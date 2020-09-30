Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91127E0E8
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgI3GPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:15:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:15587 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3GPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 02:15:36 -0400
IronPort-SDR: AdMQP1z8BV3i+Z7Ss3pQbqzwZ1pP0Q+Cyp9rS2rkFyx885sKaqmngGQIKWs9cTyrytR+6XcwDv
 oyJi2LMy8GYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="162434207"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="162434207"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:15:35 -0700
IronPort-SDR: sBn7bCvEv6gW72S7mx/s5Qekpo+g8ugzx7CJOh103DwTiEOj6dwlVt8yqs2U7QaM+20wKNHrmM
 mrCmMq1pvxJA==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="308046642"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:15:34 -0700
Date:   Tue, 29 Sep 2020 23:15:33 -0700
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
Subject: Re: [PATCH 07/22] kvm: mmu: Support zapping SPTEs in the TDP MMU
Message-ID: <20200930061533.GC29659@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-8-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:47PM -0700, Ben Gardon wrote:
> Add functions to zap SPTEs to the TDP MMU. These are needed to tear down
> TDP MMU roots properly and implement other MMU functions which require
> tearing down mappings. Future patches will add functions to populate the
> page tables, but as for this patch there will not be any work for these
> functions to do.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c      |  15 +++++
>  arch/x86/kvm/mmu/tdp_iter.c |  17 ++++++
>  arch/x86/kvm/mmu/tdp_iter.h |   1 +
>  arch/x86/kvm/mmu/tdp_mmu.c  | 106 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h  |   2 +
>  5 files changed, 141 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f09081f9137b0..7a17cca19b0c1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5852,6 +5852,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	kvm_reload_remote_mmus(kvm);
>  
>  	kvm_zap_obsolete_pages(kvm);
> +
> +	if (kvm->arch.tdp_mmu_enabled)
> +		kvm_tdp_mmu_zap_all(kvm);

Haven't looked into how this works; is kvm_tdp_mmu_zap_all() additive to
what is done by the legacy zapping, or is it a replacement?

> +
>  	spin_unlock(&kvm->mmu_lock);
>  }
> @@ -57,8 +58,13 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  	return root->tdp_mmu_page;
>  }
>  
> +static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> +			  gfn_t start, gfn_t end);
> +
>  static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  {
> +	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);

BIT_ULL(...)

> +
>  	lockdep_assert_held(&kvm->mmu_lock);
>  
>  	WARN_ON(root->root_count);
> @@ -66,6 +72,8 @@ static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  
>  	list_del(&root->link);
>  
> +	zap_gfn_range(kvm, root, 0, max_gfn);
> +
>  	free_page((unsigned long)root->spt);
>  	kmem_cache_free(mmu_page_header_cache, root);
>  }
> @@ -193,6 +201,11 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  				u64 old_spte, u64 new_spte, int level);
>  
> +static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
> +{
> +	return sp->role.smm ? 1 : 0;
> +}
> +
>  /**
>   * handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
> @@ -294,3 +307,96 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  		free_page((unsigned long)pt);
>  	}
>  }
> +
> +#define for_each_tdp_pte_root(_iter, _root, _start, _end) \
> +	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
> +
> +/*
> + * If the MMU lock is contended or this thread needs to yield, flushes
> + * the TLBs, releases, the MMU lock, yields, reacquires the MMU lock,
> + * restarts the tdp_iter's walk from the root, and returns true.
> + * If no yield is needed, returns false.
> + */
> +static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +{
> +	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> +		kvm_flush_remote_tlbs(kvm);
> +		cond_resched_lock(&kvm->mmu_lock);
> +		tdp_iter_refresh_walk(iter);
> +		return true;
> +	} else {
> +		return false;
> +	}

Kernel style is to not bother with an "else" if the "if" returns.

> +}
> +
> +/*
> + * Tears down the mappings for the range of gfns, [start, end), and frees the
> + * non-root pages mapping GFNs strictly within that range. Returns true if
> + * SPTEs have been cleared and a TLB flush is needed before releasing the
> + * MMU lock.
> + */
> +static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> +			  gfn_t start, gfn_t end)
> +{
> +	struct tdp_iter iter;
> +	bool flush_needed = false;
> +	int as_id = kvm_mmu_page_as_id(root);
> +
> +	for_each_tdp_pte_root(iter, root, start, end) {
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
> +		/*
> +		 * If this is a non-last-level SPTE that covers a larger range
> +		 * than should be zapped, continue, and zap the mappings at a
> +		 * lower level.
> +		 */
> +		if ((iter.gfn < start ||
> +		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
> +		    !is_last_spte(iter.old_spte, iter.level))
> +			continue;
> +
> +		*iter.sptep = 0;
> +		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte, 0,
> +				    iter.level);
> +
> +		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
> +	}
> +	return flush_needed;
> +}
> +
> +/*
> + * Tears down the mappings for the range of gfns, [start, end), and frees the
> + * non-root pages mapping GFNs strictly within that range. Returns true if
> + * SPTEs have been cleared and a TLB flush is needed before releasing the
> + * MMU lock.
> + */
> +bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_mmu_page *root;
> +	bool flush = false;
> +
> +	for_each_tdp_mmu_root(kvm, root) {
> +		/*
> +		 * Take a reference on the root so that it cannot be freed if
> +		 * this thread releases the MMU lock and yields in this loop.
> +		 */
> +		get_tdp_mmu_root(kvm, root);
> +
> +		flush = zap_gfn_range(kvm, root, start, end) || flush;
> +
> +		put_tdp_mmu_root(kvm, root);
> +	}
> +
> +	return flush;
> +}
> +
> +void kvm_tdp_mmu_zap_all(struct kvm *kvm)
> +{
> +	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);

BIT_ULL

> +	bool flush;
> +
> +	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
> +	if (flush)
> +		kvm_flush_remote_tlbs(kvm);
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 9274debffeaa1..cb86f9fe69017 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -12,4 +12,6 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>  void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
>  
> +bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
> +void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
