Return-Path: <kvm+bounces-2251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECAF7F3ED5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E21FB21113
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 07:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F211F609;
	Wed, 22 Nov 2023 07:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5ME/6iR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C67A1;
	Tue, 21 Nov 2023 23:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700637880; x=1732173880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7iO42SkQCmhwo8NQfOnavlhegZ7a1op2/6QivppH0Qo=;
  b=G5ME/6iR4JRq0AQpDwvOAcEqj1eV0no9JIfxaDO9BDwM0H4gObScuMMd
   p+Jtme+iDH5IkkVx+NBzsekZzwLMARwuIgFOXXRC9pXptLQt5liYDBjmC
   osoNA2x2bcWvWeM0pwyryoVtWIGC7Kob4RfLlDIUXR9ATeGrG+h5a0yRn
   MEs64m35a0PdcJkBd5yjRtn6CVN/R3IdIlIZr5p4rqtb7wrlXs6LCy9FS
   IKGoEd6VzYyfVl0cEMUYZbTEWPDjn2lE50MY6A0AasMzwqYARQvvk+LJ9
   66NuGS3J5Ri/OkPYw7xKbjb5iSDyYZcBxjEPEpLAOYq9Fu9cY7o8Bgp1m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="391769228"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="391769228"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 23:24:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="716754374"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="716754374"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 23:24:35 -0800
Message-ID: <f6fd4e02-62f8-48b8-b6f3-74b856f8a72c@linux.intel.com>
Date: Wed, 22 Nov 2023 15:24:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/16] KVM: x86/tdp_mmu: Try to merge pages into a
 large page
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <fef62447723682de6ea30452b270ccf75891f6a0.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fef62447723682de6ea30452b270ccf75891f6a0.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> When a large page is passed to the KVM page fault handler and some of sub
> pages are already populated, try to merge sub pages into a large page.
> This situation can happen when the guest converts small pages into shared
> and convert it back into private.
>
> When a large page is passed to KVM mmu page fault handler and the spte
> corresponding to the page is non-leaf (one or more of sub pages are already
> populated at lower page level), the current kvm mmu zaps non-leaf spte at a
> large page level, and populate a leaf spte at that level.  Thus small pages
> are converted into a large page.  However, it doesn't work for TDX because
> zapping and re-populating results in zeroing page content.  Instead,
> populate all small pages and merge them into a large page.
>
> Merging pages into a large page can fail when some sub pages are accepted
> and some are not.  In such case, with the assumption that guest tries to
> accept at large page size for performance when possible, don't try to be
> smart to identify which page is still pending, map all pages at lower page
> level, and let vcpu re-execute.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   2 +
>   arch/x86/include/asm/kvm_host.h    |   4 +
>   arch/x86/kvm/mmu/tdp_iter.c        |  37 +++++--
>   arch/x86/kvm/mmu/tdp_iter.h        |   2 +
>   arch/x86/kvm/mmu/tdp_mmu.c         | 172 ++++++++++++++++++++++++++++-
>   5 files changed, 207 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 3deb6ab4f291..9a7d4db304c7 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -104,9 +104,11 @@ KVM_X86_OP(load_mmu_pgd)
>   KVM_X86_OP_OPTIONAL(link_private_spt)
>   KVM_X86_OP_OPTIONAL(free_private_spt)
>   KVM_X86_OP_OPTIONAL(split_private_spt)
> +KVM_X86_OP_OPTIONAL(merge_private_spt)
>   KVM_X86_OP_OPTIONAL(set_private_spte)
>   KVM_X86_OP_OPTIONAL(remove_private_spte)
>   KVM_X86_OP_OPTIONAL(zap_private_spte)
> +KVM_X86_OP_OPTIONAL(unzap_private_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e75a461bdea7..0254c382f4f0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -146,6 +146,7 @@
>   #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
>   #define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
>   #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
> +#define KVM_HPAGE_GFN_MASK(x)	(~((1UL << KVM_HPAGE_GFN_SHIFT(x)) - 1))
>   #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
>   #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
>   #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
> @@ -1755,11 +1756,14 @@ struct kvm_x86_ops {
>   				void *private_spt);
>   	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				  void *private_spt);
> +	int (*merge_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				 void *private_spt);
>   	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				 kvm_pfn_t pfn);
>   	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				    kvm_pfn_t pfn);
>   	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
> +	int (*unzap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
>   
>   	bool (*has_wbinvd_exit)(void);
>   
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index bd30ebfb2f2c..f33226fcd62a 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -71,6 +71,14 @@ tdp_ptep_t spte_to_child_pt(u64 spte, int level)
>   	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
>   }
>   
> +static void step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
> +{
> +	iter->level--;
> +	iter->pt_path[iter->level - 1] = child_pt;
> +	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
> +	tdp_iter_refresh_sptep(iter);
> +}
> +
>   /*
>    * Steps down one level in the paging structure towards the goal GFN. Returns
>    * true if the iterator was able to step down a level, false otherwise.
> @@ -92,14 +100,28 @@ static bool try_step_down(struct tdp_iter *iter)
>   	if (!child_pt)
>   		return false;
>   
> -	iter->level--;
> -	iter->pt_path[iter->level - 1] = child_pt;
> -	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
> -	tdp_iter_refresh_sptep(iter);
> -
> +	step_down(iter, child_pt);
>   	return true;
>   }
>   
> +/* Steps down for freezed spte.  Don't re-read sptep because it was freezed. */
> +void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
> +{
> +	WARN_ON_ONCE(!child_pt);
> +	WARN_ON_ONCE(iter->yielded);
> +	WARN_ON_ONCE(iter->level == iter->min_level);
> +
> +	step_down(iter, child_pt);
> +}
> +
> +void tdp_iter_step_side(struct tdp_iter *iter)
> +{
> +	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
> +	iter->next_last_level_gfn = iter->gfn;
> +	iter->sptep++;
> +	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
> +}
> +
>   /*
>    * Steps to the next entry in the current page table, at the current page table
>    * level. The next entry could point to a page backing guest memory or another
> @@ -117,10 +139,7 @@ static bool try_step_side(struct tdp_iter *iter)
>   	    (SPTE_ENT_PER_PAGE - 1))
>   		return false;
>   
> -	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
> -	iter->next_last_level_gfn = iter->gfn;
> -	iter->sptep++;
> -	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
> +	tdp_iter_step_side(iter);
>   
>   	return true;
>   }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index a9c9cd0db20a..ca00db799a50 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -134,6 +134,8 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>   		    int min_level, gfn_t next_last_level_gfn);
>   void tdp_iter_next(struct tdp_iter *iter);
>   void tdp_iter_restart(struct tdp_iter *iter);
> +void tdp_iter_step_side(struct tdp_iter *iter);
> +void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt);
>   
>   static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
>   {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 734ee822b43c..c8a4bd052c71 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1224,6 +1224,176 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
>   	}
>   }
>   
> +static int tdp_mmu_iter_step_side(int i, struct tdp_iter *iter)
> +{
> +	i++;
> +
> +	/*
> +	 * if i = SPTE_ENT_PER_PAGE, tdp_iter_step_side() results
> +	 * in reading the entry beyond the last entry.
> +	 */
> +	if (i < SPTE_ENT_PER_PAGE)
> +		tdp_iter_step_side(iter);
> +
> +	return i;
> +}
> +
> +static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
> +				     struct kvm_page_fault *fault,
> +				     struct tdp_iter *iter, u64 new_spte)
> +{
> +	u64 *sptep = rcu_dereference(iter->sptep);
> +	u64 old_spte = iter->old_spte;
> +	struct kvm_mmu_page *child_sp;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct tdp_iter child_iter;
> +	int level = iter->level;
> +	gfn_t gfn = iter->gfn;
> +	tdp_ptep_t child_pt;
> +	u64 child_spte;
> +	int ret = 0;
> +	int i;
> +
> +	/*
> +	 * TDX KVM supports only 2MB large page.  It's not supported to merge
> +	 * 2MB pages into 1GB page at the moment.
> +	 */
> +	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_2M);
> +	WARN_ON_ONCE(iter->level != PG_LEVEL_2M);
> +	WARN_ON_ONCE(!is_large_pte(new_spte));
> +
> +	/* Freeze the spte to prevent other threads from working spte. */
> +	if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
> +		return -EBUSY;
> +
> +	/*
> +	 * Step down to the child spte.  Because tdp_iter_next() assumes the
> +	 * parent spte isn't freezed, do it manually.
s/freezed/frozen

> +	 */
> +	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
> +	child_sp = sptep_to_sp(child_pt);
> +	WARN_ON_ONCE(child_sp->role.level != PG_LEVEL_4K);
> +	WARN_ON_ONCE(!kvm_mmu_page_role_is_private(child_sp->role));
> +
> +	/* Don't modify iter as the caller will use iter after this function. */
> +	child_iter = *iter;
> +	/* Adjust the target gfn to the head gfn of the large page. */
> +	child_iter.next_last_level_gfn &= -KVM_PAGES_PER_HPAGE(level);
> +	tdp_iter_step_down(&child_iter, child_pt);
> +
> +	/*
> +	 * All child pages are required to be populated for merging them into a
> +	 * large page.  Populate all child spte.
> +	 */
> +	for (i = 0; i < SPTE_ENT_PER_PAGE; i = tdp_mmu_iter_step_side(i, &child_iter)) {
> +		int tmp;
> +
> +		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
> +
> +		if (is_shadow_present_pte(child_iter.old_spte)) {
> +			/* TODO: relocate page for huge page. */
> +			if (WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) !=
> +					 spte_to_pfn(new_spte) + i)) {
> +				if (!ret)
> +					ret = -EAGAIN;
> +				continue;
> +			}
> +			/*
> +			 * When SEPT_VE_DISABLE=true and the page state is
> +			 * pending, this case can happen.  Just resume the vcpu
> +			 * again with the expectation for other vcpu to accept
> +			 * this page.
> +			 */
> +			if (child_iter.gfn == fault->gfn) {
> +				if (!ret)
> +					ret = -EAGAIN;
> +			}
> +			continue;
> +		}
> +
> +		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
> +		/*
> +		 * Because other thread may have started to operate on this spte
> +		 * before freezing the parent spte,  Use atomic version to
> +		 * prevent race.
> +		 */
> +		tmp = tdp_mmu_set_spte_atomic(vcpu->kvm, &child_iter, child_spte);
> +		if (tmp == -EBUSY || tmp == -EAGAIN) {
> +			/*
> +			 * There was a race condition.  Populate remaining 4K
> +			 * spte to resolve fault->gfn to guarantee the forward
> +			 * progress.
> +			 */
> +			if (!ret)
> +				ret = tmp;
> +		} else if (tmp) {
> +			ret = tmp;
> +			goto out;
> +		}
> +	}
> +	if (ret)
> +		goto out;
> +
> +	/* Prevent the Secure-EPT entry from being used. */
> +	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> +	if (ret)
> +		goto out;
> +	kvm_flush_remote_tlbs_range(kvm, gfn & KVM_HPAGE_GFN_MASK(level),
> +				    KVM_PAGES_PER_HPAGE(level));
> +
> +	/* Merge pages into a large page. */
> +	ret = static_call(kvm_x86_merge_private_spt)(kvm, gfn, level,
> +						     kvm_mmu_private_spt(child_sp));
> +	/*
> +	 * Failed to merge pages because some pages are accepted and some are
> +	 * pending.  Since the child page was mapped above, let vcpu run.
> +	 */
> +	if (ret) {
> +		if (static_call(kvm_x86_unzap_private_spte)(kvm, gfn, level))
> +			old_spte = SHADOW_NONPRESENT_VALUE |
> +				(spte_to_pfn(old_spte) << PAGE_SHIFT) |
> +				PT_PAGE_SIZE_MASK;
> +		goto out;
> +	}
> +
> +	/* Unfreeze spte. */
> +	iter->old_spte = new_spte;
> +	__kvm_tdp_mmu_write_spte(sptep, new_spte);
> +
> +	/*
> +	 * Free unused child sp.  Secure-EPT page was already freed at TDX level
> +	 * by kvm_x86_merge_private_spt().
> +	 */
> +	tdp_unaccount_mmu_page(kvm, child_sp);
> +	tdp_mmu_free_sp(child_sp);
> +	return -EAGAIN;
It successfully promoted the page, why still return -EAGAIN?

> +
> +out:
> +	iter->old_spte = old_spte;
> +	__kvm_tdp_mmu_write_spte(sptep, old_spte);
> +	return ret;
> +}
> +
> +static int __tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> +					     struct kvm_page_fault *fault,
> +					     struct tdp_iter *iter, u64 new_spte)
> +{
> +	/*
> +	 * The private page has smaller-size pages.  For example, the child
> +	 * pages was converted from shared to page, and now it can be mapped as
> +	 * a large page.  Try to merge small pages into a large page.
> +	 */
> +	if (fault->slot &&
> +	    kvm_gfn_shared_mask(vcpu->kvm) &&
> +	    iter->level > PG_LEVEL_4K &&
> +	    kvm_is_private_gpa(vcpu->kvm, fault->addr) &&
> +	    is_shadow_present_pte(iter->old_spte) &&
> +	    !is_large_pte(iter->old_spte))
> +		return tdp_mmu_merge_private_spt(vcpu, fault, iter, new_spte);
> +
> +	return tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte);
> +}
> +
>   /*
>    * Installs a last-level SPTE to handle a TDP page fault.
>    * (NPT/EPT violation/misconfiguration)
> @@ -1265,7 +1435,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   
>   	if (new_spte == iter->old_spte)
>   		ret = RET_PF_SPURIOUS;
> -	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> +	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
>   		return RET_PF_RETRY;
>   	else if (is_shadow_present_pte(iter->old_spte) &&
>   		 !is_last_spte(iter->old_spte, iter->level))


