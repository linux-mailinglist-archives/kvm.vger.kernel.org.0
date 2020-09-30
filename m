Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2927F0B6
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgI3RtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 13:49:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:9702 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgI3RtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 13:49:02 -0400
IronPort-SDR: lbnM/WN/KQEqH/INyCO70FRuluVReZBOUfNYRkVeksiDrhzBvD5NhGmkR1QdMloKyWH94YcXrY
 TKBhQl2WNRMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="247229391"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="247229391"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 10:49:01 -0700
IronPort-SDR: YObUFLCMlpQRUAtFRw7Nv3r+9L0tp72d+DGCASSdgLMUc82Htp1BVRhFbUl5oHY9Y/bKk3ilvy
 MvF5p1GoKv6g==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="308245900"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 10:49:00 -0700
Date:   Wed, 30 Sep 2020 10:48:59 -0700
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
Subject: Re: [PATCH 14/22] kvm: mmu: Add access tracking for tdp_mmu
Message-ID: <20200930174858.GG32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-15-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-15-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:54PM -0700, Ben Gardon wrote:
> @@ -1945,12 +1944,24 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>  
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
>  {
> -	return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
> +	int young = false;
> +
> +	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
> +	if (kvm->arch.tdp_mmu_enabled)

If we end up with a per-VM flag, would it make sense to add a static key
wrapper similar to the in-kernel lapic?  I assume once this lands the vast
majority of VMs will use the TDP MMU.

> +		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
> +
> +	return young;
>  }

...

> +
> +/*
> + * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
> + * if any of the GFNs in the range have been accessed.
> + */
> +static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			 struct kvm_mmu_page *root, gfn_t start, gfn_t end,
> +			 unsigned long unused)
> +{
> +	struct tdp_iter iter;
> +	int young = 0;
> +	u64 new_spte = 0;
> +	int as_id = kvm_mmu_page_as_id(root);
> +
> +	for_each_tdp_pte_root(iter, root, start, end) {

Ah, I think we should follow the existing shadow iterates by naming this

	for_each_tdp_pte_using_root()

My first reaction was that this was iterating over TDP roots, which was a bit
confusing.  I suspect others will make the same mistake unless they look at the
implementation of for_each_tdp_pte_root().

Similar comments on the _vcpu() variant.  For that one I think it'd be
preferable to take the struct kvm_mmu, i.e. have for_each_tdp_pte_using_mmu(),
as both kvm_tdp_mmu_page_fault() and kvm_tdp_mmu_get_walk() explicitly
reference vcpu->arch.mmu in the surrounding code.

E.g. I find this more intuitive

	struct kvm_mmu *mmu = vcpu->arch.mmu;
	int leaf = mmu->shadow_root_level;

	for_each_tdp_pte_using_mmu(iter, mmu, gfn, gfn + 1) {
		leaf = iter.level;
		sptes[leaf - 1] = iter.old_spte;
	}

	return leaf

versus this, which makes me want to look at the implementation of for_each().


	int leaf = vcpu->arch.mmu->shadow_root_level;

	for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
		...
	}

> +		if (!is_shadow_present_pte(iter.old_spte) ||
> +		    !is_last_spte(iter.old_spte, iter.level))
> +			continue;
> +
> +		/*
> +		 * If we have a non-accessed entry we don't need to change the
> +		 * pte.
> +		 */
> +		if (!is_accessed_spte(iter.old_spte))
> +			continue;
> +
> +		new_spte = iter.old_spte;
> +
> +		if (spte_ad_enabled(new_spte)) {
> +			clear_bit((ffs(shadow_accessed_mask) - 1),
> +				  (unsigned long *)&new_spte);
> +		} else {
> +			/*
> +			 * Capture the dirty status of the page, so that it doesn't get
> +			 * lost when the SPTE is marked for access tracking.
> +			 */
> +			if (is_writable_pte(new_spte))
> +				kvm_set_pfn_dirty(spte_to_pfn(new_spte));
> +
> +			new_spte = mark_spte_for_access_track(new_spte);
> +		}
> +
> +		*iter.sptep = new_spte;
> +		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
> +				      new_spte, iter.level);
> +		young = true;

young is an int, not a bool.  Not really your fault as KVM has a really bad
habit of using ints instead of bools.

> +	}
> +
> +	return young;
> +}
> +
> +int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
> +			      unsigned long end)
> +{
> +	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
> +					    age_gfn_range);
> +}
> +
> +static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
> +			unsigned long unused2)
> +{
> +	struct tdp_iter iter;
> +	int young = 0;
> +
> +	for_each_tdp_pte_root(iter, root, gfn, gfn + 1) {
> +		if (!is_shadow_present_pte(iter.old_spte) ||
> +		    !is_last_spte(iter.old_spte, iter.level))
> +			continue;
> +
> +		if (is_accessed_spte(iter.old_spte))
> +			young = true;

Same bool vs. int weirdness here.  Also, |= doesn't short circuit for ints
or bools, so this can be

		young |= is_accessed_spte(...)

Actually, can't we just return true immediately?

> +	}
> +
> +	return young;
> +}
> +
> +int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
> +{
> +	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
> +					    test_age_gfn);
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index ce804a97bfa1d..f316773b7b5a8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -21,4 +21,8 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
>  
>  int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
>  			      unsigned long end);
> +
> +int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
> +			      unsigned long end);
> +int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
