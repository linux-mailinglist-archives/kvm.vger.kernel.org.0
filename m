Return-Path: <kvm+bounces-13026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3521689034C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7D491F2438D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE40131184;
	Thu, 28 Mar 2024 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QngdAr6+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2912FF9C;
	Thu, 28 Mar 2024 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711640380; cv=none; b=UzW8WJIEo6viKfhibEP1JFeZPmgSPCrd/spwoeDp42kqqrJ14+6qBbKQHNDQ5jxWRRGc4s17TS89R5jyhA73KbHNaxc8whEOyCQV2Dw5Ssx3Zsw7gQU2ncRNU9F6StsJ0qsuF9vsoiXHKZU0Hqv4s0UVUvbYrmAmgIEjhwSmxzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711640380; c=relaxed/simple;
	bh=qFpjInxBSRGeS4eLn5//waKAvTtSRtM80g21c3bF4XU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVOqdQbY3AwN5lTgtIeFM7tbExTz38/wszShAXV0m1SLNTfVaCyODOX+uYnnrqjoVW1G93ocHEB8N0Gtnv6u9m56gDYBOIf9D5cUX1xk7Cu/FAUQvcvCW+/KTYGtL4SLvh0yELgd7PCJnVuVjo/Q5GMsaEIRjoNjVZqPB8qtsjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QngdAr6+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BE37B40E016B;
	Thu, 28 Mar 2024 15:39:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id br_Jfh_3Oy_y; Thu, 28 Mar 2024 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711640369; bh=Ejb8lv3Vq0VWJRdrieqp/miwPgnvt0ExrNRBJ+G7hRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QngdAr6+2bgCXZFKu1pL1PYr7qPFjAEUCQY3ZG4jc91Bsrw+KhNEbs4LDjqfZtGjk
	 gKl4ibxnSgNTP77wiATk1HnVEZTcu9RLFaMqa12AWvOPqRhd1DwUkpqyvLpDIjWtPu
	 ZdETPhAo+c3JNE+X90NzitgpwIguinfJe4pzBrlAyR3PRmg4pHFYdtcfaI+gX3Stbk
	 03MrPGidKcGyjja/AUzeaOFI918ntiQVr0KCCxlFXl+/ml2cZ3GEoCrxLoy0WTilw2
	 3YICcDtx52a5DBALC+kii4UmrCyS2AQxYDBCCcOxsyX1SVBn9hq6e/tY3nzv3xZjm9
	 FWTy3SQGTnZq25HcxMpTqxOvNRUafQIMRxeLmLxQPgqYPeukc1Q3Z9uHqPt2fz43+P
	 Y8HyhS5ZweVUoX5qxJFzzHGkKmO1bW59PDihVAv27yVyPkFWm/k4jjQSI5xNcisBGJ
	 Gm09COvxMkXrCdUOymegXpFzJo0NNtH3OmWkSWMg6zrfY1jd/6CNAtIZ/zkT4503re
	 dHg+tZKQr6pp+l/xE27XQV8W4iOyjU6VSApJMqTURZl64eYzb3sB4Fhg7W4PoAd9yz
	 uzfzKGG0/+elQ3l+P2/nMITTWSLofdO0+rQpEN5fGGn4/+V40XxLjXNC8fkEwvWAsu
	 fQtSfl7P7bTeLlmGM5J5a9Lo=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9F55040E00B2;
	Thu, 28 Mar 2024 15:39:21 +0000 (UTC)
Date: Thu, 28 Mar 2024 16:39:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
Message-ID: <20240328153914.GBZgWPIvLT6EXAPJci@fat_crate.local>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
 <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
 <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
 <ac4f34a0-036a-48b9-ab56-8257700842fc@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac4f34a0-036a-48b9-ab56-8257700842fc@linux.microsoft.com>

On Thu, Mar 28, 2024 at 03:24:29PM +0100, Jeremi Piotrowski wrote:
> It's not but if you set it before the check it will be set for all AMD
> systems, even if they are neither CC hosts nor CC guests.

That a problem?

It is under a CONFIG_ARCH_HAS_CC_PLATFORM...

> To leave open the possibility of an SNP hypervisor running nested.

But !CC_ATTR_GUEST_SEV_SNP doesn't mean that. It means it is not
a SEV-SNP guest.

> I thought you wanted to filter out SEV-SNP guests, which also have
> X86_FEATURE_SEV_SNP CPUID bit set.

I want to run snp_probe_rmptable_info() only on baremetal where it makes
sense.

> My understanding is that these are the cases:
> 
> CPUID(SEV_SNP) | MSR(SEV_SNP)     | what am I
> ---------------------------------------------
> set            | set              | SNP-guest
> set            | unset            | SNP-host
> unset          | ??               | not SNP

So as you can see, we can't use X86_FEATURE_SEV_SNP for anything due to
the late disable need. So we should be moving away from it.

So we need a test for "am I a nested SNP hypervisor?"

So, can your thing clear X86_FEATURE_HYPERVISOR and thus "emulate"
baremetal?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

