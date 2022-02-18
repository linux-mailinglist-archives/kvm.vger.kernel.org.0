Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89DD4BBF0B
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbiBRSJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:09:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiBRSJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:09:18 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898DF26553C
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:09:01 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u16so2888479pfg.12
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AlHyiX5LrdEWhZ9Co3lMbGLFgIDtYexqf1L/CNhQw3E=;
        b=HpvXBj1VHVYEWtTw1OGbUHeNyUjkoPhx6+l1cPDm/SKWtBGjlpYKkuOh3pRmcOKi9z
         F40QfcVvdWBWUNVIEX9nKE5hOSXpxQz8i162U8F6hoEIFmdxfJd6JWbcRFL7oVVRnTdt
         CCSHf0ggP8hdfxU87dEL8nMyGEn72hNsaUe7BFlUb8acpAA7heOEu4k3ioLRzXRa2qsB
         mw3xqtflLxDYgP6z0Xe08Wb12/UJ2iMr2vs5BJ9R8N+hpiSJIiniTmUZb9pffGR3Rq4Y
         fcIbvyCO3jkVqqSazurJIQYMy1/qNWfsoNG8njWZsphJo+nSdMwgJsMBiMMl8BMmAZ9r
         wGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AlHyiX5LrdEWhZ9Co3lMbGLFgIDtYexqf1L/CNhQw3E=;
        b=yf6zxh6Kb5xT5yrUxoWSF0a7XZQJxOFbklPpLKkXhoArbobhiCC6O5FJAxO1A7c45m
         GHUHR1ur8Q9eFk8gNS+ku7TDSSo2J12yOxGpYbgRU9sShGCxI7/8k7W6674NedIP8S4D
         Pq7KnC+oufG0yHbstFk9IlqIgIgmgIHBqbw35+Fwiquymlm6WbgZ+0a6hzsJG4dLmiEw
         ZyL6ZzeLKjfAV2yl0hfJ2yyaHCRmdYt6hRo21AJ2vO9BhXgfVSx09VXIyJ6bUVTjhzHy
         1ZXv3AdhrZDAIdEojWAWdu6bK5KaMSAQ9nEsv5HqoirP/a2EOXrTINj5OldzSAQGXyF1
         JSWw==
X-Gm-Message-State: AOAM531LxkB9WqqhroDEu5RGNr+8MftstCt298pqBFpUD7edcSz9k3iL
        mBMAAr8+um6a9B4S1IKpxPsZpw==
X-Google-Smtp-Source: ABdhPJyBlmVUgv9BMdbLQgS/63ZmOTggTRvnwzOGFX3es6MawMFCoUFF5HCPCGoOdjMTYq6JBZ3hyA==
X-Received: by 2002:a63:e30b:0:b0:34a:e4d9:c0c8 with SMTP id f11-20020a63e30b000000b0034ae4d9c0c8mr7391562pgh.54.1645207740765;
        Fri, 18 Feb 2022 10:09:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ob12sm95751pjb.5.2022.02.18.10.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:09:00 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:08:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 09/18] KVM: x86/mmu: look for a cached PGD when going
 from 32-bit to 64-bit
Message-ID: <Yg/guAXFLJBmDflh@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-10-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Right now, PGD caching avoids placing a PAE root in the cache by using the
> old value of mmu->root_level and mmu->shadow_root_level; it does not look
> for a cached PGD if the old root is a PAE one, and then frees it using
> kvm_mmu_free_roots.
> 
> Change the logic instead to free the uncacheable root early.
> This way, __kvm_new_mmu_pgd is able to look up the cache when going from
> 32-bit to 64-bit (if there is a hit, the invalid root becomes the least
> recently used).  An example of this is nested virtualization with shadow
> paging, when a 64-bit L1 runs a 32-bit L2.
> 
> As a side effect (which is actually the reason why this patch was
> written), PGD caching does not use the old value of mmu->root_level
> and mmu->shadow_root_level anymore.

Maybe another blurb on 5=>4-level nNPT being broken?  I'm also ok omitting it.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *mmu,
> +					      gpa_t new_pgd,
> +					      union kvm_mmu_page_role new_role)
>  {
>  	uint i;
> -	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  
>  	if (is_root_usable(&mmu->root, new_pgd, new_role))
>  		return true;
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> +		/*
> +		 * The swaps end up rotating the cache like this:
> +		 *   C   0 1 2 3   (on entry to the function)
> +		 *   0   C 1 2 3
> +		 *   1   C 0 2 3
> +		 *   2   C 0 1 3
> +		 *   3   C 0 1 2   (on exit from the loop)
> +		 */
>  		swap(mmu->root, mmu->prev_roots[i]);
> -

I'd prefer we keep this whitespace, I like that it separates the swap() and its
comment from the usability check.

>  		if (is_root_usable(&mmu->root, new_pgd, new_role))
> -			break;
> +			return true;
>  	}
>  
> -	return i < KVM_MMU_NUM_PREV_ROOTS;
> +	kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
> +	return false;
>  }
>  
> -static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> -			    union kvm_mmu_page_role new_role)
> +/*
> + * Find out if a previously cached root matching the new pgd/role is available.
> + * On entry, mmu->root is invalid.
> + * If a matching root is found, it is assigned to kvm_mmu->root, the LRU entry
> + * of the cache becomes invalid, and true is returned.
> + * If no match is found, kvm_mmu->root is left invalid and false is returned.
> + */
> +static bool cached_root_find_without_current(struct kvm *kvm, struct kvm_mmu *mmu,
> +					     gpa_t new_pgd,
> +					     union kvm_mmu_page_role new_role)
>  {
> -	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	uint i;
> +
> +	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +		if (is_root_usable(&mmu->prev_roots[i], new_pgd, new_role))
> +			goto hit;

The for-loop needs curly braces.

>  
> +	return false;
> +
> +hit:
> +	swap(mmu->root, mmu->prev_roots[i]);
> +	/* Bubble up the remaining roots.  */
> +	for (; i < KVM_MMU_NUM_PREV_ROOTS - 1; i++)
> +		mmu->prev_roots[i] = mmu->prev_roots[i + 1];
> +	mmu->prev_roots[i].hpa = INVALID_PAGE;
> +	return true;
> +}
> +
> +static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
> +			    gpa_t new_pgd, union kvm_mmu_page_role new_role)
> +{
>  	/*
> -	 * For now, limit the fast switch to 64-bit hosts+VMs in order to avoid
> +	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
>  	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
>  	 * later if necessary.
>  	 */
> -	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> -	    mmu->root_level >= PT64_ROOT_4LEVEL)
> -		return cached_root_available(vcpu, new_pgd, new_role);
> +	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  
> -	return false;
> +	if (VALID_PAGE(mmu->root.hpa))
> +		return cached_root_find_and_keep_current(kvm, mmu, new_pgd, new_role);
> +	else
> +		return cached_root_find_without_current(kvm, mmu, new_pgd, new_role);
>  }
>  
>  static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> @@ -4160,8 +4196,8 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  
> -	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
> -		kvm_mmu_free_roots(vcpu->kvm, mmu, KVM_MMU_ROOT_CURRENT);
> +	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
> +		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */

The "kvm_mmu_ensure_valid_pgd" part is stale due to the bikeshedding stalemate.
Maybe reference vcpu_enter_guest() instead?  E.g.

	/*
	 * If no usable root is found there's nothing more to do, a new root
	 * will be set up during vcpu_enter_guest(), prior to the next VM-Enter.
	 */
	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role))
		return;
