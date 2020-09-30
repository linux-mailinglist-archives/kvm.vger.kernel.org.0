Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDAB27F100
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgI3SEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:04:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:11258 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3SEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:04:45 -0400
IronPort-SDR: bkp9gNTt+wCfmFHRdw/POWgftgyu0PUFu2eKLWMo1f5KuypR3/e3wOoGct/FnhCmX5x/pTdLYr
 H48ft4pt4Ozw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="247234912"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="247234912"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:04:43 -0700
IronPort-SDR: I0dCNHipiIbsdyw6DNVgyHoR71iGEmLRSr5q0cMX2x9jIN2GPBWG79zFGjRpciJ5vB4HfYOTz0
 1hWtL3rbKFNQ==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="341276374"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:04:43 -0700
Date:   Wed, 30 Sep 2020 11:04:42 -0700
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
Subject: Re: [PATCH 17/22] kvm: mmu: Support dirty logging for the TDP MMU
Message-ID: <20200930180438.GH32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-18-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-18-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:57PM -0700, Ben Gardon wrote:
> +/*
> + * Remove write access from all the SPTEs mapping GFNs in the memslot. If
> + * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
> + * Returns true if an SPTE has been changed and the TLBs need to be flushed.
> + */
> +bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			     bool skip_4k)
> +{
> +	struct kvm_mmu_page *root;
> +	int root_as_id;
> +	bool spte_set = false;
> +
> +	for_each_tdp_mmu_root(kvm, root) {
> +		root_as_id = kvm_mmu_page_as_id(root);
> +		if (root_as_id != slot->as_id)
> +			continue;

This pattern pops up quite a few times, probably worth adding

#define for_each_tdp_mmu_root_using_memslot(...)	\
	for_each_tdp_mmu_root(...)			\
		if (kvm_mmu_page_as_id(root) != slot->as_id) {
		} else

> +
> +		/*
> +		 * Take a reference on the root so that it cannot be freed if
> +		 * this thread releases the MMU lock and yields in this loop.
> +		 */
> +		get_tdp_mmu_root(kvm, root);
> +
> +		spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
> +				slot->base_gfn + slot->npages, skip_4k) ||
> +			   spte_set;
> +
> +		put_tdp_mmu_root(kvm, root);
> +	}
> +
> +	return spte_set;
> +}
> +
> +/*
> + * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
> + * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
> + * If AD bits are not enabled, this will require clearing the writable bit on
> + * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
> + * be flushed.
> + */
> +static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> +			   gfn_t start, gfn_t end)
> +{
> +	struct tdp_iter iter;
> +	u64 new_spte;
> +	bool spte_set = false;
> +	int as_id = kvm_mmu_page_as_id(root);
> +
> +	for_each_tdp_pte_root(iter, root, start, end) {
> +		if (!is_shadow_present_pte(iter.old_spte) ||
> +		    !is_last_spte(iter.old_spte, iter.level))
> +			continue;

Same thing here, extra wrappers would probably be helpful.  At least add one
for the present case, e.g.

  #define for_each_present_tdp_pte_using_root()

and maybe even

  #define for_each_leaf_tdp_pte_using_root()

since the "!present || !last" pops up 4 or 5 times.

> +
> +		if (spte_ad_need_write_protect(iter.old_spte)) {
> +			if (is_writable_pte(iter.old_spte))
> +				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> +			else
> +				continue;
