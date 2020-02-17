Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505E4161252
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 13:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgBQMqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 07:46:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728688AbgBQMqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 07:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581943579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1IBRJqn+scoqGFE7Ecg3JdfKODqslJ6sMFIQcaVmgmQ=;
        b=gTcaC1yDdaKsG2Ig+/8h5igXLVkFcMrUAvlq0/bWCGYVZxsihSNetTH3BGytrhgKz0G5D7
        mzM3mOfe5DR67pohMH5NEE+/xzhq3c0bn7++0qO9aX75+RZKTOGD+9hUW0pGUWdcOPOew2
        BhmnxZDvxwjjkVVoDo8TPRLGEJ1kLoA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-M8UQUQaGNwuSulXWwP542A-1; Mon, 17 Feb 2020 07:46:16 -0500
X-MC-Unique: M8UQUQaGNwuSulXWwP542A-1
Received: by mail-wm1-f72.google.com with SMTP id y125so2586762wmg.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 04:46:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1IBRJqn+scoqGFE7Ecg3JdfKODqslJ6sMFIQcaVmgmQ=;
        b=TLFZ0A1yJlqQSAywkjgB1oFJ8O4knNfZn5Zie3u0oDfBICfGEccetyurllv7OZfGo0
         iJ4h0M3PaiP0VFwcYY0nGlPZJXKF41bHtriUqxWSLIygagmV5R8AYQpfBe59VSDE0+HQ
         I1RjMQIMOvM3T/yGc58pTk0B969ecBvImwsfQr2uhyMF+zrT7Z3mLJb9FK6Sea8qyo7/
         2muYcNFZPD9wRkiMkydgcgE1Ue+7DC+eN3Rl7HGYuhCRw5ti3DEZoo+e2i8khzOJnt/y
         cdgKy3r+HIFCDp+UsVHHTn9wU4G5YwpVmlXkvwlcfmX7DedkpUebua4a6ZRzyGu9cpsM
         m01w==
X-Gm-Message-State: APjAAAX2IbdO3NKWjnCqlSJt9IIj3ZgiVl/ANTQV8FyEZwYYVAbBZxOc
        Zf6dibefyJhIL4IEs0+scAj5MQqFiZTHbHMyUd+dGrSPieMzAqFhap5c6TWUNxVxv7Ll1RIHQIO
        XYlXEe5jdU4Bw
X-Received: by 2002:a7b:c459:: with SMTP id l25mr21600361wmi.17.1581943575040;
        Mon, 17 Feb 2020 04:46:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzvRniTXW6DUJ8zXCaDWv4tXMB+/SKFo/9HDJN5SVbn7+nrb4j0vfkutpvM9Y+DkMMk74TTQ==
X-Received: by 2002:a7b:c459:: with SMTP id l25mr21600335wmi.17.1581943574741;
        Mon, 17 Feb 2020 04:46:14 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t12sm775315wrq.97.2020.02.17.04.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 04:46:14 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
References: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
Date:   Mon, 17 Feb 2020 13:46:13 +0100
Message-ID: <871rqtbcve.fsf@vitty.brq.redhat.com>
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
> v1 -> v2:
>  * remove '!alloc' check
>  * use new pv check helpers
>
>  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 76ea8c4..377b224 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
>          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
>  }
>
> +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> +
>  #ifdef CONFIG_SMP
>
>  static bool pv_ipi_supported(void)
> @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct
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
> @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
>      update_intr_gate(X86_TRAP_PF, async_page_fault);
>  }
>
> -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
>
>  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>              const struct flush_tlb_info *info)
> @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct
> cpumask *cpumask,
>      u8 state;
>      int cpu;
>      struct kvm_steal_time *src;
> -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>
>      cpumask_copy(flushmask, cpumask);
>      /*
> @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
>      if (pv_tlb_flush_supported()) {
>          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +        pr_info("KVM setup pv remote TLB flush\n");

Nit: to be consistent with __send_ipi_mask() the message should be
somthing like

"KVM: switch to using PV TLB flush"

>      }
>
>      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> @@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
>
> -static __init int kvm_setup_pv_tlb_flush(void)
> +static __init int kvm_alloc_cpumask(void)
>  {
>      int cpu;
> +    bool alloc = false;
>
>      if (!kvm_para_available() || nopv)
>          return 0;
>
> -    if (pv_tlb_flush_supported()) {
> +    if (pv_tlb_flush_supported())
> +        alloc = true;
> +
> +#if defined(CONFIG_SMP)
> +    if (pv_ipi_supported())
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
> 2.7.4
>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

