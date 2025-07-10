Return-Path: <kvm+bounces-52046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54BB4B007A0
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 396E417A7B0
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BB927585B;
	Thu, 10 Jul 2025 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Smmq2eq8"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDC3273D91;
	Thu, 10 Jul 2025 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752162447; cv=none; b=NNLBrd54ohbEF6MY088slpn/qAU+PheTcGR7mzqKrmbD0Os2PXweJK+7umafLdCctl6moMxIdMOKpctIIwr4vF/mpFnOGCfhnCxAqofW6deQlzePdz7SIJzMjF5a5q1mfjUH2b8znq6XbFUKHK63wg+2RhNknuwboTQLHFmeRak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752162447; c=relaxed/simple;
	bh=CG10AydbLDKiz7iLm8kpbdO5TAZItghs/0FO7lh9rLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9pN9hpSgFZY67Bxmjj7kHkk8w1uqZei50vZhyKspu/m6Zoe1uhbL4NSlEMckSopWco4iCV/hnewoU3uGdyIvU7EWoR6+q3PT+nmyCqCeCg7kvtiBXyeOsxTSP56YbchjaGmryF1Udx2/s9UnR8pYKxumTkHbFX0FwfHYMdDHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Smmq2eq8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bZxu+DQfctNogwYpaOLz3JI+YiDCl8GgvQ6csZ2gybM=; b=Smmq2eq8bLmDm8uRIhrsL1Iz+i
	KDfeleHWzqJbwBBqrzQw8bqxlDE3NNE+UH5P9hCLxdYEkm2uenfLix3GBBM5cJAi4xifIlZb5RGX4
	qp/6ggvpcg+pspjWyCcGZm9BFrgKIEc1rNSckMye0oibhVr8SyHjv2YuMS8Tur+gMoiVE/zGFR7ae
	OmutweWxlh7yvdVHcv16t6DNs7rWFQQTL2qoPAuTix1NsYkTQyXDetxhVA/kuXT3e2k5N/zKNFT1G
	ngUJqDsD5rORXZxA1Nwsl6POiRzriZcdONDtiC4Xv1vKvdr2+QDSwvw6B5vtbl+/DDdkOSSf8zx6I
	iSkVuDDg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZtUI-00000009438-0aQX;
	Thu, 10 Jul 2025 15:47:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 05E1B30023C; Thu, 10 Jul 2025 17:47:05 +0200 (CEST)
Date: Thu, 10 Jul 2025 17:47:04 +0200
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
Message-ID: <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
 <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710143729.GL1613200@noisy.programming.kicks-ass.net>

On Thu, Jul 10, 2025 at 04:37:29PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 10, 2025 at 01:29:02PM +0200, Borislav Petkov wrote:
> > On Thu, May 22, 2025 at 04:37:27PM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> > > index 079c3f3cd32c..1789db5d8825 100644
> > > --- a/arch/x86/lib/cache-smp.c
> > > +++ b/arch/x86/lib/cache-smp.c
> > > @@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
> > >  	on_each_cpu(__wbinvd, NULL, 1);
> > >  }
> > >  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> > > +
> > > +static void __wbnoinvd(void *dummy)
> > > +{
> > > +	wbnoinvd();
> > > +}
> > > +
> > > +void wbnoinvd_on_all_cpus(void)
> > > +{
> > > +	on_each_cpu(__wbnoinvd, NULL, 1);
> > > +}
> > > +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
> > 
> > If there's no particular reason for the non-GPL export besides being
> > consistent with the rest - yes, I did the change for wbinvd_on_all_cpus() but
> > that was loooong time ago - I'd simply make this export _GPL.
> 
> Uhhhh, how about we use this fancy export to known modules only thing
> for this?
> 
> These are typical things we do *NOT* want people to actually use.

So kvm-amd is the SEV stuff, AGPGART is the ancient crap nobody cares
about, CCP is more SEV stuff, DRM actually does CLFLUSH loops, but has a
WBINVD fallback. i915 is rude and actually does WBINVD. Could they
pretty please also do CLFLUSH loops?

Anyway, the below seems to survive an allmodconfig.

---
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index c5c60d07308c..ac3cc32a4054 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -12,19 +12,19 @@ void wbinvd_on_cpu(int cpu)
 {
 	smp_call_function_single(cpu, __wbinvd, NULL, 1);
 }
-EXPORT_SYMBOL(wbinvd_on_cpu);
+EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_cpu, "kvm-amd,agpgart,ccp,drm,i915");
 
 void wbinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbinvd, NULL, 1);
 }
-EXPORT_SYMBOL(wbinvd_on_all_cpus);
+EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_all_cpus, "kvm-amd,agpgart,ccp,drm,i915,intel-gtt");
 
 void wbinvd_on_cpus_mask(struct cpumask *cpus)
 {
 	on_each_cpu_mask(cpus, __wbinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbinvd_on_cpus_mask);
+EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_cpus_mask, "kvm,kvm-amd,agpgart,ccp,drm,i915");
 
 static void __wbnoinvd(void *dummy)
 {
@@ -35,10 +35,10 @@ void wbnoinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbnoinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbnoinvd_on_all_cpus);
+EXPORT_SYMBOL_GPL_FOR_MODULES(wbnoinvd_on_all_cpus, "kvm-amd,agpgart,ccp,drm,i915");
 
 void wbnoinvd_on_cpus_mask(struct cpumask *cpus)
 {
 	on_each_cpu_mask(cpus, __wbnoinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbnoinvd_on_cpus_mask);
+EXPORT_SYMBOL_GPL_FOR_MODULES(wbnoinvd_on_cpus_mask, "kvm-amd,agpgart,ccp,drm,i915");

