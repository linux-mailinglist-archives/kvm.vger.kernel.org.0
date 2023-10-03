Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0F7B6F17
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbjJCQ4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbjJCQ4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845659B
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696352112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUE4b4eA8EVcusS8OYgffaSubZlYW8k7hwjIUaJEuJ0=;
        b=bzzUDhfiuV+IxugSPepgZOyn8MwqwnrqBl8FT7MZiLrUNyrcaFIRvWndj8uIVbk4w9Ni66
        YVBWOAXpiIq7BZsEu+sdQbdNx9FvQM1y6TWxpkRRSc0/aqc+pAhY5pWGI2Md8SExz33Tnc
        D0PuhltLjIPusNbZl838svva5c6TdvE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-T5rgaQucNP6V6BDiGAbI_g-1; Tue, 03 Oct 2023 12:55:00 -0400
X-MC-Unique: T5rgaQucNP6V6BDiGAbI_g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fef5403093so84695e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352098; x=1696956898;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uUE4b4eA8EVcusS8OYgffaSubZlYW8k7hwjIUaJEuJ0=;
        b=fafMW43S1KqdY5r0MJdFXInovOoisj6iljsmQMWafeKT9nopRtflfiMs8vD7979oMQ
         KB7OWrNPMi/HL+ykt/mz/kI+U1ouBOKz4M5C2Dzt9WOGbVlRcODygmtAsmUO7A814NVU
         cME7M7BjXFZwUxfRx3QAMybELEuaLUOB+5Qwxsfd+xOVITCC8K7e64CG7wheiczNnaIJ
         N1ScBRBoLhUebvwBkNYimAttMSZLbEYFMp/Lyv8PRGh+Xp5LhLh9SAN2wss0eC+EZ+ES
         Ysoor6X5Bkd73ljZ99fgwtZ44GX0Ni3pnbOHNgnXjB/lgZyXk/tc4jOwyJj/oelJ75XW
         3c7A==
X-Gm-Message-State: AOJu0Yw1gnmQd0O/EPbZv5MCXk5a8xG2F8e5wVYCuKL+H1zhWexGUK9r
        9FOuNuAWQESayWOlWro1PV7YpZG/mzfFIzOfiqG1aPdqoEfKtC1N/HOJTIUMfscPdHoaH03H6qe
        D6utV6QdjBiWBHuzS0Yhy
X-Received: by 2002:a05:600c:1c9b:b0:405:3622:382c with SMTP id k27-20020a05600c1c9b00b004053622382cmr2665560wms.17.1696352098615;
        Tue, 03 Oct 2023 09:54:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP4APoMvfSFRDaIFr2iCuYs0CEJsDHoCSuhiuSiY9KVZfnpDvSxlj0ZWm4z0+iu/WKyObsyw==
X-Received: by 2002:a05:600c:1c9b:b0:405:3622:382c with SMTP id k27-20020a05600c1c9b00b004053622382cmr2665541wms.17.1696352098090;
        Tue, 03 Oct 2023 09:54:58 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4cc6000000b00325c7295450sm1978005wrt.3.2023.10.03.09.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:57 -0700 (PDT)
Message-ID: <ca9dde6a5c8d8ff9eb1945fd6c846ed5184d45ee.camel@redhat.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 03 Oct 2023 19:54:56 +0300
In-Reply-To: <20230911021637.1941096-7-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
         <20230911021637.1941096-7-stevensd@google.com>
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
> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> to map memory into the guest that is backed by non-refcounted struct
> pages - for example, the tail pages of higher order non-compound pages
> allocated by the amdgpu driver via ttm_pool_alloc_page.
> 
> The bulk of this change is tracking the is_refcounted_page flag so that
> non-refcounted pages don't trigger page_count() == 0 warnings. This is
> done by storing the flag in an unused bit in the sptes. There are no
> bits available in PAE SPTEs, so non-refcounted pages can only be handled
> on TDP and x86-64.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
>  arch/x86/kvm/mmu/spte.c         |  4 ++-
>  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
>  include/linux/kvm_host.h        |  3 ++
>  virt/kvm/kvm_main.c             |  6 ++--
>  8 files changed, 76 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1eca26215e2..b8168cc4cc96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -545,12 +545,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>  
>  	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
>  		flush = true;
> -		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +		if (is_refcounted_page_pte(old_spte))
> +			kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
>  	}
>  
>  	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
>  		flush = true;
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		if (is_refcounted_page_pte(old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
>  	}
>  
>  	return flush;
> @@ -588,14 +590,18 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  	 * before they are reclaimed.  Sanity check that, if the pfn is backed
>  	 * by a refcounted page, the refcount is elevated.
>  	 */
> -	page = kvm_pfn_to_refcounted_page(pfn);
> -	WARN_ON_ONCE(page && !page_count(page));
> +	if (is_refcounted_page_pte(old_spte)) {
> +		page = kvm_pfn_to_refcounted_page(pfn);
> +		WARN_ON_ONCE(!page || !page_count(page));
> +	}
>  
> -	if (is_accessed_spte(old_spte))
> -		kvm_set_pfn_accessed(pfn);
> +	if (is_refcounted_page_pte(old_spte)) {
> +		if (is_accessed_spte(old_spte))
> +			kvm_set_page_accessed(pfn_to_page(pfn));
>  
> -	if (is_dirty_spte(old_spte))
> -		kvm_set_pfn_dirty(pfn);
> +		if (is_dirty_spte(old_spte))
> +			kvm_set_page_dirty(pfn_to_page(pfn));
> +	}
>  
>  	return old_spte;
>  }
> @@ -631,8 +637,8 @@ static bool mmu_spte_age(u64 *sptep)
>  		 * Capture the dirty status of the page, so that it doesn't get
>  		 * lost when the SPTE is marked for access tracking.
>  		 */
> -		if (is_writable_pte(spte))
> -			kvm_set_pfn_dirty(spte_to_pfn(spte));
> +		if (is_writable_pte(spte) && is_refcounted_page_pte(spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
>  
>  		spte = mark_spte_for_access_track(spte);
>  		mmu_spte_update_no_track(sptep, spte);
> @@ -1261,8 +1267,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
>  {
>  	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
>  					       (unsigned long *)sptep);
> -	if (was_writable && !spte_ad_enabled(*sptep))
> -		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
> +	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_pte(*sptep))
> +		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
>  
>  	return was_writable;
>  }
> @@ -2913,6 +2919,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	bool host_writable = !fault || fault->map_writable;
>  	bool prefetch = !fault || fault->prefetch;
>  	bool write_fault = fault && fault->write;
> +	/*
> +	 * Prefetching uses gfn_to_page_many_atomic, which never gets
> +	 * non-refcounted pages.
> +	 */
> +	bool is_refcounted = !fault || fault->is_refcounted_page;
A WARN_ON_ONCE for a future bug that will make this condition false might be a good idea.

>  
>  	if (unlikely(is_noslot_pfn(pfn))) {
>  		vcpu->stat.pf_mmio_spte_created++;
> @@ -2940,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	}
>  
>  	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
> -			   true, host_writable, &spte);
> +			   true, host_writable, is_refcounted, &spte);
>  
>  	if (*sptep == spte) {
>  		ret = RET_PF_SPURIOUS;
> @@ -4254,13 +4265,18 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> +	/*
> +	 * There are no extra bits for tracking non-refcounted pages in
> +	 * PAE SPTEs, so reject non-refcounted struct pages in that case.
> +	 */
> +	bool has_spte_refcount_bit = tdp_enabled && IS_ENABLED(CONFIG_X86_64);

I think that the tdp_enabled condition is needed because shadow paging uses the same
paging mode as the guest and it can use PAE, thus there will be no reserved bits.

Is this true? If true, can you write a comment about this? I haven't worked with shadow paging
for a long time, I no longer remember some of the details.


>  	struct kvm_follow_pfn foll = {
>  		.slot = slot,
>  		.gfn = fault->gfn,
>  		.flags = fault->write ? FOLL_WRITE : 0,
>  		.try_map_writable = true,
>  		.guarded_by_mmu_notifier = true,
> -		.allow_non_refcounted_struct_page = false,
> +		.allow_non_refcounted_struct_page = has_spte_refcount_bit,
>  	};
>  
>  	/*
> @@ -4277,6 +4293,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			fault->slot = NULL;
>  			fault->pfn = KVM_PFN_NOSLOT;
>  			fault->map_writable = false;
> +			fault->is_refcounted_page = false;
>  			return RET_PF_CONTINUE;
>  		}
>  		/*
> @@ -4332,6 +4349,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  success:
>  	fault->hva = foll.hva;
>  	fault->map_writable = foll.writable;
> +	fault->is_refcounted_page = foll.is_refcounted_page;
>  	return RET_PF_CONTINUE;
>  }
>  
> @@ -4420,8 +4438,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	r = direct_map(vcpu, fault);
>  
>  out_unlock:
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));
>  	write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
>  	return r;
>  }
>  
> @@ -4496,8 +4515,9 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	r = kvm_tdp_mmu_map(vcpu, fault);
>  
>  out_unlock:
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));
>  	read_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
>  	return r;
>  }
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index b102014e2c60..7f73bc2a552e 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -239,6 +239,7 @@ struct kvm_page_fault {
>  	kvm_pfn_t pfn;
>  	hva_t hva;
>  	bool map_writable;
> +	bool is_refcounted_page;
>  
>  	/*
>  	 * Indicates the guest is trying to write a gfn that contains one or
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index c85255073f67..0ac4a4e5870c 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -848,7 +848,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));
>  	return r;
>  }
>  
> @@ -902,7 +903,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   */
>  static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
>  {
> -	bool host_writable;
> +	bool host_writable, is_refcounted;
>  	gpa_t first_pte_gpa;
>  	u64 *sptep, spte;
>  	struct kvm_memory_slot *slot;
> @@ -959,10 +960,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>  	sptep = &sp->spt[i];
>  	spte = *sptep;
>  	host_writable = spte & shadow_host_writable_mask;
> +	is_refcounted = spte & SPTE_MMU_PAGE_REFCOUNTED;

What will happen if this function is run on 32 bit kernel and/or without tdp enabled
(that is when SPTE_MMU_PAGE_REFCOUNTED is not defined)?

>  	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	make_spte(vcpu, sp, slot, pte_access, gfn,
>  		  spte_to_pfn(spte), spte, true, false,
> -		  host_writable, &spte);
> +		  host_writable, is_refcounted, &spte);
>  
>  	return mmu_spte_update(sptep, spte);
>  }
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4a599130e9c9..ce495819061f 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
> -	       bool host_writable, u64 *new_spte)
> +	       bool host_writable, bool is_refcounted, u64 *new_spte)
>  {
>  	int level = sp->role.level;
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
> @@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  
>  	if (level > PG_LEVEL_4K)
>  		spte |= PT_PAGE_SIZE_MASK;
> +	if (is_refcounted)
> +		spte |= SPTE_MMU_PAGE_REFCOUNTED;

Same here, if make_spte is used in these modes won't it set a bit it shouldn't?

>  
>  	if (shadow_memtype_mask)
>  		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index a129951c9a88..4bf4a535c23d 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -96,6 +96,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>  /* Defined only to keep the above static asserts readable. */
>  #undef SHADOW_ACC_TRACK_SAVED_MASK
>  
> +/*
> + * Indicates that the SPTE refers to a page with a valid refcount.
> + */
> +#define SPTE_MMU_PAGE_REFCOUNTED        BIT_ULL(59)
> +
>  /*
>   * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
>   * the memslots generation and is derived as follows:
> @@ -345,6 +350,11 @@ static inline bool is_dirty_spte(u64 spte)
>  	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
>  }
>  
> +static inline bool is_refcounted_page_pte(u64 spte)
> +{
> +	return spte & SPTE_MMU_PAGE_REFCOUNTED;

Here also: if the bit is not supported, we need to assume that all sptes are refcounted I think.

> +}
> +
>  static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
>  				int level)
>  {
> @@ -475,7 +485,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
> -	       bool host_writable, u64 *new_spte);
> +	       bool host_writable, bool is_refcounted, u64 *new_spte);
>  u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
>  		      	      union kvm_mmu_page_role role, int index);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6c63f2d1675f..185f3c666c2b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -474,6 +474,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	bool was_leaf = was_present && is_last_spte(old_spte, level);
>  	bool is_leaf = is_present && is_last_spte(new_spte, level);
>  	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> +	bool is_refcounted = is_refcounted_page_pte(old_spte);
>  
>  	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
>  	WARN_ON_ONCE(level < PG_LEVEL_4K);
> @@ -538,9 +539,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	if (is_leaf != was_leaf)
>  		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
>  
> -	if (was_leaf && is_dirty_spte(old_spte) &&
> +	if (was_leaf && is_dirty_spte(old_spte) && is_refcounted &&
>  	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
>  
>  	/*
>  	 * Recursively handle child PTs if the change removed a subtree from
> @@ -552,9 +553,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
>  
> -	if (was_leaf && is_accessed_spte(old_spte) &&
> +	if (was_leaf && is_accessed_spte(old_spte) && is_refcounted &&
>  	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +		kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
>  }
>  
>  /*
> @@ -988,8 +989,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>  	else
>  		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> -					 fault->map_writable, &new_spte);
> +				   fault->pfn, iter->old_spte, fault->prefetch, true,
> +				   fault->map_writable, fault->is_refcounted_page,
> +				   &new_spte);
>  
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
> @@ -1205,8 +1207,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>  		 * Capture the dirty status of the page, so that it doesn't get
>  		 * lost when the SPTE is marked for access tracking.
>  		 */
> -		if (is_writable_pte(iter->old_spte))
> -			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
> +		if (is_writable_pte(iter->old_spte) &&
> +		    is_refcounted_page_pte(iter->old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter->old_spte)));
>  
>  		new_spte = mark_spte_for_access_track(iter->old_spte);
>  		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
> @@ -1628,7 +1631,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>  		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
>  					       iter.old_spte,
>  					       iter.old_spte & ~dbit);
> -		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
> +		if (is_refcounted_page_pte(iter.old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
>  	}
>  
>  	rcu_read_unlock();
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b95c79b7833b..6696925f01f1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1179,6 +1179,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
>  void kvm_release_page_clean(struct page *page);
>  void kvm_release_page_dirty(struct page *page);
>  
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
>  struct kvm_follow_pfn {
>  	const struct kvm_memory_slot *slot;
>  	gfn_t gfn;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 913de4e86d9d..4d8538cdb690 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2979,17 +2979,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
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


Best regards,
	Maxim Levitsky




