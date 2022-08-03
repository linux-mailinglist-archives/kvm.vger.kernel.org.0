Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0106B588F1B
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiHCPIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbiHCPIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:08:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D838827B06
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659539311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEJipl6ZEklwILT6wRjOyBYSkCe6bZ/w1fkrBbq5Vog=;
        b=FaQ958NJAkKp3fZeGnNqr4RulEHN1jg2Q3AP3uywSQalfkglVEtHUZKQjhZKb073wvLKNi
        4Wy0HN8R/AveFXBrbGyEm9tZjJb/mYKKArvq+D6tf1q1x4+j9xBqzFepIVq6jjqDK8mtsR
        Goci1RRN9KRZE7LLb9X3aPKPQ5/vqnU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-aE8BAP8jM-i3KCV64JqlWw-1; Wed, 03 Aug 2022 11:08:29 -0400
X-MC-Unique: aE8BAP8jM-i3KCV64JqlWw-1
Received: by mail-wm1-f72.google.com with SMTP id bh18-20020a05600c3d1200b003a32044cc9fso7415506wmb.6
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 08:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=TEJipl6ZEklwILT6wRjOyBYSkCe6bZ/w1fkrBbq5Vog=;
        b=uJmI69zXnZWpBnrYKocgmO3RTe8T6Qf5F53lY8ySr8AsiKGWmoVdp9PjFdBLgKoDbg
         AGY9ONEzb3M+prEYlMNJynD7X0VktH4kAKGZhDSR9UjGt4X32kewBClqwX83Q1aJ55sn
         bLSuuR01r8IUYQibfc+bnNz7pPImyyrN80ZaV8H/uvZOFPFON51jSacZUm3S1tZEyq/c
         kbc1pw5keNawhuj0229CHc4VStyy+R3vn2jKnk2nDrVdzmkc5fOjDvfo97Vym3C82+XP
         te7Bhn7P2M166VMol7Pi8SVq+cfgq8Q7DmrM991n2JKxRK5/HFwB8RUIkmaALaaJ0aB/
         dl0g==
X-Gm-Message-State: ACgBeo0pR8YCPT9ecrzm+kaBfZpfU8iJGb3o+aT8xp40bSVWfcIcwetp
        VGAOrwkKzwCVubpkf0dzixiwX5tJJ4AZLI+3MNZVBDM1xYFGNQJiQK+8HU7ADrk1+dYSm6ZYiv6
        25IsJUj6YLw5e
X-Received: by 2002:a7b:ca48:0:b0:3a3:365d:1089 with SMTP id m8-20020a7bca48000000b003a3365d1089mr3303518wml.153.1659539308548;
        Wed, 03 Aug 2022 08:08:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Pkyj5/hjywoI7Ycq4AlxsyzIwqNZ/+qcPrRRcmJRiZ74M2UHFTtU5uW2z1EWbh2qJbbexAQ==
X-Received: by 2002:a7b:ca48:0:b0:3a3:365d:1089 with SMTP id m8-20020a7bca48000000b003a3365d1089mr3303490wml.153.1659539308168;
        Wed, 03 Aug 2022 08:08:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id s1-20020adfea81000000b0021e74ef5ae8sm18333208wrm.21.2022.08.03.08.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 08:08:27 -0700 (PDT)
Message-ID: <cedcced0-b92c-07bd-ef2b-272ae58fdf40@redhat.com>
Date:   Wed, 3 Aug 2022 17:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com> <YuhoJUoPBOu5eMz8@google.com>
 <YulRZ+uXFOE1y2dj@google.com> <YuldSf4T2j4rIrIo@google.com>
 <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
 <Yul3A4CmaAHMui2Z@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yul3A4CmaAHMui2Z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/22 21:12, Sean Christopherson wrote:
> Ah crud, I misread the patch.  I was thinking tdp_mmu_spte_to_nid() was getting
> the node for the existing shadow page, but it's actually getting the node for the
> underlying physical huge page.
> 
> That means this patch is broken now that KVM doesn't require a "struct page" to
> create huge SPTEs (commit  a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted
> "struct page" to create huge SPTEs").  I.e. this will explode as pfn_to_page()
> may return garbage.
> 
> 	return page_to_nid(pfn_to_page(spte_to_pfn(spte)));

I was about to say that yesterday.  However my knowledge of struct page 
things has been proved to be spotty enough, that I wasn't 100% sure of 
that.  But yeah, with a fresh mind it's quite obvious that anything that 
goes through hva_to_pfn_remap and similar paths will fail.

> That said, I still don't like this patch, at least not as a one-off thing.  I do
> like the idea of having page table allocations follow the node requested for the
> target pfn, what I don't like is having one-off behavior that silently overrides
> userspace policy.

Yes, I totally agree with making it all or nothing.

> I would much rather we solve the problem for all page table allocations, maybe
> with a KVM_CAP or module param?  Unfortunately, that's a very non-trivial change
> because it will probably require having a per-node cache in each of the per-vCPU
> caches.

A module parameter is fine.  If you care about performance to this 
level, your userspace is probably homogeneous enough.

Paolo

> Hmm, actually, a not-awful alternative would be to have the fault path fallback
> to the current task's policy if allocation fails.  I.e. make it best effort.
> 
> E.g. as a rough sketch...
> 
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 37 ++++++++++++++++++++++++++++++-------
>   1 file changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bf2ccf9debca..e475f5b55794 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -273,10 +273,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> 
>   static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>   {
> +	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_shadow_page_cache;
>   	struct kvm_mmu_page *sp;
> 
>   	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	sp->spt = kvm_mmu_alloc_shadow_page_table(cache, GFP_NOWAIT, pfn);
> 
>   	return sp;
>   }
> @@ -1190,7 +1191,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			if (is_removed_spte(iter.old_spte))
>   				break;
> 
> -			sp = tdp_mmu_alloc_sp(vcpu);
> +			sp = tdp_mmu_alloc_sp(vcpu, fault->pfn);
>   			tdp_mmu_init_child_sp(sp, &iter);
> 
>   			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> @@ -1402,17 +1403,39 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>   	return spte_set;
>   }
> 
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +void *kvm_mmu_alloc_shadow_page_table(struct kvm_mmu_memory_cache *cache,
> +				      gfp_t gfp, kvm_pfn_t pfn)
> +{
> +	struct page *page = kvm_pfn_to_refcounted_page(pfn);
> +	struct page *spt_page;
> +	int node;
> +
> +	gfp |= __GFP_ZERO | __GFP_ACCOUNT;
> +
> +	if (page) {
> +		spt_page = alloc_pages_node(page_to_nid(page), gfp, 0);
> +		if (spt_page)
> +			return page_address(spt_page);
> +	} else if (!cache) {
> +		return (void *)__get_free_page(gfp);
> +	}
> +
> +	if (cache)
> +		return kvm_mmu_memory_cache_alloc(cache);
> +
> +	return NULL;
> +}
> +
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp,
> +							 kvm_pfn_t pfn)
>   {
>   	struct kvm_mmu_page *sp;
> 
> -	gfp |= __GFP_ZERO;
> -
>   	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
>   	if (!sp)
>   		return NULL;
> 
> -	sp->spt = (void *)__get_free_page(gfp);
> +	sp->spt = kvm_mmu_alloc_shadow_page_table(NULL, gfp, pfn);
>   	if (!sp->spt) {
>   		kmem_cache_free(mmu_page_header_cache, sp);
>   		return NULL;
> @@ -1436,7 +1459,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>   	 * If this allocation fails we drop the lock and retry with reclaim
>   	 * allowed.
>   	 */
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT);
>   	if (sp)
>   		return sp;
> 
> 
> base-commit: f8990bfe1eab91c807ca8fc0d48705e8f986b951
> --
> 

