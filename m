Return-Path: <kvm+bounces-9507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 255D3860ED3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C94C1F24B96
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD2D5C912;
	Fri, 23 Feb 2024 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8dkWQBp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A425014F8C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708682446; cv=none; b=nWfNnph8MCQE2gueUezQ/PiY1FbvyIudzwzAq1Ho4qWQYNW/jTZOuIDtY9undjkvutBnQjXupZnwTHcPHN7XhbyFlgleZL8zDjSuWqvrSbjizR1ATZviXFenb9sSxXLzUgcBFzSr8uVbQOeNifzqsF8xj6+Xan++B1weah4ddO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708682446; c=relaxed/simple;
	bh=NMigld2pzKlBahPdJK61L5TqHaArO25Rk85OMIY3FJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AhmXAkQZ21PJLS5XCkr0NwRz0N6D2J6nLm1YNQUFazZ7DPjhJo5Kls4iibMLqn/V5cB5w+RGtpngIR/xr7svhzCR1B1MFJpqrGz3sR9UzGj1NAr5u4e+KRO7ce7McJwl9saxZNHzl4y+4t1e9szaiA6bqJ9babsX4inb4umKWDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8dkWQBp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708682442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMxU6mWYxU/uR8JFHXPXzXOoISCHQJaMCW+CTaHOAQg=;
	b=h8dkWQBpyGqGNIJHllCWZAU7DkG+Zar40iEmAXQlHuSpUZ4cJ/g6IjQNzVbwVJKh+yK244
	9+PXoFE7qxbT9kqemocYJIYH0ZUCj1UP/ofyh0w7/dbmBooJjPdHJk5ZkZOygzwWYtD/bH
	BlToxyJvHnFHf0hOJy9vShzbm8AxmSg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-ZHQB8bKMN1e0LmuWJ46Q7w-1; Fri, 23 Feb 2024 05:00:41 -0500
X-MC-Unique: ZHQB8bKMN1e0LmuWJ46Q7w-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56419ff458dso386269a12.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 02:00:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708682440; x=1709287240;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMxU6mWYxU/uR8JFHXPXzXOoISCHQJaMCW+CTaHOAQg=;
        b=LyRW1sQybMeRqQGUfsar0r5rjnFQV+5AD+zxLp89ERfa/rG2rMhhqUIn3V7k4U8d0P
         7UAo7EOlKFdGnlpzET1jIPeF5E6PiXlnegsgZmt0MEg4QEMow21hpKeIXGjzXCbMq8WM
         2UcWu9veWqS/wF3YEAfohd53i4opRt/4PTNgIQANjT1zDE7u7JlcTXL79edNviZSzeCs
         CuCoS05i8RPeCMzcr1bHlJK/8BGKE/QSoz2g6OVyNARWMLf/DG+WGlQqKHBR4pc/kUuW
         KkGbpx4CzjTjKTFQYVsDr7XYNbmplkJRr7h5jShrG6Dwx8dnaXSEIiSI/SxMWWZZ0i+a
         kBmg==
X-Forwarded-Encrypted: i=1; AJvYcCUrO1N2MdcTlyvqJ71JcQgefHGZCOd8U+LhHazbxt/FX+FEIGeML+kFXv8ttCARvdcnQ+H0xSplnaGyCEF8OEY11ZM/
X-Gm-Message-State: AOJu0YyURg6NhC1ZBdKm1nAl3xmmPXRRQGssW3DiV5Iqru9LI9Rck7Tb
	95jTZFgFErKNlOMkgRJENLcwT5qs2vSChDz9ITUtMBEsUKSrBBbxCep77/iT/XWicKZ5Urmy32O
	XmECJUejRsJJb3/U81uwDUzp/7Ni2zykda0tlHebPQk5hR1soOg==
X-Received: by 2002:aa7:d44c:0:b0:564:ae07:e539 with SMTP id q12-20020aa7d44c000000b00564ae07e539mr835439edr.25.1708682440062;
        Fri, 23 Feb 2024 02:00:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEq5hJw0hKyX1/dqgQUMqF1Vr9EFWv4sZcr8UzjLvk3u2CLAjN84uupnScsDumhLpH0CP/otQ==
X-Received: by 2002:aa7:d44c:0:b0:564:ae07:e539 with SMTP id q12-20020aa7d44c000000b00564ae07e539mr835419edr.25.1708682439664;
        Fri, 23 Feb 2024 02:00:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id f17-20020a056402005100b005648d0eebdbsm150534edu.96.2024.02.23.02.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 02:00:39 -0800 (PST)
Message-ID: <f6296a0c-df91-4de8-833e-dc13b9286a2e@redhat.com>
Date: Fri, 23 Feb 2024 11:00:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted
 pages
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240221072528.2702048-1-stevensd@google.com>
 <20240221072528.2702048-10-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20240221072528.2702048-10-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 08:25, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Use one of the unused bits in EPT sptes to track whether or not an spte
> refers to a struct page that has a valid refcount, in preparation for
> adding support for mapping such pages into guests. The new bit is used
> to avoid triggering a page_count() == 0 warning and to avoid touching
> A/D bits of unknown usage.
> 
> Non-EPT sptes don't have any free bits to use, so this tracking is not
> possible when TDP is disabled or on 32-bit x86.

TDX will add support for non-zero non-present PTEs.  We could use this 
to use inverted bit 8 to mark present PTEs (bit 8 set for non-present, 
bit 8 clear for present) for both shadow paging and AMD NPT.  This would 
free bit 11 for SPTE_MMU_PAGE_REFCOUNTED.

No need to do it now, though.

Paolo

> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 43 +++++++++++++++++++---------------
>   arch/x86/kvm/mmu/paging_tmpl.h |  5 ++--
>   arch/x86/kvm/mmu/spte.c        |  4 +++-
>   arch/x86/kvm/mmu/spte.h        | 22 ++++++++++++++++-
>   arch/x86/kvm/mmu/tdp_mmu.c     | 21 ++++++++++-------
>   include/linux/kvm_host.h       |  3 +++
>   virt/kvm/kvm_main.c            |  6 +++--
>   7 files changed, 70 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bbeb0f6783d7..7c059b23ae16 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -541,12 +541,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>   
>   	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
>   		flush = true;
> -		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +		if (is_refcounted_page_spte(old_spte))
> +			kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
>   	}
>   
>   	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
>   		flush = true;
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		if (is_refcounted_page_spte(old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
>   	}
>   
>   	return flush;
> @@ -578,20 +580,23 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>   
>   	pfn = spte_to_pfn(old_spte);
>   
> -	/*
> -	 * KVM doesn't hold a reference to any pages mapped into the guest, and
> -	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
> -	 * before they are reclaimed.  Sanity check that, if the pfn is backed
> -	 * by a refcounted page, the refcount is elevated.
> -	 */
> -	page = kvm_pfn_to_refcounted_page(pfn);
> -	WARN_ON_ONCE(page && !page_count(page));
> +	if (is_refcounted_page_spte(old_spte)) {
> +		/*
> +		 * KVM doesn't hold a reference to any pages mapped into the
> +		 * guest, and instead uses the mmu_notifier to ensure that KVM
> +		 * unmaps any pages before they are reclaimed. Sanity check
> +		 * that, if the pfn is backed by a refcounted page, the
> +		 * refcount is elevated.
> +		 */
> +		page = kvm_pfn_to_refcounted_page(pfn);
> +		WARN_ON_ONCE(!page || !page_count(page));
>   
> -	if (is_accessed_spte(old_spte))
> -		kvm_set_pfn_accessed(pfn);
> +		if (is_accessed_spte(old_spte))
> +			kvm_set_page_accessed(pfn_to_page(pfn));
>   
> -	if (is_dirty_spte(old_spte))
> -		kvm_set_pfn_dirty(pfn);
> +		if (is_dirty_spte(old_spte))
> +			kvm_set_page_dirty(pfn_to_page(pfn));
> +	}
>   
>   	return old_spte;
>   }
> @@ -627,8 +632,8 @@ static bool mmu_spte_age(u64 *sptep)
>   		 * Capture the dirty status of the page, so that it doesn't get
>   		 * lost when the SPTE is marked for access tracking.
>   		 */
> -		if (is_writable_pte(spte))
> -			kvm_set_pfn_dirty(spte_to_pfn(spte));
> +		if (is_writable_pte(spte) && is_refcounted_page_spte(spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
>   
>   		spte = mark_spte_for_access_track(spte);
>   		mmu_spte_update_no_track(sptep, spte);
> @@ -1267,8 +1272,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
>   {
>   	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
>   					       (unsigned long *)sptep);
> -	if (was_writable && !spte_ad_enabled(*sptep))
> -		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
> +	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_spte(*sptep))
> +		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
>   
>   	return was_writable;
>   }
> @@ -2946,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   	}
>   
>   	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
> -			   true, host_writable, &spte);
> +			   true, host_writable, true, &spte);
>   
>   	if (*sptep == spte) {
>   		ret = RET_PF_SPURIOUS;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4d4e98fe4f35..c965f77ac4d5 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -902,7 +902,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>    */
>   static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
>   {
> -	bool host_writable;
> +	bool host_writable, is_refcounted;
>   	gpa_t first_pte_gpa;
>   	u64 *sptep, spte;
>   	struct kvm_memory_slot *slot;
> @@ -959,10 +959,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>   	sptep = &sp->spt[i];
>   	spte = *sptep;
>   	host_writable = spte & shadow_host_writable_mask;
> +	is_refcounted = is_refcounted_page_spte(spte);
>   	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>   	make_spte(vcpu, sp, slot, pte_access, gfn,
>   		  spte_to_pfn(spte), spte, true, false,
> -		  host_writable, &spte);
> +		  host_writable, is_refcounted, &spte);
>   
>   	return mmu_spte_update(sptep, spte);
>   }
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4a599130e9c9..efba85df6518 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	       const struct kvm_memory_slot *slot,
>   	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>   	       u64 old_spte, bool prefetch, bool can_unsync,
> -	       bool host_writable, u64 *new_spte)
> +	       bool host_writable, bool is_refcounted, u64 *new_spte)
>   {
>   	int level = sp->role.level;
>   	u64 spte = SPTE_MMU_PRESENT_MASK;
> @@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   
>   	if (level > PG_LEVEL_4K)
>   		spte |= PT_PAGE_SIZE_MASK;
> +	if (spte_has_refcount_bit() && is_refcounted)
> +		spte |= SPTE_MMU_PAGE_REFCOUNTED;
>   
>   	if (shadow_memtype_mask)
>   		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index a129951c9a88..4101cc9ef52f 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -96,6 +96,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
>   /* Defined only to keep the above static asserts readable. */
>   #undef SHADOW_ACC_TRACK_SAVED_MASK
>   
> +/*
> + * Indicates that the SPTE refers to a page with a valid refcount.
> + */
> +#define SPTE_MMU_PAGE_REFCOUNTED        BIT_ULL(59)
> +
>   /*
>    * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
>    * the memslots generation and is derived as follows:
> @@ -345,6 +350,21 @@ static inline bool is_dirty_spte(u64 spte)
>   	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
>   }
>   
> +/*
> + * Extra bits are only available for TDP SPTEs, since bits 62:52 are reserved
> + * for PAE paging, including NPT PAE. When a tracking bit isn't available, we
> + * will reject mapping non-refcounted struct pages.
> + */
> +static inline bool spte_has_refcount_bit(void)
> +{
> +	return tdp_enabled && IS_ENABLED(CONFIG_X86_64);
> +}
> +
> +static inline bool is_refcounted_page_spte(u64 spte)
> +{
> +	return !spte_has_refcount_bit() || (spte & SPTE_MMU_PAGE_REFCOUNTED);
> +}
> +
>   static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
>   				int level)
>   {
> @@ -475,7 +495,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	       const struct kvm_memory_slot *slot,
>   	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>   	       u64 old_spte, bool prefetch, bool can_unsync,
> -	       bool host_writable, u64 *new_spte);
> +	       bool host_writable, bool is_refcounted, u64 *new_spte);
>   u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
>   		      	      union kvm_mmu_page_role role, int index);
>   u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6ae19b4ee5b1..ee497fb78d90 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -414,6 +414,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   	bool was_leaf = was_present && is_last_spte(old_spte, level);
>   	bool is_leaf = is_present && is_last_spte(new_spte, level);
>   	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> +	bool is_refcounted = is_refcounted_page_spte(old_spte);
>   
>   	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
>   	WARN_ON_ONCE(level < PG_LEVEL_4K);
> @@ -478,9 +479,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   	if (is_leaf != was_leaf)
>   		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
>   
> -	if (was_leaf && is_dirty_spte(old_spte) &&
> +	if (was_leaf && is_dirty_spte(old_spte) && is_refcounted &&
>   	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
>   
>   	/*
>   	 * Recursively handle child PTs if the change removed a subtree from
> @@ -492,9 +493,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>   		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
>   
> -	if (was_leaf && is_accessed_spte(old_spte) &&
> +	if (was_leaf && is_accessed_spte(old_spte) && is_refcounted &&
>   	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +		kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
>   }
>   
>   /*
> @@ -956,8 +957,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>   	else
>   		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> -					 fault->map_writable, &new_spte);
> +				   fault->pfn, iter->old_spte, fault->prefetch, true,
> +				   fault->map_writable, true, &new_spte);
>   
>   	if (new_spte == iter->old_spte)
>   		ret = RET_PF_SPURIOUS;
> @@ -1178,8 +1179,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>   		 * Capture the dirty status of the page, so that it doesn't get
>   		 * lost when the SPTE is marked for access tracking.
>   		 */
> -		if (is_writable_pte(iter->old_spte))
> -			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
> +		if (is_writable_pte(iter->old_spte) &&
> +		    is_refcounted_page_spte(iter->old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter->old_spte)));
>   
>   		new_spte = mark_spte_for_access_track(iter->old_spte);
>   		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
> @@ -1602,7 +1604,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>   		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
>   					       iter.old_spte,
>   					       iter.old_spte & ~dbit);
> -		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
> +		if (is_refcounted_page_spte(iter.old_spte))
> +			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
>   	}
>   
>   	rcu_read_unlock();
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f72c79f159a2..cff5df6b0c52 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1211,6 +1211,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
>   void kvm_release_page_clean(struct page *page);
>   void kvm_release_page_dirty(struct page *page);
>   
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
>   struct kvm_follow_pfn {
>   	const struct kvm_memory_slot *slot;
>   	gfn_t gfn;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5d66d841e775..e53a14adf149 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3281,17 +3281,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
>   	return !PageReserved(page);
>   }
>   
> -static void kvm_set_page_dirty(struct page *page)
> +void kvm_set_page_dirty(struct page *page)
>   {
>   	if (kvm_is_ad_tracked_page(page))
>   		SetPageDirty(page);
>   }
> +EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
>   
> -static void kvm_set_page_accessed(struct page *page)
> +void kvm_set_page_accessed(struct page *page)
>   {
>   	if (kvm_is_ad_tracked_page(page))
>   		mark_page_accessed(page);
>   }
> +EXPORT_SYMBOL_GPL(kvm_set_page_accessed);
>   
>   void kvm_release_page_clean(struct page *page)
>   {


