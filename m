Return-Path: <kvm+bounces-34798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7199A0602C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C364D167085
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D16519C54A;
	Wed,  8 Jan 2025 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fpBdyc4G"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75B3259497;
	Wed,  8 Jan 2025 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736350497; cv=none; b=LWi9lMieNUtDjx0WgcZH6NZfo925uJRnb9yGjUVvSfcp/3CRGojp+k/4CwomS96+GNboho9DplE0wOTKEm7HPKeibBmDh72RVnV8p6pD9K93Z9IhrT5hejXnWL6n+KnQmDUserOB6DQEU9g1kFcM6jpIiBYTgF6xY1sGCQgRaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736350497; c=relaxed/simple;
	bh=c6foYZWTWGibcQwi7eM9+/xWsNY3OAJzuVT0qO5cYyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sU3Sm7c1gHB7To1CO//mJaw+pRbxBjSl35guVh77vx/mHykpP7unCQHkOqlF8XfwSiXB+By+60BmNo28Ofn4yTxLQvNcNzAyaIrTdFFH/FudbYWKI9MMoA+njo4o0agbwU/YgMPPqswE3beubIq5hlyKqyUGCSk0wabmrfj7MnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fpBdyc4G; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 44D4D40E01F9;
	Wed,  8 Jan 2025 15:34:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id G6gYDZTv7eJ9; Wed,  8 Jan 2025 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736350481; bh=ixTpklzRZPQg5q92zkLvTslst/mfYfhB2antGONDcn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fpBdyc4G/mMEXhDUqBBfEMyUEKJSgBF2JDGkQLFHJQEo5ssBbZgDAEm/KtD3Lkfbx
	 iF8+i4TLtL1NN8/AS+23fhi1oiFnnwhHVjDbY77raJZejwEZO3EhQ6BxHhn73eFyti
	 71UQXBjY2q19QyGjUTNF9mPltlYjLVPtAYHIYM7fSiHDsr7rVdLrX5dwZe/tbB72nN
	 /qIl94Sj6YLmHVtE+P9eErs/bVL5zuw4aIAwhaZfm6EIuUwQ2wci/msi8e1TVmqZ3o
	 b5toBaeAi3jANmriyQXVDzzYfUWrRRzoAjO3F/K5bXcxq5JVv85WVB5bXt9VSLZg5i
	 kXr3G85Kim4v8Q4OmAdbX2AOAcTwQ1AtnGN2Co3l/VLN993jQhCzRrY0doexbjdzoi
	 pA2iNBBvWaDA+ZDTosZsoW3gIZ1qGBoH+/7EJrmqrC16XZoCP06ul0cmGp5O6JbZa6
	 xo7qXpsMxEC8Ui3yIUBgI3MZ+X0gyKlCuGq9/KHFm2gfhnxkMz94sGmWQzlCZX9x7L
	 K+awXlF8EiGu2KkJLXE+jyvXGurAFVhzsTbITYRGhTMxhuD+8H9zR4okogqFBeGa+z
	 YKzHypHRW+Z63vavD7ltAbc3Q0MSVbGBS2X3wAC+0IMpMTHfXj2FF7ElWgoKFe/rRF
	 rG83jPIZkSQwUeLhcqDbEtRE=
Received: from zn.tnic (p200300eA971f938F329C23FffEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 092BA40E0277;
	Wed,  8 Jan 2025 15:34:25 +0000 (UTC)
Date: Wed, 8 Jan 2025 16:34:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z36FG1nfiT5kKsBr@google.com>

On Wed, Jan 08, 2025 at 06:00:59AM -0800, Sean Christopherson wrote:
> This still misses my point. 

Oh I got it, no worries.

> Ditto for the "x86/tsc: Switch Secure TSC guests away from kvm-clock".
> 
> I object to singling out kvmclock.  It's weird and misleading, because handling
> only kvmclock suggests that other PV clocks are somehow trusted/ok, when in
> reality the only reason kvmclock is getting singled out is (presumably) because
> it's what Nikunj and the other folks enabling KVM SNP test on.

Presumably.

> What I care most about is having a sane, consistent policy throughout the kernel.
> E.g. so that a user/reader walks away with an understanding PV clocks are a
> theoretical host attack vector and so should be avoided when Secure TSC is
> available.

Yap, agreed.

> Ideally, if the TSC is the preferred clocksource, then the scheduler will use the
> TSC and not a PV clock irrespective of STSC.  But I 100% agree with Boris that
> it needs buy-in from other maintainers (including Paolo), because it's entirely
> possible (likely, even) that there's an angle to scheduling I'm not considering.

That's exactly why I wanted to have this taken care of only for the STSC side
of things now and temporarily. So that we can finally land those STSC patches
- they've been pending for waaay too long.

And then ask Nikunj nicely to clean up this whole pv clock gunk, potentially
kill some of those old clocksources which probably don't matter anymore.

But your call how/when you wanna do this.

If you want the cleanup first, I'll take only a subset of the STSC set so that
I can unload some of that set upstream.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

