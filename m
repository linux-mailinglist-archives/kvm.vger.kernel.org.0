Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD5A5295A9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 02:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348885AbiEQABZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 20:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238851AbiEQABX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 20:01:23 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C03F33A
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:01:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x23so15448066pff.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IX2wmwvaDyZMh7ib5ZKuwhVkKDHyhdCDkN7AoejMd14=;
        b=QO4M1yV2IkKeIohfCfSn9H3sUzERCQ1hJGTky+xBqF2Rgc4HUQud/A0HZ5mhCRjOC9
         X9PJy3n49zrIzWH5CF1gyUvkBMCgbhctRGm/yJl1gIn2Z9Nib3jcV5NaP4iSz9XhATB/
         lUnlNNq5VqtrQ7JBDpM9kerEriKcO1fQSh6nNcaNjZaFoKMG0/4d1q6sPxPy6MqgLGFp
         K/xv4+vuwxaUGTBLDO3AjcPw0k5uMJxmdbA40w0uaCdxttoP35ebrshjn4E7LQPGsJ8I
         uqkXOlz+jnD1NMvb95PKCI0MDx/uY/+LaOTkepYltMJWWdcD7FOj6IeB14TRA0Bs9m6i
         NUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IX2wmwvaDyZMh7ib5ZKuwhVkKDHyhdCDkN7AoejMd14=;
        b=ZACM0y53gQdGX0K0teWRBE8oVqAW56P6Gnm1LeYq1t304pXc90xgkQm8SLWAHhLDIM
         bckdL/gNSMy4crIKMjq3RPtVShZl0qlxadX9JTSsZaFEOifa121ZdBjsN5RsZeTwAqDo
         9OihKFGr94LJW4V5TjVPN8A84v9iO4SFA7JdsBXWCSJUQVIx52Fr4l7i1xDomjH3Cnt/
         OZiC9/St2GaofJh2VP/6NPP/gtsXYMRLIjm/FC2XQT8TDSamFWwRN/Zs06cGOT0VdKPe
         QMhDTUi5+SFc4735YM/nsiVYp9OwqPiNf3LhQlbUuUcmNG+DOriU4xpoNEFaj7SPsNF5
         EClA==
X-Gm-Message-State: AOAM532gduUJOXEgRnngo8Wk2+smHRxZ9HEzzlWckYEqg2LGz8aknqly
        bD6ZKIZdIiR6GI0eVHqC3jm0Tw==
X-Google-Smtp-Source: ABdhPJzkLlYlwYRPn9ndHoCIDmiWHid04iZptb+cvXrjdGCNaUQpOU5WDN40xqZ+9PaRB0vWiHaVdA==
X-Received: by 2002:a05:6a00:23c6:b0:50f:f570:7ea7 with SMTP id g6-20020a056a0023c600b0050ff5707ea7mr19962149pfc.76.1652745681364;
        Mon, 16 May 2022 17:01:21 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902eb4d00b0015e8d4eb1b9sm7781773pli.3.2022.05.16.17.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 17:01:20 -0700 (PDT)
Date:   Tue, 17 May 2022 00:01:17 +0000
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
Subject: Re: [PATCH V2 3/7] KVM: X86/MMU: Link PAE root pagetable with its
 children
Message-ID: <YoLlzcejEDh8VpoB@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-4-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 11:07:31PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> When special shadow pages are activated, link_shadow_page() might link
> a special shadow pages which is the PAE root for PAE paging with its
> children.
> 
> Add make_pae_pdpte() to handle it.
> 
> The code is not activated since special shadow pages are not activated
> yet.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  | 6 +++++-
>  arch/x86/kvm/mmu/spte.c | 7 +++++++
>  arch/x86/kvm/mmu/spte.h | 1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 126f0cd07f98..3fe70ad3bda2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2277,7 +2277,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
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
> index 75c9e87d446a..ccd9267a58ca 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -251,6 +251,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
>  	return child_spte;
>  }
>  
> +u64 make_pae_pdpte(u64 *child_pt)
> +{
> +	/* The only ignore bits in PDPTE are 11:9. */
> +	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
> +	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
> +		shadow_me_value;

If I'm reading mmu_alloc_{direct,shadow}_roots() correctly, PAE page
directories just get: root | PT_PRESENT_MASK | shadow_me_value. Is there
a reason to add SPTE_MMU_PRESENT_MASK or am I misreading the code?

> +}
>  
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
>  {
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index fbbab180395e..09a7e4ba017a 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -413,6 +413,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
