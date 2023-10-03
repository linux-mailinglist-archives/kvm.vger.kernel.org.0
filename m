Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E57B6EF8
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbjJCQzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjJCQzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58809B
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696352069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISsb3iVPEmDc/p0deGOPwsVTZj+aTDh2tsGjptVpN5g=;
        b=hOXZoMOETRSY+ci7ZSFDSJZIEFZx8Uxcw5OCmBMjH+L5EVqEQhedNEm3JYk37+pEsmKbmJ
        +G0MjNjzmSHcy+3TiYS839lKXFUtt9SWodT5n4qPzn3pGSHv9wMSmbaK7R8oyUlKpT4Eel
        rM3b1ABSmS07qpDGmcs4u6fx2JC/aOg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-j2xvmCBoMwOxrhAb4woeeg-1; Tue, 03 Oct 2023 12:54:28 -0400
X-MC-Unique: j2xvmCBoMwOxrhAb4woeeg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso7604435e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352067; x=1696956867;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ISsb3iVPEmDc/p0deGOPwsVTZj+aTDh2tsGjptVpN5g=;
        b=rLBeb6TQgfYxvFDc0krtRY4KAmmsWncrthssDD6Jhq+CWbXOCc+ELo+gDeFCECOVqH
         DvrrSCCjP4Z8iD3S07l+DQV5Cfcc+HmX4JdFT+zCoXiOWQ1FwJZMR9N71qYLRrRxht9y
         ZXGVDvWkQeujnEnVyxPFAuOVD35XdDuYkuolNGH/l8WE5FzpQLPfgy+IZJ0SQKDGBk6k
         cnoDqWIX3gwMKR/TnDJ+Rwcul8kmiFCpGtPnXaIllGDww4ii+VCuX2HxFPUesmU0FOf1
         b/rxrhm8+o0jKhZh4TNVD9o5cn6F5bIAiN4gCrXQ+VNeM/SvPAXpU/+nHZE9QVk29fOl
         91aw==
X-Gm-Message-State: AOJu0YyzrOoreWyqk6C7+IcBEYQFFQMCz8RSmBQhxDBvAIYtgnBL64Gz
        42u0GVz82WRrsx96RgiKRXLFMUC1r5hj8RB/N8rL4Eayf+IL2Y6iFMTxEXoF4u76OlX525wGeU+
        rCN9/+DQXVGSq
X-Received: by 2002:a5d:5402:0:b0:324:8700:2fec with SMTP id g2-20020a5d5402000000b0032487002fecmr12440074wrv.64.1696352067239;
        Tue, 03 Oct 2023 09:54:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ5f0pyOLjJ2ECB9++AIorwrViTQweCCdRt4BkE6yhpaL4GqVhgMa9e97Es2Fr3cZptw9JEA==
X-Received: by 2002:a5d:5402:0:b0:324:8700:2fec with SMTP id g2-20020a5d5402000000b0032487002fecmr12440053wrv.64.1696352066761;
        Tue, 03 Oct 2023 09:54:26 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d4290000000b00325b29a6441sm1962434wrq.82.2023.10.03.09.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:26 -0700 (PDT)
Message-ID: <68ab2979f1982bdd0306e24f1e355ad322c7aa1c.camel@redhat.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 03 Oct 2023 19:54:24 +0300
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
         <20230911021637.1941096-3-stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-09-11 у 11:16 +0900, David Stevens пише:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
> __kvm_follow_pfn refactors the old API's arguments into a struct and,
> where possible, combines the boolean arguments into a single flags
> argument.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h |  16 ++++
>  virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
>  virt/kvm/kvm_mm.h        |   3 +-
>  virt/kvm/pfncache.c      |  10 ++-
>  4 files changed, 123 insertions(+), 77 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fb6c6109fdca..c2e0ddf14dba 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -97,6 +97,7 @@
>  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
>  #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
> +#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
>  
>  /*
>   * error pfns indicate that the gfn is in slot but faild to
> @@ -1177,6 +1178,21 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
>  void kvm_release_page_clean(struct page *page);
>  void kvm_release_page_dirty(struct page *page);
>  
> +struct kvm_follow_pfn {
> +	const struct kvm_memory_slot *slot;
> +	gfn_t gfn;
> +	unsigned int flags;
It might be useful for the future readers to have a note about which values the flags can take.
(e.g one of the 'FOLL_* flags).
> +	bool atomic;

I wish we had FOLL_ATOMIC, because there is a slight usability regression in regard to the fact,
that now some of the flags are here and in the 'atomic' variable.


> +	/* Try to create a writable mapping even for a read fault */
> +	bool try_map_writable;
> +
> +	/* Outputs of __kvm_follow_pfn */
> +	hva_t hva;
> +	bool writable;
> +};


Another small usability note. I feel like the name 'follow_pfn' is not the best name for this.

I think ultimately it comes from 'follow_pte()' and even that name IMHO is incorrect.
the 'follow_pte' should be called 'lookup_kernel_pte', because that is what it does - it finds a pointer to pte
of hva in its process's kernel page tables.

IMHO, the kvm_follow_pfn struct should be called something like gfn_to_pfn_params, because it specifies on how
to convert gfn to pfn (or create the pfn if the page was swapped out).

Same note applies to '__kvm_follow_pfn()'

If you really want to keep the original name though, I won't argue over this.

> +
> +kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
> +
>  kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
>  kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		      bool *writable);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ee6090ecb1fe..9b33a59c6d65 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2512,8 +2512,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>   * true indicates success, otherwise false is returned.  It's also the
>   * only part that runs if we can in atomic context.
>   */
> -static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> -			    bool *writable, kvm_pfn_t *pfn)
> +static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  {
>  	struct page *page[1];
>  
> @@ -2522,14 +2521,12 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>  	 * or the caller allows to map a writable pfn for a read fault
>  	 * request.
>  	 */
> -	if (!(write_fault || writable))
> +	if (!((foll->flags & FOLL_WRITE) || foll->try_map_writable))
>  		return false;

A small note: the 'foll' variable and the FOLL_* flags have different meaning:
foll is the pointer to a new 'struct kvm_follow_pfn' while FOLL_ is from the folio API,
I think.

Maybe we should rename the 'foll' to something, like 'args' or something like that?

>  
> -	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
> +	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
>  		*pfn = page_to_pfn(page[0]);
> -
> -		if (writable)
> -			*writable = true;
> +		foll->writable = true;
>  		return true;
>  	}
>  
> @@ -2540,35 +2537,26 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>   * The slow path to get the pfn of the specified host virtual address,
>   * 1 indicates success, -errno is returned if error is detected.
>   */
> -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> -			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
> +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  {
> -	unsigned int flags = FOLL_HWPOISON;
> +	unsigned int flags = FOLL_HWPOISON | foll->flags;
>  	struct page *page;
>  	int npages;
>  
>  	might_sleep();
>  
> -	if (writable)
> -		*writable = write_fault;
> -
> -	if (write_fault)
> -		flags |= FOLL_WRITE;
> -	if (async)
> -		flags |= FOLL_NOWAIT;
> -	if (interruptible)
> -		flags |= FOLL_INTERRUPTIBLE;
> -
> -	npages = get_user_pages_unlocked(addr, 1, &page, flags);
> +	npages = get_user_pages_unlocked(foll->hva, 1, &page, flags);
>  	if (npages != 1)
>  		return npages;
>  
> -	/* map read fault as writable if possible */
> -	if (unlikely(!write_fault) && writable) {
> +	if (foll->flags & FOLL_WRITE) {
> +		foll->writable = true;
> +	} else if (foll->try_map_writable) {
>  		struct page *wpage;
>  
> -		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
> -			*writable = true;
> +		/* map read fault as writable if possible */
> +		if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage)) {
> +			foll->writable = true;
>  			put_page(page);
>  			page = wpage;

Regardless of this patch, I am wondering, what was the reason to first map the
page in the same way as requested and then try to map it as writable.

Since the vast majority of the guest pages are likely to be writable, isn't it better
to first opportunistically map them as writable and if that fails, then try to map
readonly?

>  		}
> @@ -2599,23 +2587,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>  }
>  
>  static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> -			       unsigned long addr, bool write_fault,
> -			       bool *writable, kvm_pfn_t *p_pfn)
> +			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)
>  {
>  	kvm_pfn_t pfn;
>  	pte_t *ptep;
>  	pte_t pte;
>  	spinlock_t *ptl;
> +	bool write_fault = foll->flags & FOLL_WRITE;
>  	int r;
>  
> -	r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
> +	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
>  	if (r) {
>  		/*
>  		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
>  		 * not call the fault handler, so do it here.
>  		 */
>  		bool unlocked = false;
> -		r = fixup_user_fault(current->mm, addr,
> +		r = fixup_user_fault(current->mm, foll->hva,
>  				     (write_fault ? FAULT_FLAG_WRITE : 0),
>  				     &unlocked);
>  		if (unlocked)
> @@ -2623,7 +2611,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  		if (r)
>  			return r;
>  
> -		r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
> +		r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
>  		if (r)
>  			return r;
>  	}
> @@ -2635,8 +2623,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  		goto out;
>  	}
>  
> -	if (writable)
> -		*writable = pte_write(pte);
> +	foll->writable = pte_write(pte);
>  	pfn = pte_pfn(pte);
>  
>  	/*
> @@ -2681,24 +2668,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   * 2): @write_fault = false && @writable, @writable will tell the caller
>   *     whether the mapping is writable.
>   */
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
> -		     bool *async, bool write_fault, bool *writable)
> +kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  {
>  	struct vm_area_struct *vma;
>  	kvm_pfn_t pfn;
>  	int npages, r;
>  
>  	/* we can do it either atomically or asynchronously, not both */
> -	BUG_ON(atomic && async);
> +	BUG_ON(foll->atomic && (foll->flags & FOLL_NOWAIT));
>  
> -	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
> +	if (hva_to_pfn_fast(foll, &pfn))
>  		return pfn;
>  
> -	if (atomic)
> +	if (foll->atomic)
>  		return KVM_PFN_ERR_FAULT;
>  
> -	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
> -				 writable, &pfn);
> +	npages = hva_to_pfn_slow(foll, &pfn);
>  	if (npages == 1)
>  		return pfn;
>  	if (npages == -EINTR)
> @@ -2706,83 +2691,123 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>  
>  	mmap_read_lock(current->mm);
>  	if (npages == -EHWPOISON ||
> -	      (!async && check_user_page_hwpoison(addr))) {
> +	    (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {
>  		pfn = KVM_PFN_ERR_HWPOISON;
>  		goto exit;
>  	}
>  
>  retry:
> -	vma = vma_lookup(current->mm, addr);
> +	vma = vma_lookup(current->mm, foll->hva);
>  
>  	if (vma == NULL)
>  		pfn = KVM_PFN_ERR_FAULT;
>  	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> -		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
> +		r = hva_to_pfn_remapped(vma, foll, &pfn);
>  		if (r == -EAGAIN)
>  			goto retry;
>  		if (r < 0)
>  			pfn = KVM_PFN_ERR_FAULT;
>  	} else {
> -		if (async && vma_is_valid(vma, write_fault))
> -			*async = true;
> -		pfn = KVM_PFN_ERR_FAULT;
> +		if ((foll->flags & FOLL_NOWAIT) &&
> +		    vma_is_valid(vma, foll->flags & FOLL_WRITE))
> +			pfn = KVM_PFN_ERR_NEEDS_IO;
> +		else
> +			pfn = KVM_PFN_ERR_FAULT;
>  	}
>  exit:
>  	mmap_read_unlock(current->mm);
>  	return pfn;
>  }
>  
> -kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> -			       bool atomic, bool interruptible, bool *async,
> -			       bool write_fault, bool *writable, hva_t *hva)
> +kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
>  {
> -	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
> +	foll->writable = false;
> +	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
> +				      foll->flags & FOLL_WRITE);
>  
> -	if (hva)
> -		*hva = addr;
> -
> -	if (addr == KVM_HVA_ERR_RO_BAD) {
> -		if (writable)
> -			*writable = false;
> +	if (foll->hva == KVM_HVA_ERR_RO_BAD)
>  		return KVM_PFN_ERR_RO_FAULT;
> -	}
>  
> -	if (kvm_is_error_hva(addr)) {
> -		if (writable)
> -			*writable = false;
> +	if (kvm_is_error_hva(foll->hva))
>  		return KVM_PFN_NOSLOT;
> -	}
>  
> -	/* Do not map writable pfn in the readonly memslot. */
> -	if (writable && memslot_is_readonly(slot)) {
> -		*writable = false;
> -		writable = NULL;
> -	}
> +	if (memslot_is_readonly(foll->slot))
> +		foll->try_map_writable = false;
>  
> -	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
> -			  writable);
> +	return hva_to_pfn(foll);
> +}
> +EXPORT_SYMBOL_GPL(__kvm_follow_pfn);
> +
> +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> +			       bool atomic, bool interruptible, bool *async,
> +			       bool write_fault, bool *writable, hva_t *hva)
> +{
> +	kvm_pfn_t pfn;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = gfn,
> +		.flags = 0,
> +		.atomic = atomic,
> +		.try_map_writable = !!writable,
> +	};
> +
> +	if (write_fault)
> +		foll.flags |= FOLL_WRITE;
> +	if (async)
> +		foll.flags |= FOLL_NOWAIT;
> +	if (interruptible)
> +		foll.flags |= FOLL_INTERRUPTIBLE;
> +
> +	pfn = __kvm_follow_pfn(&foll);
> +	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
> +		*async = true;
> +		pfn = KVM_PFN_ERR_FAULT;
> +	}
> +	if (hva)
> +		*hva = foll.hva;
> +	if (writable)
> +		*writable = foll.writable;
> +	return pfn;
>  }
>  EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
>  
>  kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		      bool *writable)
>  {
> -	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
> -				    NULL, write_fault, writable, NULL);
> +	kvm_pfn_t pfn;
> +	struct kvm_follow_pfn foll = {
> +		.slot = gfn_to_memslot(kvm, gfn),
> +		.gfn = gfn,
> +		.flags = write_fault ? FOLL_WRITE : 0,
> +		.try_map_writable = !!writable,
> +	};
> +	pfn = __kvm_follow_pfn(&foll);
> +	if (writable)
> +		*writable = foll.writable;
> +	return pfn;
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);

Unrelated, but it would be a good idea to document the contract behind these functions.

>  
>  kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
> -				    NULL, NULL);
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = gfn,
> +		.flags = FOLL_WRITE,
> +	};
> +	return __kvm_follow_pfn(&foll);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
Same here + the new code makes it at least much easier to understand what each function is doing.

>  
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
> -				    NULL, NULL);
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = gfn,
> +		.flags = FOLL_WRITE,
> +		.atomic = true,
> +	};
> +	return __kvm_follow_pfn(&foll);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
>  
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index 180f1a09e6ba..ed896aee5396 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -20,8 +20,7 @@
>  #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
>  #endif /* KVM_HAVE_MMU_RWLOCK */
>  
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
> -		     bool *async, bool write_fault, bool *writable);
> +kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll);
>  
>  #ifdef CONFIG_HAVE_KVM_PFNCACHE
>  void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 2d6aba677830..86cd40acad11 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -144,6 +144,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
>  	void *new_khva = NULL;
>  	unsigned long mmu_seq;
> +	struct kvm_follow_pfn foll = {
> +		.slot = gpc->memslot,
> +		.gfn = gpa_to_gfn(gpc->gpa),
> +		.flags = FOLL_WRITE,
> +		.hva = gpc->uhva,
> +	};
>  
>  	lockdep_assert_held(&gpc->refresh_lock);
>  
> @@ -182,8 +188,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  			cond_resched();
>  		}
>  
> -		/* We always request a writeable mapping */
> -		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
> +		/* We always request a writable mapping */
> +		new_pfn = hva_to_pfn(&foll);
>  		if (is_error_noslot_pfn(new_pfn))
>  			goto out_error;
>  


Overall the patch looks like a very good refactoring.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky




