Return-Path: <kvm+bounces-14951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB848A801E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F35C328418A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C21137905;
	Wed, 17 Apr 2024 09:52:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D306522089;
	Wed, 17 Apr 2024 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713347524; cv=none; b=LMxS50fPpl/t6aFMIFnU2QZMt5oRtuMg4uYzjufNBcKo/PZzOFED8PFtKIYMKZq5VPdOpVm9WDPl0CRMFxbNh2ZcSWt3q9IX//FnlQwzomZwwjjKxPzKM/VmETZ+dG5Sho9HSpTcgiMFnUQ9e+h+1h2QNlI4FHZnivkpE1KB+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713347524; c=relaxed/simple;
	bh=+l7xW6oarzAgmIwPTf2ExAXIgjLgYncdHHchTIbITU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ms/V+g6Fu1sISBlEEbJ7tkjCRJZ0Hl7wE5gU+GZLwXJR1kVtYzi1iMpVtwSUdfTP69Z97msJ4mg/yXfmoBkS2VkygrCHHvAO9AltpaUjiRhsIVQ8Uf6sGxb/6IiOZKPwouC5KM2TG5yxFgQbZptYG13FFnGQP3ji9UJqjJpSYpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23E83339;
	Wed, 17 Apr 2024 02:52:29 -0700 (PDT)
Received: from [10.1.39.28] (FVFF763DQ05P.cambridge.arm.com [10.1.39.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 958AF3F64C;
	Wed, 17 Apr 2024 02:51:58 -0700 (PDT)
Message-ID: <03030dd1-9980-4050-a950-bb82cef27def@arm.com>
Date: Wed, 17 Apr 2024 10:51:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/43] arm64: RME: ioctls to create and configure
 realms
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
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-10-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 12/04/2024 09:42, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves

minor nit: s/FD/RD

> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
> 
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created.

It might be helpful to provide a bit more background on the Realm 
parameters. Something like:

Realm parameters for Realm Descriptor creation could be classified as:

  1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
     entry level, entry level RTTs, number of RTTs in start level, LPA2)
     Most of these are not measured by RMM and comes from KVM book
     keeping.

  2. Parameters controlling "Arm Architecture features for the VM". (e.g.
     SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
     using the "user ID register write" mechanism. These will be
     supported in the later patches.

  3. Parameters are not part of the core Arm architecture but defined
     by the RMM spec (e.g. Hash algorithm for measurement,
     Personalisation value). These are programmed via
     KVM_CAP_ARM_RME_CONFIG_REALM.



Also it may be a good idea to call out one of the issues that we have
with the UABI w.r.t the IPA Size. The IPA Size supported by RMM *could*
be different from the normal IPA Size as supported by KVM. We do not
expect this to be common, but is not impossible.

If the RMM_IPA_Size < Normal_IPA_Size, we have a problem with
advertising the "IPA Size" to the VMM. Right now we advertise
the "normal limit" by KVM_CAP_ARM_VM_IPA_SIZE and the IPA Size
is configured via vm_type[7:0] in KVM_CREATE_VM. Given we have
to configure the IPA size for a "Realm VM" at CREATE_VM time too,
the VMM is unable to choose a valid IPA Size for the Realm. We
have the following options:

1. Given IPA Size for a Realm is measured, the user must get
    what they choose. i.e., if the platform cannot support the
    requested size, don't run your Realm VM. In this case, we
    don't need to do anything.

2. Add KVM_CAP_ARM_VM_RMM_IPA_SIZE to expose the RMM limit
    for the VMM to choose.

3. VMM to create a Realm VM using the default IPA Size and then
    check the KVM_CAP_ARM_VM_IPA_SIZE on the "kvm" instance (which
    is Realm) and get the RMM IPA limit.

I prefer 2 or 1, in that order of preference. Happy to hear suggestions.

> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   5 +
>   arch/arm64/include/asm/kvm_rme.h     |  19 ++
>   arch/arm64/kvm/arm.c                 |  18 ++
>   arch/arm64/kvm/mmu.c                 |  15 +-
>   arch/arm64/kvm/rme.c                 | 282 +++++++++++++++++++++++++++
>   5 files changed, 337 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 6f08398537e2..c606316f4729 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -624,6 +624,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
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
> index 922da3f47227..cf8cc4d30364 100644
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
>   int kvm_init_rme(void);
> +u32 kvm_realm_ipa_limit(void);
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int kvm_init_realm_vm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);
>   
>   #endif
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2056c660c5ee..5729ea430d6d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -119,6 +119,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->slots_lock);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		if (!kvm_is_realm(kvm))
> +			return -EINVAL;
> +		mutex_lock(&kvm->lock);
> +		r = kvm_realm_enable_cap(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -179,6 +186,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
> @@ -219,6 +233,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_unshare_hyp(kvm, kvm + 1);
>   
>   	kvm_arm_teardown_hypercalls(kvm);
> +	kvm_destroy_realm(kvm);
>   }
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> @@ -328,6 +343,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
> index 18680771cdb0..aae365647b62 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -872,6 +872,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	struct kvm_pgtable *pgt;
>   	u64 mmfr0, mmfr1;
>   	u32 phys_shift;
> +	u32 ipa_limit = kvm_ipa_limit;
> +
> +	if (kvm_is_realm(kvm))
> +		ipa_limit = kvm_realm_ipa_limit();
>   
>   	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>   		return -EINVAL;
> @@ -880,12 +884,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	if (is_protected_kvm_enabled()) {
>   		phys_shift = kvm_ipa_limit;
>   	} else if (phys_shift) {
> -		if (phys_shift > kvm_ipa_limit ||
> +		if (phys_shift > ipa_limit ||
>   		    phys_shift < ARM64_MIN_PARANGE_BITS)
>   			return -EINVAL;
>   	} else {
>   		phys_shift = KVM_PHYS_SHIFT;
> -		if (phys_shift > kvm_ipa_limit) {
> +		if (phys_shift > ipa_limit) {
>   			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
>   				     current->comm);
>   			return -EINVAL;
> @@ -1014,6 +1018,13 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	struct kvm_pgtable *pgt = NULL;
>   
>   	write_lock(&kvm->mmu_lock);
> +	if (kvm_is_realm(kvm) &&
> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		/* TODO: teardown rtts */
> +		write_unlock(&kvm->mmu_lock);
> +		return;
> +	}

This needs a comment to explain the rationale of deferring the
Stage2 pgt freeing. Something like :

	/*
	 * For realms, we can free the entry level RTTs
	 * only after :
	 *  1. All of the stage2 mappings are torn down.
	 *  2. The Realm has been destroyed.
	 *
	 * So, come back later once the RD has been destroyed.
	 */

>   	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 3dbbf9d046bf..658d14e8d87d 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -5,9 +5,20 @@
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
> +static bool rme_supports(unsigned long feature)
> +{
> +	return !!u64_get_bits(rmm_feat_reg0, feature);
> +}
> +
>   static int rmi_check_version(void)
>   {
>   	struct arm_smccc_res res;
> @@ -36,8 +47,272 @@ static int rmi_check_version(void)
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
> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
> +}
> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +	int i, r;
> +
> +	if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
> +		return -EEXIST;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_granule_delegate(rd_phys)) {
> +		r = -ENXIO;
> +		goto out;

super minor nit: s/out/free_rd/ is a bit more readable. Here "out" is
only used for error exits and could be confusing.

> +	}
> +
> +	for (i = 0; i < pgt->pgd_pages; i++) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		if (rmi_granule_delegate(pgd_phys)) {
> +			r = -ENXIO;
> +			goto out_undelegate_tables;
> +		}
> +	}
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = pgt->pgd_pages;
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
> +	realm->rd = rd;
> +
> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +		WARN_ON(rmi_realm_destroy(rd_phys));
> +		goto out_undelegate_tables;
> +	}
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	while (--i >= 0) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		WARN_ON(rmi_granule_undelegate(pgd_phys));
> +	}
> +	WARN_ON(rmi_granule_undelegate(rd_phys));
> +out:
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

minor nit: RMM has a fixed VMID width of 16bits. Do we need to 
explicitly use that, instead of relying what kvm thinks ? (Though
in practise, this would only be a problem if the architecture
evolves to support something more).

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
> +	if (!kvm_is_realm(kvm) || kvm_realm_is_created(kvm))
> +		return -EEXIST;

Minor nit:

	if (!kvm_is_realm(kvm)
		return -EIO or even -EINVAL ?

	if (kvm_realm_is_created(kvm))
		return -EEXIST;

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
> +				  struct kvm_cap_arm_rme_config_item *cfg)
> +{
> +	switch (cfg->hash_algo) {
> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
> +			return -EINVAL;
> +		break;
> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
> +			return -EINVAL;

Do we need to add a comment here on why we don't expose the supported 
"hash" algo as part of the UABI ? Something like :

	/*
	 * The hash algorithm for the measurements is a choosen by
	 * the Realm owner (since it affects the attestation), we
	 * would like the owner to get what they wants.
	 */

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
> +	struct kvm_cap_arm_rme_config_item cfg;
> +	struct realm *realm = &kvm->arch.realm;
> +	int r = 0;
> +
> +	if (kvm_realm_is_created(kvm))
> +		return -EINVAL;

minor nit: May be return -EEXIST or -EIO rather than, "Invalid 
(parameter)" ?


> +
> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
> +		return -EFAULT;
> +
> +	switch (cfg.cfg) {
> +	case KVM_CAP_ARM_RME_CFG_RPV:
> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
> +		break;
> +	case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
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
> +	case KVM_CAP_ARM_RME_CREATE_RD:
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
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
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
> +		if (WARN_ON(rmi_granule_undelegate(rd_phys)))
> +			return;
> +		free_page((unsigned long)realm->rd);
> +		realm->rd = NULL;
> +	}
> +
> +	rme_vmid_release(realm->vmid);
> +
> +	for (i = 0; i < pgt->pgd_pages; i++) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> +			return;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +

May be add in a comment here:

      /* Now that the Realm is destroyed, free the entry level RTTs */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);



> +}
> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	struct realm_params *params;
> +
> +	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
> +	if (!params)
> +		return -ENOMEM;
> +
> +	/* Default parameters, not exposed to user space */

This is a bit misleading. The value comes from the userspace and...

> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);

(minor nit) we initialise most of the params, including those that come
from KVM later. So, as such may be a good idea to move it together at
create_realm, unless we need it.

> +	kvm->arch.realm.params = params;
> +	return 0;
> +}
> +
>   int kvm_init_rme(void)
>   {
> +	int ret;
> +
>   	if (PAGE_SIZE != SZ_4K)
>   		/* Only 4k page size on the host is supported */
>   		return 0;
> @@ -46,6 +321,13 @@ int kvm_init_rme(void)
>   		/* Continue without realm support */
>   		return 0;
>   
> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
> +		return 0;
> +
> +	ret = rme_vmid_init();
> +	if (ret)
> +		return ret;
> +
>   	/* Future patch will enable static branch kvm_rme_is_available */
>   
>   	return 0;


Suzuki


