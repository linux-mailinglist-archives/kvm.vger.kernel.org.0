Return-Path: <kvm+bounces-34410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE039FE5A3
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 12:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2140A18824FE
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 11:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF43A1A83E2;
	Mon, 30 Dec 2024 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QAlEtTIR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275A42594BB;
	Mon, 30 Dec 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735558164; cv=none; b=Vcl7t1t++41S/cKGBrDNSg6OwtSdhRO8tynRLgJMQHVy3CpvL7OLwGIHAKqhAEpRcmhSMp0hr6Q+WGbDsKXsZekrARA9qjQo5FKIGHNd9Oj8Uk8iam17pg5CiyWx/34dXceSN7SrPyD7ogHGHE3w9vg4Nv60zqpkHqsNPtdAOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735558164; c=relaxed/simple;
	bh=eFHzAqqIqdvwT7orCl8moUolC/85ycBRCvKpk2qxJNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kF3GGMf0f0svjPoYXgnwZSs7398C3yILMg3e/by1eEui1pOlbw2fZNGT9nvFIKpFf/7JG45Z78i3RaFw50/2UHo0fHgEJVwZe9dg/1EeOQaflnfiCuc5jnnUcBSN/rWjymoWLqpLKTw9WotzOzojMF6F6gFrf4V2EJwQK3Zluqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QAlEtTIR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DC8B540E02C0;
	Mon, 30 Dec 2024 11:29:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4CGu9SNyAqfi; Mon, 30 Dec 2024 11:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735558156; bh=m//ao9qrCYpV4aUcQOoew8wuEo4I7gde9kOL+bsHqUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAlEtTIRvXGTt8K/9l3o1oqG6YwThJto1ke2Px+vHtD/pDaUHyty/62DUXxVPe/IW
	 xnypeaOOtzf5GeTmlT+8sRLIIdM+g98OjXup9XWbTwmSp7aQcOkWdet9+DSkKKCWyy
	 aoPSCxzAOAZNm6myz5jPrufXIEzI3u+V4s7zdq7ce6gBntX8iFTtqqYWiLHCldpBEx
	 yS1xkTJmBAQ7OD+7gpxdZ8IoKZUhMhRF95ssMap2fj6yMlPfuKQqjEvkUQBZY0GiDo
	 mtQ0D4411vD4paLs+enp9PoksRt8lSv0LHG2ipnQ6c8jTjRIQ/IEFEsQqPy6cDkSNr
	 HHPDCM2cGW5dfz73DRY0pu2U+q2IIFlS9cZUlp+eNykQrl+991D3Btpd94llfCbCYs
	 YW+9U7Qi7KFVIFavRJPZokfQAH09OQGhSUjV+dEmsiaDig8i6t1U4CcN24XnDSI9E2
	 0opIKFCFDqEFIROR07xHu6PDQbtzv2sxHmkq53nb2vNe4SPst3vSRcQizj+HTT/I6e
	 CrewS7Nbtai/kW7W1oWh3Hi3QqD/dW+0zEXGGpdYi0gLB2D7ZBjn3kVHerAYlXv3YP
	 xC3v6o5hEev0Hsv9EdVCfebirUrSW1Iw4jz1Arz8X0T99v1XfN5nQxVAO7aXki8Bxp
	 cNnpANuw58SXMcKjrUERLvT8=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7BBB740E02C4;
	Mon, 30 Dec 2024 11:29:05 +0000 (UTC)
Date: Mon, 30 Dec 2024 12:29:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-10-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:41PM +0530, Nikunj A Dadhania wrote:
> Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for...

The tip tree preferred format for patch subject prefixes is
'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
'genirq/core:'. Please do not use file names or complete file paths as
prefix. 'git log path/to/file' should give you a reasonable hint in most
cases.

Audit your whole set pls.

> +void __init snp_secure_tsc_init(void)
> +{
> +	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
> +	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;

The fact that you assign the same function to two different function ptrs
already hints at some sort of improper functionality split.

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 67aeaba4ba9c..c0eef924b84e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -30,6 +30,7 @@
>  #include <asm/i8259.h>
>  #include <asm/topology.h>
>  #include <asm/uv/uv.h>
> +#include <asm/sev.h>
>  
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -1515,6 +1516,10 @@ void __init tsc_early_init(void)
>  	/* Don't change UV TSC multi-chassis synchronization */
>  	if (is_early_uv_system())
>  		return;
> +
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		snp_secure_tsc_init();

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index aac066d798ef..24e7c6cf3e29 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3287,6 +3287,9 @@ static unsigned long securetsc_get_tsc_khz(void)
 
 void __init snp_secure_tsc_init(void)
 {
+	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		return;
+
 	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
 	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c0eef924b84e..0864b314c26a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1517,8 +1517,7 @@ void __init tsc_early_init(void)
 	if (is_early_uv_system())
 		return;
 
-	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
-		snp_secure_tsc_init();
+	snp_secure_tsc_init();
 
 	if (!determine_cpu_tsc_frequencies(true))
 		return;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

