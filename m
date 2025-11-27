Return-Path: <kvm+bounces-64903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C4BC8F992
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D6533AAD8E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1B22E0923;
	Thu, 27 Nov 2025 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+fCyl0X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6F2DF3CC
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263256; cv=none; b=oN8AsDuqy4xruKcBVwWMAfpRc/m+K8R7NtSK8FXJMh1Rvqg1LtkwrznCkltG4Gr3TzULLCevt86Yvat6I/6ZOSH9Vtit5JtEfn+oLj1Z/YupS+ZWPFTHYSvna4C9rmjg7AWmMjl4gPjSK25k2l5qGOlf1i6GMy/bdzisCK5ni7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263256; c=relaxed/simple;
	bh=WNftygtxSL6IMWGCxSRkwNbV5nPIgoHk2RbEmkARluA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EjqUkgaNiLoPKezEM9q3jdHYh0z2sdDp7g+B0jHn7RkraPLCxpNx+lNdKX8IV4ucHC0v7Je+GZVT4X55BTQFdMbpyqR9lgqyLgoNBtf1V8rHavKFqjFR3XHPaZ6w94yUnauimgM64eVEBbyZ2zMkvo1EoPz1Kwh9gR1ksXsRl2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+fCyl0X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764263253;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mV2UP49qvKkyyXIhJrLysCKXjPL5fKqw41mRBMGCnN8=;
	b=K+fCyl0X18ms8HkwsMTRYoxSe34kiH9ZOyOV847a5NROgUwpaYvM/zEAgkuUZTCFwEP3K8
	jioGRGH8c3SlQmDHHvjpQnA4oNeeO8z5w8Ts41Ue4ZTHsymuK4ATjzbMvnb8BYhnLhJC88
	zqn87kZmQfyaB07CBbqCcoRO2Pg/BQc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-eAfN3hj0NqOsc2IGD08QIw-1; Thu, 27 Nov 2025 12:07:31 -0500
X-MC-Unique: eAfN3hj0NqOsc2IGD08QIw-1
X-Mimecast-MFC-AGG-ID: eAfN3hj0NqOsc2IGD08QIw_1764263251
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-882380bead6so23041066d6.0
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 09:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764263251; x=1764868051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV2UP49qvKkyyXIhJrLysCKXjPL5fKqw41mRBMGCnN8=;
        b=eXXueyCMsmHfTxqnkg4ScV9xJzluq22MYduShvWZfzDV7F7jBQmpheh0j3b0woR4Py
         pcv5+JwcRfvfuDPZOpuM/4HHDBo2zNtK5RmprsTHgKXjpvsRnQhvOL0khz8FU6itv3mI
         xYcUYerWjjc1/OlefXbbswi3ckun8y1/IK8Vnu6YTB6GYh/MohGMRGLlwSoeDamNc4Qe
         xNxrjrw7LLACKMfYk3hrYOFJ7vghzFn2B0o2B0qqAVNTZuqNjQDkBQ+y7FWnue21wnBG
         arWoKOyRGDDoQoMK5e2iOZ47Dw9aOURrF/+2ZsahVIyKApgtrGECr8dzpya7umFtwwAN
         JlBw==
X-Forwarded-Encrypted: i=1; AJvYcCXdNLAT0ffJIu05tpEBo4yMOsrIMQPqv1gkq4LxnKygZ8B5j30b65Wph8Mt/7b5NZhkWic=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHxHRVnF968oaa2CFW3WvJYpS1l6E4bQ2awIj/QBpx5MGiIqdv
	+RHXAphBB8Ca09vQOsjsTGcGkXM0imxVZU4Xk0WcQjBskS1bMJkqUPtMQIujSwkst0lyWvvC2wO
	QFPkb0hbYWN/zWmwRl1Dd/yab7RIsTteaM3CDomjj0jCB3zaxwJHRTA==
X-Gm-Gg: ASbGncvpAuKRlCttImnR6r4uYF3Af3aUfNTUa+MRu+o6Y6ED9054LgQSYyhOCw1EMn3
	nZetZyLVQeH88HpC4CxqC5riK61qSE3pFhYngo9+qAsmn7Sl3G4Wk6uxMPa/1Mk2j8RcSVMxOk/
	aeh1LRoxWklQp2SYFKG0tYruzeenCRrZAwTNN7zSrws6fMNh2LCsmtyfSBPIVm+bCQJpKY40/mi
	RR777joVbKlwiG6hBHZ1mj3CZF3UW23aKxFWfVNHcL0uXpkk2igiAYl88PwCksoHTjJPhQBgPOb
	zsle/3KUtJiaCaowsXdMOdpVIPXXaIfoCTuADEToXrQuYHaUG+t+OgwdsFNDBfmpE7dNpm2HrTq
	DDf730IgrXtqxuYsWJchsE4UCyGDBmRDzaSAxc1fVsYVfFwWO7jySU71ctg==
X-Received: by 2002:ac8:5f93:0:b0:4ee:12e0:f071 with SMTP id d75a77b69052e-4efbda335afmr149294841cf.20.1764263251175;
        Thu, 27 Nov 2025 09:07:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6lyi76KYE/oBFzG9aDg5WUkrTUPkQ/7sKsHxhci6KoegKW5WMzobiAFfIQE8n+bHCDtPTPg==
X-Received: by 2002:ac8:5f93:0:b0:4ee:12e0:f071 with SMTP id d75a77b69052e-4efbda335afmr149294261cf.20.1764263250688;
        Thu, 27 Nov 2025 09:07:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b73542sm12559736d6.44.2025.11.27.09.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 09:07:30 -0800 (PST)
Message-ID: <e4ffc74b-ae94-4304-9985-7e1f2df2767f@redhat.com>
Date: Thu, 27 Nov 2025 18:07:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 01/10] arm64: drop to EL1 if booted at
 EL2
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-2-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-2-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> EL2 is not currently supported, drop to EL1 to conitnue booting.
continue
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/cstart64.S         | 47 +++++++++++++++++++++++++++++++++++++++---
>  lib/arm64/asm/sysreg.h | 14 +++++++++++++
>  2 files changed, 58 insertions(+), 3 deletions(-)
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 014c9c7b..79b93dd4 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -15,6 +15,46 @@
>  #include <asm/thread_info.h>
>  #include <asm/sysreg.h>
>  
> +.macro init_el, tmp

init_el2? but also likely to fall back to EL1. At least add a doc comment to explain what the function does.

> +	mrs	\tmp, CurrentEL
> +	cmp	\tmp, CurrentEL_EL2
> +	b.ne	1f
> +	/* EL2 setup */
> +	mrs	\tmp, mpidr_el1
> +	msr	vmpidr_el2, \tmp
> +	mrs	\tmp, midr_el1
> +	msr	vpidr_el2, \tmp
> +	/* clear trap registers */
clear FGT registers if FGT feature supported
> +	mrs	\tmp, id_aa64mmfr0_el1
> +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cbz	\tmp, .Lskip_fgt_\@
> +	mov	\tmp, #0
> +	msr_s	SYS_HFGRTR_EL2, \tmp
> +	msr_s	SYS_HFGWTR_EL2, \tmp
> +	msr_s	SYS_HFGITR_EL2, \tmp
> +	mrs	\tmp, id_aa64mmfr0_el1
> +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cmp	\tmp, #ID_AA64MMFR0_EL1_FGT_FGT2
> +	bne	.Lskip_fgt_\@
> +	mov	\tmp, #0
> +	msr_s	SYS_HFGRTR2_EL2, \tmp
> +	msr_s	SYS_HFGWTR2_EL2, \tmp
> +	msr_s	SYS_HFGITR2_EL2, \tmp
> +.Lskip_fgt_\@:
> +	mov	\tmp, #0
> +	msr	cptr_el2, \tmp
> +	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
> +	msr	hcr_el2, \tmp
> +	mov	\tmp, PSR_MODE_EL1t
> +	msr	spsr_el2, \tmp
> +	adrp	\tmp, 1f
> +	add	\tmp, \tmp, :lo12:1f
> +	msr	elr_el2, \tmp
> +	eret
> +1:
> +.endm

I read in the coverletter you chose to not reuse include/asm/el2_setup.h
which indeed would look overkill given the reduced scope that we target
here. However compared to init_el2_state we seem to do very few things
in the EL2 setup before switching to EL1. I would give a bit more info
in the commit msg about what you keep and what you dropped and why it is
reasonable (stage2, timers, debug at least).

> +
> +
>  #ifdef CONFIG_EFI
>  #include "efi/crt0-efi-aarch64.S"
>  #else
> @@ -56,15 +96,15 @@ start:
>  	add     x6, x6, :lo12:reloc_end
>  1:
>  	cmp	x5, x6
> -	b.hs	1f
> +	b.hs	reloc_done
>  	ldr	x7, [x5]			// r_offset
>  	ldr	x8, [x5, #16]			// r_addend
>  	add	x8, x8, x4			// val = base + r_addend
>  	str	x8, [x4, x7]			// base[r_offset] = val
>  	add	x5, x5, #24
>  	b	1b
> -
> -1:
> +reloc_done:
> +	init_el x4
>  	/* zero BSS */
>  	adrp	x4, bss
>  	add	x4, x4, :lo12:bss
> @@ -185,6 +225,7 @@ get_mmu_off:
>  
>  .globl secondary_entry
>  secondary_entry:
> +	init_el x0
>  	/* enable FP/ASIMD and SVE */
>  	mov	x0, #(3 << 20)
>  	orr	x0, x0, #(3 << 16)
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index e537bb46..ed776716 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -77,6 +77,9 @@ asm(
>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
>  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
>  
> +#define ID_AA64MMFR0_EL1_FGT_SHIFT	56
> +#define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
> +
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
>  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> @@ -113,6 +116,17 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define HCR_EL2_RW		_BITULL(31)
> +
> +#define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)

I don't really understand the renaming

> +
> +#define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
> +#define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)
> +#define SYS_HFGITR_EL2		sys_reg(3, 4, 1, 1, 6)
> +#define SYS_HFGRTR2_EL2		sys_reg(3, 4, 3, 1, 2)
> +#define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
> +#define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
> +
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
Thanks

Eric


