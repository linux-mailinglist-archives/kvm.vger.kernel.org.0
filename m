Return-Path: <kvm+bounces-37134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FE7A2609A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3A113A72FA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 16:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27A220B7EF;
	Mon,  3 Feb 2025 16:52:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443F31FFC55;
	Mon,  3 Feb 2025 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738601579; cv=none; b=U4AkgGfg+Wa55SN07DpsahC8jt1zTlfZ5nlIqrbKi1PHgNSEJBKpMhSdV/MIttXZmw/jUOktihE7MnHIyzg8i/AHaJ0wu5eJ8fcSNtUH0Ez1jbidP+69uNJXm/OLHfQVBGCI1ZC8mhkHjovNF3i0uQaF/V9Oq4Cc0j/RyziGipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738601579; c=relaxed/simple;
	bh=3bhunF3vxg5B6DZapJXXQ9hOHFkskLmjBAXNK5ISwtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G9Z5KqmExZblEnTq20MJdXNBnHwxWfhgxJvVs/YVt7958qcLgrJRszaksvAAjmiR3HJfQKXZF/nW+AnP+BQmzXxKuhNThrzQZXVm228tjvu8+NOVYX6GqjPEroyvARnVr6YgVNbGUMkzipa310LWstUjiICS3+tm3c4H7wnVs5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D789211FB;
	Mon,  3 Feb 2025 08:53:20 -0800 (PST)
Received: from [10.1.34.25] (e122027.cambridge.arm.com [10.1.34.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE04E3F58B;
	Mon,  3 Feb 2025 08:52:51 -0800 (PST)
Message-ID: <4196d432-ccde-4d1f-b07e-8603bf5dcdaf@arm.com>
Date: Mon, 3 Feb 2025 16:52:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/43] arm64: RME: Allow populating initial contents
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
 <20241212155610.76522-20-steven.price@arm.com>
 <68e545c8-57a3-4567-9e96-b46066cf6cee@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <68e545c8-57a3-4567-9e96-b46066cf6cee@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/01/2025 04:38, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> For now only 4k mappings are supported, future work may add support for
>> larger mappings.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v5:
>>   * Refactor to use PFNs rather than tracking struct page in
>>     realm_create_protected_data_page().
>>   * Pull changes from a later patch (in the v5 series) for accessing
>>     pages from a guest memfd.
>>   * Do the populate in chunks to avoid holding locks for too long and
>>     triggering RCU stall warnings.
>> ---
>>   arch/arm64/kvm/rme.c | 243 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 243 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 22f0c74455af..d4561e368cd5 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -4,6 +4,7 @@
>>    */
>>     #include <linux/kvm_host.h>
>> +#include <linux/hugetlb.h>
>>   
> 
> This wouldn't be needed since the huge pages, especially hugetlb part,
> isn't
> supported yet.

Indeed, thanks for spotting.

>>   #include <asm/kvm_emulate.h>
>>   #include <asm/kvm_mmu.h>
>> @@ -545,6 +546,236 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start, u64 size,
>>           realm_unmap_private_range(kvm, start, end);
>>   }
>>   +static int realm_create_protected_data_page(struct realm *realm,
>> +                        unsigned long ipa,
>> +                        kvm_pfn_t dst_pfn,
>> +                        kvm_pfn_t src_pfn,
>> +                        unsigned long flags)
>> +{
>> +    phys_addr_t dst_phys, src_phys;
>> +    int ret;
>> +
>> +    dst_phys = __pfn_to_phys(dst_pfn);
>> +    src_phys = __pfn_to_phys(src_pfn);
>> +
>> +    if (rmi_granule_delegate(dst_phys))
>> +        return -ENXIO;
>> +
>> +    ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa,
>> src_phys,
>> +                  flags);
>> +
>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +        /* Create missing RTTs and retry */
>> +        int level = RMI_RETURN_INDEX(ret);
>> +
>> +        ret = realm_create_rtt_levels(realm, ipa, level,
>> +                          RMM_RTT_MAX_LEVEL, NULL);
>> +        if (ret)
>> +            goto err;
>> +
>> +        ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa,
>> +                      src_phys, flags);
>> +    }
>> +
>> +    if (!ret)
>> +        return 0;
>> +
>> +err:
>> +    if (WARN_ON(rmi_granule_undelegate(dst_phys))) {
>> +        /* Page can't be returned to NS world so is lost */
>> +        get_page(pfn_to_page(dst_pfn));
>> +    }
>> +    return -ENXIO;
>> +}
>> +
>> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
>> +{
>> +    phys_addr_t rtt_addr;
>> +    int ret;
>> +
>> +    ret = realm_rtt_fold(realm, addr, level + 1, &rtt_addr);
>> +    if (ret)
>> +        return ret;
>> +
>> +    free_delegated_granule(rtt_addr);
>> +
>> +    return 0;
>> +}
>> +
>> +static int populate_par_region(struct kvm *kvm,
>> +                   phys_addr_t ipa_base,
>> +                   phys_addr_t ipa_end,
>> +                   u32 flags)
>> +{
> 
> At the first glance, I was wandering what's meant by 'par' in the
> function name.
> It turns to be a 2MB region and I guess it represents 'part'. I think
> this may
> be renamed to populate_sub_region() or populate_region() directly.

Actually 'par' is outdated and refers to "protected address range" which
is a concept which existed in an older version of CCA realms. It's
definitely in need of a rename! ;) I'll just drop the 'par' and call it
populate_region().

>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct kvm_memory_slot *memslot;
>> +    gfn_t base_gfn, end_gfn;
>> +    int idx;
>> +    phys_addr_t ipa;
>> +    int ret = 0;
>> +    unsigned long data_flags = 0;
>> +
>> +    base_gfn = gpa_to_gfn(ipa_base);
>> +    end_gfn = gpa_to_gfn(ipa_end);
>> +
>> +    if (flags & KVM_ARM_RME_POPULATE_FLAGS_MEASURE)
>> +        data_flags = RMI_MEASURE_CONTENT;
>> +
> 
> The 'data_flags' can be sorted out by its caller kvm_populate_realm(),
> and passed
> to populate_par_region(). In that way, we needn't to figure out
> 'data_flags' in
> every call to populate_par_region().

Ack

>> +    idx = srcu_read_lock(&kvm->srcu);
>> +    memslot = gfn_to_memslot(kvm, base_gfn);
>> +    if (!memslot) {
>> +        ret = -EFAULT;
>> +        goto out;
>> +    }
>> +
>> +    /* We require the region to be contained within a single memslot */
>> +    if (memslot->base_gfn + memslot->npages < end_gfn) {
>> +        ret = -EINVAL;
>> +        goto out;
>> +    }
>> +
>> +    if (!kvm_slot_can_be_private(memslot)) {
>> +        ret = -EINVAL;
>> +        goto out;
>> +    }
>> +
>> +    write_lock(&kvm->mmu_lock);
>> +
>> +    ipa = ipa_base;
>> +    while (ipa < ipa_end) {
>> +        struct vm_area_struct *vma;
>> +        unsigned long map_size;
>> +        unsigned int vma_shift;
>> +        unsigned long offset;
>> +        unsigned long hva;
>> +        struct page *page;
>> +        bool writeable;
>> +        kvm_pfn_t pfn;
>> +        int level, i;
>> +
>> +        hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
>> +        vma = vma_lookup(current->mm, hva);
>> +        if (!vma) {
>> +            ret = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        /* FIXME: Currently we only support 4k sized mappings */
>> +        vma_shift = PAGE_SHIFT;
>> +
>> +        map_size = 1 << vma_shift;
>> +
>> +        ipa = ALIGN_DOWN(ipa, map_size);
>> +
> 
> The blank lines in above 5 lines can be dropped :)

:) Agreed

>> +        switch (map_size) {
>> +        case RMM_L2_BLOCK_SIZE:
>> +            level = 2;
>> +            break;
>> +        case PAGE_SIZE:
>> +            level = 3;
>> +            break;
>> +        default:
>> +            WARN_ONCE(1, "Unsupported vma_shift %d", vma_shift);
>> +            ret = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        pfn = __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_WRITE,
>> +                    &writeable, &page);
>> +
>> +        if (is_error_pfn(pfn)) {
>> +            ret = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        if (level < RMM_RTT_MAX_LEVEL) {
>> +            /*
>> +             * A temporary RTT is needed during the map, precreate
>> +             * it, however if there is an error (e.g. missing
>> +             * parent tables) this will be handled in the
>> +             * realm_create_protected_data_page() call.
>> +             */
>> +            realm_create_rtt_levels(realm, ipa, level,
>> +                        RMM_RTT_MAX_LEVEL, NULL);
>> +        }
>> +
> 
> This block of code to create the temporary RTT can be removed. With it
> removed,
> we're going to rely on realm_create_protected_data_page() to create the
> needed
> RTT in its failing path. If the temporary RTT has been existing, the
> function
> call to realm_create_rtt_levels() doesn't nothing except multiple RMI
> calls are
> issued. RMI calls aren't cheap and it causes performance lost if you agree.

Actually this is to avoid extra RMI calls - albeit this is irrelevant
with the current FIXME above because everything is 4k.

For a block mapping it's still required to create RTTs to the full
depth, the individual 4k pages are then mapped, and finally the RTTs are
"folded" to remove the bottom table.

So in the usual case where RTTs exist to level 2 (because there are
other mappings nearby) then attempting to create the final level avoids
the first call to rmi_data_create() (in
realm_create_protected_data_page()) failing.

We don't expect tables to be created to RMM_RTT_MAX_LEVEL - because that
implies that there is something already mapped there (although this can
also happen in the situation where there was previously something mapped
but it has been unmapped without the RTTs being destroyed).

The comment is there because rather than adding another path for the
situation where parent tables don't exist, this is handled by the
rmi_data_create() failing in realm_create_protected_data_page() - the
error code lets us know which levels are needed. This is (of course)
inefficient, but it will be rare.

But given that I haven't got huge pages supported yet it's hard to make
any real judgements about the trade-offs and which is going to be most
performant.

>> +        for (offset = 0, i = 0; offset < map_size && !ret;
>> +             offset += PAGE_SIZE, i++) {
>> +            phys_addr_t page_ipa = ipa + offset;
>> +            kvm_pfn_t priv_pfn;
>> +            struct page *gmem_page;
>> +            int order;
>> +
>> +            ret = kvm_gmem_get_pfn(kvm, memslot,
>> +                           page_ipa >> PAGE_SHIFT,
>> +                           &priv_pfn, &gmem_page, &order);
>> +            if (ret)
>> +                break;
>> +
>> +            ret = realm_create_protected_data_page(realm, page_ipa,
>> +                                   priv_pfn,
>> +                                   pfn + i,
>> +                                   data_flags);
>> +        }
>> +
>> +        kvm_release_faultin_page(kvm, page, false, false);
>> +
>> +        if (ret)
>> +            break;
>> +
>> +        if (level == 2)
>> +            fold_rtt(realm, ipa, level);
>> +
>> +        ipa += map_size;
>> +    }
>> +
>> +    write_unlock(&kvm->mmu_lock);
>> +
>> +out:
>> +    srcu_read_unlock(&kvm->srcu, idx);
>> +    return ret;
>> +}
>> +
>> +static int kvm_populate_realm(struct kvm *kvm,
>> +                  struct kvm_cap_arm_rme_populate_realm_args *args)
>> +{
>> +    phys_addr_t ipa_base, ipa_end;
>> +
>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +        return -EINVAL;
>> +
>> +    if (!IS_ALIGNED(args->populate_ipa_base, PAGE_SIZE) ||
>> +        !IS_ALIGNED(args->populate_ipa_size, PAGE_SIZE))
>> +        return -EINVAL;
>> +
>> +    if (args->flags & ~RMI_MEASURE_CONTENT)
>> +        return -EINVAL;
>> +
>> +    ipa_base = args->populate_ipa_base;
>> +    ipa_end = ipa_base + args->populate_ipa_size;
>> +
>> +    if (ipa_end < ipa_base)
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * Perform the populate in parts to ensure locks are not held for
>> too
>> +     * long
>> +     */
>> +    while (ipa_base < ipa_end) {
>> +        phys_addr_t end = min(ipa_end, ipa_base + SZ_2M);
>> +
>> +        int ret = populate_par_region(kvm, ipa_base, end,
>> +                          args->flags);
>> +
>> +        if (ret)
>> +            return ret;
>> +
> 
> cond_resched() seems nice to have here so that those pending tasks can
> be run immediately.

Ack

Thanks,
Steve

>> +        ipa_base = end;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>>               unsigned long start,
>>               unsigned long end,
>> @@ -794,6 +1025,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>> kvm_enable_cap *cap)
>>           r = kvm_init_ipa_range_realm(kvm, &args);
>>           break;
>>       }
>> +    case KVM_CAP_ARM_RME_POPULATE_REALM: {
>> +        struct kvm_cap_arm_rme_populate_realm_args args;
>> +        void __user *argp = u64_to_user_ptr(cap->args[1]);
>> +
>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>> +            r = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        r = kvm_populate_realm(kvm, &args);
>> +        break;
>> +    }
>>       default:
>>           r = -EINVAL;
>>           break;
> 
> Thanks,
> Gavin
> 


