Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ECB3A714A
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 23:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhFNVZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 17:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhFNVZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 17:25:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA342C061574
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:23:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k22-20020a17090aef16b0290163512accedso637523pjz.0
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yfyhEeTvxVZokhtepH7+msQnDmfJTecfyzHzwveJgxM=;
        b=fU6a0wxmPYZbCgAc3dxBv84xBx57UCoGnjlm+vBWQjd7MFRAFslYHBUYi7naJrgq/K
         535RifIg673xIvbjmNDI6vIe7LAKmFpLZaa+RiLb+0HOylcBROYNN6PGopjktvDKYxyZ
         l63pDudjIcxvcbsx7uHjh2tQ360gQg1dUgzIqvxMAIXmZUeK1Ozm3pho5n/orvlIb0WY
         f3kZnnxbK3W4nM2Bm9e2QZIX2YlD9OrApoGhwN01P3QtYMI4maJ9/yCdMILNZSQwZ+TW
         04AnIh8CxnAm+NdcSXFzuwksBPFMK7bbC//7wwuPMHq9I6CqrhShL+n6AqGhTT9NeE39
         BdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yfyhEeTvxVZokhtepH7+msQnDmfJTecfyzHzwveJgxM=;
        b=JyF+/mFgs9D6n6iCE1q4Twsd1CZBBLpoMqWYOyHFrAzhszeiUlHBY4mVoZUpkF4Is6
         e7hkNG4C9+fHaoaubdFpdddMUu9uS0b7XjRsh7BRfLAP8vu/pU10Lb85LwL2wT9ddwfo
         RZHir2uo7hy/fpwd+3RanuvQ8I9+C5bwXWE6F/b9gOPeMLR9+sZosVVrocKkS7cOZqWJ
         ryz8dODm8Mj0KyLkYovyoTb3PwjOXIMALDgH/LG1db377rHkSHk1Pkv4bB0/+nF0WlJY
         tbHgu9Zg7FTyjuIGCYF2BxjxBjIeFVJT7DNQ3QfD9kFKTU3xXB8+2wCohvMNCjQ6X/J8
         91xA==
X-Gm-Message-State: AOAM533OUrxo3eAh1YAn5+GShTb3nKE9XEQyK9UG0ecL5yqXAl8zyAUZ
        EryKUIlaBlhorPwrE2JrylAZVA==
X-Google-Smtp-Source: ABdhPJwNDzg33AYOJ0dLD7+VTdhzW+jM+K+H38zZ8bAF2KH5dt5jEzUu5EzDbJ81v5NN0kZVsiZfbw==
X-Received: by 2002:a17:90b:fd4:: with SMTP id gd20mr1178166pjb.24.1623705800185;
        Mon, 14 Jun 2021 14:23:20 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 203sm13320274pfw.124.2021.06.14.14.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:23:19 -0700 (PDT)
Date:   Mon, 14 Jun 2021 21:23:15 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Refactor is_tdp_mmu_root()
Message-ID: <YMfIw3Evf6JK78JR@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-2-dmatlack@google.com>
 <YMepDK40DLkD4DSy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMepDK40DLkD4DSy@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 07:07:56PM +0000, Sean Christopherson wrote:
> On Fri, Jun 11, 2021, David Matlack wrote:
> > Refactor is_tdp_mmu_root() into is_vcpu_using_tdp_mmu() to reduce
> > duplicated code at call sites and make the code more readable.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 10 +++++-----
> >  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++---
> >  3 files changed, 11 insertions(+), 9 deletions(-)
> > 
> 
> ...

I'm not sure how to interpret this.

> 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index 5fdf63090451..c8cf12809fcf 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -91,16 +91,18 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
> >  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
> >  #endif
> >  
> > -static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> > +static inline bool is_vcpu_using_tdp_mmu(struct kvm_vcpu *vcpu)
> 
> I normally like code reduction, but I think in this case we should stay with
> something closer to the existing code.
> 
> If interpreted literally as "is the vCPU using the TDP MMU", the helper is flat
> out broken if arch.mmu points at guest_mmu, in which case the function will
> evaluate "false" even if the _vCPU_ is using the TDP MMU for the non-nested MMU.

Good point. is_vcpu_using_tdp_mmu is ambiguous: It's not clear if it's
checking if the vcpu is using the TDP MMU "right now" versus "at all".

> 
> We could dance around that by doing something like:
> 
> 	if (is_current_mmu_tdp_mmu(vcpu))
> 		....
> 
> but IMO that's a net negative versus:
> 
> 	if (is_tdp_mmu(vcpu, vcpu->arch.mmu))
> 		...
> 
> because it's specifically the MMU that is of interest.

I agree this is more clear.

> 
> >  {
> > +	struct kvm *kvm = vcpu->kvm;
> >  	struct kvm_mmu_page *sp;
> > +	hpa_t root_hpa = vcpu->arch.mmu->root_hpa;
> >  
> >  	if (!is_tdp_mmu_enabled(kvm))
> 
> If we want to eliminate the second param from the prototype, I think we'd be
> better off evaluating whether or not this check buys us anything.  Or even better,
> eliminate redundant calls to minimize the benefits so that the "fast" check is
> unnecessary.
> 
> The extra check in kvm_tdp_mmu_map() can simply be dropped; it's sole caller
> literally wraps it with a is_tdp_mmu... check.
> 
> >  		return false;
> > -	if (WARN_ON(!VALID_PAGE(hpa)))
> > +	if (WARN_ON(!VALID_PAGE(root_hpa)))
> 
> And hoist this check out of is_tdp_mmu().  I think it's entirely reasonable to
> expect the caller to first test the validity of the root before caring about
> whether it's a TDP MMU or legacy MMU.
> 
> The VALID_PAGE() checks here and in__direct_map() and FNAME(page_fault) are also
> mostly worthless, but they're at least a marginally not-awful sanity check and
> not fully redundant.
> 
> E.g. achieve this over 2-4 patches:

Thanks for the suggestions, I'll take a look at cleaning that up. I am
thinking of making that a separate patch series (including removing this
patch from this series) as the interaction between the two is entirely
superficial. Let me know if that makes sense.

> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f96fc3cd5c18..527305c8cede 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2899,9 +2899,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         gfn_t gfn = gpa >> PAGE_SHIFT;
>         gfn_t base_gfn = gfn;
> 
> -       if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> -               return RET_PF_RETRY;
> -
>         level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
>                                         huge_page_disallowed, &req_level);
> 
> @@ -3635,7 +3632,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>                 return reserved;
>         }
> 
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_tdp_mmu(vcpu->arch.mmu))
>                 leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
>         else
>                 leaf = get_walk(vcpu, addr, sptes, &root);
> @@ -3801,6 +3798,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                              bool prefault, int max_level, bool is_tdp)
>  {
> +       bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
>         bool write = error_code & PFERR_WRITE_MASK;
>         bool map_writable;
> 
> @@ -3810,10 +3808,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         hva_t hva;
>         int r;
> 
> +       if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> +               return RET_PF_RETRY;
> +
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
> 
> -       if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
> +       if (!is_tdp_mmu_fault) {
>                 r = fast_page_fault(vcpu, gpa, error_code);
>                 if (r != RET_PF_INVALID)
>                         return r;
> @@ -3835,7 +3836,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> 
>         r = RET_PF_RETRY;
> 
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_tdp_mmu_fault)
>                 read_lock(&vcpu->kvm->mmu_lock);
>         else
>                 write_lock(&vcpu->kvm->mmu_lock);
> @@ -3846,7 +3847,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (r)
>                 goto out_unlock;
> 
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_tdp_mmu_fault)
>                 r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
>                                     pfn, prefault);
>         else
> @@ -3854,7 +3855,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                                  prefault, is_tdp);
> 
>  out_unlock:
> -       if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> +       if (is_tdp_mmu_fault)
>                 read_unlock(&vcpu->kvm->mmu_lock);
>         else
>                 write_unlock(&vcpu->kvm->mmu_lock);
> 		diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index cc13e001f3de..7ce90bc50774 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -979,11 +979,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         int level;
>         int req_level;
> 
> -       if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> -               return RET_PF_RETRY;
> -       if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
> -               return RET_PF_RETRY;
> -
>         level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
>                                         huge_page_disallowed, &req_level);
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index f7a7990da11d..6ebe2331a641 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -92,16 +92,11 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  #endif
> 
> -static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> +static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  {
>         struct kvm_mmu_page *sp;
> 
> -       if (!is_tdp_mmu_enabled(kvm))
> -               return false;
> -       if (WARN_ON(!VALID_PAGE(hpa)))
> -               return false;
> -
> -       sp = to_shadow_page(hpa);
> +       sp = to_shadow_page(mmu->root_hpa);
>         if (WARN_ON(!sp))
>                 return false;
> 
