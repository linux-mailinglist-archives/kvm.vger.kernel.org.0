Return-Path: <kvm+bounces-37075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9ACA24C76
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 03:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61F80164506
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 02:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA7F1C6B4;
	Sun,  2 Feb 2025 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/Rthgzn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87060DDBC
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 02:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462020; cv=none; b=lqKUp0R7FjwJBwLuIxAc/d4g+vWFxm/eYP4drC37vqRcsLtBtpsgoUGsz4IS+/IQs1ZEQFBUsBCO/6dZ4c2ESXsY/kKCikkRLqu3UcOckAMMPN2LNGVD+2/9RDHYCm3Q2eisutc7Df/KAdHgSJvmVxTvIDQP3/WLFPtQwf5iJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462020; c=relaxed/simple;
	bh=Cv+rYeVYUucgFkd9j+IahXxjPtJ2f4F7GoUBqwxuulM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nft3cy9mnbuyOm2HzFvhBfsjkfSSPvBbehKqcYOvuvvy4259J/s9nZj0OdnDpYpl9kZ3zSfxkRRWJwo3F7e9pljzaJxCZwsYZPpcUZ4tXLC+ebnfOYbEdextrebH5XtaDApW5DJoQgUy8nGtHmzEEajw32gP8RIR/JemRESp1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/Rthgzn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sSlKml/+kejUBtq+rKq08KSBVq8nnU94jjP3M+wY8SY=;
	b=f/Rthgzn84xgwTDoR62H7DK8W7vCrAatAD/mhxU8frJXZrAB8DnAsK28qncwuBAZ2ewTdn
	QuLsdoTOP3QCzHMKuU8X3BaB3lK3r2s/9MVDok2K5NnHYwNQHaNhhRF4QrrO6G23VdWlsp
	/YdqztwtH8r77yq4X7T4VRuqsmgo/yc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-_HiGa89MMJ6gMeAArypyMA-1; Sat, 01 Feb 2025 21:06:55 -0500
X-MC-Unique: _HiGa89MMJ6gMeAArypyMA-1
X-Mimecast-MFC-AGG-ID: _HiGa89MMJ6gMeAArypyMA
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-218ad674181so89588585ad.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 18:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462014; x=1739066814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSlKml/+kejUBtq+rKq08KSBVq8nnU94jjP3M+wY8SY=;
        b=pjfcmdeuuXdHp3CyM3N1XnRqzGa/8ZMPbcv23Vf2KyERPKZ9lqnSDrHL2/H99bI3N9
         T2N1Ev4R+nSTIvvooLSVvsk41vxUWdmX8rnVBdZmz8Ymt8qfJfVygPQQW7PQbHVvMSw3
         ATaD3RGPdvRIobez2p85t1fFKm+oCRnrOEZkNVqbTd/9U5ibVpf5QhWuGEZ4D9NhrO3S
         E0ac7CUfcb+bhl0+cfL54PL8V/WBzSrRTmESyNzbDtIXxdX/4ByxeLw8fgwBXSmn51TX
         H4vEeTg/0B+urTSUXTe29Y3o22EkMv+CqQ49ZFKPNQfrRw+HbGoXbI40odVAMnEF1mWP
         G5BA==
X-Forwarded-Encrypted: i=1; AJvYcCX881V70BHX+VJgt/q5s5xw9SwW+AWGx7gQCP5buD4ox++DG5A4FOpA/ORLr3aOJBNRti8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx324390/nQaNuViaFo0y0DX8OlMS+5qowjbw/a3wQh0hXVPHaN
	z1IqQrMtp6vEsDRM7XkLGC/yM6OVaqmsB3rPb7g7Og7+WFsdUzzl+o3OW0e1QevyjBzmhJxlb95
	F2aVzuzAttVi41zN9MEJSRM8Rw5YBi/YpV3/aQMmsJgzFpxthBA==
X-Gm-Gg: ASbGncvG/0EiBfsZlsZqfbY+PJTpfzKEQxebz5+ZoX+IVDwqb4z8Ul+Sw2ZRiBL0abk
	+FNnD8R0+cJHAJfbR69O8tRpIpqKkeE1FNLRNc8lLkB2L6PbZ3QYsJO522IWwnx35QwWLcRBQIC
	Jyj3qp2IAtKhrwnHz6+8AxMe00aptbvhPeLwq98esXmTztqyG74RjHXebD3Wsefvu/+r9JiTIFl
	g17H9cUcm8lbvj/rkuInP+uWiFUow0oCLEGeTSaXXk5erwW9wiSGejD1Mtnv8SPI1wfZQAoLYfX
	vF+8LA==
X-Received: by 2002:a05:6300:7111:b0:1ed:a4b1:9124 with SMTP id adf61e73a8af0-1eda4b195bcmr6482932637.8.1738462014128;
        Sat, 01 Feb 2025 18:06:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuAmakbdVZEYfdxlzFY/5lw1yKumpAmcjFfn5o/6n2SOgtQbAy8hTNJJ7loIVoDWvimSAuIQ==
X-Received: by 2002:a05:6300:7111:b0:1ed:a4b1:9124 with SMTP id adf61e73a8af0-1eda4b195bcmr6482907637.8.1738462013708;
        Sat, 01 Feb 2025 18:06:53 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631bf29sm5625326b3a.20.2025.02.01.18.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:06:53 -0800 (PST)
Message-ID: <489025af-a0c3-449f-a746-f898b77fc660@redhat.com>
Date: Sun, 2 Feb 2025 12:06:44 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/43] KVM: arm64: Handle Realm PSCI requests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-24-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-24-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM needs to be informed of the target REC when a PSCI call is made
> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
> is handled by it.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  3 +++
>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
>   arch/arm64/kvm/psci.c            | 29 +++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             | 15 +++++++++++++++
>   4 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 158f77e24a26..90a4537ad38d 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -113,6 +113,9 @@ int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			unsigned long addr, unsigned long end,
>   			unsigned long ripas,
>   			unsigned long *top_ipa);
> +int realm_psci_complete(struct kvm_vcpu *calling,
> +			struct kvm_vcpu *target,
> +			unsigned long status);
>   

The 'calling' may be renamed to 'source', consistent to the names in arch/arm64/kvm/psci.c.
Other nitpicks can be found below.

>   #define RMM_RTT_BLOCK_LEVEL	2
>   #define RMM_RTT_MAX_LEVEL	3
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f588b528c3f9..eff1a4ec892b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1745,6 +1745,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>   }
>   
> +static int kvm_arm_vcpu_rmm_psci_complete(struct kvm_vcpu *vcpu,
> +					  struct kvm_arm_rmm_psci_complete *arg)
> +{
> +	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
> +
> +	if (!target)
> +		return -EINVAL;
> +
> +	/*
> +	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
> +	 * for the status. But, let us leave it to the RMM to filter
> +	 * for making this future proof.
> +	 */
> +	return realm_psci_complete(vcpu, target, arg->psci_status);
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -1867,6 +1883,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   
>   		return kvm_arm_vcpu_finalize(vcpu, what);
>   	}
> +	case KVM_ARM_VCPU_RMM_PSCI_COMPLETE: {
> +		struct kvm_arm_rmm_psci_complete req;
> +
> +		if (!kvm_is_realm(vcpu->kvm))
> +			return -EINVAL;

We probably need to check with vcpu_is_rec(). -EPERM seems more precise
than -EINVAL.

> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_rmm_psci_complete(vcpu, &req);
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3b5dbe9a0a0e..9dc161abc30c 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   	reset_state->reset = true;
>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +	/*
> +	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
> +	 * scheduled.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
>   
>   	/*
>   	 * Make sure the reset request is observed if the RUNNABLE mp_state is
> @@ -115,6 +121,10 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   out_unlock:
>   	spin_unlock(&vcpu->arch.mp_state_lock);
> +	if (vcpu_is_rec(vcpu) && ret != PSCI_RET_SUCCESS)
> +		realm_psci_complete(source_vcpu, vcpu,
> +				    ret == PSCI_RET_ALREADY_ON ?
> +				    PSCI_RET_SUCCESS : PSCI_RET_DENIED);

{} is needed here.

>   	return ret;
>   }
>   
> @@ -142,6 +152,25 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>   	/* Ignore other bits of target affinity */
>   	target_affinity &= target_affinity_mask;
>   
> +	if (vcpu_is_rec(vcpu)) {
> +		struct kvm_vcpu *target_vcpu;
> +
> +		/* RMM supports only zero affinity level */
> +		if (lowest_affinity_level != 0)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
> +		if (!target_vcpu)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		/*
> +		 * Provide the references of running and target RECs to the RMM
                                              ^^^^^^^
                                              the source
> +		 * so that the RMM can complete the PSCI request.
> +		 */
> +		realm_psci_complete(vcpu, target_vcpu, PSCI_RET_SUCCESS);
> +		return PSCI_RET_SUCCESS;
> +	}
> +
>   	/*
>   	 * If one or more VCPU matching target affinity are running
>   	 * then ON else OFF
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 146ef598a581..5831d379760a 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -118,6 +118,21 @@ static void free_delegated_granule(phys_addr_t phys)
>   	free_page((unsigned long)phys_to_virt(phys));
>   }
>   
> +int realm_psci_complete(struct kvm_vcpu *calling, struct kvm_vcpu *target,
> +			unsigned long status)
> +{
> +	int ret;
> +
> +	ret = rmi_psci_complete(virt_to_phys(calling->arch.rec.rec_page),
> +				virt_to_phys(target->arch.rec.rec_page),
> +				status);
> +
         ^^^^^
Unnecessary blank line.

> +	if (ret)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int realm_rtt_create(struct realm *realm,
>   			    unsigned long addr,
>   			    int level,

Thanks,
Gavin


