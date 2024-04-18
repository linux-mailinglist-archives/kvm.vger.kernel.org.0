Return-Path: <kvm+bounces-15061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 585A38A9602
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A60E2847E8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D89915B157;
	Thu, 18 Apr 2024 09:23:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF4B15EFD2;
	Thu, 18 Apr 2024 09:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432222; cv=none; b=QhabjB5Eag/ajhSeurADfUxk4K/8b7oOFz+4jpnra6Avmk4xPs033c8swLxW27HJWjT1kdGs1Eo9ZphcdM5lVxDJQgtB+wBxG9Rr++UgYQtsD4hjCYYWoAemKsw9o88BwexUIyMtEBlOC0ocm9tk7OEZpLABJonmJ1oVideYZEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432222; c=relaxed/simple;
	bh=OH+74VFa5Lmuf9FRrVDGvrVSNIzV/ol9B/HVoqNNo/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYQ9BO3UC0CpWKu/pJZFf60mY34vp3tQ4m+GJwcaLjq+VcHls243uSo/WhRMiJ8rO+sFP3evYVBo4kgTKuRDj+OCDHr3jAG9nZaebDDOObxxliJK8rjMXPY4ggq969J8hfVygjrjDffAHQbTckuFO7ClxVVsg+5cyxv9jFtHeNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5122A339;
	Thu, 18 Apr 2024 02:24:07 -0700 (PDT)
Received: from [10.57.84.16] (unknown [10.57.84.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 250513F64C;
	Thu, 18 Apr 2024 02:23:37 -0700 (PDT)
Message-ID: <70c38786-445c-4818-b04d-0ff5a7cc48bf@arm.com>
Date: Thu, 18 Apr 2024 10:23:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/43] arm64: RME: Allocate/free RECs to match vCPUs
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-15-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 

May be a good idea to add a note about the AUX granules, to help the
reader with the context.

RECs must be supplied with additional pages (AUX Granules) for storing
the larger registers state (e.g., SVE). The number of AUX granules for
a REC depends on the "parameters" with which the Realm was created.

Also the register states for the REC cannot be modified by KVM after the
REC is created.




> See Realm Management Monitor specification (DEN0137) for more information:
> https://developer.arm.com/documentation/den0137/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   2 +
>   arch/arm64/include/asm/kvm_host.h    |   3 +
>   arch/arm64/include/asm/kvm_rme.h     |  18 ++++
>   arch/arm64/kvm/arm.c                 |   2 +
>   arch/arm64/kvm/reset.c               |  11 ++
>   arch/arm64/kvm/rme.c                 | 150 +++++++++++++++++++++++++++
>   6 files changed, 186 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c606316f4729..2209a7c6267f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -631,6 +631,8 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return vcpu->arch.rec.mpidr != INVALID_HWID;
>   	return false;
>   }
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 63b68b85db3f..f7ac40ce0caf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -694,6 +694,9 @@ struct kvm_vcpu_arch {
>   
>   	/* Per-vcpu CCSIDR override or NULL */
>   	u32 *ccsidr;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>   };
>   
>   /*
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 4ab5cb5e91b3..915e76068b00 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,7 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <asm/rmi_smc.h>
>   #include <uapi/linux/kvm.h>
>   
>   /**
> @@ -70,6 +71,21 @@ struct realm {
>   	unsigned int ia_bits;
>   };
>   
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> +	struct rec_run *run;
> +};
> +
>   int kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   
> @@ -77,6 +93,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +int kvm_create_rec(struct kvm_vcpu *vcpu);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
>   #define RME_RTT_BLOCK_LEVEL	2
>   #define RME_RTT_MAX_LEVEL	3
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c5a6139d5454..d70c511e16a0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -432,6 +432,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	/* Force users to call KVM_ARM_VCPU_INIT */
>   	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>   	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	/*
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 68d1d05672bd..6e6eb4a15095 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -134,6 +134,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>   			return -EPERM;
>   
>   		return kvm_vcpu_finalize_sve(vcpu);
> +	case KVM_ARM_VCPU_REC:
> +		if (!kvm_is_realm(vcpu->kvm))
> +			return -EINVAL;
> +
> +		return kvm_create_rec(vcpu);
>   	}
>   
>   	return -EINVAL;
> @@ -144,6 +149,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>   	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return false;
>   
> +	if (kvm_is_realm(vcpu->kvm) &&
> +	    !(vcpu_is_rec(vcpu) &&
> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
> +		return false;
> +
>   	return true;
>   }
>   
> @@ -157,6 +167,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>   	kfree(sve_state);
>   	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>   }
>   
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 09b59bcad8b6..629a095bea61 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -474,6 +474,156 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		phys_addr_t aux_page_phys = page_to_phys(aux_pages[i]);
> +
> +		/* If the undelegate fails then leak the page */
> +		if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
> +			continue;
> +
> +		__free_page(aux_pages[i]);
> +	}
> +}
> +
> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	int ret;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page;
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (rmi_granule_delegate(aux_page_phys)) {
> +			__free_page(aux_page);
> +			ret = -ENXIO;
> +			goto out_err;
> +		}
> +		aux_pages[i] = aux_page;
> +		aux_phys_pages[i] = aux_page_phys;
> +	}
> +
> +	return 0;
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +
> +int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +	struct rec_params *params;
> +	int r, i;
> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
> +		return -ENOENT;
> +
> +	/*
> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
> +	 * flag covers v0.2 and onwards.
> +	 */
> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
> +
> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (!params || !rec->rec_page || !rec->run) {
> +		r = -ENOMEM;
> +		goto out_free_pages;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
> +		params->gprs[i] = vcpu_regs->regs[i];
> +
> +	params->pc = vcpu_regs->pc;
> +
> +	if (vcpu->vcpu_id == 0)
> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	if (rmi_granule_delegate(rec_page_phys)) {
> +		r = -ENXIO;
> +		goto out_free_pages;
> +	}
> +
> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;
> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}
> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	/* If the REC destroy fails, leak all pages relating to the REC */

minor nit: May be we could clarify the situation of AUX granules.

	/*
	 * We cannot reclaim the REC page and any AUX pages
	 * until the REC is destroyed. So, if we fail to destroy
	 * the REC, leak the REC and AUX pages.
	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +
> +	/* If the undelegate fails then leak the REC page */
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		return;
> +
> +	free_page((unsigned long)rec->rec_page);


> +	free_page((unsigned long)rec->run);

I think this can be freed irrespective of the delegated pages.
So, may be we could do move it to the top.


> +}
> +

Suzuki


>   int kvm_init_realm_vm(struct kvm *kvm)
>   {
>   	struct realm_params *params;


