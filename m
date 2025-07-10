Return-Path: <kvm+bounces-52042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2AFB00568
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 16:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 491D11C45BB8
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 14:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11A2273D8E;
	Thu, 10 Jul 2025 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fT2rnsEK"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34117B421;
	Thu, 10 Jul 2025 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752158269; cv=none; b=D+zKEgEpE3elY1Nnbo0NjmCuPNKm6adrAgW4j7dAUFwqOzxZ4tiNoXyby3NxEabOPKrBO5ZDOxEqr2HtpRIaqrZmOOo7us5JpO5NAwKMzlWwk+24IJNtvPSw/6ZMJ6Z8Amb0a3FjE18s4OUkvxjP161V5VTPPWS1/UG1uCCgZiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752158269; c=relaxed/simple;
	bh=UvMZGDxZJVgD+NwV/t+TM0jrjH2lCjiv88qf/4+E5fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkmZjXhsO7+RvPBzcOmssuRExqBOgHp8VQzaYHOuoMKOUf09cZHqbdfBbJGuoicRJGDUCbz1vvHKvVMzhlIFByifGDOkhe4lREggeO7xu6jrkmitJ7fipWMFKwTzfTGiuez1uFAjCJsp61Uia9sUw8TuwiHAsVo6JK1yG6BmceM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fT2rnsEK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l/VowybUVqfBfJLENTNbFHp0kWze8NXY/smu/Q+m5Vc=; b=fT2rnsEKw3ORydq38vuGxhbBJs
	8E3Qn8Z7TCGVBWaHW+32Ia9tegauI9oonq2liG7d7BOoFTB/mvKxhkxoTdK69WGEz21m2JUHYCHBA
	VGo5bFyuaCpvdymX3geHkeBUZbUE30fm3ezwDl9/Tcac0YSAQtpS6O47bm886Amw9bgnT4t401jQV
	CazUDxCgRxKb1Kk0u5JJ+IJzGaRkpuaOPBr2173ClXyt1I95GAc/VM6BXhmXyPgZ5F8nKo9jynkeZ
	2hj5DedthD0vNmvJhtKC/u7nYB4T3C24vSXDq2OjVibi4fhf4mpS0teODSGO13OyViwlderJSAFWr
	iaZA6F6A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZsOw-00000009FLo-16vX;
	Thu, 10 Jul 2025 14:37:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 64209300158; Thu, 10 Jul 2025 16:37:29 +0200 (CEST)
Date: Thu, 10 Jul 2025 16:37:29 +0200
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
Message-ID: <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>

On Thu, Jul 10, 2025 at 01:29:02PM +0200, Borislav Petkov wrote:
> On Thu, May 22, 2025 at 04:37:27PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> > index 079c3f3cd32c..1789db5d8825 100644
> > --- a/arch/x86/lib/cache-smp.c
> > +++ b/arch/x86/lib/cache-smp.c
> > @@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
> >  	on_each_cpu(__wbinvd, NULL, 1);
> >  }
> >  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> > +
> > +static void __wbnoinvd(void *dummy)
> > +{
> > +	wbnoinvd();
> > +}
> > +
> > +void wbnoinvd_on_all_cpus(void)
> > +{
> > +	on_each_cpu(__wbnoinvd, NULL, 1);
> > +}
> > +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
> 
> If there's no particular reason for the non-GPL export besides being
> consistent with the rest - yes, I did the change for wbinvd_on_all_cpus() but
> that was loooong time ago - I'd simply make this export _GPL.

Uhhhh, how about we use this fancy export to known modules only thing
for this?

These are typical things we do *NOT* want people to actually use.


