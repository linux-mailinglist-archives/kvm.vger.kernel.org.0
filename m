Return-Path: <kvm+bounces-42959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9052CA81424
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 19:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24CE3B0F13
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA6023E350;
	Tue,  8 Apr 2025 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQehLTgO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16023DE80
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744134843; cv=none; b=ZN6zHG05LpapvwoZnj+yil/n5mXWrMHjNBQ3CDUUuUM26cO0DgtB3e31VyvFc2fkyo94AKVUMNjxQDxYm/c/hDAuy/lbSsZ1K8JyAN230U3Q0X6/5czwBdT/8+NwM+j8T2O+WEs9b41SlM55gvCoJUxjg1F6DZXHjLGe+N2LXzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744134843; c=relaxed/simple;
	bh=nxR/QwwulzJcKTmYvdkvPJrA6Zg1biT3vi9DMGQMWhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W/cNlcfKOXIc0Qs7XAhuXcl0VZQt+Tqsv8d7FNNb3xn24fTpEghgWIUpFUOBYAEgqqIM5ajarR+HjffSkpF/63Atj9rp8N4I9Uegq6qynGuBUmkFCCLFQJsOTweSQuQD1gm+5nAbSpyiQZXb3lqO0o/42amRfC9A0G6kKfSk8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQehLTgO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744134840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6Qs6Sjtb/mQ7XSt+odQ57p91PpfSig/7toCKtfcX27Y=;
	b=IQehLTgOSKlXTYN5gwa5+1N7AS7Qh36tQcZDS6sfpLgBuy2X835KQehYX1XfjqQSTJVYPn
	vUFtYjHWWEocyGrVSD331db24ni01tBd4klULYOW2v2Y5ufiA783anIi2Q9jeUEoeODF0j
	rPoJepmqMJ4CkbC9QW4sRMyO4Vn27yY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-qqrXuDziMk-mE8FR35euFA-1; Tue, 08 Apr 2025 13:53:59 -0400
X-MC-Unique: qqrXuDziMk-mE8FR35euFA-1
X-Mimecast-MFC-AGG-ID: qqrXuDziMk-mE8FR35euFA_1744134837
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e5d9682f53so5576113a12.2
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 10:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744134837; x=1744739637;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Qs6Sjtb/mQ7XSt+odQ57p91PpfSig/7toCKtfcX27Y=;
        b=fWt/reJPg3PGxd+FB3J8x5P2Lq21GtjRpusG17nnF3skoIIsryEjwvUUCsp9BSDEv9
         v1G/1Ft/n7zjs3bwTNvLUwd5+MbEr4NIZ8Nq6jLW3eMFAUewA9t7pFDhHHv1oH71YCuN
         5P7P62Ce/pm6uOt7Jl+nGfHwtVC/5eXqK+15UUXh1k2IOrc91z/SQYDSQrkR7SyYMgWS
         AVmkJxKp5e1PRctIpPyZdLBvfJ/adCOh9bXmwnlDpKX1yiF8YS+H8GwODE0jl4uSPPjG
         82I3LCRqoU2B9YKDP6e9dZC/UrpodebdneQcoNwVTd5WRdGNUERMbGbNCqDvB80W9dVE
         lLpA==
X-Gm-Message-State: AOJu0Yx35vdqzYO1SX/8R+bcXCeLxaB/jKraqkeU6g6hDHLMhyS+rKcu
	pMLmgqiC57Ob4VICyCarsG6v22Ngt6h2U6+JHWAXHB6AORxC2KZ8cUlLAWC1W3IzgILzqptxi8L
	ETs1cyJJnve4Jjp8IHHfdsH7Qf7i7ilYfylsZjQ3k4/4AF2fy6Q==
X-Gm-Gg: ASbGncuoXbSkmEejD5n32F9AU+WHQJ3CK6OD9vQAOr6RqRVxwIoKDH5jdEmr+08j4G1
	HfltqjgvYT2bOcSjs4/X/PyhqlUIfKVb+0dRpnPKdDQLcPSAoRvzUgWhroJA/YLBfJHkEsDK0jg
	a3OfPDLqNJZsB0wl6S4cWcv1+2vNUccmtT0nUJftctA8GjasLLoEbP9F6T2hXDoHEuN1M+8wqG0
	LjFigzSYU2MWPwp0orinu5mBfgYjNPokW9QDVvTviB5STXrC5ElCWYWeIpWXEpXrYSG5HUNMCat
	AxofFadGNkS+i3IWX9Zp
X-Received: by 2002:a17:907:a4d:b0:ac7:d23d:b3ac with SMTP id a640c23a62f3a-aca9b73bcb6mr11321266b.53.1744134836559;
        Tue, 08 Apr 2025 10:53:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFradihmf+AC4yn3FgdDqXmRXXTm9NS2gH86OwHZ5/1qyQ8qvnZbJExdjvopNVWThCbQOCfRw==
X-Received: by 2002:a17:907:a4d:b0:ac7:d23d:b3ac with SMTP id a640c23a62f3a-aca9b73bcb6mr11317866b.53.1744134836125;
        Tue, 08 Apr 2025 10:53:56 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.197.100])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac7c01c21dbsm937739366b.167.2025.04.08.10.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 10:53:55 -0700 (PDT)
Message-ID: <4c396e79-845a-481a-8a3e-4a7f458371b8@redhat.com>
Date: Tue, 8 Apr 2025 19:53:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 65/67] KVM: SVM: Generate GA log IRQs only if the
 associated vCPUs is blocking
To: Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-66-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250404193923.1413163-66-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 21:39, Sean Christopherson wrote:
> Configure IRTEs to GA log interrupts for device posted IRQs that hit
> non-running vCPUs if and only if the target vCPU is blocking, i.e.
> actually needs a wake event.  If the vCPU has exited to userspace or was
> preempted, generating GA log entries and interrupts is wasteful and
> unnecessary, as the vCPU will be re-loaded and/or scheduled back in
> irrespective of the GA log notification (avic_ga_log_notifier() is just a
> fancy wrapper for kvm_vcpu_wake_up()).
> 
> Use a should-be-zero bit in the vCPU's Physical APIC ID Table Entry to
> track whether or not the vCPU's associated IRTEs are configured to
> generate GA logs, but only set the synthetic bit in KVM's "cache", i.e.
> never set the should-be-zero bit in tables that are used by hardware.
> Use a synthetic bit instead of a dedicated boolean to minimize the odds
> of messing up the locking, i.e. so that all the existing rules that apply
> to avic_physical_id_entry for IS_RUNNING are reused verbatim for
> GA_LOG_INTR.
> 
> Note, because KVM (by design) "puts" AVIC state in a "pre-blocking"
> phase, using kvm_vcpu_is_blocking() to track the need for notifications
> isn't a viable option.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/svm.h |  7 ++++++
>   arch/x86/kvm/svm/avic.c    | 49 +++++++++++++++++++++++++++-----------
>   2 files changed, 42 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 8b07939ef3b9..be6e833bf92c 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -246,6 +246,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>   #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
>   #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
>   
> +/*
> + * GA_LOG_INTR is a synthetic flag that's never propagated to hardware-visible
> + * tables.  GA_LOG_INTR is set if the vCPU needs device posted IRQs to generate
> + * GA log interrupts to wake the vCPU (because it's blocking or about to block).
> + */
> +#define AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR		BIT_ULL(61)
> +
>   #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
>   #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
>   #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1466e66cca6c..0d2a17a74be6 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -798,7 +798,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>   		} else {
>   			pi_data.cpu = -1;
> -			pi_data.ga_log_intr = true;
> +			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
>   		}
>   
>   		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
> @@ -823,7 +823,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   }
>   
>   static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
> -					    bool toggle_avic)
> +					    bool toggle_avic, bool ga_log_intr)
>   {
>   	struct amd_svm_iommu_ir *ir;
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -839,9 +839,9 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
>   
>   	list_for_each_entry(ir, &svm->ir_list, node) {
>   		if (!toggle_avic)
> -			WARN_ON_ONCE(amd_iommu_update_ga(ir->data, cpu, true));
> +			WARN_ON_ONCE(amd_iommu_update_ga(ir->data, cpu, ga_log_intr));
>   		else if (cpu >= 0)
> -			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu, true));
> +			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, cpu, ga_log_intr));
>   		else
>   			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
>   	}
> @@ -875,7 +875,8 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
>   	entry = svm->avic_physical_id_entry;
>   	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>   
> -	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
> +	entry &= ~(AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK |
> +		   AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
>   	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
>   	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>   
> @@ -892,7 +893,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool toggle_avic)
>   
>   	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
>   
> -	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic);
> +	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, toggle_avic, false);
>   
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>   }
> @@ -912,7 +913,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	__avic_vcpu_load(vcpu, cpu, false);
>   }
>   
> -static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
> +static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic,
> +			    bool is_blocking)

What would it look like to use an enum { SCHED_OUT, SCHED_IN, 
ENABLE_AVIC, DISABLE_AVIC, START_BLOCKING } for both __avic_vcpu_put and 
__avic_vcpu_load's second argument?  Consecutive bools are ugly...

Paolo

>   {
>   	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -934,14 +936,28 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, bool toggle_avic)
>   	 */
>   	spin_lock_irqsave(&svm->ir_list_lock, flags);
>   
> -	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic);
> +	avic_update_iommu_vcpu_affinity(vcpu, -1, toggle_avic, is_blocking);
>   
> +	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
> +
> +	/*
> +	 * Keep the previouv APIC ID in the entry so that a rogue doorbell from
> +	 * hardware is at least restricted to a CPU associated with the vCPU.
> +	 */
>   	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> -	svm->avic_physical_id_entry = entry;
>   
>   	if (enable_ipiv)
>   		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
>   
> +	/*
> +	 * Note!  Don't set AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR in the table as
> +	 * it's a synthetic flag that usurps an unused a should-be-zero bit.
> +	 */
> +	if (is_blocking)
> +		entry |= AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
> +
> +	svm->avic_physical_id_entry = entry;
> +
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>   }
>   
> @@ -957,10 +973,15 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>   	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
>   
>   	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
> -	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> -		return;
> +	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)) {
> +		if (WARN_ON_ONCE(!kvm_vcpu_is_blocking(vcpu)))
> +			return;
>   
> -	__avic_vcpu_put(vcpu, false);
> +		if (!(WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR))))
> +			return;
> +	}
> +
> +	__avic_vcpu_put(vcpu, false, kvm_vcpu_is_blocking(vcpu));
>   }
>   
>   void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
> @@ -997,7 +1018,7 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   	if (kvm_vcpu_apicv_active(vcpu))
>   		__avic_vcpu_load(vcpu, vcpu->cpu, true);
>   	else
> -		__avic_vcpu_put(vcpu, true);
> +		__avic_vcpu_put(vcpu, true, true);
>   }
>   
>   void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> @@ -1023,7 +1044,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>   	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
>   	 * to the vCPU while it's scheduled out.
>   	 */
> -	avic_vcpu_put(vcpu);
> +	__avic_vcpu_put(vcpu, false, true);
>   }
>   
>   void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)


