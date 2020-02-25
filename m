Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F6416EED3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 20:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgBYTQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 14:16:07 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40510 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729894AbgBYTQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 14:16:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id b185so43206pfb.7
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 11:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUZVMlHBXvZV7Ou78rc/XDRW/zexdXeiYa6RgRgftog=;
        b=hImB0JUoI8D5rK/tvQTSN8CVItuNPQJbJ2XDE4D3EQAf9y/En82yTf0XNRIkj4/FuS
         CTDFFM0RvgF2LzPcTMLHhOUBt0dw9qe7ZoedDQOT8Y+Q2Af73Jbgz5NDt3bhoObV6lnP
         MBi596CYyRbYToSNJDfbJXZNkQ9qFGCuqk2jXULldpEqVG26dhFNsHiR1QRPyySsYf3Q
         2K+6SBsBDKpokrUngVilOcKztuzkSOX0YnPTtx7FyLpJRsqhPtL6gJyBiE87HG8kmFDe
         o9Ews1BI81nG4va/t3WuZ6AG0lE0DUYCbOzqGETO0qH98D2lO3YaWzz6szRAfhmFXXjQ
         IK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUZVMlHBXvZV7Ou78rc/XDRW/zexdXeiYa6RgRgftog=;
        b=Jxz5/Ijh4nAFM3Oo95pp1CGFH1lxlmjNPSh7sPl4W05dijXjjJoxwX3hh5iTQ8muSM
         bC2rtSaC7sh5RIH49BckTKCIz4KJxJdOvNLTb1mi+Jx1nMYL6LJIxDL769coQFUuHbWr
         A1dEb+5ZFGKEUMXCQpBegXjssX4T7MJchFDuL/yiYQl54F08DbJoNP2wEVkA8NdBqXfp
         gJwEnIcv8z94oA8l+DObWHmsGTtKKp1DJCFWKt5JDuekg46109tc4j8/AQZ/O49jwLmJ
         Y61VD6nyrEq76aTJzBLk93uFnKIanzOH2fzuMZaiZyltOWWTvo/Bwo/e5u1pxkYEuV5a
         scYQ==
X-Gm-Message-State: APjAAAUVdmmL9JVZYJlmyORTgyHchvB8sXYlZHC7gYnb6k/4RGngKhBj
        fSZb+AK5/tjOs7JD8tw90VOuRRCDiNI+TAmJSt/Wgg==
X-Google-Smtp-Source: APXvYqy1/IF0tRAavAP1XBZXStk4y3mP+ffbu1nWKKy5fKo84qgyYl5tLGoSfMXrJ/7UEF1VXqAeEBC+4VCGJdlptd4=
X-Received: by 2002:a63:4e22:: with SMTP id c34mr18126pgb.263.1582658165742;
 Tue, 25 Feb 2020 11:16:05 -0800 (PST)
MIME-Version: 1.0
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
 <1581988104-16628-2-git-send-email-wanpengli@tencent.com> <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com>
In-Reply-To: <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 25 Feb 2020 11:15:54 -0800
Message-ID: <CAKwvOd=bDW6K3PC7S5fiG5n_kwgqhbnVsBHUSGgYaPQY-L_YmA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per
 cpu for both pv tlb and pv ipis
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(putting Paolo in To: field, in case email filters are to blame.
Vitaly, maybe you could ping Paolo internally?)

On Mon, Feb 24, 2020 at 11:55 PM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> ping,
> On Tue, 18 Feb 2020 at 09:12, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
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
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
> >                 kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> >  }
> >
> > +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> > +
> >  #ifdef CONFIG_SMP
> >
> >  static bool pv_ipi_supported(void)
> > @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
> >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
> >  {
> >         unsigned int this_cpu = smp_processor_id();
> > -       struct cpumask new_mask;
> > +       struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >         const struct cpumask *local_mask;
> >
> > -       cpumask_copy(&new_mask, mask);
> > -       cpumask_clear_cpu(this_cpu, &new_mask);
> > -       local_mask = &new_mask;
> > +       cpumask_copy(new_mask, mask);
> > +       cpumask_clear_cpu(this_cpu, new_mask);
> > +       local_mask = new_mask;
> >         __send_ipi_mask(local_mask, vector);
> >  }
> >
> > @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
> >         update_intr_gate(X86_TRAP_PF, async_page_fault);
> >  }
> >
> > -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
> >
> >  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> >                         const struct flush_tlb_info *info)
> > @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> >         u8 state;
> >         int cpu;
> >         struct kvm_steal_time *src;
> > -       struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> > +       struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >
> >         cpumask_copy(flushmask, cpumask);
> >         /*
> > @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
> >         if (pv_tlb_flush_supported()) {
> >                 pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> >                 pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> > +               pr_info("KVM setup pv remote TLB flush\n");
> >         }
> >
> >         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > @@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
> >  }
> >  arch_initcall(activate_jump_labels);
> >
> > -static __init int kvm_setup_pv_tlb_flush(void)
> > +static __init int kvm_alloc_cpumask(void)
> >  {
> >         int cpu;
> > +       bool alloc = false;
> >
> >         if (!kvm_para_available() || nopv)
> >                 return 0;
> >
> > -       if (pv_tlb_flush_supported()) {
> > +       if (pv_tlb_flush_supported())
> > +               alloc = true;
> > +
> > +#if defined(CONFIG_SMP)
> > +       if (pv_ipi_supported())
> > +               alloc = true;
> > +#endif
> > +
> > +       if (alloc)
> >                 for_each_possible_cpu(cpu) {
> > -                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> > +                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> >                                 GFP_KERNEL, cpu_to_node(cpu));
> >                 }
> > -               pr_info("KVM setup pv remote TLB flush\n");
> > -       }
> >
> >         return 0;
> >  }
> > -arch_initcall(kvm_setup_pv_tlb_flush);
> > +arch_initcall(kvm_alloc_cpumask);
> >
> >  #ifdef CONFIG_PARAVIRT_SPINLOCKS
> >
> > --
> > 2.7.4
> >



-- 
Thanks,
~Nick Desaulniers
