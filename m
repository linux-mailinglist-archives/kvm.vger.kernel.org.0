Return-Path: <kvm+bounces-23191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA08947675
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB54281938
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 07:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE3114B064;
	Mon,  5 Aug 2024 07:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcZyq9Zt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34449149C68;
	Mon,  5 Aug 2024 07:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722844759; cv=none; b=jTngZob/bDdsP28icbahkb6s8UlPL/gjBSG/ljZbHvojpEQrsl32lhBkKQIN8H0F23L3yeOB8FqOROGWlZ62jzSS+XTBy3hcbXxR/s+3hyXwmLvhAZ0ZGuae+X9myziNMBTdbBxR2wXf/Dt3W1WervN1MaHkIslY8GnjmYp+5/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722844759; c=relaxed/simple;
	bh=NKf63D9jiD2a9CqpHJMdfC3i7PiyG9ITClmyQ+0bY9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNCsCwpzisfMil03olpMhG1moPCxh83RoOlhHWItOhhBRo9xxAR84Hy6hOy+Xk9ilYx7fUixUx1IOvbJCoMXQ/NMUVnGLux2rKjwf+WGpEysmlLtAtjB/1v1+pK7F+UcbS+t7vmRgQzvSJBJRgRcfOzv8Mx3g3x+Kl6dEJCsdCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcZyq9Zt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722844757; x=1754380757;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NKf63D9jiD2a9CqpHJMdfC3i7PiyG9ITClmyQ+0bY9c=;
  b=KcZyq9Zt4rcUTZu0DRTbsXLL96Lac6PNT0kG03pQ4baZgJe4qpOgIzWZ
   TyKiRLO0T9jt4cnIlKkzTYAVrHpvQ8ZRwJx0PmzBG6hXbuLxTC29Yx6ej
   5aY87I1MyAxq/hmkQhbrDJR3Tk/2wIL06omOTQLaf8BEjdDfkTYhL55Id
   mPs8qOHoBSS5MGb1dJqa31BtSrXx3gYB2U8TaNmSwZWoJnLX9U23fy+12
   2hUkFPb1ZCdSZXem+n7lS5zWrw6mCvLQUJdEwThIfRNMSBTHKq7axWizJ
   9QxVDBkldaTZwsSKnYWw8+dfVqAeVYRUeWUSMakMGGWiap/jrNkpzYyqC
   A==;
X-CSE-ConnectionGUID: e6xdijh+T9qsw7fVkTzfeg==
X-CSE-MsgGUID: MedZytc9T7+MzQiS9ctvnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="38251012"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="38251012"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 00:59:17 -0700
X-CSE-ConnectionGUID: +18DwL1fT9aR++Xt8KkH2g==
X-CSE-MsgGUID: iF66DRgnR2CYlfZTc85cew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="56000060"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa009.jf.intel.com with ESMTP; 05 Aug 2024 00:59:14 -0700
Date: Mon, 5 Aug 2024 15:59:11 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 9/9] KVM: x86/mmu: Track SPTE accessed info across
 mmu_notifier PROT changes
Message-ID: <20240805075911.3cxfzewmqlkmvgfw@yy-desk-7060>
References: <20240801183453.57199-1-seanjc@google.com>
 <20240801183453.57199-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801183453.57199-10-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Thu, Aug 01, 2024 at 11:34:53AM -0700, Sean Christopherson wrote:
> Preserve Accessed information when zapping SPTEs in response to an
> mmu_notifier protection change, e.g. if KVM is zapping SPTEs because
> NUMA balancing kicked in.  KVM is not required to fully unmap the SPTE,
> and the core VMA information isn't changing, i.e. the information is
> still fresh and useful.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ac3200ce00f9..780f35a22c05 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -838,7 +838,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * operation can cause a soft lockup.
>   */
>  static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> -			      gfn_t start, gfn_t end, bool can_yield, bool flush)
> +			      gfn_t start, gfn_t end, bool can_yield,
> +			      bool keep_accessed_bit, bool flush)
>  {
>  	struct tdp_iter iter;
>
> @@ -849,17 +850,29 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  	rcu_read_lock();
>
>  	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> +		u64 new_spte = SHADOW_NONPRESENT_VALUE;
> +
>  		if (can_yield &&
>  		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
>  			flush = false;
>  			continue;
>  		}
>
> +		/*
> +		 * Note, this will fail to clear non-present, accessed SPTEs,
> +		 * but that isn't a functional problem, it can only result in
> +		 * a _potential_ false positive  in the unlikely scenario that
> +		 * the primary MMU zaps an hva, reinstalls a new hva, and ages
> +		 * the new hva, all before KVM accesses the hva.
> +		 */
>  		if (!is_shadow_present_pte(iter.old_spte) ||
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>
> -		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		if (keep_accessed_bit)
> +			new_spte |= iter.old_spte & shadow_accessed_mask;
> +
> +		tdp_mmu_iter_set_spte(kvm, &iter, new_spte);
>
>  		/*
>  		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
> @@ -889,7 +902,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
>
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, -1)
> -		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
> +		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, false, flush);
>
>  	return flush;
>  }
> @@ -1180,11 +1193,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  				 bool flush)
>  {
> +	bool keep_a_bit = range->arg.event == MMU_NOTIFY_PROTECTION_VMA ||
> +			  range->arg.event == MMU_NOTIFY_PROTECTION_PAGE;
>  	struct kvm_mmu_page *root;
>
>  	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>  		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
> -					  range->may_block, flush);
> +					  range->may_block, keep_a_bit, flush);
>
>  	return flush;
>  }
> @@ -1201,7 +1216,11 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
>  {
>  	u64 new_spte;
>
> -	if (spte_ad_enabled(iter->old_spte)) {
> +	if (spte_ad_enabled(iter->old_spte) ||
> +	    !is_shadow_present_pte(iter->old_spte)) {
> +		KVM_MMU_WARN_ON(!is_shadow_present_pte(iter->old_spte) &&
> +				iter->old_spte != (SHADOW_NONPRESENT_VALUE | shadow_accessed_mask));

Is that possible some sptes are zapped by
kvm_tdp_mmu_zap_leafs(keep_accessed_bit = false) i.e. from kvm_post_set_cr0(),
then handled by __kvm_tdp_mmu_age_gfn_range() for aging before
accessed by guest again ?
In this scenario the spte is non-present w/o A bit set.

> +
>  		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
>  							 iter->old_spte,
>  							 shadow_accessed_mask,
> @@ -1235,7 +1254,7 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
>  	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
>  		rcu_read_lock();
>
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> +		tdp_root_for_each_pte(iter, root, range->start, range->end) {

This also clears the A bit of non-leaf entries for aging, I remember
KVM doesn't care them before, could you please explain the reason of
this ?

>  			if (!is_accessed_spte(iter.old_spte))
>  				continue;
>
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>
>

