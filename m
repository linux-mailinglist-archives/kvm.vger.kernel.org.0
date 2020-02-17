Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BAB16188E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgBQRL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:11:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgBQRL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 12:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLzWBd5S+TLMrOF4P4oljWP71RXE91914adPJ7oufsE=;
        b=CgGgIF4xANoUIt+LAIvAOuyWnmIFPDBmwXh/oEn2ktCEosCbvC4CsXTBT4tikOMoPUv8lu
        pk7zGpIWbCyNQP60URJ+Yx/dzib5WmrzGhor0hbAOraXJoTUfgNDqzLBaTK39p+joH/DjX
        ylrlRGBHHzEqiAHeg3jKrKQZHMNZBHQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-1DGd1-y2N5mMx-c0UXM7AQ-1; Mon, 17 Feb 2020 12:11:23 -0500
X-MC-Unique: 1DGd1-y2N5mMx-c0UXM7AQ-1
Received: by mail-wr1-f70.google.com with SMTP id u8so9259724wrp.10
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SLzWBd5S+TLMrOF4P4oljWP71RXE91914adPJ7oufsE=;
        b=dAmWHWhQDAoMW7FkNi/BOZQq3IEvlfU9IGWz8Uo1D9ojhuB7xQEEWmQFUTc0geuGHZ
         B/CJGvPSrHgWBYfVnqhUUCoEh/CbwIbdRjHEXB5eQFv9aF/i0mYq9rVQqHMagrmO051L
         8z8KjMTLqz6d/QmlTfyeP86ACntNWzfd+5hhRh6ifLyVLrAALW3wKelctlZ4g3454dws
         6RPSLl6jwl7N3qdKcthj62ZDo16CU1PvX8cK84ZpeHRgTnEVbf/to1PMU9Kpy8wN9HEu
         MBhMBz3DpESmz3S26DVdqHioM/et7jleHrhr7r+VjitiPGs/wDpo7cWCNfDVv/OFQ7Bd
         rnPA==
X-Gm-Message-State: APjAAAW7Agyljl6hHrDX9DuG6CYEttFKa1/6tz/NC50Ywi7+RNnJwBjX
        FmMOC1mpS2Pek3w/boT6BSCDiaeqygVKZSYReVMiIn/lbVLr9706BrKICUsYrT+SU54gSkjj4yX
        Ji25eU83Eg/jo
X-Received: by 2002:a1c:4144:: with SMTP id o65mr16676wma.81.1581959481669;
        Mon, 17 Feb 2020 09:11:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCEB0/a6a+eRnWW0AjErCPuC0+Diyp+47hup9Tw6KykoyRkF+jAJ5atf0FW/bsBAQHOKqsag==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr16650wma.81.1581959481329;
        Mon, 17 Feb 2020 09:11:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id z11sm1777478wrv.96.2020.02.17.09.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:11:20 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for
 both pv tlb and pv ipis
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2ee716e-8ef0-3940-0841-28c5a245b207@redhat.com>
Date:   Mon, 17 Feb 2020 18:11:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/20 07:38, Wanpeng Li wrote:
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

Also has messed up whitespace, can you resend please?

Paolo

