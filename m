Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B30E69FC60
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 20:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjBVTnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 14:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjBVTnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 14:43:01 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F53AA9
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 11:43:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z10so6971993ple.6
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 11:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kRmAPGwQXO+tCQzgAIz/+MxdpLOLdUGFrnqf04p6lc=;
        b=WuFqT5PWyBDjW6lxMbo6or7xz51H+DWmyWugdCzi0nk3l/XAsdqqNu54ZAuJ9akFLb
         wPzifLp0IsUpB9eeIRBxOHPw1S1moAyQCarz10apS5P1WTaidK6bYejTxyhZMrjlFgUA
         oAvZI43UmlqvJy57MTE1+RPapJYu+s28WF0GiaaIEMxQyGiFItSoO97NLFE+ULzGL+Nv
         OuVpsKXFjFsqyt8oIn/WbOA9oc1ulXyLG1iOKSfKTbtYKNGtyRhQybLg2U6/WdmLtN59
         eawFUyL7qVH2bWE1IBjksTUxYfPXkPHvnwA6sf06Vpp1ouF2Vf6spk9CuO3bMdBJ1OXw
         uXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kRmAPGwQXO+tCQzgAIz/+MxdpLOLdUGFrnqf04p6lc=;
        b=CRloVEZ5r9CvKDCr1g587pXJGgSqcR03HROCbkmctNAMJ6GpLDL4L5BCTJamaG4aZI
         4JYRT/GEIxwE/dR1GrPWHIJS/CWVMTLqrXjKrT/QG+LnloM9xjItRbq4kd3jcnarppMw
         qH6VBWxCJs2nxb7JvuuhhJO0JaQuV4idiJ2cHfbC8cJmAdBwg9ETpy3sFpq+jXJY6jHf
         vMEy45GBAB2DUNWQqitwF70uWumPiwuzStFI7rDrqjqJhOdAG19lKv6S4UznEUYXzdFs
         z1J1UXSGHKp9Yim/kijZEGUcuvAvFRep2KDmaZdSS2aHZelwk8GVNK84K9eBrzIbfGhY
         TU+g==
X-Gm-Message-State: AO0yUKWIyc48sNReIrQ6qTGM+46titHpMK2KgZKbuaRzOz9X7epaVObE
        1Je0KrVv1wYitX+yE+O8XqD10w==
X-Google-Smtp-Source: AK7set98xCRgixr2FUHfjzR8eq4vP7HzQF0eRb4HHjomtotU6ysixTKHdkPQimI/grPPwzDlU9ZKlQ==
X-Received: by 2002:a05:6a20:7f8e:b0:c7:7afa:5016 with SMTP id d14-20020a056a207f8e00b000c77afa5016mr3517083pzj.9.1677094979855;
        Wed, 22 Feb 2023 11:42:59 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p13-20020a63fe0d000000b00499a90cce5bsm5423599pgh.50.2023.02.22.11.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 11:42:59 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:42:55 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 7/7] KVM: x86/mmu: Merge all handle_changed_pte*
 functions.
Message-ID: <Y/ZwP18nw/PIHGsK@google.com>
References: <20230211014626.3659152-1-vipinsh@google.com>
 <20230211014626.3659152-8-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211014626.3659152-8-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 05:46:26PM -0800, Vipin Sharma wrote:
> __handle_changed_pte() and handle_changed_spte_acc_track() are always
> used together. Merge these two functions and name the new function

nit: State what the patch does first.

> handle_changed_pte(). Remove the existing handle_changed_pte() function
> which just calls __handle_changed_pte and
> handle_changed_spte_acc_track().

s/_pte/_spte/

> 
> This converges SPTEs change handling code to a single place.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Nice cleanup! Commit message nits aside,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++---------------------------
>  1 file changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 0c031319e901..67538ec48ce5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -334,17 +334,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  				u64 old_spte, u64 new_spte, int level,
>  				bool shared);
>  
> -static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
> -{
> -	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
> -		return;
> -
> -	if (is_accessed_spte(old_spte) &&
> -	    (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
> -	     spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
> -		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> -}
> -
>  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, +1);
> @@ -487,7 +476,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  }
>  
>  /**
> - * __handle_changed_spte - handle bookkeeping associated with an SPTE change
> + * handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
>   * @as_id: the address space of the paging structure the SPTE was a part of
>   * @gfn: the base GFN that was mapped by the SPTE
> @@ -501,9 +490,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   * Handle bookkeeping that might result from the modification of a SPTE.
>   * This function must be called for all TDP SPTE modifications.
>   */
> -static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				  u64 old_spte, u64 new_spte, int level,
> -				  bool shared)
> +static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> +				u64 old_spte, u64 new_spte, int level,
> +				bool shared)
>  {
>  	bool was_present = is_shadow_present_pte(old_spte);
>  	bool is_present = is_shadow_present_pte(new_spte);
> @@ -587,15 +576,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	if (was_present && !was_leaf &&
>  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> -}
>  
> -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				u64 old_spte, u64 new_spte, int level,
> -				bool shared)
> -{
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> -			      shared);
> -	handle_changed_spte_acc_track(old_spte, new_spte, level);
> +	if (was_leaf && is_accessed_spte(old_spte) &&
> +	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
> +		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
>  }
>  
>  /*
> @@ -638,9 +622,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
>  		return -EBUSY;
>  
> -	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			      new_spte, iter->level, true);
> -	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> +	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> +			    new_spte, iter->level, true);
>  
>  	return 0;
>  }
> @@ -705,8 +688,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  
>  	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
>  
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> -	handle_changed_spte_acc_track(old_spte, new_spte, level);
> +	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
>  	return old_spte;
>  }
>  
> @@ -1276,7 +1258,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  	 * Note, when changing a read-only SPTE, it's not strictly necessary to
>  	 * zero the SPTE before setting the new PFN, but doing so preserves the
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
> -	 * See __handle_changed_spte().
> +	 * See handle_changed_spte().
>  	 */
>  	tdp_mmu_iter_set_spte(kvm, iter, 0);
>  
> @@ -1301,7 +1283,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	/*
>  	 * No need to handle the remote TLB flush under RCU protection, the
>  	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> -	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> +	 * shadow page. See the WARN on pfn_changed in handle_changed_spte().
>  	 */
>  	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
>  }
> -- 
> 2.39.1.581.gbfd45094c4-goog
> 
