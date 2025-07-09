Return-Path: <kvm+bounces-51993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C12AFF412
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01744641AD0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C209224DD10;
	Wed,  9 Jul 2025 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="R2qbSb5y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B0D241673;
	Wed,  9 Jul 2025 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097305; cv=none; b=UUm6XSozLrSa/Yzi7FjWuoqq6JxPqpP/Ki4QLrvfKWsmRdhYQL2fpVTMEqmK3YNI1EEty2+t4B7QvX//QX7EtZVNC8ZnKt7EK2MY+uDytf2D2eBNBcgMgjZ0i2zm7YjOlUC3SrgN6+NvAjJ6agZ5DbaToi2uSQ4DTChFWO+zyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097305; c=relaxed/simple;
	bh=aQbzgSyNSih8ocOpxy2RZ+8ww8LgbwU4eJQbGKAzvVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tauSWLz/pBwZZzAHG7OunlzZUhdk6rvCEmLPkgkENpcbnoAg59f0nrGJWgYh4lzP5EeBua1XueyOLFkR70VBdkAySv5XY4j0HknJDLjZPKKSCsRPI7bon0xvSUWpR/fZv45X9a0D5tRSCBI3o8DUNRdZNqMfBWBUY9OjE6xn1Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=R2qbSb5y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 902CB40E0216;
	Wed,  9 Jul 2025 21:41:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7TXVX2LfnEoA; Wed,  9 Jul 2025 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752097297; bh=welqa06GFJI4VOR5xGX4jgUpfnRTCDdVT0ZtjsQ9UPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R2qbSb5yJ3ZE4CO49ocu83kCx+CRDiDhZpqRz6j8nuSw7Jrco38J+A8aYhK9Pzf1s
	 R8IG7HnToowum2itDeWC88m3q6n5TheGlEJoftjqy+0+BOm8GSxg07BspPgpZ7ueSv
	 JyOueLKkE7Ryi0oiYGAfVC1y1cfAVngXNqDwVGhQx4eBGzX91LdwR1/WGxXr61c1ca
	 hG6xWLjVbroFJ6GmP8vD52x4rwB7+xg8jyhpqwvAh5OwLdri3Kvsu63j1Q+NYECTzy
	 Sk1lNknMO8ADT3bRG4bsZ7wzDodlXbTU5lf5ldGHu1V/X8xh+eMTt6Xsw/RpBgijO4
	 Vi3EHbltTWA5klvGeaRD2aXdl4hjwb3Uyi6EMFOtP8G9/18HkGUkgWkP0v7dssQtE3
	 Lun7IaXbAWTRRVAnYB8EvydK6lttTLw6Ukaa8LHyj1f1YegyYg/6EO/2nG5R5aLjQw
	 rIrmhG54P9lrI5ryd9bKOT+cCl64zD57Erl0CM4OBlnMizQqNyAJ0CkyIC6zj1495A
	 S4eLKCwYDJPhbEGFo4UdjX+98bXvsK0kN9ypt1C02arxsF33uW8FnzZqypE2Prh3FH
	 g/MhuI6O8SC3vnpQ0+eldX+FlmSa3SNZGT4Ix+Utbjwo4z09ozbHy469tyXdCxYm3K
	 zkyJ5qvlOYju0Eu4iXpG9ys0=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1110540E0215;
	Wed,  9 Jul 2025 21:41:16 +0000 (UTC)
Date: Wed, 9 Jul 2025 23:41:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v8 00/35] AMD: Add Secure AVIC Guest Support
Message-ID: <20250709214110.GFaG7h9kPZoSS_MhIr@fat_crate.local>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <aG5_mowwoIogBSqH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aG5_mowwoIogBSqH@google.com>

On Wed, Jul 09, 2025 at 07:41:30AM -0700, Sean Christopherson wrote:
> Boris, do you anticipate taking this entire series for 6.17?  If not, I'd be more
> than happy to grab all of the KVM => x86/apic renames and code movement for 6.17,
> e.g. to avoid complications if a conflicting KVM change comes along.  I can throw
> them in a dedicated topic branch so that you could ingest the dependency prior to
> 6.17-rc1 if necessary.
 
> I.e. these:

Yah, I'd feel much more at ease if you took the KVM cleanups so that the
patchset is slimmed down and then we cat concentrate on reviewing the
remaining pile. I haven't gone through it, I know tglx did look at this and
with vacations upcoming we might not be ready for the merge window...

I can see how far I can get but you could give me that topic branch just in
case and I'll see what I can stick ontop if/when I get to it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

