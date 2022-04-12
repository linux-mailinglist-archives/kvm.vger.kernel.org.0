Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8284FEA20
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 00:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiDLWcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 18:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiDLWcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 18:32:22 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FCCF61C6
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 14:17:42 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a21so139615pfv.10
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 14:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=knG9M3UYQieXfNA2xBybpWoSnTduc8ITKXA/PJQTuvE=;
        b=N4Pn9XBMGe+1OSsSvf0TKA+WHDQEDctYbjd2ywUDQay5xt4RobfdJqq/dQLSRXPXY9
         OZWBNrtQ1rWdIFovQx8BwIg/4TArhupIVUGvLewL/soCnwuyuUIDs1EpK1DnwYBXJLBS
         GnaMdOyf+EzFITDXdiP6K7eLcSo5DCCmuiMNZdcLy1FhXEQz9AtoBE5+yTmHsc9y4t9h
         OfKHfLxDZ7SXbcuwCSEpeO/WTnbWEf1s5UepVvBYWpYZviFsywwjr36wXtK1edvX1X/+
         WqQujedZWJoCgOsDOdSq5hzUBCvKGvsABheFwNk3wYcvQMB9tI+TRMJAFu4P26QFTq+D
         FpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=knG9M3UYQieXfNA2xBybpWoSnTduc8ITKXA/PJQTuvE=;
        b=A78oGrcyUQhBnq/HjCouGagE5fAV3jkW66FJSn78VXmKmeLsDFKBU0HniIXEO1B5XD
         39XBuoc0FJHVPQTdO0YxL8jAf3kWwHTSYuziFG+hq5YjZ6/91cg0U9l3Zk9cg8IVtrOe
         jxz8klUWKj5An4rpQC6e+jhJg53lDzba/WeZemEV2ERLFA+H0qVn1bH0RgorlImmXczH
         EgaaSziJamzwmeWh7d695pRgXDRTeN/EK+ct9DlBoyoEcYl1DbuqJUdEABSA6q0VC+it
         B4xA3M8tlqDA8/dVMKYlieaDoOdLGat+Bb1Yz3Cuku7PklYrMgHmMHqu8BYuHwQWSqdC
         JrnA==
X-Gm-Message-State: AOAM533OaOzoaEjCKcLUbADtdHetSPA0AFEElN/gLKuc9Z3mYLHrGJ9m
        JCquO8CSL4uSiIIMW66MvcVJewxIfNWeUQ==
X-Google-Smtp-Source: ABdhPJwIB/I0m6Z1vpJVIM1zCzFcYNBDyM0Q8/OVLOPqFiN3cPMCp15+J1ilmqJAp824tzokxXjO0g==
X-Received: by 2002:a65:6a07:0:b0:39d:8c35:426b with SMTP id m7-20020a656a07000000b0039d8c35426bmr5198065pgu.171.1649798071171;
        Tue, 12 Apr 2022 14:14:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aa38600b001ca2f87d271sm432615pjp.15.2022.04.12.14.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 14:14:30 -0700 (PDT)
Date:   Tue, 12 Apr 2022 21:14:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
Message-ID: <YlXrshJa2Sd1WQ0P@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330132152.4568-4-jiangshanlai@gmail.com>
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

On Wed, Mar 30, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Currently pae_root is special root page, this patch adds facility to
> allow using kvm_mmu_get_page() to allocate pae_root shadow page.

I don't think this will work for shadow paging.  CR3 only has to be 32-byte aligned
for PAE paging.  Unless I'm missing something subtle in the code, KVM will incorrectly
reuse a pae_root if the guest puts multiple PAE CR3s on a single page because KVM's
gfn calculation will drop bits 11:5.

Handling this as a one-off is probably easier.  For TDP, only 32-bit KVM with NPT
benefits from reusing roots, IMO and shaving a few pages in that case is not worth
the complexity.

> @@ -332,7 +337,8 @@ union kvm_mmu_page_role {
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
>  		unsigned glevel:4;
> -		unsigned :2;
> +		unsigned pae_root:1;

If we do end up adding a role bit, it can simply be "root", which may or may not
be useful for other things.  is_pae_root() is then a combo of root+level.  This
will clean up the code a bit as role.root is (mostly?) hardcoded based on the
function, e.g. root allocators set it, child allocators clear it.

> +		unsigned :1;
>  
>  		/*
>  		 * This is left at the top of the word so that
> @@ -699,6 +705,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	void *mmu_pae_root_cache;
>  
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d53037df8177..81ccaa7c1165 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -694,6 +694,35 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static int mmu_topup_pae_root_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page;
> +
> +	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
> +		return 0;
> +	if (vcpu->arch.mmu_pae_root_cache)
> +		return 0;
> +
> +	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
> +	if (!page)
> +		return -ENOMEM;
> +	vcpu->arch.mmu_pae_root_cache = page_address(page);
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
> +		set_memory_decrypted((unsigned long)vcpu->arch.mmu_pae_root_cache, 1);
> +	else
> +		WARN_ON_ONCE(shadow_me_mask);
> +	return 0;
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -705,6 +734,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  		return r;
>  	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
>  				       PT64_ROOT_MAX_LEVEL);
> +	if (r)
> +		return r;
> +	r = mmu_topup_pae_root_cache(vcpu);

This doesn't need to be called from the common mmu_topup_memory_caches(), e.g. it
will unnecessarily require allocating another DMA32 page when handling a page fault.
I'd rather call this directly kvm_mmu_load(), which also makes it more obvious
that the cache really is only used for roots.

>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -717,12 +749,23 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  					  PT64_ROOT_MAX_LEVEL);
>  }
>  

...

>  static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>  			     struct kvm_mmu_page *sp)
>  {
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
>  	u64 spte;
>  
>  	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
>  
> -	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> +	if (!parent_sp->role.pae_root)

Hmm, without role.root, this could be:

	if (sp->role.level == (PT32E_ROOT_level - 1) &&
	    ((__pa(sptep) & PT64_BASE_ADDR_MASK) == vcpu->arch.mmu->root.hpa))
		spte = make_pae_pdpte(sp->spt);
	else
		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));

Which is gross, but it works.  We could also do FNAME(link_shadow_page) to send
PAE roots down a dedicated path (also gross).  Point being, I don't think we
strictly need a "root" flag unless the PAE roots are put in mmu_page_hash.

> +		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> +	else
> +		spte = make_pae_pdpte(sp->spt);
>  
>  	mmu_spte_set(sptep, spte);
>  
> @@ -4782,6 +4847,8 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
>  	role.base.direct = true;
>  	role.base.has_4_byte_gpte = false;
> +	if (role.base.level == PT32E_ROOT_LEVEL)
> +		role.base.pae_root = 1;
>  
>  	return role;
>  }
> @@ -4848,6 +4915,9 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	else
>  		role.base.level = PT64_ROOT_4LEVEL;
>  
> +	if (role.base.level == PT32E_ROOT_LEVEL)
> +		role.base.pae_root = 1;
> +
>  	return role;
>  }
>  
> @@ -4893,6 +4963,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  
>  	role.base.direct = false;
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> +	if (role.base.level == PT32E_ROOT_LEVEL)
> +		role.base.pae_root = 1;
>  
>  	return role;
>  }
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 67489a060eba..1015f33e0758 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1043,6 +1043,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		.access = 0x7,
>  		.quadrant = 0x3,
>  		.glevel = 0xf,
> +		.pae_root = 0x1,
>  	};
>  
>  	/*
> -- 
> 2.19.1.6.gb485710b
> 
