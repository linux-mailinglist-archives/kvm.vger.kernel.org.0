Return-Path: <kvm+bounces-47094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13669ABD3A3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B0994A220A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27190268C42;
	Tue, 20 May 2025 09:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9bihbti"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4623521C9EE;
	Tue, 20 May 2025 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734091; cv=none; b=dtb7oxXaPZedEbSv8miANJr3afIlugeVFIgZUp60TfXSPpCxCwNv+mYO3CA0+QqH7zJ/Y7LIwppn95nslxYS6fgmLznnGvq5QG+UiU6VPFbvlf0Bn1w/frjv6FNotOXavu0tDFxyuXHsx4v4DKYFDNlM80KwUhHk4Qm+Ht7IeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734091; c=relaxed/simple;
	bh=B9V4qKH/i2E6tTGsCihryVv51mK/NkF7DleeEUfylJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePzKEamhBCOl63yq17+DbQtIq6/Tz4A2cVyd5K3icPbU8mVVGdVUaAFs1FQ1TESiKSCcvsvCAzeF51gHTpj/5srUeseaPfOgtiZ+XjofRl43+IGH5e5BZhFxk4B0yNsN+CVgjV2dOKXSggEO3nBeg6XnBxA5n5RZ0wNsRYzFFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9bihbti; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0C7C4CEEB;
	Tue, 20 May 2025 09:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747734090;
	bh=B9V4qKH/i2E6tTGsCihryVv51mK/NkF7DleeEUfylJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9bihbti/zHkO7bNWfl3FNjyyDAvgGIFI03fN1Zy2940E5kNMtKoZkx9NDQiFRPTs
	 pOFCN5jDOYRdQwoDSKZEmaS2AMsVaQS+IsuDEbaRCfuNgChUaZOF3SJlmw9StJsrR1
	 xT4GvbMEZs0a9rFFgFG8Eh2tnbe8VLhqhe/P0882MM2FLPjCv2P37ctawPBaM2ln7r
	 1vpFDl4TsOm1BgVLibctOaaYHuaHCTezYGO/J3fnsXZWaEB6Dy5KA1I6d1sUuNAlER
	 sJqhwX4+YFJVGbu1D39rCtcKSgoFWDqUsoY3BmWFU73AddxobgQ1y+zU8JGSd8uLBq
	 kH3VCQ8TEqD+w==
Date: Tue, 20 May 2025 11:41:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kevin Loughlin <kevinloughlin@google.com>,
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 4/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <aCxORJga9goyt9N7@gmail.com>
References: <20250516212833.2544737-1-seanjc@google.com>
 <20250516212833.2544737-5-seanjc@google.com>
 <aCgw6sbpE6f42sC_@gmail.com>
 <aCtcqlP8MAqgyTbd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCtcqlP8MAqgyTbd@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> > and to point out that the 'invalidate' part of the WBNOINVD name is 
> > a misnomer, as it doesn't invalidate anything, it only writes back 
> > dirty cachelines.
> 
> I wouldn't call it a misnomer, the NO part makes it semantically 
> accurate.

If only 'NO' in that context was unambiguous: initially I fully read it 
as some sort of acronym or abbreviation :) Why wasn't it named WBCACHE 
or so? But I digress.

> [...]  I actually think the mnemonic was well chosen, as it helps 
> capture the relationships and behaviors of INVD, WBINVD, and 
> WBNOINVD.
> 
> How about this?

Much better!

> +/*
> + * Write back all modified lines in all levels of cache associated with this
> + * logical processor to main memory, and then invalidate all caches.  Depending
> + * on the micro-architecture, WBINVD (and WBNOINVD below) may or may not affect
> + * lower level caches associated with another logical processor that shares any
> + * level of this processor’s cache hierarchy.
> + *
> + * Note, AMD CPUs enumerate the behavior or WB{NO}{INVD} with respect to other
> + * logical, non-originating processors in CPUID 0x8000001D.EAX[N:0].
> + */
>  static __always_inline void wbinvd(void)
>  {
> +       asm volatile("wbinvd" : : : "memory");
> +}
> +
> +/* Instruction encoding provided for binutils backwards compatibility. */
> +#define ASM_WBNOINVD _ASM_BYTES(0xf3,0x0f,0x09)
> +
> +/*
> + * Write back all modified lines in all levels of cache associated with this
> + * logical processor to main memory, but do NOT explicitly invalidate caches,
> + * i.e. leave all/most cache lines in the hierarchy in non-modified state.
> + */
> +static __always_inline void wbnoinvd(void)
> +{
> +       /*
> +        * Explicitly encode WBINVD if X86_FEATURE_WBNOINVD is unavailable even
> +        * though WBNOINVD is backwards compatible (it's simply WBINVD with an
> +        * ignored REP prefix), to guarantee that WBNOINVD isn't used if it
> +        * needs to be avoided for any reason.  For all supported usage in the
> +        * kernel, WBINVD is functionally a superset of WBNOINVD.
> +        */
> +       alternative("wbinvd", ASM_WBNOINVD, X86_FEATURE_WBNOINVD);
>  }

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

