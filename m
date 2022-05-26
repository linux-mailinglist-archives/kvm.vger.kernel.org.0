Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D78053482C
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345871AbiEZBab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 21:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345886AbiEZBaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 21:30:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B122BC6F6;
        Wed, 25 May 2022 18:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653528614; x=1685064614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a8+WUe4B0ciu7UC0zA7ygOhzD7vTZsn3gC9JC/7qays=;
  b=RwbTImCD9ckRaOF3JENfzcWQoCFkyByl/uiytOCrIhsgOcCbXrpsYZYQ
   3SbvwC+lRcgp4MCiwrbvg7qz2ewwgqMOPkufR+AhZY/KMNZo4iAatDgTI
   xTJrLIRhVKk9j98rC8yoUf+Da8t1DU+j3IlB2CmdY1nnzBo5N10Pevzgh
   PesWteXbWwkDvYEIPdSiEfXaoisUxv6U6XMIGm4GGMUFLtj9/OJtooGX5
   dfR/jk4M+JGIFKFd9BEwJ8lxolgflFOPCJZsZam+zhLnqp6MwqgsqRvRN
   wov/xd1FPbe9G1VGQJESrgxfi59r9u0D2nYWunz4uP6QRrdKai+dRUz7c
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="253860813"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="253860813"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 18:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="559947247"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 25 May 2022 18:30:10 -0700
Date:   Thu, 26 May 2022 09:30:10 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
 logging
Message-ID: <20220526013010.ag4jzs7bbt5mudrg@yy-desk-7060>
References: <20220525230904.1584480-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525230904.1584480-1-bgardon@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 11:09:04PM +0000, Ben Gardon wrote:
> When disabling dirty logging, zap non-leaf parent entries to allow
> replacement with huge pages instead of recursing and zapping all of the
> child, leaf entries. This reduces the number of TLB flushes required.
>
> Currently disabling dirty logging with the TDP MMU is extremely slow.
> On a 96 vCPU / 96G VM backed with gigabyte pages, it takes ~200 seconds
> to disable dirty logging with the TDP MMU, as opposed to ~4 seconds with
> the shadow MMU. This patch reduces the disable dirty log time with the
> TDP MMU to ~3 seconds.
>
> Testing:
> Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
> patch introduced no new failures.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  9 +++++++++
>  arch/x86/kvm/mmu/tdp_iter.h |  1 +
>  arch/x86/kvm/mmu/tdp_mmu.c  | 38 +++++++++++++++++++++++++++++++------
>  3 files changed, 42 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index 6d3b3e5a5533..ee4802d7b36c 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -145,6 +145,15 @@ static bool try_step_up(struct tdp_iter *iter)
>  	return true;
>  }
>
> +/*
> + * Step the iterator back up a level in the paging structure. Should only be
> + * used when the iterator is below the root level.
> + */
> +void tdp_iter_step_up(struct tdp_iter *iter)
> +{
> +	WARN_ON(!try_step_up(iter));
> +}
> +
>  /*
>   * Step to the next SPTE in a pre-order traversal of the paging structure.
>   * To get to the next SPTE, the iterator either steps down towards the goal
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index f0af385c56e0..adfca0cf94d3 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -114,5 +114,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  		    int min_level, gfn_t next_last_level_gfn);
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
> +void tdp_iter_step_up(struct tdp_iter *iter);
>
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 841feaa48be5..7b9265d67131 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1742,12 +1742,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  	gfn_t start = slot->base_gfn;
>  	gfn_t end = start + slot->npages;
>  	struct tdp_iter iter;
> +	int max_mapping_level;
>  	kvm_pfn_t pfn;
>
>  	rcu_read_lock();
>
>  	tdp_root_for_each_pte(iter, root, start, end) {
> -retry:
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
>
> @@ -1755,15 +1755,41 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>
> +		/*
> +		 * This is a leaf SPTE. Check if the PFN it maps can
> +		 * be mapped at a higher level.
> +		 */
>  		pfn = spte_to_pfn(iter.old_spte);
> -		if (kvm_is_reserved_pfn(pfn) ||
> -		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
> -							    pfn, PG_LEVEL_NUM))
> +
> +		if (kvm_is_reserved_pfn(pfn))
>  			continue;
>
> +		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> +				iter.gfn, pfn, PG_LEVEL_NUM);
> +
> +		WARN_ON(max_mapping_level < iter.level);
> +
> +		/*
> +		 * If this page is already mapped at the highest
> +		 * viable level, there's nothing more to do.
> +		 */
> +		if (max_mapping_level == iter.level)
> +			continue;
> +
> +		/*
> +		 * The page can be remapped at a higher level, so step
> +		 * up to zap the parent SPTE.
> +		 */
> +		while (max_mapping_level > iter.level)
> +			tdp_iter_step_up(&iter);

So the benefit from this is:
Before: Zap 512 ptes in 4K level page table do TLB flush 512 times.
Now: Zap higher level 1 2MB level pte do TLB flush 1 time, event
     it also handles all 512 lower level 4K ptes, but just atomic operation
     there, see handle_removed_pt().

Is my understanding correct ?

> +
>  		/* Note, a successful atomic zap also does a remote TLB flush. */
> -		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> -			goto retry;
> +		tdp_mmu_zap_spte_atomic(kvm, &iter);
> +
> +		/*
> +		 * If the atomic zap fails, the iter will recurse back into
> +		 * the same subtree to retry.
> +		 */
>  	}
>
>  	rcu_read_unlock();
> --
> 2.36.1.124.g0e6072fb45-goog
>
