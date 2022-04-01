Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF64EE5A0
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 03:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243707AbiDABUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 21:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiDABUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 21:20:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9524BF9
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:18:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f10so1145851plr.6
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aMuLN31fNY1UMpirCc6Bdm0SR1Y9IKc76mhcsohNuMU=;
        b=sD44gl2AzVQt68GXn9rBDBzarHscR8FRKGlfQtI14+VhDjlU8jTGA3erInHfx52aOP
         73cNO8rOwIlVl1/5OFJfuCg8gQetqUnCORG6QwDVAC875FFIPtD7ZBXC/JYljuQSQY6I
         MX8PJNjcMcgR5ZriH9b4Nh3gcLBdn0CPZJX+ocvlxi0bNUb1yz4wD866K4va5QEi/BQN
         u+wp6SAh1mEFiiXojNEVwimZaR2VNqpz8bKM/ZNfrdm3cGyW/wviSzzPU81L4vLAqydA
         YE1iNGJq3tMX9G/0mAAz3q2UWWAJL2gLDTPfw3dJO1utm+L3F5BRvnXOymmlbqpsGhgU
         2OHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aMuLN31fNY1UMpirCc6Bdm0SR1Y9IKc76mhcsohNuMU=;
        b=bx1Pdhgw5BOVgsRWUIwIOAsb9hHHYhbWyzal0Qxxcv/MiUAIqP/wjwy+Vs9+/BL6rK
         NZUp+i4gwx/2pLuUeUX90tGP7CBJaHA6F20hy7YvKbQ+NjRtrpXDB/xmiVppzeikwUgY
         3cfTPZts73V5X3WAERz8zMXvAPLpdNSM/O8PE6sKiZv0tXDI4M/x1RNJ41t12Smxb2RO
         ExIVUO5TkCRG5dZD8ONegyYWZ31p2J0DFRu8ta6mqJrh4cO+WcD01tczDAs0SOEFDkp4
         tv+9puFsVv2kElKZ1rzy6rlKJ0UW9MDkkCAsznHP5NdmbN5D1YjciGxT9TCLEs0dNnJX
         aL7Q==
X-Gm-Message-State: AOAM532qrGF+kmBoG6UAVJG2UJMfMeCVKYsSgcymT1oeqv0peTPhs8mg
        tBFBIKWrPJQyw6G0pG4YpZ7SrQ==
X-Google-Smtp-Source: ABdhPJyg769LiCZCkzAMrZhxtwWq/dzP7uh67D7W1WE7wVkJjqnqm7mGX0yumwPc2AaIQpnfFu4WNQ==
X-Received: by 2002:a17:903:1c2:b0:154:5edf:56d3 with SMTP id e2-20020a17090301c200b001545edf56d3mr8260992plh.10.1648775906614;
        Thu, 31 Mar 2022 18:18:26 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000cd000b004fadb6f0290sm765442pfv.11.2022.03.31.18.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 18:18:26 -0700 (PDT)
Date:   Fri, 1 Apr 2022 01:18:22 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 3/4] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YkZS3uBTmRldql+M@google.com>
References: <20220323184915.1335049-1-mizhang@google.com>
 <20220323184915.1335049-5-mizhang@google.com>
 <YkOHDeh8JgWc8iFb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkOHDeh8JgWc8iFb@google.com>
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

On Tue, Mar 29, 2022, Sean Christopherson wrote:
> +Yosry
> 
> On Wed, Mar 23, 2022, Mingwei Zhang wrote:
> > Add extra check to specify the case of nx hugepage and allow KVM to
> > reconstruct large mapping after dirty logging is disabled. Existing code
> > works only for nx hugepage but the condition is too general in that does
> > not consider other usage case (such as dirty logging). Note that
> > when dirty logging is disabled, KVM calls kvm_mmu_zap_collapsible_sptes()
> > which only zaps leaf SPTEs.
> 
> This opening is very, very confusing.  A big part of the confusion is due to poor
> naming in KVM, where kvm_mmu_page.lpage_disallowed really should be
> nx_huge_page_disalowed.  Enabling dirty logging also disables huge pages, but that
> goes through the memslot's disallow_lpage.  Reading through this paragraph, and
> looking at the code, it sounds like disallowed_hugepage_adjust() is explicitly
> checking if a page is disallowed due to dirty logging, which is not the case.
> 
> I'd prefer the changelog lead with the bug it's fixing and only briefly mention
> dirty logging as a scenario where KVM can end up with shadow pages without child
> SPTEs.  Such scenarios can also happen with mmu_notifier calls, etc...
> 
> E.g.
> 
>   Explicitly check if a NX huge page is disallowed when determining if a page
>   fault needs to be forced to use a smaller sized page.  KVM incorrectly
>   assumes that the NX huge page mitigation is the only scenario where KVM
>   will create a shadow page instead of a huge page.  Any scenario that causes
>   KVM to zap leaf SPTEs may result in having a SP that can be made huge
>   without violating the NX huge page mitigation.  E.g. disabling of dirty
>   logging, zapping from mmu_notifier due to page migration, guest MTRR changes
>   that affect the viability of a huge page, etc...
> 
Thanks for the correction. yeah, I hit this bug when I rebase the
internal demand paging. Other than that, the only user that will trigger
this issue is dirty logging. So this would be the motivation.

> > Moreover, existing code assumes that a present PMD or PUD indicates that
> > there exist 'smaller SPTEs' under the paging structure. This assumption may
> > no be true if KVM zaps only leafs in MMU.
> > 
> > Missing the check causes KVM incorrectly regards the faulting page as a NX
> > huge page and refuse to map it at desired level. And this leads to back
> > performance issue in shadow mmu and potentially in TDP mmu as well.
> > 
> > Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> > Cc: stable@vger.kernel.org
I remove the Cc to stable, since this patch alone may have a race in TDP
mmu. So will include both patches you attached in the 2nd version.

> 
> I vote to keep the Fixes tag, but drop the Cc: stable@ and NAK any MANUALSEL/AUTOSEL
> for backporting this to stable trees.  Yes, it's a bug, but the NX huge page zapping
> kthread will (eventually) reclaim the lost performance.  On the flip side, if there's
> an edge case we mess up (see below), then we've introduced a far worse bug.
> 
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5628d0ba637e..d9b2001d8217 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2919,6 +2919,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> >  	    cur_level == fault->goal_level &&
> >  	    is_shadow_present_pte(spte) &&
> >  	    !is_large_pte(spte)) {
> > +		struct kvm_mmu_page *sp;
> > +		u64 page_mask;
> > +		/*
> > +		 * When nx hugepage flag is not set, there is no reason to go
> > +		 * down to another level. This helps KVM re-generate large
> > +		 * mappings after dirty logging disabled.
> > +		 */
> 
> Honestly, I'd just omit the comment.  Again, IMO the blurb about dirty logging
> does more harm than good because it makes it sound like this is somehow unique to
> dirty logging, which it is not.  Lack of a check was really just a simple goof.
> 
> > +		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > +		if (!sp->lpage_disallowed)
> 
> This is unsafe for the TDP MMU.  If mmu_lock is held for read, tdp_mmu_link_sp()
> could be in the process of creating the shadow page for a different fault.
> Critically, tdp_mmu_link_sp() sets lpage_disallowed _after_ installing the SPTE.
> Thus this code could see the present shadow page, with the correct old_spte (and
> thus succeed its eventual tdp_mmu_set_spte_atomic()), but with the wrong
> lpage_disallowed.
> 
> To fix, tdp_mmu_link_sp() needs to tag the shadow page with lpage_disallowed before
> setting the SPTE, and also needs appropriate memory barriers.  It's a bit messy at
> first glance, but actually presents an opportunity to further improve TDP MMU
> performance.  tdp_mmu_pages can be turned into a counter, at which point the
> link/unlock paths don't need to acquire the spinlock except for NX huge page case.
> 
> Yosry (Cc'd) is also looking into adding stats for the number of page table pages
> consumed by KVM, turning tdp_mmu_pages into a counter would trivialize that for
> the TDP MMU (the stats for the TDP MMU and old MMU are best kept separated, see
> the details in the attached patch).
> 
> Unlike the legacy MMU, the TDP MMU never re-links existing shadow pages.  This means
> it doesn't need to worry about the scenario where lpage_disallowed was already set.
> So, setting the flag prior to the SPTE is trivial and doesn't need to be unwound.
> 
> Disclaimer: attached patches are lightly tested.

ack.
> 
> On top, this patch would need to add barriers, e.g.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5cb845fae56e..0bf85bf3da64 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2896,6 +2896,12 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>             cur_level == fault->goal_level &&
>             is_shadow_present_pte(spte) &&
>             !is_large_pte(spte)) {
> +               /* comment goes here. */
> +               smp_rmb();
> +
> +               if (!sp->lpage_disallowed)
> +                       return;
> +
>                 /*
>                  * A small SPTE exists for this pfn, but FNAME(fetch)
>                  * and __direct_map would like to create a large PTE
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5ca78a89d8ed..9a0bc19179b0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1207,6 +1207,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         tdp_mmu_init_child_sp(sp, &iter);
> 
>                         sp->lpage_disallowed = account_nx;
> +                       /* comment goes here. */
> +                       smp_wmb();
> 
>                         if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>                                 tdp_mmu_free_sp(sp);
> 

> From 80d8bbd4a92faabc65cc5047c6b8ff1468cda1fa Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 29 Mar 2022 13:25:34 -0700
> Subject: [PATCH 1/2] KVM: x86/mmu: Set lpage_disallowed in TDP MMU before
>  setting SPTE
> 
> Set lpage_disallowed in TDP MMU shadow pages before making the SP visible
> to other readers, i.e. before setting its SPTE.  This will allow KVM to
> query lpage_disallowed when determining if a shadow page can be replaced
> by a NX huge page without violating the rules of the mitigation.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 20 ++++++++++++--------
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..5cb845fae56e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -812,14 +812,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	kvm_mmu_gfn_disallow_lpage(slot, gfn);
>  }
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	if (sp->lpage_disallowed)
> -		return;
> -
>  	++kvm->stat.nx_lpage_splits;
>  	list_add_tail(&sp->lpage_disallowed_link,
>  		      &kvm->arch.lpage_disallowed_mmu_pages);
> +}
> +
> +static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	if (sp->lpage_disallowed)
> +		return;
> +
> +	__account_huge_nx_page(kvm, sp);
> +
>  	sp->lpage_disallowed = true;
>  }
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1bff453f7cbe..4a0087efa1e3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -168,7 +168,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b3b6426725d4..f05423545e6d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1122,16 +1122,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @sp: The new TDP page table to install.
> - * @account_nx: True if this page table is being installed to split a
> - *              non-executable huge page.
>   * @shared: This operation is running under the MMU lock in read mode.
>   *
>   * Returns: 0 if the new page table was installed. Non-0 if the page table
>   *          could not be installed (e.g. the atomic compare-exchange failed).
>   */
>  static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> -			   struct kvm_mmu_page *sp, bool account_nx,
> -			   bool shared)
> +			   struct kvm_mmu_page *sp, bool shared)
>  {
>  	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
>  	int ret = 0;
> @@ -1146,8 +1143,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	if (account_nx)
> -		account_huge_nx_page(kvm, sp);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
>  	return 0;
> @@ -1160,6 +1155,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	struct kvm *kvm = vcpu->kvm;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
>  	int ret;
> @@ -1210,10 +1206,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			sp = tdp_mmu_alloc_sp(vcpu);
>  			tdp_mmu_init_child_sp(sp, &iter);
>  
> -			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> +			sp->lpage_disallowed = account_nx;
> +
> +			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>  				tdp_mmu_free_sp(sp);
>  				break;
>  			}
> +
> +			if (account_nx) {
> +				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +				__account_huge_nx_page(kvm, sp);
> +				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +			}
>  		}
>  	}
>  
> @@ -1501,7 +1505,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * correctness standpoint since the translation will be the same either
>  	 * way.
>  	 */
> -	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
> +	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
>  	if (ret)
>  		goto out;
>  
> 
> base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
> -- 
> 2.35.1.1021.g381101b075-goog
> 

> From 18eaf3b86dfd01a5b58d9755ba76fe8ff80702ab Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 29 Mar 2022 14:41:40 -0700
> Subject: [PATCH 2/2] KVM: x86/mmu: Track the number of TDP MMU pages, but not
>  the actual pages
> 
> Track the number of TDP MMU "shadow" pages instead of tracking the pages
> hemselves.  With the NX huge page list manipulation moved out of the
> common linking flow, elminating the list-based tracking means the happy
> path of adding a shadow page doesn't need to acquire a spinlock and can
> instead inc/dec an atomic.
> 
> Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
> pages is very, very useful for detecting KVM bugs.
> 
> Tracking the number of pages will also make it trivial to expose the
> counter to userspace as a stat in the future, which may or may not be
> desirable.
> 
> Note, the TDP MMU needs to use a seperate counter (and stat if that ever
> comes to be) from the existing n_used_mmu_pages.  The TDP MMU doesn't
> bother supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES
> (because the TDP MMU consumes so few pages relative to shadow paging),
> and including TDP MMU pages in that counter would break both the shrinker
> and shadow MMUs, e.g. if a VM is using nested TDP.
> 
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++--------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++--------
>  2 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9694dd5e6ccc..d0dd5ed2e209 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1192,6 +1192,9 @@ struct kvm_arch {
>  	 */
>  	bool tdp_mmu_enabled;
>  
> +	/* The number of TDP MMU pages across all roots. */
> +	atomic64_t tdp_mmu_pages;
> +
>  	/*
>  	 * List of struct kvm_mmu_pages being used as roots.
>  	 * All struct kvm_mmu_pages in the list should have
> @@ -1212,18 +1215,10 @@ struct kvm_arch {
>  	 */
>  	struct list_head tdp_mmu_roots;
>  
> -	/*
> -	 * List of struct kvmp_mmu_pages not being used as roots.
> -	 * All struct kvm_mmu_pages in the list should have
> -	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
> -	 */
> -	struct list_head tdp_mmu_pages;
> -
>  	/*
>  	 * Protects accesses to the following fields when the MMU lock
>  	 * is held in read mode:
>  	 *  - tdp_mmu_roots (above)
> -	 *  - tdp_mmu_pages (above)
>  	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
>  	 *  - lpage_disallowed_mmu_pages
>  	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f05423545e6d..5ca78a89d8ed 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -24,7 +24,6 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
> -	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>  	kvm->arch.tdp_mmu_zap_wq =
>  		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
>  
> @@ -51,7 +50,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
> -	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
> +	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  
>  	/*
> @@ -381,14 +380,17 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +
> +	if (!sp->lpage_disallowed)
> +		return;
> +
>  	if (shared)
>  		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	else
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	list_del(&sp->link);
> -	if (sp->lpage_disallowed)
> -		unaccount_huge_nx_page(kvm, sp);
> +	unaccount_huge_nx_page(kvm, sp);
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1141,9 +1143,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
>  
>  	return 0;
>  }
> -- 
> 2.35.1.1021.g381101b075-goog
> 

