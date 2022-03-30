Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68434EB789
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 02:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbiC3Auf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 20:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241408AbiC3Auc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 20:50:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB536253
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:48:47 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b15so17395777pfm.5
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5NrRZS8TLku6dnHD8p5dRwj1dDry3kfXuEtH+RzRjG8=;
        b=H3ztMl5n1iMDL5Th1/k1tpa46AW6/IIuIKeviJuiL9v6BzU3L4YRmOQbnDqKppJogo
         dcmlMZtaS5WZaVVhHwed0GvB/Ir+ygUfbP7b7vy7o1Z2BgyhzVxes7iE86W1TmESnjer
         nWwLrk4Q2bZtilKN84F+NtZ4NKfeRlUiYSFbVOHl2OLMJ/sfWfukK/BEPtqPXeLASRVQ
         Chy29JSiZQRL7nPVGpL6wBdE22Vel+2otXBylMPT8gow3KdoSdPHV4J1wa7k5XJKY2HC
         Hrp3dOK8Ug4gOK7xVcs2xeG1xTso27wWX6I59B7pJcEPqYrzdIXYRIc3DzxyqVy3RZr+
         JKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5NrRZS8TLku6dnHD8p5dRwj1dDry3kfXuEtH+RzRjG8=;
        b=cBblaqMR9qp6pjLzILFWKUS0h+i1I18xf8Qxd4sxSfVZqLCg0vgBLkOcOgVVBat/vj
         aXT6XPz1TMkFtwjW0L191eTfo6AaE8D1IwArvWxou/WSOo1AEx5IZYYNlHf+24y1/wkX
         KAtF+WfaQzPY/uS40RJX0d4VYJcz4kDkg0mdy/1P4+2JoRV262kCvkof45iMYmAPpFjn
         zGvzKCuLiv7taymBe33/fiM3lH0N+GVnJRFmIZQmFwzSsAX8QngxjLI9aPrEe5wdC+o9
         SlwE+SBaHdZr/LZyRt8Q6eZiy42GsJSMPHew++cPWGEOdMtwKIw+E3B3AkgTyezf0vVD
         Ew/w==
X-Gm-Message-State: AOAM531HCl2KCfC7K2KHJZ9HNI679DPNvcomR81xZXcJE0B++1vuA0K2
        pPbF9QCRuROd9MI66VidQkaMTg==
X-Google-Smtp-Source: ABdhPJxLDZ+doxeUUSujvmXhvd9NA1e5Kwd03cSeFPP8MNLZoF6HJFWoYxg95o4jFUG7UUw9XOu+kQ==
X-Received: by 2002:a63:1f55:0:b0:382:65eb:3073 with SMTP id q21-20020a631f55000000b0038265eb3073mr4043707pgm.624.1648601326693;
        Tue, 29 Mar 2022 17:48:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004fb28fafc4csm15271435pfk.97.2022.03.29.17.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:48:46 -0700 (PDT)
Date:   Wed, 30 Mar 2022 00:48:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: memcg: count KVM page table pages used by KVM in
 memcg pagetable stats
Message-ID: <YkOo6iM9YUACsNGF@google.com>
References: <20220311001252.195690-1-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311001252.195690-1-yosryahmed@google.com>
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

On Fri, Mar 11, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM for page tables in pagetable memcg stats in
> memory.stat.

Why?  Is it problematic to count these as kernel memory as opposed to page tables?
What is gained/lost by tracking these as page table allocations?  E.g. won't this
pollute the information about the host page tables for the userpace process?

When you asked about stats, I thought you meant KVM stats :-)

> Most pages used for KVM page tables come from the mmu_shadow_page_cache,
> in addition to a few allocations in __kvm_mmu_create() and
> mmu_alloc_special_roots().
> 
> For allocations from the mmu_shadow_page_cache, the pages are counted as
> pagetables when they are actually used by KVM (when
> mmu_memory_cache_alloc_obj() is called), rather than when they are
> allocated in the cache itself. In other words, pages sitting in the
> cache are not counted as pagetables (they are still accounted as kernel
> memory).
> 
> The reason for this is to avoid the complexity and confusion of
> incrementing the stats in the cache layer, while decerementing them
> by the cache users when they are being freed (pages are freed directly
> and not returned to the cache).
> For the sake of simplicity, the stats are incremented and decremented by
> the users of the cache when they get the page and when they free it.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 +++++++
>  arch/x86/kvm/mmu/mmu.c          | 19 +++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++++
>  virt/kvm/kvm_main.c             | 17 +++++++++++++++++
>  4 files changed, 47 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72e80178ffc..4a1dda2f56e1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -458,6 +458,13 @@ struct kvm_mmu {
>  	*/
>  	u32 pkru_mask;
>  
> +	/*
> +	 * After a page is allocated for any of these roots,
> +	 * increment per-memcg pagetable stats by calling:
> +	 * inc_lruvec_page_state(page, NR_PAGETABLE)
> +	 * Before the page is freed, decrement the stats by calling:
> +	 * dec_lruvec_page_state(page, NR_PAGETABLE).
> +	 */
>  	u64 *pae_root;
>  	u64 *pml4_root;
>  	u64 *pml5_root;

Eh, I would much prefer we don't bother counting these.  They're barely page
tables, more like necessary evils.  And hopefully they'll be gone soon[*].

[*] https://lore.kernel.org/all/20220329153604.507475-1-jiangshanlai@gmail.com

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3b8da8b0745e..5f87e1b0da91 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1673,7 +1673,10 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
>  	hlist_del(&sp->hash_link);
>  	list_del(&sp->link);
> +
> +	dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);

I would strongly prefer to add new helpers to combine this accounting with KVM's
existing accounting.  E.g. for the legacy (not tdp_mmu.c) MMU code

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..c2cb642157cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1668,6 +1668,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
        percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }

+static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+       kvm_mod_used_mmu_pages(kvm, 1);
+       inc_lruvec_page_state(..., NR_PAGETABLE);
+}
+
+static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+       kvm_mod_used_mmu_pages(kvm, -1);
+       dec_lruvec_page_state(..., NR_PAGETABLE);
+}
+
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
        MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
@@ -1723,7 +1735,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
         */
        sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
        list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-       kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+       kvm_account_mmu_page(vcpu->kvm, sp);
        return sp;
 }

@@ -2339,7 +2351,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
                        list_add(&sp->link, invalid_list);
                else
                        list_move(&sp->link, invalid_list);
-               kvm_mod_used_mmu_pages(kvm, -1);
+               kvm_unaccount_mmu_page(kvm, sp);
        } else {
                /*
                 * Remove the active root from the active page list, the root


>  	free_page((unsigned long)sp->spt);
> +

There's a lot of spurious whitespace change in this patch.

>  	if (!sp->role.direct)
>  		free_page((unsigned long)sp->gfns);
>  	kmem_cache_free(mmu_page_header_cache, sp);
> @@ -1711,7 +1714,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +

More whitespace, though it should just naturally go away.

>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	inc_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
> +
>  	if (!direct)
>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> @@ -3602,6 +3608,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	mmu->pml4_root = pml4_root;
>  	mmu->pml5_root = pml5_root;
>  
> +	/* Update per-memcg pagetable stats */
> +	inc_lruvec_page_state(virt_to_page(pae_root), NR_PAGETABLE);
> +	inc_lruvec_page_state(virt_to_page(pml4_root), NR_PAGETABLE);
> +	inc_lruvec_page_state(virt_to_page(pml5_root), NR_PAGETABLE);
>  	return 0;
>  
>  #ifdef CONFIG_X86_64
> @@ -5554,6 +5564,12 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>  {
>  	if (!tdp_enabled && mmu->pae_root)
>  		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
> +
> +	/* Update per-memcg pagetable stats */
> +	dec_lruvec_page_state(virt_to_page(mmu->pae_root), NR_PAGETABLE);
> +	dec_lruvec_page_state(virt_to_page(mmu->pml4_root), NR_PAGETABLE);
> +	dec_lruvec_page_state(virt_to_page(mmu->pml5_root), NR_PAGETABLE);
> +
>  	free_page((unsigned long)mmu->pae_root);
>  	free_page((unsigned long)mmu->pml4_root);
>  	free_page((unsigned long)mmu->pml5_root);
> @@ -5591,6 +5607,9 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  	if (!page)
>  		return -ENOMEM;
>  
> +	/* Update per-memcg pagetable stats */
> +	inc_lruvec_page_state(page, NR_PAGETABLE);
> +
>  	mmu->pae_root = page_address(page);
>  
>  	/*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index af60922906ef..ce8930fd0835 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -64,6 +64,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> +	dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);

I'd prefer to do this in tdp_mmu_{,un}link_sp(), it saves having to add calls in
all paths that allocate TDP MMU pages.
