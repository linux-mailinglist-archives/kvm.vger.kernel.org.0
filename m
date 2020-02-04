Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8678D151AE0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBDM5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:57:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727174AbgBDM5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 07:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580821036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QUc1Zczmgm9nQV8lLS+0yNUCGflG/6zOwM+BqXBaIpE=;
        b=CwM0vsoGIKjJLKTsinNW1dFF+GvW+AaIrOe89ihDkKwds/ShRJlXUV1xx8zQhkGJFwOZn6
        5Bql30o90F0jSjWLFh4C+ff3q/n0/P/8+J2uAvcHw/sBsJNXUF+u3F8hgE2JIFO/0At3gd
        0bcCCMtJRjH58aPmNMk3BfqUI979B6U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-1dpp85bTNv6nF5Q8QSgG8A-1; Tue, 04 Feb 2020 07:57:09 -0500
X-MC-Unique: 1dpp85bTNv6nF5Q8QSgG8A-1
Received: by mail-wr1-f71.google.com with SMTP id o6so10087283wrp.8
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 04:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QUc1Zczmgm9nQV8lLS+0yNUCGflG/6zOwM+BqXBaIpE=;
        b=VZ4mZ13vMGJZqH4d2QX30bpsqvBH1obEzfHFebq26heIwrCUn677YtV4bkwiGO3eZL
         g0MbehcTRKXEkxMPqohhXDQGi/vebGHvQgBmhSBZ61Y7HY+I0cr82/PEhHOfn0BfVKQh
         TGaJUSDMwGWLkdvtAMEJocy20REGcjbFkTQ5p3wgcW7EVLZ8CV3/EZUJZJ97F23Sc5M2
         +4FmOZYuDY7CZGoQ0dCsEaqsgOO+qeXsWnsUmPfM9GRu3NF9YVj93XqUQsAR921UBTsd
         jtGQLKBLNlucApTxEI4BpWXKpqdXxSxlK8JBoHcIm8tiFYSCFP0zTaz+ErpKKF9ty7zm
         qvVA==
X-Gm-Message-State: APjAAAXkJWcAR6rkxpAk2FrN21gdRya4Klite4WEcNTthMMPoxdgl6O7
        r8asmLXqlGcmWcayGcmYqVYbvSxblGgQDffmOUWal1OspWN+Hu13GbHn3entE/Jbuh0BILL+4VE
        4dXaYaoFfHzH2
X-Received: by 2002:a5d:410e:: with SMTP id l14mr20992782wrp.238.1580821027972;
        Tue, 04 Feb 2020 04:57:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRZZSjvon8ionEzjdZOIwMzpjS55ShQuUVAd+xkIJ0MG4jCofXi7E5DepoIDnT6c5w5yVUrA==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr20992759wrp.238.1580821027774;
        Tue, 04 Feb 2020 04:57:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t131sm3790960wmb.13.2020.02.04.04.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 04:57:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
Date:   Tue, 04 Feb 2020 13:57:06 +0100
Message-ID: <878slio6hp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Nick Desaulniers Reported:
>
>   When building with:
>   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
>   The following warning is observed:
>   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
>   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
>   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
>   vector)
>               ^
>   Debugging with:
>   https://github.com/ClangBuiltLinux/frame-larger-than
>   via:
>   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>     kvm_send_ipi_mask_allbutself
>   points to the stack allocated `struct cpumask newmask` in
>   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
>   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
>   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
>   8192, making a single instance of a `struct cpumask` 1024 B.
>
> This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
> both pv tlb and pv ipis..
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
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

'!alloc' check is superfluous.

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

Honestly, I'd simplify the check in kvm_alloc_cpumask() as

if (!kvm_para_available())
	return;

and allocated masks for all other cases.

>
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>
> --
> 1.8.3.1
>

-- 
Vitaly

