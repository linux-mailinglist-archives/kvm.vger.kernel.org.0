Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334B04E9053
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 10:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbiC1ImJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 04:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiC1ImI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 04:42:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21B42517EC
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 01:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648456825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1A+KmteLAN0ERVYaTCTWXzUwXF6QOlGwibaPQ1ipLw=;
        b=RAVyJ2n6wnKYJ3cFN0f+DzgKMRPHgN1ExI5+VN54ArfuThusMxkqFH5S8T9OnhAmspRyCf
        Ggqro/AAxN8AqU1NlWIJZT4ESxgFZ4kyaEq/SBIjX/IEwCHpgzCeKOYWTg+THXmEUYWUiL
        34040Y/xxv73D1N2jzkOK//nSNG4f7Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-ftqZ5_aIOGy8KF-JRF3lUw-1; Mon, 28 Mar 2022 04:40:20 -0400
X-MC-Unique: ftqZ5_aIOGy8KF-JRF3lUw-1
Received: by mail-wm1-f69.google.com with SMTP id 12-20020a05600c24cc00b0038c6caa95f7so5408382wmu.4
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 01:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l1A+KmteLAN0ERVYaTCTWXzUwXF6QOlGwibaPQ1ipLw=;
        b=MtjyRoAVdxViKBJnwdcTGqIvsJCTIiqTG8x4PS/ZWObp39nzoavTMrdw9Ae7k97gOM
         6A7Z6VeN3Y21LjpiNAZ4K95mLzMbmCoMYETujoP0zxdZWptOkpTzuFKDrsIriEc7Yic2
         TPambK7zADd+t5dB250prwKDmblRuE10vcuCO7sjdsmox4vBeJxMtO26TDDrSAs3czoE
         iP//eBxrZf8r2yihBfXcw2NNrXfNuI3jF8Kryb3n4480oY+RlpjDnSPBSxebtDPGNFNj
         HKIDtJ5SykI9SV2LXIYFnn0zi439B3L8HeTTuMWjhY/W3Yy7I4igpbwz2wrzc9tVV3GV
         6cNg==
X-Gm-Message-State: AOAM5336abBdHmtRKcghB28e/GNf1ZWmERGjptYiWVVIQRstWYpT2pqj
        EUaiJaPd37DbnYfNkImQIVG/tHEvYLs7R2nY2UHK2S9CRhyPvfr0CVZgUqN4qglX7SyCcaqYMr1
        5MifMiEI4zelB
X-Received: by 2002:a05:600c:4401:b0:38c:8df8:9797 with SMTP id u1-20020a05600c440100b0038c8df89797mr34087035wmn.13.1648456819466;
        Mon, 28 Mar 2022 01:40:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxiPZFJa7ApsBFKEdeOO+6tYtLq6fYC75457JZka/ZZAfB4UgDoEMn7gfDVjHqpWtvnfNXUg==
X-Received: by 2002:a05:600c:4401:b0:38c:8df8:9797 with SMTP id u1-20020a05600c440100b0038c8df89797mr34087008wmn.13.1648456819196;
        Mon, 28 Mar 2022 01:40:19 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b0038ceb0b21b4sm9028325wmq.24.2022.03.28.01.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 01:40:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Zap only TDP MMU leafs in zap range and
 mmu_notifier unmap
In-Reply-To: <20220325230348.2587437-1-seanjc@google.com>
References: <20220325230348.2587437-1-seanjc@google.com>
Date:   Mon, 28 Mar 2022 10:40:17 +0200
Message-ID: <87lewuo4ge.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Re-introduce zapping only leaf SPTEs in kvm_zap_gfn_range() and
> kvm_tdp_mmu_unmap_gfn_range(), this time without losing a pending TLB
> flush when processing multiple roots (including nested TDP shadow roots).
> Dropping the TLB flush resulted in random crashes when running Hyper-V
> Server 2019 in a guest with KSM enabled in the host (or any source of
> mmu_notifier invalidations, KSM is just the easiest to force).
>
> This effectively revert commits 873dd122172f8cce329113cfb0dfe3d2344d80c0
> and fcb93eb6d09dd302cbef22bd95a5858af75e4156, and thus restores commit
> cf3e26427c08ad9015956293ab389004ac6a338e, plus this delta on top:
>
> bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
>         struct kvm_mmu_page *root;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> -               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
> +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
>
>         return flush;
>  }
>

I confirm this fixes the issue I was seeing, thanks!

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 +--
>  arch/x86/kvm/mmu/tdp_mmu.c | 57 +++++++++++---------------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  8 +-----
>  3 files changed, 19 insertions(+), 50 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..a7cb877f3784 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5842,8 +5842,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
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
> index b3b6426725d4..c4333efb9e9c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -906,10 +906,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  }
>  
>  /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> + * have been cleared and a TLB flush is needed before releasing the MMU lock.
>   *
>   * If can_yield is true, will release the MMU lock and reschedule if the
>   * scheduler needs the CPU or there is contention on the MMU lock. If this
> @@ -917,44 +915,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
> -	 * Do not do it above the 1GB level, to avoid making tdp_mmu_set_spte's
> -	 * recursion too expensive and allow yielding.
> -	 */
> -	int min_level = zap_all ? PG_LEVEL_1G : PG_LEVEL_4K;
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
> @@ -962,17 +941,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		flush = true;
>  	}
>  
> +	rcu_read_unlock();
> +
>  	/*
> -	 * Need to flush before releasing RCU.  TODO: do it only if intermediate
> -	 * page tables were zapped; there is no need to flush under RCU protection
> -	 * if no 'struct kvm_mmu_page' is freed.
> +	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
> +	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
>  	 */
> -	if (flush)
> -		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
> -
> -	rcu_read_unlock();
> -
> -	return false;
> +	return flush;
>  }
>  
>  /*
> @@ -981,13 +956,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
> +		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
>  
>  	return flush;
>  }
> @@ -1235,8 +1210,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
>
> base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6

-- 
Vitaly

