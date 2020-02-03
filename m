Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07B91508FC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgBCPDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:03:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43777 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgBCPDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:03:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id u131so7951002pgc.10
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 07:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQK4ORCAhYC2TygAyENUq1Q+925Z/9wGLN91NM9l6UU=;
        b=qBazqR061kVg8v/Z8p7nBu1H7IXupX7i4lpnY8jUobCGDQ/rxhNQypnA74Avdyk0QT
         9vWGwBk+bGjA7/AdJJ2Kln8dtDBLuKYmoYZrpYh0+96J4SWcKi317h3DIDYFQ4eBbTgB
         KAnxFWfqoHtNtM9FT0ONAFtcW82nwvl3Gr4WMnbgH4lR96YaB2Wwx2zpGSK39KZP8rjf
         Tn7wRdP67jpxr7ArhQqUaWd2R4vxKk5xluqHm7F7pn9tUNcA0bKQgP0LCw+JoZ1Q0BJC
         7XMw7kL0mCiBTZKZTY4P3Jg6ARZUlfa3jkymf0dPURusFWn/umMslprlVcR9VrpWEmNr
         /1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQK4ORCAhYC2TygAyENUq1Q+925Z/9wGLN91NM9l6UU=;
        b=DJeAXFJN2/gHu0zTlIXpjLRmI0QHr/JApgsJb6VfzyW6qRQhyB2yn0LkCGeU1lWo8f
         L7PC4Su/C2eAdVEn7b0J+hGgM20yb5Op0iiRR3f7uSftXL8Vcn78nQnnURV+ANzkpdng
         vkxfUZGWq/d4Qy0kmS4tgzt/WQjVhKo4wiyDz+ONlXp8SQk5Udt9v5KteORkIk8NqBJU
         YFYAZ+KReMZB3Y5q1vcJSaZMiEQx3MpI7Y6QkWIdlazk+CNqkbXyCkXg3eNeZMYiAh41
         hrkR7ARbGY2yXZzYmY5TvKspCpU0TQmnHoUIS2YW5Zwh+wfz2adovXqNnyV5z2PG0BFp
         ZfXw==
X-Gm-Message-State: APjAAAXFu8NRyx7nsq17XaH+xXkohz216eHeSQAUpOyQR7mxKYEUh2/R
        4vOcz//vCQhL5D+lAyhn/N5XBkxTZmdZEVkBzHNq4w==
X-Google-Smtp-Source: APXvYqzb5OMphFicZAJboQPCxanNzxSVDgsY+/vXFIRCX3rDhzaMIMOJWaUtwbLvBk/9cKuzg3ecfo/XKdAIJbUO3FM=
X-Received: by 2002:a62:38c9:: with SMTP id f192mr25348029pfa.165.1580742182018;
 Mon, 03 Feb 2020 07:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20200127071602.11460-1-nick.desaulniers@gmail.com> <CANRm+CwK0Cg45mktda9Yz9fsjPCvtuB8O+fma5L3tV725ki1qw@mail.gmail.com>
In-Reply-To: <CANRm+CwK0Cg45mktda9Yz9fsjPCvtuB8O+fma5L3tV725ki1qw@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Feb 2020 15:02:50 +0000
Message-ID: <CAKwvOdkJ_aJ+8=8fw50Ggk160rgp8M6xyGJ7qTsMctLT0PnZHw@mail.gmail.com>
Subject: Re: [PATCH] dynamically allocate struct cpumask
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Nick Desaulniers <nick.desaulniers@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 3, 2020 at 8:32 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Hi Nick,
> On Mon, 27 Jan 2020 at 15:16, Nick Desaulniers
> <nick.desaulniers@gmail.com> wrote:
> >
> > This helps avoid avoid a potentially large stack allocation.
> >
> > When building with:
> > $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> > The following warning is observed:
> > arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> > function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> > static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> > vector)
> >             ^
> > Debugging with:
> > https://github.com/ClangBuiltLinux/frame-larger-than
> > via:
> > $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
> >   kvm_send_ipi_mask_allbutself
> > points to the stack allocated `struct cpumask newmask` in
> > `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> > potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> > the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> > 8192, making a single instance of a `struct cpumask` 1024 B.
>
> Could you help test the below untested patch?
>
> From 867753e2fa27906f15df7902ba1bce7f9cef6ebe Mon Sep 17 00:00:00 2001
> From: Wanpeng Li <wanpengli@tencent.com>
> Date: Mon, 3 Feb 2020 16:26:35 +0800
> Subject: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both
> pv tlb and pv ipis
>
> Reported-by: Nick Desaulniers <nick.desaulniers@gmail.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 81045aab..b1e8efa 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -425,6 +425,8 @@ static void __init sev_map_percpu_data(void)
>      }
>  }
>
> +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> +
>  #ifdef CONFIG_SMP
>  #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)
>
> @@ -490,12 +492,12 @@ static void kvm_send_ipi_mask(const struct
> cpumask *mask, int vector)
>  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
> int vector)
>  {
>      unsigned int this_cpu = smp_processor_id();
> -    struct cpumask new_mask;
> +    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);

Yes, this should help reduce the stack usage, thanks.
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

>      const struct cpumask *local_mask;
>
> -    cpumask_copy(&new_mask, mask);
> -    cpumask_clear_cpu(this_cpu, &new_mask);
> -    local_mask = &new_mask;
> +    cpumask_copy(new_mask, mask);
> +    cpumask_clear_cpu(this_cpu, new_mask);
> +    local_mask = new_mask;
>      __send_ipi_mask(local_mask, vector);
>  }
>
> @@ -575,7 +577,6 @@ static void __init kvm_apf_trap_init(void)
>      update_intr_gate(X86_TRAP_PF, async_page_fault);
>  }
>
> -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
>
>  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>              const struct flush_tlb_info *info)
> @@ -583,7 +584,7 @@ static void kvm_flush_tlb_others(const struct
> cpumask *cpumask,
>      u8 state;
>      int cpu;
>      struct kvm_steal_time *src;
> -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>
>      cpumask_copy(flushmask, cpumask);
>      /*
> @@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
>          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +        pr_info("KVM setup pv remote TLB flush\n");
>      }
>
>      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> @@ -732,23 +734,30 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
>
> -static __init int kvm_setup_pv_tlb_flush(void)
> +static __init int kvm_alloc_cpumask(void)
>  {
>      int cpu;
> +    bool alloc = false;
>
>      if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>          !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> +        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
> +        alloc = true;
> +
> +#if defined(CONFIG_SMP)
> +    if (!alloc && kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
> +        alloc = true;
> +#endif
> +
> +    if (alloc)
>          for_each_possible_cpu(cpu) {
> -            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> +            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>                  GFP_KERNEL, cpu_to_node(cpu));
>          }
> -        pr_info("KVM setup pv remote TLB flush\n");
> -    }
>
>      return 0;
>  }
> -arch_initcall(kvm_setup_pv_tlb_flush);
> +arch_initcall(kvm_alloc_cpumask);
>
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>
> --
> 1.8.3.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CANRm%2BCwK0Cg45mktda9Yz9fsjPCvtuB8O%2Bfma5L3tV725ki1qw%40mail.gmail.com.



-- 
Thanks,
~Nick Desaulniers
