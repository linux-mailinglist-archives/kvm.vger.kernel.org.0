Return-Path: <kvm+bounces-50978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69365AEB519
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4ECD16318F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4063F295D85;
	Fri, 27 Jun 2025 10:37:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B254D26AA83;
	Fri, 27 Jun 2025 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020666; cv=none; b=Ebk6+nMGDk1PLZjZ5DkQ9YSivDA5FaTaP3kVP9CKo5HEI5rYM4/2rXNyr89gbepqW0CnrnhHKqnbLi9GIIySOphKljuAafrToeJFF+zXlv/8yLqpwJ8nCLnvNrk6Hp62tmpvavKLX7RD9Zg00EWyAOk4BHtvr/UQk6xG+xUkxPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020666; c=relaxed/simple;
	bh=Hs69kNfiViuyMR4UQaXJEfp9r+qWh8ezJjT7Td0uLkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d53MpBKKxm4V8lTYaGNLDy5C8Rpd4M7FR7sxmEe3RMDOZ0FWOl3WXcX1WYlP0HSpm3BhNq7L9pqk4boMqJ65m7LZGpC17jp28gma7HvLraHtAkZekrjcR8XN5xzucsDOT6mrKNyHecfkFN5UjJmHBHF8/sKsg+y8luDDHfcN4Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D43321A00;
	Fri, 27 Jun 2025 03:37:26 -0700 (PDT)
Received: from [10.1.31.20] (e122027.cambridge.arm.com [10.1.31.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E3A53F58B;
	Fri, 27 Jun 2025 03:37:39 -0700 (PDT)
Message-ID: <ac55ac54-dd06-499d-8f01-e3603b1d214c@arm.com>
Date: Fri, 27 Jun 2025 11:37:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/43] arm64: RME: Allocate/free RECs to match vCPUs
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-12-steven.price@arm.com>
 <20250625090028.GC111675@e124191.cambridge.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20250625090028.GC111675@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/06/2025 10:00, Joey Gouly wrote:
> Hi Steven,
> 
> On Wed, Jun 11, 2025 at 11:48:08AM +0100, Steven Price wrote:
>> The RMM maintains a data structure known as the Realm Execution Context
>> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
>> virtual CPUs. KVM must delegate memory and request the structures are
>> created when vCPUs are created, and suitably tear down on destruction.
>>
>> RECs must also be supplied with addition pages - auxiliary (or AUX)
>> granules - for storing the larger registers state (e.g. for SVE). The
>> number of AUX granules for a REC depends on the parameters with which
>> the Realm was created - the RMM makes this information available via the
>> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
>>
>> Note that only some of register state for the REC can be set by KVM, the
>> rest is defined by the RMM (zeroed). The register state then cannot be
>> changed by KVM after the REC is created (except when the guest
>> explicitly requests this e.g. by performing a PSCI call). The RMM also
>> requires that the VMM creates RECs in ascending order of the MPIDR.
>>
>> See Realm Management Monitor specification (DEN0137) for more information:
>> https://developer.arm.com/documentation/den0137/
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>> Changes since v7:
>>  * Add comment explaining the aux_pages array.
>>  * Rename "undeleted_failed" variable to "should_free" to avoid a
>>    confusing double negative.
>> Changes since v6:
>>  * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>>    realm guest.
>>  * Support host page size being larger than RMM's granule size when
>>    allocating/freeing aux granules.
>> Changes since v5:
>>  * Separate the concept of vcpu_is_rec() and
>>    kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>>    the indication that the VCPU is a REC.
>> Changes since v2:
>>  * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h |   7 ++
>>  arch/arm64/include/asm/kvm_host.h    |   3 +
>>  arch/arm64/include/asm/kvm_rme.h     |  27 ++++
>>  arch/arm64/kvm/arm.c                 |  13 +-
>>  arch/arm64/kvm/reset.c               |  11 ++
>>  arch/arm64/kvm/rme.c                 | 180 +++++++++++++++++++++++++++
>>  6 files changed, 239 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index a640bb7dffbc..302a691b3723 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -711,7 +711,14 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>>  
>>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>  {
>> +	if (static_branch_unlikely(&kvm_rme_is_available))
>> +		return vcpu_has_feature(vcpu, KVM_ARM_VCPU_REC);
>>  	return false;
>>  }
>>  
>> +static inline bool kvm_arm_rec_finalized(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.rec.mpidr != INVALID_HWID;
>> +}
>> +
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 18e6d72dabe9..58fe7b216126 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -883,6 +883,9 @@ struct kvm_vcpu_arch {
>>  
>>  	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>>  	struct vncr_tlb	*vncr_tlb;
>> +
>> +	/* Realm meta data */
>> +	struct realm_rec rec;
>>  };
>>  
>>  /*
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index 5f0de9a6d339..f716b890e484 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -6,6 +6,7 @@
>>  #ifndef __ASM_KVM_RME_H
>>  #define __ASM_KVM_RME_H
>>  
>> +#include <asm/rmi_smc.h>
>>  #include <uapi/linux/kvm.h>
>>  
>>  /**
>> @@ -65,6 +66,30 @@ struct realm {
>>  	unsigned int ia_bits;
>>  };
>>  
>> +/**
>> + * struct realm_rec - Additional per VCPU data for a Realm
>> + *
>> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
>> + * @rec_page: Kernel VA of the RMM's private page for this REC
>> + * @aux_pages: Additional pages private to the RMM for this REC
>> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
>> + */
>> +struct realm_rec {
>> +	unsigned long mpidr;
>> +	void *rec_page;
>> +	/*
>> +	 * REC_PARAMS_AUX_GRANULES is the maximum number of granules that the
>> +	 * RMM can require. By using that to size the array we know that it
>> +	 * will be big enough as the page size is always at least as large as
>> +	 * the granule size. In the case of a larger page size than 4k (or an
>> +	 * RMM which requires fewer auxiliary granules), the array will be
>> +	 * bigger than needed however the extra memory required is small and
>> +	 * this keeps the code cleaner.
>> +	 */
>> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> 
> I think that something like this may work, and use the right amount of pages:
> 
> 	struct page *aux_pages[(REC_PARAMS_AUX_GRANULES * RMM_PAGE_SIZE) >> PAGE_SHIFT];

Thanks, yes that should calculate the correct number of pages. I'm not
sure why I didn't figure that out before. A minor issue is RMM_PAGE_SIZE
is only defined in rme.c, but I think (with a comment) SZ_4K should suffice.

Thanks,
Steve

> Thanks,
> Joey
> 
>> +	struct rec_run *run;
>> +};
>> +
>>  void kvm_init_rme(void);
>>  u32 kvm_realm_ipa_limit(void);
>>  
>> @@ -72,6 +97,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>  int kvm_init_realm_vm(struct kvm *kvm);
>>  void kvm_destroy_realm(struct kvm *kvm);
>>  void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>> +int kvm_create_rec(struct kvm_vcpu *vcpu);
>> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  
>>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>>  						unsigned long addr)
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index b3e3323573c6..7be1bdfc5f0b 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -495,6 +495,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>  	/* Force users to call KVM_ARM_VCPU_INIT */
>>  	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>>  
>> +	vcpu->arch.rec.mpidr = INVALID_HWID;
>> +
>>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>>  
>>  	/* Set up the timer */
>> @@ -1457,7 +1459,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>>  	return -EINVAL;
>>  }
>>  
>> -static unsigned long system_supported_vcpu_features(void)
>> +static unsigned long system_supported_vcpu_features(struct kvm *kvm)
>>  {
>>  	unsigned long features = KVM_VCPU_VALID_FEATURES;
>>  
>> @@ -1478,6 +1480,9 @@ static unsigned long system_supported_vcpu_features(void)
>>  	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>>  		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>>  
>> +	if (!kvm_is_realm(kvm))
>> +		clear_bit(KVM_ARM_VCPU_REC, &features);
>> +
>>  	return features;
>>  }
>>  
>> @@ -1495,7 +1500,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>>  			return -ENOENT;
>>  	}
>>  
>> -	if (features & ~system_supported_vcpu_features())
>> +	if (features & ~system_supported_vcpu_features(vcpu->kvm))
>>  		return -EINVAL;
>>  
>>  	/*
>> @@ -1517,6 +1522,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>>  	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
>>  		return -EINVAL;
>>  
>> +	/* RME is incompatible with AArch32 */
>> +	if (test_bit(KVM_ARM_VCPU_REC, &features))
>> +		return -EINVAL;
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 959532422d3a..2e9e855581d4 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -137,6 +137,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>>  			return -EPERM;
>>  
>>  		return kvm_vcpu_finalize_sve(vcpu);
>> +	case KVM_ARM_VCPU_REC:
>> +		if (!kvm_is_realm(vcpu->kvm) || !vcpu_is_rec(vcpu))
>> +			return -EINVAL;
>> +
>> +		return kvm_create_rec(vcpu);
>>  	}
>>  
>>  	return -EINVAL;
>> @@ -147,6 +152,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>>  	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>>  		return false;
>>  
>> +	if (kvm_is_realm(vcpu->kvm) &&
>> +	    !(vcpu_is_rec(vcpu) && kvm_arm_rec_finalized(vcpu) &&
>> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
>> +		return false;
>> +
>>  	return true;
>>  }
>>  
>> @@ -161,6 +171,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>>  	kfree(vcpu->arch.vncr_tlb);
>>  	kfree(vcpu->arch.ccsidr);
>> +	kvm_destroy_rec(vcpu);
>>  }
>>  
>>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 0f89295fa59c..f094544592b5 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -484,6 +484,186 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  }
>>  
>> +static void free_rec_aux(struct page **aux_pages,
>> +			 unsigned int num_aux)
>> +{
>> +	unsigned int i, j;
>> +	unsigned int page_count = 0;
>> +
>> +	for (i = 0; i < num_aux;) {
>> +		struct page *aux_page = aux_pages[page_count++];
>> +		phys_addr_t aux_page_phys = page_to_phys(aux_page);
>> +		bool should_free = true;
>> +
>> +		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
>> +			if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
>> +				should_free = false;
>> +			aux_page_phys += RMM_PAGE_SIZE;
>> +			i++;
>> +		}
>> +		/* Only free if all the undelegate calls were successful */
>> +		if (should_free)
>> +			__free_page(aux_page);
>> +	}
>> +}
>> +
>> +static int alloc_rec_aux(struct page **aux_pages,
>> +			 u64 *aux_phys_pages,
>> +			 unsigned int num_aux)
>> +{
>> +	struct page *aux_page;
>> +	int page_count = 0;
>> +	unsigned int i, j;
>> +	int ret;
>> +
>> +	for (i = 0; i < num_aux;) {
>> +		phys_addr_t aux_page_phys;
>> +
>> +		aux_page = alloc_page(GFP_KERNEL);
>> +		if (!aux_page) {
>> +			ret = -ENOMEM;
>> +			goto out_err;
>> +		}
>> +
>> +		aux_page_phys = page_to_phys(aux_page);
>> +		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
>> +			if (rmi_granule_delegate(aux_page_phys)) {
>> +				ret = -ENXIO;
>> +				goto err_undelegate;
>> +			}
>> +			aux_phys_pages[i++] = aux_page_phys;
>> +			aux_page_phys += RMM_PAGE_SIZE;
>> +		}
>> +		aux_pages[page_count++] = aux_page;
>> +	}
>> +
>> +	return 0;
>> +err_undelegate:
>> +	while (j > 0) {
>> +		j -= RMM_PAGE_SIZE;
>> +		i--;
>> +		if (WARN_ON(rmi_granule_undelegate(aux_phys_pages[i]))) {
>> +			/* Leak the page if the undelegate fails */
>> +			goto out_err;
>> +		}
>> +	}
>> +	__free_page(aux_page);
>> +out_err:
>> +	free_rec_aux(aux_pages, i);
>> +	return ret;
>> +}
>> +
>> +int kvm_create_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
>> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> +	struct realm *realm = &vcpu->kvm->arch.realm;
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	unsigned long rec_page_phys;
>> +	struct rec_params *params;
>> +	int r, i;
>> +
>> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
>> +		return -ENOENT;
>> +
>> +	if (rec->run)
>> +		return -EBUSY;
>> +
>> +	/*
>> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
>> +	 * flag covers v0.2 and onwards.
>> +	 */
>> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
>> +		return -EINVAL;
>> +
>> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
>> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
>> +
>> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
>> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
>> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
>> +	if (!params || !rec->rec_page || !rec->run) {
>> +		r = -ENOMEM;
>> +		goto out_free_pages;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
>> +		params->gprs[i] = vcpu_regs->regs[i];
>> +
>> +	params->pc = vcpu_regs->pc;
>> +
>> +	if (vcpu->vcpu_id == 0)
>> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
>> +
>> +	rec_page_phys = virt_to_phys(rec->rec_page);
>> +
>> +	if (rmi_granule_delegate(rec_page_phys)) {
>> +		r = -ENXIO;
>> +		goto out_free_pages;
>> +	}
>> +
>> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
>> +	if (r)
>> +		goto out_undelegate_rmm_rec;
>> +
>> +	params->num_rec_aux = realm->num_aux;
>> +	params->mpidr = mpidr;
>> +
>> +	if (rmi_rec_create(virt_to_phys(realm->rd),
>> +			   rec_page_phys,
>> +			   virt_to_phys(params))) {
>> +		r = -ENXIO;
>> +		goto out_free_rec_aux;
>> +	}
>> +
>> +	rec->mpidr = mpidr;
>> +
>> +	free_page((unsigned long)params);
>> +	return 0;
>> +
>> +out_free_rec_aux:
>> +	free_rec_aux(rec->aux_pages, realm->num_aux);
>> +out_undelegate_rmm_rec:
>> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
>> +		rec->rec_page = NULL;
>> +out_free_pages:
>> +	free_page((unsigned long)rec->run);
>> +	free_page((unsigned long)rec->rec_page);
>> +	free_page((unsigned long)params);
>> +	return r;
>> +}
>> +
>> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm *realm = &vcpu->kvm->arch.realm;
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	unsigned long rec_page_phys;
>> +
>> +	if (!vcpu_is_rec(vcpu))
>> +		return;
>> +
>> +	if (!rec->run) {
>> +		/* Nothing to do if the VCPU hasn't been finalized */
>> +		return;
>> +	}
>> +
>> +	free_page((unsigned long)rec->run);
>> +
>> +	rec_page_phys = virt_to_phys(rec->rec_page);
>> +
>> +	/*
>> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
>> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
>> +	 * pages will be leaked.
>> +	 */
>> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
>> +		return;
>> +
>> +	free_rec_aux(rec->aux_pages, realm->num_aux);
>> +
>> +	free_delegated_granule(rec_page_phys);
>> +}
>> +
>>  int kvm_init_realm_vm(struct kvm *kvm)
>>  {
>>  	kvm->arch.realm.params = (void *)get_zeroed_page(GFP_KERNEL);
>> -- 
>> 2.43.0
>>


