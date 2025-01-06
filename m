Return-Path: <kvm+bounces-34619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C7AA02EA8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 18:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 768551886D5B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 17:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36C81DE897;
	Mon,  6 Jan 2025 17:13:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096431DB360
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 17:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183609; cv=none; b=dmP+V9yCMocT5hGWl4VR7S2IcIL2te60Dl6X9RMQb8LyfKZpqxFsidPwOYTJuIozq3TDjluuD0TR7CyxS/6O5Gnl2s3vYkuB1UIDStH2B+vvJ7VLhcoUuiG7ha/rQYkkDmOqb3z50m03WNwsqKYDkCh/ITmz/IG5y5bP3sGtbkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183609; c=relaxed/simple;
	bh=EHvAl+gf7weNtYBImHJjLL8Er6vMt/yLmZLEKJv6Acs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=X7hWX2tLQ9kv8nhH+Hab8lUc8IaTA8glPr5Cre+pLymVOeKbDghASFOl2TZX6HIlMKVKc6+QJMxIl8utYvA1m4YLfrouRmhE0rsKIQinr3MXDrsuGjkiPKKWtqusy+mxS9GY6d/q7pil1X1c/CoXwl4tyE0lRclrTE/U4yNXUbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a81754abb7so264237055ab.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 09:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736183606; x=1736788406;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2SOvMQ3Ov2gNrhaCuCGY0DlpYhSNX2PNhjLldp3iAI=;
        b=mPRkTZbmLiYk/Fjr6O0lI2OqNn+hayf5PPQAWgVplGWPWjO/hHbH3IeIaq/UI86+Vg
         voIcMgJ4sXS0QCroAHemzesLTHdzQ5d/bpxOv56rtcTW3WLBN+edoOPgkEu0m41qKACE
         WcxqgF3ENxcUVET2+VUbbJNgLD/WRMYdKX0l6V3Dwe007DeRW6nUjEdXgu0sci8CQxDH
         TBk3aDEQaEEbUCJgTC+kYYH5X1+Cyokt0x03hs5ze2u+pXDjxoNhUhAx/ICSPvf+rAcF
         DXrWeR8FnHMomUwHzgyrnoA9dGNfn5wAcyFK5rY+Y7Q1xIVImBDSKlUTFR/HIAuQApGb
         nDhw==
X-Forwarded-Encrypted: i=1; AJvYcCV1DPAtaAKHHW72Xjvbk3Pw8LQY0QXSiEr1gDgsBb3H9g51TuFiSK+nCyOVCGMjfTdtxFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwqU8xZEznisBBQdSfhcTlJk1qJUcUPGZPZuZsbhEwCVbuLJY9
	2lZOa04+xRM4Nr/1zzGodwFUjBx4zG+FQmtyOJq1tbsVdWWeLgARJ+x6s6oTbxBKrbcu/sdgR0w
	BUfhNZV1Piz24Brj9xzh9yU2zOeffi4kH9jp0vh/qSHzFYXuvmGdn4wM=
X-Google-Smtp-Source: AGHT+IGpeXwUZJAotwPn9uz1x/Gv8qVCweGxjkJ+brPfDb6gdgx3JAkhKMloY1oy6iPVq28ipJyL2gk44P14KlNoCnaRNt8FVnY1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1889:b0:3a7:e286:a565 with SMTP id
 e9e14a558f8ab-3c2d5a28056mr463920485ab.23.1736183606122; Mon, 06 Jan 2025
 09:13:26 -0800 (PST)
Date: Mon, 06 Jan 2025 09:13:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677c0f36.050a0220.3b3668.0014.GAE@google.com>
Subject: [syzbot] [kvm?] possible deadlock in kvm_arch_pm_notifier
From: syzbot <syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0bc21e701a6f MAINTAINERS: Remove Olof from SoC maintainers
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163abd0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86dd15278dbfe19f
dashboard link: https://syzkaller.appspot.com/bug?extid=352e553a86e0d75f5120
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0bc21e70.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7552d06d3231/vmlinux-0bc21e70.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0d1494ecdf2f/bzImage-0bc21e70.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc5-syzkaller-00012-g0bc21e701a6f #0 Not tainted
------------------------------------------------------
syz.8.2149/14842 is trying to acquire lock:
ffffc90006bccb58 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_suspend_notifier arch/x86/kvm/x86.c:6919 [inline]
ffffc90006bccb58 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_pm_notifier+0xf5/0x2b0 arch/x86/kvm/x86.c:6941

but task is already holding lock:
ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust kernel/notifier.c:344 [inline]
ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust+0xa9/0x170 kernel/notifier.c:333

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 ((pm_chain_head).rwsem){++++}-{4:4}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       __blocking_notifier_chain_register kernel/notifier.c:263 [inline]
       blocking_notifier_chain_register+0x69/0xd0 kernel/notifier.c:282
       hci_register_suspend_notifier+0xcb/0x100 net/bluetooth/hci_core.c:2769
       hci_register_dev+0x616/0xc60 net/bluetooth/hci_core.c:2652
       hci_uart_register_dev drivers/bluetooth/hci_ldisc.c:686 [inline]
       hci_uart_set_proto drivers/bluetooth/hci_ldisc.c:710 [inline]
       hci_uart_tty_ioctl+0x7d0/0xc10 drivers/bluetooth/hci_ldisc.c:762
       tty_compat_ioctl+0x381/0x4d0 drivers/tty/tty_io.c:2991
       __do_compat_sys_ioctl+0x1cb/0x2c0 fs/ioctl.c:1004
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #3 (&tty->ldisc_sem){++++}-{0:0}:
       __ldsem_down_read_nested+0xbe/0x920 drivers/tty/tty_ldsem.c:300
       tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
       tty_poll+0x94/0x1d0 drivers/tty/tty_io.c:2204
       vfs_poll include/linux/poll.h:84 [inline]
       io_file_supports_nowait io_uring/rw.c:43 [inline]
       io_file_supports_nowait+0x200/0x290 io_uring/rw.c:34
       __io_read+0xbd2/0x1190 io_uring/rw.c:855
       io_read+0x1e/0x70 io_uring/rw.c:947
       io_issue_sqe+0x175/0x1360 io_uring/io_uring.c:1740
       io_queue_sqe io_uring/io_uring.c:1950 [inline]
       io_submit_sqe io_uring/io_uring.c:2205 [inline]
       io_submit_sqes+0x951/0x25f0 io_uring/io_uring.c:2322
       __do_sys_io_uring_enter+0xd43/0x1620 io_uring/io_uring.c:3395
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #2 (&ctx->uring_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       io_handle_tw_list+0x27c/0x540 io_uring/io_uring.c:1054
       tctx_task_work_run+0xac/0x390 io_uring/io_uring.c:1121
       tctx_task_work+0x7b/0xd0 io_uring/io_uring.c:1139
       task_work_run+0x14e/0x250 kernel/task_work.c:239
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       xfer_to_guest_mode_work kernel/entry/kvm.c:20 [inline]
       xfer_to_guest_mode_handle_work+0xbe/0xf0 kernel/entry/kvm.c:47
       vcpu_run+0x1393/0x4c00 arch/x86/kvm/x86.c:11267
       kvm_arch_vcpu_ioctl_run+0x44a/0x1740 arch/x86/kvm/x86.c:11560
       kvm_vcpu_ioctl+0x6ce/0x1520 virt/kvm/kvm_main.c:4340
       kvm_vcpu_compat_ioctl+0x210/0x3f0 virt/kvm/kvm_main.c:4555
       __do_compat_sys_ioctl+0x1cb/0x2c0 fs/ioctl.c:1004
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #1 (&vcpu->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       kvm_vm_ioctl_create_vcpu virt/kvm/kvm_main.c:4121 [inline]
       kvm_vm_ioctl+0x1043/0x3df0 virt/kvm/kvm_main.c:5019
       kvm_vm_compat_ioctl+0x399/0x440 virt/kvm/kvm_main.c:5321
       __do_compat_sys_ioctl+0x1cb/0x2c0 fs/ioctl.c:1004
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #0 (&kvm->lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       kvm_arch_suspend_notifier arch/x86/kvm/x86.c:6919 [inline]
       kvm_arch_pm_notifier+0xf5/0x2b0 arch/x86/kvm/x86.c:6941
       notifier_call_chain+0xb7/0x410 kernel/notifier.c:85
       notifier_call_chain_robust kernel/notifier.c:120 [inline]
       blocking_notifier_call_chain_robust kernel/notifier.c:345 [inline]
       blocking_notifier_call_chain_robust+0xc9/0x170 kernel/notifier.c:333
       pm_notifier_call_chain_robust+0x27/0x60 kernel/power/main.c:102
       snapshot_open+0x189/0x2b0 kernel/power/user.c:77
       misc_open+0x35a/0x420 drivers/char/misc.c:165
       chrdev_open+0x237/0x6a0 fs/char_dev.c:414
       do_dentry_open+0xf59/0x1ea0 fs/open.c:945
       vfs_open+0x82/0x3f0 fs/open.c:1075
       do_open fs/namei.c:3828 [inline]
       path_openat+0x1e6a/0x2d60 fs/namei.c:3987
       do_filp_open+0x20c/0x470 fs/namei.c:4014
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_compat_sys_openat fs/open.c:1479 [inline]
       __se_compat_sys_openat fs/open.c:1477 [inline]
       __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1477
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

other info that might help us debug this:

Chain exists of:
  &kvm->lock --> &tty->ldisc_sem --> (pm_chain_head).rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock((pm_chain_head).rwsem);
                               lock(&tty->ldisc_sem);
                               lock((pm_chain_head).rwsem);
  lock(&kvm->lock);

 *** DEADLOCK ***

3 locks held by syz.8.2149/14842:
 #0: ffffffff8eaa1cc8 (misc_mtx){+.+.}-{4:4}, at: misc_open+0x63/0x420 drivers/char/misc.c:129
 #1: ffffffff8dc80d08 (system_transition_mutex){+.+.}-{4:4}, at: lock_system_sleep+0x87/0xa0 kernel/power/main.c:56
 #2: ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust kernel/notifier.c:344 [inline]
 #2: ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust+0xa9/0x170 kernel/notifier.c:333

stack backtrace:
CPU: 0 UID: 0 PID: 14842 Comm: syz.8.2149 Not tainted 6.13.0-rc5-syzkaller-00012-g0bc21e701a6f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x41c/0x610 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
 kvm_arch_suspend_notifier arch/x86/kvm/x86.c:6919 [inline]
 kvm_arch_pm_notifier+0xf5/0x2b0 arch/x86/kvm/x86.c:6941
 notifier_call_chain+0xb7/0x410 kernel/notifier.c:85
 notifier_call_chain_robust kernel/notifier.c:120 [inline]
 blocking_notifier_call_chain_robust kernel/notifier.c:345 [inline]
 blocking_notifier_call_chain_robust+0xc9/0x170 kernel/notifier.c:333
 pm_notifier_call_chain_robust+0x27/0x60 kernel/power/main.c:102
 snapshot_open+0x189/0x2b0 kernel/power/user.c:77
 misc_open+0x35a/0x420 drivers/char/misc.c:165
 chrdev_open+0x237/0x6a0 fs/char_dev.c:414
 do_dentry_open+0xf59/0x1ea0 fs/open.c:945
 vfs_open+0x82/0x3f0 fs/open.c:1075
 do_open fs/namei.c:3828 [inline]
 path_openat+0x1e6a/0x2d60 fs/namei.c:3987
 do_filp_open+0x20c/0x470 fs/namei.c:4014
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_compat_sys_openat fs/open.c:1479 [inline]
 __se_compat_sys_openat fs/open.c:1477 [inline]
 __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1477
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf715e579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f512f55c EFLAGS: 00000296 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000000
RDX: 0000000000040000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
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

