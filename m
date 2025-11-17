Return-Path: <kvm+bounces-63395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 29AF5C654B4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D86304E4793
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB2D3016E8;
	Mon, 17 Nov 2025 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVwbiTby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCAF29B79B
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398446; cv=none; b=lk5LGoJ3OwlEV/iU4ounqbuVWt6HfuJMyD9OSadafRBfgSauTZyXNDDwux5S6+b8wg2iFfTJjq3xYo5rI7QP/k1wCiUisFFLv0PEzCKDp9wsdXndG4nVFAzKe9JvOXgFSkfmYyYn2lrAUWlFACLchXD9kmBTzfEBe0CxusuJPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398446; c=relaxed/simple;
	bh=Zc6qA7IUxNXFlnoXcJZf47VEnLabbzyovUt6A+qfK3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=igMeK3dZghHnp9NDHtoYr6KDClWB5QOhmRSLcz3msTTE82h2h5/KsplZtvapQKpbqmksDLCSSmGa/lEa+rR5sfPI5NqPf0xqhUxG8ixzqWR01IsyFPSZ6RCGLa4p/AWm0lO9g6FNPkzBqjoqheScUbUHAw6TVREQTcO2DCN+9rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FVwbiTby; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341cd35b0f3so6392678a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 08:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763398444; x=1764003244; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVu0wxmdwGBM6jAYlk65BcVmnPNCAbKIIwC4yBQcYLM=;
        b=FVwbiTbyJYQDN6gHtwRNv83kznGeigxFfAF88rmL6qbaRF14qjjQtCwzABdB+8RyCA
         u/BB+KIJ757YMZ4o3nIGE6CQYdURwFUHnTm1ceLTop5B4TnjFggH6hfliMYKgMN/Bqri
         NkksvuCQ7un42+ioN+RH+lGLypLWXVZnrguQpixD/NdsvpdtkMi+FW8ianfdPtdWKx5M
         eY6pJfd+D2NT0lHgZOb+L+i2uFOUZakT1/aW2cPr+cGejUwTMiY5L2K1ACoKUNRSPzwQ
         v8vixBZTtRqaOWg6+/PXyPdbDnpCj2JdSm3PqMMAFWf3agIX7dAMmq/m6EsV4gXehuiP
         0s2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763398444; x=1764003244;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BVu0wxmdwGBM6jAYlk65BcVmnPNCAbKIIwC4yBQcYLM=;
        b=w0K/mFWwGokRqwvmhcppNsF3n4pnxgPtAGqbc460BJLP/Dpo5Y9ZMPmjylSUzhLGR9
         yWx+VvUNGnsuYHqsIz1NwjCPQAccDDwyuInNHzhB3VTBo0/JBywOYeZwGvFaHIoeaaXu
         I/kRH4JDY5UeDK3K+WocWUt16D3L4R3v3KQ4ELnfnivFasPiBhC5/X10jsAZ1MAvisB8
         vxXVrGGozEc1ymLpZTQw7jbmVu/n//7p4Pr/6e7gop0pgkh/U96vTYdf2rYhnNu6bVS9
         qGPvkNf1co3XWyEZEGiB719KJrIeRsC2zd7LhuShkfAPLxYhLbcHVcjVXXD9OCPRXF+z
         jJ9A==
X-Forwarded-Encrypted: i=1; AJvYcCV+Aoyy1W+n/9ZkIfNqGYkhUznET4o1//kGUzbnmlgcTA5ya0YDztWu8DoswYWszHRgc0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTB48ofYkhERqlbWliKXVX9neu0kUSQPayCpI+clro8jWzKczS
	YTBdebnmv4OUBWPYNrgb8CIMF61fho+1pqaWAJ2RogwFitir5MX/CNQcB8hUiLN8XjYmVbrsd0S
	8WIGBvw==
X-Google-Smtp-Source: AGHT+IEajB2KHi1upZ/Mornk8gDh2AY5APQ8i431TxPsAWjvsG+mCmOGhJ6Sug9zpqkodg1GPTVsA3FHlC4=
X-Received: from pgac15.prod.google.com ([2002:a05:6a02:294f:b0:bac:a20:5eea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d96:b0:354:ce8b:4b9a
 with SMTP id adf61e73a8af0-361170338fdmr49499637.6.1763398443597; Mon, 17 Nov
 2025 08:54:03 -0800 (PST)
Date: Mon, 17 Nov 2025 08:54:02 -0800
In-Reply-To: <CAG_fn=VdnBUX8sZ5bczVw7msbkxb1EuPD-CMs0Bzy1Zng8-jbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <691afc89.a70a0220.3124cb.009a.GAE@google.com> <CAG_fn=VdnBUX8sZ5bczVw7msbkxb1EuPD-CMs0Bzy1Zng8-jbw@mail.gmail.com>
Message-ID: <aRtTKpltYqEAbxHw@google.com>
Subject: Re: [syzbot] [kvm?] INFO: task hung in kvm_swap_active_memslots (2)
From: Sean Christopherson <seanjc@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: syzbot <syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025, Alexander Potapenko wrote:
> On Mon, Nov 17, 2025 at 11:44=E2=80=AFAM syzbot
> <syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    3a8660878839 Linux 6.18-rc1
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D160a05e2580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3De854293d7f4=
4b5a5
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D5c566b850d6ab=
6f0427a
> > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binu=
tils for Debian) 2.40
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/87a66406ce1a/d=
isk-3a866087.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/7c3300da5269/vmli=
nux-3a866087.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/b4fcefdaf57b=
/bzImage-3a866087.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com
> >
> > INFO: task syz.2.1185:11790 blocked for more than 143 seconds.
> >       Not tainted syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:syz.2.1185      state:D stack:25976 pid:11790 tgid:11789 ppid:5836=
   task_flags:0x400140 flags:0x00080002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5325 [inline]
> >  __schedule+0x1190/0x5de0 kernel/sched/core.c:6929
> >  __schedule_loop kernel/sched/core.c:7011 [inline]
> >  schedule+0xe7/0x3a0 kernel/sched/core.c:7026
> >  kvm_swap_active_memslots+0x2ea/0x7d0 virt/kvm/kvm_main.c:1642
> >  kvm_activate_memslot virt/kvm/kvm_main.c:1786 [inline]
> >  kvm_create_memslot virt/kvm/kvm_main.c:1852 [inline]
> >  kvm_set_memslot+0xd3b/0x1380 virt/kvm/kvm_main.c:1964
> >  kvm_set_memory_region+0xe53/0x1610 virt/kvm/kvm_main.c:2120
> >  kvm_set_internal_memslot+0x9f/0xe0 virt/kvm/kvm_main.c:2143
> >  __x86_set_memory_region+0x2f6/0x740 arch/x86/kvm/x86.c:13242
> >  kvm_alloc_apic_access_page+0xc5/0x140 arch/x86/kvm/lapic.c:2788
> >  vmx_vcpu_create+0x503/0xbd0 arch/x86/kvm/vmx/vmx.c:7599
> >  kvm_arch_vcpu_create+0x688/0xb20 arch/x86/kvm/x86.c:12706
> >  kvm_vm_ioctl_create_vcpu virt/kvm/kvm_main.c:4207 [inline]
> >  kvm_vm_ioctl+0xfec/0x3fd0 virt/kvm/kvm_main.c:5158
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f3c9978eec9
> > RSP: 002b:00007f3c9a676038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00007f3c999e5fa0 RCX: 00007f3c9978eec9
> > RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000003
> > RBP: 00007f3c99811f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f3c999e6038 R14: 00007f3c999e5fa0 R15: 00007ffda33577e8
> >  </TASK>
> >
> > Showing all locks held in the system:
> > 1 lock held by khungtaskd/31:
> >  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire=
 include/linux/rcupdate.h:331 [inline]
> >  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock in=
clude/linux/rcupdate.h:867 [inline]
> >  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_l=
ocks+0x36/0x1c0 kernel/locking/lockdep.c:6775
> > 2 locks held by getty/8058:
> >  #0: ffff88803440d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_=
wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
> >  #1: ffffc9000e0cd2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty=
_read+0x41b/0x14f0 drivers/tty/n_tty.c:2222
> > 2 locks held by syz.2.1185/11790:
> >  #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: class_mutex_c=
onstructor include/linux/mutex.h:228 [inline]
> >  #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_alloc_api=
c_access_page+0x27/0x140 arch/x86/kvm/lapic.c:2782
> >  #1: ffff888032d64138 (&kvm->slots_arch_lock){+.+.}-{4:4}, at: kvm_set_=
memslot+0x34/0x1380 virt/kvm/kvm_main.c:1915
>=20
> It's worth noting that in addition to upstream this bug has been
> reported by syzkaller on several other kernel branches.
> In each report, the task was shown to be holding the same pair of
> locks: &kvm->slots_arch_lock and &kvm->slots_lock.

Ya, though that's not terribly interesting because kvm_swap_active_memslots=
()
holds those locks, and the issue is specifically that kvm_swap_active_memsl=
ots()
is waiting on kvm->mn_active_invalidate_count to go to zero.

Paolo even called out this possibility in commit 52ac8b358b0c ("KVM: Block =
memslot
updates across range_start() and range_end()"):

 : Losing the rwsem fairness does theoretically allow MMU notifiers to
 : block install_new_memslots forever.  Note that mm/mmu_notifier.c's own
 : retry scheme in mmu_interval_read_begin also uses wait/wake_up
 : and is likewise not fair.

In every reproducer, the "VMM" process is either getting thrashed by reclai=
m, or
the process itself is generating a constant stream of mmu_notifier invalida=
tions.

I don't see an easy, or even decent, solution for this.  Forcing new invali=
dations
to wait isn't really an option because in-flight invalidations may be sleep=
able
(and KVM has zero visibility into the the behavior of invalidator), while n=
ew
invalidations may not be sleepable.

And on the KVM side, bailing from kvm_activate_memslot() on a pending signa=
l
isn't an option, because kvm_activate_memslot() must not fail.  Hmm, at lea=
st,
not without terminating the VM.  I guess maybe that's an option?  Add a tim=
eout
(maybe with a module param) to the kvm_swap_active_memslots() loop, and the=
n WARN
and kill the VM if the timeout is hit.

