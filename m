Return-Path: <kvm+bounces-55578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D05AB33106
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 16:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC9444434C5
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 14:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81E12DCBFD;
	Sun, 24 Aug 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nwpbCmo4";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MB27ucS4"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97831189BB0;
	Sun, 24 Aug 2025 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756047330; cv=none; b=OWeIsitJoAErRAkSih9Pbnemh737zOwBBPxjOFJt/6T9WYXnXcgBzTLYaa27dVtA9swZtNeXsDl7vzjdBmGa3bT4AIhXzfMv2yUl2gbd7+HCE1aJOML8sSgdfGJo7A1mDGghajquKPL9wSTvWXCDc5f/vNj4oLUTOB/IZ95FeYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756047330; c=relaxed/simple;
	bh=bIKHvjQjFQggm6gsSovp6QnQASPVA2MvZEluh45ww9I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QSqrUY6GkLa/w9gaRK80xM/Q39vGsedi8Muk/DB081y7aZxZanazQ6HxOGf2avMHpPhnXKhW870J7BLVUBzA/kytt4Q8JYPu6WGA2YxrJr4vxhzI5+gM2sChZtw2mukTQy1isgzhWLukB5b3GU0qAEzdIiJ6B2vRTfJria9IhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nwpbCmo4; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MB27ucS4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756047326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGLHc23v4lVRFyP1RiNLGBgKKNnCy9wCFoP2XieYBzQ=;
	b=nwpbCmo4N5pCCdkKQ9fI/pkILK3fDGabfey2b9BHNQKxbQYKIUm68MWKj3NPxgDw2wwSaA
	UWtXspZ7A3kmdXx+QxSf2ayE0HMQAumpM73gSqT8zXBVhqolTHRuph7GmarLzmze//xXjj
	XTBLJyDOM4AupvRE+TNQNCdN1xDCe1X2hkD68UykoBG6feN9x+P5gN4AtuxUqnOLyAP4VR
	3zpDhXfckGU5JE9FjDs9cBJDm7Wht5RtpTF3RutIjvUtCKAK3AfdlO9/SYBDgt5KX3r/38
	G7f4uGz5AhjCtOLHR92FMmN/SbS98NwvNH7wWFTSGh2RD1Io58eYz8uIU24m8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756047326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGLHc23v4lVRFyP1RiNLGBgKKNnCy9wCFoP2XieYBzQ=;
	b=MB27ucS4vpMMcfFWTA1YZQTTvw1ogDW+xGeDEJXOnROW7gL1RHgPlpvi0udPytp/Wo/KP8
	mD3woQ7vWRchyqCA==
To: K Prateek Nayak <kprateek.nayak@amd.com>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Cc: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
 <pawan.kumar.gupta@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Mario Limonciello <mario.limonciello@amd.com>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
 <babu.moger@amd.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>
Subject: Re: [PATCH v3 4/4] x86/cpu/topology: Check for
 X86_FEATURE_XTOPOLOGY instead of passing has_topoext
In-Reply-To: <87ms7o3kn6.ffs@tglx>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250818060435.2452-5-kprateek.nayak@amd.com> <87ms7o3kn6.ffs@tglx>
Date: Sun, 24 Aug 2025 16:55:24 +0200
Message-ID: <87jz2s3h2b.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sun, Aug 24 2025 at 15:38, Thomas Gleixner wrote:
>> -	if (!has_topoext) {
>> +	if (!cpu_feature_enabled(X86_FEATURE_XTOPOLOGY)) {
>>  		/*
>>  		 * Prefer initial_apicid parsed from XTOPOLOGY leaf
>>  		 * 0x8000026 or 0xb if available. Otherwise prefer the
>
> That's patently wrong.
>
> The leaves might be "available", but are not guaranteed to be valid. So
> FEATURE_XTOPOLOGY gives you the wrong answer.
>
> The has_topoext logic is there for a reason.

Hrm. I have to correct myself. It's set by the 0xb... parsing when that
finds a valid leaf. My memory tricked me on that.

So yes, it can be used for that, but that's a cleanup. The simple fix
should be applied first as that's trivial to backport.


