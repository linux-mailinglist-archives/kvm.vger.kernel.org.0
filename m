Return-Path: <kvm+bounces-25680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D499688C5
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 15:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB621C228F1
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 13:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBA120FA9C;
	Mon,  2 Sep 2024 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WK19Y6AI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D7184D
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725283511; cv=none; b=ARxFvDdbMvWPQk6JvmAov5LJrMCvNZwHS5GfEpUvAmLD0fKxYqpbx8m8BADaVj1Koq/yfP6RxmEYCeaVJf3drIs3uaCAdE47BTyzkD4Cb16hyl6F5CmpucalsjxdO1ypX4WXVS+Re43J7zv18Q+ID9GqMbaXKGVC5aRmbAT1b4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725283511; c=relaxed/simple;
	bh=3DTSioSmO8R4D8NbqBuLJAND5eXLasP9oeW5T5B5GLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSB+qnDunmSEPIefGAGj8VdqaBNzxSgEVRd/FiwyjvubZcna+IhQbg8f3Ai1diL1oB3w8NawE5fAobsnKfeQg/Q6wYb/l0jwRJbxvE/vkg6aKrgi7Ov679m/2iR2GYLY6ZLcwwUzjaRRlsCaAasn2vC9KikGInfJpQG7A7IRirE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WK19Y6AI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725283508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcqi+w8a7k+fZmieKnFjXwBMLevS5dcDtfb0W0QHqZw=;
	b=WK19Y6AIwLE2mAU6l7UtahBcFfrRbv7uwQjx/WzjwU/jbqBcshr6phbrXOQ/E4DGIud9hX
	43YMylA/byiFdSw0n/9QVHQyV6RRRZDwLWcPzeDzOzXx960CV3fEJlUHhiNLFB9X30wj2k
	5hXh/ZfoVnSYCAEYp04q39Zc46dVeLE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-XDfKaY_zO2KebhAHn8dcpg-1; Mon, 02 Sep 2024 09:25:07 -0400
X-MC-Unique: XDfKaY_zO2KebhAHn8dcpg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6c366f8b1ebso17433446d6.1
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 06:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725283507; x=1725888307;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcqi+w8a7k+fZmieKnFjXwBMLevS5dcDtfb0W0QHqZw=;
        b=QmhEZ0L3lQk3J5BB2lRa/onyQ7TMYL32VHiXn/NoP5Cvbus0zO8OWpqySrvD2kURfZ
         cLKBRxb3pbt+syC/O4VSiU0D9JOKKP5ecit8aClp97rQezulyiGGNw2ciIvZldqSr1qu
         V08F2v3oyCE8AW5JJDE0Oo+7BkppJOjMJx460BiUw3wjjRVTyY1E0LRbnYj7eZr7qIX8
         f7501PpRMwbxpUKlcfxMkhyDNdNMiesJ1IlCfCpgJlpk1+bgnHzXx7i95snLf3Nu8ytp
         GMjqRP/Ykrcj8+ikZZZRuDwNWYtUdirGi7/XDa2zDutgbrb74cPwsV4Os5IW047bYQsU
         HX1Q==
X-Gm-Message-State: AOJu0YwBHUdxQTKyeeIQEehR9aYMrUQLlJdRssrNxuN5/Eme95nYbKJV
	oEhwZllXvTS+VddbqLPbOVblXcwyK3Eg82bz96z71RdzPl7ZQ5MXMNWkLp1oP+ymCUfulw8hVpN
	CSLEd4OcLnYg8LRUcfIp5urofUClP3xxVcazDAFH1U3WTmalh4hzKRGsEL2u/
X-Received: by 2002:a05:6214:500e:b0:6b0:8ac1:26bc with SMTP id 6a1803df08f44-6c33f34e18emr240671466d6.14.1725283506632;
        Mon, 02 Sep 2024 06:25:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF57c2hqNLvwzNqEeleR+UGEqIDXgN59slKUoKlYXc0zt1IwtTMmYkM0vzwyL2JSwibHlG0Rg==
X-Received: by 2002:a05:6214:500e:b0:6b0:8ac1:26bc with SMTP id 6a1803df08f44-6c33f34e18emr240670956d6.14.1725283506013;
        Mon, 02 Sep 2024 06:25:06 -0700 (PDT)
Received: from fedora (193-248-58-176.ftth.fr.orangecustomers.net. [193.248.58.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340db411esm41640856d6.146.2024.09.02.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 06:25:05 -0700 (PDT)
Date: Mon, 2 Sep 2024 15:25:00 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
Message-ID: <ZtW8rNIdpd1wTx7w@fedora>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-22-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240821153844.60084-22-steven.price@arm.com>

Hello Steven, 

On Wed, Aug 21, 2024 at 04:38:22PM +0100, Steven Price wrote:
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
> Changes since v2:
>  * Avoid leaking memory if failing to map it in the realm.
>  * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>  * Adapt to changes in previous patches.
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  10 ++
>  arch/arm64/include/asm/kvm_rme.h     |  10 ++
>  arch/arm64/kvm/mmu.c                 | 120 +++++++++++++++-
>  arch/arm64/kvm/rme.c                 | 205 +++++++++++++++++++++++++--
>  4 files changed, 325 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7430c77574e3..0b50572d3719 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -710,6 +710,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>  	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>  }
>  
> +static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return BIT(realm->ia_bits - 1);
> +	}
> +	return 0;
> +}
> +
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
>  	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 0e44b20cfa48..c50854f44674 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -103,6 +103,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   u64 size,
>  			   bool unmap_private);
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache);
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache);
>  int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>  			unsigned long addr, unsigned long end,
>  			unsigned long ripas,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 620d26810019..eb8b8d013f3e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   kvm_pgtable_stage2_unmap,
> +					   may_block));
>  }
>  
>  void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> @@ -345,7 +350,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>  
> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr, false);
> +	else
> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>  }
>  
>  /**
> @@ -1037,6 +1045,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	struct kvm_memory_slot *memslot;
>  	int idx, bkt;
>  
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	mmap_read_lock(current->mm);
>  	write_lock(&kvm->mmu_lock);
> @@ -1062,6 +1074,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	if (kvm_is_realm(kvm) &&
>  	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>  	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK);
>  		write_unlock(&kvm->mmu_lock);
>  		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>  		return;
> @@ -1428,6 +1441,71 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>  
> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct page *page = pfn_to_page(pfn);
> +
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	if (!realm_is_addr_protected(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, page, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, ipa, page, map_size, memcache);
> +}
> +
> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
> +				 phys_addr_t fault_ipa,
> +				 struct kvm_memory_slot *memslot)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
> +	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
> +	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	kvm_pfn_t pfn;
> +	int ret;
> +
> +	if (priv_exists != is_priv_gfn) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      fault_ipa & ~gpa_stolen_mask,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_gfn);
> +
> +		return 0;
> +	}

If I understand correctly, `kvm_prepare_memory_fault_exit()` ends up
returning to the VMM with the KVM_EXIT_MEMORY_FAULT exit reason. The
documentation says (https://docs.kernel.org/virt/kvm/api.html#kvm-run):

"Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
it accompanies a return code of ‘-1’, not ‘0’! errno will always be set
to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
userspace should assume kvm_run.exit_reason is stale/undefined for all
other error numbers."

Shall the return code be different for KVM_EXIT_MEMORY_FAULT?

Thanks, Matias.

> +
> +	if (!is_priv_gfn) {
> +		/* Not a private mapping, handling normally */
> +		return -EAGAIN;
> +	}
> +
> +	ret = kvm_mmu_topup_memory_cache(memcache,
> +					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
> +	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
> +			    memcache);
> +	if (!ret)
> +		return 1; /* Handled */
> +
> +	put_page(pfn_to_page(pfn));
> +	return ret;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1449,10 +1527,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  
>  	if (fault_is_perm)
>  		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>  	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/*
> +	 * Realms cannot map protected pages read-only
> +	 * FIXME: It should be possible to map unprotected pages read-only
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>  	VM_BUG_ON(write_fault && exec_fault);
>  
> @@ -1553,7 +1640,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>  
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1634,7 +1721,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	/* FIXME: We shouldn't need to disable this for realms */
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
>  		if (fault_is_perm && fault_granule > PAGE_SIZE)
>  			vma_pagesize = fault_granule;
>  		else
> @@ -1686,6 +1774,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 */
>  		prot &= ~KVM_NV_GUEST_MAP_SZ;
>  		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>  	} else {
>  		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>  					     __pfn_to_phys(pfn), prot,
> @@ -1744,6 +1835,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	struct kvm_memory_slot *memslot;
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  	gfn_t gfn;
>  	int ret, idx;
>  
> @@ -1834,8 +1926,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		nested = &nested_trans;
>  	}
>  
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
> +		if (ret != -EAGAIN)
> +			goto out;
> +	}
> +
>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>  	write_fault = kvm_is_write_fault(vcpu);
>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> @@ -1879,6 +1978,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * of the page size.
>  		 */
>  		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +		ipa &= ~gpa_stolen_mask;
>  		ret = io_mem_abort(vcpu, ipa);
>  		goto out_unlock;
>  	}
> @@ -1927,6 +2027,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>  						   range->start << PAGE_SHIFT,
>  						   size, true);
> @@ -1943,6 +2047,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>  						   range->start << PAGE_SHIFT,
>  						   size, false);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 2c4e28b457be..337b3dd1e00c 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -627,6 +627,181 @@ static int fold_rtt(struct realm *realm, unsigned long addr, int level)
>  	return 0;
>  }
>  
> +static phys_addr_t rtt_get_phys(struct realm *realm, struct rtt_entry *rtt)
> +{
> +	bool lpa2 = realm->params->flags & RMI_REALM_PARAM_FLAG_LPA2;
> +
> +	if (lpa2)
> +		return rtt->desc & GENMASK(49, 12);
> +	return rtt->desc & GENMASK(47, 12);
> +}
> +
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t dst_phys = page_to_phys(dst_page);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long phys = dst_phys;
> +	unsigned long ipa = base_ipa;
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
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (map_level < RME_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RME_RTT_MAX_LEVEL, memcache);
> +	}
> +
> +	for (size = 0; size < map_size; size += PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			struct rtt_entry rtt;
> +
> +			/*
> +			 * It's possible we raced with another VCPU on the same
> +			 * fault. If the entry exists and matches then exit
> +			 * early and assume the other VCPU will handle the
> +			 * mapping.
> +			 */
> +			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
> +				goto err;
> +
> +			/*
> +			 * FIXME: For a block mapping this could race at level
> +			 * 2 or 3... currently we don't support block mappings
> +			 */
> +			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
> +				     rtt.state != RMI_ASSIGNED ||
> +				     rtt_get_phys(realm, &rtt) != phys))) {
> +				goto err;
> +			}
> +
> +			return 0;
> +		}
> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RME_RTT_MAX_LEVEL,
> +						      memcache);
> +			WARN_ON(ret);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +		WARN_ON(ret);
> +
> +		if (ret)
> +			goto err_undelegate;
> +
> +		phys += PAGE_SIZE;
> +		ipa += PAGE_SIZE;
> +	}
> +
> +	if (map_size == RME_L2_BLOCK_SIZE)
> +		ret = fold_rtt(realm, base_ipa, map_level);
> +	if (WARN_ON(ret))
> +		goto err;
> +
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
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int map_level;
> +	int ret = 0;
> +	unsigned long desc = page_to_phys(page) |
> +			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +			     /* FIXME: Read+Write permissions for now */
> +			     (3 << 6) |
> +			     PTE_SHARED;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
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
> +	if (WARN_ON(ret))
> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
>  static int populate_par_region(struct kvm *kvm,
>  			       phys_addr_t ipa_base,
>  			       phys_addr_t ipa_end,
> @@ -638,7 +813,6 @@ static int populate_par_region(struct kvm *kvm,
>  	int idx;
>  	phys_addr_t ipa;
>  	int ret = 0;
> -	struct page *tmp_page;
>  	unsigned long data_flags = 0;
>  
>  	base_gfn = gpa_to_gfn(ipa_base);
> @@ -660,9 +834,8 @@ static int populate_par_region(struct kvm *kvm,
>  		goto out;
>  	}
>  
> -	tmp_page = alloc_page(GFP_KERNEL);
> -	if (!tmp_page) {
> -		ret = -ENOMEM;
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		ret = -EINVAL;
>  		goto out;
>  	}
>  
> @@ -729,28 +902,32 @@ static int populate_par_region(struct kvm *kvm,
>  		for (offset = 0; offset < map_size && !ret;
>  		     offset += PAGE_SIZE, page++) {
>  			phys_addr_t page_ipa = ipa + offset;
> +			kvm_pfn_t priv_pfn;
> +			int order;
> +
> +			ret = kvm_gmem_get_pfn(kvm, memslot,
> +					       page_ipa >> PAGE_SHIFT,
> +					       &priv_pfn, &order);
> +			if (ret)
> +				break;
>  
>  			ret = realm_create_protected_data_page(realm, page_ipa,
> -							       page, tmp_page,
> -							       data_flags);
> +							       pfn_to_page(priv_pfn),
> +							       page, data_flags);
>  		}
> +
> +		kvm_release_pfn_clean(pfn);
> +
>  		if (ret)
> -			goto err_release_pfn;
> +			break;
>  
>  		if (level == 2)
>  			fold_rtt(realm, ipa, level);
>  
>  		ipa += map_size;
> -		kvm_release_pfn_dirty(pfn);
> -err_release_pfn:
> -		if (ret) {
> -			kvm_release_pfn_clean(pfn);
> -			break;
> -		}
>  	}
>  
>  	mmap_read_unlock(current->mm);
> -	__free_page(tmp_page);
>  
>  out:
>  	srcu_read_unlock(&kvm->srcu, idx);
> -- 
> 2.34.1
> 
> 


