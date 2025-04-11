Return-Path: <kvm+bounces-43149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A40A3A85847
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 11:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDB06179FEE
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 09:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655E32989AA;
	Fri, 11 Apr 2025 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MRJ2N1ai"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E24202F70;
	Fri, 11 Apr 2025 09:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364665; cv=none; b=IPyDcYN9mIAjUdYYUpgfxxiXtwZ2mjmgBnEFn03WHP1o0XmVweV00BUB1L/tZ286+x5P2P1H5cdyVOty4Bcrfc6XCc4LoTjR9FYIPf12lnMaHyUciJe/q5DQ87MzjQg7401sX8xBg8OCWjRAJBfH40veRu0S8OUATLUl/MZAFR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364665; c=relaxed/simple;
	bh=nwfoy+wcc2jrProhIgYowMYQYDLcJ48PHbWTmbYJJiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2xlLgXGx6JwU4JHJv1id7OpuU7wM9AJBLjVnWboVlnuB7Z5cd4Z1mpaxzJ15KAQCLXtFb178GvsIGkhh6gU5WiTy+ke3x0YQ7tSDHRBI3uHqoPIaDHMBOA5MOqc8BU4TOIyqwmE+K+5HNjsFtuX3x2LGEtlCIcUq9uwDsLDWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MRJ2N1ai; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E05B40E0244;
	Fri, 11 Apr 2025 09:44:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id g3nw8nuVPm7K; Fri, 11 Apr 2025 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744364658; bh=VULtdd9pZjePUejEED6I4TSMMzip10qR9GA/3/AO+Nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRJ2N1aiUHVg3/bdpiKvNyxM9mhPW8YLhWtAYjzx7t0wjRXBv/F1pqxRTfkDQCR/i
	 Hs+j0twRCPZy6k2MNubYSEr+PxLhuGtJfuq7G/dF2/ZlugGeLq8qoa15UQJDqPqsMZ
	 +OXr8EjsMnH3AWENM1UUhp6hAL4BbTNs8fkS5s3tqBnAp2SLkmDJoRKt6w8KORTlkm
	 hGBMJWw1j1cHD/i29b7PoCYnp0YUjJCZhq8BtzA/yWy69r95kpeP1fxwgNaiFX0eI5
	 DtsZlZbuFdRD4V7svceDNyYCvhRV0EdfQ4YjytG3gkOijZrKCYZmQaLMdNLuU1Nu0d
	 vbIcgT2k5t4jbRjCqTyvKrWcof3UlB4t4Cp6BcFzapngAbDchBtMiqWxEgMSI3FFOx
	 QUoW8kQDObVnhgPB7xk4lkmHO39HOtoH1V6aquUcs02jCBa63suo+2jcaQLsBexbJs
	 5l9xGc7KuUz9SQbNx2DJBnp+7nWxdwEUbmiZgXN+YLYaYJq9oP7rNg24EHfcP+bHK0
	 6g5YG2zPObXC/04CgIDctkgpfv5tTZRTMuqlC3Q4uUghIyT4OMRMUb9vOkehGLv1M+
	 iAMaXEyNjBmiaTP9/aAMG98xqow2nZKiPfNamip/bS9iFKkZdTIi5biOQGO9bkQY6y
	 WymD5XrCBZ8avvbqVbaCWyEc=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0DDFF40E0245;
	Fri, 11 Apr 2025 09:44:05 +0000 (UTC)
Date: Fri, 11 Apr 2025 11:44:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	babu.moger@amd.com, seanjc@google.com, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	jmattson@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 2/2] x86: KVM: Advertise AMD's speculation control
 features
Message-ID: <20250411094404.GKZ_jkZC9Zb0Lc_zU-@fat_crate.local>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-3-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241204134345.189041-3-davydov-max@yandex-team.ru>

On Wed, Dec 04, 2024 at 04:43:45PM +0300, Maksim Davydov wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 45f87a026bba..0a709d03ee5c 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -343,7 +343,10 @@
>  #define X86_FEATURE_AMD_IBPB		(13*32+12) /* Indirect Branch Prediction Barrier */
>  #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
>  #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	(13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
>  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
> +#define X86_FEATURE_AMD_IBRS_PREFERRED	(13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
> +#define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode protection */

This is an AMD-specific leaf - you don't need to put "AMD_" in front of every
bit.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

