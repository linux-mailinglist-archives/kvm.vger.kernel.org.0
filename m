Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752154EA237
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 23:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiC1VGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 17:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiC1VGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 17:06:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC257B35
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 14:04:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so672479pjo.2
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 14:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JXiZLyVcTv3cYa39mjggFsDeKk+fw8s9JjdGqHNpG80=;
        b=bClxg11Nnfo7j1cKJwJ4jY71QexPwYK77hxirTMRK3jKmt7vBlue13dO8t1feTRUP7
         InfZvOXFrGDgFXTLHDyRR47C9NgqeLQ/4nAaWWENT3uoPTQQXHMYsKnZrpoie5KiZRuw
         vDHgvU0REass3htGtzM6CsDEO44b+obMRjsYr54WXw8oiFmIuD8S9OcD21UI0UPjTEF/
         hB34HAoQz/TYryhjN+BKoKJMVa0xTPB6NPgit6zM08EHLygeZgi1fvZpEVw5OWP3kfyy
         ml/A2fH0Ql4WMRcmt2DOrwpRO/SMmpqfo4EfCwjJHJuaDU4qdxV1mShYhD7s1F8lwZG3
         P4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JXiZLyVcTv3cYa39mjggFsDeKk+fw8s9JjdGqHNpG80=;
        b=Fv280BWLpT/SUIm0Ir9BstYTBvRt+kPmYFJm81WXUqBUybBdxIS1Ks4WUtlfPS2k0j
         /xobL4jatHy/sztJ/L6CbdFdE76gh4v574OCZ9Bd4siHQTQIFgEaMM7heBIbKlzp8IkG
         YhS/FmwCmxcWtG//KgSfb9zYoxS2danURLXx2JCQYChW4z8L5zHDZo5YB4yP6ahx2xDs
         TaNLzB35OB9hw9ZBN/4gv8Gr2QM+JT44RK7lcjKb6q1zj9fDD6yvqs5u1YvOuF/MfHmi
         +U7YVtItu7s/ziNSUPC1YLYGWIek49rDNFYhfD7J5yDhsq3ZmKVGdd9k4ijTVBQ+Egvp
         GAUg==
X-Gm-Message-State: AOAM530NGuKsIQMpynIwY8G8JssWM90538KNY2PE3qtJlvEFZM24Llto
        li7NWlzQ2gm/gIjkoeBFHs6ojQ==
X-Google-Smtp-Source: ABdhPJwRrK8f6T+jicAi2bq4mRd8vAXaIvf6IHbol1O4iaEjSABKVsNSMwKhoHUWr6L5OmWyKgtpYw==
X-Received: by 2002:a17:90b:38c9:b0:1c7:1ffb:533b with SMTP id nn9-20020a17090b38c900b001c71ffb533bmr1026681pjb.220.1648501463880;
        Mon, 28 Mar 2022 14:04:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d2-20020a056a0024c200b004f6b6817549sm18217058pfv.173.2022.03.28.14.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 14:04:23 -0700 (PDT)
Date:   Mon, 28 Mar 2022 21:04:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 2/9] KVM: x86/mmu: Move hugepage adjust to
 direct_page_fault
Message-ID: <YkIi0+O4BlWu2sBF@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-3-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308043857.13652-3-nikunj@amd.com>
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

On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
> Both TDP MMU and legacy MMU do hugepage adjust in the mapping routine.
> Adjust the pfn early in the common code. This will be used by the
> following patches for pinning the pages.
> 
> No functional change intended.

There is a functional change here, as kvm_mmu_hugepage_adjust() is now called
without mmu_lock being held.  That really shouldn't be problematic, but sadly KVM
very, very subtly relies on calling lookup_address_in_mm() while holding mmu_lock
_and_ after checking mmu_notifier_retry_hva().

https://lore.kernel.org/all/CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8e24f73bf60b..db1feecd6fed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2940,8 +2940,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	int ret;
>  	gfn_t base_gfn = fault->gfn;
>  
> -	kvm_mmu_hugepage_adjust(vcpu, fault);
> -
>  	trace_kvm_mmu_spte_requested(fault);
>  	for_each_shadow_entry(vcpu, fault->addr, it) {
>  		/*
> @@ -4035,6 +4033,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  	r = RET_PF_RETRY;
>  
> +	kvm_mmu_hugepage_adjust(vcpu, fault);
> +
>  	if (is_tdp_mmu_fault)
>  		read_lock(&vcpu->kvm->mmu_lock);
>  	else
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bc9e3553fba2..e03bf59b2f81 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -959,8 +959,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	u64 new_spte;
>  	int ret;
>  
> -	kvm_mmu_hugepage_adjust(vcpu, fault);
> -
>  	trace_kvm_mmu_spte_requested(fault);
>  
>  	rcu_read_lock();
> -- 
> 2.32.0
> 
