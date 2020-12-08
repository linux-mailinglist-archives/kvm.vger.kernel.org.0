Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380CA2D279B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgLHJ3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:29:15 -0500
Received: from mail.skyhub.de ([5.9.137.197]:56968 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgLHJ3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 04:29:15 -0500
Received: from zn.tnic (p200300ec2f0f0800de4a64cb7778f3c5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:800:de4a:64cb:7778:f3c5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C635D1EC026D;
        Tue,  8 Dec 2020 10:28:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1607419712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SEzL2nzNk/FXsFQuILd9v1nxUDIDI7trIhGNE78qaZg=;
        b=VtoYDb5/xfmPAZW6FtfIjHxr9xcDkPYw6D98p7wT+gjKkDx9IvMv4CFazt5NQaAsXmSQQp
        NsoI8wdhslS+FkU5lLbOKwqQ1GICl0CgZNEqteUCzhcZr7HooUrkWLEYZwIFfMmM3gUPQF
        U96V1TZ0l1UDF29TewJ01QVl1heuf9c=
Date:   Tue, 8 Dec 2020 10:28:28 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kyung Min Park <kyung.min.park@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, cathy.zhang@intel.com
Subject: Re: [PATCH 1/2] Enumerate AVX512 FP16 CPUID feature flag
Message-ID: <20201208092828.GA27920@zn.tnic>
References: <20201208033441.28207-1-kyung.min.park@intel.com>
 <20201208033441.28207-2-kyung.min.park@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201208033441.28207-2-kyung.min.park@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020 at 07:34:40PM -0800, Kyung Min Park wrote:
> Enumerate AVX512 Half-precision floating point (FP16) CPUID feature
> flag. Compared with using FP32, using FP16 cut the number of bits
> required for storage in half, reducing the exponent from 8 bits to 5,
> and the mantissa from 23 bits to 10. Using FP16 also enables developers
> to train and run inference on deep learning models fast when all
> precision or magnitude (FP32) is not needed.
> 
> A processor supports AVX512 FP16 if CPUID.(EAX=7,ECX=0):EDX[bit 23]
> is present. The AVX512 FP16 requires AVX512BW feature be implemented
> since the instructions for manipulating 32bit masks are associated with
> AVX512BW.
> 
> The only in-kernel usage of this is kvm passthrough. The CPU feature
> flag is shown as "avx512_fp16" in /proc/cpuinfo.
> 
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index b6b9b3407c22..bec37ec7101e 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -375,6 +375,7 @@
>  #define X86_FEATURE_TSXLDTRK		(18*32+16) /* TSX Suspend Load Address Tracking */
>  #define X86_FEATURE_PCONFIG		(18*32+18) /* Intel PCONFIG */
>  #define X86_FEATURE_ARCH_LBR		(18*32+19) /* Intel ARCH LBR */
> +#define X86_FEATURE_AVX512_FP16		(18*32+23) /* AVX512 FP16 */
>  #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
>  #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
>  #define X86_FEATURE_FLUSH_L1D		(18*32+28) /* Flush L1D cache */
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index d502241995a3..42af31b64c2c 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -69,6 +69,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>  	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
>  	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
>  	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
> +	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
>  	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
>  	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
>  	{}
> -- 

Acked-by: Borislav Petkov <bp@suse.de>

Paolo, you can pick those up if you prefer.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
