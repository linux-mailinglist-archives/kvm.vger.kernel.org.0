Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9334E9DC3
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242674AbiC1RrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiC1RrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:47:17 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ADF1EACD
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:45:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m18so10413521plx.3
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DFRGfZNHGMMZKzJXUtu7ywwZlF3JepUWQrm/J5WbDog=;
        b=Yy3kEtjMZs/I13OAjIHNMfVQqyx8j2y9dZpaYo4UdgPeSC0LY3fzpXqyQ1VsawjRh3
         HwC+BnDEukxYsn8YMnQzppXPNqj+Nj9Q4853j941qJtuaAulWV7jo1a4mKB+fQSnR+vm
         drF6ZUCZ9nd5FoWi9r1laR/5SAp/fBFtmBRaqXNbVvKTCooqfShSqN/IjsckscJjHFq/
         Le80edO/zX0cwYTdpWnyk5dZKV4G1rpdY1nbimdPoz7iLCKv87dfnAfhMQ55CAdB1ffW
         kPdFJPrVld3qFIzI72m2dFfazJVSIhgPntvLB2to/twgjxjs3ydu3VxBuEdT02TAnsKo
         7Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DFRGfZNHGMMZKzJXUtu7ywwZlF3JepUWQrm/J5WbDog=;
        b=H3t8zWxo8XCM1dpRdudpXSVZpdJGNiyinFbQyQyA1dt+wMSaZNktSyhjFGqUtkmSfn
         rSHBu+dtbcw1myq6TnDCXnkAKZAWqEvIUmGj1YW2a6t8BUf0wS3+rSNKmHgMNVuwgUhF
         wEknfdlJv35flzC8cpckXaVgvN/yD/4XZ6cPeoAik2V4WygitT6a1W6h4Zk/XhtsO7Fk
         RA9MZVkYVK43ITDjPd4DRJMURhb5kNWerDLmrEH/sNpMb81HPRSV6SBXuBH0vYv29HG/
         2tDSHplS8/zgTirVUVqTr5Tlb1Vy2cIY+BS7bFv/sMlT9KJoBbVlUmr6NpIfg/zVFTd0
         owHw==
X-Gm-Message-State: AOAM530y2sbSYXLWuQ7C8pVrBiPOMGJ8STodwt9XZAxAFjrLjg/cKUwH
        cR80hLKNa4+ZzUF+liqiMguxmx8GrmpFfg==
X-Google-Smtp-Source: ABdhPJwEx7IuTcEsLqYET6UU/G+s23PPdN9RvYtLCUVjSTVaQ++fYWkpyiwXGZwx1OCTpvKAaHQ6/Q==
X-Received: by 2002:a17:902:cec8:b0:154:6dd6:255d with SMTP id d8-20020a170902cec800b001546dd6255dmr27367332plg.62.1648489535569;
        Mon, 28 Mar 2022 10:45:35 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id e6-20020a63aa06000000b00380c8bed5a6sm14379851pgf.46.2022.03.28.10.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:45:34 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:45:31 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <YkH0O2Qh7lRizGtC@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-10-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-10-bgardon@google.com>
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

On Mon, Mar 21, 2022 at 03:43:58PM -0700, Ben Gardon wrote:
> When disabling dirty logging, the TDP MMU currently zaps each leaf entry
> mapping memory in the relevant memslot. This is very slow. Doing the zaps
> under the mmu read lock requires a TLB flush for every zap and the
> zapping causes a storm of ETP/NPT violations.
> 
> Instead of zapping, replace the split large pages with large page
> mappings directly. While this sort of operation has historically only
> been done in the vCPU page fault handler context, refactorings earlier
> in this series and the relative simplicity of the TDP MMU make it
> possible here as well.
> 
> Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
> of memory per vCPU, this reduces the time required to disable dirty
> logging from over 45 seconds to just over 1 second. It also avoids
> provoking page faults, improving vCPU performance while disabling
> dirty logging.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          |  4 +-
>  arch/x86/kvm/mmu/mmu_internal.h |  6 +++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 73 ++++++++++++++++++++++++++++++++-
>  3 files changed, 79 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f98111f8f8b..a99c23ef90b6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -100,7 +100,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>   */
>  bool tdp_enabled = false;
>  
> -static int max_huge_page_level __read_mostly;
> +int max_huge_page_level;
>  static int tdp_root_level __read_mostly;
>  static int max_tdp_level __read_mostly;
>  
> @@ -4486,7 +4486,7 @@ static inline bool boot_cpu_is_amd(void)
>   * the direct page table on host, use as much mmu features as
>   * possible, however, kvm currently does not do execution-protection.
>   */
> -static void
> +void
>  build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
>  				int shadow_root_level)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1bff453f7cbe..6c08a5731fcb 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -171,4 +171,10 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
> +void
> +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> +				int shadow_root_level);
> +
> +extern int max_huge_page_level __read_mostly;
> +
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index af60922906ef..eb8929e394ec 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1709,6 +1709,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
>  
> +static bool try_promote_lpage(struct kvm *kvm,
> +			      const struct kvm_memory_slot *slot,
> +			      struct tdp_iter *iter)

Use "huge_page" instead of "lpage" to be consistent with eager page
splitting and the rest of the Linux kernel. Some of the old KVM methods
still use "lpage" and "large page", but we're slowly moving away from
that.

> +{
> +	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> +	struct rsvd_bits_validate shadow_zero_check;
> +	bool map_writable;
> +	kvm_pfn_t pfn;
> +	u64 new_spte;
> +	u64 mt_mask;
> +
> +	/*
> +	 * If addresses are being invalidated, don't do in-place promotion to
> +	 * avoid accidentally mapping an invalidated address.
> +	 */
> +	if (unlikely(kvm->mmu_notifier_count))
> +		return false;

Why is this necessary? Seeing this makes me wonder if we need a similar
check for eager page splitting.

> +
> +	if (iter->level > max_huge_page_level || iter->gfn < slot->base_gfn ||
> +	    iter->gfn >= slot->base_gfn + slot->npages)
> +		return false;
> +
> +	pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
> +				   &map_writable, NULL);
> +	if (is_error_noslot_pfn(pfn))
> +		return false;
> +
> +	/*
> +	 * Can't reconstitute an lpage if the consituent pages can't be
> +	 * mapped higher.
> +	 */
> +	if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
> +						    pfn, PG_LEVEL_NUM))
> +		return false;
> +
> +	build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
> +
> +	/*
> +	 * In some cases, a vCPU pointer is required to get the MT mask,
> +	 * however in most cases it can be generated without one. If a
> +	 * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
> +	 * In that case, bail on in-place promotion.
> +	 */
> +	if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
> +							   kvm_is_mmio_pfn(pfn),
> +							   &mt_mask)))
> +		return false;
> +
> +	__make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
> +		  map_writable, mt_mask, &shadow_zero_check, &new_spte);
> +
> +	if (tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
> +		return true;
> +
> +	/* Re-read the SPTE as it must have been changed by another thread. */
> +	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));

Huge page promotion could be retried in this case.

> +
> +	return false;
> +}
> +
>  /*
>   * Clear leaf entries which could be replaced by large mappings, for
>   * GFNs within the slot.
> @@ -1729,8 +1789,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
>  
> -		if (!is_shadow_present_pte(iter.old_spte) ||
> -		    !is_last_spte(iter.old_spte, iter.level))
> +		if (iter.level > max_huge_page_level ||
> +		    iter.gfn < slot->base_gfn ||
> +		    iter.gfn >= slot->base_gfn + slot->npages)

I feel like I've been seeing this "does slot contain gfn" calculation a
lot in recent commits. It's probably time to create a helper function.
No need to do this clean up as part of your series though, unless you
want to :).

> +			continue;
> +
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
> +		/* Try to promote the constitutent pages to an lpage. */
> +		if (!is_last_spte(iter.old_spte, iter.level) &&
> +		    try_promote_lpage(kvm, slot, &iter))
>  			continue;

If iter.old_spte is not a leaf, the only loop would always continue to
the next SPTE. Now we try to promote it and if that fails we run through
the rest of the loop. This seems broken. For example, in the next line
we end up grabbing the pfn of the non-leaf SPTE (which would be the PFN
of the TDP MMU page table?) and treat that as the PFN backing this GFN,
which is wrong.

In the worst case we end up zapping an SPTE that we didn't need to, but
we should still fix up this code.

>  
>  		pfn = spte_to_pfn(iter.old_spte);
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
