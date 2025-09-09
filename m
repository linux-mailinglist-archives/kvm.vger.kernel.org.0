Return-Path: <kvm+bounces-57147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9884B50811
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FC663B299E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86D7259C94;
	Tue,  9 Sep 2025 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1/Fz8iK"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7EF221F15
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 21:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453000; cv=none; b=Z6XzJk+Qgxp4Lt9Hl8LYjnD68eV6YgWc90mtWRiG6g9ue44MkfPKgokO9EaC3eNXrcPVZi1CmW1FrmfgONq7ohl4b6SwROiEiwjB6/WJEGoIseA+bdVTz8Qy4hGP6jha8EqEKHMpkoxe9Zu03uu70wZaJvcaYwGx/H7qU2Gx830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453000; c=relaxed/simple;
	bh=jz//N8EbGK5Q3g2ky2XCERXGpHb1mXzcmFeSIhpTVXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViE9SWc8k2p4vj2BQkDQPamz9AoxEgUJnAQp4Ri2h82WRGp1SuitoY7hMHclH4MEj4BKitamqECiIMkci6giJJtS6TiWTM+T3GxMfQkQlnt2Fk3dm9rmmF4jGmNZMlTj8PqHgvzndobHoBXK6ZW8SD4qWKxJVb/HA1hqTYsCVmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1/Fz8iK; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Sep 2025 14:23:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757452995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+9f45GM4pXzPuGA6R17FODe6k4Z6hXoC5UsvXOKaHM=;
	b=v1/Fz8iKRvrOPlvbksOV54C9bEO5rTj+ATc1KRPFjEPpmGmqqW4okyvW/r1uPzSXDOUFMC
	GPj8RNhWAXbktpXeYNQBoLbckry/gE72vo7eLAHY4kIYu0ZT63CzHBee+Xe21TyblZzbsJ
	AlqRmK21IIcRPXG7X9P0Q8CQlnAnyyU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: syzbot <syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, maz@kernel.org,
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com,
	will@kernel.org, yuzenghui@huawei.com
Subject: Re: [syzbot] [kvmarm?] [kvm?] WARNING: locking bug in vgic_put_irq
Message-ID: <aMCaviNcIeaB9SLV@linux.dev>
References: <68acd0d9.a00a0220.33401d.048b.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68acd0d9.a00a0220.33401d.048b.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 25, 2025 at 02:08:41PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7b8346bd9fce KVM: arm64: Don't attempt vLPI mappings when ..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b4e862580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7c53d3478750eda0
> dashboard link: https://syzkaller.appspot.com/bug?extid=cef594105ac7e60c6d93
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15860634580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1074e862580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-7b8346bd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/74f545807499/vmlinux-7b8346bd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d83062566dc7/Image-7b8346bd.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com
> 
> =============================
> [ BUG: Invalid wait context ]
> 6.16.0-rc3-syzkaller-g7b8346bd9fce #0 Not tainted
> -----------------------------
> syz.0.29/3743 is trying to lock:
> a3ff80008e2e9e18 (&xa->xa_lock#20){....}-{3:3}, at: vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
> other info that might help us debug this:
> context-{5:5}
> 3 locks held by syz.0.29/3743:
>  #0: a3ff80008e2e90a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x50/0x624 arch/arm64/kvm/vgic/vgic-init.c:499
>  #1: a3ff80008e2e9fa0 (&kvm->arch.config_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x5c/0x624 arch/arm64/kvm/vgic/vgic-init.c:500
>  #2: 58f0000021be1428 (&vgic_cpu->ap_list_lock){....}-{2:2}, at: vgic_flush_pending_lpis+0x3c/0x31c arch/arm64/kvm/vgic/vgic.c:150
> stack backtrace:
> CPU: 0 UID: 0 PID: 3743 Comm: syz.0.29 Not tainted 6.16.0-rc3-syzkaller-g7b8346bd9fce #0 PREEMPT 
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4833 [inline]
>  check_wait_context kernel/locking/lockdep.c:4905 [inline]
>  __lock_acquire+0x978/0x299c kernel/locking/lockdep.c:5190
>  lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5871
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
>  vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
>  vgic_flush_pending_lpis+0x24c/0x31c arch/arm64/kvm/vgic/vgic.c:158
>  __kvm_vgic_vcpu_destroy+0x44/0x500 arch/arm64/kvm/vgic/vgic-init.c:455
>  kvm_vgic_destroy+0x100/0x624 arch/arm64/kvm/vgic/vgic-init.c:505
>  kvm_arch_destroy_vm+0x80/0x138 arch/arm64/kvm/arm.c:244
>  kvm_destroy_vm virt/kvm/kvm_main.c:1308 [inline]
>  kvm_put_kvm+0x800/0xff8 virt/kvm/kvm_main.c:1344
>  kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1367
>  __fput+0x4ac/0x980 fs/file_table.c:465
>  ____fput+0x20/0x58 fs/file_table.c:493
>  task_work_run+0x1bc/0x254 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  do_notify_resume+0x1b4/0x270 arch/arm64/kernel/entry-common.c:151
>  exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
>  exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
>  el0_svc+0xb4/0x160 arch/arm64/kernel/entry-common.c:768
>  el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git fixes

