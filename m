Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D84CC7D9
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiCCVUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiCCVUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:20:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC55A1275CB
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 13:19:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso8940167pjk.1
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 13:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7n7LtyQ7H3ss+S0f6pd4UBJVO1zZM22YShmG6/aanXc=;
        b=hEEXGqhwD+X9h7IK+ygN6pK7ycJrEH5R2Be0db5wlXY7fZhhCLZM2hkfxCGwHcktkS
         LXIOteK0PTJv30sLXOaDWNxMRgXNc2u42NedG1FkN9mN+glRd+ftDcGRRmfIGdrqKfYm
         /IkFw0eymDM1N9zVNF9W15z98gq71ZRqdn26bN8BQ2Hw3pGOu/py6u5lztQvpMOI0Qlm
         BpgAkJCwJiF4IaR2jRXc9iws6Tda+clIJu8+OBl5tKFUIWeGpcVLXdijS9ZIJrzOVdcZ
         Jp0gwtwyaK/PDOlXcHnzCALJk8a750z/JkbqOjkNfrWwxqnO7yCjcQsayNBOTObwnjq5
         gxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7n7LtyQ7H3ss+S0f6pd4UBJVO1zZM22YShmG6/aanXc=;
        b=qDOOVAMvrgSODvkg0MI0ibSm5trXZXoEYGdm0hXDqSSvNehkkxmUfw3bmpcGTTuLJ3
         RYzaLgIq2HmxPQZmmTFzXUjwGpry5o5RysWKLKXBsygWRdNryAQV0LasQiu/4k3L3MDZ
         eqHtXeb1zIvPWebjVpGUONmQh1sOu1rzJf9YuGzuRIEo9zU0XcuLgJnZVSe31MjWJwTT
         XOjsXr2hpm5fUnG9iVNOOdUGQqDNS3adPaYOxKR8k5Kysz2qE/1jFScthQnb9HSFgR1U
         31t9Uxl0H9BzPvvat/B7SCNQ/YJdC59EMc56t8di/EdcUqxNSZk36KvPfIBBU9SBuKkS
         EU0A==
X-Gm-Message-State: AOAM5319x30kr61vMldyu507bTvqYWR9KUxGHkmyrIEEGJ7InQVssgmk
        HsJu67ApTfJjRcyfEBEpgHjuqQ==
X-Google-Smtp-Source: ABdhPJw/+ASn72tJMaGqjOFSrS6zq3+0tRKvIBpvUaq7S7DZULRk6clBx34Mls9ya6TcUm2oq73gog==
X-Received: by 2002:a17:902:6ac4:b0:149:907d:afdc with SMTP id i4-20020a1709026ac400b00149907dafdcmr38204290plt.59.1646342387836;
        Thu, 03 Mar 2022 13:19:47 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7888c000000b004f3fc6d95casm3643866pfe.20.2022.03.03.13.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:19:47 -0800 (PST)
Date:   Thu, 3 Mar 2022 21:19:43 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 15/28] KVM: x86/mmu: Add dedicated helper to zap TDP
 MMU root shadow page
Message-ID: <YiEw7z9TCQJl+udS@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-16-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-16-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Add a dedicated helper for zapping a TDP MMU root, and use it in the three
> flows that do "zap_all" and intentionally do not do a TLB flush if SPTEs
> are zapped (zapping an entire root is safe if and only if it cannot be in
> use by any vCPU).  Because a TLB flush is never required, unconditionally
> pass "false" to tdp_mmu_iter_cond_resched() when potentially yielding.
> 
> Opportunistically document why KVM must not yield when zapping roots that
> are being zapped by kvm_tdp_mmu_put_root(), i.e. roots whose refcount has
> reached zero, and further harden the flow to detect improper KVM behavior
> with respect to roots that are supposed to be unreachable.
> 
> In addition to hardening zapping of roots, isolating zapping of roots
> will allow future simplification of zap_gfn_range() by having it zap only
> leaf SPTEs, and by removing its tricky "zap all" heuristic.  By having
> all paths that truly need to free _all_ SPs flow through the dedicated
> root zapper, the generic zapper can be freed of those concerns.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 98 +++++++++++++++++++++++++++++++-------
>  1 file changed, 82 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 87706e9cc6f3..c5df9a552470 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -56,10 +56,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	rcu_barrier();
>  }
>  
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> -			  bool shared);
> -
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
>  	free_page((unsigned long)sp->spt);
> @@ -82,6 +78,9 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	tdp_mmu_free_sp(sp);
>  }
>  
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +			     bool shared);
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  bool shared)
>  {
> @@ -104,7 +103,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 * intermediate paging structures, that may be zapped, as such entries
>  	 * are associated with the ASID on both VMX and SVM.
>  	 */
> -	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> +	tdp_mmu_zap_root(kvm, root, shared);
>  
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -751,6 +750,76 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
>  	return iter->yielded;
>  }
>  
> +static inline gfn_t tdp_mmu_max_gfn_host(void)
> +{
> +	/*
> +	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
> +	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
> +	 * and so KVM will never install a SPTE for such addresses.
> +	 */
> +	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> +}
> +
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +			     bool shared)
> +{
> +	bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
> +	struct tdp_iter iter;
> +
> +	gfn_t end = tdp_mmu_max_gfn_host();
> +	gfn_t start = 0;
> +
> +	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * No need to try to step down in the iterator when zapping an entire
> +	 * root, zapping an upper-level SPTE will recurse on its children.
> +	 */
> +	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
> +retry:
> +		/*
> +		 * Yielding isn't allowed when zapping an unreachable root as
> +		 * the root won't be processed by mmu_notifier callbacks.  When
> +		 * handling an unmap/release mmu_notifier command, KVM must
> +		 * drop all references to relevant pages prior to completing
> +		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
> +		 * for an unreachable root after a relevant callback completes,
> +		 * which leads to use-after-free as zapping a SPTE triggers
> +		 * "writeback" of dirty/accessed bits to the SPTE's associated
> +		 * struct page.
> +		 */

I have a quick question here: when the roots are unreachable, we can't
yield, understand that after reading the comments. However, what if
there are too many SPTEs that need to be zapped that requires yielding.
In this case, I guess we will have a RCU warning, which is unavoidable,
right?
> +		if (!root_is_unreachable &&
> +		    tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> +			continue;
> +
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
> +		if (!shared) {
> +			tdp_mmu_set_spte(kvm, &iter, 0);
> +		} else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
> +			/*
> +			 * cmpxchg() shouldn't fail if the root is unreachable.
> +			 * Retry so as not to leak the page and its children.
> +			 */
> +			WARN_ONCE(root_is_unreachable,
> +				  "Contended TDP MMU SPTE in unreachable root.");
> +			goto retry;
> +		}
> +
> +		/*
> +		 * WARN if the root is invalid and is unreachable, all SPTEs
> +		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
> +		 * and inserting new SPTEs under an invalid root is a KVM bug.
> +		 */
> +		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	u64 old_spte;
> @@ -799,8 +868,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  gfn_t start, gfn_t end, bool can_yield, bool flush,
>  			  bool shared)
>  {
> -	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> -	bool zap_all = (start == 0 && end >= max_gfn_host);
> +	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>  	struct tdp_iter iter;
>  
>  	/*
> @@ -809,12 +877,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 */
>  	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
>  
> -	/*
> -	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> -	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> -	 * and so KVM will never install a SPTE for such addresses.
> -	 */
> -	end = min(end, max_gfn_host);
> +	end = min(end, tdp_mmu_max_gfn_host());
>  
>  	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
>  
> @@ -874,6 +937,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>  
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  {
> +	struct kvm_mmu_page *root;
>  	int i;
>  
>  	/*
> @@ -881,8 +945,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
> +			tdp_mmu_zap_root(kvm, root, false);
> +	}
>  }
>  
>  /*
> @@ -908,7 +974,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  		 * will still flush on yield, but that's a minor performance
>  		 * blip and not a functional issue.
>  		 */
> -		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
> +		tdp_mmu_zap_root(kvm, root, true);
>  
>  		/*
>  		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
