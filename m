Return-Path: <kvm+bounces-53128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A03BB0DE1A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98D2E585115
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C452EE281;
	Tue, 22 Jul 2025 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lMXDxgab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40012EAB79
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193479; cv=none; b=ML3LC7c0dUldIJ6okzWCcdkPA2lm4bYeaxuwKWCZ/+ZdBRE2hbkAaNxxNS2xHb64ZVsDsruJLkHKaM6tuUaikffNo1MC+q2qzUO0pxaqhFInl4CsAr9qEFEZ4JMu/tExK6tVTehhZTm7Az/3UjbLaSvM/HkUcZe6TrWRazxJ7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193479; c=relaxed/simple;
	bh=wRwXjhWlbKKzAfQxAC+BDSH/bfNklI92eBAGV10UszE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkCoyLtxtHmxFUqmIhhq1/W1usHnn65ZKH2uKyM/wWmypA21yVtz5VOdRa7O+HL9/fvUjx4fSS9Zor1H4n3VjiebzU4qwtsUjp/zAIOPrUnh7bvrpXFFjF/cjxiYPcmafp0kMZc5Abms2zz6JxNBSsEotPrebrdTQH924sK+YYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lMXDxgab; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so6378657a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753193476; x=1753798276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhr5DdAG1y4qmrkRFBW7TPP793xjLuWMlbUZVYJdXY0=;
        b=lMXDxgabbUNfLs2Jolc7mh5wCxHRrJaCR0/9UPy7YP89yoMeW8Ps0xtO1gZHZblsYU
         1yRGwjl5Fks1XpiQa4CewjTo6fFDc/vd84TZoT5XXd8ndogLNivG3luTvy5uXqGgkAEz
         yM4YGST3KGW/klvgGCgL33wKP6jcWtS0iqqdWnnleb//KqcFkULLs4Vq9rpS32oWPxyk
         RWxgWUu6/b6/DRkeoa3IJKE03v/SJZJ+nkzOf2e5kybI5VN0Hdqm793PYERRZz6iroOi
         8IyIELzAbD24KtRLSirUDRQeFc9JGKoxFqbhJFPOlClAMLmlUOc9VIPpl+aVVZsqT1aW
         0Cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753193476; x=1753798276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhr5DdAG1y4qmrkRFBW7TPP793xjLuWMlbUZVYJdXY0=;
        b=DiBpSk1trwDqJSsTEbhzBq+I1ZFi51XGaDauv7+onetUfniGx7kJ+B9ug9DRD9LYNQ
         fyXRa0EL2yWYTtMq7zWXGdjCEOY3VOh49zODicGmDFZnrusrwSLW1USL8Wy7dUg1uyvX
         2zr3fwIlHkXw+oijvueBewa7qEicM1R3RG5tVC2l8I6+I6j82zJ/awst8itV9TD4Qjsn
         xMCpB45YKs9bzPh/2ToyvdEBI1Z0uO9dm+bQ2+GcUzbV07fydV2O8sjtRi8kWQ1gLF0M
         hyXDCF7yp8Iwv+KvmMKuXm9bz9z2CuIgQUKIYrjSGk7sZ/rPbWss9LNiTTETMzh9j854
         s7hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYiHYdW9laxNwh/4NpwZ+RyH4UDJpGCr7zfaHvXEptBXcBngKgW3Zaun7OdwNFMZE698Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+xLzLs01lOZubBfBKpgTjAgsiSxbR+bg4UjbFWMCgN/f4/6KU
	xJr0Dkcp4eBLnZFP+6Qj/jBoggLatLFt7GdbYAC0aAPbwEKt8mShKMJUVDmpcrk6HI90IZ8e2lk
	fxvyj+Q==
X-Google-Smtp-Source: AGHT+IHz6YqAcopC+P6ScKSU5WWDSjba8vHQ5SgWsdgu/3WXQBnQE+NEWNjk1kKSfQgkq2XdBsLFy0RsPC8=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350e:b0:315:f6d6:d29c
 with SMTP id 98e67ed59e1d1-31e3e1f12a8mr4913476a91.15.1753193476158; Tue, 22
 Jul 2025 07:11:16 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:11:14 -0700
In-Reply-To: <20250722131533.106473-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722131533.106473-1-adrian.hunter@intel.com> <20250722131533.106473-2-adrian.hunter@intel.com>
Message-ID: <aH-b5UAkokFocLvG@google.com>
Subject: Re: [PATCH V3 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, vannapurve@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Adrian Hunter wrote:
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 7ddef3a69866..f66328404724 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> +void tdx_quirk_reset_paddr(unsigned long base, unsigned long size);
> +
>  struct tdx_td {
>  	/* TD root structure: */
>  	struct page *tdr_page;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 573d6f7d1694..1b549de6da06 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -283,25 +283,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>  	vcpu->cpu = -1;
>  }
>  
> -static void tdx_clear_page(struct page *page)
> -{
> -	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> -	void *dest = page_to_virt(page);
> -	unsigned long i;
> -
> -	/*
> -	 * The page could have been poisoned.  MOVDIR64B also clears
> -	 * the poison bit so the kernel can safely use the page again.
> -	 */
> -	for (i = 0; i < PAGE_SIZE; i += 64)
> -		movdir64b(dest + i, zero_page);
> -	/*
> -	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> -	 * from seeing potentially poisoned cache.
> -	 */
> -	__mb();
> -}
> -
>  static void tdx_no_vcpus_enter_start(struct kvm *kvm)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -347,7 +328,7 @@ static int tdx_reclaim_page(struct page *page)
>  
>  	r = __tdx_reclaim_page(page);
>  	if (!r)
> -		tdx_clear_page(page);
> +		tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);

This is silly.  Literally every use in KVM is on a struct page.  I agree with
Dave that having a wrapper with a completely unrelated name is confusing, but
that's a naming problem, not a code problem.

And FWIW, I find tdx_quirk_reset_paddr() confusing, because it reads like it's
resetting the address itself.  But if KVM only ever uses tdx_quirk_reset_page(),
I don't care what you call the inner helper.

