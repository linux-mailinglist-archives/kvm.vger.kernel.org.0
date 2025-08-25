Return-Path: <kvm+bounces-55604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C370B339E2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 10:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34D3216A1E2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 08:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CA92BCF5D;
	Mon, 25 Aug 2025 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eyK+Eur/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71131E0DCB;
	Mon, 25 Aug 2025 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111829; cv=none; b=sFS8RgdnCD0b2smzy3JEscAb6tdVwQb0yLlfgxBgLuDu738vcc/81C773g0jDtoQ8Wfm98y144DdAC0PTv49Kdae0b+dlQwz5iCyg2tmTqKfYlbTWkZnMZ3wjG8zBBx0imn9qoa5p64V/5nEuT6fJ+a59FoBHHGOnYQE9JCyhIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111829; c=relaxed/simple;
	bh=Xtml559ogB0uUdvg77mXp304iBjiaV7jOI+rnKG2hfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLFBiTVCkAtdcGkEv+KBCJB3q8YyPM6BewOl38eKF3GWYIRk0F4A2Utj3CDpBvtJ2VPaMdt0Tr0ioBT0KLLAuWF8WiGUSIDBGI0X0zhcnvX5qGR+SS39d66OdkeKgB19ENA3UJHyzu2/5j5Oh6nptEzsGzjLMzVbL1Ra7QQx418=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eyK+Eur/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1192140E023B;
	Mon, 25 Aug 2025 08:50:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uCezOB_PD1im; Mon, 25 Aug 2025 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756111818; bh=KKGCgNEPWkw/z2lK1j3DQROSoKZTCmEnBPN/FJrqRV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyK+Eur/QRXtQl0vI2ruLmzUkGQoV6r1mBJ2VGpUQbO5iG7otIKaVp9YZA1iGC89S
	 3lXbjhUndjoHMIyIiXVrIW5Bus943up537Uj+5Dq/JsHXKdu7SF4KQ5BKb5YFQSv78
	 pRA+9jYHE9tHtjwXf8L5jpRoY6Qhb5nN2WVk4R5VAiV2wcAXi8IeZoKjZ1yJ/4z8Dm
	 Nnrl0vqH7DvrPtBUbVWFp4SjCNOjD3TfR3KCKdtruxO3xkwY9x1xc0KQieGOhvMPpo
	 4piJ0ouE8CV8nGfmS1qynq3gN3GuNkCx0adMgAcIhgcYPBe0IEyyGhjmGNQdrpdndJ
	 nj/fUPTRDnqkK66mHWB+OemV0KhZIWCLwDYLJt8c89a6QcKFG/itdAMXMwLInv8oP/
	 JEzygpWyfayQ79/znLELLDE4bYUI7XAWpHIAb6kNWMXi4dSc6MhrMGQ6suwslEyXFI
	 bC9v6rNyo3ZB6tgvseCtfl0ZMie4HFhwqVEzc5k8pmyGgXrBozVIduHRS+5Oa/FF6g
	 pxozdDgmlWTsqt4mFBD9M2Yk7IpYxdbSRIiHRYr6AweQgcIwTCYKmLAhH88jH/9BvU
	 wdWxV9Cp7Y79INZrwfxEq0cs8/SsozSiK5knsXgNzCGKiV3jtaMcb2kNCxCCS8G4G9
	 ooF727/WlDsr4HKR5Prey0zI=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0B35440E0217;
	Mon, 25 Aug 2025 08:49:57 +0000 (UTC)
Date: Mon, 25 Aug 2025 10:49:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>
Subject: Re: [PATCH v4 0/4] x86/cpu/topology: Fix the preferred order of
 initial APIC ID parsing on AMD/Hygon
Message-ID: <20250825084950.GAaKwjrvrmXZStqrji@fat_crate.local>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250825075732.10694-1-kprateek.nayak@amd.com>

On Mon, Aug 25, 2025 at 07:57:28AM +0000, K Prateek Nayak wrote:
> This led us down a rabbit hole of XTOPOLOGY vs TOPOEXT support, preferred

So in order to save people the rabbit hole wandering each time they (or we)
have to undertake, I think we should document what the whole logic and
precedences are wrt CPUID leafs and topology. What should be done where and so
on.

And those commit messages have a lot of text which explains that and I think
it would be worth the effort to start holding it down here
Documentation/arch/x86/topology.rst

No long texts, no big explanations - just the plain facts and what the current
strategy is wrt to which CPUID leafs we parse for what in what order and so
on.

You could start the AMD side, it doesn't have to be exhaustive - just the
facts from this rabbit hole trip.

And then we'll keep extending it and filling out the details so that it is
right there written down in one place.

Makes sense?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

