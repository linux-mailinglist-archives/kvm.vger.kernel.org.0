Return-Path: <kvm+bounces-18167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F328CFA03
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5E2A1C20E27
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A35F282FE;
	Mon, 27 May 2024 07:24:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362A224D6
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716794671; cv=none; b=Yonxn2ClJfUIYwyhP7i0miVsI8GB4dBt/0BPXCL4OCFUjJJYErl11s/7XROLYzgzxmBRlmf2pZGKNErx0/ufIcuLTTNVqBBgerZKl3VL4tUmQyXvUT1YvHD/+jgQgae2MYvx2wAcx+PMJTgs7zrOZ0pW5zvb8/mof+oAStxkj+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716794671; c=relaxed/simple;
	bh=lw8KkLJUAe8zbtM6WWDBVTxtolCUjkKLl/X460mypOo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aH7r7eQsUiVo2mchONSvqWba8F78IFYwb/QEYD+K/J/KFq7iGtZSgbLCAhUFBIXTryT/WmnrbeQ/EtoBnLA8zzaDMiJfnqU0ou5djip7efVnWhtjFIQKHkxXeWOb8ad0adT+haqiGNFlPNVlj9S9gb3vIrLHmh5isTH7R55kjMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7e8dc9db8deso185155539f.1
        for <kvm@vger.kernel.org>; Mon, 27 May 2024 00:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716794669; x=1717399469;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lmfp46OXIt859MZHaU6A+z3GBHDbs4UP5Lz/+uglPoE=;
        b=tHxfthciDUzDEJREzhAVxijrnH4E0PSescQclchNN8JohTe7fb94+VmZ6QLHVpXRF0
         R1lrYQaYC5vV4YtkRpRIXSIm0Up27F4Sv476HCgy1PQMWURZ3uB61E3ikkoZygKaDVIl
         d28RQxZSv4HVjIhi2Fzw/jWKBxD9uzJhhV8Lzq+XhoV061psUbMx4Zltbe6YgEeT58hl
         /SwMQxQG+FmorfSqv400Mov7VjCCdFuXR+cXFsQVhRWAs74rwWTtR93t+YPlC48UME6/
         pPcPsWvvYWgogqgW/yjO4b02cI7ttAZvTP7c5rQBoqPVxsuVwfpfw5T/m2rhzbhqE+pD
         9obw==
X-Forwarded-Encrypted: i=1; AJvYcCUk+YmXec+HPnUnu0aIC37cQq5AEJ270xqwGc3KB1/qvmCoLkf+ZnNvStr4OY7uxYJzD1Xx5Y/FDuUoT60yKHmA08PJ
X-Gm-Message-State: AOJu0YzrQVcYpNByLU8+E2B0q8BLrs3p4XxcUFq+CaK/mi/jm8UytXZF
	I+r81ByXl+mXQOkRsexyhVxMJck22CWZD1028Qw37PpGEWiQlJ/73v+XLoJyc3zBPuCHD/eG9P5
	PTrXuUPkDyaNQV4EHWZjPZOYHBbFtidzFDOVYBxpZAV2y2XoEy2bBSa0=
X-Google-Smtp-Source: AGHT+IF0D+SBEAfyHXY+f4w4IB0XaBM88nfJbwNbHgX23hmzt65xUjYOd40kaT7dEqVkbrz5bV7Vw8VDxkExQNd9oKktnsBAmjgW
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d83:b0:36c:6080:753d with SMTP id
 e9e14a558f8ab-37347c2e5a9mr5061585ab.1.1716794669425; Mon, 27 May 2024
 00:24:29 -0700 (PDT)
Date: Mon, 27 May 2024 00:24:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006c777106196a68c1@google.com>
Subject: [syzbot] [kvm?] KASAN: wild-memory-access Read in __timer_delete_sync
From: syzbot <syzbot+d74d6f2cf5cb486c708f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1613e604df0c Linux 6.10-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10672b3f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=733cc7a95171d8e7
dashboard link: https://syzkaller.appspot.com/bug?extid=d74d6f2cf5cb486c708f
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1613e604.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdfe02141e4c/vmlinux-1613e604.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e655c2629f1/bzImage-1613e604.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d74d6f2cf5cb486c708f@syzkaller.appspotmail.com

bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
==================================================================
BUG: KASAN: wild-memory-access in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: wild-memory-access in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: wild-memory-access in __lock_acquire+0xeba/0x3b30 kernel/locking/lockdep.c:5107
Read of size 8 at addr 1fffffff8763e898 by task syz-executor.0/11675

CPU: 0 PID: 11675 Comm: syz-executor.0 Not tainted 6.10.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 kasan_report+0xd9/0x110 mm/kasan/report.c:601
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 __lock_acquire+0xeba/0x3b30 kernel/locking/lockdep.c:5107
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __timer_delete_sync+0x152/0x1b0 kernel/time/timer.c:1647
 del_timer_sync include/linux/timer.h:185 [inline]
 cleanup_srcu_struct+0x124/0x520 kernel/rcu/srcutree.c:659
 bch2_fs_btree_iter_exit+0x46e/0x630 fs/bcachefs/btree_iter.c:3410
 __bch2_fs_free fs/bcachefs/super.c:556 [inline]
 bch2_fs_release+0x11b/0x810 fs/bcachefs/super.c:603
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
RIP: 0023:0xf731b579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ffc4e538 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
RAX: 0000000000000000 RBX: 00000000ffc4e5e0 RCX: 0000000000000009
RDX: 00000000f7471ff4 RSI: 00000000f73c2361 RDI: 00000000ffc4f684
RBP: 00000000ffc4e5e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
==================================================================
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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

