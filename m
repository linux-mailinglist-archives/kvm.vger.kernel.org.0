Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5C03E2F10
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 19:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbhHFR6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 13:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242327AbhHFR6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 13:58:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347C7C0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 10:58:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso15290795pjb.5
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 10:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yfna8yy9OoeQ4INvTxTB1CGlw6p6Y9Y6Ed68sMQ7pCo=;
        b=DV4aSUeO3M3CtpHbLENmzzGKiCh6c6idfhVfuaZuKX+V56K+V7ov54u1brCsL/4niS
         RTHZjSckoxGcGueQuWbyYfq4Yk4UYkrwKNdnA7lqEAodu1Ne7Wg+RakAGQBs1quwkIkK
         lcTjtG9/W5IU8o79PMQzNdftPtlLgG60eX8Gc/p/F0KM2oh6Ud8TvhbJRlLrwinogCkb
         1E7XKjm92EtGAuMrGc5qlAlQK/6B9TJPbynVGMkA8jgfUO/lXnhqOTSrhaIAJyYLLJuT
         0JhxZMpFDEunLJAKBawj5E1nLiO0SkZi81l5c1g8qUkcxs+nisgF7JuSn7leLIi1eXLC
         ioXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yfna8yy9OoeQ4INvTxTB1CGlw6p6Y9Y6Ed68sMQ7pCo=;
        b=dugyYv+fSgAPDISUGJMyF5qB31Cm5iCzmwWBNDLgRCuz2TYYbmilx5vWANstpGGu8n
         oZ4BYwI7T1CP4OLaTG4a9umOI8rJk4LuC5qxnAkZcIIBkkT9iE2VVnxzJfvrSQ3S9dv1
         3vOMzRdKh8Qac16zggGU4Oiq2lhBBlZ4Egg2f2hR/UCZ6j6lKOkTjmBehoaVkFvXTyPp
         MZR97C8UyLMkgU2jP01opx/sFU0MuCitazG0qfFK52K1VR8ClxuzQOrj0lcdgMqogiDg
         OPId8AJk6cQOQTN95hE8Jy31YCfZk1pEtuXKpCvx2kW6TYWnuVCYQib9X+tLwiADBDNg
         aYUQ==
X-Gm-Message-State: AOAM533TyNTVomG1ALfKY4fck89r0n2PSzuVyBPIqPouyj4Z0E7/5HOM
        8WFcvpU8gf3ydBNUmyJ2Cs7+6A==
X-Google-Smtp-Source: ABdhPJwwobT4+HD9q5+WZRVrJxjjkJ6KCI3JBZXUvrVVwzmRGfAZfncglXKdToOX9VKTLv5d13sq6w==
X-Received: by 2002:a17:90a:3fcc:: with SMTP id u12mr21214336pjm.5.1628272714472;
        Fri, 06 Aug 2021 10:58:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ls16sm9797708pjb.49.2021.08.06.10.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 10:58:33 -0700 (PDT)
Date:   Fri, 6 Aug 2021 17:58:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v1 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
Message-ID: <YQ14RmuYxlAydmOu@google.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-3-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805205504.2647362-3-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Wei Huang wrote:
> When the 5-level page table CPU flag is exposed, KVM code needs to handle
> this case by pointing mmu->root_hpa to a properly-constructed 5-level page
> table.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 46 +++++++++++++++++++++++----------
>  2 files changed, 34 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 20ddfbac966e..8586ffdf4de8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -447,6 +447,7 @@ struct kvm_mmu {
>  
>  	u64 *pae_root;
>  	u64 *pml4_root;
> +	u64 *pml5_root;
>  
>  	/*
>  	 * check zero bits on shadow page table entries, these
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 44e4561e41f5..b162c3e530aa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3428,7 +3428,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	 * the shadow page table may be a PAE or a long mode page table.
>  	 */
>  	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
> -	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
> +	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
>  		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
>  
>  		if (WARN_ON_ONCE(!mmu->pml4_root)) {
> @@ -3454,11 +3454,17 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  				      PT32_ROOT_LEVEL, false);
>  		mmu->pae_root[i] = root | pm_mask;
>  	}
> +	mmu->root_hpa = __pa(mmu->pae_root);
>  
> -	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
> +	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> +		mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
>  		mmu->root_hpa = __pa(mmu->pml4_root);
> -	else
> -		mmu->root_hpa = __pa(mmu->pae_root);
> +	}
> +
> +	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
> +		mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
> +		mmu->root_hpa = __pa(mmu->pml5_root);
> +	}

Ouch, the root_hpa chaining is subtle.  That's my fault :-)  I think it would be
better to explicitly chain pae->pml4->pml5?  E.g.

	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;

		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
			mmu->pml5_root[0] = __pa(mmu->pml4_root) | pm_mask;
			mmu->root_hpa = __pa(mmu->pml5_root);
		} else {
			mmu->root_hpa = __pa(mmu->pml4_root);
		}
	} else {
		mmu->root_hpa = __pa(mmu->pae_root);
	}

It'd require more churn if we get to 6-level paging, but that's a risk I'm willing
to take ;-)

>  
>  set_root_pgd:
>  	mmu->root_pgd = root_pgd;
> @@ -3471,7 +3477,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	u64 *pml4_root, *pae_root;
> +	u64 *pml5_root, *pml4_root, *pae_root;
>  
>  	/*
>  	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
> @@ -3487,17 +3493,18 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	 * This mess only works with 4-level paging and needs to be updated to
>  	 * work with 5-level paging.
>  	 */
> -	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
> +	if (WARN_ON_ONCE(mmu->shadow_root_level < PT64_ROOT_4LEVEL)) {

This is amusingly wrong.  The check above this is:

	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)  <--------
		return 0;

meaning this is dead code.  It should simply deleted.  If we reaaaaaly wanted to
future proof the code, we could do:

	if (WARN_ON_ONCE(mmu->shadow_root_level > PT64_ROOT_5LEVEL)
		return -EIO;

but at that point we're looking at a completely different architecture, so I don't
think we need to be that paranoid :-)

>  		return -EIO;
> +	}
>  
> -	if (mmu->pae_root && mmu->pml4_root)
> +	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
>  		return 0;
>  
>  	/*
>  	 * The special roots should always be allocated in concert.  Yell and
>  	 * bail if KVM ends up in a state where only one of the roots is valid.
>  	 */
> -	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
> +	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root || mmu->pml5_root))
>  		return -EIO;
>  
>  	/*
> @@ -3506,18 +3513,30 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>  	 */
>  	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!pae_root)
> -		return -ENOMEM;
> +		goto err_out;

Branching to the error handling here is silly, it's the first allocation.

>  
>  	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> -	if (!pml4_root) {
> -		free_page((unsigned long)pae_root);
> -		return -ENOMEM;
> -	}
> +	if (!pml4_root)
> +		goto err_out;
> +
> +	pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);

This should be guarded by "mmu->shadow_root_level > PT64_ROOT_4LEVEL", there's no
need to waste a page on PML5 if it can't exist.

> +	if (!pml5_root)
> +		goto err_out;
>  
>  	mmu->pae_root = pae_root;
>  	mmu->pml4_root = pml4_root;
> +	mmu->pml5_root = pml5_root;
>  
>  	return 0;
> +err_out:
> +	if (pae_root)
> +		free_page((unsigned long)pae_root);
> +	if (pml4_root)
> +		free_page((unsigned long)pml4_root);
> +	if (pml5_root)
> +		free_page((unsigned long)pml5_root);

This is flawed as failure to allocate pml4_root will consume an uninitialized
pml5_root.  There's also no need to check for non-NULL values as free_page plays
nice with NULL pointers.

If you drop the unnecessary goto for pae_root allocation failure, than this can
become:

err_out:
	free_page((unsigned long)pml4_root);
	free_page((unsigned long)pae_root);

since pml4_root will be NULL if pml4_root allocation failures.  IMO that's
unnecessarily clever though, and a more standard:

err_pml5:
	free_page((unsigned long)pml4_root);
err_pml4:
	free_page((unsigned long)pae_root);
	return -ENOMEM;

would be far easier to read/maintain.

> +
> +	return -ENOMEM;
>  }
>  
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
> @@ -5320,6 +5339,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>  		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
>  	free_page((unsigned long)mmu->pae_root);
>  	free_page((unsigned long)mmu->pml4_root);
> +	free_page((unsigned long)mmu->pml5_root);
>  }
>  
>  static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> -- 
> 2.31.1
> 
