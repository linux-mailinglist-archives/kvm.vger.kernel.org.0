Return-Path: <kvm+bounces-43001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA385A820F3
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B02988075C
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C7425D21C;
	Wed,  9 Apr 2025 09:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CORhHpP+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544E71D6DBC;
	Wed,  9 Apr 2025 09:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190649; cv=none; b=LjgoAiox7FbofCoVgCD6CXMBkviTRe9koi/Ysa5cFeQSLwciGwtIK2YkPTkmksaDdWFVmM8NyL53EeAwxapYZ5l7BvSiv3U+n0VJMjT1lJ9BYu84FHMudDklO5ghTCqr7UvYoR7fcTFm2XW/4G9GI140j0fvWwhJzg7LmOw0Mp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190649; c=relaxed/simple;
	bh=pKMPn6LX9Ik+1q/L52rcfUEHkvv9f6rdNvpYqbcrERc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+Le7u4nIfWsP+SiX5czuZtrIWEzG8PfAaM3SZqc9TRSJAXbgS9z1rsavOrr3EyLMRo3BbtabN0i2/f1U3s5dnMD0QMlPBdZuvG3VrkQK74fHRtbY5SwID5fYDsH9dFXf3lNRlUHXFSOvhDpq1ZCdmhxLDjzKB8GLlVprtumxQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CORhHpP+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9C90140E021C;
	Wed,  9 Apr 2025 09:24:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wsQ31adu357h; Wed,  9 Apr 2025 09:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744190639; bh=NLvGKlsAVBdcuD0MlFjXL/oVZE7GoQlaw8lDAa1U9Ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CORhHpP+3gm07R/iQCHSwNp6WUNAj/ArCdlVAK4V9rQf9WBOCw0Btx/hvjSv5rger
	 rse4TmiQImVw0+qJ9+fDhNY7XIaDB/3XpIWY4zScsHcq0HqalUmIgOl6UvYC+ezJuX
	 C3UQyfthmbv6DSqMVYF5S3vqxNxTn3rfOs2jrWa5VPvEjsiROIsvAfyyiSGN/vG2+F
	 AJ2ZhJkOrhfZfDcwRt3pyAF9Fvmjpx6j7LYIBEjEEMrWvxPRBIy+g8HsZZAPltnka4
	 PTFbSl/nfQJB07+ui5mPBWVE/R5y6Gnr2nSDoDXnJMf4SpiB9EUmRKZbzu5XdB0yt/
	 m72uxvCH+7lO79e9na9Y9QabPgkc9SIUKTMN2aZ8lKxW5wHjyzHyPwwpYkaCLNk76J
	 RMKpQNdwDZESA70ln62sNSV7cL74l2TxKGPCFnRsgKAfl9bfz7EYFn+UmNE1E4HYdK
	 mbkd0RP6kJ19NEu//Rd6gpH2VlsHoG9FEVZU3NFfKBQZwsLxh1xyMnNED0gHZVPXOJ
	 ohvW0W8TQCG9DCwafd+Xn5nnvI7vq6r/9EkoYdZKjH5MAN6J2MMKUoeXitz07/8wFK
	 Np8HU7vp7/5mGFgLYefK39j4RBsBIOdKCGF/1+s2PAL3JdUbRERxLb3KRWSJ9zj1xo
	 9lrkUXzw+OW06HHsG6S545Qc=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C8B7940E01A3;
	Wed,  9 Apr 2025 09:23:43 +0000 (UTC)
Date: Wed, 9 Apr 2025 11:23:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Babu Moger <babu.moger@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
	hpa@zytor.com, daniel.sneddon@linux.intel.com, jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com, thomas.lendacky@amd.com,
	perry.yuan@amd.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] x86/cpufeatures: Define X86_FEATURE_PREFETCHI (AMD)
Message-ID: <20250409092341.GBZ_Y8ne2Of4lfvL_O@fat_crate.local>
References: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>

On Tue, Apr 08, 2025 at 05:57:09PM -0500, Babu Moger wrote:
> The latest AMD platform has introduced a new instruction called PREFETCHI.
> This instruction loads a cache line from a specified memory address into
> the indicated data or instruction cache level, based on locality reference
> hints.
> 
> Feature bit definition:
> CPUID_Fn80000021_EAX [bit 20] - Indicates support for IC prefetch.
> 
> This feature is analogous to Intel's PREFETCHITI (CPUID.(EAX=7,ECX=1):EDX),
> though the CPUID bit definitions differ between AMD and Intel.
> 
> Expose the feature to KVM guests.
> 
> The feature is documented in Processor Programming Reference (PPR)
> for AMD Family 1Ah Model 02h, Revision C1 (Link below).
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 6c2c152d8a67..7d7507b3eefd 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -457,6 +457,7 @@
>  #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
>  #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
>  
> +#define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

