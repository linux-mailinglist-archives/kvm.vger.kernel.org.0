Return-Path: <kvm+bounces-42958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 510D2A8141A
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 19:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 093303B27DD
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C8623ED74;
	Tue,  8 Apr 2025 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQac4EFn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1980B23E34B
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 17:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744134692; cv=none; b=NVgMIegkzDVA4YeqIrwnye1hXYb3RdLtBQOBAM3wYsn2qGVPcgoIFjiWat7MVgyVx6LSMgejLGA4vhtNGBHnK54hTHK4cebZKRWvDnXrJ2c/JW+SE+OyY3tIItvTSys4LA3R92pI9gFwxpIzoERTLZn16fbPMqWG6vPLXwjjaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744134692; c=relaxed/simple;
	bh=O9yVBnVA0VV37RgA5y4nQzjG05tKLNm5p8JUvBWBnOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5rVZDecATcoO+UHMRpTSubewMf7CwdD7vsecxrGFmCTflY8fErMhvfgJfvq8RR7O81THRP27ppfu5zp6WERGP2HB3Xi6TOJdHHHqYTRf5VK4f9BCXSjRRlfyg0SQGKqZMlQiiM/xuaEybQAmOaFdZ40+aIJZ41jSGNjJsNIic0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQac4EFn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744134689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jVmRUiQDLWJ203tqLnD/OuMwczvhDUm4XHoxY85XOIs=;
	b=PQac4EFnCGphPfQxnflW2uO0RsuTanvFT+Sq0DWMQv5kBCRkHzJCOoK8Wrenu7tduSPk3I
	34GyKMNlQUGVCHPq71kRXAd9/Hk6TmPzelVS89SYy3NL9RSndJrXRPkjsWwT3VCdHgy6p7
	PPIri5LX4hWjsYKg6opoH6qBxskse28=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-rbOwR_orMxCz1oKTqlrl9g-1; Tue, 08 Apr 2025 13:51:28 -0400
X-MC-Unique: rbOwR_orMxCz1oKTqlrl9g-1
X-Mimecast-MFC-AGG-ID: rbOwR_orMxCz1oKTqlrl9g_1744134687
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac3d175fe71so394895766b.0
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 10:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744134687; x=1744739487;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jVmRUiQDLWJ203tqLnD/OuMwczvhDUm4XHoxY85XOIs=;
        b=Hi4aNCP2onimMYKuFsczM8i5EyiokSMdC36TGDH0WK0pbXy9wXYNZVekcHiwibL4Zr
         nJW9Vlo2ydV8LYUYBwxv+OQs7BoEUmCJoqUY+aVwo66UtYHSMIEad76Q5f+4dnMBwURr
         IgZ0QDKXfkP14t92PTgd3cSt8/Ce6jqQkMQlxghN8PkhD41fSqpuklsR38jRMX00iDHe
         sKIFJHPsh4jtmH6gl8R8ITxR5FuBjpvZ4/iEpez5Dnr3PZjESYzmGthMX74xv/LpRpKf
         gWMQ3ZfJNWe5o/HxcnP7r8+etOdZTxslHtXKfxWm84Qon3jOf5makPuhg7gks1ODhu3s
         7NQg==
X-Gm-Message-State: AOJu0YxTLeY4Jf/bhzY/RlnvgbvVkM6lhCYfxQxRoEQECohQw7QMWCWj
	gmyU0yLNRxDgfu+a9YEqY/SYWkq5dIG5NIyfoCRSiEfCNBUH5jbS61K0x5UWWauZ/dzZ/Jzk+3D
	SbULwPmK+PUXBzYcJj1rwiTieLieUvfHkSaaViKr6jzbqJIOm9g==
X-Gm-Gg: ASbGncvc3kGMnrpTm68yKzLIXUSSHJVABnrNQ0W0MjYTdnC3XFBiL6iGdzuyYLJKT06
	932gCKciJYzsz91DcGRX5vEDzyh+vDKcolZuM0692HKlAjeHdbVBppF0pFClxvFDfpK4Y4laXSX
	nofffPhgghc0zuIbnqIGJj/d+m7PKdLsr55eAHxfaXrqxKyHqXaLw89mw88shM+UKmYGz1ztMlC
	ANCoVG9U+F9twhYCDIpIQUOidrvlGZbnhTHmaMdgw89f+9dAVQlQKuHirf/Xi50cL4LgIZUVvS3
	zQRNTRFTEkjTvDyGpXSI
X-Received: by 2002:a17:907:3f26:b0:ac7:3817:d8da with SMTP id a640c23a62f3a-aca9b7718b1mr8156266b.52.1744134687060;
        Tue, 08 Apr 2025 10:51:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEAzVZ7/qwQFMPt/QXOHxFTFozQku5BHeCETp2tWjKJ3IsbjhXd6GGXO545EnliOM3B7HwGA==
X-Received: by 2002:a17:907:3f26:b0:ac7:3817:d8da with SMTP id a640c23a62f3a-aca9b7718b1mr8153966b.52.1744134686436;
        Tue, 08 Apr 2025 10:51:26 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.197.100])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac7bfea10f6sm945030566b.71.2025.04.08.10.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 10:51:25 -0700 (PDT)
Message-ID: <d3bdaa2e-c268-4828-8f85-75fd0f859887@redhat.com>
Date: Tue, 8 Apr 2025 19:51:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 62/67] KVM: SVM: Don't check vCPU's blocking status when
 toggling AVIC on/off
To: Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-63-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250404193923.1413163-63-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 21:39, Sean Christopherson wrote:
> Don't query a vCPU's blocking status when toggling AVIC on/off; barring
> KVM bugs, the vCPU can't be blocking when refrecing AVIC controls.  And if

refrecing -> refreshing

Paolo

> there are KVM bugs, ensuring the vCPU and its associated IRTEs are in the
> correct state is desirable, i.e. well worth any overhead in a buggy
> scenario.
> 
> Isolating the "real" load/put flows will allow moving the IOMMU IRTE
> (de)activation logic from avic_refresh_apicv_exec_ctrl() to
> avic_update_iommu_vcpu_affinity(), i.e. will allow updating the vCPU's
> physical ID entry and its IRTEs in a common path, under a single critical
> section of ir_list_lock.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 65 +++++++++++++++++++++++------------------
>   1 file changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 0425cc374a79..d5fa915d0827 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -838,7 +838,7 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
>   		WARN_ON_ONCE(amd_iommu_update_ga(cpu, ir->data));
>   }
>   
> -void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>   	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   	int h_physical_id = kvm_cpu_get_apicid(cpu);
> @@ -854,16 +854,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
>   		return;
>   
> -	/*
> -	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
> -	 * is being scheduled in after being preempted.  The CPU entries in the
> -	 * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
> -	 * If the vCPU was migrated, its new CPU value will be stuffed when the
> -	 * vCPU unblocks.
> -	 */
> -	if (kvm_vcpu_is_blocking(vcpu))
> -		return;
> -
>   	/*
>   	 * Grab the per-vCPU interrupt remapping lock even if the VM doesn't
>   	 * _currently_ have assigned devices, as that can change.  Holding
> @@ -898,31 +888,33 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>   }
>   
> -void avic_vcpu_put(struct kvm_vcpu *vcpu)
> +void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
> +	 * is being scheduled in after being preempted.  The CPU entries in the
> +	 * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
> +	 * If the vCPU was migrated, its new CPU value will be stuffed when the
> +	 * vCPU unblocks.
> +	 */
> +	if (kvm_vcpu_is_blocking(vcpu))
> +		return;
> +
> +	__avic_vcpu_load(vcpu, cpu);
> +}
> +
> +static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	unsigned long flags;
> -	u64 entry;
> +	u64 entry = svm->avic_physical_id_entry;
>   
>   	lockdep_assert_preemption_disabled();
>   
>   	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
>   		return;
>   
> -	/*
> -	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
> -	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
> -	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
> -	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
> -	 * recursively.
> -	 */
> -	entry = svm->avic_physical_id_entry;
> -
> -	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
> -	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> -		return;
> -
>   	/*
>   	 * Take and hold the per-vCPU interrupt remapping lock while updating
>   	 * the Physical ID entry even though the lock doesn't protect against
> @@ -942,7 +934,24 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>   		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
>   
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> +}
>   
> +void avic_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
> +	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
> +	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
> +	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
> +	 * recursively.
> +	 */
> +	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
> +
> +	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
> +	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> +		return;
> +
> +	__avic_vcpu_put(vcpu);
>   }
>   
>   void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
> @@ -983,9 +992,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   	avic_refresh_virtual_apic_mode(vcpu);
>   
>   	if (activated)
> -		avic_vcpu_load(vcpu, vcpu->cpu);
> +		__avic_vcpu_load(vcpu, vcpu->cpu);
>   	else
> -		avic_vcpu_put(vcpu);
> +		__avic_vcpu_put(vcpu);
>   
>   	/*
>   	 * Here, we go through the per-vcpu ir_list to update all existing


