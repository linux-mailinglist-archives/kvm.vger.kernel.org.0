Return-Path: <kvm+bounces-40261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8C7A5522B
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1217A3A1DAC
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD3726BD9F;
	Thu,  6 Mar 2025 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iNTknRuK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A52325BADC;
	Thu,  6 Mar 2025 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280436; cv=none; b=tcwfypwva6KiWO7I3rujXOMhwT/bcuUugCrus1rsctUKRTtrE7udm7DskXiZ7ei20GhKM803mjBs2cBlqvo04BK5/dz1lD9u2F1DTpPn9GYX1MM4PbBObQppz/g+EyWo0GGG3YfmRg2Aakeq44J3KRPdC7eMDeX2VPOcMyJXxfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280436; c=relaxed/simple;
	bh=CA3oS7yvpfmULftQdCN1MhnvUH4iqwV7t8JiQGZfNqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1dE/rQyx4cc3RBdtjczGehVO0aX5TvzlTCklmzGWOTPj5Fgr9Rsx7KfWcBjfJVemAVki+jFzfDSR+1YZOqXB1O7RxYU/oba61nXEu7WuNHCXxBKfRqUQZgE22Q3E5EiHy8yQSi4L17gZLknkz7h02O+XCPn1Rv2x2JNWc7daMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iNTknRuK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 24B8440E0216;
	Thu,  6 Mar 2025 17:00:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nxFP5hBSf08p; Thu,  6 Mar 2025 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741280419; bh=yRS5zdx12qlghPTisegH/MGSTWiNp0ZxQFtA1dzgSCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iNTknRuK8K0YaWLMKsbSE7wAsBn+qoAs+cnac+2DvCsqlfCH/sERig2gFVI1M1kjX
	 VjELmvuYsSFT11HDtmwZoEnhliioJJ/OfeH1mqNo2lcg6/6DZhypTeHvRiLX6FLlFl
	 S60Q1ssaFWb1BBd8EQ6GG1lJObJCygUFYlDUdW4uhTT+69wxNGpcEb9G8g+DaWX49b
	 5LZH6lpb83J0wjbfeRU/KshRXJ7gxGjI33g5O4VFYJk5EMkGdFAkQrNEbJwlZ9Ro/H
	 tpyeqR+7F6XOR1d3JZ8vWlJy6h61gPmjidntFdDQoGL8+O/NTTh7DcaW1xYczGf55t
	 zfXC/16gAmErg2eewKpj7WmDneFcSkWoygk8lrW62aHAQUk8s7YyQVZXGb/MrbM4CH
	 iHrvUjPaEJy33pAWsfOpPot0tdlZjbh7tvrR/OkRaQZV7qZnqZIEoIfgp0DvNDEjQD
	 MGegSFaOjE5SgwIWY1tg7WaRPyOtwHKdfg170zLElbeiuWScJeLFHv+YDCWqRh9JEn
	 E995j59TN8+AZRo9KvMpjv1jkZKveh9BDpFcGVvbxksXCyH32po7/4LkQ3y2tY+hbQ
	 ySTjZgs4n5QJMgF5fGlbacB9+KY6IWVh2dQwRIyq5N04YM84nwS0eRnK3wIEeJ1MA8
	 5KZ40LTgQLk49vGlN0AfzjmI=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 32F4A40E0214;
	Thu,  6 Mar 2025 17:00:05 +0000 (UTC)
Date: Thu, 6 Mar 2025 17:59:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Nikunj A . Dadhania" <nikunj@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 1/2] x86/cpufeatures: Add "Allowed SEV Features"
 Feature
Message-ID: <20250306165958.GGZ8nUjqVyJnw-JV0B@fat_crate.local>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-2-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250306003806.1048517-2-kim.phillips@amd.com>

On Wed, Mar 05, 2025 at 06:38:04PM -0600, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Add CPU feature detection for "Allowed SEV Features" to allow the
> Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
> enable features (via SEV_FEATURES) that the Hypervisor does not
> support or wish to be enabled.
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8f8aaf94dc00..6a12c8c48bd2 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -454,6 +454,7 @@
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
>  #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
>  #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
> +#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>  #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
>  
> -- 

I guess this goes thru Sean:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

