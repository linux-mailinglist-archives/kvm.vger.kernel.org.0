Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057394CCB37
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 02:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbiCDBRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 20:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiCDBRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 20:17:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20417AEE8
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 17:17:04 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so9329651pjb.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 17:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kx5Jp4/0ww7++KGVRBeTTTvpau2ndGSiDv71YsjwVqk=;
        b=Nej3XIybw8L9KhSnUMcPkV/ZHDELs8Rz7aThhpO8znjxk18FqCRWlZBar3Zt7ifoyg
         dXpn9iZkajl5C5sKOZcmz9rDhvl+Kczn7GuNzYFWv/p/OtKj7dpUvWPDqXklah2m230y
         q6A1A7w7WJz/Bjq4FqJzQoEvuEsbNM2svXjo7EXGixz1ukRldztqT+V49kpHk8h2PvCJ
         804ejnC+jM67RYNSZ1loBUZMyOkeuelTUqGzmW0SQA8k4J1I1afcik2paf5/U08bfBvq
         HV1lWgBzg0j7YTqrA4ic//hc8MUHuzvapMVWcytM9TxANXwaVJtLXWbxAYGSrYqIsU5+
         MDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kx5Jp4/0ww7++KGVRBeTTTvpau2ndGSiDv71YsjwVqk=;
        b=ay7DbRybz7I9m37BdF6vV9cPn1xWBhDAstY3vF+Ke0C8482e1Rp/IS1voA5PAqBzvT
         gPyV5Le/l+iB8KgdcQvHXiOI9eRf2om7Tcj1ZQCmmh7hhk3n27DapQRnDVKBJZo0y+Lt
         EBaGdsXn+8PFBPOymoDXbtp6+rJcHNin6AsU1ZyRtq9j8L0wT49qbEsZfFmxJC9I9gdX
         8a0AXGeCXNkJEfUKwm13sp9XRVLBhJJJByj3HzhksrYzYaHzD/IIxT3WPGX0avhHcaVC
         RAyEJ4xNlAXmIRQhhSH8pJA6mu8AyLrDYdJHbtLH8gvS1DpBgbnwd3QaVTigybuyZohA
         Q0lA==
X-Gm-Message-State: AOAM532yhXeJs5obkQXUIwghZtSPq7HiMV3JCEj5wxzf3IRaivLdltR7
        1Y+ba1Wo2zL055omYUNeRofCdg==
X-Google-Smtp-Source: ABdhPJwRtsxVbXHpeu1pMjZ85vERlwkEBvx2oMLzzmbNukNprT83DewEGg1uh3mGv5PGaKYRwShFSQ==
X-Received: by 2002:a17:902:7296:b0:151:62b1:e2b0 with SMTP id d22-20020a170902729600b0015162b1e2b0mr24588921pll.165.1646356623568;
        Thu, 03 Mar 2022 17:17:03 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id k5-20020aa788c5000000b004df7bf0a290sm3809208pff.1.2022.03.03.17.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 17:17:02 -0800 (PST)
Date:   Fri, 4 Mar 2022 01:16:59 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()
Message-ID: <YiFoi8SjWiCHax0P@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-19-pbonzini@redhat.com>
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

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
> functions accordingly.  When removing mappings for functional correctness
> (except for the stupid VFIO GPU passthrough memslots bug), zapping the
> leaf SPTEs is sufficient as the paging structures themselves do not point
> at guest memory and do not directly impact the final translation (in the
> TDP MMU).
> 
> Note, this aligns the TDP MMU with the legacy/full MMU, which zaps only
> the rmaps, a.k.a. leaf SPTEs, in kvm_zap_gfn_range() and
> kvm_unmap_gfn_range().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-18-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
>  3 files changed, 14 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8408d7db8d2a..febdcaaa7b94 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5834,8 +5834,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  
>  	if (is_tdp_mmu_enabled(kvm)) {
>  		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
> -							  gfn_end, flush);
> +			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> +						      gfn_end, true, flush);
>  	}
>  
>  	if (flush)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f3939ce4a115..c71debdbc732 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  }
>  
>  /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> + * have been cleared and a TLB flush is needed before releasing the MMU lock.

I think the original code does not _over_ zapping. But the new version
does. Will that have some side effects? In particular, if the range is
within a huge page (or HugeTLB page of various sizes), then we choose to
zap it even if it is more than the range.

Regardless of side effect, I think we probably should mention that in
the comments?

>   *
>   * If can_yield is true, will release the MMU lock and reschedule if the
>   * scheduler needs the CPU or there is contention on the MMU lock. If this
> @@ -845,42 +843,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * the caller must ensure it does not supply too large a GFN range, or the
>   * operation can cause a soft lockup.
>   */
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end, bool can_yield, bool flush)
> +static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> +			      gfn_t start, gfn_t end, bool can_yield, bool flush)
>  {
> -	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>  	struct tdp_iter iter;
>  
> -	/*
> -	 * No need to try to step down in the iterator when zapping all SPTEs,
> -	 * zapping the top-level non-leaf SPTEs will recurse on their children.
> -	 */
> -	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
> -
>  	end = min(end, tdp_mmu_max_gfn_host());
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	rcu_read_lock();
>  
> -	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
> +	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
>  		if (can_yield &&
>  		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
>  			flush = false;
>  			continue;
>  		}
>  
> -		if (!is_shadow_present_pte(iter.old_spte))
> -			continue;
> -
> -		/*
> -		 * If this is a non-last-level SPTE that covers a larger range
> -		 * than should be zapped, continue, and zap the mappings at a
> -		 * lower level, except when zapping all SPTEs.
> -		 */
> -		if (!zap_all &&
> -		    (iter.gfn < start ||
> -		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
> +		if (!is_shadow_present_pte(iter.old_spte) ||
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> @@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   * SPTEs have been cleared and a TLB flush is needed before releasing the
>   * MMU lock.
>   */
> -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> -				 gfn_t end, bool can_yield, bool flush)
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> +			   bool can_yield, bool flush)
>  {
>  	struct kvm_mmu_page *root;
>  
>  	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> -		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> +		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
>  
>  	return flush;
>  }
> @@ -1202,8 +1183,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  				 bool flush)
>  {
> -	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
> -					   range->end, range->may_block, flush);
> +	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
> +				     range->end, range->may_block, flush);
>  }
>  
>  typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 5e5ef2576c81..54bc8118c40a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -15,14 +15,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  bool shared);
>  
> -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
>  				 gfn_t end, bool can_yield, bool flush);
> -static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
> -					     gfn_t start, gfn_t end, bool flush)
> -{
> -	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
> -}
> -
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> -- 
> 2.31.1
> 
> 
