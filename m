Return-Path: <kvm+bounces-37881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09098A3106D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45BBA188B65F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79034254AF5;
	Tue, 11 Feb 2025 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m8ENGSZN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C789254AE9
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739289477; cv=none; b=jXXuP+M1LhKwxWfBF9F4Urb5ztNBwOax/OsCCIYf1r4+A+pk7IqRIXfF2DnyDgkSBy9HRg0AuVPVhRBMIIuKFZPJaVeTY8EfILdoPCJCCXQOfKqnORReWaBY1lHw4PUsCrs4HeMOHPtAr1Sq/Pw8Havzv13xkauN8yLLWKvMgiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739289477; c=relaxed/simple;
	bh=y4iKEJDDBwze0t7ZAI0gDJsyLMCySCJBcLUnHGyKpDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGpJehOKqc1xTNiIMbvDKHMuJa7oQFUiYWy81nzOFbR14D1w4whMkSrdCU8PZ7yweesesS1/qOcuQIP3mbh0/MHEOaSeFE9oDP91VVerZKSH/ChoJ2bwx331822YMcT8pSRMLqPaYQxDFZxCkk86Yhx8S0mauJe6bjDSR678Qpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m8ENGSZN; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5de56ff9851so7143353a12.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739289474; x=1739894274; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSy9CeX8Agir4rGMRLeCG9EkflqYF5Cr1FhyZfH86h4=;
        b=m8ENGSZN0XiwHfEQWQApn6TWuVfqrcGdm1G3QygmWvEktPHPCN9PhWvHxQVL5dmSwZ
         d/QrDnLVy3m1X5kLayLTkLVk2jdVcNyd7kw3kRmh8F9cN9zdmYuX6gDpNDnU+w/PhiGU
         cx918f287NZZp4Bb1/X8ZzLd7f7W9Wrqq0ojzPF64jZeppjcwiF5vYUKsJlvCZmxnj2a
         fS++vZ01jCvZTWjAKHCGmU4ZMbbBW0efauv39iJ4uqKfNbyMcLIeweeh5+rDHQ0Taclf
         1fQDT29LMfB8oSEBKqiUlZsw0X1AFCpD8eDDNqT6NJnBgeCHvdOy15bxO77hVu1wE4Zn
         BvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739289474; x=1739894274;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSy9CeX8Agir4rGMRLeCG9EkflqYF5Cr1FhyZfH86h4=;
        b=kRePA1g31tQhzBzlN9+JeVM2UaRUbaRuD4XPOxmwV/L+fwoHAjOsno3cSEEhEvLz3a
         7Cd5EhbRFnx8y2T0bLkGWyAPMkujYlZ1qBZ4JuxKWNs2x9oM0BkRgFDJvaKi39/o1frq
         NiAMexdXPEdCPDOTQY39eLv/VGzh+IdmgJHjLEl1begKOS2deFs52n7do4e7hTgBcge4
         5Epn8B/IgeR4eAOrU41fSuhrJLjLZFZuDIrFvIYT1rgdo+eA3+hRwwg3jPPbzBc4VURh
         FEpQ+V2cA8QuMa9Gu/aoFRoPkq5dBW403Lxe6qW9GjwJo8LAx9CFR4/60EBSRIsB8HN8
         A4ow==
X-Gm-Message-State: AOJu0Ywg3OI/+SH+FLvchRFbqLLmUk+3qq5JlShYwpHG2TIN/rfKh450
	MAg7wXwMocR0Jb/qjDtut4F3u9tQQxjRsWqpFoL4GVFQrLoiI7tAMreNbhHPmQ==
X-Gm-Gg: ASbGncv6DPkPhWJLa+XOYFaNC3DjUUiA3xydhC5mRFh6VrQCg074THt15NNbTKjBDAD
	LmlVeUA+PHwEQ27nhtKjhMfqogVu+HDrGxMpmGpCHfF1kQGqWBxlo3wyn22PpzM/TOzjwClB0ln
	cicF6Nzsl0RA9968r9I3zOX+BWNxGsjGn1xzEefdUjPW7V7M7wu9trHbHFFvELV3OGB6kLp0WCn
	+AHPA1xRO3pWNr3+VVKlbHhtYyG2l+OP8FEpupOxW6vcl5tpQhWx6WN8zueJxYl3gNAM8xKdMef
	O4kkYszzNA0Ba/wovF0hXGOjs4vJLvC0YgDcLGZYmtX7SQZwzQoi
X-Google-Smtp-Source: AGHT+IHvBbSF7MaP8XjqV6V+IWo7/0vGZiaY1WWsB3xUcJqEU+O4V3CWmqqms9kl920x44mAhGChyA==
X-Received: by 2002:a05:6402:238a:b0:5dc:e393:af63 with SMTP id 4fb4d7f45d1cf-5de9a3dc461mr3738748a12.16.1739289473700;
        Tue, 11 Feb 2025 07:57:53 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b7b0a2sm9755130a12.22.2025.02.11.07.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 07:57:52 -0800 (PST)
Date: Tue, 11 Feb 2025 15:57:48 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com,
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org,
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 08/11] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
Message-ID: <Z6tzfMW0TdwdAWxT@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211121128.703390-9-tabba@google.com>

Hey Fuad,

On Tuesday 11 Feb 2025 at 12:11:24 (+0000), Fuad Tabba wrote:
> Add arm64 support for handling guest page faults on guest_memfd
> backed memslots.
> 
> For now, the fault granule is restricted to PAGE_SIZE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c     | 84 ++++++++++++++++++++++++++--------------
>  include/linux/kvm_host.h |  5 +++
>  virt/kvm/kvm_main.c      |  5 ---
>  3 files changed, 61 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b6c0acb2311c..305060518766 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1454,6 +1454,33 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>  
> +static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			     gfn_t gfn, bool write_fault, bool *writable,
> +			     struct page **page, bool is_private)
> +{
> +	kvm_pfn_t pfn;
> +	int ret;
> +
> +	if (!is_private)
> +		return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writable, page);
> +
> +	*writable = false;
> +
> +	if (WARN_ON_ONCE(write_fault && memslot_is_readonly(slot)))
> +		return KVM_PFN_ERR_NOSLOT_MASK;

I believe this check is superfluous, we should decide to report an MMIO
exit to userspace for write faults to RO memslots and not get anywhere
near user_mem_abort(). And nit but the error code should probably be
KVM_PFN_ERR_RO_FAULT or something instead?

> +
> +	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
> +	if (!ret) {
> +		*writable = write_fault;

In normal KVM, if we're not dirty logging we'll actively map the page as
writable if both the memslot and the userspace mappings are writable.
With gmem, the latter doesn't make much sense, but essentially the
underlying page should really be writable (e.g. no CoW getting in the
way and such?). If so, then perhaps make this

		*writable = !memslot_is_readonly(slot);

Wdyt?

> +		return pfn;
> +	}
> +
> +	if (ret == -EHWPOISON)
> +		return KVM_PFN_ERR_HWPOISON;
> +
> +	return KVM_PFN_ERR_NOSLOT_MASK;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1461,25 +1488,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  {
>  	int ret = 0;
>  	bool write_fault, writable;
> -	bool exec_fault, mte_allowed;
> +	bool exec_fault, mte_allowed = false;
>  	bool device = false, vfio_allow_any_uc = false;
>  	unsigned long mmu_seq;
>  	phys_addr_t ipa = fault_ipa;
>  	struct kvm *kvm = vcpu->kvm;
> -	struct vm_area_struct *vma;
> +	struct vm_area_struct *vma = NULL;
>  	short vma_shift;
>  	void *memcache;
> -	gfn_t gfn;
> +	gfn_t gfn = ipa >> PAGE_SHIFT;
>  	kvm_pfn_t pfn;
>  	bool logging_active = memslot_is_logging(memslot);
> -	bool force_pte = logging_active || is_protected_kvm_enabled();
> -	long vma_pagesize, fault_granule;
> +	bool is_private = kvm_mem_is_private(kvm, gfn);

Just trying to understand the locking rule for the xarray behind this.
Is it kvm->srcu that protects it for reads here? Something else?

> +	bool force_pte = logging_active || is_private || is_protected_kvm_enabled();
> +	long vma_pagesize, fault_granule = PAGE_SIZE;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
>  	struct page *page;
>  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
>  
> -	if (fault_is_perm)
> +	if (fault_is_perm && !is_private)

Nit: not strictly necessary I think.

>  		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>  	write_fault = kvm_is_write_fault(vcpu);
>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> @@ -1510,24 +1538,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			return ret;
>  	}
>  
> +	mmap_read_lock(current->mm);
> +
>  	/*
>  	 * Let's check if we will get back a huge page backed by hugetlbfs, or
>  	 * get block mapping for device MMIO region.
>  	 */
> -	mmap_read_lock(current->mm);
> -	vma = vma_lookup(current->mm, hva);
> -	if (unlikely(!vma)) {
> -		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> -		mmap_read_unlock(current->mm);
> -		return -EFAULT;
> -	}
> +	if (!is_private) {
> +		vma = vma_lookup(current->mm, hva);
> +		if (unlikely(!vma)) {
> +			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> +			mmap_read_unlock(current->mm);
> +			return -EFAULT;
> +		}
>  
> -	/*
> -	 * logging_active is guaranteed to never be true for VM_PFNMAP
> -	 * memslots.
> -	 */
> -	if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
> -		return -EFAULT;
> +		/*
> +		 * logging_active is guaranteed to never be true for VM_PFNMAP
> +		 * memslots.
> +		 */
> +		if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
> +			return -EFAULT;
> +
> +		vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> +		mte_allowed = kvm_vma_mte_allowed(vma);
> +	}
>  
>  	if (force_pte)
>  		vma_shift = PAGE_SHIFT;
> @@ -1597,18 +1631,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		ipa &= ~(vma_pagesize - 1);
>  	}
>  
> -	gfn = ipa >> PAGE_SHIFT;
> -	mte_allowed = kvm_vma_mte_allowed(vma);
> -
> -	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> -
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
>  
>  	/*
>  	 * Read mmu_invalidate_seq so that KVM can detect if the results of
> -	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
> -	 * acquiring kvm->mmu_lock.
> +	 * vma_lookup() or faultin_pfn() become stale prior to acquiring
> +	 * kvm->mmu_lock.
>  	 *
>  	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>  	 * with the smp_wmb() in kvm_mmu_invalidate_end().
> @@ -1616,8 +1645,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	mmap_read_unlock(current->mm);
>  
> -	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> -				&writable, &page);
> +	pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_private);
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 39fd6e35c723..415c6274aede 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1882,6 +1882,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
>  	return gfn_to_memslot(kvm, gfn)->id;
>  }
>  
> +static inline bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> +{
> +	return slot->flags & KVM_MEM_READONLY;
> +}
> +
>  static inline gfn_t
>  hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38f0f402ea46..3e40acb9f5c0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2624,11 +2624,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	return size;
>  }
>  
> -static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> -{
> -	return slot->flags & KVM_MEM_READONLY;
> -}
> -
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
>  				       gfn_t *nr_pages, bool write)
>  {
> -- 
> 2.48.1.502.g6dc24dfdaf-goog
> 

