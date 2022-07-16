Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CE4576C1A
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 07:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiGPFx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jul 2022 01:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiGPFxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jul 2022 01:53:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D97665C6
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 22:53:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y15so99288plp.10
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 22:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k4ReJi3gLhxX1c6bDpJ9BCH4j4KqMwkRvv91qaJAxJY=;
        b=jDsNDTwTJLpeMwp6Rv+gmgHzKlrJzAOAR1jaFqVkv/rcdSdDiuYxpH8FWU30NJ9/eZ
         MvZDnQfR641Oppryi7W3Ndrem1mmobAwtU7lPUrjCm0USaB+tjP0+Jmh20WPB4Ej+8UV
         tUlsHe+GPn1OfGvCJEd5Ci1vxm3kXEqkIlrao7AcPYwjgvsRQ8X02wMmxzEKOXh0p9hs
         3XlYjpLrN5ObmxalmOJuOsaKCY8kcQnuvJhJ5dSqNKP/FPy31VrkxsxXP1+VGpI8R5Hg
         0d+IzewWtjNVh4PZjiOd4SEJFQE3PIyt/Ncc6YscFCz7tUzq77cMcUQ61jWXVUrbS4Xf
         /2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4ReJi3gLhxX1c6bDpJ9BCH4j4KqMwkRvv91qaJAxJY=;
        b=Ru2lZNCexKt2zh/TXL+QBygE2MZcYyBGyvpcMgjnhhfbdqXHaXanvNkhZdAxVvqX2M
         KscNQukWELzI8DDflmuK5GUWB4CknJ0Yaqla0+DSdUWyPd/90UXC5HXdy5roh7W0WSU0
         EPCqpOu9Q56FY69O/0pCDr6JdHpAzaCLzhXbhfBxuxNXpAsRWGXaG0ZvJsJDbzwreSFg
         WylbdEUJzIU6qlCFadKi6GzBj8g2rxxmqsa7tlOBZlYwsTII16COIkpXajK4QlHozVZr
         ixre/9ZEkGuNAhsWtZl3OURZiD3Vck/9hIp5TOGEpL2w1g9SQ6eLUuSFdBgDkYG3LZXT
         FeZA==
X-Gm-Message-State: AJIora8ZdtUfFYGXWyUkH+o8vNj23hZgof8lEYiceY/WzwOC3QOVwfiq
        yMrznRsTnnxA0mtuWPF6Uzal/Q==
X-Google-Smtp-Source: AGRyM1s8pOZhah+AKb86PkWmI7YeI9laP1eieASnKKPv2eD4EV+em/W618k6pZSnGTD8iqtPlRdJ+Q==
X-Received: by 2002:a17:902:d50e:b0:16c:1664:81e5 with SMTP id b14-20020a170902d50e00b0016c166481e5mr17437272plg.149.1657950831675;
        Fri, 15 Jul 2022 22:53:51 -0700 (PDT)
Received: from google.com (59.39.145.34.bc.googleusercontent.com. [34.145.39.59])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902a38900b0016c0c82e85csm4587320pla.75.2022.07.15.22.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 22:53:50 -0700 (PDT)
Date:   Sat, 16 Jul 2022 05:53:46 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86/mmu: Don't require refcounted "struct page"
 to create huge SPTEs
Message-ID: <YtJSalFfPPoQs4Dj@google.com>
References: <20220715232107.3775620-1-seanjc@google.com>
 <20220715232107.3775620-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715232107.3775620-2-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022, Sean Christopherson wrote:
> Drop the requirement that a pfn be backed by a refcounted, compound or
> or ZONE_DEVICE, struct page, and instead rely solely on the host page
> tables to identify huge pages.  The PageCompound() check is a remnant of
> an old implementation that identified (well, attempt to identify) huge
> pages without walking the host page tables.  The ZONE_DEVICE check was
> added as an exception to the PageCompound() requirement.  In other words,
> neither check is actually a hard requirement, if the primary has a pfn
> backed with a huge page, then KVM can back the pfn with a huge page
> regardless of the backing store.
> 
> Dropping the @pfn parameter will also allow KVM to query the max host
> mapping level without having to first get the pfn, which is advantageous
> for use outside of the page fault path where KVM wants to take action if
> and only if a page can be mapped huge, i.e. avoids the pfn lookup for
> gfns that can't be backed with a huge page.

Our of curiosity, when host maps huge pages under VMA with VM_PFNMAP,
they are basically out of the control of MM (I presume). So, when
drivers of those pages remove them from host page table, do we (KVM) get
mmu_notifiers?

> 
> Cc: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 23 +++++------------------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  8 +-------
>  3 files changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 52664c3caaab..bebff1d5acd4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2919,11 +2919,10 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
>  	__direct_pte_prefetch(vcpu, sp, sptep);
>  }
>  
> -static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>  				  const struct kvm_memory_slot *slot)
>  {
>  	int level = PG_LEVEL_4K;
> -	struct page *page;
>  	unsigned long hva;
>  	unsigned long flags;
>  	pgd_t pgd;
> @@ -2931,17 +2930,6 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	pud_t pud;
>  	pmd_t pmd;
>  
> -	/*
> -	 * Note, @slot must be non-NULL, i.e. the caller is responsible for
> -	 * ensuring @pfn isn't garbage and is backed by a memslot.
> -	 */
> -	page = kvm_pfn_to_refcounted_page(pfn);
> -	if (!page)
> -		return PG_LEVEL_4K;
> -
> -	if (!PageCompound(page) && !kvm_is_zone_device_page(page))
> -		return PG_LEVEL_4K;
> -
>  	/*
>  	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
>  	 * is not solely for performance, it's also necessary to avoid the
> @@ -2994,7 +2982,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn,
> -			      kvm_pfn_t pfn, int max_level)
> +			      int max_level)
>  {
>  	struct kvm_lpage_info *linfo;
>  	int host_level;
> @@ -3009,7 +2997,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
> +	host_level = host_pfn_mapping_level(kvm, gfn, slot);
>  	return min(host_level, max_level);
>  }
>  
> @@ -3034,8 +3022,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * level, which will be used to do precise, accurate accounting.
>  	 */
>  	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
> -						     fault->gfn, fault->pfn,
> -						     fault->max_level);
> +						     fault->gfn, fault->max_level);
>  	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>  		return;
>  
> @@ -6406,7 +6393,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 */
>  		if (sp->role.direct &&
>  		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
> -							       pfn, PG_LEVEL_NUM)) {
> +							       PG_LEVEL_NUM)) {
>  			pte_list_remove(kvm, rmap_head, sptep);
>  
>  			if (kvm_available_flush_tlb_with_range())
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ae2d660e2dab..582def531d4d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -309,7 +309,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn,
> -			      kvm_pfn_t pfn, int max_level);
> +			      int max_level);
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f3a430d64975..d75d93edc40a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1733,7 +1733,6 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  	gfn_t end = start + slot->npages;
>  	struct tdp_iter iter;
>  	int max_mapping_level;
> -	kvm_pfn_t pfn;
>  
>  	rcu_read_lock();
>  
> @@ -1745,13 +1744,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> -		/*
> -		 * This is a leaf SPTE. Check if the PFN it maps can
> -		 * be mapped at a higher level.
> -		 */
> -		pfn = spte_to_pfn(iter.old_spte);
>  		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> -				iter.gfn, pfn, PG_LEVEL_NUM);
> +							      iter.gfn, PG_LEVEL_NUM);
>  
>  		WARN_ON(max_mapping_level < iter.level);
>  
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
