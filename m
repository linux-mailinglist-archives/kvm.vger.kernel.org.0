Return-Path: <kvm+bounces-63355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5C8C63C51
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 76C22381503
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A0432A3C9;
	Mon, 17 Nov 2025 11:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dQcP4SSo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DA030E0C8
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763377613; cv=none; b=UoujPu4RiPq6Y6MqIfOHNbhcQeLcLrDcMmymsCRuPQuw3GeqMexxoJ/+7MYSXoO62K/oSXWjqRweWdB6fkDnPy8Utt1lsS6FuBphhA/rWHFz08uqGPWLHnRofnmnV+II8t/kkXUxDPvOhIhAq0yM3LZtS3zyJueBXKteNapN07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763377613; c=relaxed/simple;
	bh=tjhalpEbYwkuoF1+bKdOJ/ZErIlWiNKYQRrKtszKT4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElZyhLZF87ueRGHymLIuHOU/g9scdyameNv3egbOGJAbQ69uOcQS3I1CIwM21Nakau8y+5T2cj8slhWSxjC87VucRxR7sHumRcw/HQwzBoU9PS6Gq7O2u5eN3jmlvcjwtFBT7hyvb8XT83laLhywBukazErEAFq7177ocfyD6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dQcP4SSo; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88245cc8c92so26613806d6.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 03:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763377611; x=1763982411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IETXTBKOmAepOEkqOIVJriN1cWOhftlrVXQaaWGnWJU=;
        b=dQcP4SSodP0qcuxfLPnS11t1qYCk21nWaJTWvUlsxk7WJ6WWanN3Kdl6ywnx4dlAd3
         4KShUHBzetfhfXI4W+YYqhstaSSHyK5e9KYNJfeJFoTLf+qOadaL3OuZpevL21ZYcKkY
         tfqVC8ce+b3XYXuDdYqh9V2ZTFkYXlj+rONyT1czd4i8epsTDEJ8eSrzKd5kkhpY12ZX
         J3MovoqwF5opYQTlkpMq8XHnCQnV9097XjYj7MtIVzfL4AE0psEI18GwjwBp5N9Tpl7M
         uP9MLSnKcakQR0+RNK7O+tcPw6tLODA++0tnP1Ydp2Zcfk6H0e9fRty/lOhAnd9/TH9m
         uZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763377611; x=1763982411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IETXTBKOmAepOEkqOIVJriN1cWOhftlrVXQaaWGnWJU=;
        b=XHQ9+eqSMijkAx3SA/lSKPpfp/4yma8wSqQO8rlSa43iSMk24pOV/nuaJOj00Kdf2+
         GQniheDqLNakB5AwPvfsw+thnYtGI6fIfbP6SViMNB8oGHm/1BEHOOzOTN54Uh3Q7H1c
         WYKeRTGxhd+dFjhOKTMaGMYtREopwdGlNRlYuWd6Z2jMvFn1cxpmySEtDYSN024AT9Y0
         F4JZhzZZF5x4i0y7BdV5FwqNxugU4HbxemE+yiBQKfhh3e9W8LNHTFGjdZL7h+huu1Ib
         j78yQc463z4dFkgRgFTua2S8xc2jEN8mSs0V6piMlCgwsC7Cs7R4qehcLw7UaCCpIbab
         ccRw==
X-Gm-Message-State: AOJu0Yx+AFSJPgeMioqX3zK/dEG7Mwqi0ia9355t+31Puj4Rho4f5DvR
	HcxoEMt4u40BDtjLYlVdzMdZTTXQ8HhebMoqjec4oOyKYavMIgiN9kBqQlmorVGvixn+8LWyJX5
	JC7G9iiJ7WX/jb7rwgPqU1al/BUaRD4mCToDZGsD/
X-Gm-Gg: ASbGncvWb3ElT227S5rX7TLjKunnUTRzjXN37pbfkBaGEmH6PuiBKZnAo/d/oGfphzU
	K2rtfrpQGfAf+zWbUTC8AiKJdabGu2xWawQZNveE21aYtrmYqU2KEkvUwcJENpXDJEN7V2LT9ND
	CmtmwBUYKhYRoyK54B6RZYKIsnpb7z+W9y5Nq2Gl5DP5+9S1G5WMJ4ddTUyT/KJbY2xxM5XAn3m
	UqqhIg2/rh01wCwyPZeIdDM5t4Wl+IY6vfj4dHUq3WN/l4kPK1fPbU0kkXiV7gQhv1niB4YKQG0
	GVmQscDMpR8L++rieMVLfht0onr2E3akK5Re
X-Google-Smtp-Source: AGHT+IGqJGFO/HZ4Lf/E4AOIKqpUY+VMIR3O3L34JrECSUQBLc2fS4xs4uxRgvxQwvp6ZouM1Gyf8OLcMtsyWaj0YxI=
X-Received: by 2002:a05:6214:f6a:b0:87c:1f7c:76ea with SMTP id
 6a1803df08f44-88292686aabmr141825906d6.44.1763377610809; Mon, 17 Nov 2025
 03:06:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <691afc89.a70a0220.3124cb.009a.GAE@google.com>
In-Reply-To: <691afc89.a70a0220.3124cb.009a.GAE@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 17 Nov 2025 12:06:14 +0100
X-Gm-Features: AWmQ_bn8tI6rHVE6u7DMJPWSXAOmy4fO89dkrKNnuGRmgTMd-CdRSCctDlndQt0
Message-ID: <CAG_fn=VdnBUX8sZ5bczVw7msbkxb1EuPD-CMs0Bzy1Zng8-jbw@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] INFO: task hung in kvm_swap_active_memslots (2)
To: syzbot <syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 11:44=E2=80=AFAM syzbot
<syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    3a8660878839 Linux 6.18-rc1
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D160a05e258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3De854293d7f44b=
5a5
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D5c566b850d6ab6f=
0427a
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binuti=
ls for Debian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/87a66406ce1a/dis=
k-3a866087.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7c3300da5269/vmlinu=
x-3a866087.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b4fcefdaf57b/b=
zImage-3a866087.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com
>
> INFO: task syz.2.1185:11790 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.2.1185      state:D stack:25976 pid:11790 tgid:11789 ppid:5836  =
 task_flags:0x400140 flags:0x00080002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5325 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6929
>  __schedule_loop kernel/sched/core.c:7011 [inline]
>  schedule+0xe7/0x3a0 kernel/sched/core.c:7026
>  kvm_swap_active_memslots+0x2ea/0x7d0 virt/kvm/kvm_main.c:1642
>  kvm_activate_memslot virt/kvm/kvm_main.c:1786 [inline]
>  kvm_create_memslot virt/kvm/kvm_main.c:1852 [inline]
>  kvm_set_memslot+0xd3b/0x1380 virt/kvm/kvm_main.c:1964
>  kvm_set_memory_region+0xe53/0x1610 virt/kvm/kvm_main.c:2120
>  kvm_set_internal_memslot+0x9f/0xe0 virt/kvm/kvm_main.c:2143
>  __x86_set_memory_region+0x2f6/0x740 arch/x86/kvm/x86.c:13242
>  kvm_alloc_apic_access_page+0xc5/0x140 arch/x86/kvm/lapic.c:2788
>  vmx_vcpu_create+0x503/0xbd0 arch/x86/kvm/vmx/vmx.c:7599
>  kvm_arch_vcpu_create+0x688/0xb20 arch/x86/kvm/x86.c:12706
>  kvm_vm_ioctl_create_vcpu virt/kvm/kvm_main.c:4207 [inline]
>  kvm_vm_ioctl+0xfec/0x3fd0 virt/kvm/kvm_main.c:5158
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3c9978eec9
> RSP: 002b:00007f3c9a676038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f3c999e5fa0 RCX: 00007f3c9978eec9
> RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000003
> RBP: 00007f3c99811f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3c999e6038 R14: 00007f3c999e5fa0 R15: 00007ffda33577e8
>  </TASK>
>
> Showing all locks held in the system:
> 1 lock held by khungtaskd/31:
>  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x36/0x1c0 kernel/locking/lockdep.c:6775
> 2 locks held by getty/8058:
>  #0: ffff88803440d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x24/0x80 drivers/tty/tty_ldisc.c:243
>  #1: ffffc9000e0cd2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x41b/0x14f0 drivers/tty/n_tty.c:2222
> 2 locks held by syz.2.1185/11790:
>  #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: class_mutex_con=
structor include/linux/mutex.h:228 [inline]
>  #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_alloc_apic_=
access_page+0x27/0x140 arch/x86/kvm/lapic.c:2782
>  #1: ffff888032d64138 (&kvm->slots_arch_lock){+.+.}-{4:4}, at: kvm_set_me=
mslot+0x34/0x1380 virt/kvm/kvm_main.c:1915

It's worth noting that in addition to upstream this bug has been
reported by syzkaller on several other kernel branches.
In each report, the task was shown to be holding the same pair of
locks: &kvm->slots_arch_lock and &kvm->slots_lock.

