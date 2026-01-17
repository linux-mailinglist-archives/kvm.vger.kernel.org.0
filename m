Return-Path: <kvm+bounces-68422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE839D38AFB
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61A59307B3A9
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52991D90DF;
	Sat, 17 Jan 2026 01:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GWkhClwK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4F5140E5F
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768611726; cv=none; b=e14A95p6u+S/gc8u6/RTTVKXYGF79sv+pVmQ8yJevG1q+wPNjUJmT0fSIcQO+UCXME9MWlqI/6uT5GhsLkTFDKoRy4B9ttlDrdZ82lZMDUl2+71EvprG7Ex38IzhM/0kFhKEXyQgQANC/YNT1XjscYtVUT3NQ5jpRgc2hPoZMXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768611726; c=relaxed/simple;
	bh=387TLTU83paT+jk/XoywCNBbbdR4aObP3kXaD1x/h9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SsmYxib0wtXM+FS6RbjFmlpG5BWxrnozo/EXBaFHeAHCE9ZjJpLCycTGmCBG3SQdm9W/yu38roKc0z2W4Y7hAa2OGj2ZHiBihzwKWr4t0T9J/qjluvbra19v3mwLGN0EBVK7VCS7Qn/fVIXFxWn+KeaW77TviiYuAjLDXSpw9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GWkhClwK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ea5074935so2428056a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768611725; x=1769216525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=33kwIywl/krx+QdnC8KwFooydqEwwakdHI97f7zntIM=;
        b=GWkhClwKwL9zquNgNAPBDRCwL8UVQcdPdIOxHkqKEYCbiMFs6enE5Oec4z+7sdsBjJ
         lqAV+icp2sM5quMs9nhYeIw2Yw1TJI2OUqSDziZZip10b74pyw7UFiq4N1o9l7D+NF0+
         FepYcj61SOD3SJLrDmKnpBdJVgAaepIc2a1QE4US4rsVO+TQJBNfpOCnKsr/N9d4HfWh
         WmJt24exxQ+ELkDOERYvSDscJfI04o5nLanZYEFCVeg08g1kcnKp2TVB7wf870tAS3QN
         eiL+o+t8emhJljNuav21hDwWLyL68QBzyz4QQwyfuNN5rvNpSdQRHYD2VhCONMoRkTHK
         LYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768611725; x=1769216525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33kwIywl/krx+QdnC8KwFooydqEwwakdHI97f7zntIM=;
        b=iPcY+RA/W5x7NEDd3XEEt3VQBuIiwfnde/ccB2KJqrjIUpbsqAOY0U6n79SogvdzmZ
         tASVvZVRzDolW25X//UfJZ3RlrZjMgpCfy1TmqykTyxJQidBCQ5pRUUz139YJM5vqq7t
         eGNV4wBwA3fNNW/GfsMOZ5BYdOLFdzjSPOoNdbkIaklZI0TsHz9fxq0BuGTfGCkKGVar
         UCFnKo2tCfPINsdvKbYXaRjFAXsKDQBDNmm2jBPjqxlI9dbc8lPppmZAbbDkDgUHXgdO
         w9OHModmxlF6GMUk1oa58bqjid71TIV90PabBi/h0yLJM5boU97Gnd6a+DYtWBtkb25+
         OlMw==
X-Forwarded-Encrypted: i=1; AJvYcCVtkBtqDpo5g07ffctZQwnE7J8GvxSNMfwsjS8O3ryQL5S6zFMKF1BNvHnBqmygljddzAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGjJ84XYgGfZhjgiNtL8eH+mskz46s4IcCth6AwtB7dQG52YmP
	IhIgRrAw/CqxHnrEeAYLwaK1o1BX6C8MdaPgLqsWi/8oQpUyHdsIeMXVYqjoBTkfe3+/JdTh5Q2
	6zizQoA==
X-Received: from pjtn4.prod.google.com ([2002:a17:90a:c684:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5101:b0:34a:8c77:d37b
 with SMTP id 98e67ed59e1d1-352731799d0mr4376642a91.16.1768611724820; Fri, 16
 Jan 2026 17:02:04 -0800 (PST)
Date: Fri, 16 Jan 2026 17:02:03 -0800
In-Reply-To: <20251121005125.417831-13-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com> <20251121005125.417831-13-rick.p.edgecombe@intel.com>
Message-ID: <aWrfi8Oy6WXhiNv1@google.com>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 20, 2025, Rick Edgecombe wrote:
> ---
> v4:
>  - Change to GFP_KERNEL_ACCOUNT to match replaced kvm_mmu_memory_cache
>  - Add GFP_ATOMIC backup, like kvm_mmu_memory_cache has (Kiryl)

LOL, having fun reinventing kvm_mmu_memory_cache? :-D

>  - Explain why not to use mempool (Dave)
>  - Tweak local vars to be more reverse christmas tree by deleting some
>    that were only added for reasons that go away in this patch anyway
> ---
>  arch/x86/include/asm/tdx.h  | 43 ++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.c      | 21 +++++++++++++-----
>  arch/x86/kvm/vmx/tdx.h      |  2 +-
>  arch/x86/virt/vmx/tdx/tdx.c | 22 +++++++++++++------
>  virt/kvm/kvm_main.c         |  3 ---
>  5 files changed, 75 insertions(+), 16 deletions(-)

> +/*
> + * Simple structure for pre-allocating Dynamic
> + * PAMT pages outside of locks.

As called out in an earlier patch, it's not just PAMT pages.

> + */
> +struct tdx_prealloc {
> +	struct list_head page_list;
> +	int cnt;
> +};
> +
> +static inline struct page *get_tdx_prealloc_page(struct tdx_prealloc *prealloc)
> +{
> +	struct page *page;
> +
> +	page = list_first_entry_or_null(&prealloc->page_list, struct page, lru);
> +	if (page) {
> +		list_del(&page->lru);
> +		prealloc->cnt--;
> +	}
> +
> +	return page;
> +}
> +
> +static inline int topup_tdx_prealloc_page(struct tdx_prealloc *prealloc, unsigned int min_size)
> +{
> +	while (prealloc->cnt < min_size) {
> +		struct page *page = alloc_page(GFP_KERNEL_ACCOUNT);
> +
> +		if (!page)
> +			return -ENOMEM;
> +
> +		list_add(&page->lru, &prealloc->page_list);

Huh, TIL that page->lru is fair game for private usage when the page is kernel-
allocated.  

> +		prealloc->cnt++;
>
>  static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
>  {
> -	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct tdx_prealloc *prealloc = &to_tdx(vcpu)->prealloc;
> +	int min_fault_cache_size;
>  
> -	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
> +	/* External page tables */
> +	min_fault_cache_size = cnt;
> +	/* Dynamic PAMT pages (if enabled) */
> +	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
> +
> +	return topup_tdx_prealloc_page(prealloc, min_fault_cache_size);
>  }
>  
>  static void tdx_free_external_fault_cache(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct page *page;
>  
> -	kvm_mmu_free_memory_cache(&tdx->mmu_external_spt_cache);
> +	while ((page = get_tdx_prealloc_page(&tdx->prealloc)))
> +		__free_page(page);

No.  Either put the ownership of the PAMT cache in arch/x86/virt/vmx/tdx/tdx.c
or use kvm_mmu_memory_cache.  Don't add a custom caching scheme in KVM.
  
>  /* Number PAMT pages to be provided to TDX module per 2M region of PA */
> -static int tdx_dpamt_entry_pages(void)
> +int tdx_dpamt_entry_pages(void)
>  {
>  	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>  		return 0;
>  

A comment here stating the "common" number of entries would be helper.  I have no
clue as to the magnitude.  E.g. this could be 2 or it could be 200, I genuinely
have no idea.

