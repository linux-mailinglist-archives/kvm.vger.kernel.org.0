Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25CE52A88A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351183AbiEQQsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351171AbiEQQsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:48:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2634EF46
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:47:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c2so116783plh.2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EBasZC6YLIGG+8ebkH1QLdEFicqNV7dhlVlz53XQa0g=;
        b=Lmv+/OShourHoBUs+tURSbEj9Ks1XGiGMRM1OA2iE9dUBahc5HLA478PsXXz7goCEk
         oWj8FTCW5ak98bLmlPS8M39fBTM6883huUiR2o2OTG0IUprf+o9MMW58JrB8kaJhjwBB
         rSmIX/EVnANSjwuReBISK8mk29tv18UFf44sovifAskP6YHXlmF7KPRbh6pOTYI3exrD
         nChhxdff6K0M4caV4KluMckdE/abpp0X3Y5PpHytyh1u/znF1JO4NbwVQG18nDDFWr+6
         Lo85CQkuRy3rfW59Lh92dLP/q808AX5DHZAhfG+S4d3Dm5HvzM5xKlInnAIrtCEosfpt
         Gg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EBasZC6YLIGG+8ebkH1QLdEFicqNV7dhlVlz53XQa0g=;
        b=yhz5P8ouDwoCQe9XBbNmyHyp2fb9tlcdgYCHLf7TnLeDHDQt1EZyLF3/yqQrZFarc3
         QDRNW1WN4YO17Qum1yeirpxT2spYC3uA1lwPbV0/Pny6isztJ/tdE5OmugtfKhdrHyny
         +1g50ODsauucsXqtMEyz3JyWKXK/PK8p2cQRl5AoD1h18d+1qIG6Qtw4dkDgWMRcQxb7
         9u1Sx6RDlWhc2q66P6FoZEteEah1yJq3+/thOi9euLdWYiZW91gkeeTTOwclUJCbIIau
         vYw0UmzPE1wH9yZWeREEoHHHalm2a9D15vU3XJ2x5ku2lmpl5s/PZC6/3YaaTaG91I0a
         xA7w==
X-Gm-Message-State: AOAM530GoBG7n972BFjSxWmO/Jm4N7jvHF5IhicF/pFsePlzI8U9jNqJ
        DLcV174mL222IzqF3nPxRHABjg0UbJRhhA==
X-Google-Smtp-Source: ABdhPJwedacUE1vAqgT/wmFPcMSU3He4JFWbqObgpC8o4yG5zSA3Tap0Mjo0P4Uz/5VfkOYxfjqnDQ==
X-Received: by 2002:a17:903:124b:b0:15e:84d0:ded6 with SMTP id u11-20020a170903124b00b0015e84d0ded6mr22605889plh.141.1652806078925;
        Tue, 17 May 2022 09:47:58 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id i7-20020a63cd07000000b003c14af5063esm8853588pgg.86.2022.05.17.09.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 09:47:58 -0700 (PDT)
Date:   Tue, 17 May 2022 16:47:54 +0000
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
Subject: Re: [PATCH V2 5/7] KVM: X86/MMU: Remove the check of the return
 value of to_shadow_page()
Message-ID: <YoPRuh2T/9RvWih4@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-6-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-6-jiangshanlai@gmail.com>
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

On Tue, May 03, 2022 at 11:07:33PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Remove the check of the return value of to_shadow_page() in
> mmu_free_root_page(), kvm_mmu_free_guest_mode_roots(), is_unsync_root()
> and is_tdp_mmu() because it can not return NULL.
> 
> Remove the check of the return value of to_shadow_page() in
> is_page_fault_stale() and is_obsolete_root() because it can not return
> NULL and the obsoleting for special shadow page is already handled by
> a different way.
> 
> When the obsoleting process is done, all the obsoleted shadow pages are
> already unlinked from the special pages by the help of the parent rmap
> of the children and the special pages become theoretically valid again.
> The special shadow page can be freed if is_obsolete_sp() return true,
> or be reused if is_obsolete_sp() return false.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c     | 44 +++-----------------------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  7 +-----
>  2 files changed, 4 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f626d7e8ebb..bcb3e2730277 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3318,8 +3318,6 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  		return;
>  
>  	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> -	if (WARN_ON(!sp))
> -		return;
>  
>  	if (is_tdp_mmu_page(sp))
>  		kvm_tdp_mmu_put_root(kvm, sp, false);
> @@ -3422,8 +3420,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  		if (!VALID_PAGE(root_hpa))
>  			continue;
>  
> -		if (!to_shadow_page(root_hpa) ||
> -			to_shadow_page(root_hpa)->role.guest_mode)
> +		if (to_shadow_page(root_hpa)->role.guest_mode)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  	}
>  
> @@ -3673,13 +3670,6 @@ static bool is_unsync_root(hpa_t root)
>  	smp_rmb();
>  	sp = to_shadow_page(root);
>  
> -	/*
> -	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
> -	 * PDPTEs for a given PAE root need to be synchronized individually.
> -	 */
> -	if (WARN_ON_ONCE(!sp))
> -		return false;
> -
>  	if (sp->unsync || sp->unsync_children)
>  		return true;
>  
> @@ -3975,21 +3965,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault, int mmu_seq)
>  {
> -	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
> -
> -	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> -	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> -		return true;
> -
> -	/*
> -	 * Roots without an associated shadow page are considered invalid if
> -	 * there is a pending request to free obsolete roots.  The request is
> -	 * only a hint that the current root _may_ be obsolete and needs to be
> -	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> -	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> -	 * to reload even if no vCPU is actively using the root.
> -	 */
> -	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> +	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root.hpa)))
>  		return true;
>  
>  	return fault->slot &&
> @@ -5094,24 +5070,10 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  
>  static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
>  {
> -	struct kvm_mmu_page *sp;
> -
>  	if (!VALID_PAGE(root_hpa))
>  		return false;
>  
> -	/*
> -	 * When freeing obsolete roots, treat roots as obsolete if they don't
> -	 * have an associated shadow page.  This does mean KVM will get false
> -	 * positives and free roots that don't strictly need to be freed, but
> -	 * such false positives are relatively rare:
> -	 *
> -	 *  (a) only PAE paging and nested NPT has roots without shadow pages
> -	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
> -	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
> -	 *      is unlikely to zap an in-use PGD.
> -	 */
> -	sp = to_shadow_page(root_hpa);
> -	return !sp || is_obsolete_sp(kvm, sp);
> +	return is_obsolete_sp(kvm, to_shadow_page(root_hpa));
>  }
>  
>  static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c163f7cc23ca..5779a2a7161e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -78,13 +78,8 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	if (WARN_ON(!VALID_PAGE(hpa)))
>  		return false;
>  
> -	/*
> -	 * A NULL shadow page is legal when shadowing a non-paging guest with
> -	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
> -	 * pae_root page, not a shadow page.
> -	 */
>  	sp = to_shadow_page(hpa);
> -	return sp && is_tdp_mmu_page(sp) && sp->root_count;
> +	return is_tdp_mmu_page(sp) && sp->root_count;
>  }
>  #else
>  static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
> -- 
> 2.19.1.6.gb485710b
> 
