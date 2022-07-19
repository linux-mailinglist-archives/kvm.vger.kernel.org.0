Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4E857AA40
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbiGSXId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbiGSXIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:08:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA47624AC
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:08:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q43-20020a17090a17ae00b001f1f67e053cso431455pja.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ET65oz3snuYW9UKmGCi68CucaUuwFBdpbcu5YHhob8w=;
        b=ZDwPc2YaURL2ac7KBS/xNJru3MgkntAdwQ0Q43KLd3OK7/f5sLniwqTBRcAVCfzz6c
         r6gZ+UJFFUxNdswWA7VgEolASTeA/dgFHbNACXgans17Ncv68aXHlr6vowlOsgwjpNqr
         5MCvt0x9BBhlN2AR0g2evITBgzAdNEVGLY2DdzuqsssKqV6yLI7N9LtYenxYb+EwzBSQ
         FSPjoO1OwPl4jXkahKNFQNyqR3ml73f234EORFB920A/GzeY+LQMbzWw0i6AcVqA7zOY
         95owPxP3yO8dr74A2adqCrAu5fx245AiUDjxTXJZveXZ/xquCvkY8mFyanggl6w4SEqN
         TJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ET65oz3snuYW9UKmGCi68CucaUuwFBdpbcu5YHhob8w=;
        b=gnkI5lemH4z1vwGMh1lVDifWHfJI+JfCQ9b5BXNS4sULLxfmKhg0jXnS2zlnTfV9CC
         Opx2ab8RzRGXwL14pV3twVft6DsIrrUNseGmP93IgAXG7ng7RYv5Atnlicb9cihCOf2t
         FjZ6baD3wPnkiUFZ+WnYaa7zjF5BGVoIyH8c0dB8Dgif1FEHX5dlDnZZ6ApJ3aYnzf6P
         sKZBILJYeMFCPYjEPNMZlCCI8Rd/d5Rtx8o/zlzpWHDu8ziJ+GM0qYox8CdANOzxSCOb
         hbeGp+q9IteWTzb4vjRH0eTnBR7IObmBHW9ux44D2du8PeHBdeEkDAEreKknrZsa73I2
         Kc1A==
X-Gm-Message-State: AJIora8hrNQIXSLiXSi97xYgsM3sNo6CV2S/rqC8zAh38zKgfpuCp2gE
        OugXj7UApEaW2WCBimqF3Cha9Q==
X-Google-Smtp-Source: AGRyM1tjxWRS3tOmxtESoizG6YYLn4fNUbLCxDc5oFfKk4184j1oiwQdV22Lb7ncrvKw4a18UgdiTQ==
X-Received: by 2002:a17:90b:1a81:b0:1ef:9e9d:a08a with SMTP id ng1-20020a17090b1a8100b001ef9e9da08amr1939618pjb.58.1658272106623;
        Tue, 19 Jul 2022 16:08:26 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b0016c2cdea409sm12289236plc.280.2022.07.19.16.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 16:08:26 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:08:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 08/12] KVM: X86/MMU: Allocate mmu->pae_root for PAE
 paging on-demand
Message-ID: <Ytc5Zmer7sjkGAqV@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-9-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-9-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> mmu->pae_root for non-PAE paging is allocated on-demand, but
> mmu->pae_root for PAE paging is allocated early when struct kvm_mmu is
> being created.
> 
> Simplify the code to allocate mmu->pae_root for PAE paging and make
> it on-demand.

Hmm, I'm not convinced this simplifies things enough to justify the risk.  There's
a non-zero chance that the __GFP_DMA32 allocation was intentionally done during VM
creation in order to avoid OOM on low memory.

Maybe move this patch to the tail end of the series so that it has a higher chance
of reverting cleanly if on-demand allocation breaks someone's setup?

> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   2 +-
>  arch/x86/kvm/mmu/mmu.c          | 101 +++++++++++++-------------------
>  arch/x86/kvm/x86.c              |   4 +-
>  3 files changed, 44 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9cdc5bbd721f..fb9751dfc1a7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1615,7 +1615,7 @@ int kvm_mmu_vendor_module_init(void);
>  void kvm_mmu_vendor_module_exit(void);
>  
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
> -int kvm_mmu_create(struct kvm_vcpu *vcpu);
> +void kvm_mmu_create(struct kvm_vcpu *vcpu);
>  int kvm_mmu_init_vm(struct kvm *kvm);
>  void kvm_mmu_uninit_vm(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 90b715eefe6a..63c2b2c6122c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -668,6 +668,41 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static int mmu_alloc_pae_root(struct kvm_vcpu *vcpu)

Now that pae_root isn't the "full" root, just the page table, I think we should
rename pae_root to something else, and then name this accordingly.

pae_root_backing_page and mmu_alloc_pae_root_backing_page()?  Definitely don't
love the name if someone has a better idea.

> +{
> +	struct page *page;
> +
> +	if (vcpu->arch.mmu->root_role.level != PT32E_ROOT_LEVEL)
> +		return 0;

I think I'd prefer to move this check to the caller, it's confusing to see an
unconditional call to a PAE-specific helper.

> +	if (vcpu->arch.mmu->pae_root)
> +		return 0;
> +
> +	/*
> +	 * Allocate a page to hold the four PDPTEs for PAE paging when emulating
> +	 * 32-bit mode.  CR3 is only 32 bits even on x86_64 in this case.
> +	 * Therefore we need to allocate the PDP table in the first 4GB of
> +	 * memory, which happens to fit the DMA32 zone.
> +	 */
> +	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);

Leave off __GFP_ZERO, it's unnecesary in both cases, and actively misleading in
when TDP is disabled.  KVM _must_ write the page after making it decrypted.  And
since I can't find any code that actually does initialize "pae_root", I suspect
this series is buggy.

But if there is a bug, it was introduced earlier in this series, either by

  KVM: X86/MMU: Add local shadow pages

or by

  KVM: X86/MMU: Activate local shadow pages and remove old logic

depending on whether you want to blame the function that is buggy, or the patch
that uses the buggy function..

The right place to initialize the root is kvm_mmu_alloc_local_shadow_page().
KVM sets __GFP_ZERO for mmu_shadow_page_cache, i.e. relies on new sp->spt pages
to be zeroed prior to "allocating" from the cache.

The PAE root backing page on the other hand is allocated once and then reused
over and over.

	if (role.level == PT32E_ROOT_LEVEL &&
	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root)) {
		sp->spt = vcpu->arch.mmu->pae_root;
		kvm_mmu_initialize_pae_root(sp->spt): <==== something like this
	} else {
		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
	}


> -	for (i = 0; i < 4; ++i)
> -		mmu->pae_root[i] = INVALID_PAE_ROOT;

Please remove this code in a separate patch.  I don't care if it is removed before
or after (I'm pretty sure the existing behavior is paranoia), but I don't want
multiple potentially-functional changes in this patch.
