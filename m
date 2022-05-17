Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7556252A8B0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351264AbiEQQ5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344714AbiEQQ5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:57:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE274F9F6
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:57:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c22so693850pgu.2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZrkN+YgQcy8TmBn9IQj258ckKwGL6KgYMAMdpFCzl+0=;
        b=Z0W6Fesmppi/k/m0+l3fvjlzx5G0H6gVZ2f07+JAuuTTeO8m8XLKP2G4bvCdR4dshd
         oxnaIOLfzq6QRhRPG81rI5zqY7jSD9YM2LBq3QOcTjY0VHXuOngQiif1S5TCwBDxysoh
         h0AjbNgPsSqPSwxx8oHr6i7jDH0j2OqWACyL+wN/ouZNo22OZiQDYFxaRZUY2QwsZ3xW
         mcVqrIxTzRpSucPGRzuSVseoBxdg6sRhV8Q3S5WsxEloHQXn/6jPnnLECkDP0k0v7XSy
         mr6KKhu8xhvceslqQ2zU98fQkxEHsOKLCQawz1a5xxLIiwNxN0+dzNgZRRhn1fndgvCT
         1G6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZrkN+YgQcy8TmBn9IQj258ckKwGL6KgYMAMdpFCzl+0=;
        b=j36OZfkTSVo1bZSuGJoCYCRcjRruGRPFsqLcKtCyJd9+bS3yptHa04yj+SzwCeorsa
         hHr7vKMl45Vsip+59TAFWzTIAFstguY5d4KY4KeQNtPCy9nyPbVyY6fXhOBF4WYouGFD
         SWQG9/+PfNRRAIR246pwmqYgB7zcFEKiwi1zr3aM7U92WmNnDZTYQ3nUM4vNHv8ptmir
         9+MjAediSF4n9QlX/Kv1EXhxea1z0FvVJl3VQAtvBerdzZ8JXBgfI3InWtrZhW+HNFTY
         H4YuDDzG3/F6dmNszya4M0whReLAeo6oy/oucn64LlZ3wUb36jH+/jl1SHDTcOWj9fm5
         xSBw==
X-Gm-Message-State: AOAM531PbCEfNuqWK9SOwO5/HBBljguGG2rgje6lHHoJlg1N6eOeXUM9
        16mnOHVsNgfUBVdyAdFlXkmO1A==
X-Google-Smtp-Source: ABdhPJzWpE20upem7cs6BX2VWWBhtrwf10SFgIkk8EyDuL9wYbTgCsRbrxH8glHRNtY+fLSZh/J0rw==
X-Received: by 2002:a62:a209:0:b0:510:3c47:7888 with SMTP id m9-20020a62a209000000b005103c477888mr23212920pff.14.1652806639519;
        Tue, 17 May 2022 09:57:19 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id cs20-20020a17090af51400b001df5dea7d4bsm1912045pjb.43.2022.05.17.09.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 09:57:18 -0700 (PDT)
Date:   Tue, 17 May 2022 16:57:14 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V2 6/7] KVM: X86/MMU: Allocate mmu->pae_root for PAE
 paging on-demand
Message-ID: <YoPT6petoQUnF4vB@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-7-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-7-jiangshanlai@gmail.com>
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

On Tue, May 03, 2022 at 11:07:34PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> mmu->pae_root for non-PAE paging is allocated on-demand, but
> mmu->pae_root for PAE paging is allocated early when struct kvm_mmu is
> being created.
> 
> Simplify the code to allocate mmu->pae_root for PAE paging and make
> it on-demand.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 99 ++++++++++++++-------------------
>  arch/x86/kvm/mmu/mmu_internal.h | 10 ----
>  2 files changed, 42 insertions(+), 67 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bcb3e2730277..c97f830c5f8c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -691,6 +691,41 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static int mmu_alloc_pae_root(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page;
> +
> +	if (vcpu->arch.mmu->root_role.level != PT32E_ROOT_LEVEL)
> +		return 0;
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
> +	if (!page)
> +		return -ENOMEM;
> +	vcpu->arch.mmu->pae_root = page_address(page);
> +
> +	/*
> +	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
> +	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
> +	 * that KVM's writes and the CPU's reads get along.  Note, this is
> +	 * only necessary when using shadow paging, as 64-bit NPT can get at
> +	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
> +	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
> +	 */
> +	if (!tdp_enabled)
> +		set_memory_decrypted((unsigned long)vcpu->arch.mmu->pae_root, 1);
> +	else
> +		WARN_ON_ONCE(shadow_me_value);
> +	return 0;
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -5031,6 +5066,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
>  	if (r)
>  		goto out;
> +	r = mmu_alloc_pae_root(vcpu);
> +	if (r)
> +		return r;
>  	r = mmu_alloc_special_roots(vcpu);
>  	if (r)
>  		goto out;
> @@ -5495,63 +5533,18 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>  	free_page((unsigned long)mmu->pml5_root);
>  }
>  
> -static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +static void __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)

vcpu is now unused.

>  {
> -	struct page *page;
>  	int i;
>  
>  	mmu->root.hpa = INVALID_PAGE;
>  	mmu->root.pgd = 0;
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;

optional: Consider open-coding this directly in kvm_mmu_create() and
drop __kvm_mmu_create().

> -
> -	/* vcpu->arch.guest_mmu isn't used when !tdp_enabled. */
> -	if (!tdp_enabled && mmu == &vcpu->arch.guest_mmu)
> -		return 0;
> -
> -	/*
> -	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
> -	 * while the PDP table is a per-vCPU construct that's allocated at MMU
> -	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
> -	 * x86_64.  Therefore we need to allocate the PDP table in the first
> -	 * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
> -	 * generally doesn't use PAE paging and can skip allocating the PDP
> -	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
> -	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
> -	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
> -	 */
> -	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
> -		return 0;
> -
> -	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
> -	if (!page)
> -		return -ENOMEM;
> -
> -	mmu->pae_root = page_address(page);
> -
> -	/*
> -	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
> -	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
> -	 * that KVM's writes and the CPU's reads get along.  Note, this is
> -	 * only necessary when using shadow paging, as 64-bit NPT can get at
> -	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
> -	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
> -	 */
> -	if (!tdp_enabled)
> -		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
> -	else
> -		WARN_ON_ONCE(shadow_me_value);
> -
> -	for (i = 0; i < 4; ++i)
> -		mmu->pae_root[i] = INVALID_PAE_ROOT;
> -
> -	return 0;
>  }
>  
>  int kvm_mmu_create(struct kvm_vcpu *vcpu)

kvm_mmu_create() could return void now too.

>  {
> -	int ret;
> -
>  	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
>  	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
>  
> @@ -5563,18 +5556,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>  
> -	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
> -	if (ret)
> -		return ret;
> -
> -	ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
> -	if (ret)
> -		goto fail_allocate_root;
> +	__kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
> +	__kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
>  
> -	return ret;
> - fail_allocate_root:
> -	free_mmu_pages(&vcpu->arch.guest_mmu);
> -	return ret;
> +	return 0;
>  }
>  
>  #define BATCH_ZAP_PAGES	10
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1bff453f7cbe..d5673a42680f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -20,16 +20,6 @@ extern bool dbg;
>  #define MMU_WARN_ON(x) do { } while (0)
>  #endif
>  
> -/*
> - * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
> - * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
> - * PDPTR is !PRESENT, its corresponding PAE root cannot be set to INVALID_PAGE,
> - * as the CPU would treat that as PRESENT PDPTR with reserved bits set.  Use
> - * '0' instead of INVALID_PAGE to indicate an invalid PAE root.
> - */
> -#define INVALID_PAE_ROOT	0
> -#define IS_VALID_PAE_ROOT(x)	(!!(x))
> -
>  typedef u64 __rcu *tdp_ptep_t;
>  
>  struct kvm_mmu_page {
> -- 
> 2.19.1.6.gb485710b
> 
