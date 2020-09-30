Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E67227EF5B
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbgI3Qhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 12:37:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:7978 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 12:37:44 -0400
IronPort-SDR: UsWXlNVRBeOGHBgs894UqGO3Qm+Su98FtXqHFgqPd6AnPy1gD1lfuBFO7VYU2JChqgKB3s2JU8
 XanX7R2Is2hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="162543989"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="162543989"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:37:43 -0700
IronPort-SDR: wzBLzfRqPD09jxiARGiDQH9pVSv14S8oWOwVe4szLXCUo70svQtGDU3EV4CVsQMBCqhbjNjbKT
 II8PO3+2hZfQ==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457717435"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:37:43 -0700
Date:   Wed, 30 Sep 2020 09:37:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 10/22] kvm: mmu: Add TDP MMU PF handler
Message-ID: <20200930163740.GD32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-11-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:50PM -0700, Ben Gardon wrote:
> @@ -4113,8 +4088,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	if (page_fault_handle_page_track(vcpu, error_code, gfn))
>  		return RET_PF_EMULATE;
>  
> -	if (fast_page_fault(vcpu, gpa, error_code))
> -		return RET_PF_RETRY;
> +	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +		if (fast_page_fault(vcpu, gpa, error_code))
> +			return RET_PF_RETRY;

It'll probably be easier to handle is_tdp_mmu() in fast_page_fault().

>  
>  	r = mmu_topup_memory_caches(vcpu, false);
>  	if (r)
> @@ -4139,8 +4115,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
>  		goto out_unlock;
> -	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> -			 prefault, is_tdp && lpage_disallowed);
> +
> +	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +		r = kvm_tdp_mmu_page_fault(vcpu, write, map_writable, max_level,
> +					   gpa, pfn, prefault,
> +					   is_tdp && lpage_disallowed);
> +	else
> +		r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> +				 prefault, is_tdp && lpage_disallowed);
>  
>  out_unlock:
>  	spin_unlock(&vcpu->kvm->mmu_lock);

...

> +/*
> + * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> + * page tables and SPTEs to translate the faulting guest physical address.
> + */
> +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> +			   int max_level, gpa_t gpa, kvm_pfn_t pfn,
> +			   bool prefault, bool account_disallowed_nx_lpage)
> +{
> +	struct tdp_iter iter;
> +	struct kvm_mmu_memory_cache *pf_pt_cache =
> +			&vcpu->arch.mmu_shadow_page_cache;
> +	u64 *child_pt;
> +	u64 new_spte;
> +	int ret;
> +	int as_id = kvm_arch_vcpu_memslots_id(vcpu);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	int level;
> +
> +	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> +		return RET_PF_RETRY;

I feel like we should kill off these silly WARNs in the existing code instead
of adding more.  If they actually fired, I'm pretty sure that they would
continue firing and spamming the kernel log until the VM is killed as I don't
see how restarting the guest will magically fix anything.

> +
> +	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
> +		return RET_PF_RETRY;

This seems especially gratuitous, this has exactly one caller that explicitly
checks is_tdp_mmu_root().  Again, if this fires it will spam the kernel log
into submission.

> +
> +	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn);
> +
> +	for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
> +		disallowed_hugepage_adjust(iter.old_spte, gfn, iter.level,
> +					   &pfn, &level);
> +
> +		if (iter.level == level)
> +			break;
> +
> +		/*
> +		 * If there is an SPTE mapping a large page at a higher level
> +		 * than the target, that SPTE must be cleared and replaced
> +		 * with a non-leaf SPTE.
> +		 */
> +		if (is_shadow_present_pte(iter.old_spte) &&
> +		    is_large_pte(iter.old_spte)) {
> +			*iter.sptep = 0;
> +			handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
> +					    iter.old_spte, 0, iter.level);
> +			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
> +					KVM_PAGES_PER_HPAGE(iter.level));
> +
> +			/*
> +			 * The iter must explicitly re-read the spte here
> +			 * because the new is needed before the next iteration
> +			 * of the loop.
> +			 */

I think it'd be better to explicitly, and simply, call out that iter.old_spte
is consumed below.  It's subtle enough to warrant a comment, but the comment
didn't actually help me.  Maybe something like:

			/*
			 * Refresh iter.old_spte, it will trigger the !present
			 * path below.
			 */

> +			iter.old_spte = READ_ONCE(*iter.sptep);
> +		}
> +
> +		if (!is_shadow_present_pte(iter.old_spte)) {
> +			child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
> +			clear_page(child_pt);
> +			new_spte = make_nonleaf_spte(child_pt,
> +						     !shadow_accessed_mask);
> +
> +			*iter.sptep = new_spte;
> +			handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
> +					    iter.old_spte, new_spte,
> +					    iter.level);
> +		}
> +	}
> +
> +	if (WARN_ON(iter.level != level))
> +		return RET_PF_RETRY;

This also seems unnecessary.  Or maybe these are all good candiates for
KVM_BUG_ON...

> +
> +	ret = page_fault_handle_target_level(vcpu, write, map_writable,
> +					     as_id, &iter, pfn, prefault);
> +
> +	/* If emulating, flush this vcpu's TLB. */

Why?  It's obvious _what_ the code is doing, the comment should explain _why_.

> +	if (ret == RET_PF_EMULATE)
> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +
> +	return ret;
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index cb86f9fe69017..abf23dc0ab7ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -14,4 +14,8 @@ void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
>  
>  bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> +
> +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> +			   int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
> +			   bool lpage_disallowed);
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
