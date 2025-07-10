Return-Path: <kvm+bounces-52048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C40BB007E6
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDB317BFF2B
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F9E27AC25;
	Thu, 10 Jul 2025 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vN9Ev23k"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9349D43169;
	Thu, 10 Jul 2025 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163121; cv=none; b=n+7o0kmJXLQijevxVj70m0Ro96pnxR6xAtlR3YAcfMg/bGx1T8jnL3BwqvVf3sHF0EEsV2z6OrSrOfSBJjwQ2EIduzIycHCU/cZ44q69SbYTGcOJUSjlV6gO+QODFrZH+xNKw3mepZ70YgpczqGBr+9qJucmYbe3/rEYQaFUq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163121; c=relaxed/simple;
	bh=Ug/xuZy4+C63jQXlPrpv32eUh4tPCngp8U/00/gVLGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXVMiOCfUn9ACaP+Fq1LE4lgVcPQ2LSXqTTs1tjRmPh+ArJ1Qr99MRG7gPp6BHtBevqTbddFkzLjoH5EZJIPKR70Ex5O+XoERNO5h12pOiCteiQySAUvOA6Cw7ZCrBCtA3OJODplur2S5E7oH/lZb1ZmK4hNcn6BfFxUCnY+rpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vN9Ev23k; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VNSSl7zcfIOqJpK24zVMGGLJHAtlPxO/oNxdIpnF5F0=; b=vN9Ev23kcMljgdfRBvSifEtfjX
	f+yn1QegKA1zMOQFhhMX05TBc/Cl1PbBQ+tBZaoJ3FgLBNrymKgKoIt+r9efxT13D1A3kRXDTlNOq
	TGO/aR+sDKHjfuQpKOKWY29gtwL42lmfKR3p2dlBAtOFT1VrWeS9s/3P/iH6h+9ICouyx6XwzpAKW
	dMSIH9DO/sazRV3YP1LlsKnU8hp2ofhoTsV8X8zFevifZbuNSvkxWKxV96Vs3g/4M0O1OQqvSik/e
	LbOdXmQGoPnQP+pK7Nw/4HtFZmcWiE2U3+r3PmGpmguVQW6l1aprioMUd7XVvHkox9PfaX9cjFyWl
	foduRo6w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZtfF-00000009VNm-28hO;
	Thu, 10 Jul 2025 15:58:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2247D300158; Thu, 10 Jul 2025 17:58:25 +0200 (CEST)
Date: Thu, 10 Jul 2025 17:58:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20250710155824.GA905792@noisy.programming.kicks-ass.net>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
 <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
 <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
 <aG_iVqMkeIUELiTX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG_iVqMkeIUELiTX@google.com>

On Thu, Jul 10, 2025 at 08:55:02AM -0700, Sean Christopherson wrote:

> > So kvm-amd is the SEV stuff, AGPGART is the ancient crap nobody cares
> > about, CCP is more SEV stuff, DRM actually does CLFLUSH loops, but has a
> > WBINVD fallback. i915 is rude and actually does WBINVD. Could they
> > pretty please also do CLFLUSH loops?
> 
> FWIW, doing CLFLUSH in KVM isn't feasible.  In multiple flows, KVM doesn't have
> a valid virtual mapping, and hardware *requires* a WBINVD for at least one of the
> SEV paths.

Yeah, I know. We should give the hardware folks more grief about this
though. If we ever get into the situation of requiring WBINVD, they've
messed up.

> > Anyway, the below seems to survive an allmodconfig.
> > 
> > ---
> > diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> > index c5c60d07308c..ac3cc32a4054 100644
> > --- a/arch/x86/lib/cache-smp.c
> > +++ b/arch/x86/lib/cache-smp.c
> > @@ -12,19 +12,19 @@ void wbinvd_on_cpu(int cpu)
> >  {
> >  	smp_call_function_single(cpu, __wbinvd, NULL, 1);
> >  }
> > -EXPORT_SYMBOL(wbinvd_on_cpu);
> > +EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_cpu, "kvm-amd,agpgart,ccp,drm,i915");
> 
> Patch 5 of this series drops KVM's homebrewed version of WBINVD-on-CPU, so this
> one at least would need to export the symbol for "kvm" as well.

Ah, sure. At the same time, cpumask_of(cpu) is very cheap.



