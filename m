Return-Path: <kvm+bounces-23479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 042B5949FF1
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 08:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE727286980
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 06:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9301B8E84;
	Wed,  7 Aug 2024 06:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RePvCfW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0398D1B86E4;
	Wed,  7 Aug 2024 06:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723012896; cv=none; b=YWTii8ElQNJvFtOqp01RUxkg+3BaOKnj2YqV08gL/BXk7t1pnXOk/QNuLckg7CP4AIIlSNkShxDOLwiZqJlzQHiiK+ndtuYRG8uEQFLsbeeb5C0vsMZqZF4v2zIgCKg7nodtdkdGVTpS81+VUGPJAHM/tzvblBHhw3vr/nqY59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723012896; c=relaxed/simple;
	bh=mVSYfEzE6S6t0EX9rKYwRYhqaJXEwOw90Fc2bN022OQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGhd6eCjCrEWR3mSJiKS/9ssQr2BFu4eiZXhlsoUx9iEtkKg0mlklIBJhkX7olcxekcodShz3frdE7epOwoKWv33kOfTNZxeXLDl6JGicKGKTT+ylw0uhRw27D3gM2aaVwBTZJgguDxS/eDvM3fuIAGzh3Y79EdeTzjDkXVPF2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RePvCfW4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723012895; x=1754548895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mVSYfEzE6S6t0EX9rKYwRYhqaJXEwOw90Fc2bN022OQ=;
  b=RePvCfW4lKjRZYpogpznuNSWXejSxMCG0nWLTSQkAge+aaCN9v0cV7dr
   66/U6HyTu3SEXEPhcOg0sZhOwigMuj21ZqOvwmSWIZzmhW2K1YG5NmM8F
   LPVvh8jaS9zTpx38yFLm81NXEdYTAFyounOsck8jaKuctg9uF0wAwgceA
   bJRtyMMtJNZyyrqtlUI0QniMXCBQz3Zp/gN6NRTC4oCM1Bi6SiptTgdSb
   iQpiZQUGFPghl06eGir4oBsOjY8h+dAO9ksjzDYty+5rVN9wB2YzDBeOa
   zlPiCUcs7WMr3hM5MyyU88x3JZFO1pDivZXDuvJeSMI5uJo2nQ1MgoLwK
   g==;
X-CSE-ConnectionGUID: T4Ac1EAfT++8b6h7zfdnvQ==
X-CSE-MsgGUID: ouSjJm4zTla5gTfhs/Nj0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="20637463"
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="20637463"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 23:41:34 -0700
X-CSE-ConnectionGUID: IG6P46pdTSmpAbQT58FMcQ==
X-CSE-MsgGUID: GqOWA+N4TCOwt5sScmQG1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="56618308"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa010.jf.intel.com with ESMTP; 06 Aug 2024 23:41:33 -0700
Date: Wed, 7 Aug 2024 14:41:31 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 9/9] KVM: x86/mmu: Track SPTE accessed info across
 mmu_notifier PROT changes
Message-ID: <20240807064131.rf7f2ve324hg434r@yy-desk-7060>
References: <20240801183453.57199-1-seanjc@google.com>
 <20240801183453.57199-10-seanjc@google.com>
 <20240805075911.3cxfzewmqlkmvgfw@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805075911.3cxfzewmqlkmvgfw@yy-desk-7060>
User-Agent: NeoMutt/20171215

On Mon, Aug 05, 2024 at 03:59:11PM +0800, Yuan Yao wrote:
> On Thu, Aug 01, 2024 at 11:34:53AM -0700, Sean Christopherson wrote:
> > Preserve Accessed information when zapping SPTEs in response to an
> > mmu_notifier protection change, e.g. if KVM is zapping SPTEs because
> > NUMA balancing kicked in.  KVM is not required to fully unmap the SPTE,
> > and the core VMA information isn't changing, i.e. the information is
> > still fresh and useful.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index ac3200ce00f9..780f35a22c05 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -838,7 +838,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >   * operation can cause a soft lockup.
> >   */
> >  static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > -			      gfn_t start, gfn_t end, bool can_yield, bool flush)
> > +			      gfn_t start, gfn_t end, bool can_yield,
> > +			      bool keep_accessed_bit, bool flush)
> >  {
> >  	struct tdp_iter iter;
> >
> > @@ -849,17 +850,29 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> >  	rcu_read_lock();
> >
> >  	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> > +		u64 new_spte = SHADOW_NONPRESENT_VALUE;
> > +
> >  		if (can_yield &&
> >  		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
> >  			flush = false;
> >  			continue;
> >  		}
> >
> > +		/*
> > +		 * Note, this will fail to clear non-present, accessed SPTEs,
> > +		 * but that isn't a functional problem, it can only result in
> > +		 * a _potential_ false positive  in the unlikely scenario that
> > +		 * the primary MMU zaps an hva, reinstalls a new hva, and ages
> > +		 * the new hva, all before KVM accesses the hva.
> > +		 */
> >  		if (!is_shadow_present_pte(iter.old_spte) ||
> >  		    !is_last_spte(iter.old_spte, iter.level))
> >  			continue;
> >
> > -		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> > +		if (keep_accessed_bit)
> > +			new_spte |= iter.old_spte & shadow_accessed_mask;
> > +
> > +		tdp_mmu_iter_set_spte(kvm, &iter, new_spte);
> >
> >  		/*
> >  		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
> > @@ -889,7 +902,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
> >
> >  	lockdep_assert_held_write(&kvm->mmu_lock);
> >  	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, -1)
> > -		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
> > +		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, false, flush);
> >
> >  	return flush;
> >  }
> > @@ -1180,11 +1193,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> >  				 bool flush)
> >  {
> > +	bool keep_a_bit = range->arg.event == MMU_NOTIFY_PROTECTION_VMA ||
> > +			  range->arg.event == MMU_NOTIFY_PROTECTION_PAGE;
> >  	struct kvm_mmu_page *root;
> >
> >  	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
> >  		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
> > -					  range->may_block, flush);
> > +					  range->may_block, keep_a_bit, flush);
> >
> >  	return flush;
> >  }
> > @@ -1201,7 +1216,11 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
> >  {
> >  	u64 new_spte;
> >
> > -	if (spte_ad_enabled(iter->old_spte)) {
> > +	if (spte_ad_enabled(iter->old_spte) ||
> > +	    !is_shadow_present_pte(iter->old_spte)) {
> > +		KVM_MMU_WARN_ON(!is_shadow_present_pte(iter->old_spte) &&
> > +				iter->old_spte != (SHADOW_NONPRESENT_VALUE | shadow_accessed_mask));
>
> Is that possible some sptes are zapped by
> kvm_tdp_mmu_zap_leafs(keep_accessed_bit = false) i.e. from kvm_post_set_cr0(),
> then handled by __kvm_tdp_mmu_age_gfn_range() for aging before
> accessed by guest again ?
> In this scenario the spte is non-present w/o A bit set.
>
> > +
> >  		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
> >  							 iter->old_spte,
> >  							 shadow_accessed_mask,
> > @@ -1235,7 +1254,7 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
> >  	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
> >  		rcu_read_lock();
> >
> > -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> > +		tdp_root_for_each_pte(iter, root, range->start, range->end) {
>
> This also clears the A bit of non-leaf entries for aging, I remember
> KVM doesn't care them before, could you please explain the reason of
> this ?

The new __kvm_tdp_mmu_age_gfn_range() covers aging and testing, so here
it allows testing on non-present sptes, becasue A bit is preserved there.

I worried before that the access state is updated by
handle_changed_spte() in case of zapping, preserve A bit
gives the inaccurate access state to in future .test_young()
if no one access the zapped guest again. But this should be
addressed by patch 8 and 81 in the 'massive "follow pfn"
rework' patch set mentioned in the cover letter.

>
> >  			if (!is_accessed_spte(iter.old_spte))
> >  				continue;
> >
> > --
> > 2.46.0.rc1.232.g9752f9e123-goog
> >
> >
>

