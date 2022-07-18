Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290C5577D9F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 10:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiGRIhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 04:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiGRIhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 04:37:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C184E01C;
        Mon, 18 Jul 2022 01:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658133466; x=1689669466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NcNFG8qw/hYkIbRGo28LEd3K60uudyThwy4dOWj6rYQ=;
  b=Cpb4TNTNlEfD7iefprh35SPSDgZZ04JB0caSAue91NdvUuTkZJszw2Hc
   qLDZ5SSZI2WAbgtexcKqzc0z79JozJ6pG/FjLJKbuGn18lGDN1PCoj6/9
   Y7+wd4aAKvjpuKQtNaCsrea21f+wijHBhJEgIRGedc6rq8fQUKkXRagoC
   iX9tTMZoybDPAJ8loKLhctb0MqEO481Bm1Y14t2aeYM0jKEkZEPC5gMp/
   T9r2BGnKyfHiyqf8M+oaAbpTtsnaFNh9qAObUDTzbMirWdgu8/UFN6lsy
   tuLWBOaas42mS/ap4MOLnd+EZqGbdxmRvLIc28nEg5XxcNeZM89Qj/Djd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="311848110"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="311848110"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 01:37:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="655181565"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 01:37:44 -0700
Date:   Mon, 18 Jul 2022 16:37:43 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 056/102] KVM: x86/mmu: steal software usable git to
 record if GFN is for shared or not
Message-ID: <20220718083743.dmgc4zsxag42o6vw@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <5ebf360e196b3f52eb42efaa8eeba587fab5897a.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ebf360e196b3f52eb42efaa8eeba587fab5897a.1656366338.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:48PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>

Subject: s/git/bit

>
> With TDX, all GFNs are private at guest boot time.  At run time guest TD
> can explicitly change it to shared from private or vice-versa by MapGPA
> hypercall.  If it's specified, the given GFN can't be used as otherwise.
> That's is, if a guest tells KVM that the GFN is shared, it can't be used
> as private.  or vice-versa.
>
> Steal software usable bit, SPTE_SHARED_MASK, for it from MMIO counter to
> record it.  Use the bit SPTE_SHARED_MASK in shared or private EPT to
> determine which mapping, shared or private, is allowed.  If requested
> mapping isn't allowed, return RET_PF_RETRY to wait for other vcpu to change
> it.  The bit is recorded in both shared and private shadow page to avoid
> traverse one more shadow page when resolving KVM page fault.
>
> The bit needs to be kept over zapping the EPT entry.  Currently the EPT
> entry is initialized SHADOW_NONPRESENT_VALUE unconditionally to clear
> SPTE_SHARED_MASK bit.  To carry SPTE_SHARED_MASK bit, introduce a helper
> function to get initial value for zapped entry with SPTE_SHARED_MASK bit.
> Replace SHADOW_NONPRESENT_VALUE with it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/spte.h    | 17 +++++++---
>  arch/x86/kvm/mmu/tdp_mmu.c | 65 ++++++++++++++++++++++++++++++++------
>  2 files changed, 68 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 96312ab4fffb..7c1aaf0e963e 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -14,6 +14,9 @@
>   */
>  #define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
>
> +/* Masks that used to track for shared GPA **/
> +#define SPTE_SHARED_MASK		BIT_ULL(62)
> +
>  /*
>   * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
>   * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
> @@ -104,7 +107,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>   * the memslots generation and is derived as follows:
>   *
>   * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
> - * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
> + * Bits 8-18 of the MMIO generation are propagated to spte bits 52-61

Should be 8-17.

>   *
>   * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
>   * the MMIO generation number, as doing so would require stealing a bit from
> @@ -118,7 +121,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  #define MMIO_SPTE_GEN_LOW_END		10
>
>  #define MMIO_SPTE_GEN_HIGH_START	52
> -#define MMIO_SPTE_GEN_HIGH_END		62
> +#define MMIO_SPTE_GEN_HIGH_END		61
>
>  #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
>  						    MMIO_SPTE_GEN_LOW_START)
> @@ -131,7 +134,7 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
>  #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
>
>  /* remember to adjust the comment above as well if you change these */
> -static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
> +static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 10);
>
>  #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
>  #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
> @@ -208,6 +211,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
>  static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
>  static_assert(!(__REMOVED_SPTE & SHADOW_NONPRESENT_VALUE));
> +static_assert(!(__REMOVED_SPTE & SPTE_SHARED_MASK));
>
>  /*
>   * See above comment around __REMOVED_SPTE.  REMOVED_SPTE is the actual
> @@ -217,7 +221,12 @@ static_assert(!(__REMOVED_SPTE & SHADOW_NONPRESENT_VALUE));
>
>  static inline bool is_removed_spte(u64 spte)
>  {
> -	return spte == REMOVED_SPTE;
> +	return (spte & ~SPTE_SHARED_MASK) == REMOVED_SPTE;
> +}
> +
> +static inline u64 spte_shared_mask(u64 spte)
> +{
> +	return spte & SPTE_SHARED_MASK;
>  }
>
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index fef6246086a8..4f279700b3cc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -758,6 +758,11 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	return 0;
>  }
>
> +static u64 shadow_nonpresent_spte(u64 old_spte)
> +{
> +	return SHADOW_NONPRESENT_VALUE | spte_shared_mask(old_spte);
> +}
> +
>  static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  					  struct tdp_iter *iter)
>  {
> @@ -791,7 +796,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
>  	 * can be set when EPT table entries are zapped.
>  	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
> +	__kvm_tdp_mmu_write_spte(iter->sptep,
> +			       shadow_nonpresent_spte(iter->old_spte));
>
>  	return 0;
>  }
> @@ -975,8 +981,11 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>
>  		if (!shared)
> -			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
> +			tdp_mmu_set_spte(kvm, &iter,
> +					 shadow_nonpresent_spte(iter.old_spte));
> +		else if (tdp_mmu_set_spte_atomic(
> +				 kvm, &iter,
> +				 shadow_nonpresent_spte(iter.old_spte)))
>  			goto retry;
>  	}
>  }
> @@ -1033,7 +1042,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		return false;
>
>  	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> -			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> +			   shadow_nonpresent_spte(old_spte),
> +			   sp->gfn, sp->role.level + 1,
>  			   true, true, is_private_sp(sp));
>
>  	return true;
> @@ -1075,11 +1085,20 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>  		}
>
> +		/*
> +		 * SPTE_SHARED_MASK is stored as 4K granularity.  The
> +		 * information is lost if we delete upper level SPTE page.
> +		 * TODO: support large page.
> +		 */
> +		if (kvm_gfn_shared_mask(kvm) && iter.level > PG_LEVEL_4K)
> +			continue;
> +
>  		if (!is_shadow_present_pte(iter.old_spte) ||
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>
> -		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		tdp_mmu_set_spte(kvm, &iter,
> +				 shadow_nonpresent_spte(iter.old_spte));
>  		flush = true;
>  	}
>
> @@ -1195,18 +1214,44 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	gfn_t gfn_unalias = iter->gfn & ~kvm_gfn_shared_mask(vcpu->kvm);
>
>  	WARN_ON(sp->role.level != fault->goal_level);
> +	WARN_ON(is_private_sptep(iter->sptep) != fault->is_private);
>
> -	/* TDX shared GPAs are no executable, enforce this for the SDV. */
> -	if (kvm_gfn_shared_mask(vcpu->kvm) && !fault->is_private)
> -		pte_access &= ~ACC_EXEC_MASK;
> +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> +		if (fault->is_private) {
> +			/*
> +			 * SPTE allows only RWX mapping. PFN can't be mapped it
> +			 * as READONLY in GPA.
> +			 */
> +			if (fault->slot && !fault->map_writable)
> +				return RET_PF_RETRY;
> +			/*
> +			 * This GPA is not allowed to map as private.  Let
> +			 * vcpu loop in page fault until other vcpu change it
> +			 * by MapGPA hypercall.
> +			 */
> +			if (fault->slot &&

Please consider to merge this if into above "if (fault->slot) {}"

> +				spte_shared_mask(iter->old_spte))
> +				return RET_PF_RETRY;
> +		} else {
> +			/* This GPA is not allowed to map as shared. */
> +			if (fault->slot &&
> +				!spte_shared_mask(iter->old_spte))
> +				return RET_PF_RETRY;
> +			/* TDX shared GPAs are no executable, enforce this. */
> +			pte_access &= ~ACC_EXEC_MASK;
> +		}
> +	}
>
>  	if (unlikely(!fault->slot))
>  		new_spte = make_mmio_spte(vcpu, gfn_unalias, pte_access);
> -	else
> +	else {
>  		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
>  				   gfn_unalias, fault->pfn, iter->old_spte,
>  				   fault->prefetch, true, fault->map_writable,
>  				   &new_spte);
> +		if (spte_shared_mask(iter->old_spte))
> +			new_spte |= SPTE_SHARED_MASK;
> +	}

The if can be eliminated:
new_spte |= spte_shared_mask(iter->old_spte);

>
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
> @@ -1509,7 +1554,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
>  	 * See __handle_changed_spte().
>  	 */
> -	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
> +	tdp_mmu_set_spte(kvm, iter, shadow_nonpresent_spte(iter->old_spte));
>
>  	if (!pte_write(range->pte)) {
>  		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
> --
> 2.25.1
>
