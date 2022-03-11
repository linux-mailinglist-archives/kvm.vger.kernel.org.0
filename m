Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546404D6459
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiCKPLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348602AbiCKPL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:11:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F9E01C4B14
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647011421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S86JNNozDNBpXX5OqlAvYtryTmTo71qDJCBEDOod3jQ=;
        b=cQ0QrSboDhpd4krAWwLfX+3QdENZD7VyapQOGL1yAxvw9stBn5L/wQjiUcL+nrxS9LkD/T
        bUNksSKfbFsy2eDbGiu1i+ozR9PW1U2UwrXqWJt3x8ni/CpH5ZOks6jPJoUkChhKfY1Yog
        woWrjqRR8mTyk8f/yiVWB+uCvXfz6vo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-cfmCbE3YN264cMHMmS0VCA-1; Fri, 11 Mar 2022 10:10:15 -0500
X-MC-Unique: cfmCbE3YN264cMHMmS0VCA-1
Received: by mail-ed1-f71.google.com with SMTP id r8-20020aa7d588000000b00416438ed9a2so5015505edq.11
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:10:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=S86JNNozDNBpXX5OqlAvYtryTmTo71qDJCBEDOod3jQ=;
        b=IWq4fpU5qhl4z0Zyx5+nHXHwrqu7+EhmBmMRRcBgubgsgcxsqrYAjdQ29HOSw7d4Ud
         ac4ThM5qzZQuUeqMwvnsYwSzKnnbt9OcPZrYm1XfoNMsaMactMjt4StHQba3R5YEVW8I
         c0ovna/MNc3bDD5EtEqask56A0az2jBteEcXtWAQwAlwG+xyGnuav0ao2F1tt2xmAj5q
         y+PIiJ3LqyJ2VEAEbibY9nSYRLGxeOcc3nXProq7fcWnF85x0vrux2296oV63HX3lCjk
         uOC88MQQSrPC4N8ZgUkd01z+/f0fhdIfXvvgPFEmYZJfQd0bPr1A6SzQpkxVJ88Fq7Sp
         kz7g==
X-Gm-Message-State: AOAM531yqe5bLLN3u/qYjaZmZQT8aPqcXlU9AFWbgc2jGp+/TXpNV78z
        Rh9UwUFnQXDT6r2z2DZxLBSKI8Ap+O//ye79USBZc+IDrdU6kQ1RYlJkX9xl6MubfHL6Vj/ZkI4
        i3qQZci3+2GGHsMlzkTKEGZ3lF9kwn5u8y0W9gAVH4aIUuyCag4PGoSqAGg57r8Fs
X-Received: by 2002:a17:906:9f21:b0:6b6:1f07:fb86 with SMTP id fy33-20020a1709069f2100b006b61f07fb86mr8922195ejc.495.1647011410933;
        Fri, 11 Mar 2022 07:10:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpg4AhO6R+aOLseJyWOkNzsFA5iV8kBdrbE562CRDglmbNK4DdT28I2Eiql+gwjeGck5AhzA==
X-Received: by 2002:a17:906:9f21:b0:6b6:1f07:fb86 with SMTP id fy33-20020a1709069f2100b006b61f07fb86mr8921290ejc.495.1647011397721;
        Fri, 11 Mar 2022 07:09:57 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j20-20020a508a94000000b00416c19650e8sm1728303edj.71.2022.03.11.07.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 07:09:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()
In-Reply-To: <20220303193842.370645-19-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
Date:   Fri, 11 Mar 2022 16:09:56 +0100
Message-ID: <87wnh08r0b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

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

I've noticed that multi-vCPU Hyper-V guests started crashing randomly on
boot with the latest kvm/queue and I've bisected the problem to this
particular patch. Basically, I'm not able to boot e.g. 16-vCPU guest
successfully anymore. Both Intel and AMD seem to be affected. Reverting
this commit saves the day.

Having some experience with similarly looking crashes in the past, I'd
suspect it is TLB flush related. I'd appreciate any thoughts.

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

-- 
Vitaly

