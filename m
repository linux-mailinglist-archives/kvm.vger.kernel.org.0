Return-Path: <kvm+bounces-7425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3389F841BC0
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AECA61F270B3
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 06:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2C138396;
	Tue, 30 Jan 2024 06:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVt67mZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4138385;
	Tue, 30 Jan 2024 06:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706594957; cv=none; b=aZ57DySUyprnQxQQCcbIVuoRimbQeJ+Sh8Kh1TdWO380A4mJmQMaTp7RWNik2SRPGAKqRd/wfVBY9Tc2+dkt0RoKoaPn6TqpMr0fiGa6GoCVle7zvKS3tZrZ3f5e+u7+HUxd0+ngrvi+7N1rVF6N6DcDI/MM2uiCNBdURrr9/iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706594957; c=relaxed/simple;
	bh=CBNVtpkAUZIbu206WZYostSlSnVa9yEV75iE3wZAZyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UysBTpVk6JzkNQ9Bo27Ny9I8LxaL/dk6xbHAd6/KjiaAz4QpINqEoygJvRzAe8IrKTKnKJgShqwVhpY1u1NPmOzIA3S7WHq8RFsFPCTa6KhrZDi6IboCAzgRhDhPorjrm53M3UrOvX4tyklDoSmt3DDJjF6JDCLhHzaJcHusppc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVt67mZ/; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706594955; x=1738130955;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CBNVtpkAUZIbu206WZYostSlSnVa9yEV75iE3wZAZyg=;
  b=UVt67mZ/uMILka1loG4B8Ityatq0e3BkRzpoHf5SLPYptELR9KpZOypi
   hCOY3Xjxtwvq0VzX6xiDPhlcwz4+7u0J9Sa7sK4HVY10k6x5bXcKyDEZk
   4OG6BcLwf97V8uTOCFFiOF5lllvjvS5QS3AhIBPR49jHcn53ydjvMAQI7
   oyugiwwuZfvU4O4ok8F8r0eDZiSt55NjUw8QCP4w6GObV1n/sbAlaA+R2
   Stkjo5pp/3enslAKXD7jEk/YeDZRw5/Uwi34L9h+GR0Vjb/dwAbRM+S9D
   a7/mT7oZaYZZ+uxwE8hhNv3VrvvFA2sIDCkn4ZaE5c9UF9yr6QghkV6NZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="16713819"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="16713819"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 22:09:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="822082100"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="822082100"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 22:09:10 -0800
Message-ID: <6220164a-aa1d-43d2-b918-6a6eaad769fb@linux.intel.com>
Date: Tue, 30 Jan 2024 14:09:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 048/121] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <0b308fb6dd52bafe7153086c7f54bfad03da74b1.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0b308fb6dd52bafe7153086c7f54bfad03da74b1.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX supports only write-back(WB) memory type for private memory
> architecturally so that (virtualized) memory type change doesn't make sense
> for private memory.  Also currently, page migration isn't supported for TDX
> yet. (TDX architecturally supports page migration. it's KVM and kernel
> implementation issue.)
>
> Regarding memory type change (mtrr virtualization and lapic page mapping
> change), pages are zapped by kvm_zap_gfn_range().  On the next KVM page
> fault, the SPTE entry with a new memory type for the page is populated.
> Regarding page migration, pages are zapped by the mmu notifier. On the next
> KVM page fault, the new migrated page is populated.  Don't zap private
> pages on unmapping for those two cases.
>
> When deleting/moving a KVM memory slot, zap private pages. Typically
> tearing down VM.  Don't invalidate private page tables. i.e. zap only leaf
> SPTEs for KVM mmu that has a shared bit mask. The existing
> kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-lock
> of mmu_lock so that other vcpu can operate on KVM mmu concurrently.  It
> marks the root page table invalid and zaps SPTEs of the root page
> tables. The TDX module doesn't allow to unlink a protected root page table
> from the hardware and then allocate a new one for it. i.e. replacing a
> protected root page table.  Instead, zap only leaf SPTEs for KVM mmu with a
> shared bit mask set.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 61 ++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++----
>   arch/x86/kvm/mmu/tdp_mmu.h |  5 ++--
>   3 files changed, 92 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 32c619125be4..f4fbf42e05fb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6267,7 +6267,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>   	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
>   	 */
>   	if (tdp_mmu_enabled)
> -		kvm_tdp_mmu_invalidate_all_roots(kvm);
> +		kvm_tdp_mmu_invalidate_all_roots(kvm, true);
>   
>   	/*
>   	 * Notify all vcpus to reload its shadow page table and flush TLB.
> @@ -6389,7 +6389,16 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
>   
>   	if (tdp_mmu_enabled)
> -		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
> +		/*
> +		 * zap_private = false. Zap only shared pages.
> +		 *
> +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
> +		 * type was changed.  Later on the next kvm page fault,
> +		 * populate it with updated spte entry.
> +		 * Because only WB is supported for private pages, don't
> +		 * care of private pages.
> +		 */
> +		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush, false);
>   
>   	if (flush)
>   		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
> @@ -6835,10 +6844,56 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   	kvm_mmu_zap_all(kvm);
>   }
>   
> +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	bool flush = false;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	/*
> +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> +	 * case scenario we'll have unused shadow pages lying around until they
> +	 * are recycled due to age or when the VM is destroyed.
> +	 */
> +	if (tdp_mmu_enabled) {
> +		struct kvm_gfn_range range = {
> +		      .slot = slot,
> +		      .start = slot->base_gfn,
> +		      .end = slot->base_gfn + slot->npages,
> +		      .may_block = true,
> +
> +		      /*
> +		       * This handles both private gfn and shared gfn.
> +		       * All private page should be zapped on memslot deletion.
> +		       */
> +		      .only_private = true,
> +		      .only_shared = true,
only_{private,shared} were added in Sean's gmem patch series, but removed
in v14.
https://lore.kernel.org/kvm/20231105163040.14904-1-pbonzini@redhat.com/
I didn't find the two members are added in this patch series, is there other
dependent patches?

Also, what does it mean by setting both only_private and only_shared as 
true?
Per your comment, it seems both shared & private should be handled.
Then, they both should be false?

It is a bit confusing, maybe you can consider to use enum mentioned in the
discussion below?
https://lore.kernel.org/kvm/ZUO1Giju0GkUdF0o@google.com/#t


> +		};
> +
> +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
> +	} else {
> +		/* TDX supports only TDP-MMU case. */
> +		WARN_ON_ONCE(1);
> +		flush = true;
> +	}
> +	if (flush)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot)
>   {
> -	kvm_mmu_zap_all_fast(kvm);
> +	if (kvm_gfn_shared_mask(kvm))
> +		/*
> +		 * Secure-EPT requires to release PTs from the leaf.  The
> +		 * optimization to zap root PT first with child PT doesn't
> +		 * work.
> +		 */
> +		kvm_mmu_zap_memslot(kvm, slot);
> +	else
> +		kvm_mmu_zap_all_fast(kvm);
>   }
>   
>   void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d47f0daf1b03..e7514a807134 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>   	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
>   	 * ultimately frees all roots.
>   	 */
> -	kvm_tdp_mmu_invalidate_all_roots(kvm);
> +	kvm_tdp_mmu_invalidate_all_roots(kvm, false);
>   	kvm_tdp_mmu_zap_invalidated_roots(kvm);
>   
>   	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
> @@ -771,7 +771,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>    * operation can cause a soft lockup.
>    */
>   static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> -			      gfn_t start, gfn_t end, bool can_yield, bool flush)
> +			      gfn_t start, gfn_t end, bool can_yield, bool flush,
> +			      bool zap_private)
>   {
>   	struct tdp_iter iter;
>   
> @@ -779,6 +780,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
> +	WARN_ON_ONCE(zap_private && !is_private_sp(root));
> +	if (!zap_private && is_private_sp(root))
> +		return false;
> +
>   	rcu_read_lock();
>   
>   	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> @@ -810,13 +815,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>    * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
>    * more SPTEs were zapped since the MMU lock was last acquired.
>    */
> -bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush,
> +			   bool zap_private)
>   {
>   	struct kvm_mmu_page *root;
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	for_each_tdp_mmu_root_yield_safe(kvm, root)
> -		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
> +		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush,
> +					  zap_private && is_private_sp(root));
>   
>   	return flush;
>   }
> @@ -891,7 +898,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>    * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
>    * See kvm_tdp_mmu_get_vcpu_root_hpa().
>    */
> -void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
>   {
>   	struct kvm_mmu_page *root;
>   
> @@ -916,6 +923,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>   	 * or get/put references to roots.
>   	 */
>   	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> +		/*
> +		 * Skip private root since private page table
> +		 * is only torn down when VM is destroyed.
> +		 */
> +		if (skip_private && is_private_sp(root))
> +			continue;
>   		/*
>   		 * Note, invalid roots can outlive a memslot update!  Invalid
>   		 * roots must be *zapped* before the memslot update completes,
> @@ -1104,14 +1117,26 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	return ret;
>   }
>   
> +/* Used by mmu notifier via kvm_unmap_gfn_range() */
>   bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>   				 bool flush)
>   {
>   	struct kvm_mmu_page *root;
> +	bool zap_private = false;
> +
> +	if (kvm_gfn_shared_mask(kvm)) {
> +		if (!range->only_private && !range->only_shared)
> +			/* attributes change */
> +			zap_private = !(range->arg.attributes &
> +					KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +		else
> +			zap_private = range->only_private;
> +	}
>   
>   	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>   		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
> -					  range->may_block, flush);
> +					  range->may_block, flush,
> +					  zap_private && is_private_sp(root));
>   
>   	return flush;
>   }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 20d97aa46c49..b3cf58a50357 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -19,10 +19,11 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>   
>   void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
>   
> -bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush,
> +			   bool zap_private);
>   bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>   void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> -void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> +void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private);
>   void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
>   
>   int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);


