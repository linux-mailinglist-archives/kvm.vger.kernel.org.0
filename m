Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6154434151
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhJSW0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhJSW0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:26:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4ADC061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:24:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so999266pjb.3
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7DYCUknc3dQUBnoaGeUnyUU/CuK4FgSm2oYsWvbJD5E=;
        b=ba33n7vXoirIraKwU+JkwtO9KxLQ6aPywRIkMDrDzPTXzSRhapzDByeCLM0PAr0rKm
         vAsZVDuWksxGPfUulEA8y14nUsrf6mN7IMNQVc0ccewhv6VJ6gv8mM/dVArwPTmVQAQM
         yw+YYdfPHR8gYaTyH+R7PtJlIPir+cfv2J89mVEQCGGlpR2nGup3mHTZeZAG03rsmqVB
         eyW9W0lbCChrj1bhkyGJd8Ln1F9rQurWt5kc24B9cMXANjtlvOK4eOitvh/itFg08B1j
         BZ4GAgVTcElDI/DWXfuf4kD+zYv9qK76JsHp5fmrqkGTf6YK/D9r+jMY8uCFR36v2AC9
         /9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7DYCUknc3dQUBnoaGeUnyUU/CuK4FgSm2oYsWvbJD5E=;
        b=t0M5+d4Mz1iSUSlEaBw+BAtwa9oiOPoFj6x9TuqtDysWXSmmzqCPjS7BFrQTc2yWI0
         TA/IUtL6F22tFAfHzhrdo1qZu4smaFKlq7viZ3XtY+UAvyVH9HqCLdq78nMRHF2OlpWw
         6Y7UYgOOFUfEdFf9yC6p1JQXKlMz4iMkvV0b0CmFyO/Y55Yw0GPG5hPYcgjCLaN+mZWP
         2GTr29RvXhvqXzD14dYWSUssGC+uUzTg5bGWd0EjbGfTlYPzf2VsmJE3d1WHOf2iR1ha
         /kq619EXhwHUg8NvP3z5+11OU/6E6yDQoz7yJKfCo+sYFvFI/xmEJ0WVROt8b1Ny9k2n
         vSMw==
X-Gm-Message-State: AOAM532OEeAgPh7tDW4oQiN006JSjVhNiA4KnulSjJVDm56OXPVYTWVP
        CLMzo+Pau+Yjz7FCLUwExu7WKg==
X-Google-Smtp-Source: ABdhPJwvxhW/BXgKa0H3kIJtuPrBi6OJ/RRAqa+whZ3cQ7SanraNICIPOafZ0qis8jqNs/OwFMjYCg==
X-Received: by 2002:a17:90a:d48e:: with SMTP id s14mr3026552pju.49.1634682256598;
        Tue, 19 Oct 2021 15:24:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z13sm217243pfq.130.2021.10.19.15.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:24:15 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:24:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <YW9Fi128rYxiF1v3@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no point in recalculating from scratch the total number of pages
> in all memslots each time a memslot is created or deleted.
> 
> Just cache the value and update it accordingly on each such operation so
> the code doesn't need to traverse the whole memslot array each time.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28ef14155726..65fdf27b9423 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11609,9 +11609,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				const struct kvm_memory_slot *new,
>  				enum kvm_mr_change change)
>  {
> -	if (!kvm->arch.n_requested_mmu_pages)
> -		kvm_mmu_change_mmu_pages(kvm,
> -				kvm_mmu_calculate_default_mmu_pages(kvm));
> +	if (change == KVM_MR_CREATE)
> +		kvm->arch.n_memslots_pages += new->npages;
> +	else if (change == KVM_MR_DELETE) {
> +		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
> +		kvm->arch.n_memslots_pages -= old->npages;
> +	}
> +
> +	if (!kvm->arch.n_requested_mmu_pages) {

Hmm, once n_requested_mmu_pages is set it can't be unset.  That means this can be
further optimized to skip avoid taking mmu_lock on flags-only changes (and
memslot movement).  E.g.

	if (!kvm->arch.n_requested_mmu_pages &&
	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {

	}

It's a little risky, but kvm_vm_ioctl_set_nr_mmu_pages() would need to be modified
to allow clearing n_requested_mmu_pages and it already takes slots_lock, so IMO
it's ok to force kvm_vm_ioctl_set_nr_mmu_pages() to recalculate pages if it wants
to allow reverting back to the default.

> +		u64 memslots_pages;
> +		unsigned long nr_mmu_pages;
> +
> +		memslots_pages = kvm->arch.n_memslots_pages * KVM_PERMILLE_MMU_PAGES;
> +		do_div(memslots_pages, 1000);
> +		nr_mmu_pages = max_t(typeof(nr_mmu_pages),
> +				     memslots_pages, KVM_MIN_ALLOC_MMU_PAGES);

"memslots_pages" is a bit of a misnomer.  Any objection to avoiding naming problems
by explicitly casting to an "unsigned long" and simply operating on nr_mmu_pages?

		nr_mmu_pages = (unsigned long)kvm->arch.n_memslots_pages;
		nr_mmu_pages *= (KVM_PERMILLE_MMU_PAGES / 1000);
		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);

E.g. the whole thing can be

	if (!kvm->arch.n_requested_mmu_pages &&
	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
		unsigned long nr_mmu_pages;

		if (change == KVM_MR_CREATE) {
			kvm->arch.n_memslots_pages += new->npages;
		} else {
			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
			kvm->arch.n_memslots_pages -= old->npages;
		}

		nr_mmu_pages = (unsigned long)kvm->arch.n_memslots_pages;
		nr_mmu_pages *= (KVM_PERMILLE_MMU_PAGES / 1000);
		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
	}

> +		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> +	}
>  
>  	kvm_mmu_slot_apply_flags(kvm, old, new, change);
>  
