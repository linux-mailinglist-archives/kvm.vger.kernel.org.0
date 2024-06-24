Return-Path: <kvm+bounces-20419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40947915A50
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E37AB282AD1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9060A1A2C0D;
	Mon, 24 Jun 2024 23:21:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8467B1A0B03
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 23:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271294; cv=none; b=QNzdzU+9kMtwWrIiWKA8cUMVF6znimDwNf1WCnmXFHdh3FQdZFd5gxOi+etBtIoFwEIsbJ0T9cjBiBhGg9B7Hm9NJJNQBXOnQjXuk8dKiX+Q5Lzef81ZKw98jugvGfVBGWRWejs48MEy6LZUwmJOXHekhCj2WMC8rRfwt/A4OZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271294; c=relaxed/simple;
	bh=jujgC8Gc8P6ID90YBX0LNLxKcoNkikqg7Z+PuO3r7Ew=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=h0LT9e3gZ8YY+hlU1KW8I/jzRMb15RSkHd8hRoe2cypuMA33/rHP9j5LaCZiUaZ6t4ZoJUGEy9DCMjAC6EON+7ZF64NRbCSeNrPk19aopQJYDKR7SVWmeGP3Y/kIGrwOfExmW3P5Uk1uqjCngpbaLIdqzSLbkF68lT843Oz7W1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-37620c37ae8so60178915ab.2
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 16:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271291; x=1719876091;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WCR7i9SnpTLLYT/QkKabtMlEKHNeVqQdTucfDiXzGvc=;
        b=rJ+qJa3NBVhwBGNzNa4/d2RSsjIwQmWzib7JN5GZiuovOMakDo8mugk4FMZCpC0c1s
         XoemHpSKVc0CyIx/9j+J/E9lInIClm6z/VXqFdsXCVhfx3Q8ndW+mXcEXp9+usp71XOj
         Y4FS2Gg7KmuylxyE4HMm2t7KoLRhMJ1FjlWzMN7a8ZRowmDJymk3f7tHGhA5BzD9Mxw+
         +4TBe/yPK/B9vcd5HkK6nXY3LoG+Hj/H1TkwVcbpy5XHZy6BZQMBE8P4qDwgRmJWCEwI
         XVUCct8H18H0fjNrMj0cB34nJEdkzguIj7Z+lnxCgQYnQ76uCwINsT3ZeMNHk79G+Oxb
         PubA==
X-Forwarded-Encrypted: i=1; AJvYcCWB1L4qX2D/MoE7szKmwR/jE0CQY4StCL8ALHJ+nC32ymN6mv2faRMtk11yjZjcB0jrrlp6caEjNfMg6UOwMzSEjFly
X-Gm-Message-State: AOJu0Yw8Bef5VOANqgV3JByPERXR+Zdt/GlwGnJajk2CX9Y14c4Ct/rJ
	9oDqom0hb37R/zTVj1ck/alT25YSi2kyjqVFCpID/gb/mqijOl6S9sijo3dZsoFI8N0TS+6gtRK
	jcydB+UqAizpEX2LTUkZAPbDjzHiBmZqsZLBT8NOeCTVQbinPal5uwqQ=
X-Google-Smtp-Source: AGHT+IFTLZ8hH2SxsQBZ1nvip172SSUi07XnvTlIo4JsAWUumhG6MGbbpfVnaF9uDyocekgrkOfBFSosV8grD8YHpTfS6vQwJxRN
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:376:11a3:a36b with SMTP id
 e9e14a558f8ab-3763f4a93a0mr6615065ab.0.1719271291654; Mon, 24 Jun 2024
 16:21:31 -0700 (PDT)
Date: Mon, 24 Jun 2024 16:21:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ca899061bab0a49@google.com>
Subject: [syzbot] [bcachefs?] [kvm?] general protection fault in
 detach_if_pending (3)
From: syzbot <syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    626737a5791b Merge tag 'pinctrl-v6.10-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117e90d6980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53ab35b556129242
dashboard link: https://syzkaller.appspot.com/bug?extid=f4b2fbba4d8c2e290380
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-626737a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/03802640516e/vmlinux-626737a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09b1b299316b/bzImage-626737a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com

bcachefs (loop3): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop3): shutdown complete, journal seq 15
bcachefs (loop3): marking filesystem clean
bcachefs (loop3): shutdown complete
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 6009 Comm: syz-executor.3 Not tainted 6.10.0-rc5-syzkaller-00012-g626737a5791b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__hlist_del include/linux/list.h:988 [inline]
RIP: 0010:detach_timer kernel/time/timer.c:934 [inline]
RIP: 0010:detach_if_pending+0x14c/0x450 kernel/time/timer.c:953
Code: df 4c 89 ea 4c 8b 23 48 c1 ea 03 80 3c 02 00 0f 85 ea 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 6b 08 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 be 02 00 00 4d 85 e4 4d 89 65 00 74 2a e8 9c 5a
RSP: 0018:ffffc90003f0fb78 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffffe8ffad268390 RCX: ffffffff817b36ca
RDX: 0000000000000000 RSI: ffffffff817b34ee RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 000000000003d94c
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:00000000574c8400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f735bfd0 CR3: 0000000046582000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __try_to_del_timer_sync+0xc5/0x170 kernel/time/timer.c:1509
 __timer_delete_sync+0xf4/0x1b0 kernel/time/timer.c:1665
 del_timer_sync include/linux/timer.h:185 [inline]
 cleanup_srcu_struct+0x124/0x520 kernel/rcu/srcutree.c:659
 bch2_fs_btree_iter_exit+0x479/0x640 fs/bcachefs/btree_iter.c:3411
 __bch2_fs_free fs/bcachefs/super.c:556 [inline]
 bch2_fs_release+0x117/0x870 fs/bcachefs/super.c:605
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1fa/0x5b0 lib/kobject.c:737
 deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
 deactivate_super+0xde/0x100 fs/super.c:506
 cleanup_mnt+0x222/0x450 fs/namespace.c:1267
 task_work_run+0x14e/0x250 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
 __do_fast_syscall_32+0x80/0x120 arch/x86/entry/common.c:389
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf72df579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000fff0a178 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
RAX: 0000000000000000 RBX: 00000000fff0a220 RCX: 0000000000000009
RDX: 00000000f7435ff4 RSI: 00000000f7386361 RDI: 00000000fff0b2c4
RBP: 00000000fff0a220 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__hlist_del include/linux/list.h:988 [inline]
RIP: 0010:detach_timer kernel/time/timer.c:934 [inline]
RIP: 0010:detach_if_pending+0x14c/0x450 kernel/time/timer.c:953
Code: df 4c 89 ea 4c 8b 23 48 c1 ea 03 80 3c 02 00 0f 85 ea 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 6b 08 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 be 02 00 00 4d 85 e4 4d 89 65 00 74 2a e8 9c 5a
RSP: 0018:ffffc90003f0fb78 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffffe8ffad268390 RCX: ffffffff817b36ca
RDX: 0000000000000000 RSI: ffffffff817b34ee RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 000000000003d94c
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:00000000574c8400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f735bfd0 CR3: 0000000046582000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	df 4c 89 ea          	fisttps -0x16(%rcx,%rcx,4)
   4:	4c 8b 23             	mov    (%rbx),%r12
   7:	48 c1 ea 03          	shr    $0x3,%rdx
   b:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   f:	0f 85 ea 02 00 00    	jne    0x2ff
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	4c 8b 6b 08          	mov    0x8(%rbx),%r13
  23:	4c 89 ea             	mov    %r13,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 be 02 00 00    	jne    0x2f2
  34:	4d 85 e4             	test   %r12,%r12
  37:	4d 89 65 00          	mov    %r12,0x0(%r13)
  3b:	74 2a                	je     0x67
  3d:	e8                   	.byte 0xe8
  3e:	9c                   	pushf
  3f:	5a                   	pop    %rdx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

