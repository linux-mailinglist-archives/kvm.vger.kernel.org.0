Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA613535241
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiEZQkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 12:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiEZQka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 12:40:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C973B3C0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:40:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c65so1558527pfb.1
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qm/bVNNdXqTapnzq5a3prBU390ldFSuOXJiLpWHawkQ=;
        b=R+x1MUxR33XfpedDwvQaiuAUW+Q7ZEcX45T5t+DjlDw+0CKO6rEsBRh61K2L5VY7B0
         lZfl1BBiXcxYE8Mruw1/QPLIUOXDeQ/hc7m8dtGqLKVnRX0zjb7Uexm2wyMOxftJi9tC
         f56c9oAqTf0cBZY2+H9f9rE5oWA9ikXykDr4Ghw/bAhX6JahCuIH3yZ/8ih8I8r/2AG6
         8t5MrmFIJYmmjmPfNwXUwqYyJh+ACyMziAzj5dXUU7LeITI5IANrDMSaWiyOeJbgKjYh
         MkA8ivnsvzjqXpv2k/bYgr4jb+QuoYuzTDszQaqOB+E/lRytNu5W2LhpBtBaDXyy+tSh
         IHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qm/bVNNdXqTapnzq5a3prBU390ldFSuOXJiLpWHawkQ=;
        b=Nkc5+x1M314bGVo8FkhGZSRWx8qCOt7KpA4aT+8IgMX1c7uxXilCCGaQwVK4Q8oOnO
         nAmooLIkZ+fVmWyXVYOxVRWHs9x1dQQAWiIeuzapDeAjlOkG4Dgx2LYEYie7Ffg/PNQq
         lDtrfW1N0ZJeQkZxnLR3OPeLJaaMzFq1OVyKQ1tU6VEYhdMdUGvH3T6TemLg+/Eqghw7
         l/8ABGOJVCGD2DNOf0HazoBWa6VWGludf4zvCL1xTDBopoKQKFZ1VEP/POdpMv+rvh2P
         AktiGcsQAiI8y3Vf+Nbn74o2MJxnKk9Pl3zYsSj5nDGj/qOlbVMuXx1NfyzqYkTOISbl
         LQ/w==
X-Gm-Message-State: AOAM532xQKLw4RXlsVRS5vboIVpyKaUUuKe4a4ltyHOhw74C8TNNKtX+
        +Eg4DXw8ByW9r9kpBXW0pK9hgIfwSF3vxg==
X-Google-Smtp-Source: ABdhPJyGGDxeevh6Hrci70x5DivpUnSf32p7bYI5avh1GAy878a7gP1PLmaPpluQ5Iefh9lutvBiIg==
X-Received: by 2002:a05:6a00:1411:b0:4fd:e594:fac0 with SMTP id l17-20020a056a00141100b004fde594fac0mr39518591pfu.79.1653583228391;
        Thu, 26 May 2022 09:40:28 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a00231200b005104c6d7941sm1767647pfh.31.2022.05.26.09.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 09:40:27 -0700 (PDT)
Date:   Thu, 26 May 2022 16:40:23 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
 logging
Message-ID: <Yo+td/A+yEK8z7Z/@google.com>
References: <20220525230904.1584480-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525230904.1584480-1-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Nice!

It'd be good to also mention the new WARN. e.g.

  Opportunistically add a WARN() to catch GFNS that are mapped at a
  higher level than their max level.

> 
> Testing:
> Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
> patch introduced no new failures.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

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
