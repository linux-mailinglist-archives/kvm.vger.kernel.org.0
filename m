Return-Path: <kvm+bounces-15114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7BA8A9F7E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0467B2571A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330E016F913;
	Thu, 18 Apr 2024 16:04:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A26A16F855;
	Thu, 18 Apr 2024 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456298; cv=none; b=OfkGiqDrXzq0r94APr0O+Ps8EuOHsmVS28fvemQqYlB+qU7sob6mnyfv2DSEUESMDeikG9oOFR/WtRXos5H1GGAshak9l/WFMeoRHfFcYlQSlDM2LwlZxOoV3lo6tU1ojgFvRLTCUr8vxOL8WMSmNXDSXr+MMQ+nb7eHSE7Ins0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456298; c=relaxed/simple;
	bh=GbU1JA6YVxb3ig5NRjN18v3UIYgnjfVgvATBleIZOu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QWeLoBa4kafp3iXDYZU31oz/mkPlNuDthgN7uddOOBXvZfEbi1ycmekFrHfy6tgmpvlninE2IpLD5uMgTqz5N7VVYHw2gyn4ocNMuqWRbCDqec/F5rCd97peEN8oVZ5DbeR7jKm8nALpi8/k1tZr6An9j3aftx6mzke0DjYUL+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6C82F;
	Thu, 18 Apr 2024 09:05:23 -0700 (PDT)
Received: from [10.57.84.16] (unknown [10.57.84.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 131373F64C;
	Thu, 18 Apr 2024 09:04:52 -0700 (PDT)
Message-ID: <89f94c97-ea8d-47e1-919f-8137b74a8943@arm.com>
Date: Thu, 18 Apr 2024 17:04:51 +0100
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

On 12/04/2024 09:42, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves
> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
> 
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created.
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
>   	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;

See my comment below.

...

> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{

...

> +	for (i = 0; i < pgt->pgd_pages; i++) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> +			return;

I think we need to either:

	a. memset() the root RTT pages to 0 here.

OR

         b. for Realms, avoid walking the page table triggered via

  kvm_pgtable_stage2_destroy()->kvm_pgtable_walk().

Even though the root RTTs are all empty (invalid entries, written using 
RMM's memory encryption.), the Host might be seeing "garbage" which
might look like "valid" entries and thus triggering crashes.

I prefer not walking the RTTs for a Realm and thus simply skip the walk.

Suzuki


> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
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
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
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


