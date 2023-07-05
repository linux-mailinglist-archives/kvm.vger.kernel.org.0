Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622E17484CB
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjGENTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 09:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjGENTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 09:19:19 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B7170A;
        Wed,  5 Jul 2023 06:19:18 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f13c41c957so1641251e87.1;
        Wed, 05 Jul 2023 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688563156; x=1691155156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJeyGVv0znTqEcwVXg84NyttMMA4ZPCQSajMCy1/ipI=;
        b=sPtYj//OIwl0gmeHlYrkvbM20OcSAfC5BuEH/aktXrPpwhzFC+tU2dAZtGjqYdK9Dz
         Nl2G1kN0X84ctvw5d3m/qEbDlcnKUTtlUhViET6mXRgNwHgPTrJ9LqBCXUfQbUYxPgib
         T96ZY/nMt9SOc6mp/xMEWpzuUgunIXkcSygiLdLwvxpXtRVtjCaBwATLS+dtpa5EawA6
         9Im23n6E0jBfsFH0VPk9ptvPg/h6vnLKZPPbQI0+uslVIYg8tEyweRJG4vk3xRVSCA6E
         69xgpB5HxORzlTNBXQ9vSd5rr4K5OTsBmZfZ6uPksZ2uKNdIO35tVSddQLnNnftzFucX
         4nIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688563156; x=1691155156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJeyGVv0znTqEcwVXg84NyttMMA4ZPCQSajMCy1/ipI=;
        b=jJ6kontIq6nTHGX7Zr+or/aTAoXundJk+0VkdSSPIxV6BXFvFr38eOrspwrhtN9FV/
         MC5E3GfCMZwE4aubWgTQktWb3QGtIjLaGxreI28O5TtzrwuBia/37H5wHaQbwnq6l8yF
         /Sv8KclSUdzBP7ogINPEwQTJPDCRsm6RBJgZ1vBsun+k5zL/v4fPuxpZWD8YysJoDqZZ
         cQV+0Vd48O1JND3UR+CxXjWLcaziP+URFZL2UmvmZ0P3wHbJsWfqaem7xrh3p9wmdxyn
         2FW/AzvqFUkf+oKqbjH5+jV4LOL6Wda34XYMlm1+Dm1liebajKk1Ku+v75/RecLPeDtq
         MeQA==
X-Gm-Message-State: ABy/qLaF52TcDd7qMML36vc8NEMLwbzsfdR8qSDfmxTqjQIdV6naM+Xt
        Xz/A0P9fgbmB8dhjUHGAB0g=
X-Google-Smtp-Source: APBJJlFrj4FvZq1htKqVy1cumLXg0HKuhb6vEpYa7o44yN2SGeOZXSfX9tofaOJVbI8rVzVHlvWPLw==
X-Received: by 2002:ac2:4acf:0:b0:4f3:8267:a2f3 with SMTP id m15-20020ac24acf000000b004f38267a2f3mr8874415lfp.0.1688563155758;
        Wed, 05 Jul 2023 06:19:15 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a11-20020a056512020b00b004f875a919a6sm4072096lfo.293.2023.07.05.06.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 06:19:15 -0700 (PDT)
Date:   Wed, 5 Jul 2023 16:19:14 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
Message-ID: <20230705161914.00004070.zhi.wang.linux@gmail.com>
In-Reply-To: <20230704075054.3344915-4-stevensd@google.com>
References: <20230704075054.3344915-1-stevensd@google.com>
        <20230704075054.3344915-4-stevensd@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Jul 2023 16:50:48 +0900
David Stevens <stevensd@chromium.org> wrote:

> From: David Stevens <stevensd@chromium.org>
> 
> Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
> callers to resolve a gfn when the associated pfn has a valid struct page
> that isn't being actively refcounted (e.g. tail pages of non-compound
> higher order pages). For a caller to safely omit FOLL_GET, all usages of
> the returned pfn must be guarded by a mmu notifier.
> 
> This also adds a is_refcounted_page out parameter to kvm_follow_pfn that
> is set when the returned pfn has an associated struct page with a valid
> refcount. Callers that don't pass FOLL_GET should remember this value
> and use it to avoid places like kvm_is_ad_tracked_page that assume a
> non-zero refcount.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h | 10 ++++++
>  virt/kvm/kvm_main.c      | 67 +++++++++++++++++++++-------------------
>  virt/kvm/pfncache.c      |  2 +-
>  3 files changed, 47 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ef2763c2b12e..a45308c7d2d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
>  void kvm_release_page_clean(struct page *page);
>  void kvm_release_page_dirty(struct page *page);
>  
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
>  struct kvm_follow_pfn {
>  	const struct kvm_memory_slot *slot;
>  	gfn_t gfn;
> @@ -1164,10 +1167,17 @@ struct kvm_follow_pfn {
>  	bool atomic;
>  	/* Allow a read fault to create a writeable mapping. */
>  	bool allow_write_mapping;
> +	/*
> +	 * Usage of the returned pfn will be guared by a mmu notifier. Must
                                              ^guarded
> +	 * be true if FOLL_GET is not set.
> +	 */
> +	bool guarded_by_mmu_notifier;
>
It seems no one sets the guraded_by_mmu_notifier in this patch. Is
guarded_by_mmu_notifier always equal to !foll->FOLL_GET and set by the
caller of __kvm_follow_pfn()?

If yes, do we have to use FOLL_GET to resolve GFN associated with a tail page?
It seems gup can tolerate gup_flags without FOLL_GET, but it is more like a
temporary solution. I don't think it is a good idea to play tricks with
a temporary solution, more like we are abusing the toleration.

Is a flag like guarded_by_mmu_notifier (perhaps a better name) enough to
indicate a tail page?
 
>  	/* Outputs of __kvm_follow_pfn */
>  	hva_t hva;
>  	bool writable;
> +	/* True if the returned pfn is for a page with a valid refcount. */
> +	bool is_refcounted_page;
>  };
>  
>  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b13f22861d2f..0f7b41f220b6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2502,6 +2502,9 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
>  		*pfn = page_to_pfn(page[0]);
>  		foll->writable = foll->allow_write_mapping;
> +		foll->is_refcounted_page = true;
> +		if (!(foll->flags & FOLL_GET))
> +			put_page(page[0]);
>  		return true;
>  	}
>  
> @@ -2525,6 +2528,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  		return npages;
>  
>  	foll->writable = (foll->flags & FOLL_WRITE) && foll->allow_write_mapping;
> +	foll->is_refcounted_page = true;
>  
>  	/* map read fault as writable if possible */
>  	if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> @@ -2537,6 +2541,8 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  		}
>  	}
>  	*pfn = page_to_pfn(page);
> +	if (!(foll->flags & FOLL_GET))
> +		put_page(page);
>  	return npages;
>  }
>  
> @@ -2551,16 +2557,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
>  	return true;
>  }
>  
> -static int kvm_try_get_pfn(kvm_pfn_t pfn)
> -{
> -	struct page *page = kvm_pfn_to_refcounted_page(pfn);
> -
> -	if (!page)
> -		return 1;
> -
> -	return get_page_unless_zero(page);
> -}
> -
>  static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn *foll,
>  			       kvm_pfn_t *p_pfn)
>  {
> @@ -2568,6 +2564,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn
>  	pte_t *ptep;
>  	spinlock_t *ptl;
>  	bool write_fault = foll->flags & FOLL_WRITE;
> +	struct page *page;
>  	int r;
>  
>  	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
> @@ -2599,24 +2596,27 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn
>  	pfn = pte_pfn(*ptep);
>  
>  	/*
> -	 * Get a reference here because callers of *hva_to_pfn* and
> -	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
> -	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> -	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
> -	 * simply do nothing for reserved pfns.
> -	 *
> -	 * Whoever called remap_pfn_range is also going to call e.g.
> -	 * unmap_mapping_range before the underlying pages are freed,
> -	 * causing a call to our MMU notifier.
> +	 * Now deal with reference counting. If kvm_pfn_to_refcounted_page
> +	 * returns NULL, then there's no refcount to worry about.
>  	 *
> -	 * Certain IO or PFNMAP mappings can be backed with valid
> -	 * struct pages, but be allocated without refcounting e.g.,
> -	 * tail pages of non-compound higher order allocations, which
> -	 * would then underflow the refcount when the caller does the
> -	 * required put_page. Don't allow those pages here.
> +	 * Otherwise, certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages but be allocated without refcounting e.g., tail pages of
> +	 * non-compound higher order allocations. If FOLL_GET is set and we
> +	 * increment such a refcount, then when that pfn is eventually passed to
> +	 * kvm_release_pfn_clean, its refcount would hit zero and be incorrectly
> +	 * freed. Therefore don't allow those pages here when FOLL_GET is set.
>  	 */ 
> -	if (!kvm_try_get_pfn(pfn))
> +	page = kvm_pfn_to_refcounted_page(pfn);
> +	if (!page)
> +		goto out;
> +
> +	if (get_page_unless_zero(page)) {
> +		foll->is_refcounted_page = true;
> +		if (!(foll->flags & FOLL_GET))
> +			put_page(page);
> +	} else if (foll->flags & FOLL_GET) {
>  		r = -EFAULT;
> +	}
>  
>  out:
>  	pte_unmap_unlock(ptep, ptl);
> @@ -2693,6 +2693,9 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  
>  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
>  {
> +	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll->guarded_by_mmu_notifier))
> +		return KVM_PFN_ERR_FAULT;
> +
>  	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
>  				      foll->flags & FOLL_WRITE);
>  
> @@ -2717,7 +2720,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>  	struct kvm_follow_pfn foll = {
>  		.slot = slot,
>  		.gfn = gfn,
> -		.flags = 0,
> +		.flags = FOLL_GET,
>  		.atomic = atomic,
>  		.allow_write_mapping = !!writable,
>  	};
> @@ -2749,7 +2752,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  	struct kvm_follow_pfn foll = {
>  		.slot = gfn_to_memslot(kvm, gfn),
>  		.gfn = gfn,
> -		.flags = write_fault ? FOLL_WRITE : 0,
> +		.flags = FOLL_GET | (write_fault ? FOLL_WRITE : 0),
>  		.allow_write_mapping = !!writable,
>  	};
>  	pfn = __kvm_follow_pfn(&foll);
> @@ -2764,7 +2767,7 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>  	struct kvm_follow_pfn foll = {
>  		.slot = slot,
>  		.gfn = gfn,
> -		.flags = FOLL_WRITE,
> +		.flags = FOLL_GET | FOLL_WRITE,
>  	};
>  	return __kvm_follow_pfn(&foll);
>  }
> @@ -2775,7 +2778,7 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
>  	struct kvm_follow_pfn foll = {
>  		.slot = slot,
>  		.gfn = gfn,
> -		.flags = FOLL_WRITE,
> +		.flags = FOLL_GET | FOLL_WRITE,
>  		.atomic = true,
>  	};
>  	return __kvm_follow_pfn(&foll);
> @@ -2930,17 +2933,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
>  	return !PageReserved(page);
>  }
>  
> -static void kvm_set_page_dirty(struct page *page)
> +void kvm_set_page_dirty(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		SetPageDirty(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
>  
> -static void kvm_set_page_accessed(struct page *page)
> +void kvm_set_page_accessed(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		mark_page_accessed(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_accessed);
>  
>  void kvm_release_page_clean(struct page *page)
>  {
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index e3fefa753a51..87caafce3dd0 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -147,7 +147,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  	struct kvm_follow_pfn foll = {
>  		.slot = gpc->memslot,
>  		.gfn = gpa_to_gfn(gpc->gpa),
> -		.flags = FOLL_WRITE,
> +		.flags = FOLL_WRITE | FOLL_GET,
>  		.hva = gpc->uhva,
>  	};
>  

