Return-Path: <kvm+bounces-64394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B7FE9C81130
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7BFED347296
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 14:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF25280CD2;
	Mon, 24 Nov 2025 14:40:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71282773F9
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763995235; cv=none; b=HHyjecnnqjmSDvZLi0GuKTcCRMiIaUMFSUSI1lErBndz/N/c1L0n/G6mImjA0ZtbAlM/NzerbvGsTdYjE8ea1aqTShai1hhvbBfiZa49Z/FN/yY86sfXqV/I0n/feNspCordv3iBVJ99uw4SUW+kf1/32nCw8pFXRSxgIG9imIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763995235; c=relaxed/simple;
	bh=WtxjRib8fRyg/a0M3F+nOpaMeaww/wYt2QRfxy4DBXI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BScjN4Rrde/86t1UjAk0589lENuAXWdB/LCFg63XDnZfavNrRYx2XOiWAHmswW6ds+FG2BkDXACV13mCjS/4rsvNIslh8tjm+1yqa/7RxcRxOiham6IhLPsykLcLzO8jG0TKu+ikno5yLAKVeE88XZ8ypaJ9sPBX4satRpT6Zkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43322fcfae7so42627245ab.1
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:40:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763995233; x=1764600033;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UFXCAocyaQJYOXiqP6gOl5CvRLfZoqSdu4vxmRyV5B4=;
        b=hJ7GQLGxwEgn3oO70Nj7jp1lcoE7fMoQ7+uAHSuLWM+nEf560CAwFuTwJBFz4EijGt
         QPNLc9/XrVmsM/zIpLuw2svCfK9vsrmiPPZhF3PCe+AEslNUdqW84tx8bf78Pi3ECf7E
         k1YWSNX7vg7qzl0fxmjO3N/AAHHTl5GWMF7KM9qVnMrTA5wrCeTQzBgrVZjt122yy76+
         zeD+IamS4bCCq2gSdpLJpdrKnABb0FD5qRYvLgIA7m+WNZTNZF2fYnp/jDTjvauEs+bK
         +IZhIPz7tK+p35eJnq76qr6NLKXr4CqFQVyULf93NBX3QFDEHMl0C76qQdB9rl8uZ5M3
         7Mnw==
X-Forwarded-Encrypted: i=1; AJvYcCX20Ta17EEixmAF6Ie83RDdgW5C9CSvhwmkoQr4BTeQ2RFj6uwnMu5g1ebBHLEwrQgMwu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyfwL0wDNbrC1AhF/w5EyZ7yZ8H07g/m2gE1wOYO/+u1KUCibr
	fGz1NejlTWbRh19IS8jmz8juZARWbht6SRjryWWZ5LzVO3y4jYybPNFVq7AFibsx351sD+XXxhJ
	WhvmISZPw4iarT8xcrPq/l6lc9Hh2cY6+SxIe417DErVXie/+rYUVt5uPbIE=
X-Google-Smtp-Source: AGHT+IG+FIgamX9chgH7c3HkxxSIsPbdchq0UJicuLBINKbqg/JgqmTbA/vPn0sBnkCZ7P1fuJC1YLCB3okPFeRLJxMfIT9PthTf
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:348e:b0:433:7673:1d with SMTP id
 e9e14a558f8ab-435b8e9acb8mr109337345ab.31.1763995232398; Mon, 24 Nov 2025
 06:40:32 -0800 (PST)
Date: Mon, 24 Nov 2025 06:40:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69246e60.a70a0220.d98e3.008e.GAE@google.com>
Subject: [syzbot] [kvm-x86?] WARNING in x86_emulate_insn (2)
From: syzbot <syzbot+fa52a184ebce1b30ad49@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d724c6f85e80 Add linux-next specific files for 20251121
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11513612580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=763fb984aa266726
dashboard link: https://syzkaller.appspot.com/bug?extid=fa52a184ebce1b30ad49
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165638b4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c00e58580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b2f349c65e3c/disk-d724c6f8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aba40ae987ce/vmlinux-d724c6f8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b98fbfe576f/bzImage-d724c6f8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa52a184ebce1b30ad49@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: arch/x86/kvm/emulate.c:5560 at x86_emulate_insn+0x2909/0x41a0 arch/x86/kvm/emulate.c:5560, CPU#1: syz.1.2382/16268
Modules linked in:
CPU: 1 UID: 0 PID: 16268 Comm: syz.1.2382 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:x86_emulate_insn+0x2909/0x41a0 arch/x86/kvm/emulate.c:5560
Code: 36 31 ff 44 89 f6 e8 66 99 77 00 45 85 f6 0f 84 05 02 00 00 e8 18 95 77 00 41 bf 01 00 00 00 e9 ef e0 ff ff e8 08 95 77 00 90 <0f> 0b 90 48 8b 44 24 50 42 80 3c 20 00 48 8b 5c 24 48 74 08 48 89
RSP: 0018:ffffc9000d6ff6c0 EFLAGS: 00010293
RAX: ffffffff814a8468 RBX: 000304000010220a RCX: ffff88807d930000
RDX: 0000000000000000 RSI: 00000000000000ff RDI: 000000000000001f
RBP: ffffc9000d6ff7d0 R08: ffff88807d930000 R09: 0000000000000002
R10: 0000000000000006 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff92001adfee8 R14: 00000000000000ff R15: ffff888060266780
FS:  00007f90f1e156c0(0000) GS:ffff888125b6f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000745ec000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 x86_emulate_instruction+0xea7/0x20b0 arch/x86/kvm/x86.c:9521
 kvm_arch_vcpu_ioctl_run+0x1404/0x1cd0 arch/x86/kvm/x86.c:11960
 kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4477
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f90f0f8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90f1e15038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f90f11e6090 RCX: 00007f90f0f8f749
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f90f1013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f90f11e6128 R14: 00007f90f11e6090 R15: 00007ffc7b4d1758
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

