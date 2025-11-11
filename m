Return-Path: <kvm+bounces-62807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD98C4F605
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D72A3AF68F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9D3361DA3;
	Tue, 11 Nov 2025 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJqx4hqG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mnnex841"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AA270ED2
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762884544; cv=none; b=Cgl56tJfm+rn/9g85nQjchgVq3nuDYe1EymhWTRKdoi+af1os82GOnyn7nsuttfO4093uJ6Wjf691/GzFMr5nNbtMLVny4Vf/WzF5Fr6fUkJ+0E09IoPULBWEow0Hdy2wpv5y9vphAkLPQLX9o0UC62fOLmAX7kbuj/tsfUyCVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762884544; c=relaxed/simple;
	bh=eM057ONsBUwVHwEcTJHHOB8WMV8ykuIXS2pwGufAqps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XwrAcGI5Gyx9oMGRBf2UJyLTJYpZQdORDsBFP8eiVRqw+lVTdkEPV/VnJ/J38oMg/Yd6pxnCO9ExYhR0/76jP1rYBR2Haiu1+Hczq86kwELTGI8sh4lu/gNRfWnJJDDXKy+0Ax1ABOWMJLJ52D0Zkfu205PHwdxr72ULr962L+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iJqx4hqG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mnnex841; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762884541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZTiiH+FfdmBKx/X3lpx9zM3sRSjKewzog8F+EGlzxMw=;
	b=iJqx4hqGZhFl0eVKFATK7qvipcKEtHEC1qoUY4t2r2rXt0fncX6p2BgKWH80eleLAld6Pm
	VZJzx9Qs9exbdFYTQ+HU+aD/hGTQndFY56rg4rCEKPw3vE59tscOOcGSjQstVw5FT7tafY
	lDJqB3N1V5Fk+oZKpzbYhCHLVz298xk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-jPLYDhF-M42UDrm4b1OlFg-1; Tue, 11 Nov 2025 13:09:00 -0500
X-MC-Unique: jPLYDhF-M42UDrm4b1OlFg-1
X-Mimecast-MFC-AGG-ID: jPLYDhF-M42UDrm4b1OlFg_1762884539
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso92075e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 10:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762884539; x=1763489339; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTiiH+FfdmBKx/X3lpx9zM3sRSjKewzog8F+EGlzxMw=;
        b=Mnnex841eKPrWTBYvpbRREGJXn1tz5N2zUVWsZrT0rOAeDt+d+BmyWbxRQvRNgitIl
         wTswzZCwSBDG9l3VnGTP+YKAx3iUB2+JNyuK4zH6p3hZFVESzQ2dpTmP5QpXkM+PA/dH
         0UaNcym+EGuqYia7ddXJPWHHmXWmZwaqV4FupGXXcL9R0tLg3iSttLrGxHmoaelwCYmf
         /KFtuymBixW6qfNQMNGcEkpHijMcNluA41DjcQIRIc2xMD9MNxk/T3NsbG2DznifIqQD
         PDfPJnk8BXaRPoobMMSO+dphtBGopOIciYqus1N6ovzNa+mOw+12uIALYXR3jP5V+JFX
         XInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762884539; x=1763489339;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTiiH+FfdmBKx/X3lpx9zM3sRSjKewzog8F+EGlzxMw=;
        b=ns0txjtxSGrQKmLpJb7iJcrFkZKTvfmHBJGD0mkeA7pSe/Ewi+3DmLRVPwejIuIe2x
         LZTojJgEAoJhlDNoGAnuCykV9RL2uUSUImCF/687S9couKXM4m8Mj/o6iIRVgrRL4riE
         iXBt6m6DFoPEZK7sfg8zQ7pEzm+NphVsL596KeRt6BkNuy4ABTimQErf+SgRoLzRGASx
         kNe1qJ20wgZQyMwm7FW5hIO0MK9lv9GPnLqc+ZoopF1OK+O2l8tTdg06EG+A1eCxfFPF
         4gESP7Q0os8Kh2xbzGLpRk/8q6GmXt9KdQET8WDtdsh6weOJoGBEGGOXR+GTk32mu1Cn
         sedw==
X-Forwarded-Encrypted: i=1; AJvYcCWi2IA+E/iPvQFVFJV48RPDZAYtu/ieDbRQs4HKG+A1Q866DEBETXtRRWe9kmaaIfnrh+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuB4uC7vSiAp7YXNYlJmpIqB7S9qU2rk37FtzhDf5O2IeikuKv
	0BGZ2CZR0NmSJRoqi4PJ8p1RUHYIEA19IY0s1LL4QdtDNvKOzxaanBAvNFrYK6gYgFyHxSVfnUa
	RaFhWS01KEF14pYoXgQkAkAovpdI8ou0FitZtomxA/gvr9qn66sg2ZA==
X-Gm-Gg: ASbGncsZIH89nHpqfJmgbZ0k0kvPlw5Aa/EozvtEHZfwd7X7/+lxjDdv5j5H6vCfjmz
	zPPEjP4au4tcoCe/KEZ/VrZnEdPUboioGJN5CqNEnU5tcLkoNt7ccKHTGDYzqGdxr7CJWnrnsSS
	oFybH3O+hxuaVkUW+Q5rDSiknH0pczCS86DhhYP4N1J/lRkusR/UO3Iu8yfsqzkfroVRCg5Fjo4
	Ofdav7ELTqZrVMKcS+rnil4lc6F2XAsm75H43RLPngKWpJSq+aj3Bf62sErn/p5S7sXtImHG3xJ
	rHS2XAZMy+XIV8mqJ3DMM7heLApcPy2t7TpfoKdVJV49zNoChb57rCyc46QIIYWWqMJsvlevQLD
	zOWVIaTXLBviw7zNoMCK4NEsEO2ytx1Ieu/bjE6YCocbgFp446Ff7JS1OdPlbQHKr0oBVxb8vF/
	XFdTpp6w==
X-Received: by 2002:a05:600c:4fc9:b0:477:557b:691d with SMTP id 5b1f17b1804b1-477870857e3mr2529945e9.25.1762884539159;
        Tue, 11 Nov 2025 10:08:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFu6AOQN1R5m7gTW6bq/E9O2wxQesMHXXbmPkMIGlWRaF8ha07Tu7YdBjaAgwcY2Fz7PGbqNw==
X-Received: by 2002:a05:600c:4fc9:b0:477:557b:691d with SMTP id 5b1f17b1804b1-477870857e3mr2529745e9.25.1762884538737;
        Tue, 11 Nov 2025 10:08:58 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4775cd45466sm379917565e9.0.2025.11.11.10.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 10:08:58 -0800 (PST)
Message-ID: <7cff2a78-94f3-4746-9833-c2a1bf51eed6@redhat.com>
Date: Tue, 11 Nov 2025 19:08:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 02/20] KVM: x86: Refactor GPR accessors to
 differentiate register access types
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-3-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251110180131.28264-3-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Refactor the GPR accessors to introduce internal helpers to distinguish
> between legacy and extended registers.
> 
> x86 CPUs introduce additional GPRs, but those registers will initially
> remain unused in the kernel and will not be saved in KVM register cache
> on every VM exit. Guest states are expected to remain live in hardware
> registers.
> 
> This abstraction layer centralizes the selection of access methods,
> providing a unified interface. For now, the EGPR accessors are
> placeholders to be implemented later.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h      | 18 ++++++++++++
>   arch/x86/include/asm/kvm_vcpu_regs.h | 16 ++++++++++
>   arch/x86/kvm/fpu.h                   |  6 ++++
>   arch/x86/kvm/x86.h                   | 44 ++++++++++++++++++++++++++--
>   4 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..940f83c121cf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -212,6 +212,24 @@ enum {
>   	VCPU_SREG_GS,
>   	VCPU_SREG_TR,
>   	VCPU_SREG_LDTR,
> +#ifdef CONFIG_X86_64
> +	VCPU_XREG_R16 = __VCPU_XREG_R16,
> +	VCPU_XREG_R17 = __VCPU_XREG_R17,
> +	VCPU_XREG_R18 = __VCPU_XREG_R18,
> +	VCPU_XREG_R19 = __VCPU_XREG_R19,
> +	VCPU_XREG_R20 = __VCPU_XREG_R20,
> +	VCPU_XREG_R21 = __VCPU_XREG_R21,
> +	VCPU_XREG_R22 = __VCPU_XREG_R22,
> +	VCPU_XREG_R23 = __VCPU_XREG_R23,
> +	VCPU_XREG_R24 = __VCPU_XREG_R24,
> +	VCPU_XREG_R25 = __VCPU_XREG_R25,
> +	VCPU_XREG_R26 = __VCPU_XREG_R26,
> +	VCPU_XREG_R27 = __VCPU_XREG_R27,
> +	VCPU_XREG_R28 = __VCPU_XREG_R28,
> +	VCPU_XREG_R29 = __VCPU_XREG_R29,
> +	VCPU_XREG_R30 = __VCPU_XREG_R30,
> +	VCPU_XREG_R31 = __VCPU_XREG_R31,
> +#endif
>   };
>   
>   enum exit_fastpath_completion {
> diff --git a/arch/x86/include/asm/kvm_vcpu_regs.h b/arch/x86/include/asm/kvm_vcpu_regs.h
> index 1af2cb59233b..dd0cc171f405 100644
> --- a/arch/x86/include/asm/kvm_vcpu_regs.h
> +++ b/arch/x86/include/asm/kvm_vcpu_regs.h
> @@ -20,6 +20,22 @@
>   #define __VCPU_REGS_R13 13
>   #define __VCPU_REGS_R14 14
>   #define __VCPU_REGS_R15 15
> +#define __VCPU_XREG_R16 16
> +#define __VCPU_XREG_R17 17
> +#define __VCPU_XREG_R18 18
> +#define __VCPU_XREG_R19 19
> +#define __VCPU_XREG_R20 20
> +#define __VCPU_XREG_R21 21
> +#define __VCPU_XREG_R22 22
> +#define __VCPU_XREG_R23 23
> +#define __VCPU_XREG_R24 24
> +#define __VCPU_XREG_R25 25
> +#define __VCPU_XREG_R26 26
> +#define __VCPU_XREG_R27 27
> +#define __VCPU_XREG_R28 28
> +#define __VCPU_XREG_R29 29
> +#define __VCPU_XREG_R30 30
> +#define __VCPU_XREG_R31 31
>   #endif
>   
>   #endif /* _ASM_X86_KVM_VCPU_REGS_H */
> diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
> index 3ba12888bf66..159239b3a651 100644
> --- a/arch/x86/kvm/fpu.h
> +++ b/arch/x86/kvm/fpu.h
> @@ -4,6 +4,7 @@
>   #define __KVM_FPU_H_
>   
>   #include <asm/fpu/api.h>
> +#include <asm/kvm_vcpu_regs.h>
>   
>   typedef u32		__attribute__((vector_size(16))) sse128_t;
>   #define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
> @@ -137,4 +138,9 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
>   	kvm_fpu_put();
>   }
>   
> +#ifdef CONFIG_X86_64
> +static inline unsigned long kvm_read_egpr(int reg) { return 0; }
> +static inline void kvm_write_egpr(int reg, unsigned long data) { }

Do not inline these, they're quite large.  Leave them in x86.c.

Also please add a KVM_APX Kconfig symbol and add "select KVM_APX if 
X86_64" to KVM_INTEL.

This way, AMD and 32-bit use the same logic to elide all the EGPR code.

Paolo

> +#endif
> +
>   #endif
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 4edadd64d3d5..74ae8f12b5a1 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -400,9 +400,49 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>   	return false;
>   }
>   
> +#ifdef CONFIG_X86_64
> +static inline unsigned long _kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
> +{
> +	switch (reg) {
> +	case VCPU_REGS_RAX ... VCPU_REGS_R15:
> +		return kvm_register_read_raw(vcpu, reg);
> +	case VCPU_XREG_R16 ... VCPU_XREG_R31:
> +		return kvm_read_egpr(reg);
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void _kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long val)
> +{
> +	switch (reg) {
> +	case VCPU_REGS_RAX ... VCPU_REGS_R15:
> +		kvm_register_write_raw(vcpu, reg, val);
> +		break;
> +	case VCPU_XREG_R16 ... VCPU_XREG_R31:
> +		kvm_write_egpr(reg, val);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +#else
> +static inline unsigned long _kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
> +{
> +	return kvm_register_read_raw(vcpu, reg);
> +}
> +
> +static inline void _kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long val)
> +{
> +	kvm_register_write_raw(vcpu, reg, val);
> +}
> +#endif
> +
>   static inline unsigned long kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
>   {
> -	unsigned long val = kvm_register_read_raw(vcpu, reg);
> +	unsigned long val = _kvm_gpr_read(vcpu, reg);
>   
>   	return is_64_bit_mode(vcpu) ? val : (u32)val;
>   }
> @@ -411,7 +451,7 @@ static inline void kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long v
>   {
>   	if (!is_64_bit_mode(vcpu))
>   		val = (u32)val;
> -	return kvm_register_write_raw(vcpu, reg, val);
> +	_kvm_gpr_write(vcpu, reg, val);
>   }
>   
>   static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)


