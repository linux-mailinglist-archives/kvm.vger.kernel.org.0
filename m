Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF716130B
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 14:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgBQNQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 08:16:00 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35679 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgBQNQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 08:16:00 -0500
Received: by mail-ot1-f66.google.com with SMTP id r16so16042430otd.2;
        Mon, 17 Feb 2020 05:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9L+xGkQdZskmDmVK8EKNQvHsZDgIYop6ATmqu+ddc+g=;
        b=PnAWHY350QaNmKuFFhoAVSzIc0h+RgcosNi5BhzC9J4EQxoQ32bI0zgLSQ0LqCstEv
         s7oXUDto8+QWTqDt3XkRgZADOZXW6ve8obI1GWcqEojb6/iDltqh+1DPSewPQsnHYWZQ
         MKYThuoqE74f16QHhxQFti9QJ21eS3/8DLlo6zIa0BAEwIKrwX+9E47TNuOUgEsQnrh8
         /sq20etq+JIqTua/AtmEJMBjdHcS/mrnfnVj3uL7VLQcQscuI2iX+UihnIeT2xSJ5520
         JwuTBC8LP+DP0WLH+ol3khD2KiUnOXwKUKADjFF1o+ceogfrZZT3Bz8aKHbEU0EbdpFM
         zPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9L+xGkQdZskmDmVK8EKNQvHsZDgIYop6ATmqu+ddc+g=;
        b=MaN/Td2JEH4x6A2AMqmRNwgaZAb17NN0KPhiA3JcaAMFKSUh9mIgT2bgI1ntv/NUIG
         eL3JeqlEC6At4uTIlIqpnk92iExMj984gFSTD8VAk9qQmE9QqvGA3+mewPZdHmDT+PuS
         r4H/xQz4IpOE5Dys7/+0QdJHTAaIzdC0uTiEnMfetq3oL/YDB9S2fxrXYtjK7LTOpd8k
         MvMPfbs8rZ3SfiEdxgEBbZvFk750gOgpYxT7fz8dQb0CJn6kqkfE/tgQD+03VVNoAuhU
         LCZaYJlNecZ6VplTmDmc/WykuzYwAQDbQJDckXzQ3FcgSDeoY3Rr/z1Et+cIOeYcnhM+
         pxHw==
X-Gm-Message-State: APjAAAWmCSRcr/HJyO1yKpwXCqyYm7ykvmqlCO/0G40ryp3P4dKdp8oj
        /H6ELFC6cycPdeQJJMRWbl3BJsjwbrvPH0Hkatw=
X-Google-Smtp-Source: APXvYqz+LmHgmc5fI/HHeeGukyXH2hP16gHVdtW8CTvtEdHY+pJIsV7t/B9I2jzRptznDsmHLuyCUZo/NGcFMOrWSkk=
X-Received: by 2002:a9d:7653:: with SMTP id o19mr11658462otl.118.1581945359278;
 Mon, 17 Feb 2020 05:15:59 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
 <871rqtbcve.fsf@vitty.brq.redhat.com>
In-Reply-To: <871rqtbcve.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 Feb 2020 21:15:48 +0800
Message-ID: <CANRm+Cz_gskKwa0SU0PUhtacj3Ovm_MmBASDJHOECsnYz=jxkg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for
 both pv tlb and pv ipis
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 at 20:46, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
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
>
> Nit: to be consistent with __send_ipi_mask() the message should be
> somthing like
>
> "KVM: switch to using PV TLB flush"

There is a lot of native ops we replace by pv ops in kvm.c, I use "KVM
setup xxx" there, like pv ipis, pv tlb flush, pv sched yield, should
we keep consistent as before?

    Wanpeng

>
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
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> --
> Vitaly
>
