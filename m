Return-Path: <kvm+bounces-34476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C159FF759
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C675E162240
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08796199237;
	Thu,  2 Jan 2025 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CMVyeJRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB6217996;
	Thu,  2 Jan 2025 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735809462; cv=none; b=bezklP3hFXRhZUWCi7O4BWrN1zRDmBHxWZOZivMXJoy41z1a2Hr8rJAGxs0MP8ZBr6oIG3SGO5826Oiehztg+sExYNchksE4CuL/SHbUUJZTK8jAGsT2+w2p/0FxYWU3vNeukmK0BYDUSlKN2KtoBAcRGbcGNQI0GtD9XHVUVDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735809462; c=relaxed/simple;
	bh=PYucrqLqnoXyNj0k4xz6OxbOLT07KKSFdF5x8sEYpKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQBIXz2MJpdQNww9bEQyJfso4opQ3/ATJxern/W5Vje0E7eNEbbnEpzPT5hbJ1uK2ChIB/9xBCPtYwUfpT/PacTuGKpFONJPSoi37f70ARtvldEKw6eAiSaETqIB+YPQzLzIERyIFY0zWKIOSSOx18uDkLsWLI+9Oe2eKKTgw1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CMVyeJRS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2B31A40E02C0;
	Thu,  2 Jan 2025 09:17:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id L_h-JbgA8m4b; Thu,  2 Jan 2025 09:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735809454; bh=sNt4WXWhoJvqCRrkTbp7wooAwMT8erQYEJDHfSfp63E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMVyeJRSyHEyuYdxZhmbR/+2T6pdfIwqWBGAzJhJ/Mb3pj+dgMTQKkYT77l+TTZ9T
	 7iZDANOnVlK76oa70QrzvFMmdFpo6uV9Mye6+qpvd5ZzTLG6HyWiCM85Ra1CgK4QcA
	 0AB9s3l/LIn3Crb0ySLWGkEVp2K3peINhwSRPP/cNlPZ0iq6RktIR1LPoS/udTVP/y
	 3YIix0UxnF9gYVtA41gi3CRXG4PdTfSPRoolbG0yZz4tcpC3zEyfJwDMQ5IwaJn7WN
	 94EZYSAJnsI2pJQ3CQuHuCaX5fUy4mZ4f5oqsjgMnjbqNFo6RGpJHSud83blJWuJSa
	 40By0oMTuL+p1sbuodskR2c0nqenrS8xpcP1QVrYqbBj15GbGuyDzYFvDmERn2y5Fj
	 uQmIy036XIiqlud7IEQGX8G9l6aEdMNVYihrIiRbdruQJB4dxnbB3dVI0iC3OPfZKN
	 QLsazl3v5Rbdlillj1kJHD2D95WtOHS0GW/CSEDo5DOwI8A1Q2X7345a+PLYh4d/L2
	 np1mQKaaWw/CgSnkdNIIA3f03v5KYjsSfZsiJcZ7N/MCdl7F0KzCO6AqYaftgpXlBU
	 hDq5vKhGMl3xFE0xTySL5BVb2pZK/4YWTWPBdW6k+bxcdYqmUDpiL4sUSnpjcdCxp5
	 vf5xmjN6TEg9yq8nKbzO1dwM=
Received: from zn.tnic (p200300ea971F93de329C23FFfeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93de:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B003240E0163;
	Thu,  2 Jan 2025 09:17:23 +0000 (UTC)
Date: Thu, 2 Jan 2025 10:17:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a978259b-355b-4271-ad54-43bb013e5704@amd.com>

On Thu, Jan 02, 2025 at 10:40:05AM +0530, Nikunj A. Dadhania wrote:
> Again: As kvm-clock has over-ridden both the callbacks, SecureTSC needs to
> override them with its own.

Again?

Where do you state this fact?

Because I don't see it in the commit message:

"Calibrating the TSC frequency using the kvmclock is not correct for
SecureTSC enabled guests. Use the platform provided TSC frequency via the
GUEST_TSC_FREQ MSR (C001_0134h)."

Yes, you had this in your reply but that's not good enough.

So again: you need to explain exactly *why* you're doing stuff in patches
because I don't have a crystal ball and I don't have special capabilities of
reading people's minds. If I had those, I wouldn't be doing this.

And if you had read my reply properly you would've realized that this is not
really what I'm asking. I'm asking why you have to assign the *same* function
to both function pointers.

And if you had done some git archeology, you would've found this:

aa297292d708 ("x86/tsc: Enumerate SKL cpu_khz and tsc_khz via CPUID")

and then you would've been able to state that you can assign the same function
to both function ptrs because the difference between CPU base and TSC
frequency does not apply in this case.

But that's too much to ask, right? :-(

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

