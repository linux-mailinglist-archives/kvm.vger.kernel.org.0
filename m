Return-Path: <kvm+bounces-44849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0F1AA4289
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E358F174F61
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E35801;
	Wed, 30 Apr 2025 05:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CecAy9iq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4973219E975
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 05:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745991609; cv=none; b=G1r01fVCN3yXQIkZz+TRYdc8JpyB9EGBkOv8NZ1xsGv9Di0E/p4R4wYu35Ti+iKsIgXmXyqTPcIxQd+YVYqpn9GWtw6mrnlgDqwoyy0fFptLR8aMlHMOUQVb/TWiEDybdUPUC26SRU0snBNUm58rVccOPSu3iWvC0Fu6M5uRDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745991609; c=relaxed/simple;
	bh=eTEQYlV/sDxawCxOuu9cT5wEcP22VsX0u/L/5hr9do4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3D2vUFhvgBUsjvIwA8RMTNHXJqPh6KKOTa6S1zLG+cPiC1gJTTLwc1mbNMn1IdIKD6imucnmWFzXYYKXc0l7kvpYhx8dXqULNjypgyan7u52ImIUGTVhkh4ZSqoq72tGM/q3z5gwJDM7DvT/zjxcByqDj0NcxSiu6EE/FJ35vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CecAy9iq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745991606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zVCkZcq4W2ul19Ksyh9bgX6b4WBpBTYFnXA9H5yQHDc=;
	b=CecAy9iqDP2Ht5LzxiMga+462+tq5fl3geUeNNqUbKlVz2aAiLnyFJ5rJfvXnaokX9NhwU
	CuiwiPLQS0VdBhGZHT+wOfRaeIV9FRRTTYRpSoA7yfk0UkjiUBjmsFIV/gmTDpksFLKYyx
	dUy/jeGnANfFtj0jB6SIDiT7ho/Dno8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-MnD0MrEZOluMNjkpyvMMvA-1; Wed, 30 Apr 2025 01:40:04 -0400
X-MC-Unique: MnD0MrEZOluMNjkpyvMMvA-1
X-Mimecast-MFC-AGG-ID: MnD0MrEZOluMNjkpyvMMvA_1745991603
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7391d68617cso591823b3a.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745991603; x=1746596403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVCkZcq4W2ul19Ksyh9bgX6b4WBpBTYFnXA9H5yQHDc=;
        b=NPjWrvglwjFxIEvVvPQwWTvH5bCtxqBoWdbd/EQj2wtnjcdoLd4kGQoGzdG7837BA1
         jny4YNhw/V/3uL6RlR5xWwm65YQouFS4TI1/vKEjg8A7jcKqMbG7Jcx691RRpLndkBOp
         w2IHB9noLMZsmkvZlHzMMj3Nk1UqdZkVTYvFtWCxraONTBrVJa/AXlMeDqC5+5bEHmUL
         kusvaoQSa9HLYOlgOUyP/HirHQN4rB21QUP3hXf5aCGCJf02e09dYIMX31eZYEhgGVVd
         CI65Y4LIw6aIAAi5Qi0gI5u9yxim4OKfEBAIt5eKIJSLg0/QPttLeKSuXG2y4ye9jWg4
         Ypgw==
X-Forwarded-Encrypted: i=1; AJvYcCXIQF2EKP3Cnutlg4HJY6YA923W/cZBltR55IHGbZ6qgiAIG19r0L63iqGW1rfaahnaHyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YylKhJJKkeavpbL8QRkT8ARIoB/HwjEfcENhRo/YwbqgMG2AkPV
	+kDnfGhkZLc8ed4yPQli2U7KSXiZDWnERVdz7oTh+R0B7rWUT7JpJ7N3ku5lPxmqF6mnqxy7ZaO
	If0eWyz42wkOAhDvm8v6CFVsLviWOgSfmm1ts7cOJ9+zATEZZ+A==
X-Gm-Gg: ASbGncv26Rh6+72P1YlRWd3HBxZ8S+zSyD9gA/qGae8ndtQdzRSVHBMR3vnYT8zI3PJ
	mvAav1izUmU3al03qyOaO7xtd8HCpJssaW4ZBnpH1OJG+ZVvzt3Lkm9S3P+HAi1KxNZNPCLID7u
	klZ8bJSiMiNv0Gq5QP1hFltHzJ/pcS6Pd6fSwJ4PBiJAprGfiiovNQg8UixLFN0ddg/SWC0473Z
	MdvDVYztRW0SRcBX9jMhMkBlrC0FPDB6ahRV2xzS/olLQHogpAhEmbpIxsOoowHCfgMcN8dBojZ
	9eVf6yinVmAF
X-Received: by 2002:a05:6a20:7f88:b0:1ee:ab52:b8cc with SMTP id adf61e73a8af0-20a915f164amr2378386637.21.1745991602766;
        Tue, 29 Apr 2025 22:40:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdwByPhzYXp+S8Y6x/vmCL8M+UXiqBvRqA0xKJ3OpwWpUfMpKnj3ruZKm4F1zTZtrrmYx6zQ==
X-Received: by 2002:a05:6a20:7f88:b0:1ee:ab52:b8cc with SMTP id adf61e73a8af0-20a915f164amr2378332637.21.1745991602253;
        Tue, 29 Apr 2025 22:40:02 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f76f4219sm9892611a12.6.2025.04.29.22.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:40:01 -0700 (PDT)
Message-ID: <1802ffb9-798a-4c48-8420-c046f86c548c@redhat.com>
Date: Wed, 30 Apr 2025 15:39:52 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/43] arm64: RME: ioctls to create and configure
 realms
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-8-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_RD ioctl to create a realm. This involves
> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
> 
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created. Configuration options can be classified as:
> 
>   1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
>      entry level, entry level RTTs, number of RTTs in start level, LPA2)
>      Most of these are not measured by RMM and comes from KVM book
>      keeping.
> 
>   2. Parameters controlling "Arm Architecture features for the VM". (e.g.
>      SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
>      using the "user ID register write" mechanism. These will be
>      supported in the later patches.
> 
>   3. Parameters are not part of the core Arm architecture but defined
>      by the RMM spec (e.g. Hash algorithm for measurement,
>      Personalisation value). These are programmed via
>      KVM_CAP_ARM_RME_CONFIG_REALM.
> 
> For the IPA size there is the possibility that the RMM supports a
> different size to the IPA size supported by KVM for normal guests. At
> the moment the 'normal limit' is exposed by KVM_CAP_ARM_VM_IPA_SIZE and
> the IPA size is configured by the bottom bits of vm_type in
> KVM_CREATE_VM. This means that it isn't easy for the VMM to discover
> what IPA sizes are supported for Realm guests. Since the IPA is part of
> the measurement of the realm guest the current expectation is that the
> VMM will be required to pick the IPA size demanded by attestation and
> therefore simply failing if this isn't available is fine. An option
> would be to expose a new capability ioctl to obtain the RMM's maximum
> IPA size if this is needed in the future.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v7:
>   * Minor code cleanup following Gavin's review.
> Changes since v6:
>   * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
>     host page size to be larger than 4k while still communicating with an
>     RMM which uses 4k granules.
> Changes since v5:
>   * Introduce free_delegated_granule() to replace many
>     undelegate/free_page() instances and centralise the comment on
>     leaking when the undelegate fails.
>   * Several other minor improvements suggested by reviews - thanks for
>     the feedback!
> Changes since v2:
>   * Improved commit description.
>   * Improved return failures for rmi_check_version().
>   * Clear contents of PGD after it has been undelegated in case the RMM
>     left stale data.
>   * Minor changes to reflect changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   5 +
>   arch/arm64/include/asm/kvm_rme.h     |  19 ++
>   arch/arm64/kvm/arm.c                 |  16 ++
>   arch/arm64/kvm/mmu.c                 |  22 +-
>   arch/arm64/kvm/rme.c                 | 319 +++++++++++++++++++++++++++
>   5 files changed, 379 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 1c43a4fc25dd..4ee6c215da82 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -699,6 +699,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>   	return READ_ONCE(kvm->arch.realm.state);
>   }
>   
> +static inline bool kvm_realm_is_created(struct kvm *kvm)
> +{
> +	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
> +}
> +
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	return false;
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 9c8a0b23e0e4..5dc1915de891 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,8 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <uapi/linux/kvm.h>
> +
>   /**
>    * enum realm_state - State of a Realm
>    */
> @@ -46,11 +48,28 @@ enum realm_state {
>    * struct realm - Additional per VM data for a Realm
>    *
>    * @state: The lifetime state machine for the realm
> + * @rd: Kernel mapping of the Realm Descriptor (RD)
> + * @params: Parameters for the RMI_REALM_CREATE command
> + * @num_aux: The number of auxiliary pages required by the RMM
> + * @vmid: VMID to be used by the RMM for the realm
> + * @ia_bits: Number of valid Input Address bits in the IPA
>    */
>   struct realm {
>   	enum realm_state state;
> +
> +	void *rd;
> +	struct realm_params *params;
> +
> +	unsigned long num_aux;
> +	unsigned int vmid;
> +	unsigned int ia_bits;
>   };
>   
>   void kvm_init_rme(void);
> +u32 kvm_realm_ipa_limit(void);
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int kvm_init_realm_vm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);
>   
>   #endif /* __ASM_KVM_RME_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 856a721d41ac..0e8482fdc4d3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -136,6 +136,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		mutex_lock(&kvm->lock);
> +		r = kvm_realm_enable_cap(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -198,6 +203,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>   
> +	/* Initialise the realm bits after the generic bits are enabled */
> +	if (kvm_is_realm(kvm)) {
> +		ret = kvm_init_realm_vm(kvm);
> +		if (ret)
> +			goto err_free_cpumask;
> +	}
> +
>   	return 0;
>   
>   err_free_cpumask:
> @@ -257,6 +269,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_unshare_hyp(kvm, kvm + 1);
>   
>   	kvm_arm_teardown_hypercalls(kvm);
> +	kvm_destroy_realm(kvm);
>   }
>   
>   static bool kvm_has_full_ptr_auth(void)
> @@ -405,6 +418,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
>   		r = BIT(0);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		r = static_key_enabled(&kvm_rme_is_available);
> +		break;
>   	default:
>   		r = 0;
>   	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2feb6c6b63af..5957a07de86d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -876,12 +876,16 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.icache_inval_pou	= invalidate_icache_guest_page,
>   };
>   
> -static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
> +static int kvm_init_ipa_range(struct kvm *kvm,
> +			      struct kvm_s2_mmu *mmu, unsigned long type)
>   {
>   	u32 kvm_ipa_limit = get_kvm_ipa_limit();
>   	u64 mmfr0, mmfr1;
>   	u32 phys_shift;
>   
> +	if (kvm_is_realm(kvm))
> +		kvm_ipa_limit = kvm_realm_ipa_limit();
> +
>   	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>   		return -EINVAL;
>   
> @@ -946,7 +950,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   		return -EINVAL;
>   	}
>   
> -	err = kvm_init_ipa_range(mmu, type);
> +	err = kvm_init_ipa_range(kvm, mmu, type);
>   	if (err)
>   		return err;
>   
> @@ -1072,6 +1076,20 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	struct kvm_pgtable *pgt = NULL;
>   
>   	write_lock(&kvm->mmu_lock);
> +	if (kvm_is_realm(kvm) &&
> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		/* Tearing down RTTs will be added in a later patch */
> +		write_unlock(&kvm->mmu_lock);
> +
> +		/*
> +		 * The physical PGD pages are delegated to the RMM, so cannot
> +		 * be freed at this point. This function will be called again
> +		 * from kvm_destroy_realm() after the physical pages have been
> +		 * returned at which point the memory can be freed.
> +		 */
> +		return;
> +	}
>   	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 67cf2d94cb2d..dbb6521fe380 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -5,9 +5,23 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/rmi_cmds.h>
>   #include <asm/virt.h>
>   
> +#include <asm/kvm_pgtable.h>
> +
> +static unsigned long rmm_feat_reg0;
> +
> +#define RMM_PAGE_SHIFT		12
> +#define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
> +
> +static bool rme_has_feature(unsigned long feature)
> +{
> +	return !!u64_get_bits(rmm_feat_reg0, feature);
> +}
> +
>   static int rmi_check_version(void)
>   {
>   	struct arm_smccc_res res;
> @@ -42,6 +56,305 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +u32 kvm_realm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
> +static int get_start_level(struct realm *realm)
> +{
> +	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> +}
> +
> +static void free_delegated_granule(phys_addr_t phys)
> +{
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return;
> +	}
> +
> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +}
> +
> +/* Calculate the number of s2 root rtts needed */
> +static int realm_num_root_rtts(struct realm *realm)
> +{
> +	unsigned int ipa_bits = realm->ia_bits;
> +	unsigned int levels = 3 - get_start_level(realm);
> +	unsigned int sl_ipa_bits = (levels + 1) * (RMM_PAGE_SHIFT - 3) +
> +				   RMM_PAGE_SHIFT;
> +
> +	if (sl_ipa_bits >= ipa_bits)
> +		return 1;
> +
> +	return 1 << (ipa_bits - sl_ipa_bits);
> +}
> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int i, r;
> +	int rtt_num_start;
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	rtt_num_start = realm_num_root_rtts(realm);
> +
> +	if (WARN_ON(realm->rd || !realm->params))
> +		return -EEXIST;
> +
> +	if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
> +		return -EINVAL;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_granule_delegate(rd_phys)) {
> +		r = -ENXIO;
> +		goto free_rd;
> +	}
> +
> +	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (rmi_granule_delegate(pgd_phys)) {
> +			r = -ENXIO;
> +			goto out_undelegate_tables;
> +		}
> +	}
> +
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = rtt_num_start;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +	params->vmid = realm->vmid;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +		WARN_ON(rmi_realm_destroy(rd_phys));
> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	while (i > 0) {
> +		i -= RMM_PAGE_SIZE;
> +
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
> +			/* Leak the pages if they cannot be returned */
> +			kvm->arch.mmu.pgt = NULL;
> +			break;
> +		}
> +	}
> +	if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
> +		/* Leak the page if it isn't returned */
> +		return r;
> +	}
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +
> +/* Protects access to rme_vmid_bitmap */
> +static DEFINE_SPINLOCK(rme_vmid_lock);
> +static unsigned long *rme_vmid_bitmap;
> +
> +static int rme_vmid_init(void)
> +{
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
> +	if (!rme_vmid_bitmap) {
> +		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rme_vmid_reserve(void)
> +{
> +	int ret;
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	spin_lock(&rme_vmid_lock);
> +	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
> +	spin_unlock(&rme_vmid_lock);
> +
> +	return ret;
> +}
> +
> +static void rme_vmid_release(unsigned int vmid)
> +{
> +	spin_lock(&rme_vmid_lock);
> +	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
> +	spin_unlock(&rme_vmid_lock);
> +}
> +
> +static int kvm_create_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	int ret;
> +
> +	if (!kvm_is_realm(kvm))
> +		return -EINVAL;

This check is duplicate because the only caller kvm_realm_enable_cap() already
has the check. So it can be dropped.

> +	if (kvm_realm_is_created(kvm))
> +		return -EEXIST;
> +
> +	ret = rme_vmid_reserve();
> +	if (ret < 0)
> +		return ret;
> +	realm->vmid = ret;
> +
> +	ret = realm_create_rd(kvm);
> +	if (ret) {
> +		rme_vmid_release(realm->vmid);
> +		return ret;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
> +
> +	/* The realm is up, free the parameters.  */
> +	free_page((unsigned long)realm->params);
> +	realm->params = NULL;
> +
> +	return 0;
> +}
> +
> +static int config_realm_hash_algo(struct realm *realm,
> +				  struct arm_rme_config *cfg)
> +{
> +	switch (cfg->hash_algo) {
> +	case ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA256:
> +		if (!rme_has_feature(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
> +			return -EINVAL;
> +		break;
> +	case ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA512:
> +		if (!rme_has_feature(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	realm->params->hash_algo = cfg->hash_algo;
> +	return 0;
> +}
> +
> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	struct arm_rme_config cfg;
> +	struct realm *realm = &kvm->arch.realm;
> +	int r = 0;
> +
> +	if (kvm_realm_is_created(kvm))
> +		return -EBUSY;
> +
> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
> +		return -EFAULT;
> +
> +	switch (cfg.cfg) {
> +	case ARM_RME_CONFIG_RPV:
> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
> +		break;
> +	case ARM_RME_CONFIG_HASH_ALGO:
> +		r = config_realm_hash_algo(realm, &cfg);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +	return r;
> +}
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r = 0;
> +
> +	if (!kvm_is_realm(kvm))
> +		return -EINVAL;
> +
> +	switch (cap->args[0]) {
> +	case KVM_CAP_ARM_RME_CONFIG_REALM:
> +		r = kvm_rme_config_realm(kvm, cap);
> +		break;
> +	case KVM_CAP_ARM_RME_CREATE_REALM:
> +		r = kvm_create_realm(kvm);
> +		break;
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int i;
> +
> +	if (realm->params) {
> +		free_page((unsigned long)realm->params);
> +		realm->params = NULL;
> +	}
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
> +
> +	if (realm->rd) {
> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +
> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
> +			return;
> +		free_delegated_granule(rd_phys);
> +		realm->rd = NULL;
> +	}
> +
> +	rme_vmid_release(realm->vmid);
> +
> +	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> +			return;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
> +	/* Now that the Realm is destroyed, free the entry level RTTs */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	kvm->arch.realm.params = (void *)get_zeroed_page(GFP_KERNEL);
> +
> +	if (!kvm->arch.realm.params)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
>   void kvm_init_rme(void)
>   {
>   	if (PAGE_SIZE != SZ_4K)
> @@ -52,5 +365,11 @@ void kvm_init_rme(void)
>   		/* Continue without realm support */
>   		return;
>   
> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
> +		return;
> +
> +	if (rme_vmid_init())
> +		return;
> +
>   	/* Future patch will enable static branch kvm_rme_is_available */
>   }

Thanks,
Gavin


