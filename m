Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54AF7A9E45
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjIUT7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjIUT7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2394F4F906
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5WnZqdwhkRoKQqYw3cgQpal+kFJURVQvQfhkGIc48y8=;
        b=ZtWSEI3mnJy7q+OmC/6w3qacABgt83cfkTCooUBAiXJz/kGkJJL8pJvTPpjcv+tnnrn+1m
        8QBFNsXxE1+2ZjS4vqZbmIJibS0WIFwgLoxCNN5iDx/+ChGjxZ0zV4dJsgaiJjPN81mVLt
        +Wkl73izNul4omQibGLjMd+JuiAmoKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-njenodV1Mg-K7-pyVvx2ug-1; Thu, 21 Sep 2023 06:52:42 -0400
X-MC-Unique: njenodV1Mg-K7-pyVvx2ug-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40526a782f7so6321025e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 03:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695293562; x=1695898362;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WnZqdwhkRoKQqYw3cgQpal+kFJURVQvQfhkGIc48y8=;
        b=M6mPput/Om7vkvUCDQQLtWqV5zKofjFL4ahsv9Im90kMiA/HpkYkvWySPOGbLQSizA
         GkAumUNkFmEicBvaDdtjLFrtlqq+0TvLbsxsf3cBt00Q3LNvUzsKrIB3o0ZvODCTeZAH
         lr1hfrDZ5645T/tVWYjJZ+pFe+oFzPNg/1SITyv5iRUs5NqjjSxGPdlO6gP1+CM4eFjH
         XIGuHXj8BMrb9eQ4Jj4iXgb8apzv+nCygm7BgvkHVa25ipNj92BMaQKwA8w3iMMBiP9N
         ra98xQIvhuAdZCf0WRfKnfJdzS0fuGvSNHIDlJVqzxKDpc93gtbp1kO/C25QgS5UN6ig
         6QNQ==
X-Gm-Message-State: AOJu0Yz4luoqW4ZNFvo8CPtsGNws3QvlZ46oSYf0j1iIX01yDD2+yCNU
        ti0V+Bl+ZkT95CXtc1keNvYuOlyAGmaGU8dutQSk4lwntTsG6uMGz7ps75LuPwbGC+T8UWDXPgd
        zRMvXklU12biw
X-Received: by 2002:a05:600c:2201:b0:401:d3dd:c3c with SMTP id z1-20020a05600c220100b00401d3dd0c3cmr4562511wml.39.1695293561849;
        Thu, 21 Sep 2023 03:52:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVd+0oglV4sq2NNW4UpuK3w9yQhq7UAjftlH920QyVqC/rkJkmvOuYGXtFeT65RGtogMwRGg==
X-Received: by 2002:a05:600c:2201:b0:401:d3dd:c3c with SMTP id z1-20020a05600c220100b00401d3dd0c3cmr4562490wml.39.1695293561432;
        Thu, 21 Sep 2023 03:52:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p19-20020a05600c1d9300b0040531f5c51asm1541399wms.5.2023.09.21.03.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 03:52:40 -0700 (PDT)
Message-ID: <adebc422-2937-48d7-20c1-aef2dc1ac436@redhat.com>
Date:   Thu, 21 Sep 2023 12:52:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Take "shared" instead of "as_id" TDP
 MMU's yield-safe iterator
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
References: <20230916003916.2545000-1-seanjc@google.com>
 <20230916003916.2545000-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230916003916.2545000-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/23 02:39, Sean Christopherson wrote:
> Replace the address space ID in for_each_tdp_mmu_root_yield_safe() with a
> shared (vs. exclusive) param, and have the walker iterate over all address
> spaces as all callers want to process all address spaces.  Drop the @as_id
> param as well as the manual address space iteration in callers.
> 
> Add the @shared param even though the two current callers pass "false"
> unconditionally, as the main reason for refactoring the walker is to
> simplify using it to zap invalid TDP MMU roots, which is done with
> mmu_lock held for read.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

You konw what, I don't really like the "bool shared" arguments anymore.
For example, neither tdp_mmu_next_root nor kvm_tdp_mmu_put_root need to 
know if the lock is taken for read or write; protection is achieved via 
RCU and tdp_mmu_pages_lock.  It's more self-documenting to remove the 
argument and assert that the lock is taken.

Likewise, the argument is more or less unnecessary in the 
for_each_*_tdp_mmu_root_yield_safe() macros.  Many users check for the 
lock before calling it; and all of them either call small functions that 
do the check, or end up calling tdp_mmu_set_spte_atomic() and 
tdp_mmu_iter_set_spte(), so the per-iteration checks are also overkill.

It may be useful to a few assertions to make up for the lost check 
before the first execution of the body of 
for_each_*_tdp_mmu_root_yield_safe(), but even this is more for 
documentation reasons than to catch actual bugs.

I'll send a v2.

Paolo

> ---
>   arch/x86/kvm/mmu/mmu.c     |  8 ++------
>   arch/x86/kvm/mmu/tdp_mmu.c | 20 ++++++++++----------
>   arch/x86/kvm/mmu/tdp_mmu.h |  3 +--
>   3 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 59f5e40b8f55..54f94f644b42 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6246,7 +6246,6 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
>   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   {
>   	bool flush;
> -	int i;
>   
>   	if (WARN_ON_ONCE(gfn_end <= gfn_start))
>   		return;
> @@ -6257,11 +6256,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   
>   	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
>   
> -	if (tdp_mmu_enabled) {
> -		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> -						      gfn_end, flush);
> -	}
> +	if (tdp_mmu_enabled)
> +		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
>   
>   	if (flush)
>   		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 89aaa2463373..7cb1902ae032 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -211,8 +211,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>   #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
>   	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
>   
> -#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
> -	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)
> +#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
> +	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, false);		\
> +	     _root;								\
> +	     _root = tdp_mmu_next_root(_kvm, _root, _shared, false))		\
> +		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
> +		} else
>   
>   /*
>    * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
> @@ -877,12 +881,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>    * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
>    * more SPTEs were zapped since the MMU lock was last acquired.
>    */
> -bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> -			   bool flush)
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
>   {
>   	struct kvm_mmu_page *root;
>   
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
>   		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
>   
>   	return flush;
> @@ -891,7 +894,6 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
>   void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   {
>   	struct kvm_mmu_page *root;
> -	int i;
>   
>   	/*
>   	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
> @@ -905,10 +907,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   	 * is being destroyed or the userspace VMM has exited.  In both cases,
>   	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>   	 */
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> -		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
> -			tdp_mmu_zap_root(kvm, root, false);
> -	}
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
> +		tdp_mmu_zap_root(kvm, root, false);
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index eb4fa345d3a4..bc088953f929 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -20,8 +20,7 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>   void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   			  bool shared);
>   
> -bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> -			   bool flush);
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
>   bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>   void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>   void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);

