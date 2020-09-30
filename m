Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD81027EFE5
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 19:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgI3RD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 13:03:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:28526 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3RD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 13:03:57 -0400
IronPort-SDR: ajedkFEnkuiwyG71rwyUF2X37o2fmFBGb1n4/OsyY1d90bv7z4eu4zOyM2PvYe/Tv7QaXTX7Nd
 wIPIoUJURdiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="161725106"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="161725106"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 10:03:56 -0700
IronPort-SDR: V9welq7gA/v5MO6CmpIQWnKqOsruSsnNHpSd0rkeMK5DOT6kO10llvmbXMtObM1fjgl4C5ALgd
 cRAWTQbOAHjw==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="350730342"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 10:03:55 -0700
Date:   Wed, 30 Sep 2020 10:03:54 -0700
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
Subject: Re: [PATCH 13/22] kvm: mmu: Support invalidate range MMU notifier
 for TDP MMU
Message-ID: <20200930170354.GF32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-14-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-14-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:53PM -0700, Ben Gardon wrote:
> In order to interoperate correctly with the rest of KVM and other Linux
> subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
> hooks to handle the invalidate range family of MMU notifiers.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  9 ++++-
>  arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
>  3 files changed, 86 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 52d661a758585..0ddfdab942554 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1884,7 +1884,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
>  			unsigned flags)
>  {
> -	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> +	int r;
> +
> +	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> +
> +	if (kvm->arch.tdp_mmu_enabled)
> +		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);

Similar to an earlier question, is this intentionally additive, or can this
instead by:

	if (kvm->arch.tdp_mmu_enabled)
		r = kvm_tdp_mmu_zap_hva_range(kvm, start, end);
	else
		r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);

> +
> +	return r;
>  }
>  
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 557e780bdf9f9..1cea58db78a13 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -60,7 +60,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  }
>  
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end);
> +			  gfn_t start, gfn_t end, bool can_yield);
>  
>  static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  {
> @@ -73,7 +73,7 @@ static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  
>  	list_del(&root->link);
>  
> -	zap_gfn_range(kvm, root, 0, max_gfn);
> +	zap_gfn_range(kvm, root, 0, max_gfn, false);
>  
>  	free_page((unsigned long)root->spt);
>  	kmem_cache_free(mmu_page_header_cache, root);
> @@ -361,9 +361,14 @@ static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>   * non-root pages mapping GFNs strictly within that range. Returns true if
>   * SPTEs have been cleared and a TLB flush is needed before releasing the
>   * MMU lock.
> + * If can_yield is true, will release the MMU lock and reschedule if the
> + * scheduler needs the CPU or there is contention on the MMU lock. If this
> + * function cannot yield, it will not release the MMU lock or reschedule and
> + * the caller must ensure it does not supply too large a GFN range, or the
> + * operation can cause a soft lockup.
>   */
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end)
> +			  gfn_t start, gfn_t end, bool can_yield)
>  {
>  	struct tdp_iter iter;
>  	bool flush_needed = false;
> @@ -387,7 +392,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte, 0,
>  				    iter.level);
>  
> -		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
> +		if (can_yield)
> +			flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);

		flush_needed = !can_yield || !tdp_mmu_iter_cond_resched(kvm, &iter);

> +		else
> +			flush_needed = true;
>  	}
>  	return flush_needed;
>  }
> @@ -410,7 +418,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
>  		 */
>  		get_tdp_mmu_root(kvm, root);
>  
> -		flush = zap_gfn_range(kvm, root, start, end) || flush;
> +		flush = zap_gfn_range(kvm, root, start, end, true) || flush;
>  
>  		put_tdp_mmu_root(kvm, root);
>  	}
> @@ -551,3 +559,65 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
>  
>  	return ret;
>  }
> +
> +static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
> +		unsigned long end, unsigned long data,
> +		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			       struct kvm_mmu_page *root, gfn_t start,
> +			       gfn_t end, unsigned long data))
> +{
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *memslot;
> +	struct kvm_mmu_page *root;
> +	int ret = 0;
> +	int as_id;
> +
> +	for_each_tdp_mmu_root(kvm, root) {
> +		/*
> +		 * Take a reference on the root so that it cannot be freed if
> +		 * this thread releases the MMU lock and yields in this loop.
> +		 */
> +		get_tdp_mmu_root(kvm, root);
> +
> +		as_id = kvm_mmu_page_as_id(root);
> +		slots = __kvm_memslots(kvm, as_id);
> +		kvm_for_each_memslot(memslot, slots) {
> +			unsigned long hva_start, hva_end;
> +			gfn_t gfn_start, gfn_end;
> +
> +			hva_start = max(start, memslot->userspace_addr);
> +			hva_end = min(end, memslot->userspace_addr +
> +				      (memslot->npages << PAGE_SHIFT));
> +			if (hva_start >= hva_end)
> +				continue;
> +			/*
> +			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> +			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> +			 */
> +			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
> +			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
> +
> +			ret |= handler(kvm, memslot, root, gfn_start,
> +				       gfn_end, data);

Eh, I'd say let this one poke out, the above hva_to_gfn_memslot() already
overruns 80 chars.  IMO it's more readable without the wraps.

> +		}
> +
> +		put_tdp_mmu_root(kvm, root);
> +	}
> +
> +	return ret;
> +}
> +
> +static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
> +				     struct kvm_memory_slot *slot,
> +				     struct kvm_mmu_page *root, gfn_t start,
> +				     gfn_t end, unsigned long unused)
> +{
> +	return zap_gfn_range(kvm, root, start, end, false);
> +}
> +
> +int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> +			      unsigned long end)
> +{
> +	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
> +					    zap_gfn_range_hva_wrapper);
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index abf23dc0ab7ad..ce804a97bfa1d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -18,4 +18,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
>  			   int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
>  			   bool lpage_disallowed);
> +
> +int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> +			      unsigned long end);
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
