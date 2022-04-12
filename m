Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B054FE620
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357810AbiDLQpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357894AbiDLQph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:45:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E645F4C5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:43:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so17298684plh.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cC6hNcDSob2h1qJMPH49Fl94mXox8pjM3QZWLbewUDg=;
        b=iJKyH5b1m6N+YNB3hGi95xmA6mRRknNsWMP1Zu3scy9gU2ivs51h5RABH8Vwp+ylJL
         fEAJzU+2ooh5U9PqZZ3d96P0u34xZdPGA7fMkRokxribDQOpLnWqsyG0XNHT3q/Mw19o
         p/Ots6B3AT62Zbo4TN2TdCGufXWsWVJ2+dAa6hHfcOZKmV7auEz6i6vN9v4Hb5RUDpgT
         rCfHI+VsIDLhEV4jJdlM4m5GEYYAxJWbrTZ+lbxMAgFBBUcoSyfyAbsI5Q7xFz6K4AFg
         GfH7buQE/RnVNsX+w2C4BwMZzeoGRyQlb5qkbG3Ebg2IeD9L9jJOdi+GnpH6jpIF1W0X
         06RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cC6hNcDSob2h1qJMPH49Fl94mXox8pjM3QZWLbewUDg=;
        b=Hzmu1wE7P3gVUN6MG7bV7YIbfZ8Zg5awonKGLW9/rJzDkRqaKHkmWKZYN5yPuBqbAc
         yRM6V3uEizwGS1IHnBXtoKNebEHy1RfJBm1t5mvzQVw3o172GTgcRJY9ugSS8fGBF6CU
         6mhEg2MoEBFRC2R02X00w5noomRAZYn1R4jhBy4fSHIVPWF7CFftqu1C1tJ5MRCtvUfE
         8MHRdTn4N+lfNo3g23S5zTL8PHN+ken1YHGAF8LjzmSaM+m687H0mOr3CWH6AwMXCI8J
         p3aTeVuYCfhp4AhzBHPTL022vf2n9Knled+88jM0aqj2S11Dtidn+jK23mdsoUEArssh
         bhFA==
X-Gm-Message-State: AOAM5323B2E2+qTBPBg+7n0lIkO/Nh6ruTJn0g8jmPDdiuMnV2o3atoO
        Xauvlz1eNKOGpnx5MyAE//SlyA==
X-Google-Smtp-Source: ABdhPJxG3Hrann2XtU6smEa42o9pXeSIJgM7E0Zud6j1a3qpLaNEVbPIwBvvEyx9yG4qD134bG956g==
X-Received: by 2002:a17:902:6bc6:b0:157:c19e:d149 with SMTP id m6-20020a1709026bc600b00157c19ed149mr23604400plt.24.1649781799109;
        Tue, 12 Apr 2022 09:43:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm28488104pfj.118.2022.04.12.09.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:43:18 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:43:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <YlWsImxP0C01BUtM@google.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022, Ben Gardon wrote:
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

Same comments from the earlier patch.

> +extern int max_huge_page_level __read_mostly;

Can you put this at the top of the heaader?  x86.h somehow ended up with extern
variables being declared in the middle of the file and I find it very jarring,
e.g. global definitions are pretty much never buried in the middle of a .c file.

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

I believe we've settled on huge_page instead of lpage.

And again, I strongly prefer a 0/-errno return instead of a boolean as seeing
-EBUSY or whatever makes it super obviously that the early returns are failure
paths.

> +			      const struct kvm_memory_slot *slot,
> +			      struct tdp_iter *iter)
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

"huge page", though honestly I'd just drop the comment, IMO this is more intuitive
then say the checks against the slot stuff above.

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

I wouldn't bother with the "unlikely".  It's wrong for a VM with non-coherent DMA,
and it's very unlikely (heh) to actually be a meaningful optimization in any case.

> +							   kvm_is_mmio_pfn(pfn),
> +							   &mt_mask)))
> +		return false;
> +
> +	__make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,

A comment stating the return type is intentionally ignore would be helpful.  Not
strictly necessary because it's mostly obvious after looking at the details, but
it'd save someone from having to dig into said details.

> +		  map_writable, mt_mask, &shadow_zero_check, &new_spte);

Bad indentation.

> +
> +	if (tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
> +		return true;

And by returning an int, and because the failure path rereads the SPTE for you,
this becomes:

	return tdp_mmu_set_spte_atomic(kvm, iter, new_spte);

> +
> +	/* Re-read the SPTE as it must have been changed by another thread. */
> +	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +
> +	return false;
> +}
> +
>  /*
>   * Clear leaf entries which could be replaced by large mappings, for
>   * GFNs within the slot.

This comment needs to be updated to include the huge page promotion behavior. And
maybe renamed the function too?  E.g.

static void zap_or_promote_collapsible_sptes(struct kvm *kvm,
					     struct kvm_mmu_page *root,
					     const struct kvm_memory_slot *slot)

> @@ -1729,8 +1789,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
>  
> -		if (!is_shadow_present_pte(iter.old_spte) ||
> -		    !is_last_spte(iter.old_spte, iter.level))
> +		if (iter.level > max_huge_page_level ||
> +		    iter.gfn < slot->base_gfn ||
> +		    iter.gfn >= slot->base_gfn + slot->npages)

Isn't this exact check in try_promote_lpage()?  Ditto for the kvm_mmu_max_mapping_level()
check that's just out of sight.  That one in particular can be somewhat expsensive,
especially when KVM is fixed to use a helper that disable IRQs so the host page tables
aren't freed while they're being walked.  Oh, and the huge page promotion path
doesn't incorporate the reserved pfn check.

In other words, shouldn't this be:


		if (!is_shadow_present_pte(iter.old_spte))
			continue;

		if (iter.level > max_huge_page_level ||
		    iter.gfn < slot->base_gfn ||
		    iter.gfn >= slot->base_gfn + slot->npages)
			continue;

		pfn = spte_to_pfn(iter.old_spte);
		if (kvm_is_reserved_pfn(pfn) ||
		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
							    pfn, PG_LEVEL_NUM))
			continue;

Followed by the promotion stuff.  And then unless I'm overlooking something, "pfn"
can be passed into try_promote_huge_page(), it just needs to be masked appropriately.
I.e. the promotion path can avoid the __gfn_to_pfn_memslot() lookup and also drop
its is_error_noslot_pfn() check since the pfn is pulled from the SPTE and KVM should
never install garbage into the SPTE (emulated/noslot MMIO pfns fail the shadow
present check).

> +			continue;
> +
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;

I strongly prefer to keep the !is_shadow_present_pte() check first, it really
should be the first thing any of these flows check.

> +
> +		/* Try to promote the constitutent pages to an lpage. */
> +		if (!is_last_spte(iter.old_spte, iter.level) &&
> +		    try_promote_lpage(kvm, slot, &iter))

There is an undocumented function change here, and I can't tell if it's intentional.
If the promotion fails, KVM continues on an zaps the non-leaf shadow page.  If that
is intentional behavior, it should be done in a follow-up patch, e.g. so that it can
be easily reverted if it turns out that zappping e.g. a PUD is bad for performance.

I.e. shouldn't this be:

		if (!is_last_spte(iter.old_spte, iter.level)) {
			try_promote_huge_page(...);
			continue;
		}

and then converted to the current variant in a follow-up?

>  			continue;
>  
>  		pfn = spte_to_pfn(iter.old_spte);
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
