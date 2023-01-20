Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D136748B9
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 02:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjATBSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 20:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjATBSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 20:18:52 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD6CA45F2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:18:49 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id a9-20020a17090a740900b0022a0e51fb17so947915pjg.3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EIvtGhQ863eAgHEBR7gzw1wvWAHw06RQf9S7Ko277YM=;
        b=nl3mSBo+1nhS4sKoPUAOfZK2zUSyaVHWy3zd27RXkDikAieQupMoh/UL3hTocVJreJ
         e7dNjgHsUh+3mu2+eRc3i4/4Tufja81lu31S4InlmwaRPXghWUKDtuxGrunC8JCvpwpX
         DRUGdS1K6U3WJqn/tI9GWEW6ekSURLxeO8D0/rO41uxg1G9kSSAxZeU7620G/v3kCWRt
         XIcRyKYWWG3P3DiStnr6SmTdgtXWNwg/GIC6QwICEZs30gcgD17A6+2LHdTY5f6vdVtK
         qySjAkqFEF9vDBnytSeVK1Ve21Z0ehQDrl6FHYK0g0OLI4rBTKyxMkwsV730XJ7/Rk88
         7ZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIvtGhQ863eAgHEBR7gzw1wvWAHw06RQf9S7Ko277YM=;
        b=SZ4mkscz9/fiLxQQoMwycabmybgzVJaXuUbUPa3jmFbe8GRJ6YCbsTvdUJRyQb15We
         7K0O5i4U2ZhoCkX6nIOw2HCRVXMQHM5NotsVO8cuMrCDC2YJO9zRrPBb6iMqTsZN8cWj
         i/PpFh16Jk0IgL9JwDwPWobkKP6hsDjT7dWh+RVo0Bt0JvsBcgkdrvO2cGoNOow17avw
         /kSxrUsrbvi5Nh9OoMvrXt0CTAR1TWIBXCqDWhIx/UbJzrZvUVbdBSg7NEinDE5awJ/M
         GFzzD4TJj/W5ot0HLBdUxAXxWV87gy+XJJ3NxZy5KO0SNR8se8l4LE03Hr/FvPBlN9rc
         J5rQ==
X-Gm-Message-State: AFqh2kpOhGCvIPk0pfcEx0zxshFxv54SPUySTXSGDeoZljMSbZdQWDGz
        4nPGYxoPksTt8T6RZzLnAAY9vzPCJyoF3ib8kGU=
X-Google-Smtp-Source: AMrXdXtFneiKO3u0VL/FOlu+x06cPnFN5v62BvDxPDdRlscyXkFcGkAc5iAOuQfRIBcL/ViL8im7oA==
X-Received: by 2002:a05:6a21:9214:b0:b8:c3c0:e7f7 with SMTP id tl20-20020a056a21921400b000b8c3c0e7f7mr8746pzb.1.1674177528978;
        Thu, 19 Jan 2023 17:18:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902ea0200b00192a96f4916sm7382638plg.259.2023.01.19.17.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 17:18:48 -0800 (PST)
Date:   Fri, 20 Jan 2023 01:18:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct
 mode
Message-ID: <Y8nr9SZAnUguf3qU@google.com>
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+David and Ben

On Tue, Dec 06, 2022, Yu Zhang wrote:
> Simplify the code by introducing a wrapper, mmu_is_direct(),
> instead of using vcpu->arch.mmu->root_role.direct everywhere.
> 
> Meanwhile, use temporary variable 'direct', in routines such
> as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
> vcpu->arch.mmu->root_role.direct repeatedly.

I've looked at this patch at least four times and still can't decide whether or
not I like the helper.  On one had, it's shorter and easier to read.  On the other
hand, I don't love that mmu_is_nested() looks at a completely different MMU, which
is weird if not confusing.

Anyone else have an opinion?

> No functional change intended.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
>  arch/x86/kvm/x86.c     |  9 +++++----
>  arch/x86/kvm/x86.h     |  5 +++++
>  3 files changed, 23 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4736d7849c60..d2d0fabdb702 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2280,7 +2280,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  
>  	if (iterator->level >= PT64_ROOT_4LEVEL &&
>  	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
> -	    !vcpu->arch.mmu->root_role.direct)
> +	    !mmu_is_direct(vcpu))
>  		iterator->level = PT32E_ROOT_LEVEL;
>  
>  	if (iterator->level == PT32E_ROOT_LEVEL) {
> @@ -2677,7 +2677,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
>  	gpa_t gpa;
>  	int r;
>  
> -	if (vcpu->arch.mmu->root_role.direct)
> +	if (mmu_is_direct(vcpu))
>  		return 0;
>  
>  	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> @@ -3918,7 +3918,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_mmu_page *sp;
>  
> -	if (vcpu->arch.mmu->root_role.direct)
> +	if (mmu_is_direct(vcpu))
>  		return;
>  
>  	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
> @@ -4147,7 +4147,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	arch.token = alloc_apf_token(vcpu);
>  	arch.gfn = gfn;
> -	arch.direct_map = vcpu->arch.mmu->root_role.direct;
> +	arch.direct_map = mmu_is_direct(vcpu);
>  	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
>  
>  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> @@ -4157,17 +4157,16 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
> +	bool direct = mmu_is_direct(vcpu);

I would prefer to not add local bools and instead due a 1:1 replacement.  "direct"
loses too much context (direct what?), and performance wise I doubt it will
influence the compiler.
