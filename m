Return-Path: <kvm+bounces-24423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4CB9550E2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF7F1C21294
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCDB1C37BF;
	Fri, 16 Aug 2024 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2dGktiQh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3881BB6B3
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833102; cv=none; b=gLL3JvDlTc5ZWScyab0HzE0G0qP43fJVL/nhklcngWuTLwMw8lX8WbFpl72Rp5Uqu+KwjxjLLksK5tNoXjSCRJ93bdTXHKFa8b20vhn/llIqzzhfD+n2YUxtQSxktYMxTy0BL6i6fNCxGrFSklNqP4YCwHzrzN8/lzctKeKF3ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833102; c=relaxed/simple;
	bh=i0zV6lbPPWrGKxZ8cQwpB4ShIYz5hjzjpnBNmNeJRb8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dn/KA4g/gbJPpF2evxeUgDoX9sJKugHfjNiFwGq5T21JzGayoPPzoSZtu5A4y2mGuS14Qo2AuO8aMY+MKN7jpqXpGmlee9SKPoCO3lBLSTQsX3HlthnbhSYa/Yt7gQu1o/vljoHOpHySObQOm2j2Qlw4uzw9RAyzhicS/lYsd4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2dGktiQh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a267d9e7b0so2009829a12.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723833100; x=1724437900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=REutRUN9HpiUkRLy4DH4FMjh6GvS15wrUkE7wZN+0aA=;
        b=2dGktiQhvYvOW74HAQziKgWQSF5uxSKAXwc6wObgHyZI1ZUI6r4rIiA1NDu2F0KLBP
         gtPbxJjvbP46Q3KQjYrHbWoSiugPvtkdg4zu1vAbCw825PepdO16PIcXZeoeXf1iYWh6
         640ODvrtxp8fpV6Kd+GY6PwnmL//wS15zuv+T8U5ihEylx0H6akHhXpcQn4U6/6bcHBb
         JyDeD9jpzL8CL0B3C37ddKbmdX9h0DQCm6I0Y3L5MqHObPREmifA69hTrC90enSXx+zx
         RnfC06s1j3QqNZAYyXXkVk6ffuP3Q+DByo9cGJwq6DuJzrrJAM5EO/AwWc4HCoWQ+Jbn
         S9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723833100; x=1724437900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=REutRUN9HpiUkRLy4DH4FMjh6GvS15wrUkE7wZN+0aA=;
        b=vUyP74lXU0O5LRPLKkfVPKLQf2fVo0J7QVP7X38LyeqgdfiIQH749VHyw2uM4/1Fau
         rdnAzXak7UmfU9fTZ9+KaRxKMMpi7AEQa/A04eerys4CqZK5Atr9oUZjKFqdBa9etzmE
         MA7D2bPTdCUAK2gQ48unL/rH8G2hazZs84XxpMjXHhpt0WRQwiZcWsVE/yhJaK5Dmc6l
         f90UtkJuTC6W/cG1Yy9q7E+LyxxWIx7q65EligDR4uzIJZnoATLP16JIpClbahERM1Zm
         66tPf/bFYQUSMtufttWVPpdbcO56j7DM/XDSig62R2aQ8gesvI+Whwl5YY+6nCYmgCCg
         V6aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy0E/73x+YyxTtdCCargA1xh3Ry5+c67TGgzcr4bMsd6x0REIK4UYxCXdUwsfBfP8i1DU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfebfTJsCE7egSGuD6y++hVvw2hiEeF8jTTboI/tP00+rY+U5+
	bmAtom83UHWt8iu+cD7wY8XkF/R42PsNZIftnODSD7oc72Bno/6HRhcrD8fvywv0arEjNoKgadb
	a9g==
X-Google-Smtp-Source: AGHT+IFBBeZ4mwen6hWtId2WoTKWu3e1hoWuLVAB8Gq1vG68TQp5WX/jLsxLlzL7u/K/Kn+gb4wz0RDmXQY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:78b:b0:72b:5113:ec05 with SMTP id
 41be03b00d2f7-7c979bbfb25mr6548a12.5.1723833100166; Fri, 16 Aug 2024 11:31:40
 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:31:38 -0700
In-Reply-To: <0000000000006c777106196a68c1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000006c777106196a68c1@google.com>
Message-ID: <Zr-bCqSWRS3yob7V@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: wild-memory-access Read in __timer_delete_sync
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+d74d6f2cf5cb486c708f@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 27, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1613e604df0c Linux 6.10-rc1
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10672b3f180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=733cc7a95171d8e7
> dashboard link: https://syzkaller.appspot.com/bug?extid=d74d6f2cf5cb486c708f
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1613e604.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bdfe02141e4c/vmlinux-1613e604.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9e655c2629f1/bzImage-1613e604.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d74d6f2cf5cb486c708f@syzkaller.appspotmail.com
> 
> bcachefs (loop0): shutting down
> bcachefs (loop0): shutdown complete
> ==================================================================
> BUG: KASAN: wild-memory-access in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: wild-memory-access in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
> BUG: KASAN: wild-memory-access in __lock_acquire+0xeba/0x3b30 kernel/locking/lockdep.c:5107
> Read of size 8 at addr 1fffffff8763e898 by task syz-executor.0/11675
> 
> CPU: 0 PID: 11675 Comm: syz-executor.0 Not tainted 6.10.0-rc1-syzkaller #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
>  kasan_report+0xd9/0x110 mm/kasan/report.c:601
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>  __lock_acquire+0xeba/0x3b30 kernel/locking/lockdep.c:5107
>  lock_acquire kernel/locking/lockdep.c:5754 [inline]
>  lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
>  __timer_delete_sync+0x152/0x1b0 kernel/time/timer.c:1647
>  del_timer_sync include/linux/timer.h:185 [inline]
>  cleanup_srcu_struct+0x124/0x520 kernel/rcu/srcutree.c:659
>  bch2_fs_btree_iter_exit+0x46e/0x630 fs/bcachefs/btree_iter.c:3410
>  __bch2_fs_free fs/bcachefs/super.c:556 [inline]
>  bch2_fs_release+0x11b/0x810 fs/bcachefs/super.c:603
>  kobject_cleanup lib/kobject.c:689 [inline]
>  kobject_release lib/kobject.c:720 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x1fa/0x5b0 lib/kobject.c:737
>  deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
>  deactivate_super+0xde/0x100 fs/super.c:506
>  cleanup_mnt+0x222/0x450 fs/namespace.c:1267
>  task_work_run+0x14e/0x250 kernel/task_work.c:180
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
>  __do_fast_syscall_32+0x80/0x120 arch/x86/entry/common.c:389
>  do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> RIP: 0023:0xf731b579
> Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> RSP: 002b:00000000ffc4e538 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
> RAX: 0000000000000000 RBX: 00000000ffc4e5e0 RCX: 0000000000000009
> RDX: 00000000f7471ff4 RSI: 00000000f73c2361 RDI: 00000000ffc4f684
> RBP: 00000000ffc4e5e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> ==================================================================

Re-labeling this to bcachefs, as only one of the splats directly involves KVM,
there were past failures in KVM that were likely caused by bcachesfs, and in the
one splat that hit KVM, squashfs complained about possible data corruption between
bcachefs unmounting and KVM dying (see below).

#syz set subsystems: bcachefs


[  212.712001][ T5229] bcachefs (loop2): shutting down
[  212.714390][ T5229] bcachefs (loop2): going read-only
[  212.716673][ T5229] bcachefs (loop2): finished waiting for writes to stop
[  212.724653][ T5229] bcachefs (loop2): flushing journal and stopping allocators, journal seq 12
[  212.740723][ T5229] bcachefs (loop2): flushing journal and stopping allocators complete, journal seq 14
[  212.746964][ T5229] bcachefs (loop2): shutdown complete, journal seq 15
[  212.750429][ T5229] bcachefs (loop2): marking filesystem clean

...

[  212.875663][ T9117] loop1: detected capacity change from 0 to 8
[  212.899637][ T9117] SQUASHFS error: zlib decompression failed, data probably corrupt
[  212.903051][ T9117] SQUASHFS error: Failed to read block 0x4e8: -5
[  213.053013][ T9115] ==================================================================
[  213.056197][ T9115] BUG: KASAN: wild-memory-access in __lock_acquire+0xeba/0x3b30
[  213.059059][ T9115] Read of size 8 at addr 1fffffff905a0b18 by task syz-executor.1/9115
[  213.061962][ T9115] 
[  213.062917][ T9115] CPU: 2 PID: 9115 Comm: syz-executor.1 Not tainted 6.10.0-rc5-syzkaller-00012-g626737a5791b #0
[  213.068867][ T9115] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[  213.072893][ T9115] Call Trace:
[  213.074033][ T9115]  <TASK>
[  213.075190][ T9115]  dump_stack_lvl+0x116/0x1f0
[  213.076947][ T9115]  kasan_report+0xd9/0x110
[  213.082231][ T9115]  kasan_check_range+0xef/0x1a0
[  213.083875][ T9115]  __lock_acquire+0xeba/0x3b30
[  213.089050][ T9115]  lock_acquire+0x1b1/0x560
[  213.096435][ T9115]  __timer_delete_sync+0x152/0x1b0
[  213.100058][ T9115]  cleanup_srcu_struct+0x124/0x520
[  213.102146][ T9115]  kvm_put_kvm+0x8d3/0xb80
[  213.105999][ T9115]  kvm_vm_release+0x42/0x60
[  213.107840][ T9115]  __fput+0x408/0xbb0
[  213.109579][ T9115]  __fput_sync+0x47/0x50
[  213.111404][ T9115]  __ia32_sys_close+0x86/0x100
[  213.113458][ T9115]  __do_fast_syscall_32+0x73/0x120
[  213.115472][ T9115]  do_fast_syscall_32+0x32/0x80
[  213.117549][ T9115]  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
[  213.146118][ T9115]  </TASK>
[  213.147157][ T9115] ==================================================================

