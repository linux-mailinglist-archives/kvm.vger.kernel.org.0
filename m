Return-Path: <kvm+bounces-34479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C67F9FF76F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10470162078
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9260A199920;
	Thu,  2 Jan 2025 09:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PYN1ANwV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA1518E75A;
	Thu,  2 Jan 2025 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735810379; cv=none; b=hl3a1TTUxHFKE15Ix2YJreTThdVhWDyJZ1KbM+Un9SdZglsWlw7VqZj0ZENKpkrjWjfzBakYpBJHe6CHe3Z1F0tiABA0Df0LG5CfAtYOOmIN68knWEA4abE/QZYt6eThjL18U6KOajoL21kBbzeRRbCzLX7YPWCNSdUpst7Y4Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735810379; c=relaxed/simple;
	bh=7hWQxG5WXbD74I+mXQpf65FUtWq/x5ME6dwlbGx20eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TR+R7ljJC9TT00lQ82ZvrqBEvBhl8vEQ2nkmGrHUWzk5Lb9OhplBRaKpHbjHRkMb2i5Xj6zxJ74dnGBcwODgmvGhjhyFDCVgnsJh1GEGcvw+CVidvHzcpMkl6SalNPiHKDqM/Gocp9TV9xyksRUpls87kQRlf0ACikda8MRXA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PYN1ANwV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 33E7640E02BF;
	Thu,  2 Jan 2025 09:32:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cvScK39mzsce; Thu,  2 Jan 2025 09:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735810373; bh=gz/ci7galio5GJdmYQx0SMy2njVvxRZDhmGG+WyJ+Do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PYN1ANwVXzntLX6aqD6+FSDrGeNApZNzZX9mJcJiF3zv1TAnYM8Em9gKOY1FSHFHg
	 ZiJPtYQVtWobN3t+UJZCFe8a/+jtEdrk5AeTpca2qVTrxGCEWC749pCSY5kRtfxir/
	 FRuP8dbH/3FX3uzjebA8h0/zPZTe1bKtNT9cjg7Cgl663xUO/X/u8sV689OrJg3dro
	 NfbMNYMcBejobCU9Z36sC4Tt/vQDOdjm6E5c28UpbitkuD1edJJGGd5R9trL784yqJ
	 lKmry9OTQyniaZpyEwq8ImrKrhlru3+JkN+ouyqtYelkXXn+9sdPyQokCD4TzVAUf4
	 zWad+EgUITdNQAwhi5PFWTh1JEWQCOEPLuf4r8ds8b8FxmwzzurUWaHTvoc5z1cPsk
	 xNeZ2BPIFFl5fbjDuejVf3qYhbh6LHjESeGARZtrn+ly4apRV1SbKqj5sCVnU4rgut
	 n5wkXv0BVspudv75nSUi+bBOQrPCd0AMKCS0XltldCRSv0Zn1AWi6RXYIJvBRY/aoL
	 HyMcXdhh/+fDO/7TP/Vco2Cua22OI7DXVy2fy+d+w9l25MpOc6bXdunSGRivKHdnqg
	 grLiVepzfiJAG29FrU8EHzpsGlu6TDDAcP34ASekEytkpQ5DchPk8Cfuqd65fwQFvh
	 Cvj8UIIjX86ruCJVqYIfkxAI=
Received: from zn.tnic (p200300ea971F93de329C23FFfeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93de:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CBD4E40E0163;
	Thu,  2 Jan 2025 09:32:38 +0000 (UTC)
Date: Thu, 2 Jan 2025 10:32:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
Message-ID: <20250102093237.GEZ3ZdNa-zuiyC9LUQ@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
 <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
 <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>

On Thu, Jan 02, 2025 at 10:50:53AM +0530, Nikunj A. Dadhania wrote:
> This is what was suggested by tglx: 
> 
> "So if you know you want TSC to be selected, then upgrade the rating of
>  both the early and the regular TSC clocksource and be done with it."

I highly doubt that he saw what you have now:

Your commit message is talking about virtualized environments but your diff is
doing a global, unconditional change which affects *everything*.

If we are going to do this, we need to put this at least through the
meatgrinder and run it on *everything* that's out there and see what falls out
before we make it the default.

But if tglx thinks this is fine, I won't object - I've uttered my scepticism
already.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

