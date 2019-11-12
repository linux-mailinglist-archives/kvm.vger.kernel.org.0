Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8809F9911
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKLStU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 13:49:20 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44372 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLStU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 13:49:20 -0500
Received: by mail-io1-f65.google.com with SMTP id j20so19627022ioo.11
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 10:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xvqyLpPA5kcKjuswGO1+kIpP11dfUKZHmvVJw9JK1n0=;
        b=izSY/8EHcI+HX8mwoHOor9JBuEM15JmT9CwpquMRgiluHLU/bV1ApJeg3ThW8kVfu4
         B4RvQSbsQPN7ANR7kRYld6xNexbk1UvddfLntNe9YwbcGB7Nj+2TXbsWzSyREBV62P6j
         l1XjUDtJJ4p9gZV5FUW6CUrZJDoXq/anpg572YJIxJ8ZvjlnDOMtEEnYL+dIe1/xeczH
         E0k2NAqYdS1Mx0F2gg7qOZyWYzCDcVEkHHveVGaMPn4z95zXCQAHodEqsS0nQZ937/Yh
         Y2//9uRmtwEu9isiYHP7ihWzFSoGI13IWlfseDcyGOH1mtWR8RaqkkY/Bu/FBMCFCZT3
         YBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xvqyLpPA5kcKjuswGO1+kIpP11dfUKZHmvVJw9JK1n0=;
        b=GjpmcVqPhEsAu0K321XofpvcVdsdqHWDAX/Jbv3FatLKzHC/V4rnMcWeIUrhwzc3po
         aKcS5ukQUdy82tvkyEuixuhDMI1qKPXzLVzo0ImuytCQA8YMTjUBio2tDyJkXr4vvD+x
         lM0UAHetOJIAq2wZu0iHMc/1TcuHB8/m/XNgAq0MVafosCk9LR/x27Bdj9k10fxos6Je
         ySggXd+gS4scM4a6gfZKpd3EGErWbFxYU1Mrxz+/w0PkG7/bAcjmvT1WwLKZD8cdGwgz
         BQj0Qtfrv8xBmBH777WQ+sxoTG67KnwUNcAzW7/PwQV8v7+9l/IGbwCIBbQxHPwp3ZxB
         UeJQ==
X-Gm-Message-State: APjAAAXSScQyzjEMaeN0hyzn1kBRD4MUvEqYEMtOoMMYd9NAMXWi7+EU
        kf0RD+IMqidFcyvrNMWxCgw6VzCTdOgBYKnMUAsDQrxO
X-Google-Smtp-Source: APXvYqxUYk11cnSmSgrLa6DZPJ/i1J3bR4EJC27ZaxQ5lVBCQUv8ymCjuBB6qkW8ExbmrxZTlQ/AFYCxW/muga/juks=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr16562550ioj.296.1573584558733;
 Tue, 12 Nov 2019 10:49:18 -0800 (PST)
MIME-Version: 1.0
References: <1573478741-30959-1-git-send-email-pbonzini@redhat.com> <1573478741-30959-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1573478741-30959-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 Nov 2019 10:49:07 -0800
Message-ID: <CALMp9eSnf7ag_Rep1V_AA44Bug2LCF9xzK+L2Bod9THuvBLOmg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Fix NULL-ptr deref after kvm_create_vm fails
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 5:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Reported by syzkaller:
>
>     kasan: CONFIG_KASAN_INLINE enabled
>     kasan: GPF could be caused by NULL-ptr deref or user memory access
>     general protection fault: 0000 [#1] PREEMPT SMP KASAN
>     CPU: 0 PID: 14727 Comm: syz-executor.3 Not tainted 5.4.0-rc4+ #0
>     RIP: 0010:kvm_coalesced_mmio_init+0x5d/0x110 arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
>     Call Trace:
>      kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3446 [inline]
>      kvm_dev_ioctl+0x781/0x1490 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3494
>      vfs_ioctl fs/ioctl.c:46 [inline]
>      file_ioctl fs/ioctl.c:509 [inline]
>      do_vfs_ioctl+0x196/0x1150 fs/ioctl.c:696
>      ksys_ioctl+0x62/0x90 fs/ioctl.c:713
>      __do_sys_ioctl fs/ioctl.c:720 [inline]
>      __se_sys_ioctl fs/ioctl.c:718 [inline]
>      __x64_sys_ioctl+0x6e/0xb0 fs/ioctl.c:718
>      do_syscall_64+0xca/0x5d0 arch/x86/entry/common.c:290
>      entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Commit 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm")
> moves memslots and buses allocations around, however, if kvm->srcu/irq_srcu fails
> initialization, NULL will be returned instead of error code, NULL will not be intercepted
> in kvm_dev_ioctl_create_vm() and be deferenced by kvm_coalesced_mmio_init(), this patch
> fixes it.
>
> Moving the initialization is required anyway to avoid an incorrect synchronize_srcu that
> was also reported by syzkaller:
>
>  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
>  __synchronize_srcu+0x197/0x250 kernel/rcu/srcutree.c:921
>  synchronize_srcu_expedited kernel/rcu/srcutree.c:946 [inline]
>  synchronize_srcu+0x239/0x3e8 kernel/rcu/srcutree.c:997
>  kvm_page_track_unregister_notifier+0xe7/0x130 arch/x86/kvm/page_track.c:212
>  kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu.c:5828
>  kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9579
>  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:702 [inline]
>
> so do it.

Thanks for doing this!

> Reported-by: syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com
> Reported-by: syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com
> Fixes: 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d6f0696d98ef..e22ff63e5b1a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -645,6 +645,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
>
>         BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);

Nit: I would keep the BUILD_BUG_ON closer to the memslot allocation.

> +       if (init_srcu_struct(&kvm->srcu))
> +               goto out_err_no_srcu;
> +       if (init_srcu_struct(&kvm->irq_srcu))
> +               goto out_err_no_irq_srcu;
> +
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>                 struct kvm_memslots *slots = kvm_alloc_memslots();
>
> @@ -675,11 +680,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
>         INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
>  #endif
>
> -       if (init_srcu_struct(&kvm->srcu))
> -               goto out_err_no_srcu;
> -       if (init_srcu_struct(&kvm->irq_srcu))
> -               goto out_err_no_irq_srcu;
> -
>         r = kvm_init_mmu_notifier(kvm);
>         if (r)
>                 goto out_err;
> @@ -693,10 +693,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
>         return kvm;
>
>  out_err:
> -       cleanup_srcu_struct(&kvm->irq_srcu);
> -out_err_no_irq_srcu:
> -       cleanup_srcu_struct(&kvm->srcu);
> -out_err_no_srcu:
>         hardware_disable_all();
>  out_err_no_disable:
>         kvm_arch_destroy_vm(kvm);
> @@ -706,6 +702,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
>                 kfree(kvm_get_bus(kvm, i));
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>                 kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
> +       cleanup_srcu_struct(&kvm->irq_srcu);
> +out_err_no_irq_srcu:
> +       cleanup_srcu_struct(&kvm->srcu);
> +out_err_no_srcu:
>         kvm_arch_free_vm(kvm);
>         mmdrop(current->mm);
>         return ERR_PTR(r);
> --
> 1.8.3.1

Reviewed-by: Jim Mattson <jmattson@google.com>
