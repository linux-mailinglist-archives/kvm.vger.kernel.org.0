Return-Path: <kvm+bounces-7307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 653B783FD35
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 05:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2B0EB21BBC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 04:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E234719BA3;
	Mon, 29 Jan 2024 04:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmFk+bD2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94B14AAA;
	Mon, 29 Jan 2024 04:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706502567; cv=none; b=mKR/TfEIR/NSVy4BCSx/Txf6GhTuPu/GFTaE9Rhg9P7iVHwp5OA9DEXSPMyITpOCdgSdOypESIaBtuqZ/KoiNPkbLW8abeiVVoutbDo2AB6amKN3+/uIZgYbLP4CyIrkhuRCM1b8BEtfhDnMnBCcU9QyB1eGhOCG0OA0sFf0IFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706502567; c=relaxed/simple;
	bh=3EK/8yxeed8m7k4dlgjD0V/NjwPLMBHE+69C12MTZ18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hw3SBe0QSKWkCtxY2ypV7dAfEYmdji0P9mMLVnsYw0UMhUDCfLgHgOBUKc8BguOADY8i02Ds822LAfed80DdQauPnSWoxjoh0u42uEjTwJ4dvC2rBES07HuZQO5Wk00/08R8HGbQ8TEKS3nIfnc3FdX7KJIP2X5Swd7mhrfjiuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmFk+bD2; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706502565; x=1738038565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3EK/8yxeed8m7k4dlgjD0V/NjwPLMBHE+69C12MTZ18=;
  b=OmFk+bD2PXX+IfN88vXweFzYh5e5D0jSpW6UMakb4VbR+ai1EC+PUw1w
   jOqlcWdM8lswiiO6SKlH8z0cwMypgQeQeLPZunNSBNHGHg6uwd4wLIXq8
   8cJFJcLVy91sGktP6Na8qKB8i6Hb6+QidF84a8g84wM0XmjCkfkjB6hx0
   ArR8/0nVjbXdah8nYPSM7WhPd0YfVZnK2nuFvU1h6a/roQ1UDIeYttSZc
   MH0u43LuHt7xSWjhJIvu8WQc9IVTVADAhn+J368yUkSLg+gl/ii1R9GF/
   LznAK6Z9lRlNHDMZf8t15GrruMzuhxqXtka1NU3xiHILOncDxJNdC8bev
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="9521283"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="9521283"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 20:29:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="3229390"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 20:29:21 -0800
Message-ID: <56882cd9-67f5-4396-b91b-52fb202d3386@linux.intel.com>
Date: Mon, 29 Jan 2024 12:29:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 047/121] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <3a97d83c79350c4a2ae10de86270ee8f8d0bf1e2.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <3a97d83c79350c4a2ae10de86270ee8f8d0bf1e2.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For private GPA, CPU refers a private page table whose contents are
> encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used and their cost is expensive.
>
> When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> existing KVM MMU code and mitigate the heavy cost to directly walk private
> page table, allocate one more page to copy the dummy page table for KVM MMU
> code to directly walk.  Resolve KVM page fault with the existing code, and
> do additional operations necessary for the private page table.  To
> distinguish such cases, the existing KVM page table is called a shared page
> table (i.e. not associated with private page table), and the page table
> with private page table is called a private page table.  The relationship
> is depicted below.
>
> Add a private pointer to struct kvm_mmu_page for private page table and
> add helper functions to allocate/initialize/free a private page table
> page.
>
>                KVM page fault                     |
>                       |                           |
>                       V                           |
>          -------------+----------                 |
>          |                      |                 |
>          V                      V                 |
>       shared GPA           private GPA            |
>          |                      |                 |
>          V                      V                 |
>      shared PT root      dummy PT root            |    private PT root
>          |                      |                 |           |
>          V                      V                 |           V
>       shared PT            dummy PT ----propagate---->   private PT
>          |                      |                 |           |
>          |                      \-----------------+------\    |
>          |                                        |      |    |
>          V                                        |      V    V
>    shared guest page                              |    private guest page
>                                                   |
>                             non-encrypted memory  |    encrypted memory
>                                                   |
> PT: page table
> - Shared PT is visible to KVM and it is used by CPU.
> - Private PT is used by CPU but it is invisible to KVM.
> - Dummy PT is visible to KVM but not used by CPU.  It is used to
>    propagate PT change to the actual private PT which is used by CPU.

Nit: one typo below.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  5 ++
>   arch/x86/kvm/mmu/mmu.c          |  7 +++
>   arch/x86/kvm/mmu/mmu_internal.h | 83 +++++++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>   4 files changed, 92 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0cdbbc21136b..1d074956ac0d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -841,6 +841,11 @@ struct kvm_vcpu_arch {
>   	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>   	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>   	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	/*
> +	 * This cache is to allocate private page table. E.g.  Secure-EPT used
> +	 * by the TDX module.
> +	 */
> +	struct kvm_mmu_memory_cache mmu_private_spt_cache;
>   
>   	/*
>   	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 583ae9d6bf5d..32c619125be4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -685,6 +685,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>   	if (r)
>   		return r;
> +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_spt_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
>   	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
>   				       PT64_ROOT_MAX_LEVEL);
>   	if (r)
> @@ -704,6 +710,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_spt_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>   }
>   
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 97af4e39ce6f..957654c3cde9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -101,7 +101,23 @@ struct kvm_mmu_page {
>   		int root_count;
>   		refcount_t tdp_mmu_root_count;
>   	};
> -	unsigned int unsync_children;
> +	union {
> +		struct {
> +			unsigned int unsync_children;
> +			/*
> +			 * Number of writes since the last time traversal
> +			 * visited this page.
> +			 */
> +			atomic_t write_flooding_count;
> +		};
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +		/*
> +		 * Associated private shadow page table, e.g. Secure-EPT page
> +		 * passed to the TDX module.
> +		 */
> +		void *private_spt;
> +#endif
> +	};
>   	union {
>   		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
>   		tdp_ptep_t ptep;
> @@ -124,9 +140,6 @@ struct kvm_mmu_page {
>   	int clear_spte_count;
>   #endif
>   
> -	/* Number of writes since the last time traversal visited this page.  */
> -	atomic_t write_flooding_count;
> -
>   #ifdef CONFIG_X86_64
>   	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
>   	struct rcu_head rcu_head;
> @@ -150,6 +163,68 @@ static inline bool is_private_sp(const struct kvm_mmu_page *sp)
>   	return kvm_mmu_page_role_is_private(sp->role);
>   }
>   
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
> +{
> +	return sp->private_spt;
> +}
> +
> +static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
> +{
> +	sp->private_spt = private_spt;
> +}
> +
> +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +{
> +	bool is_root = vcpu->arch.root_mmu.root_role.level == sp->role.level;
> +
> +	KVM_BUG_ON(!kvm_mmu_page_role_is_private(sp->role), vcpu->kvm);
> +	if (is_root)
> +		/*
> +		 * Because TDX module assigns root Secure-EPT page and set it to
> +		 * Secure-EPTP when TD vcpu is created, secure page table for
> +		 * root isn't needed.
> +		 */
> +		sp->private_spt = NULL;
> +	else {
> +		/*
> +		 * Because the TDX module doesn't trust VMM and initializes
> +		 * the pages itself, KVM doesn't initialize them.  Allocate
> +		 * pages with garbage and give them to the TDX module.
> +		 */
> +		sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
> +		/*
> +		 * Because mmu_private_spt_cache is topped up before staring kvm
s/staring/starting

> +		 * page fault resolving, the allocation above shouldn't fail.
> +		 */
> +		WARN_ON_ONCE(!sp->private_spt);
> +	}
> +}
> +
> +static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
> +{
> +	if (sp->private_spt)
> +		free_page((unsigned long)sp->private_spt);
> +}
> +#else
> +static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
> +{
> +	return NULL;
> +}
> +
> +static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
> +{
> +}
> +
> +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +{
> +}
> +
> +static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
> +{
> +}
> +#endif
> +
>   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>   {
>   	/*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 87233b3ceaef..d47f0daf1b03 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>   
>   static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>   {
> +	kvm_mmu_free_private_spt(sp);
>   	free_page((unsigned long)sp->spt);
>   	kmem_cache_free(mmu_page_header_cache, sp);
>   }


