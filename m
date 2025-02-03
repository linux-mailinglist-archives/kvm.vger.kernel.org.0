Return-Path: <kvm+bounces-37122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 103B7A25680
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7771F7A479C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EB7201021;
	Mon,  3 Feb 2025 09:57:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742DE200126
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738576643; cv=none; b=JaAWOcWcQL2SeNrvKT1e+s0I26SJT0ioQ2qRINC/C9yfIsRZ+SDdbLxPelvvVgKsbjzATm2mt3PdC2bP3gfsTu9QjUl6WpYPXGoe1XSTNsiayk7hIbwH5PBI3ese1mASlCDtkoFLaDz1u3OjQ0sXTn/BOsEBX2C3r9jtaWP2hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738576643; c=relaxed/simple;
	bh=7QPCZVm8uZsigVkzr7sQwFV5eYHQpG7HcOxYgpl/Db0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tRP+kH/M2s8lT3fJv20E8uZAbtKE3UVXP3jYjOnlsbTA0Y7dpcOVb6LVa6aPBQcAwiHGBU0lglp8CyY+018iAbhDnVyX/972ZJDPwL8d8ZrLWKYS8fy+FQjiBpv5CkQMNKZxbkFg3Hd7cADVkFbcoh8Bx64lhxIqSItm/UQ0FeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9d57cff85so89650985ab.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 01:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738576640; x=1739181440;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pohBAsk+VfWTs0qwofD5+fE+WCyA8aDvg+C1Zl4hi/g=;
        b=R9HvPL8oulxti1K38nHyUfYkoPTEPOypXay97edYxhuiAvTi3UylSVWD6U8C9zTYuZ
         iBrSJ01gGrNwjvf3oELg27QJm9oEYFfvtUJ/Fid5lGODI00yzfUSjDICrifV2AWJ0URl
         Mt1NITHpI4/dq217xDwAP4cqBpO3CfG/aZI9r0opf97oOMNNcCoGojeADT1hQRJdoI+H
         0lt895xcpA2KRUIqcGIXIVT7MQe79hR4+/U4hIueEpl/gs73ndQh5psznRWMCspxVYNk
         OOp6GB7lZNfB5aYI0PL2AkMiG+XaT+AlpANv0sBCjekERwOth0L8mKk7WLL36VfDVJL4
         KIlg==
X-Forwarded-Encrypted: i=1; AJvYcCXmvtA/TYiGWgcHaZuj0md1yjykWBH92wV67l36zBiIpwoTdAGmTwcWwVRwW/gwkNQsfd8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLR5ECFzcu0kZ344OSJyUeUkFSued5SlZ7jHvsIgnwt0xUxiAs
	/oUi+VTb58O0cMzkGe7BRnLhtnMWLRPqWT6/u/BYGHStszqIL4gZbc2NyHsWMYldJDeMW5nkykG
	pVG/dmaL0hHf/RptY+b3l9kTIDzASJkL/6BFM3ezrloQgKndXRSOjqhE=
X-Google-Smtp-Source: AGHT+IFGjYu0PzVJbiJYn3l/HayCoiP6DVH3R1koA8FiVlkJ2t+WwOWB1EI1T6J/gLhOprq9VymUxq1o7Y8s1FMo+cPDcqtpgtyg
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2483:b0:3cf:c8bf:3b8a with SMTP id
 e9e14a558f8ab-3cffe3e5c91mr205309775ab.7.1738576640656; Mon, 03 Feb 2025
 01:57:20 -0800 (PST)
Date: Mon, 03 Feb 2025 01:57:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a09300.050a0220.d7c5a.008b.GAE@google.com>
Subject: [syzbot] [net?] general protection fault in add_wait_queue
From: syzbot <syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mhal@rbox.co, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com, 
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2933b2befe2 Merge tag 'net-6.14-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16f676b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=9d55b199192a4be7d02c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13300b24580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12418518580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c7667ae12603/disk-c2933b2b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/944ca63002c1/vmlinux-c2933b2b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/30748115bf0b/bzImage-c2933b2b.xz

The issue was bisected to:

commit fcdd2242c0231032fc84e1404315c245ae56322a
Author: Michal Luczaj <mhal@rbox.co>
Date:   Tue Jan 28 13:15:27 2025 +0000

    vsock: Keep the binding until socket destruction

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148f5ddf980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=168f5ddf980000
console output: https://syzkaller.appspot.com/x/log.txt?x=128f5ddf980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com
Fixes: fcdd2242c023 ("vsock: Keep the binding until socket destruction")

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 5845 Comm: syz-executor865 Not tainted 6.13.0-syzkaller-09685-gc2933b2befe2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5091
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 2b 98 80 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 88 26 8b 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000407f870 EFLAGS: 00010006
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000018
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff203680f R12: ffff888035760000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000018
FS:  000055555c9b3380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000044c CR3: 00000000352c0000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
 add_wait_queue+0x46/0x180 kernel/sched/wait.c:22
 virtio_transport_wait_close net/vmw_vsock/virtio_transport_common.c:1200 [inline]
 virtio_transport_close net/vmw_vsock/virtio_transport_common.c:1282 [inline]
 virtio_transport_release+0x4c4/0xce0 net/vmw_vsock/virtio_transport_common.c:1302
 __vsock_release+0xf1/0x4f0 net/vmw_vsock/af_vsock.c:830
 vsock_release+0x97/0x100 net/vmw_vsock/af_vsock.c:941
 __sock_release net/socket.c:642 [inline]
 sock_close+0xbc/0x240 net/socket.c:1393
 __fput+0x3e9/0x9f0 fs/file_table.c:450
 __do_sys_close fs/open.c:1579 [inline]
 __se_sys_close fs/open.c:1564 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1564
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2406c95400
Code: ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 80 3d 81 8c 07 00 00 74 17 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c
RSP: 002b:00007ffe044a2b28 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f2406c95400
RDX: 000000000000000d RSI: 0000000000000001 RDI: 0000000000000004
RBP: 00000000000f4240 R08: 0000000000000008 R09: 000000005c9b4610
R10: 0000000020000180 R11: 0000000000000202 R12: 000000000000e3ae
R13: 00007ffe044a2b34 R14: 00007ffe044a2b50 R15: 00007ffe044a2b40
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5091
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 2b 98 80 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 88 26 8b 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000407f870 EFLAGS: 00010006
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000018
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff203680f R12: ffff888035760000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000018
FS:  000055555c9b3380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000044c CR3: 00000000352c0000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 f8 16 	xor    %al,0x16f8850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d 2b 98 80 0e 00 	cmpl   $0x0,0xe80982b(%rip)        # 0xe809840
  15:	0f 84 c8 13 00 00    	je     0x13e3
  1b:	89 54 24 60          	mov    %edx,0x60(%rsp)
  1f:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 88 26 8b 00       	call   0x8b26c0
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

