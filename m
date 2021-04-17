Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42A362FE2
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhDQMem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:34:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236240AbhDQMel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618662854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJrQheBC58wapcZPpGnAbCScf3qwzXRcA9ee7XXRb9s=;
        b=V+u9GRuuT6BwYGQAHF1CTalNxYPTNIarpNfYGaqGzzKQqqYJYQrYhmQ+o34u+q5NNO3L7m
        Gad7oOpVAb5kDizapG4Sxl/2ycyZAJCr6HiKO3Vv2mPK+E3gfz0F6Ox7aXYFxgf873rfKX
        difiQmtrA8lGq+X4UsvWkE9R4kMqtwc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-94KrI4i3NWyvoFtF6Md2WA-1; Sat, 17 Apr 2021 08:34:12 -0400
X-MC-Unique: 94KrI4i3NWyvoFtF6Md2WA-1
Received: by mail-ed1-f71.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso8576205edc.3
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aJrQheBC58wapcZPpGnAbCScf3qwzXRcA9ee7XXRb9s=;
        b=UsPsnHVdAvULu8v4JaUObjEXCAR4FgzAhbQrR48rIN+JNs6dgAHgGGNBJSKFWpevPi
         BRYm0vcEsxCdJVAhQmkxqx8wEGTfapkebREDpKa/VdCNTB0OQ73EVeJYDIjJsMoyFvHG
         4c4EpWET5J5aJXdjkFGB8OMlO5sHT1qk3CBKWdlTsFugFeTpTPXlh0k9H3K0RnhWv6s3
         UFah1y5Vdeu/P0tEox5goYYEUh1x8czAAyLXlpQfabF6kfzpqmQJ4HJ84FZrD6x2ud+K
         SvrjglxOj3CZPQsxLi0INcdn6gbyBCAKeZYuDhobtpc4MAAS1RXIhs6ROgjm6qGEb3kn
         /plw==
X-Gm-Message-State: AOAM533Pvw6psuxKzN7NmLRk9gNdM0iX/GJul462PGGNRrFys1yhZHy4
        y1PW/lxm4aKs17qvu7hd8v4cK5IZ2al2cmoarGGN4x0rzrY+bt9loSp67lZla4tDkZ6aZ03i8KB
        KTy1MTepkXGEq
X-Received: by 2002:a17:907:9691:: with SMTP id hd17mr13089836ejc.205.1618662851554;
        Sat, 17 Apr 2021 05:34:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbR2plk+3GLfeWSx/VBv8yLBEXfSEW3y4lcp0aZA4pM2Sg/4om8YCrhBKLBddZ5TFZC/sMEQ==
X-Received: by 2002:a17:907:9691:: with SMTP id hd17mr13089820ejc.205.1618662851344;
        Sat, 17 Apr 2021 05:34:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j5sm8020490edt.56.2021.04.17.05.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:34:10 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] x86/kvm: Don't bother __pv_cpu_mask when
 !CONFIG_SMP
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2faaf564-ab1c-0a21-4b41-48ed657e4ee6@redhat.com>
Date:   Sat, 17 Apr 2021 14:34:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 06:18, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Enable PV TLB shootdown when !CONFIG_SMP doesn't make sense. Let's
> move it inside CONFIG_SMP. In addition, we can avoid define and
> alloc __pv_cpu_mask when !CONFIG_SMP and get rid of 'alloc' variable
> in kvm_alloc_cpumask.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>   * shuffle things around a bit more
> 
>   arch/x86/kernel/kvm.c | 118 +++++++++++++++++++++++---------------------------
>   1 file changed, 55 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01..224a7a1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -451,6 +451,10 @@ static void __init sev_map_percpu_data(void)
>   	}
>   }
>   
> +#ifdef CONFIG_SMP
> +
> +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> +
>   static bool pv_tlb_flush_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> @@ -458,10 +462,6 @@ static bool pv_tlb_flush_supported(void)
>   		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
>   }
>   
> -static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> -
> -#ifdef CONFIG_SMP
> -
>   static bool pv_ipi_supported(void)
>   {
>   	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
> @@ -574,6 +574,49 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   	}
>   }
>   
> +static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> +			const struct flush_tlb_info *info)
> +{
> +	u8 state;
> +	int cpu;
> +	struct kvm_steal_time *src;
> +	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> +
> +	cpumask_copy(flushmask, cpumask);
> +	/*
> +	 * We have to call flush only on online vCPUs. And
> +	 * queue flush_on_enter for pre-empted vCPUs
> +	 */
> +	for_each_cpu(cpu, flushmask) {
> +		src = &per_cpu(steal_time, cpu);
> +		state = READ_ONCE(src->preempted);
> +		if ((state & KVM_VCPU_PREEMPTED)) {
> +			if (try_cmpxchg(&src->preempted, &state,
> +					state | KVM_VCPU_FLUSH_TLB))
> +				__cpumask_clear_cpu(cpu, flushmask);
> +		}
> +	}
> +
> +	native_flush_tlb_others(flushmask, info);
> +}
> +
> +static __init int kvm_alloc_cpumask(void)
> +{
> +	int cpu;
> +
> +	if (!kvm_para_available() || nopv)
> +		return 0;
> +
> +	if (pv_tlb_flush_supported() || pv_ipi_supported())
> +		for_each_possible_cpu(cpu) {
> +			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> +				GFP_KERNEL, cpu_to_node(cpu));
> +		}
> +
> +	return 0;
> +}
> +arch_initcall(kvm_alloc_cpumask);
> +
>   static void __init kvm_smp_prepare_boot_cpu(void)
>   {
>   	/*
> @@ -611,33 +654,8 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   	local_irq_enable();
>   	return 0;
>   }
> -#endif
> -
> -static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> -			const struct flush_tlb_info *info)
> -{
> -	u8 state;
> -	int cpu;
> -	struct kvm_steal_time *src;
> -	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> -
> -	cpumask_copy(flushmask, cpumask);
> -	/*
> -	 * We have to call flush only on online vCPUs. And
> -	 * queue flush_on_enter for pre-empted vCPUs
> -	 */
> -	for_each_cpu(cpu, flushmask) {
> -		src = &per_cpu(steal_time, cpu);
> -		state = READ_ONCE(src->preempted);
> -		if ((state & KVM_VCPU_PREEMPTED)) {
> -			if (try_cmpxchg(&src->preempted, &state,
> -					state | KVM_VCPU_FLUSH_TLB))
> -				__cpumask_clear_cpu(cpu, flushmask);
> -		}
> -	}
>   
> -	native_flush_tlb_others(flushmask, info);
> -}
> +#endif
>   
>   static void __init kvm_guest_init(void)
>   {
> @@ -653,12 +671,6 @@ static void __init kvm_guest_init(void)
>   		pv_ops.time.steal_clock = kvm_steal_clock;
>   	}
>   
> -	if (pv_tlb_flush_supported()) {
> -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> -		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> -		pr_info("KVM setup pv remote TLB flush\n");
> -	}
> -
>   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>   		apic_set_eoi_write(kvm_guest_apic_eoi_write);
>   
> @@ -668,6 +680,12 @@ static void __init kvm_guest_init(void)
>   	}
>   
>   #ifdef CONFIG_SMP
> +	if (pv_tlb_flush_supported()) {
> +		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> +		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +		pr_info("KVM setup pv remote TLB flush\n");
> +	}
> +
>   	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
>   	if (pv_sched_yield_supported()) {
>   		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
> @@ -734,7 +752,7 @@ static uint32_t __init kvm_detect(void)
>   
>   static void __init kvm_apic_init(void)
>   {
> -#if defined(CONFIG_SMP)
> +#ifdef CONFIG_SMP
>   	if (pv_ipi_supported())
>   		kvm_setup_pv_ipi();
>   #endif
> @@ -794,32 +812,6 @@ static __init int activate_jump_labels(void)
>   }
>   arch_initcall(activate_jump_labels);
>   
> -static __init int kvm_alloc_cpumask(void)
> -{
> -	int cpu;
> -	bool alloc = false;
> -
> -	if (!kvm_para_available() || nopv)
> -		return 0;
> -
> -	if (pv_tlb_flush_supported())
> -		alloc = true;
> -
> -#if defined(CONFIG_SMP)
> -	if (pv_ipi_supported())
> -		alloc = true;
> -#endif
> -
> -	if (alloc)
> -		for_each_possible_cpu(cpu) {
> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> -				GFP_KERNEL, cpu_to_node(cpu));
> -		}
> -
> -	return 0;
> -}
> -arch_initcall(kvm_alloc_cpumask);
> -
>   #ifdef CONFIG_PARAVIRT_SPINLOCKS
>   
>   /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
> 

Queued all three, thanks.

Paolo

