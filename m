Return-Path: <kvm+bounces-48707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD34DAD1646
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 02:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58E35188A37A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 00:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3C91E521;
	Mon,  9 Jun 2025 00:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0QlQ9xN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132E41362
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 00:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749428868; cv=none; b=WPCho4cbNE0nks6DQr3o4pJEFtyHexxHWtO+SOLSkowuhe07bckmkKLzl3OtqJb/s1pnOjQh8Ds0R8BT2QD4A97YqQPrOShb57QErmzdAogjjPCdSTVUCpXY5XSAZ9xboA0HzVLbb1lHSG81ZFC/8mj6rSoB0bVoHecKxwaZwi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749428868; c=relaxed/simple;
	bh=7WpUKqEOXwgaoE3GafJ8Z0bG+eTIgCVsRCcOjaCfoj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjWoZcGhEFpKuk0FYsLjGqVCU2mNuufBXGmIilH9vBNS6P0fi0E3tavQA8Qze3UBt0oyfHKS45bvYZ2Oo87pEMl9okTAgvxT+ZE9P+hc7rM6/dqwbK011BfNrsmWfsvz5G67yo1pIAwS90NhIzCO4k0Rq/n38X1g+aA6KD2uRy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0QlQ9xN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749428866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o9UNmllkjwQtpYWDrQxVcySKnjZcVFIMjHUJsdLCTJk=;
	b=K0QlQ9xNu2LedAmRoskhVrjs4D0JlKlhmaI5Ufle29Q/p6zwNJLDA7o3BZ4zZf1/uVx4mn
	6JTPwnWtRtDDjpjrAwQjOP8w4V0tfZ+BTBsvG6ddGZuaZFbq/s4nGFSrY24aNDTWusGU1g
	iG30gloWsMCgCWLZH0JZobbL4lzwX/c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-45U9A_mjMs6hRmqqeOR_hA-1; Sun, 08 Jun 2025 20:27:44 -0400
X-MC-Unique: 45U9A_mjMs6hRmqqeOR_hA-1
X-Mimecast-MFC-AGG-ID: 45U9A_mjMs6hRmqqeOR_hA_1749428864
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2358de17665so34677565ad.3
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 17:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749428864; x=1750033664;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9UNmllkjwQtpYWDrQxVcySKnjZcVFIMjHUJsdLCTJk=;
        b=XlsVACVh6I+ofGznns4KXudwfaFbyGLGujELzl4ZhFlq4AzyW1/hJOeS6v4MeA6c5O
         CVw8pjKq4Gxzv5bVoiGz3wp8m7WjdMtXHmjwClOSD/FTPhwU2Le5792Dqrm+eCbOwwN5
         bH0AM8vQsiXlD5eyXyoSYb5bSeoga+x+OzhGOfh2evKI82Q47P5KOKAJJFondKVCTUYU
         Ywi0nhh8gWxsHXYauY1HPtQ4kmCMZbnbfkyGJAysOxv6R476wQY5fB7/lGUx2Wsqe5fP
         /rLpzXsxiVj2hJFdw4U5iGpiB4+NvccXIpf4nUIRJky8p1tmAYRi2X8nLZHly9FCyfuO
         DvMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnXP6pVl4D0O7VDLW0P0XvNjFZC4ZmZGdaCdNq8GaxThyFsyqZSj0EzoEzNF6ZbRUy7Gs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/rUke+t5znfCwW6/SEfykkxUqg3kBF767ITR5i015NJZwzlVW
	sySbXCNOG+BJVhdL8SsI0ixA8m2p7clPsZfsrv8BdVxrMUURqBfHKXxB1VN3MRY4pKXvlkz+hrE
	Uc83zCuSSkViuUZbpfzViKmYO31qngNWx26GhKvfcuApfCZrXy3oJfQ==
X-Gm-Gg: ASbGncshH0xV6kfuAyvPntG1u5njLXpQO4/NuVKifpzT332oBbkIQM/qAua5LWWbIby
	2jAAKCW3YLMazOkq+Ix7q2P04OdPDl3DhYuVub48XmotaqArW609Entll23WMts5zu4VPzZOaDU
	Sj5yw/6k1nBiuP31B/TJbIrTN29bLgku4NZAwY5IfIcM70kaWCkCUva6qO7x+mL93wzFbjdg/VX
	K8Tf0ga4wy9lXyHsJOphaJpvhG52rQ6x95aQdGuSYmGY5XML5zVybKbcqIELvapP596JgMNH16t
	q6rnIFyPN2XEtfH8KWlGSSjgHe/pkw5plgFsjTDqKislsQG/4RI=
X-Received: by 2002:a17:902:db10:b0:235:ef67:b5a0 with SMTP id d9443c01a7336-23601d977c9mr168621775ad.36.1749428863644;
        Sun, 08 Jun 2025 17:27:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEIahDyULI4f4Ir1WuH59IRh27zdVpHrZxdQdpnA/44DRpbUCVtuOsfb5+cTtGSF8pRBHI7Q==
X-Received: by 2002:a17:902:db10:b0:235:ef67:b5a0 with SMTP id d9443c01a7336-23601d977c9mr168621195ad.36.1749428863043;
        Sun, 08 Jun 2025 17:27:43 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236034059b3sm43590825ad.175.2025.06.08.17.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 17:27:42 -0700 (PDT)
Message-ID: <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
Date: Mon, 9 Jun 2025 10:27:21 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 13/18] KVM: arm64: Refactor user_mem_abort()
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
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-14-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-14-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> To simplify the code and to make the assumptions clearer,
> refactor user_mem_abort() by immediately setting force_pte to
> true if the conditions are met.
> 
> Remove the comment about logging_active being guaranteed to never be
> true for VM_PFNMAP memslots, since it's not actually correct.
> 
> Move code that will be reused in the following patch into separate
> functions.
> 
> Other small instances of tidying up.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 100 ++++++++++++++++++++++++-------------------
>   1 file changed, 55 insertions(+), 45 deletions(-)
> 

One nitpick below in case v12 is needed. In either way, it looks good to me:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index eeda92330ade..ce80be116a30 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1466,13 +1466,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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

It's unnecessary to initialize 'memcache' when topup_memcache is false.

	if (!topup_memcache)
		return 0;

	min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
	if (!is_protected_kvm_enabled())
		*memcache = &vcpu->arch.mmu_page_cache;
	else
		*memcache = &vcpu->arch.pkvm_memcache;

Thanks,
Gavin

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
> @@ -1484,6 +1527,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	gfn_t gfn;
>   	kvm_pfn_t pfn;
>   	bool logging_active = memslot_is_logging(memslot);
> +	bool force_pte = logging_active || is_protected_kvm_enabled();
>   	long vma_pagesize, fault_granule;
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
> @@ -1501,28 +1545,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   	}
>   
> -	if (!is_protected_kvm_enabled())
> -		memcache = &vcpu->arch.mmu_page_cache;
> -	else
> -		memcache = &vcpu->arch.pkvm_memcache;
> -
>   	/*
>   	 * Permission faults just need to update the existing leaf entry,
>   	 * and so normally don't require allocations from the memcache. The
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
> @@ -1536,16 +1568,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   	}
>   
> -	/*
> -	 * logging_active is guaranteed to never be true for VM_PFNMAP
> -	 * memslots.
> -	 */
> -	if (logging_active || is_protected_kvm_enabled()) {
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
> @@ -1597,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			max_map_size = PAGE_SIZE;
>   
>   		force_pte = (max_map_size == PAGE_SIZE);
> -		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> +		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
>   	}
>   
>   	/*
> @@ -1626,7 +1652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>   	 * with the smp_wmb() in kvm_mmu_invalidate_end().
>   	 */
> -	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> +	mmu_seq = kvm->mmu_invalidate_seq;
>   	mmap_read_unlock(current->mm);
>   
>   	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> @@ -1661,24 +1687,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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


