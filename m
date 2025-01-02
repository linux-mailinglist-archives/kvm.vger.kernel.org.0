Return-Path: <kvm+bounces-34477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F10F9FF760
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 488A87A13C1
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2057C1991A9;
	Thu,  2 Jan 2025 09:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="F+kJUMn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58C17996;
	Thu,  2 Jan 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735809932; cv=none; b=isGInN5FVZYXxwfDqPwAOfnbs1UkN8UA/TG2IEzuRTJgZwZ9xY0VOyfV8I3e0t516fBORzUUxQtAtSAUbvbTrW8dv19Vx814ARghvXkVlDojSdDYTXldwiKpvYwimGDVtKtjgyAGL51Dx+tZfPhzq1pDbRYQXCB9KrhGtiJcNEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735809932; c=relaxed/simple;
	bh=1ethIKxMG+8qLvWA9g1AYNpongVPwI1wbuU6dLd/2iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtVIPcGMp1q2koZYoU1dl9rFrma7pzKy3FDZ5AQQ61wCDKcBi2d8gcO+IzELNRYnatIk76s2pOy7HnBgwNzNIL3eix8eiuv0ggnZ7VBhmOThQqASOxjwlEbGYDyQr/3kjU+OLzxb0nFVwkSL23IU+K6Z7dZl7bWGBsY2At2HxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=F+kJUMn/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3FFFB40E028B;
	Thu,  2 Jan 2025 09:25:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id f1FjNGb-4KVX; Thu,  2 Jan 2025 09:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735809925; bh=3fUexfpL+aBfUQ9rDDx+WydTvOsBmHl9GX/ika19eIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+kJUMn/K5Rj4MKMuez1Echz0LstOLjvC4PVBKFk4QGJiDddlqkR3oDqfMiOa3c0W
	 RQ6DjRZOZmbL7ks5hLjV4q7NysnEeAwQN+6R7qUuazFmmE6enpEIfi8+j5R2R9AFQH
	 X70g/ixRnURMm0HZlGKwv4AcjD0oPRWA/qctaogswV4bOhYjYy0NbFGPgCO7JWybAM
	 Oj07fG+us6J0bEbRHokFjzjYquxXG911WyQLGzIGovRit2mBnFN80g+ntGrJ1NC5gT
	 q/xXb/p5JgiUeN1u9fWs+XG0JlPlNW158/xqqaTb9n5qsnDBWSa6mI0ck+WvWJesdf
	 oXPsEmWlRmnRsHsUHOqsnDIzdypjMyndD+ao2HdhogmYuouF9M62/VGHX4VsHOID+a
	 VX+e3Wao4hULtxhJUsq7hU4FmmTlks2AVBLkVHYOViY8jY6MHndw20tP5vI2ZMuRKZ
	 p7XGZRQK6IEKQwWHOlz5+R7azc37KKlEUnCLbBjK5gG0P2Z+SYHbPs7kocniArovk6
	 n01VZRdsSyMy4wpVXPg0FcX1+qgm3J1ZEGSFaWRYp/JZr0FlY66VVR/WFdW2oyvg04
	 dBVnTKMqx4yrgir1qmSC26M9iUQVQcl/fBnrKj6MuZ150z9uuZkcGYzKS+e7qpASf3
	 HMVkmiM4Ls98XHfLQOGyL93M=
Received: from zn.tnic (p200300ea971F93de329C23FFfeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93de:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 07F0B40E02BF;
	Thu,  2 Jan 2025 09:25:13 +0000 (UTC)
Date: Thu, 2 Jan 2025 10:25:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
Message-ID: <20250102092512.GDZ3ZbeGsxuPjXwc_K@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
 <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
 <f46f0581-1ea8-439e-9ceb-6973d22e94d2@amd.com>
 <20250101161923.GDZ3VrC9C7tWjRT8xR@fat_crate.local>
 <09187d10-78b3-402f-be77-138cea98d8b7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <09187d10-78b3-402f-be77-138cea98d8b7@amd.com>

On Thu, Jan 02, 2025 at 11:04:21AM +0530, Nikunj A. Dadhania wrote:
> 
> 
> On 1/1/2025 9:49 PM, Borislav Petkov wrote:
> > On Wed, Jan 01, 2025 at 03:14:12PM +0530, Nikunj A. Dadhania wrote:
> >> I can drop this patch, and if the admin wants to change the clock 
> >> source to kvm-clock from Secure TSC, that will be permitted.
> > 
> > Why would the admin want that and why would we even support that?
> 
> I am not saying that admin will do that, I am saying that it is a possibility.
> 
> Changing clocksource is supported via sysfs interface:
> 
> echo "kvm-clock" > /sys/devices/system/clocksource/clocksource0/current_clocksource

You can do that in the guest, right?

Not on the host.

If so, are you basically saying that users will be able to kill their guests
simply by switching the clocksource?

Because this would be dumb of us.

And then the real thing to do should be something along the lines of

"You're running a Secure TSC guest, changing the clocksource is not allowed!"

or even better we warn when the user changes it but allow the change and taint
the kernel.

...

Yeah, stuff like that comes out only when I scratch the surface and ask about
it. And then people complain about it taking too long.

Well, tough luck.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

