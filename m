Return-Path: <kvm+bounces-28066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA8A992F70
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 16:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E3451F22E94
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 14:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCED1D95B1;
	Mon,  7 Oct 2024 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jbc9WKPy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5F1D416B;
	Mon,  7 Oct 2024 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728311457; cv=none; b=kQ8DEL931PjMn57dOBtt1UTrii8L1kVAuCNmImA1F8/Cancc9ll/ZHHZBzBR1HaTCjb25ELGMzAol+Nz2gV6QV6yHeR6REa2z3nirABAZ+g2DTdLvhiwGb0Q3v7U85wBXu/CjUYbrC2nww3TQD6dJWFnTTGEN09Sg7XkoQGU/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728311457; c=relaxed/simple;
	bh=bqNnpLGSI8ObeGs4CLpY9ivgJb2h8lo/nKnIR/o6eW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/NJVdVTczCSVSK2gQiC4N7ILKz0shnGF/0PWyU+WhjHXNqfnjpq8f+RZPn4kF4FKu8NWVYcOo6A1XEayBIaVkHLljBt80lvoSMS8LLLGuLdu7Te1wqLby0CE27sr7dPVQNFYLXg+jTTX9iiZqdolFu30YI4CUw0P3AQKfK4ank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Jbc9WKPy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ECF2040E0198;
	Mon,  7 Oct 2024 14:30:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4YkEZfVcnZj2; Mon,  7 Oct 2024 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728311440; bh=iszCQnjQ8pE33VOc40q9Nefpswx6WyKznXbi97JB8FY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jbc9WKPyCjxe9DEy9ApzeqjDe8lJosJuGoQI/02RCy/JBxL3edIAq2fju8l8tz572
	 fo6b/rJar65VaP03zYLsCAxg9xpNTPfVzZKKfMQuykG3qhNh6TMvGX8/JWTIggRQRF
	 nccYVmaiB23kFW0P0cKuFqP/37f3OpUxpE3Bwixywg61EXtz39P6DyC6zZInfM/y3m
	 zikwew7zVRmAM89tV0lQUz5XUnxNxH3lplawuvzPhJxZPdMh+kqoMoesit3Ns9EFxq
	 b2bfyvL9uYmlXrVsI5vVUZIjQqtDSq7MFxEqZ7fvUN6yAH4PQvJ/sZ6a/1DbgmEkhw
	 rwJK9bvYQ6k9og4OkqNaY6vB0DlM0p9LncTLrR/illPctiD1itsgC1UTSkbkjB8Uoe
	 mrOk2roSsLEgIjhKWIfmYcfKUJIJle1Zu/Khuwa147XePHKuUl+QjlgQRKotlKczMO
	 DZ9J4H/qVnln7yYkpRRQYn8dUKG7hii+eE3cVhCjU1ZN6t2NX8650aRtBMQgmGgkE+
	 w1IEvD23ZoqB8U28+L4cVp3domYhQaHFt4iGh0jHQjhWZirBHeaMpilCmC7IVDjhEW
	 yqKPrBhmd742NccrTb0LHmZwtfm+r2bJzszC+zfrSMdyJz43ow+7T30tO91C4oTzjz
	 o6b5BM1sz32j5rMYVrrkf6xw=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A65440E0169;
	Mon,  7 Oct 2024 14:30:25 +0000 (UTC)
Date: Mon, 7 Oct 2024 16:30:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Kai Huang <kai.huang@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Venkatesh Srinivas <venkateshs@chromium.org>
Subject: Re: [PATCH v4 1/3] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
Message-ID: <20241007143019.GAZwPwe286itXE2Wj2@fat_crate.local>
References: <20240913173242.3271406-1-jmattson@google.com>
 <20240913173242.3271406-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913173242.3271406-2-jmattson@google.com>

On Fri, Sep 13, 2024 at 10:32:27AM -0700, Jim Mattson wrote:
> AMD's initial implementation of IBPB did not clear the return address
> predictor. Beginning with Zen4, AMD's IBPB *does* clear the return
> address predictor. This behavior is enumerated by
> CPUID.80000008H:EBX.IBPB_RET[bit 30].
> 
> Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
> when determining cross-vendor capabilities.
> 
> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index cabd6b58e8ec..a222a24677d7 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -215,7 +215,7 @@
>  #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
>  #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
>  #define X86_FEATURE_IBRS		( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
> -#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without RSB flush */

I see upstream

#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier */

Where does "without RSB flush" come from?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

