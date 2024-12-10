Return-Path: <kvm+bounces-33408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEB69EB01A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 12:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4BE31667AC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 11:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9932F2080F4;
	Tue, 10 Dec 2024 11:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HtRt+zNV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB51C78F4E;
	Tue, 10 Dec 2024 11:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733831062; cv=none; b=Meet0jgh+QTn1msEmVPDYDYhDk64QJDJ3ifMzho3jrDCzVHAfQxnMt51sYUMxywi1jQ5IK0P8Z/mNQDWdNAtkd2wkfkYYXN1sA8Q6wziEpOh++6vUV2Q4YAaywepm3Ja/rWEJPXOCm6LicS8vr9GXGShi3j3yQHDB6dSs7/VynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733831062; c=relaxed/simple;
	bh=0Mf4oVOdop9NMOPaTNKF9+A+JLd79o/hDvEFom7mz3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlbNiiYkxsPnwApRlg1RcnylcsY5HHl9WXxl1Ff2JXLqkOtZ5rmGJw8h8YJZ7N5YdkWwowr4aPNqMMGr2cBaztj7oeuhczsO9psCIVyKFaTVASclduSqMcJkyP/A/BB5IaKyXPZa78WxtE/itzPbUBDGciVGnN8j4HYPVJanh4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HtRt+zNV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CCE8040E0289;
	Tue, 10 Dec 2024 11:44:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wKmnOdZIG68v; Tue, 10 Dec 2024 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733831055; bh=C+3Ag3afQTJP9uDrSN5VyHgMzC00XCdTA6P4MYaad6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HtRt+zNVUCaM7MiXETSwBoz37evCN0xcdlVUs8CVsmhj/CbDG8W4LG8C3wzMsnZLx
	 PvVMS14lgTiJhMzSvj7es7LZKd+8/Rdzr+5zGu0CBNjl9lmwyv98oVYNsT2XzEHjxI
	 6bs83szJZwbSac9LSRc6IZaSdBBpTqlUCLhF3oLZv1QZVEIKef0gvMcZ275cd2UL1x
	 cJlg0uk/gWmF99/iIs3AEXkHnkrxonAGMeChHbuFltvemvbILcYk61b0iEp3y14Ofl
	 LTHFVPEPPOKYSE6epCa5zik1OGDgOp9rEV5Mhv6oiwH91jDCnYH4RdxQdj5pMujkpr
	 WQttRPMsVmZITfQy9OHVtYhr5FUx+mkMU1x6i/cRPTs3FfZaVpHIxW+WXEXLoN1Yea
	 +YJGJZoxQmIDbFlCwNWVF/dTNvMEMbS3RnNfGOIyOdtZjt67LhjvOzHegYy2ISxvB2
	 qR5eSrvsK1nAdoDp9WTppzyQ7YaLcjYWv2vJgI0DyU+x6Jdh0cONw/BGpSkmGrEe5U
	 uXyqmREUal+wvfkstFf4oLY4y/3yduomPXxKh7ihYcG0PtkdjGpZr1oBksEzbXgAQp
	 LDqLRA/6LSPbQebUQ0LR0dEqUX2n0jHLPjoCW90uyKfB1sBdMPPFW2s8RhmelmD3f9
	 0OVG+fRm9NXZRiS3i+rJSM4A=
Received: from zn.tnic (p200300EA971f930C329C23FfFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0F1FA40E0288;
	Tue, 10 Dec 2024 11:44:04 +0000 (UTC)
Date: Tue, 10 Dec 2024 12:43:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure
 TSC enabled guests
Message-ID: <20241210114357.GGZ1gpfWVLixGKXc0s@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>

On Tue, Dec 10, 2024 at 10:32:23AM +0530, Nikunj A. Dadhania wrote:
> That is the warning from the APM: 15.36.18 Secure TSC
> 
> "Guests that run with Secure TSC enabled are not expected to perform writes to
> the TSC MSR (10h). If such a write occurs, subsequent TSC values read are
> undefined."
> 
> What I make out of it is: if a write is performed to the TSC MSR, subsequent
> reads of TSC is not reliable/trusted.

Basically, what happens on baremetal too.

> Do you also want to terminate the offending guest?
> 
> ES_UNSUPPORTED return will do that.

I guess that would be too harsh. I guess a warn and a ES_OK should be fine for
now.

> This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC
> MSR reads are converted to RDTSC. This is a good optimization. But just
> wanted to bring up the subtle impact.

That RDTSC happens still in the guest, right? But in its #VC handler. Versus it
being a HV GHCB protocol call. I guess this conversion should be a separate
patch in case there's some issues like the HV intercepting RDTSC... i.e.,
VMEXIT_RDTSC.

We should probably handle that case too and then fallback to the GHCB call. Or
is there a catch 22 I'm missing here...

> Yes, I was thinking about a switch, as there will be more such instances when we
> enable newer features.

Exactly.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

