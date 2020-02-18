Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CC3161E7E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBRBX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:23:27 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45923 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgBRBX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:23:26 -0500
Received: by mail-oi1-f194.google.com with SMTP id v19so18517030oic.12;
        Mon, 17 Feb 2020 17:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8upeiht+r89HKGNg+QWPXHKtgwxpcyyqCLrriB2c5lg=;
        b=uJyagPQHBQMc2p72vARugaNjTaNi9Auy6/mDOPA5lUeycInuT7YlArbkMDLQYTvVXX
         TCKNnsounbc8Yfx4m1g0Zozj0e5y2PVrxxehGELSeIlRuoH4ML336bnS6hrw3I2Uf1ed
         LkBBeiHyRGQHYUiIwSD0XhDoh8ya1uEVOaBrOax5YZPwwINr5ZJEMeBzpYhs4KOSbzC+
         4ikSkKpr8ONAwArmzwUXefIBrG2W916T8N2pX9iGj/59UneS3E7uhmwIj3BdF0Mx3L5h
         YeNFvRAdRGD915XUuqC0rfLaTU0M8YmSeyJccgChu9S/Ap+5mk9eNjz5QY5KmBWragxZ
         P5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8upeiht+r89HKGNg+QWPXHKtgwxpcyyqCLrriB2c5lg=;
        b=GEu4xF8drWbSPl1xSQyF3reYypbxoofo2f2+7lZ4J+rk3LpcAlXrvX9R83bpN8EggM
         89F15dsajGkTJ1CG2ABgraWWWTYuYqUErhynFvTuycJ6dbj16pEwFxN7GqcPzlwXPGcz
         qXfc8l9l0FpRZCVd/uaaIwN0KxMySUvif3cRbtjR5vt2Xcc8a2/x6Ggy/kbj7qhc5SR7
         fv7KJvVlnHZTdDdJ7G7/pBz4CgPHXIfZYmJxnNqA2XCd6XDYoT7zElW4lBVSwaDaaW01
         faWgwyLcinkNWp+juhilXyVsBHklJy4YSdW1a2ARzGkuzm1r0BiwvZgSGPnR3JHO8T02
         RiPQ==
X-Gm-Message-State: APjAAAWoOIdjeL5703So4DDx+2W3dOCssCrMSwRRLyGJJaWYdJ5cZLCU
        LT9suDRDMqb3y3CRQwLGLeYhTri4GZDj67Tm+Ev/AgstMEM=
X-Google-Smtp-Source: APXvYqx4hj1wk1F9MvBZvnoeZOuCQkj7QqeDnG2So1wH3pvraNelBYrkulWsOcWrGas5nPfNZeZHSWAbw8cdZM32a7g=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr1083369oii.141.1581989005963;
 Mon, 17 Feb 2020 17:23:25 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
 <b2ee716e-8ef0-3940-0841-28c5a245b207@redhat.com>
In-Reply-To: <b2ee716e-8ef0-3940-0841-28c5a245b207@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 Feb 2020 09:23:15 +0800
Message-ID: <CANRm+CwQcg5u=BFYrvRTwLvbVFCpXQyF2wb65org6pdMpSb8mg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for
 both pv tlb and pv ipis
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Feb 2020 at 01:11, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/02/20 07:38, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Nick Desaulniers Reported:
> >
> >   When building with:
> >   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> >   The following warning is observed:
> >   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> >   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> >   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> >   vector)
> >               ^
> >   Debugging with:
> >   https://github.com/ClangBuiltLinux/frame-larger-than
> >   via:
> >   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
> >     kvm_send_ipi_mask_allbutself
> >   points to the stack allocated `struct cpumask newmask` in
> >   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> >   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> >   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> >   8192, making a single instance of a `struct cpumask` 1024 B.
> >
> > This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
> > both pv tlb and pv ipis..
> >
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * remove '!alloc' check
> >  * use new pv check helpers
> >
> >  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
> >  1 file changed, 21 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 76ea8c4..377b224 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
> >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> >  }
> >
> > +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> > +
> >  #ifdef CONFIG_SMP
> >
> >  static bool pv_ipi_supported(void)
> > @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct
> > cpumask *mask, int vector)
> >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
> > int vector)
> >  {
> >      unsigned int this_cpu = smp_processor_id();
> > -    struct cpumask new_mask;
> > +    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >      const struct cpumask *local_mask;
> >
> > -    cpumask_copy(&new_mask, mask);
> > -    cpumask_clear_cpu(this_cpu, &new_mask);
> > -    local_mask = &new_mask;
> > +    cpumask_copy(new_mask, mask);
> > +    cpumask_clear_cpu(this_cpu, new_mask);
> > +    local_mask = new_mask;
> >      __send_ipi_mask(local_mask, vector);
> >  }
> >
> > @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
> >      update_intr_gate(X86_TRAP_PF, async_page_fault);
> >  }
> >
> > -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
> >
> >  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> >              const struct flush_tlb_info *info)
> > @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct
> > cpumask *cpumask,
> >      u8 state;
> >      int cpu;
> >      struct kvm_steal_time *src;
> > -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> > +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >
> >      cpumask_copy(flushmask, cpumask);
> >      /*
> > @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
> >      if (pv_tlb_flush_supported()) {
> >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> > +        pr_info("KVM setup pv remote TLB flush\n");
> >      }
> >
> >      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > @@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
> >  }
> >  arch_initcall(activate_jump_labels);
> >
> > -static __init int kvm_setup_pv_tlb_flush(void)
> > +static __init int kvm_alloc_cpumask(void)
> >  {
> >      int cpu;
> > +    bool alloc = false;
> >
> >      if (!kvm_para_available() || nopv)
> >          return 0;
> >
> > -    if (pv_tlb_flush_supported()) {
> > +    if (pv_tlb_flush_supported())
> > +        alloc = true;
> > +
> > +#if defined(CONFIG_SMP)
> > +    if (pv_ipi_supported())
> > +        alloc = true;
> > +#endif
> > +
> > +    if (alloc)
> >          for_each_possible_cpu(cpu) {
> > -            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> > +            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> >                  GFP_KERNEL, cpu_to_node(cpu));
> >          }
> > -        pr_info("KVM setup pv remote TLB flush\n");
> > -    }
> >
> >      return 0;
> >  }
> > -arch_initcall(kvm_setup_pv_tlb_flush);
> > +arch_initcall(kvm_alloc_cpumask);
> >
> >  #ifdef CONFIG_PARAVIRT_SPINLOCKS
> >
> > --
> > 2.7.4
> >
>
> Also has messed up whitespace, can you resend please?

My fault, just resend all of them.

    Wanpeng
