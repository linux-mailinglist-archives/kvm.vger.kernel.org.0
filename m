Return-Path: <kvm+bounces-33409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3839EB03E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 12:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEC79167ECC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 11:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89E01A0B05;
	Tue, 10 Dec 2024 11:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bIUFhxV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD91A070E;
	Tue, 10 Dec 2024 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733831638; cv=none; b=Ju1A7Cw88wSKa8qzhDXZdu28aDXLctnOsmwYB8jKNHfTIJ3trjHWBJ3sUnjnPBZopzvGtor9icru10bSEZ3jm8zeUoIHXc3IP34XGJ1ryU7XCitjrdSY12Kt5TjvH/Kdo4YJb1I2ndoMFVWTq0HExqnV6Db/4ObxuGpKsYxWXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733831638; c=relaxed/simple;
	bh=E8Y57loc24DZ53YYVCBR4Gb6cxx9DH/iOIt+nQ27Aik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEQQqeF3fbp4Ec3gwjc87ifMsYhUZBimOxWDOinXxtNnRdIHKPbt/1VBQ6/fr8TehimQ2QOrZtptAEfbEr9b51zfmyTw+ep32s5MdZRVDAlDeIxZdP1iyK1m8sw33c9VtgR8wdNXe2757Fd9pT9FzPK+BeaLeEq1LQMmNWETtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bIUFhxV7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C5A2D40E0289;
	Tue, 10 Dec 2024 11:53:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AUioMlM3D3p3; Tue, 10 Dec 2024 11:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733831630; bh=dy5UoaFNj6uvazM7D97qWEqgPsKemimzwxzPNDTilfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIUFhxV73iRhDIVSUvuuAqErUwFA4wy720T+QlNK1LDmwjE4M8A3ExMtwvgK11uqQ
	 ltZFpqEhSJzvK5mdWaNn+OLdjDepMyNQsx1XAbI6O6/x/LCT5n67G2uepD8/L9ulF2
	 jUUPnYSodJcxq/HMvaa+kvYLvYxgL/fn4ox+E+tZ4leEuh9iijdm7VANvssWEoVfAL
	 1xeQRy9C+CWi5thI5ypvIW5OiCm5OHVnMzcBQZIyOEMnFJDTlPamKtmPfq7te1CfIc
	 m3vXpftNxHwwhLP7ufZC2J14BtkM7fW8v2uHHvyH7vP8U2iZrkWUMf6Igvr4+G/hd5
	 Zt25xtghA6LUDE423hAH9kneOMA16zAzDyd5piOwXqYxhqlb+Yk3MZb0coCsVIIitC
	 sI/xcRLo46ncSpKHjVc78IWGLDDMKMJ8BT7kQzSS5wDdfYfXXoOJ0J7xw+RJdcFALk
	 ssKYnUoOSMp3GhOmXnjOdwqFgbYD8DCjSSnAscI/ZHh5VwGrEatFnAEFfhp3g+Wsi1
	 GKdCVigaDWzky129NuYtzizShCG347LR1t22a9/yNpQ5O3mhlEyGSz6aTf38JrNJOM
	 FzXgeTZ2tzFVMwNn+DZ9P8l0im31m7cD1pVy/Wm032nYJvluUud86jXpJqhQmG24Ed
	 ERFi5kF9IMwq0PWv0/gF/9DU=
Received: from zn.tnic (p200300eA971f930c329C23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1200B40E0277;
	Tue, 10 Dec 2024 11:53:39 +0000 (UTC)
Date: Tue, 10 Dec 2024 12:53:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Message-ID: <20241210115337.GAZ1grwdMmKXVE3Vpi@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-6-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-6-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:37PM +0530, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index 71de53194089..879ab48b705c 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -1140,6 +1140,20 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>  	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>  	enum es_result ret;
>  
> +	/*
> +	 * The hypervisor should not be intercepting RDTSC/RDTSCP when Secure
> +	 * TSC is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
> +	 * instructions are being intercepted. If this should occur and Secure
> +	 * TSC is enabled, guest execution should be terminated as the guest
> +	 * cannot rely on the TSC value provided by the hypervisor.
> +	 *
> +	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
> +	 * use sev_status here as cc_platform_has() is not available when
> +	 * compiling boot/compressed/sev.c.
> +	 */

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71c7024eb597..2e4122f8aa6b 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1147,10 +1147,6 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	 * instructions are being intercepted. If this should occur and Secure
 	 * TSC is enabled, guest execution should be terminated as the guest
 	 * cannot rely on the TSC value provided by the hypervisor.
-	 *
-	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
-	 * use sev_status here as cc_platform_has() is not available when
-	 * compiling boot/compressed/sev.c.
 	 */
 	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 		return ES_VMM_ERROR;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

