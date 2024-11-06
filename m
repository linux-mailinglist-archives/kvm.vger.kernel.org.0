Return-Path: <kvm+bounces-31000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC5D9BF32D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2987E1C21F50
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B44D206049;
	Wed,  6 Nov 2024 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lCcgewcH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C034205AAC;
	Wed,  6 Nov 2024 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730910345; cv=none; b=g04uDPwIO5hHIIJISszmNTuYug19II9toFoBgiqYapfCrL7E9yRHCVmsSgByr7MoSG9xWEZWaGv6EarxPyyVON9f/B9HEhngZsghvvmS5wGx92AKmJzXiE4/BW0R2egu3Ka7I99mjQQ0N8vzSZXFT821rA15DPaPr3R9ZE/lHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730910345; c=relaxed/simple;
	bh=/7T9CWq50/EDW4GKHhXrEmSIjWMuU9YbJ9xGSuwCaqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTISmTMiiLDCEEp4H+2l9fhyz4cCQh2n6vBpqc4ch2gyxM61EVrPFOcaswIIWjZ6lE/90Qe2zIlFDLVWgn0wmWplINn1DTpFH4fyPlMXj4EWmuwudleZXd2Ho7Q/GhZR9lDdCiJJKQVQBqVcDMBTuGM2t5QbMgrgdG1f3rhWGjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lCcgewcH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3B66440E0191;
	Wed,  6 Nov 2024 16:25:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rFZESn4E9EYc; Wed,  6 Nov 2024 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730910337; bh=GmdL+T5K4/SF+Sct49tJ8IMuWMK3TTT9WwZH8bDTlgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lCcgewcHDU8owBBp8kRF9Ui7cVCT5+NN2YO25bfoRLHMftyg2nLw/GOoFkCuZQ9of
	 eRLhkBNzWGac3lRYyrJZS2uhTGDOnrVeiq77UGY5XJnxTtaO3UixFqxDYuWsgF5Zbx
	 iMNeU4MOtRb/xyRkOacgi00XrzN6ABvBoJMWyevOnzjdNuu6AqBG0glpT1LG0XmJiF
	 VKvgEQxsbbr6brQs2Y3hcww4T3YKgtN3rNfz36fDGIf0l0Qs7HFcoVcsaOJvaejaK4
	 DlWtITAxRjGjTdGc4n9r90XD4dc8HcX76CV4ROkaGtjMCzxmXP/n+QSg+rox0oyLKr
	 z9xEzjtwcgnggMSeTdc7vdP7dlV4V7tbB06MgCmmUvexjeqt+7r1jWVJPkjrME5Fkm
	 XQ5Eo5P4lEG69jectFyyU7vOruPRDkqpZ1cliO1qNnfQucbsoO9KC2VL+Q/YEi4pwn
	 qrP/7Urk07zjKQFMnZFSpgxcPsWgONWhoTe7AkSuofp7jblVDcv5OtpUQE8Ei33b+U
	 5wD98Tp5tEpH7bATmK6V/wtBKhWS/U5vQV7pqFbgQcCbesFYfB0zwjHEgbb2G6mBFR
	 w4p6tuqm7Y0Y0pE7EWLhgTuU3594cy5PUaPC9/yfh3ig+0ph44P38oKcyh7AkrEVGh
	 45rSk0r1txjCNHvGMmrzjOKA=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 04F5840E0163;
	Wed,  6 Nov 2024 16:25:29 +0000 (UTC)
Date: Wed, 6 Nov 2024 17:25:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241106162525.GHZyuYdWswAoGAUEUM@fat_crate.local>
References: <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com>
 <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
 <ZyuMsz5p26h_XbRR@google.com>
 <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
 <ZyuWoiUf2ghGvj7s@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyuWoiUf2ghGvj7s@google.com>

On Wed, Nov 06, 2024 at 08:17:38AM -0800, Sean Christopherson wrote:
> I do subscribe to kvm@, but it's a mailing list, not at alias like x86@.  AFAIK,
> x86@ is unique in that regard.  In other words, I don't see a need to document
> the kvm@ behavior, because that's the behavior for every L: entry in MAINTAINERS
> except the few "L:	x86@kernel.org" cases.

I have had maintainers in the past not like to be CCed directly as long as the
corresponding mailing list is CCed. You guys want to be CCed. I will try to
remember that. We have different trees, with different requirements, wishes,
idiosyncrasies and so on. And you know that very well.

So document it or not - your call.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

