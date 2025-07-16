Return-Path: <kvm+bounces-52613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C65B07391
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D88CF3A8C1F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE352EE991;
	Wed, 16 Jul 2025 10:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NqS28MpC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B4E1F0E24
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662213; cv=none; b=Y+Z3xDQ8xlWw83BdMxDUbv/fJGv3OIq4FSTotoBed5M8ZLbYIfxjc3vgjEV1qlmZ3JXrTlGbrhgBtRlJyNv5UHpVEbRP2HddXpBDsVIFpHCdJfA+Vs3ubO+gDjl6pHkl7LZ7MPQ4XorHb+P4GAfoIKWLFDMqIh5Fzel9IEVhhp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662213; c=relaxed/simple;
	bh=Tsc1Xe1qBO5FuZzG5+JMhiZ15rod/BXpM9D1I/2t98o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q0NKh0/cchm01FpJjzaGG3P2CD2w4T4ELJCX/EBrxx+MfCdNkh12yp9imCHMVRi34Ma2Y0R067gXDQOXVhVR4UPKM9RKYemRjkmsHeya+FdPYIckwtE86FAbZ3R9SvDqK2GdULdrdDOLBax3q7iQYgxE4ME2cn2tyUqpa7zxQAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NqS28MpC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752662210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4rOutu6emn1jUH6gZxmdkOM1xiraIgWWmX6c5FRKOw4=;
	b=NqS28MpCCm4+pl/Rcn+Z/+hZF/16l3z1gdINxVbadxfk14XfvHyMayQ5QO546VdU5/dGbA
	6Ez3q7erEvjSuriefYUxDwezLzt30S42gxYarNrHeAh1yOG8f8gVxcWCrRhAnmers2Tm19
	PBtTHqnfERMqf3gM+tUuNAYpnKupN54=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-r4um7uBzNguZje7-AZdJeA-1; Wed, 16 Jul 2025 06:36:49 -0400
X-MC-Unique: r4um7uBzNguZje7-AZdJeA-1
X-Mimecast-MFC-AGG-ID: r4um7uBzNguZje7-AZdJeA_1752662208
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b5fe97af5fso1437861f8f.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 03:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752662208; x=1753267008;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4rOutu6emn1jUH6gZxmdkOM1xiraIgWWmX6c5FRKOw4=;
        b=daNDeDSWWTxpBEJMsbYzkJgIVRQv8xhTIOubhuMhEJbpPbQcDrUmttJBUtqgUIBOxu
         3egsZbSPTM1p6HL7z9VZexsq8W3E3/S78p3TOiihwCvY9eVzCyn5cmSsHMLZwayRbQaI
         7n01wBamg5VEGVR/4wCcKWw64JYHucvHLbGDw7pZbMtRpNAVSezPdg0GJn/vhYkWLEad
         I2x49pW/NYmTJ9Cb3iliv8TPDATB5KajCbseY9nWgHLHjPXO89SckkAZ7JpaLGi1LUez
         N8FYulqHNWXy6HlJx3oIF0kBflZsj2E+Yx6adUFsxJfgyWHMs+JYYOYY24UMLkj2a/yr
         7S/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXN388tHzEjDpSdbJug3Aqcw44akBQPlK/UX8XIU3gKFanrQekHmkAMMu+tUCTwjQ7poBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY1mum4dIwVK3EkzLykIecQjJ740GDegkQ0yMX34IfZshQP/qd
	A8eCM8BxNogtu9bUDnc8fZEcdZpp0f+luRssx2rQSoHbp1mnue01ZXNbVqBlOcvMjxnSTqvikyU
	dmG8apH2QHbHXHm18IjDYxSdBvm32OhAl3J2GQN7qI0mMwtIQ75x2bA==
X-Gm-Gg: ASbGncv55ySdYtl9WKZfLHRYPIBffZetWGumI2v1NdBevtNQDmk9KkvO1cDZGniLy0U
	jUd4rphYS0IBB6oOo5csJjycmdEqzMQ2uDSAaQ/o0g9V15LilGNHwGEd+L222A7Zm3308SDF51L
	tzgAM0KBhUKbczQXoIiwN28ip1juxgLW3UCt6mCOfnTm8H9j+8jg5+5V2ezF60Cb3QJNQO3WeuI
	hQ6VjyhQ9iLRTjf5DEJ9OoqmqBADD2HpJJXJd8PxhG24UXL5T95IQ4AhfCqidHE6Ul0JbQk+ngr
	trSe2ftvc2C3tB8y87Ni+KaSPvMJ5W674jqAEPYNgtOUML/7pLb6UGzxnVSO0cGZN+oEdOFjpum
	wCCzrS1yn92k7RTkiZXSsLP2BVpsCV8PapvIZUmO0o3YLY/4KD39GQr91r5YpEtarn/s=
X-Received: by 2002:a5d:584e:0:b0:3a4:eb92:b5eb with SMTP id ffacd0b85a97d-3b60e523551mr1304043f8f.50.1752662207993;
        Wed, 16 Jul 2025 03:36:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPZOVooIiE4D7VY4Pu8CJq7+Wp/dgZGh1+ls5EgJLi2IB+AD4z3TJyoNFEewMKZ9U8y36IkA==
X-Received: by 2002:a5d:584e:0:b0:3a4:eb92:b5eb with SMTP id ffacd0b85a97d-3b60e523551mr1304002f8f.50.1752662207447;
        Wed, 16 Jul 2025 03:36:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:ed00:1769:dd7c:7208:eb33? (p200300d82f1ded001769dd7c7208eb33.dip0.t-ipconnect.de. [2003:d8:2f1d:ed00:1769:dd7c:7208:eb33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e8027f9sm17107415e9.14.2025.07.16.03.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 03:36:46 -0700 (PDT)
Message-ID: <39a217c1-29a9-4497-b3b6-bc0459e75a91@redhat.com>
Date: Wed, 16 Jul 2025 12:36:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 15/21] KVM: arm64: Refactor user_mem_abort()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-16-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250715093350.2584932-16-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.07.25 11:33, Fuad Tabba wrote:
> Refactor user_mem_abort() to improve code clarity and simplify
> assumptions within the function.
> 
> Key changes include:
> 
> * Immediately set force_pte to true at the beginning of the function if
>    logging_active is true. This simplifies the flow and makes the
>    condition for forcing a PTE more explicit.
> 
> * Remove the misleading comment stating that logging_active is
>    guaranteed to never be true for VM_PFNMAP memslots, as this assertion
>    is not entirely correct.
> 
> * Extract reusable code blocks into new helper functions:
>    * prepare_mmu_memcache(): Encapsulates the logic for preparing and
>      topping up the MMU page cache.
>    * adjust_nested_fault_perms(): Isolates the adjustments to shadow S2
>      permissions and the encoding of nested translation levels.
> 
> * Update min(a, (long)b) to min_t(long, a, b) for better type safety and
>    consistency.
> 
> * Perform other minor tidying up of the code.
> 
> These changes primarily aim to simplify user_mem_abort() and make its
> logic easier to understand and maintain, setting the stage for future
> modifications.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 110 +++++++++++++++++++++++--------------------
>   1 file changed, 59 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2942ec92c5a4..b3eacb400fab 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1470,13 +1470,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>   	return vma->vm_flags & VM_MTE_ALLOWED;
>   }
>   
> +static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
> +				void **memcache)
> +{
> +	int min_pages;
> +
> +	if (!is_protected_kvm_enabled())
> +		*memcache = &vcpu->arch.mmu_page_cache;
> +	else
> +		*memcache = &vcpu->arch.pkvm_memcache;
> +
> +	if (!topup_memcache)
> +		return 0;
> +
> +	min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> +
> +	if (!is_protected_kvm_enabled())
> +		return kvm_mmu_topup_memory_cache(*memcache, min_pages);
> +
> +	return topup_hyp_memcache(*memcache, min_pages);
> +}
> +
> +/*
> + * Potentially reduce shadow S2 permissions to match the guest's own S2. For
> + * exec faults, we'd only reach this point if the guest actually allowed it (see
> + * kvm_s2_handle_perm_fault).
> + *
> + * Also encode the level of the original translation in the SW bits of the leaf
> + * entry as a proxy for the span of that translation. This will be retrieved on
> + * TLB invalidation from the guest and used to limit the invalidation scope if a
> + * TTL hint or a range isn't provided.
> + */
> +static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> +				      enum kvm_pgtable_prot *prot,
> +				      bool *writable)
> +{
> +	*writable &= kvm_s2_trans_writable(nested);
> +	if (!kvm_s2_trans_readable(nested))
> +		*prot &= ~KVM_PGTABLE_PROT_R;
> +
> +	*prot |= kvm_encode_nested_level(nested);
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
>   			  bool fault_is_perm)
>   {
>   	int ret = 0;
> -	bool write_fault, writable, force_pte = false;
> +	bool topup_memcache;
> +	bool write_fault, writable;
>   	bool exec_fault, mte_allowed;
>   	bool device = false, vfio_allow_any_uc = false;
>   	unsigned long mmu_seq;
> @@ -1488,6 +1531,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	gfn_t gfn;
>   	kvm_pfn_t pfn;
>   	bool logging_active = memslot_is_logging(memslot);
> +	bool force_pte = logging_active;
>   	long vma_pagesize, fault_granule;
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
> @@ -1498,17 +1542,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>   	write_fault = kvm_is_write_fault(vcpu);
>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> -	VM_BUG_ON(write_fault && exec_fault);
> -
> -	if (fault_is_perm && !write_fault && !exec_fault) {
> -		kvm_err("Unexpected L2 read permission error\n");
> -		return -EFAULT;
> -	}
> -
> -	if (!is_protected_kvm_enabled())
> -		memcache = &vcpu->arch.mmu_page_cache;
> -	else
> -		memcache = &vcpu->arch.pkvm_memcache;
> +	VM_WARN_ON_ONCE(write_fault && exec_fault);
>   
>   	/*
>   	 * Permission faults just need to update the existing leaf entry,
> @@ -1516,17 +1550,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * only exception to this is when dirty logging is enabled at runtime
>   	 * and a write fault needs to collapse a block entry into a table.
>   	 */
> -	if (!fault_is_perm || (logging_active && write_fault)) {
> -		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> -
> -		if (!is_protected_kvm_enabled())
> -			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> -		else
> -			ret = topup_hyp_memcache(memcache, min_pages);
> -
> -		if (ret)
> -			return ret;
> -	}
> +	topup_memcache = !fault_is_perm || (logging_active && write_fault);
> +	ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
> +	if (ret)
> +		return ret;
>   
>   	/*
>   	 * Let's check if we will get back a huge page backed by hugetlbfs, or
> @@ -1540,16 +1567,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   	}
>   
> -	/*
> -	 * logging_active is guaranteed to never be true for VM_PFNMAP
> -	 * memslots.
> -	 */
> -	if (logging_active) {
> -		force_pte = true;
> +	if (force_pte)
>   		vma_shift = PAGE_SHIFT;
> -	} else {
> +	else
>   		vma_shift = get_vma_page_shift(vma, hva);
> -	}
>   
>   	switch (vma_shift) {
>   #ifndef __PAGETABLE_PMD_FOLDED
> @@ -1601,7 +1622,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			max_map_size = PAGE_SIZE;
>   
>   		force_pte = (max_map_size == PAGE_SIZE);
> -		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> +		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
>   	}
>   
>   	/*
> @@ -1630,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>   	 * with the smp_wmb() in kvm_mmu_invalidate_end().
>   	 */
> -	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> +	mmu_seq = kvm->mmu_invalidate_seq;
>   	mmap_read_unlock(current->mm);
>   
>   	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> @@ -1665,24 +1686,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (exec_fault && device)
>   		return -ENOEXEC;
>   
> -	/*
> -	 * Potentially reduce shadow S2 permissions to match the guest's own
> -	 * S2. For exec faults, we'd only reach this point if the guest
> -	 * actually allowed it (see kvm_s2_handle_perm_fault).
> -	 *
> -	 * Also encode the level of the original translation in the SW bits
> -	 * of the leaf entry as a proxy for the span of that translation.
> -	 * This will be retrieved on TLB invalidation from the guest and
> -	 * used to limit the invalidation scope if a TTL hint or a range
> -	 * isn't provided.
> -	 */
> -	if (nested) {
> -		writable &= kvm_s2_trans_writable(nested);
> -		if (!kvm_s2_trans_readable(nested))
> -			prot &= ~KVM_PGTABLE_PROT_R;
> -
> -		prot |= kvm_encode_nested_level(nested);
> -	}
> +	if (nested)
> +		adjust_nested_fault_perms(nested, &prot, &writable);
>   
>   	kvm_fault_lock(kvm);
>   	pgt = vcpu->arch.hw_mmu->pgt;
> @@ -1953,6 +1958,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		goto out_unlock;
>   	}
>   
> +	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> +
>   	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
>   			     esr_fsc_is_permission_fault(esr));
>   	if (ret == 0)


A note that on the KVM arm next tree

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=next

there are some user_mem_abort() changes. IIUC, only smaller conflicts.

-- 
Cheers,

David / dhildenb


