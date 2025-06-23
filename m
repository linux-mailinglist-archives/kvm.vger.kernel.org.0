Return-Path: <kvm+bounces-50370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B398AE475B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29C33B61C9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF96526F477;
	Mon, 23 Jun 2025 14:45:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D143926B2A9;
	Mon, 23 Jun 2025 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750689946; cv=none; b=VZ2F0oA4n+c3zutQA0IKTyIEBrkT03aI8TxzQetLxKt4r0du6BLe3HCWeGs/Mj+6UrHL/a84ySAtQ2si7c0rlK6saB95WbqzARdalVkHfoNWH9G13LOXenGBENwAXWLEV4GGQVFjjOKga5ycfEEtOhMXGUWRHKxkCThIWOn/L5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750689946; c=relaxed/simple;
	bh=9PtIFxfbF87dTDTypxZfGEj9DfZhGdyBYnPLpKurM1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kVj158LT9RSFcywNAmRtl6XH3NwArH7QBPX5/3FBKAkcK55L8AnIqGSiBJ22sj3m+l29zcxVdZ4Vo4CoScO1AOrom8A4KgeN/GAuD62gCUR8TSXk97uaenyauMt6qFWP2iZkIl5I24Y3jvLCjfMSXvfXwf7yYz8UN23BKBpfevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C94D113E;
	Mon, 23 Jun 2025 07:45:26 -0700 (PDT)
Received: from [10.57.29.183] (unknown [10.57.29.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C19EE3F66E;
	Mon, 23 Jun 2025 07:45:38 -0700 (PDT)
Message-ID: <c96eb50e-eee6-4589-894a-6e10613f6dfb@arm.com>
Date: Mon, 23 Jun 2025 15:45:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/43] arm64: RME: Allow VMM to set RIPAS
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-16-steven.price@arm.com>
 <20250618133355.2af1dcc4@donnerap.manchester.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20250618133355.2af1dcc4@donnerap.manchester.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/06/2025 13:33, Andre Przywara wrote:
> On Wed, 11 Jun 2025 11:48:12 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
> Hi Steven,
> 
> one build error below, on my machine (with GCC10):
> 
>> Each page within the protected region of the realm guest can be marked
>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>> has started and provide the equivalent functions to change this (with
>> the guest's approval) at runtime.
>>
>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>> unmapped from the guest and undelegated allowing the memory to be reused
>> by the host. When transitioning to RIPAS RAM the actual population of
>> the leaf RTTs is done later on stage 2 fault, however it may be
>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>> for the requested range.
>>
>> When freeing a block mapping it is necessary to temporarily unfold the
>> RTT which requires delegating an extra page to the RMM, this page can
>> then be recovered once the contents of the block mapping have been
>> freed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v8:
>>  * Propagate the 'may_block' flag to allow conditional calls to
>>    cond_resched_rwlock_write().
>>  * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>>    kvm_account_pgtable_pages() and use when allocating RTTs.
>>  * Code reorganisation to allow init_ipa_state and set_ipa_state to
>>    share a common ripas_change() function,
>>  * Other minor changes following review.
>> Changes from v7:
>>  * Replace use of "only_shared" with the upstream "attr_filter" field
>>    of struct kvm_gfn_range.
>>  * Clean up the logic in alloc_delegated_granule() for when to call
>>    kvm_account_pgtable_pages().
>>  * Rename realm_destroy_protected_granule() to
>>    realm_destroy_private_granule() to match the naming elsewhere. Also
>>    fix the return codes in the function to be descriptive.
>>  * Several other minor changes to names/return codes.
>> Changes from v6:
>>  * Split the code dealing with the guest triggering a RIPAS change into
>>    a separate patch, so this patch is purely for the VMM setting up the
>>    RIPAS before the guest first runs.
>>  * Drop the useless flags argument from alloc_delegated_granule().
>>  * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>  * Deal with the RMM granule size potentially being smaller than the
>>    host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>    still allocates an entire host page for every RMM granule (so wasting
>>    memory when PAGE_SIZE>4k).
>> Changes from v5:
>>  * Adapt to rebasing.
>>  * Introduce find_map_level()
>>  * Rename some functions to be clearer.
>>  * Drop the "spare page" functionality.
>> Changes from v2:
>>  * {alloc,free}_delegated_page() moved from previous patch to this one.
>>  * alloc_delegated_page() now takes a gfp_t flags parameter.
>>  * Fix the reference counting of guestmem pages to avoid leaking memory.
>>  * Several misc code improvements and extra comments.
>> ---
>>  arch/arm64/include/asm/kvm_rme.h |   6 +
>>  arch/arm64/kvm/mmu.c             |   8 +-
>>  arch/arm64/kvm/rme.c             | 447 +++++++++++++++++++++++++++++++
>>  3 files changed, 458 insertions(+), 3 deletions(-)
>>
> 
> [ ... ]
> 
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 25705da6f153..fe75c41d6ac3 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
> 
> [ ... ]
> 
>> @@ -318,6 +619,140 @@ static int realm_create_rd(struct kvm *kvm)
>>  	return r;
>>  }
>>  
>> +static void realm_unmap_private_range(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end,
>> +				      bool may_block)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long next_addr, addr;
>> +	int ret;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		ret = realm_unmap_private_page(realm, addr, &next_addr);
>> +
>> +		if (ret)
>> +			break;
>> +
>> +		if (may_block)
>> +			cond_resched_rwlock_write(&kvm->mmu_lock);
>> +	}
>> +
>> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>> +			     start, end);
>> +}
>> +
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> +			   unsigned long size, bool unmap_private,
>> +			   bool may_block)
>> +{
>> +	unsigned long end = start + size;
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	end = min(BIT(realm->ia_bits - 1), end);
>> +
>> +	if (!kvm_realm_is_created(kvm))
>> +		return;
>> +
>> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
>> +				 start, end, may_block);
>> +	if (unmap_private)
>> +		realm_unmap_private_range(kvm, start, end, may_block);
>> +}
>> +
>> +enum ripas_action {
>> +	RIPAS_INIT,
>> +	RIPAS_SET,
>> +};
>> +
>> +static int ripas_change(struct kvm *kvm,
>> +			struct kvm_vcpu *vcpu,
>> +			unsigned long ipa,
>> +			unsigned long end,
>> +			enum ripas_action action,
>> +			unsigned long *top_ipa)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +	phys_addr_t rec_phys;
>> +	struct kvm_mmu_memory_cache *memcache = NULL;
>> +	int ret = 0;
>> +
>> +	if (vcpu) {
>> +		rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
>> +		memcache = &vcpu->arch.mmu_page_cache;
>> +
>> +		WARN_ON(action != RIPAS_SET);
>> +	} else {
>> +		WARN_ON(action != RIPAS_INIT);
>> +	}
>> +
>> +	while (ipa < end) {
>> +		unsigned long next;
>> +
>> +		switch (action) {
>> +		case RIPAS_INIT:
>> +			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>> +			break;
>> +		case RIPAS_SET:
>> +			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
>> +						&next);
>> +			break;
>> +		}
>> +
>> +		switch (RMI_RETURN_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			ipa = next;
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			int err_level = RMI_RETURN_INDEX(ret);
> 
> This breaks the build on GCC <= v10:
> 
> /src/linux/arch/arm64/kvm/rme.c: In function ‘ripas_change’:
> /src/linux/arch/arm64/kvm/rme.c:1190:4: error: a label can only be part of a statement and a declaration is not a statement
>  1190 |    int err_level = RMI_RETURN_INDEX(ret);
>       |    ^~~
> /src/linux/arch/arm64/kvm/rme.c:1191:4: error: expected expression before int’
>  1191 |    int level = find_map_level(realm, ipa, end);
>       |    ^~~
> /src/linux/arch/arm64/kvm/rme.c:1193:21: error: ‘level’ undeclared (first use in this function)
>  1193 |    if (err_level >= level)
>       |                     ^~~~~
> 
> With GCC 11 and later I see this still as a warning when using -Wpedantic,
> but it vanishes when also paired with -std=gnu2x.
> 
> So either hoist the variable declaration up, or use brackets, this worked
> for me as well, and I see it in other places:
> 
> 		case RMI_ERROR_RTT: {
> 			....
> 		}
> 		default:


I'm surprised my compiler didn't complain - variable declarations in
switch statements can often be dodgy because it can cause subtle cases
where the variable is used without being set. Although perhaps Duff's
Device means the compiler is hard pressed to generate meaningful warnings.

I think in this case the extra brackets is probably cleanest.

Thanks,
Steve

> Cheers,
> Andre
> 
> 
>> +			int level = find_map_level(realm, ipa, end);
>> +
>> +			if (err_level >= level)
>> +				return -EINVAL;
>> +
>> +			ret = realm_create_rtt_levels(realm, ipa,
>> err_level,
>> +						      level, memcache);
>> +			if (ret)
>> +				return ret;
>> +			/* Retry with the RTT levels in place */
>> +			break;
>> +		default:
>> +			WARN_ON(1);
>> +			return -ENXIO;
>> +		}
>> +	}
>> +
>> +	if (top_ipa)
>> +		*top_ipa = ipa;
>> +
>> +	return 0;
>> +}
>> +
>> +static int realm_init_ipa_state(struct kvm *kvm,
>> +				unsigned long ipa,
>> +				unsigned long end)
>> +{
>> +	return ripas_change(kvm, NULL, ipa, end, RIPAS_INIT, NULL);
>> +}
>> +
>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>> +				    struct arm_rme_init_ripas *args)
>> +{
>> +	gpa_t addr, end;
>> +
>> +	addr = args->base;
>> +	end = addr + args->size;
>> +
>> +	if (end < addr)
>> +		return -EINVAL;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +		return -EPERM;
>> +
>> +	return realm_init_ipa_state(kvm, addr, end);
>> +}
>> +
>>  /* Protects access to rme_vmid_bitmap */
>>  static DEFINE_SPINLOCK(rme_vmid_lock);
>>  static unsigned long *rme_vmid_bitmap;
>> @@ -441,6 +876,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>> kvm_enable_cap *cap) case KVM_CAP_ARM_RME_CREATE_REALM:
>>  		r = kvm_create_realm(kvm);
>>  		break;
>> +	case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
>> +		struct arm_rme_init_ripas args;
>> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
>> +
>> +		if (copy_from_user(&args, argp, sizeof(args))) {
>> +			r = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		r = kvm_init_ipa_range_realm(kvm, &args);
>> +		break;
>> +	}
>>  	default:
>>  		r = -EINVAL;
>>  		break;
> 


