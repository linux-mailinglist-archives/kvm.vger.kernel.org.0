Return-Path: <kvm+bounces-52107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00729B016DE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DD49566713
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7E521ABCB;
	Fri, 11 Jul 2025 08:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JkwZzsuF"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4131213E9F;
	Fri, 11 Jul 2025 08:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223958; cv=none; b=Gz99FCnDHrkRAKxjEgQwyWEt/V1nyanM9S18FYp+eC7uH6gFdhfcdzRm0AGLeIrbLFldgm4qCzMuA/of2BGV7oggWKCSgq5GM5oEb0YtBNF1qTQzSWBVHSzjp0UG23gfmCYo+evGgF8WDK6zoGYCP/67lRFYFReOKNNLYebMvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223958; c=relaxed/simple;
	bh=ay7MW8JKx2jdPUdeChqtmYV9yyRKEgfYKBEIfZdnNcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0JRWZ+ytucIa1uMZ8UZeaxrN0XdtlPpMXq9cVFKAeYsV1qZotRWjYtCmKVYN25NsxRgU8Vg4dOt8915zl0d6nFXheseJD/UaidIwpje76lMaWnHfXW2Lx1pS65LS+TGD2QRG5v+mprjiVQ0+BiH/VCuIGvzLQXcweZfNGkIexg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JkwZzsuF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wYHoau81VTJVn1Ls5cS2yLxxY36G9E5eaFrXLtksm1g=; b=JkwZzsuFOvuPFHCMaGzXJWbtHA
	ZLdyO6+HWPsb3yj/IxWDVNKCVGWnO16CkAt3nf4I6dPqlS/xIaprl/Yu6szH3aaT1nUpkN1+RWKPh
	eip82Jjcq6Y6j6jBGY3wd/PsOpOVT4gzXoDyp8GHQec6duWSJoCfhhR0cSWKfChY5YsDjcTtfT1rq
	7qDhw8S1C8W4mN493ef9sCvKvShPkKbZeTpn+ATt/gNafhK4lvuchWEK/5PwFoxs0JD9AY9Yv8ZDV
	SZih5OCmWzbGhsyk77X2NBAfXLYT/7lyaZ6T7kGZ2IWtUG6vKWTjkumu2ECxHDjf1hjNBupXdtO3o
	AP008Fcg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ua9UR-00000009EDX-3xTK;
	Fri, 11 Jul 2025 08:52:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7AC303001AA; Fri, 11 Jul 2025 10:52:19 +0200 (CEST)
Date: Fri, 11 Jul 2025 10:52:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Kevin Loughlin <kevinloughlin@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Mingwei Zhang <mizhang@google.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <20250711085219.GA3108775@noisy.programming.kicks-ass.net>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
 <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
 <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>

On Thu, Jul 10, 2025 at 05:47:05PM +0200, Peter Zijlstra wrote:

> So kvm-amd is the SEV stuff, AGPGART is the ancient crap nobody cares
> about, CCP is more SEV stuff, DRM actually does CLFLUSH loops, but has a
> WBINVD fallback. i915 is rude and actually does WBINVD. Could they
> pretty please also do CLFLUSH loops?

So having looked at i915 a little more:

drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c:      * Currently we just do a heavy handed wbinvd_on_all_cpus() here since
drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c:             wbinvd_on_all_cpus();

This one can be runtime; but is only applied on certain parts that might
be less than coherent -- hopefully not new parts, but who knows.

Parts not taking this path end up calling drm_clflush_sg(), which DTRT.


And these all look suspend/resume related, so we can live with them:

drivers/gpu/drm/i915/gem/i915_gem_pm.c:#define wbinvd_on_all_cpus() \
drivers/gpu/drm/i915/gem/i915_gem_pm.c:         wbinvd_on_all_cpus();
drivers/gpu/drm/i915/gem/i915_gem_pm.c: wbinvd_on_all_cpus();
drivers/gpu/drm/i915/gt/intel_ggtt.c:           wbinvd_on_all_cpus();


