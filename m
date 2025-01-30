Return-Path: <kvm+bounces-36897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8CCA2287E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 06:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10F377A2562
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 05:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7041714B4;
	Thu, 30 Jan 2025 05:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WOidmkKI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5014EC73
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 05:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738214577; cv=none; b=YElNxxzqZMDSyXdTQ2oP6KPtQuQ+/mcWJ/Fe2FM/yT84GgMlN9UkauJsYKThuwvP1AnYYWf400g9cacTfJQpAV3kULyjnqSpV2g9KmBZI+hE2jgeSwbicpPxcYTYeWU+5B3AqMh96wECNSKtGcWFgPJe+2PQbPx5TIvyMvhr/vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738214577; c=relaxed/simple;
	bh=TTXcFdX0jbW31HN6B1hgIiJDiMx4fZkSCZHY7NeCxkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QfazK6Ygjgj25AvriQTj4iPhsstZX/27pRQovBm0+A8pA6oXcfReDb4jBQDgfUb8wHJhfEcEl+3iidBqbuRnhYiVvaGSeI9JqJXSWsfKeGXjvLc05YY47YbKwF/+OHHMy2IcAdpt1KMPDNMcxCBGJTSPcMmQU/OmyAJGOSFJ4jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WOidmkKI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738214574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJqmoyQhicf/RcQVlsyiFXFzEydJ+9aYbDRPjrVrplI=;
	b=WOidmkKIInI5YDtgbqi4VVvBQf0UxTY9Ni5IzL9st6BNFsNl5FW03VMBsoDKksqsvojMpa
	+6IOBKQCuteYEB3lfyuQsEgGO8g7a+TMDL5hwO7Bss4c1SDWQF/Ti3JT8wyaHqJryX5KBA
	1HmFMryLL8SedTYnuVNLUu5y5wHeWEY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-IBDk7ppJPTSIRySwYEknCA-1; Thu, 30 Jan 2025 00:22:52 -0500
X-MC-Unique: IBDk7ppJPTSIRySwYEknCA-1
X-Mimecast-MFC-AGG-ID: IBDk7ppJPTSIRySwYEknCA
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21648c8601cso8215925ad.2
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 21:22:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738214571; x=1738819371;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJqmoyQhicf/RcQVlsyiFXFzEydJ+9aYbDRPjrVrplI=;
        b=A+jPlPxGQzvD7MAZoXeHEe++Te2nGEoJtOEFLHNq/peBTI+TYOCbnJbuUKT960lVFj
         RGxDrJXN9gGWYDl2+wLZtlIOUxCpNSkzC2bfDBRmF73f+173FZEjG5evWfnJDILEfrQd
         zTTSDwF1Gx9gNRD2vyCW2o6SsSZ+NYV2a6Ln9zPOqISJjsdNZbY9K5cWIcDAm/1MquP4
         5uh890SUKN+DexzzTI2nWhVmiXio4IGy4ImWr242nr2NgWmcMgbeNBPPmGWMZ5r+ggvq
         xnYWNwvz6iWnG/lu/nCAOyU0erNowIl7HSYi+gaTCAtKp/szmV8Qm2Wekx6YuUVyHdjW
         IntA==
X-Forwarded-Encrypted: i=1; AJvYcCXG8Sd1Kvtov/1SQ2vb3REGCzLR2si+ebYSXUDkQDM8sxE/skhsI5ZlX9p95O8aOfemJfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfGtg4oDiS9c5U9YxnIEVuIA6HjuRrp9V2SN5vPu1RmJXL6w4g
	jtcN8rRHcprA8tpAcLEYUQD/v3L8ChnRji61zWN/MxJJpuSimABixYbJG/lHuBfe8qPCqj+UvCB
	TvnOgWXYBFtqmxcNHiq105wwYXKOOpBAX2kb49UHGJRJ2yuCqNQ==
X-Gm-Gg: ASbGnctBoh0sqiGHVP+qGN1EMRxiC7j/5PtGOP3EPaEzxpzNivedkqO5vTrrnCqSTg2
	ij1HIpla2FKVu7cK64OaEzQWpra4/FUZ9Iam29ydGjf6cRXI+G462zPjyBQnjHzBpnwZvDChzj3
	0KIGRx2K34/EjqXEkv0e2o4nSINwy3SBCIbZlV7ecMOBVK/eHY48galdo71o5kYYS3Jhxtz+nSQ
	nvnSE5vjcN4H6KtzfS6w5lcCvQ1fdLXF842fFyW7KqhoXvsRggRwhhPo/CDX6R7e3MjdQt8ySK6
	PpZXvg==
X-Received: by 2002:a17:902:d2c8:b0:21d:3bd7:afe8 with SMTP id d9443c01a7336-21dd7e00b71mr90545005ad.49.1738214571247;
        Wed, 29 Jan 2025 21:22:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu86/0ROuwvcJ0Pv2IWNCsQtCkxRL8TUgfOSraQ/KGbeeK3aNXf2w8gCD17pv9MGfJvQiBJQ==
X-Received: by 2002:a17:902:d2c8:b0:21d:3bd7:afe8 with SMTP id d9443c01a7336-21dd7e00b71mr90544755ad.49.1738214570798;
        Wed, 29 Jan 2025 21:22:50 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de31f6b37sm5212225ad.65.2025.01.29.21.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 21:22:50 -0800 (PST)
Message-ID: <3f0caace-ee05-4ddf-ae75-2157e77aa57c@redhat.com>
Date: Thu, 30 Jan 2025 15:22:41 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/43] arm64: RME: Runtime faulting of memory
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
 <20241212155610.76522-21-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Reduce use of struct page in preparation for supporting the RMM
>     having a different page size to the host.
>   * Handle a race when delegating a page where another CPU has faulted on
>     a the same page (and already delegated the physical page) but not yet
>     mapped it. In this case simply return to the guest to either use the
>     mapping from the other CPU (or refault if the race is lost).
>   * The changes to populate_par_region() are moved into the previous
>     patch where they belong.
> Changes since v4:
>   * Code cleanup following review feedback.
>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>     This is now set by the RMM and the host has no control of it and the
>     spec requires the bit to be set to zero.
> Changes since v2:
>   * Avoid leaking memory if failing to map it in the realm.
>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>   * Adapt to changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>   arch/arm64/kvm/mmu.c                 | 124 +++++++++++++++++++--
>   arch/arm64/kvm/rme.c                 | 156 +++++++++++++++++++++++++++
>   4 files changed, 293 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index ec2b6d9c9c07..b13e367b6972 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -720,6 +720,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>   }
>   
> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t fault_ipa)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return fault_ipa & ~BIT(realm->ia_bits - 1);
> +	}
> +	return fault_ipa;
> +}
> +

'fault' has been included in 'kvm_gpa_from_fault' and 'fault_ipa'. To avoid the
duplication, 'fault_ipa' can be renamed to 'ipa'.

>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 0410650cd545..158f77e24a26 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -99,6 +99,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   u64 size,
>   			   bool unmap_private);
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			kvm_pfn_t pfn,
> +			unsigned long size,
> +			struct kvm_mmu_memory_cache *memcache);
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 kvm_pfn_t pfn,
> +			 unsigned long size,
> +			 struct kvm_mmu_memory_cache *memcache);
>   int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			unsigned long addr, unsigned long end,
>   			unsigned long ripas,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b100d4b3aa29..e88714903ce5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   kvm_pgtable_stage2_unmap,
> +					   may_block));
>   }
>   
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> @@ -346,7 +351,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>   	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>   	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>   
> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr, false);
> +	else
> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>   }
>   
>   /**
> @@ -1037,6 +1045,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>   	struct kvm_memory_slot *memslot;
>   	int idx, bkt;
>   
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   	mmap_read_lock(current->mm);
>   	write_lock(&kvm->mmu_lock);
> @@ -1062,6 +1074,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK, false);
>   		write_unlock(&kvm->mmu_lock);
>   		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   
> @@ -1446,6 +1459,76 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>   	return vma->vm_flags & VM_MTE_ALLOWED;
>   }
>   
> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	if (!realm_is_addr_protected(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, pfn, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, ipa, pfn, map_size, memcache);
> +}
> +
> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
> +				 phys_addr_t fault_ipa,
> +				 struct kvm_memory_slot *memslot)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	int ret;
> +	/*
> +	 * For Realms, the shared address is an alias of the private GPA with
> +	 * the top bit set. Thus is the fault address matches the GPA then it
> +	 * is the private alias.
> +	 */
> +	bool is_priv_gfn = (gpa == fault_ipa);
> +

We may rename 'priv_exists' to 'was_priv_gfn', which is consistent to 'is_priv_gfn'.
Alternatively, we may use 'was_private' and 'is_private'.

> +	if (priv_exists != is_priv_gfn) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      gpa,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_gfn);
> +
> +		return -EFAULT;
> +	}
> +
> +	if (!is_priv_gfn) {
> +		/* Not a private mapping, handling normally */
> +		return -EINVAL;
> +	}
> +
> +	ret = kvm_mmu_topup_memory_cache(memcache,
> +					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
> +	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
> +			    memcache);
> +	if (!ret)
> +		return 1; /* Handled */
> +
> +	put_page(page);
> +	return ret;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1472,6 +1555,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>   	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/*
> +	 * Realms cannot map protected pages read-only
> +	 * FIXME: It should be possible to map unprotected pages read-only
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>   	VM_BUG_ON(write_fault && exec_fault);
>   
> @@ -1579,7 +1670,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ipa &= ~(vma_pagesize - 1);
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>   	mte_allowed = kvm_vma_mte_allowed(vma);
>   
>   	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1660,7 +1751,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * If we are not forced to use page mapping, check if we are
>   	 * backed by a THP and thus use block mapping if possible.
>   	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	/* FIXME: We shouldn't need to disable this for realms */
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
>   		if (fault_is_perm && fault_granule > PAGE_SIZE)
>   			vma_pagesize = fault_granule;
>   		else
> @@ -1712,6 +1804,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		 */
>   		prot &= ~KVM_NV_GUEST_MAP_SZ;
>   		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>   	} else {
>   		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
> @@ -1854,8 +1949,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		nested = &nested_trans;
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>   	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, ipa, memslot);
> +		if (ret != -EINVAL)
> +			goto out;
> +	}
> +
>   	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>   	write_fault = kvm_is_write_fault(vcpu);
>   	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> @@ -1899,7 +2001,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		 * of the page size.
>   		 */
>   		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> -		ret = io_mem_abort(vcpu, ipa);
> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>   		goto out_unlock;
>   	}
>   
> @@ -1947,6 +2049,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, true);
> @@ -1963,6 +2069,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, false);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index d4561e368cd5..146ef598a581 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -602,6 +602,162 @@ static int fold_rtt(struct realm *realm, unsigned long addr, int level)
>   	return 0;
>   }
>   
> +int realm_map_protected(struct realm *realm,
> +			unsigned long ipa,
> +			kvm_pfn_t pfn,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long base_ipa = ipa;
> +	unsigned long size;
> +	int map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RMM_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +

The same block of code, to return the RTT level according to the map size, has been
used for multiple times. It would be nice to introduce a helper for this.

> +	if (map_level < RMM_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RMM_RTT_MAX_LEVEL, memcache);
> +	}
> +

This block of code could be dropped. If the RTTs have been existing, realm_create_rtt_levels()
doesn't nothing, but several RMI calls are issued. RMI calls aren't cheap and it can cause
performance lost.

> +	for (size = 0; size < map_size; size += PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			/*
> +			 * It's likely we raced with another VCPU on the same
> +			 * fault. Assume the other VCPU has handled the fault
> +			 * and return to the guest.
> +			 */
> +			return 0;
> +		}

We probably can't bail immediately when error is returned from rmi_granule_delegate()
because we intend to map a region whose size is 'map_size'. So a 'continue' instead
of 'return 0' seems correct to me.

> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RMM_RTT_MAX_LEVEL,
> +						      memcache);
> +			WARN_ON(ret);
> +			if (ret)
> +				goto err_undelegate;

			if (WARN_ON(ret))
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +		WARN_ON(ret);
> +
> +		if (ret)
> +			goto err_undelegate;

		if (WARN_ON(ret))

> +
> +		phys += PAGE_SIZE;
> +		ipa += PAGE_SIZE;
> +	}
> +
> +	if (map_size == RMM_L2_BLOCK_SIZE)
> +		ret = fold_rtt(realm, base_ipa, map_level);
> +	if (WARN_ON(ret))
> +		goto err;
> +

The nested if statements are needed here because the WARN_ON() only
take effect on the return value from fold_rtt().

	if (map_size == RMM_L2_BLOCK_SIZE) {
		ret = fold_rtt(realm, base_ipa, map_level);
		if (WARN_ON(ret))
			goto err;
	}

> +	return 0;
> +
> +err_undelegate:
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Page can't be returned to NS world so is lost */
> +		get_page(phys_to_page(phys));
> +	}
> +err:
> +	while (size > 0) {
> +		unsigned long data, top;
> +
> +		phys -= PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +		ipa -= PAGE_SIZE;
> +
> +		WARN_ON(rmi_data_destroy(rd, ipa, &data, &top));
> +
> +		if (WARN_ON(rmi_granule_undelegate(phys))) {
> +			/* Page can't be returned to NS world so is lost */
> +			get_page(phys_to_page(phys));
> +		}
> +	}
> +	return -ENXIO;
> +}
> +
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 kvm_pfn_t pfn,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int map_level;
> +	int ret = 0;
> +	unsigned long desc = __pfn_to_phys(pfn) |
> +			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +			     /* FIXME: Read+Write permissions for now */
> +			     (3 << 6);
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RMM_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +

As above.

> +	ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level, map_level,
> +					      memcache);
> +		if (WARN_ON(ret))
> +			return -ENXIO;
> +
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +	}
> +	/*
> +	 * RMI_ERROR_RTT can be reported for two reasons: either the RTT tables
> +	 * are not there, or there is an RTTE already present for the address.
> +	 * The call to realm_create_rtt_levels() above handles the first case,
> +	 * and in the second case this indicates that another thread has
> +	 * already populated the RTTE for us, so we can ignore the error and
> +	 * continue.
> +	 */
> +	if (WARN_ON(ret && RMI_RETURN_STATUS(ret) != RMI_ERROR_RTT))
> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
>   static int populate_par_region(struct kvm *kvm,
>   			       phys_addr_t ipa_base,
>   			       phys_addr_t ipa_end,

Thanks,
Gavin


