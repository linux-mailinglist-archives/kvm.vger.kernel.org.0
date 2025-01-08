Return-Path: <kvm+bounces-34752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F59A054F7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A72D3A2570
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C933D1D5ABF;
	Wed,  8 Jan 2025 08:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BtiUvKJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632A1AA781;
	Wed,  8 Jan 2025 08:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736323546; cv=none; b=RK4FG4fQrrlsZX1h7umQI9HmU8jNzKK6ffe49uCfIO9CuwBTZVfUEmWtndrbgnW+W98GpJoPO37FF7cz4Zs4HYKPA1VvBSZhn9rgz1oAyw1Cc9Hb8rhOty1phjXhgckZ8c4N4kRnycLBgp8XuhOdcFv4zm9sitwwCdBOn2iQ2LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736323546; c=relaxed/simple;
	bh=NnQo2+0yXMFfm318o5AHBJPcazm6/LS/1elqIg743CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAgAviwWTJCPNfUwYAsymKxwYXASNFZTNAOen6HuBk8Nk0AQpMDKUCjyUY0xOMm/JTibQ9YyxNUxl9XpE2czjQciR3RnrHuqx898KnQzNTd8U7QcgVzmhj+2xnp5qAHubz0TsxGEuOyKIS4f9Hb93YlekR9mOM/j3bagh6Pwbxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BtiUvKJK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BA9A440E01C5;
	Wed,  8 Jan 2025 08:05:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id c8SgWhVE-vwA; Wed,  8 Jan 2025 08:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736323537; bh=GhCp6fxIxdUod09RiDSv4rhuoYXgPO6+7pwUIXEwMII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BtiUvKJKIiIEMIS8MNH78otI68INJpyztMw2pDeMT0NQ86RYMzaaI+5/K5tCOhz0g
	 bNbMzqnpxg8LfDODn88yN4H4i3UpZlKHe0yazvPgXGZz5ZbqYJYgnTET/cDdenZrlj
	 D7YTdQJ6IasQH69XfZVT45HDH2eOA9iZIqeQ6zrQ8E61er21CxS2NedOLE+jXB03Mz
	 jhXvUW8zIgzCXxfaYQ452KK8my1ekpiGAh6EJ2LTfFtTd/N6IVpG5E/I6tFvxP+MYt
	 +MI37exzH38KZ/JdIqHNb6hUfFWyScspIJ+FwzaqT2X1H4sQthXCRKfPWlLODjhAe3
	 FJsrprihdGRMOXHfGhoY6OVquj+/fPofMYr491ChMHxCoQaiR0ukcBCH0r3ghjQciU
	 zgXfnFoLHHUw6CAvZdUviM1bNvGADH9EZLRS01VA5e4W91O+asaXzd6hdkvrKg+AHE
	 bNEzjVQIAou2ojQasWbkq5UgOls3Io+XJTpzEOA62hzJPoSkiLwU8FUFJ2NJqRoijZ
	 o7mvX2qqQw5SEml4w4XOWGjTGhJAIcZn4EtinmhF5ANlmJfK6dP4Bc1ro9ldNFRSxJ
	 UCcGpdiTEbRKuEvSrmxugKmBCBeE6+VkJ+FGt8lRQxlAy85U5XrSRt9ByW7KXyiEpP
	 Yg+1JJmoGcaSLsrID7hYPajM=
Received: from zn.tnic (p200300eA971f9314329C23FFfEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 71BFD40E0267;
	Wed,  8 Jan 2025 08:05:25 +0000 (UTC)
Date: Wed, 8 Jan 2025 09:05:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250108080515.GAZ34xuwMjbrSYFcHN@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
 <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
 <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
 <c7165d80-ab7f-425b-8323-3f759e1e41a6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c7165d80-ab7f-425b-8323-3f759e1e41a6@amd.com>

On Wed, Jan 08, 2025 at 01:17:11PM +0530, Nikunj A. Dadhania wrote:
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 00a0ac3baab7..763cfeb65b2f 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3218,7 +3218,8 @@ static int __init snp_get_tsc_info(void)
>  
>  void __init snp_secure_tsc_prepare(void)
>  {
> -	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
> +	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))

So how is moving the CC_ATTR_GUEST_SEV_SNP check here make any sense?

I simply zapped the MSR_AMD64_SEV_SNP_ENABLED check above locally.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

