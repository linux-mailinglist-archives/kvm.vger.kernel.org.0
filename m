Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC357A9BF
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbiGSWVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 18:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiGSWVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 18:21:43 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AFB5727F
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:21:42 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id l124so14867567pfl.8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jwz2xPBcsSUvi6UQz2aVRRre7pThVfHLQu+ABQPNNpM=;
        b=bvlVC+TDi6T2/b4/pLOrdrFYGLJavot6uN0VC38WaAa3VaW3zaRwWf0gdFGQMpJbak
         96TWnRjxQnbhbdZlSvBUqo1Byt+wnG1f6xVDoOZ5jTxnFgGC7/goofWz7QxxpE9MrUUu
         3MAD4vePMasYcKhPf5CPGxQPtS1ADhXACzf7vdnce4deuyM0ovvPojN5om6EIQiwq8FM
         TR/MkL13E92UYGG6nzxdVQjK7E6SC7efPQhO+iuziOnyMscb7rDTFklxqekPF3oq8pqA
         TocrVBZ8BAH2zcKnPrAWu4zilccRa0VfLpgkpuu8lVGwSTv7DDaJ+Pli6amJ5E+71iXP
         N8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jwz2xPBcsSUvi6UQz2aVRRre7pThVfHLQu+ABQPNNpM=;
        b=UvAGFeUzwu29xuA5iedMZISNfjlxStZyU2NV345qEIqX4B6u3m/VzE9E58X0/S6RwV
         CiTQQulpHXjSchB7Ub4oBSFCVdswTdMPhW9K3CB9U0WfPb0VEOTLoJdO/ko+btTHuA8u
         +zrMqfxgxcDSJTT5pQbycencmS2OpxF6b8GbTJ625tjYW4hqljDRIvlizrGAJP2PTuSr
         Z/Aykvapa4tQzIXLA3SH6qyteI7OgwZD+j89M9y6spO1csjF+apRY+DyVrqhz96tnQPb
         O1LNulG63O94+jzLevoiczTlQmWNNiHNJHerV/nkbIe/6p/2NejHMjMWP/ObAG/s6Vni
         wtrQ==
X-Gm-Message-State: AJIora96gPQBX/zRxUy37UmLQ2AvFMzxxwQ6Z+6jQLy1nPDZWikVboln
        XDdpLyojgsFQ3qgLWg86FvF04Q==
X-Google-Smtp-Source: AGRyM1s+hXqcq2Xyg6cYhNLKRigngS/2t05qB058vSHVJl/t1uUVlg5ZrhARR2xmzNBdZRH402kWTw==
X-Received: by 2002:a05:6a00:e8f:b0:528:a1c7:3d00 with SMTP id bo15-20020a056a000e8f00b00528a1c73d00mr34920341pfb.25.1658269302103;
        Tue, 19 Jul 2022 15:21:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00528c22fbb45sm12215669pfk.141.2022.07.19.15.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 15:21:41 -0700 (PDT)
Date:   Tue, 19 Jul 2022 22:21:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 05/12] KVM: X86/MMU: Link PAE root pagetable with its
 children
Message-ID: <YtcucpRhgVuucaaP@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-6-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-6-jiangshanlai@gmail.com>
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

The shortlog is very misleading.  This patch doesn't "Link PAE root pagetable with
its children", it adds support for creating PAE PDPTEs in order to link them into
shadow pages, but it doesn't do the actual linking.

  KVM: x86/mmu: Add support for linking PAE PDPTE shadow pages

On Sat, May 21, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> When local shadow pages are activated, link_shadow_page() might link
> a local shadow pages which is the PAE root for PAE paging with its
> children.
> 
> Add make_pae_pdpte() to handle it.
> 
> The code is not activated since local shadow pages are not activated
> yet.

And though it's redudnant with other context, IMO it's helpful to again reiterate
why this will be used for per-vCPU (local) shadow pages, i.e. why it's _not_ used
right now.

  Add support for installing PDPTEs via link_shadow_page(), PDPTEs have
  different layouts than every other entry type and so need a dedicated
  helper to make them.

  This code will become active when a future patch activates per-vCPU
  shadow pages and stops using so called "special" roots (which are
  installed at root allocation, not via link_shadow_page()).

> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  | 6 +++++-
>  arch/x86/kvm/mmu/spte.c | 7 +++++++
>  arch/x86/kvm/mmu/spte.h | 1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c941a5931bc3..e1a059dd9621 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2340,7 +2340,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
>  
> -	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> +	if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
> +		     vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL))
> +		spte = make_pae_pdpte(sp->spt);
> +	else
> +		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
>  
>  	mmu_spte_set(sptep, spte);
>  
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index b5960bbde7f7..5c31fa1d2b61 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -279,6 +279,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
>  	return child_spte;
>  }
>  
> +u64 make_pae_pdpte(u64 *child_pt)
> +{
> +	/* The only ignore bits in PDPTE are 11:9. */

s/ignore/ignored, though it might be worth calling out that unlike 64-bit paging,
the upper bits bits are reserved (I always forget this).

	/*
	 * Only PDPTE bits 11:9 are ignored by hardware.  Unlike 64-bit paging,
	 * bits above the PA bits are reserved.
	 */

> +	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
> +	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
> +		shadow_me_value;
> +}
>  
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
>  {
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 0127bb6e3c7d..2408ba1361d5 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -426,6 +426,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
>  	       bool host_writable, u64 *new_spte);
>  u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
> +u64 make_pae_pdpte(u64 *child_pt);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> -- 
> 2.19.1.6.gb485710b
> 
