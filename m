Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C79580831
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiGYX2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiGYX2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:28:13 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F7C2657B
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:28:11 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so11696528pgs.3
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7wi8bg/Mx00eJP/7DMQWdUzovW7ROgUSLVQ3KoCFZm4=;
        b=UVsf1+wMyBp60ANtjUt1J5fZ6B3ElwNqFoI/cgtNjF7hWuIlgK2XLGHWcL64SsuJzG
         irJXvkDmvEDZN29vOjDrOwEuSidNqcCXkCMz+jGzHJVx0ZhJcvK5Is3urL6dL8BEy9Tx
         Gdns9uPmDPtK64XjWsd8z/uBqqGU1A2dE4KxBDq6YzdhLKAPtE8Vle91IUHZBuHMDFnA
         8mQU6E3pzALA8GlQyYiWBEQ1VRAG6kslkBoTYuEktMW/r0q3B/l2po3Fb+bO6K7SWmv9
         +qqwjBdkB/V5kayThphX8iVJVm3bpUbyo/PsFAmnOy1olrPL0HJGulnS86rP0YIJkuic
         3ZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7wi8bg/Mx00eJP/7DMQWdUzovW7ROgUSLVQ3KoCFZm4=;
        b=07vw4xnF2sd2Bl88M6rcPkwm4Hdt94MyQ708U7XswuxvnHzebJLwhh7FJBArxE8j1r
         zbaOpBdb/zjz6+UcuJtGgG+Ywxcl9y3LUuRc4ck7omY6BcH+xCP+VOYcQunRIKmcw1b+
         PZeiztS8URf3CtiiNtHnff9PTpVhly9npJLzD5pqCMWE7w08xHBqkPUlaWouelTKlTQR
         GRnfOYVJgv7szTGBBheaBAqf3Lgy3+2+wEK4ehW3anX8NLWxwzyvxn1kcOPMwlZh4NQW
         mmf5UrH4bGoc9hoeaDmD3m8HkNDopu4qAZk2rdkocfyqQFFIirCN9rAH1A/4bq2cH6WJ
         m91A==
X-Gm-Message-State: AJIora/uYMCGx+/nONpBfTHAhRVP/CodleO/VQ0VNu4WoCqLVNjsflfI
        q8H8YtpcGRvL2ne3vRjrJrh5uFsoPv0JfQ==
X-Google-Smtp-Source: AGRyM1uAJt/bbD/gUxdlkUSc8KuXjNiL1jGe++3RkRQXHto/BwsierZwh3fpTMAhcSd5jCJJ0aKEEg==
X-Received: by 2002:a65:524a:0:b0:41a:996c:a2c6 with SMTP id q10-20020a65524a000000b0041a996ca2c6mr12687936pgp.528.1658791691219;
        Mon, 25 Jul 2022 16:28:11 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902d2cb00b0016bdf2220desm9835181plc.263.2022.07.25.16.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:28:10 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:28:05 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 6/6] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <Yt8nBa00jQyoqFsQ@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-7-seanjc@google.com>
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

On Sat, Jul 23, 2022 at 01:23:25AM +0000, Sean Christopherson wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> Explicitly check if a NX huge page is disallowed when determining if a page
> fault needs to be forced to use a smaller sized page. KVM incorrectly
> assumes that the NX huge page mitigation is the only scenario where KVM
> will create a shadow page instead of a huge page. Any scenario that causes
> KVM to zap leaf SPTEs may result in having a SP that can be made huge
> without violating the NX huge page mitigation. E.g. disabling of dirty
> logging, zapping from mmu_notifier due to page migration, guest MTRR
> changes that affect the viability of a huge page, etc...
> 
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> [sean: add barrier comments, use spte_to_sp()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c     | 17 +++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c |  6 ++++++
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ed3cfb31853b..97980528bf4a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3092,6 +3092,19 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	    cur_level == fault->goal_level &&
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte)) {
> +		u64 page_mask;
> +
> +		/*
> +		 * Ensure nx_huge_page_disallowed is read after checking for a
> +		 * present shadow page.  A different vCPU may be concurrently
> +		 * installing the shadow page if mmu_lock is held for read.
> +		 * Pairs with the smp_wmb() in kvm_tdp_mmu_map().
> +		 */
> +		smp_rmb();
> +
> +		if (!spte_to_sp(spte)->nx_huge_page_disallowed)
> +			return;
> +
>  		/*
>  		 * A small SPTE exists for this pfn, but FNAME(fetch)
>  		 * and __direct_map would like to create a large PTE
> @@ -3099,8 +3112,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  		 * patching back for them into pfn the next 9 bits of
>  		 * the address.
>  		 */
> -		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> -				KVM_PAGES_PER_HPAGE(cur_level - 1);
> +		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> +			    KVM_PAGES_PER_HPAGE(cur_level - 1);
>  		fault->pfn |= fault->gfn & page_mask;
>  		fault->goal_level--;
>  	}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index fea22dc481a0..313092d4931a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1194,6 +1194,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			tdp_mmu_init_child_sp(sp, &iter);
>  
>  			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> +			/*
> +			 * Ensure nx_huge_page_disallowed is visible before the
> +			 * SP is marked present, as mmu_lock is held for read.
> +			 * Pairs with the smp_rmb() in disallowed_hugepage_adjust().
> +			 */
> +			smp_wmb();
>  
>  			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>  				tdp_mmu_free_sp(sp);
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
