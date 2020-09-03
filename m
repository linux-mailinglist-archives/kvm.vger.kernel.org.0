Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251E225BF33
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgICKkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 06:40:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726678AbgICKkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 06:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599129597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijVYX0z6T27vxR7tJcyTqIs/JuL8BCy4xqW27sy9VD0=;
        b=EQlAWZUakqOmXIVbURaTip1A/ScsUIObiFLq+tMuo+rE3/nYTOL6EkxIBhrTz7lBLxokeH
        vXrnHXr8rxgAHL3ihAVCr/WDOvKyTsKPcOFMcNCi28UhvseOA8ViiTx8KbLfSYIOT/bqUD
        H6soe0WaN93KkUUBD4oMq028jxVnfAI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-qyI1OKB3OUuAbefMbhUdHQ-1; Thu, 03 Sep 2020 06:39:56 -0400
X-MC-Unique: qyI1OKB3OUuAbefMbhUdHQ-1
Received: by mail-wr1-f69.google.com with SMTP id l17so916781wrw.11
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 03:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ijVYX0z6T27vxR7tJcyTqIs/JuL8BCy4xqW27sy9VD0=;
        b=l1jQOjnxErMnyII19IMEwKVB+PrOrhiJewL7EBpStadP46Uk+vC7GWSV8/qXfzBKnX
         9LPnUD6jcUtgKHCgU+95zqmtwBgGT+ZzYgEKaZ4HsmISinigiGQX4mn0hQjiAtez5Am6
         wqziO3MkFMHKsbsF5yyhaz+UgiEHtA4o5s1bPo7Ip2PtlOlvqtkBhmL1YtZLZ6XWIHch
         /TTj7cndVBtz2OlTH2acAnFfKW0ZoJ6E7P2edDfAcz1jL1x4UsslHOCdBgd7fiDsFtep
         mtB28U/nr4Lmm31ZgkUaMESzfHWInRJRVohN/rhq8vckkODCR7DVEnKR4ItTfBTIaRUA
         9YYA==
X-Gm-Message-State: AOAM533NXYn+pjdwJB3ioaHKR6fqR5AYboe6xmcbXIKzbiKirMUZ/fJ6
        OC5p/a3AKuQnwayDxL9Ccv+VgZHG1IRle4qrNTX/bx7BxyoW398QFq8nk5aO7IN9kjve/+7fWPq
        46AgPhcELzeoT
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr1852722wmb.77.1599129595088;
        Thu, 03 Sep 2020 03:39:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG+5x9gTe9dl+reW0WRwFROTb3hPD2uAj+jMHAJIAE/fjZBSDJ9NaJEz5fiA3rL7PHaZa4Ag==
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr1852699wmb.77.1599129594857;
        Thu, 03 Sep 2020 03:39:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a83sm3608921wmh.48.2020.09.03.03.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:39:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>, tglx@linutronix.de,
        mingo@redhat.com, "bp\@alien8.de" <bp@alien8.de>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] KVM: Check the allocation of pv cpu mask
In-Reply-To: <654d8c60-49f0-e398-be25-24aed352360d@gmail.com>
References: <654d8c60-49f0-e398-be25-24aed352360d@gmail.com>
Date:   Thu, 03 Sep 2020 12:39:52 +0200
Message-ID: <87y2lrnnyf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> From: Haiwei Li <lihaiwei@tencent.com>
>
> check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
> successful.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 08320b0b2b27..d3c062e551d7 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const 
> struct cpumask *mask, int vector)
>   static void kvm_setup_pv_ipi(void)
>   {
>   	apic->send_IPI_mask = kvm_send_ipi_mask;
> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>   	pr_info("setup PV IPIs\n");
>   }
>
> @@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
>   	}
>
>   	if (pv_tlb_flush_supported()) {
> -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>   		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>   		pr_info("KVM setup pv remote TLB flush\n");
>   	}
> @@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
>   }
>   arch_initcall(activate_jump_labels);
>
> +static void kvm_free_pv_cpu_mask(void)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
> +}
> +
>   static __init int kvm_alloc_cpumask(void)
>   {
>   	int cpu;
> @@ -785,11 +791,21 @@ static __init int kvm_alloc_cpumask(void)
>
>   	if (alloc)
>   		for_each_possible_cpu(cpu) {
> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> -				GFP_KERNEL, cpu_to_node(cpu));
> +			if (!zalloc_cpumask_var_node(
> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
> +				GFP_KERNEL, cpu_to_node(cpu)))
> +				goto zalloc_cpumask_fail;
>   		}
>
> +#if defined(CONFIG_SMP)
> +	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> +#endif
> +	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;

This is too late I'm afraid. If I'm not mistaken PV patching happens
earlier, so .init.guest_late_init (kvm_guest_init()) is good and
arch_initcall() is bad.

Have you checked that with this patch kvm_flush_tlb_others() is still
being called?

Actually, there is no need to assign kvm_flush_tlb_others() so late. We
can always check if __pv_cpu_mask was allocated and revert back to the
architectural path if not.

>   	return 0;
> +
> +zalloc_cpumask_fail:
> +	kvm_free_pv_cpu_mask();
> +	return -ENOMEM;
>   }
>   arch_initcall(kvm_alloc_cpumask);
>
> --
> 2.18.4
>

-- 
Vitaly

