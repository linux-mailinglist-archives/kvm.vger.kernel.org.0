Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC32EC5BC
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 22:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbhAFVaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 16:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbhAFVai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 16:30:38 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A47C061575
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 13:29:58 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c79so2468511pfc.2
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 13:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oKwFg1foqPPQlWIN0jba7AoqjGdlRQ7YxJt5702//gk=;
        b=PcvabGtplXxFEbb1VDcktLNut0BuCBy11Zvvm7QukHEVYX+bb+s0yuezHzIcRNtnqh
         rxVzRacRBE2oI5N2Ubz/cmIRYLFqmanuelgEievD5t6qZyaZM5GrABwf05O8jMsuAWNm
         AIg8wR5opjJ99sDxl/Gw5LDwDeLGN+dWdO05KHUwHjvb3lhVP+ihzwtx4KkdADvXazPd
         Er3u3zRoI55W0ai5MT6LZg9tD8KsZO+N3FTBaVKFtn0a5Uw0vT+t2b9Q5pM79CCKSarL
         HEOtQwA8nuQpoMIHbTBmspTQ2RlfHxS5jGAZz5XrcGlI5fYLFFaPtTqHszHZtdrTcmCR
         IGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oKwFg1foqPPQlWIN0jba7AoqjGdlRQ7YxJt5702//gk=;
        b=czoOsptUaND4qnKrwt8IxPKgPTyDtiuwc2fxvCUmJRL1bZqlL9Kq722XfqroxSqA1Y
         WbMXsOY74k0FRk7xrGKGvoumq2l3hcgnytmh+cxK/3oSoNov+wGt8FkiIXWN60RAEpBC
         eKfnwffF53ad+U8BUZSaR4qwuhgVxEbBrWzdVgeEIJssoUKjQoDIg68gGZc2O6W+VMXH
         XaOYOek+dz3ppHQdLgXTuRCKxSNJg/xqSJV35I0tV3tg95sbuYvuRpPYF3+f4u/cqimK
         SK7WS4mduGmjm1/46jpdxkM0dI7R9jmfOpmVSCvc5Uv5LrmIbpx48sU+yl/Hbd5nqY0K
         AhOA==
X-Gm-Message-State: AOAM531m1SFN5TIJYRNJNLOJYqVzl297i92775h34fL002r2Ur8j2c6W
        Qbadg2QV964/gRjz/+0PoFMN+DrTEPqfvg==
X-Google-Smtp-Source: ABdhPJxSvFR4x+2YGtqxVR32iAzT2P3QhwiWaRIoUe6V6gqzwuHr/UgO3aZEEVp6KjFUPwX61NZLmg==
X-Received: by 2002:a63:1f47:: with SMTP id q7mr6515888pgm.10.1609968597827;
        Wed, 06 Jan 2021 13:29:57 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id t6sm2900646pjg.49.2021.01.06.13.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 13:29:57 -0800 (PST)
Date:   Wed, 6 Jan 2021 13:29:50 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed
 after yield
Message-ID: <X/Yrzgli82BOBgiJ@google.com>
References: <20210106185951.2966575-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106185951.2966575-1-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Ben Gardon wrote:
> Many TDP MMU functions which need to perform some action on all TDP MMU
> roots hold a reference on that root so that they can safely drop the MMU
> lock in order to yield to other threads. However, when releasing the
> reference on the root, there is a bug: the root will not be freed even
> if its reference count (root_count) is reduced to 0.
> 
> To simplify acquiring and releasing references on TDP MMU root pages, and
> to ensure that these roots are properly freed, move the get/put operations
> into the TDP MMU root iterator macro. Not all functions which use the macro
> currently get and put a reference to the root, but adding this behavior is
> harmless.

I wouldn't say it's harmless, it creates the potential for refcount leaks where
they otherwise wouldn't be possible (the early loop exit scenario).  Not saying
this is the wrong approach, just that it's not without downsides.

Maybe preemptively add tdp_mmu_root_iter_break(), which would just be a wrapper
around kvm_mmu_put_root(), but might help readability (if it's ever needed)?
Not sure that's a good idea, someone will probably just remove the dead code in
the future :-)

> Moving the get/put operations into the iterator macro also helps
> simplify control flow when a root does need to be freed. Note that using
> the list_for_each_entry_unsafe macro would not have been appropriate in

s/list_for_each_entry_unsafe/list_for_each_entry_safe

> this situation because it could keep a reference to the next root across
> an MMU lock release + reacquire.

Use of "reference" is a confusing; above it means refcounts, here it means a
pointer _without_ an elevated refcount.  Something like this?

  ... would not have been apprporiate in this situation because it could keep
  a pointer to the next root across an MMU lock release + reacquire without
  pinning the next root.

> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
> Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 97 +++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 75db27fda8f3..6e076b66973c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -44,8 +44,44 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  }
>  
> -#define for_each_tdp_mmu_root(_kvm, _root)			    \
> -	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
> +static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +	if (kvm_mmu_put_root(kvm, root))
> +		kvm_tdp_mmu_free_root(kvm, root);
> +}
> +
> +static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
> +					   struct kvm_mmu_page *root)
> +{

Maybe add lockdep annotations here?  A couple callers already have 'em.

> +	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
> +		return false;
> +
> +	kvm_mmu_get_root(kvm, root);
> +	return true;
> +
> +}
> +
> +static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> +						     struct kvm_mmu_page *root)
> +{
> +	struct kvm_mmu_page *next_root;
> +
> +	next_root = list_next_entry(root, link);
> +	tdp_mmu_put_root(kvm, root);
> +	return next_root;
> +}
> +
> +/*
> + * Note: this iterator gets and puts references to the roots it iterates over.
> + * This makes it safe to release the MMU lock and yield within the loop, but
> + * if exiting the loop early, the caller must drop the reference to the most
> + * recent root. (Unless keeping a live reference is desirable.)
> + */
> +#define for_each_tdp_mmu_root(_kvm, _root)				\
> +	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
> +				      typeof(*_root), link);		\
> +	     tdp_mmu_next_root_valid(_kvm, _root);			\
> +	     _root = tdp_mmu_next_root(_kvm, _root))
>  
>  bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>  {
> @@ -128,7 +164,11 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
>  	/* Check for an existing root before allocating a new one. */
>  	for_each_tdp_mmu_root(kvm, root) {
>  		if (root->role.word == role.word) {
> -			kvm_mmu_get_root(kvm, root);
> +			/*
> +			 * The iterator already acquired a reference to this
> +			 * root, so simply return early without dropping the
> +			 * reference.
> +			 */
>  			spin_unlock(&kvm->mmu_lock);

I vote to open code use of list_for_each_entry() for this one specific case,
it's very much a one-off flow (relative to the other iteration scenarios).

>  			return root;
>  		}
