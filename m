Return-Path: <kvm+bounces-45006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E117AA58F6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BFC71C2144E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813F1171CD;
	Thu,  1 May 2025 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2qxulPd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D620EB
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746058613; cv=none; b=XUVyY/CPdmS7uJn6KD9Gd6HLzshivdNZw8Ic6skrB3MrUIp2+a4yw6ILTZIjf6/TEU9EmjeiDh/KuL9FgFVqQq6jCb91vViPUM0E6V2ScFyel6iiKu5DDyK1OZMpsjt1CWwBIwlgeBtQ2gyTVGylXAvBirnFGuIwvUVtgubT5uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746058613; c=relaxed/simple;
	bh=47CoopMyUfAejCNY06coQyZIdMENgtC3KaqSv/FeFcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UicV7Dvr75+jU+jOBgxeF7eXhSO4ixSTesMv4zWJiyLmOfAtjS9j9Shp9za+r3tnlSHRGlUpbfv2cz3HQoF/TLQBfLSEmWNFSj1TmL4Yk0kdeYHfjrw7/4ZdaEwFNK/JxrgwMIGGYXTL49QjOdTz/5dNVB5S4KmZy8gW0VXninw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2qxulPd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746058610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZb7eMkJRyx/Lus2IgqKmamTgxXPWBKqlzSs8f4bCVI=;
	b=R2qxulPdyPXqATHDV7ffIrK2qbFFFJie3DhRtTtYOu2caCDo77mQxgc3Mz3Ijp4iS+Q3DS
	o8W1l7KMO8GP1QDmnyaK9qhmp/tmVAppqPxvncLKRfB6FA13WIJx4lnA6JvL6r2ZNsKdYi
	vDX5MwpldCrAIlj+f8fVFy5mbyR+23o=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-uqCGDNzeNbaLsUoMOTtW0g-1; Wed, 30 Apr 2025 20:16:49 -0400
X-MC-Unique: uqCGDNzeNbaLsUoMOTtW0g-1
X-Mimecast-MFC-AGG-ID: uqCGDNzeNbaLsUoMOTtW0g_1746058608
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-30a2b6c8ff2so440060a91.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 17:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746058608; x=1746663408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZb7eMkJRyx/Lus2IgqKmamTgxXPWBKqlzSs8f4bCVI=;
        b=PV1AYwjlbWMDk5kWqX7Xr1kWzLDF4+ih2lxGaW728OCf50WsraORvRemS/mizgYv5Z
         vaa9v75QCTTLZ0KpfDrIjTQ7Lch9A6wj2iOKKjrk3xDbaAT8uEaJK/Uxff9+zG8Q06no
         VWqArDh/aDI4Dtdlsi8q2wn84lG6M16KlZ9L+lWhT8W3w8s5Km0GUX1o936OgYkSIkl/
         w3x3jk5X0XVW3IFG2GwTw3T6pTch9a95T+fpTJIqh0NBJG8ENvbv4N9Chesy8PkGuud8
         A9pKBFspxc67mT9Hsdn/cSolDdyfqC5XLPKo9poDkTK7LKYbhl+5S82o1Yi/XFuSKXk8
         BFhg==
X-Forwarded-Encrypted: i=1; AJvYcCWrIN+SrM7+00gWR5WhS3oHKP15Ei9EmvGjyJpRSiBC8V4Syh6japuqGyCaNqGygFAdGzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzklG+tFZQjyonBjPaLu/jfMJFIS9mbjAgOxIVL/2wm0NHKgPDm
	aqkS/LIO+7+M8CFwRmK7kZkkTMe3kXRj8PBwErhI/eMvMu+5t09BoKEgeqpR6nuGP+O3O9V/R4F
	Fz4L0O2OVStOMmvjMMr6iUg4rL/6Cvs6A2kSMxxv/6+a2gwjcUA==
X-Gm-Gg: ASbGnctbt4iTRVOguLCrwfFLm1NshMOUKDxrIb77rJRq7aZg64FAtK2bzuXdKb6//MO
	82BQXaMZlHTzuGi7WbOpxbGpvEU/3G3WrPQ92i4pvXinkEBUTcjdLeQSI0AyEDazn3LB5e5FWyr
	UCepVXnALQNeglEN36b9ViJ46AkNBKmlbYZq8UYFLS1tXuErlR9u3krnTzbXZYDvNEF0PzgPRPf
	BT8aAuzTMxlsLLGHTlBQGSEY4yis8ITjwIbj60bX3IvXFeCxQ7OiiHLU/BYPGZuMUvn7E6M3Lte
	1vnf7gXZkUeV
X-Received: by 2002:a17:90b:544e:b0:2ff:5a9d:937f with SMTP id 98e67ed59e1d1-30a3335f521mr8269824a91.24.1746058607787;
        Wed, 30 Apr 2025 17:16:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0+5LsVstlB0oWs/emtPEk9ieFB3kYXVq8522/16fp81LD4gGp0OBkwBulVxLtIQwxremaeQ==
X-Received: by 2002:a17:90b:544e:b0:2ff:5a9d:937f with SMTP id 98e67ed59e1d1-30a3335f521mr8269777a91.24.1746058607287;
        Wed, 30 Apr 2025 17:16:47 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a349ffe38sm2311087a91.12.2025.04.30.17.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 17:16:46 -0700 (PDT)
Message-ID: <c99b408c-3819-482a-a427-68045211e434@redhat.com>
Date: Thu, 1 May 2025 10:16:36 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/43] arm64: RME: Runtime faulting of memory
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
 <20250416134208.383984-21-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
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
> Changes since v7:
>   * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>     internally WARN when necessary.
> Changes since v6:
>   * Handle PAGE_SIZE being larger than RMM granule size.
>   * Some minor renaming following review comments.
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
>   arch/arm64/kvm/mmu.c                 | 127 ++++++++++++++++++-
>   arch/arm64/kvm/rme.c                 | 180 +++++++++++++++++++++++++++
>   4 files changed, 321 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c803c8188d9c..def439d6d732 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -704,6 +704,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>   }
>   
> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return ipa & ~BIT(realm->ia_bits - 1);
> +	}
> +	return ipa;
> +}
> +
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index d86051ef0c5c..47aa6362c6c9 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -108,6 +108,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   unsigned long size,
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
>   
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 71c04259e39f..02b66ee35426 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -338,8 +338,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
> +					   may_block));
>   }
>   

As spotted previsouly, the parameter @may_block isn't handled by kvm_realm_unmap_range().

>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> @@ -359,7 +364,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
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
> @@ -1053,6 +1061,10 @@ void stage2_unmap_vm(struct kvm *kvm)
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
> @@ -1078,6 +1090,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK, false);
>   		write_unlock(&kvm->mmu_lock);
>   		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);

(~0ULL & PAGE_MASK) wouldn't be a problem since the range will be limited to
[0, BIT(realm->ia_bits) - 1] in kvm_realm_unmap_range(). I think it's reasonable
to pass the maximal size here, something like:

		kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);

>   
> @@ -1482,6 +1495,82 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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

A comment to explain why KVM_PGTABLE_PROT_W is required would be nice, something like:

	/*
	 * Write permission is required for now even though it's possible to
	 * map unprotected pages (granules) as read-only. It's impossible to
	 * map protected pages (granules) as read-only.
	 */

> +
> +	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
> +
> +	if (!kvm_realm_is_private_address(realm, ipa))
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
> +	bool is_priv_gfn = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	int ret;
> +	/*
> +	 * For Realms, the shared address is an alias of the private GPA with
> +	 * the top bit set. Thus is the fault address matches the GPA then it
> +	 * is the private alias.
> +	 */
> +	bool is_priv_fault = (gpa == fault_ipa);
> +
> +	if (is_priv_gfn != is_priv_fault) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      gpa,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_fault);

nit:

		kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
				kvm_is_write_fault(vcpu), false, is_priv_fault);

> +
> +		/*
> +		 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT,
> +		 * see the API documentation
> +		 */
> +		return -EFAULT;
> +	}
> +
> +	if (!is_priv_fault) {
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
> @@ -1509,6 +1598,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
> @@ -1623,7 +1720,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ipa &= ~(vma_pagesize - 1);
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>   	mte_allowed = kvm_vma_mte_allowed(vma);
>   
>   	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1756,6 +1853,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		 */
>   		prot &= ~KVM_NV_GUEST_MAP_SZ;
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>   	} else {
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
> @@ -1897,8 +1997,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
> @@ -1942,7 +2049,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		 * of the page size.
>   		 */
>   		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> -		ret = io_mem_abort(vcpu, ipa);
> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>   		goto out_unlock;
>   	}
>   
> @@ -1990,6 +2097,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, true);
> @@ -2006,6 +2117,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, false);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f6af3ea6ea8a..b6959cd17a6c 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -714,6 +714,186 @@ static int realm_create_protected_data_page(struct realm *realm,
>   	return -ENXIO;
>   }
>   
> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
> +{
> +	phys_addr_t rtt_addr;
> +	int ret;
> +
> +	ret = realm_rtt_fold(realm, addr, level, &rtt_addr);
> +	if (ret)
> +		return ret;
> +
> +	free_delegated_granule(rtt_addr);
> +
> +	return 0;
> +}
> +
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
> +	if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE)))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	if (IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE))
> +		map_level = 2;
> +	else
> +		map_level = 3;
> +

This block of code can be compacted a bit:

	int map_level = IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE) ? 2 : 3;

	if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE) || !IS_ALIGNED(ipa, map_size))
		return -EINVAL;

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
> +	for (size = 0; size < map_size; size += RMM_PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			/*
> +			 * It's likely we raced with another VCPU on the same
> +			 * fault. Assume the other VCPU has handled the fault
> +			 * and return to the guest.
> +			 */
> +			return 0;
> +		}
> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			WARN_ON(level == RMM_RTT_MAX_LEVEL);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RMM_RTT_MAX_LEVEL,
> +						      memcache);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +
> +		if (WARN_ON(ret))
> +			goto err_undelegate;
> +
> +		phys += RMM_PAGE_SIZE;
> +		ipa += RMM_PAGE_SIZE;
> +	}
> +
> +	if (map_size == RMM_L2_BLOCK_SIZE) {
> +		ret = fold_rtt(realm, base_ipa, map_level + 1);
> +		if (WARN_ON(ret))
> +			goto err;
> +	}
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
> +		phys -= RMM_PAGE_SIZE;
> +		size -= RMM_PAGE_SIZE;
> +		ipa -= RMM_PAGE_SIZE;
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
> +			 unsigned long size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	unsigned long offset;
> +	int map_size, map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE)))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, size)))
> +		return -EINVAL;
> +
> +	if (IS_ALIGNED(size, RMM_L2_BLOCK_SIZE)) {
> +		map_level = 2;
> +		map_size = RMM_L2_BLOCK_SIZE;
> +	} else {
> +		map_level = 3;
> +		map_size = RMM_PAGE_SIZE;
> +	}
> +

Similiarly, it can be compacted a bit:

	int map_size = IS_ALIGNED(size, RMM_L2_BLOCK_SIZE) ? RMM_L2_BLOCK_SIZE : RMM_PAGE_SIZE;
	int map_level = IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE) ? 2 : 3;

	if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE) || !IS_ALIGNED(ipa, size))
		return -EINVAL;

> +	for (offset = 0; offset < size; offset += map_size) {
> +		/*
> +		 * realm_map_ipa() enforces that the memory is writable,
> +		 * so for now we permit both read and write.
> +		 */
> +		unsigned long desc = phys |
> +				     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      map_level, memcache);
> +			if (ret)
> +				return -ENXIO;
> +
> +			ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +		}
> +		/*
> +		 * RMI_ERROR_RTT can be reported for two reasons: either the
> +		 * RTT tables are not there, or there is an RTTE already
> +		 * present for the address.  The call to
> +		 * realm_create_rtt_levels() above handles the first case, and
> +		 * in the second case this indicates that another thread has
> +		 * already populated the RTTE for us, so we can ignore the
> +		 * error and continue.
> +		 */
> +		if (ret && RMI_RETURN_STATUS(ret) != RMI_ERROR_RTT)
> +			return -ENXIO;

The comments needs to be aligned in format :)

If RMM returns RMI_ERROR_RTT for third case in the future, the assumption here
is broken. I think it's worthy to double confirm by checking the RTT entry
through RTT_READ_ENTRY interface. If the mapping doesn't exist, we probably
still need to retry.

> +
> +		ipa += map_size;
> +		phys += map_size;
> +	}
> +
> +	return 0;
> +}
> +
>   static int populate_region(struct kvm *kvm,
>   			   phys_addr_t ipa_base,
>   			   phys_addr_t ipa_end,

Thanks,
Gavin


