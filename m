Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE0027C5FC
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 13:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbgI2Lkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 07:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgI2Lkh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 07:40:37 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601379634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PLcWkCNBX2DxtvqWLFx/qLkWzg177l7fJEDxqqt5XmM=;
        b=TnCjknKkHJYVc5GLX/+8AQkow2jeipvi+d7EVU85sWwZT9e1naX4IuI8WpDSiYYbmphliw
        3LorG9Jkc5Bt2DTndkI/2OnPcPoBgJl2xuxk5Xj04JuoOukDKi6Q3DxiyyNdbiEEI1FzqH
        ZCq0WpKTqb7FmcqOawC+3f8cL6Vgu8Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-w3TLsEFnOIO7SQP959OmSw-1; Tue, 29 Sep 2020 07:40:32 -0400
X-MC-Unique: w3TLsEFnOIO7SQP959OmSw-1
Received: by mail-wm1-f72.google.com with SMTP id w3so1720555wmg.4
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PLcWkCNBX2DxtvqWLFx/qLkWzg177l7fJEDxqqt5XmM=;
        b=MPtxi2Eiqi64eQZP3JeEV0wUCWPQrnT4vJfVGVlCZDn0ED/KhnCP91jRIPByrMrM8z
         jJaIR/HBZnh3Zr8Q+qQnNPydkivsaiN0qD4SUE0s+F2stfj92jH3+oukjXDzZUAre7Gm
         Z3By+57dWKRbvSOOrV2rVAzO8EjIhQyM6f3PKiPWOV1uRtAzgtfVSRlvJAu7iYppEG+K
         Ff+OuZjOlb7+kDOeob2WflsFurQbieg6kiVjHBsK77H3WbQALp3vYgM35VR7VoYj9Syw
         BFHnwBxpojc5H1TmlKVdC6pdB/1n2ffE/VSJU5KxKJgL0rEE5rVfiBx95flFm70iXurH
         b24Q==
X-Gm-Message-State: AOAM531ZySxVqr3asv05PDC4o1Zmulzuqq3g5nr27TbdZV4/j1KxzoLj
        IY1/2KlEdQYpxgfR9hAz3Anqfqvfxr5lm7+wwGnS3bflEMySs6qvUmIW36pj0JwBNE+NQRb5z+4
        aq8VcbLDLN/1q
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr3754735wrt.162.1601379631439;
        Tue, 29 Sep 2020 04:40:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKzxxsBVGHYCgIQf15uys97Fa6esYkknq3/9BEKAgACWqwF2V5Fl06+YX+5R+cJmwzd4Nrdg==
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr3754710wrt.162.1601379631125;
        Tue, 29 Sep 2020 04:40:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t5sm5900337wrb.21.2020.09.29.04.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:40:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     lihaiwei.kernel@gmail.com, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        Haiwei Li <lihaiwei@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v3] KVM: Check the allocation of pv cpu mask
In-Reply-To: <20200925180738.4426-1-lihaiwei.kernel@gmail.com>
References: <20200925180738.4426-1-lihaiwei.kernel@gmail.com>
Date:   Tue, 29 Sep 2020 13:40:29 +0200
Message-ID: <87imbwbyky.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

lihaiwei.kernel@gmail.com writes:

> From: Haiwei Li <lihaiwei@tencent.com>
>
> check the allocation of per-cpu __pv_cpu_mask.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
> v1 -> v2:
>  * add CONFIG_SMP for kvm_send_ipi_mask_allbutself to prevent build error
> v2 -> v3:
>  * always check the allocation of __pv_cpu_mask in kvm_flush_tlb_others
>
>  arch/x86/kernel/kvm.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 9663ba31347c..1e5da6db519c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -553,7 +553,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  static void kvm_setup_pv_ipi(void)
>  {
>  	apic->send_IPI_mask = kvm_send_ipi_mask;
> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;

I see that kvm_send_ipi_mask_allbutself() uses per CPU __pv_cpu_mask and
kvm_send_ipi_mask doesn't but assigning send_IPI_mask here and
send_IPI_mask_allbutself in kvm_alloc_cpumask() looks weird. Personally,
I'd prefet to move apic->send_IPI_mask to kvm_alloc_cpumask() too
(probably call kvm_setup_pv_ipi() and get rid of kvm_apic_init()
completely).

Alternatively, we can save the original apic->send_IPI_mask_allbutself
value to a variable and call it from kvm_send_ipi_mask_allbutself() when
__pv_cpu_mask wasn't allocated.

>  	pr_info("setup PV IPIs\n");
>  }
>  
> @@ -619,6 +618,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>  	struct kvm_steal_time *src;
>  	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>  
> +	if (unlikely(!flushmask)) {
> +		native_flush_tlb_others(cpumask, info);
> +		return;
> +	}
> +
>  	cpumask_copy(flushmask, cpumask);
>  	/*
>  	 * We have to call flush only on online vCPUs. And
> @@ -765,6 +769,14 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
>  
> +static void kvm_free_cpumask(void)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
> +}
> +
>  static __init int kvm_alloc_cpumask(void)
>  {
>  	int cpu;
> @@ -783,11 +795,20 @@ static __init int kvm_alloc_cpumask(void)
>  
>  	if (alloc)
>  		for_each_possible_cpu(cpu) {
> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> -				GFP_KERNEL, cpu_to_node(cpu));
> +			if (!zalloc_cpumask_var_node(
> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
> +				GFP_KERNEL, cpu_to_node(cpu)))
> +				goto zalloc_cpumask_fail;
>  		}
>  
> +#if defined(CONFIG_SMP)
> +	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> +#endif
>  	return 0;
> +
> +zalloc_cpumask_fail:
> +	kvm_free_cpumask();
> +	return -ENOMEM;
>  }
>  arch_initcall(kvm_alloc_cpumask);

-- 
Vitaly

