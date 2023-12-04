const std = @import("std");

pub fn main() !void {
    try part1();
    try part2();
}

fn isDigit(char: u8) bool {
    return char >= '0' and char <= '9';
}

fn part1() !void {
    var file = @embedFile("./day1.txt");
    var lines = std.mem.split(u8, file, "\n");
    var sum: u32 = 0;
    while (lines.next()) |line| {
        var firstDigit: u32 = 0;
        var secondDigit: u32 = 0;
        for (line) |char| {
            if (isDigit(char)) {
                const charSlice = [_]u8{char};
                var digit = try std.fmt.parseInt(u8, &charSlice, 10);
                if (firstDigit == 0 and digit != 0) {
                    firstDigit = digit;
                    secondDigit = firstDigit;
                } else {
                    secondDigit = digit;
                }
            }
        }
        if (firstDigit > -1 and secondDigit > -1) {
            sum += firstDigit * 10 + secondDigit;
        }
    }
    std.debug.print("part 1 result: {d}\n", .{sum});
}

fn isNumber(char: u8, line: []const u8, start: usize) bool {
    return switch (char) {
        'o' => checkNumber("one", line, start, 3),
        't' => checkNumber("two", line, start, 3) or checkNumber("three", line, start, 5),
        'f' => checkNumber("four", line, start, 4) or checkNumber("five", line, start, 4),
        's' => checkNumber("six", line, start, 3) or checkNumber("seven", line, start, 5),
        'e' => checkNumber("eight", line, start, 5),
        'n' => checkNumber("nine", line, start, 4),
        else => isDigit(char),
    };
}

fn checkNumber(str: []const u8, line: []const u8, start: usize, len: usize) bool {
    var minLen = @min(line.len, len + start);
    return std.mem.eql(u8, str, line[start..minLen]);
}

fn convertNumber(char: u8, line: []const u8, start: usize) !u32 {
    const charSlice = [_]u8{char};
    return switch (char) {
        'o' => 1,
        't' => if (checkNumber("two", line, start, 3)) 2 else 3,
        'f' => if (checkNumber("four", line, start, 4)) 4 else 5,
        's' => if (checkNumber("six", line, start, 3)) 6 else 7,
        'e' => 8,
        'n' => 9,
        else => try std.fmt.parseInt(u8, &charSlice, 10),
    };
}

fn part2() !void {
    var file = @embedFile("./day1.txt");
    var lines = std.mem.split(u8, file, "\n");
    var sum: u32 = 0;
    while (lines.next()) |line| {
        var firstDigit: u32 = 0;
        var secondDigit: u32 = 0;
        for (0..line.len) |i| {
            var char = line[i];
            if (isNumber(char, line, i)) {
                var digit = try convertNumber(char, line, i);
                if (firstDigit == 0 and digit != 0) {
                    firstDigit = digit;
                    secondDigit = firstDigit;
                } else {
                    secondDigit = digit;
                }
            }
        }
        if (firstDigit > -1 and secondDigit > -1) {
            sum += firstDigit * 10 + secondDigit;
        }
    }
    std.debug.print("part 2 result: {d}\n", .{sum});
}
