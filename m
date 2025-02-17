Return-Path: <kvm+bounces-38388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A6FA38D2F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 21:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F186B16F7F5
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B45238D2E;
	Mon, 17 Feb 2025 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jhhi0Nq/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83272225413;
	Mon, 17 Feb 2025 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739823675; cv=none; b=n7wC+bbKPsQkHZVrxIq/aNmNhs6WNWYIfOzACOf2BllO6SzxHVSXxBSAc7sSCCHEMwensJtPnj81FMbwbarG++kmVoRxo2TQQPnfG2R9QA4HiDwLFogH4eai2Yrl1V7GLcSflJVRWHgA4Xnr9Vv5hJjFIKaciLUz3jZt3aJz8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739823675; c=relaxed/simple;
	bh=oiMpLGtc3056yC1c+nZCxlQbMQNfP2HZCqVZDQCvxQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIdWK8i1ySP1qpS96FJSJjGeQEYP8ZfG1S6e2D/vkOD/iq3IzsyZaBJ/6F4cUMrySCch36Z6KAA1xbZ5sYdILNOOvXpqu5DT/u/a+adRQB6qB0uaRhlIcwbfq7mZCYCpQuAl0vDrAvO6Ub3yhMkGkrAxUzBiYqMcjuW810vEw7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Jhhi0Nq/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1C84940E021F;
	Mon, 17 Feb 2025 20:21:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TV7Vd1f344j1; Mon, 17 Feb 2025 20:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739823665; bh=dE/pLAC0c1escSa5r6wXdPrlRC+bEekW99QNmTVHLTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jhhi0Nq/DFKmzxxI1E4XeWzF9mtZnqu2y4UT/8/RWcJ4t7r+JjB/6Ve18hl752Shd
	 t5PeN2hMfaZbBbR+eTdxMm+BjQmiVqHYofIhRLre3fighyE+G6zSHSn2ddNH8DA/D+
	 Xs0nWRay3UpTl+qGg/ew89/C++EDVUSot4Ep2MtJZrj9qwLuTdKGAWqdJ3EmbJzgHh
	 9E7PB5KALkD1/OokFiJZ1AareQ0D3aVp7RHxrnJCxxO+Jpr9yO6OvEiIpqglup8eNc
	 AjCD0HWsOu0JVBLRm7yM84BGyPi4xGkcSnJ6iEYlJbJVeAWrdKFCkP/8gJun/Bswjr
	 Y/mrTZYNeAlBEL+7pQXH9ba9x//sMrbbA39jhRCnOkzK8uwbhPy/mTuexFCG4DHk4N
	 yUv0T9QqX5yG14UrslCxQ2Mkw8b2Q0eTCLWUQK3NknIV+I/GwFq5DutBrbTESaKfBO
	 uf2rPZSCxJUBEHOIT9M53Hn24iMivRo8HZLsKPZFY1kk4r7EHjYg9iBDInOjjZB197
	 pLpQ2AepcKHEo+DIKEeoUqVEw187KqrFEwq5QRqYNfKIqcIHTA4Ji3jlPm4L/TWQKi
	 mG72RyPhydPDzs5Hp7X7hn6bSDfdEaEHXi2bJPYaVxw6YUqWsiwroqxCwspXp+VwYC
	 v+KZHcIfdskNfOUrbHOMQOjY=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5E14840E01A3;
	Mon, 17 Feb 2025 20:20:54 +0000 (UTC)
Date: Mon, 17 Feb 2025 21:20:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z7OUZhyPHNtZvwGJ@Asmaa.>

On Mon, Feb 17, 2025 at 11:56:22AM -0800, Yosry Ahmed wrote:
> I meant IBPB + MSR clear before going to userspace, or IBPB + MSR clear
> before a context switch.

Basically what I said already:

"Yes, let's keep it simple and do anything more involved *only* if it is
really necessary."

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

