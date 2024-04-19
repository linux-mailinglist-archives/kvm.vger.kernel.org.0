Return-Path: <kvm+bounces-15282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E23CD8AAF27
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22C30B21C58
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D44F1272DC;
	Fri, 19 Apr 2024 13:17:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBC885943;
	Fri, 19 Apr 2024 13:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713532660; cv=none; b=ma9A/cXe+ixv45fysbxFVWgIKENoqdK5YombEMHapEhHK4Yq/WGuBQ20OY2TXifgHajH7s2yXw1E5b6x6DuQXgBl2NbZ42X4zLS0JZgS6Mdaiu/e8515ij5LKkwWK9E5ne5cwBWI1t3eNp2aU0MHb8ON2poKWgFv1YQXQv2hu/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713532660; c=relaxed/simple;
	bh=KNEnmnjXcdjG/45CnWUWM7KCLSgLT4ZKgUXAsuvu8Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAGafpfIqa/Tlb1XwKf3k3MHwTE8i8kTVoqnIEYC/oHwZnvUNl32Qe7BCH3Tv/jDvO6tIDyFxijfDQl+baexf3pdbMLC4mmSxyP1bTtuY3iI8yjJ8lcs0pDJqhfOHt9eFdjfv5Jp0PKvjYqdC52shIGy5gRpg8u01rF0Aj27q/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23FF12F;
	Fri, 19 Apr 2024 06:18:05 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 410FF3F64C;
	Fri, 19 Apr 2024 06:17:34 -0700 (PDT)
Message-ID: <9b37b844-d3b1-4b9f-b37e-36b0c347206e@arm.com>
Date: Fri, 19 Apr 2024 14:17:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/43] arm64: RME: Allow populating initial contents
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
 <20240412084309.1733783-21-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/rme.c | 234 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 234 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 0a3f823b2446..4aab507f896e 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include <linux/kvm_host.h>
> +#include <linux/hugetlb.h>
>   
>   #include <asm/kvm_emulate.h>
>   #include <asm/kvm_mmu.h>
> @@ -547,6 +548,227 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size,
>   	realm_fold_rtt_range(realm, ipa, end);
>   }
>   
> +static int realm_create_protected_data_page(struct realm *realm,
> +					    unsigned long ipa,
> +					    struct page *dst_page,
> +					    struct page *src_page,
> +					    unsigned long flags)
> +{
> +	phys_addr_t dst_phys, src_phys;
> +	int ret;
> +
> +	dst_phys = page_to_phys(dst_page);
> +	src_phys = page_to_phys(src_page);
> +
> +	if (rmi_granule_delegate(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa, src_phys,
> +			      flags);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      RME_RTT_MAX_LEVEL, NULL);
> +		if (ret)
> +			goto err;
> +
> +		ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa,
> +				      src_phys, flags);
> +	}
> +
> +	if (ret)
> +		goto err;

ultra minor nit:

	if (!ret)
		return 0;

> +
> +	return 0;
> +
> +err:
> +	if (WARN_ON(rmi_granule_undelegate(dst_phys))) {
> +		/* Page can't be returned to NS world so is lost */
> +		get_page(dst_page);
> +	}
> +	return -ENXIO;
> +}
> +
> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
> +{
> +	phys_addr_t rtt_addr;
> +	int ret;
> +
> +	ret = realm_rtt_fold(realm, addr, level + 1, &rtt_addr);
> +	if (ret)
> +		return ret;
> +
> +	free_delegated_page(realm, rtt_addr);
> +
> +	return 0;
> +}
> +
> +static int populate_par_region(struct kvm *kvm,
> +			       phys_addr_t ipa_base,
> +			       phys_addr_t ipa_end,
> +			       u32 flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_memory_slot *memslot;
> +	gfn_t base_gfn, end_gfn;
> +	int idx;
> +	phys_addr_t ipa;
> +	int ret = 0;
> +	struct page *tmp_page;
> +	unsigned long data_flags = 0;
> +
> +	base_gfn = gpa_to_gfn(ipa_base);
> +	end_gfn = gpa_to_gfn(ipa_end);
> +
> +	if (flags & KVM_ARM_RME_POPULATE_FLAGS_MEASURE)
> +		data_flags = RMI_MEASURE_CONTENT;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	memslot = gfn_to_memslot(kvm, base_gfn);
> +	if (!memslot) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* We require the region to be contained within a single memslot */
> +	if (memslot->base_gfn + memslot->npages < end_gfn) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	tmp_page = alloc_page(GFP_KERNEL);
> +	if (!tmp_page) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	mmap_read_lock(current->mm);
> +
> +	ipa = ipa_base;
> +	while (ipa < ipa_end) {
> +		struct vm_area_struct *vma;
> +		unsigned long map_size;
> +		unsigned int vma_shift;
> +		unsigned long offset;
> +		unsigned long hva;
> +		struct page *page;
> +		kvm_pfn_t pfn;
> +		int level;
> +
> +		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
> +		vma = vma_lookup(current->mm, hva);
> +		if (!vma) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		if (is_vm_hugetlb_page(vma))
> +			vma_shift = huge_page_shift(hstate_vma(vma));
> +		else
> +			vma_shift = PAGE_SHIFT;
> +
> +		map_size = 1 << vma_shift;
> +
> +		/*
> +		 * FIXME: This causes over mapping, but there's no good
> +		 * solution here with the ABI as it stands
> +		 */
> +		ipa = ALIGN_DOWN(ipa, map_size);
> +
> +		switch (map_size) {
> +		case RME_L2_BLOCK_SIZE:
> +			level = 2;
> +			break;
> +		case PAGE_SIZE:
> +			level = 3;
> +			break;
> +		default:
> +			WARN_ONCE(1, "Unsupport vma_shift %d", vma_shift);

Do we really need this WARNing  ? Could we not fallback to the next 
possible mapping size ? e.g: if 1G, we could at least try 2M. I guess
this is more or less similar to what we would do on a fault and it may
be a good idea to see if could reuse the core bits from user_mem_abort ?

> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		pfn = gfn_to_pfn_memslot(memslot, gpa_to_gfn(ipa));
> +
> +		if (is_error_pfn(pfn)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		if (level < RME_RTT_MAX_LEVEL) {
> +			/*
> +			 * A temporary RTT is needed during the map, precreate
> +			 * it, however if there is an error (e.g. missing
> +			 * parent tables) this will be handled in the
> +			 * realm_create_protected_data_page() call.
> +			 */
> +			realm_create_rtt_levels(realm, ipa, level,
> +						RME_RTT_MAX_LEVEL, NULL);
> +		}
> +
> +		page = pfn_to_page(pfn);
> +
> +		for (offset = 0; offset < map_size && !ret;
> +		     offset += PAGE_SIZE, page++) {
> +			phys_addr_t page_ipa = ipa + offset;
> +
> +			ret = realm_create_protected_data_page(realm, page_ipa,
> +							       page, tmp_page,
> +							       data_flags);
> +		}
> +		if (ret)
> +			goto err_release_pfn;
> +
> +		if (level == 2) {
> +			ret = fold_rtt(realm, ipa, level);
> +			if (ret)
> +				goto err_release_pfn;

Do we care about the FOLD error here ? Ideally we shouldn't hit an 
error, but unable to fold is not an error case ? We could live with
L3 mappings ?


Suzuki


> +		}
> +
> +		ipa += map_size;
> +		kvm_release_pfn_dirty(pfn);
> +err_release_pfn:
> +		if (ret) {
> +			kvm_release_pfn_clean(pfn);
> +			break;
> +		}
> +	}
> +
> +	mmap_read_unlock(current->mm);
> +	__free_page(tmp_page);
> +
> +out:
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	return ret;
> +}
> +
> +static int kvm_populate_realm(struct kvm *kvm,
> +			      struct kvm_cap_arm_rme_populate_realm_args *args)
> +{
> +	phys_addr_t ipa_base, ipa_end;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(args->populate_ipa_base, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->populate_ipa_size, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (args->flags & ~RMI_MEASURE_CONTENT)
> +		return -EINVAL;
> +
> +	ipa_base = args->populate_ipa_base;
> +	ipa_end = ipa_base + args->populate_ipa_size;
> +
> +	if (ipa_end < ipa_base)
> +		return -EINVAL;
> +
> +	return populate_par_region(kvm, ipa_base, ipa_end, args->flags);
> +}
> +
>   static int find_map_level(struct realm *realm,
>   			  unsigned long start,
>   			  unsigned long end)
> @@ -808,6 +1030,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		r = kvm_init_ipa_range_realm(kvm, &args);
>   		break;
>   	}
> +	case KVM_CAP_ARM_RME_POPULATE_REALM: {
> +		struct kvm_cap_arm_rme_populate_realm_args args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_populate_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;


