Return-Path: <kvm+bounces-62808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EC0C4F611
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E58334BE50
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3B7393DF7;
	Tue, 11 Nov 2025 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODIcz9QC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZQaTt7h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38B7272801
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762884715; cv=none; b=i8wSVV5tomCBVSeUTtBLIbvd5TKEaigknp5jaTulRJSkSLSk7b+c6w85hidhWPRGEygwl+KAjDmSRXTMEJTUAkrWxgfbX8agpI0fTTCVHGlhw5YzUwbonlZl5TXLKqCvUPupfjsh4dGS0qY6wrKGw3au3TBsorKJMnsEtkePWBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762884715; c=relaxed/simple;
	bh=0CN8aCPRSUd02g74zKDkW0H+gl7LB0GARCp62YCq0Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWd+39GW4zknnBLKv5S9KnsyIWCb5yUvX+iTNGZGWnumZoNzpG+0e3OiGWIHoaxNMFtU2AFhKJEFF0ZjGUiriN8xDKd34fiBRRgZpA2/DcpE3aYf/NvX98qeQMv3tIDg2mYeyGDoJym/W37JjU2vmasOA/r5b3vvVW4cCKm3s9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODIcz9QC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZQaTt7h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762884713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VyEVcxglwaCXXs+jyaytGrNn4eMjO/GxB3dXawBvms0=;
	b=ODIcz9QCFmcLU8Jd8qihJqCfqFzEkicXojfSGe69LnUHIXyCjyr/icAZJ1b+m1aT0/JwLG
	A4KzQEEfnGQK0pey1Ocq7EX4Bj93yw8JxwJmlej3GQQs47OQoKTNswnsTTIi2+iLRFiG92
	I9ZwSGKqb029JZpbwe1smU43XQWOoDs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-RuK9Uno5Oi2pnKoO9v9tLg-1; Tue, 11 Nov 2025 13:11:51 -0500
X-MC-Unique: RuK9Uno5Oi2pnKoO9v9tLg-1
X-Mimecast-MFC-AGG-ID: RuK9Uno5Oi2pnKoO9v9tLg_1762884711
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b3339cab7so1569267f8f.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 10:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762884711; x=1763489511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VyEVcxglwaCXXs+jyaytGrNn4eMjO/GxB3dXawBvms0=;
        b=iZQaTt7hTWZyg23IxFRIZU1ghKMB3hjND2W4c4EFWZNHQ0hFQesV6A0Ij0yPxwBTcp
         XgpUtd+4QDANhdDF46qPOrBOHtba8HTpTn6OMXSVpkp3r0qbfPAVHOgreDB8ijwFbnlX
         kQQ0AlS/FVhmgyZGP0RuqjS7Yx8SuOBGEVBpbUhhUUrhR3CzS/T+r61G00eJ+/W90Ge/
         2S1tAvH92nQ4SH8nOdqQSyEW6WEvTH9q65a0yIr7W7EJhhgHQ9bO8Lr2FKJUp6b4wv0w
         /WsKTnnmoSOAD2iAIy6IIrmSAEFSUWqRHfeQe/Fy59iXWYaDU3N/ShZGTAjk4Aim86FN
         aBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762884711; x=1763489511;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyEVcxglwaCXXs+jyaytGrNn4eMjO/GxB3dXawBvms0=;
        b=FYLryFqARcVS4B6+4gvOH8bFC2/z5dmpsAC6wl1Tz5PBP1PoTB1MeYmHTy9T17sm/j
         5YYmMLEZvzRkpOfRShevrCLj/yUbZDQ4oJXz5EplM9LQFk+uXK3xBU5CiAz3whv9kUvk
         92AjU4V7LZ3QxYBC2Nd3LQyo7LGsbIzPDcfdgJhZDNZ9nvuEQ3TXj6MC8v9CTrlUbCkF
         u6QYQQEZgrRjz6zPh5/XeyLdIXxzKrWwiYlV8uhvTyhZTF6N3WOYU9yg/M4j18wTTFIY
         OcAom5PcKjST2TOluZ33oAADrDRugKvLyQ/TSyoQETvMx1ACEUdTn7+mi4SeOqMAEwML
         QF4w==
X-Forwarded-Encrypted: i=1; AJvYcCU1w9RGXG8+5yFbvpudmsOBbn0vGFFGipw+KKioI+5WfQfnQ+8UzrcmMywnDakKQeH70S4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3lR3Z6WbSrVTzP95IQN62+ZFhBWYKt/7KVjxxFPiCRH9FDqVx
	n9d385mSRb2276lYAY7Q9MTQV+5r6VO8ynre13hp3aAojTF8+dWh3Ry02nK9BFE882So5yyGRPE
	BBDEQfp1EixJ783JM8mMlLvZeWrXRyXSWDISDP6Q+/HVil0IN59tb+g==
X-Gm-Gg: ASbGncv8W/ezsmQUPCzWMeRZZN4U9n6PZYX7Q1OLjoqW52rZN0IG9EOLtPUZ6K8VumE
	Xg7o/sVcV+jhduRZMJcknqKEYD+Mv6wZ1uLIEYf2oIyczRqseXSrXvB2Qt5n68rypWgdN1YsltI
	nU+PaJCOV++IuNqzk9SQakcvhp6E4S0uFlmJvIHuo5/h9cOSB+Lk4umLyDQLSDajC/qbttKT+zS
	tPq0XW0CWeELCL1Jw1jITrREfQG0cGs/dCRBORWyzOqW8gKozpoFEX8+/UcL494gtbBc4XAkznO
	FlH6GdkOlapftVHBkzwUrNN/mvxQ2OR7JuFbTK9QrApNquOI9va+Mak9APLJz2hSwLY64JnqtPz
	HdiLcNki2eG4roSp4iNkK1KoJC5dleJ7MN3/mhmf9MA3WQfgMYsI5M1dYu+Fpsu7By6QcRgeSKA
	WV3mik+A==
X-Received: by 2002:a05:6000:657:b0:42b:394a:9b1 with SMTP id ffacd0b85a97d-42b4bdb2a8amr77460f8f.37.1762884710590;
        Tue, 11 Nov 2025 10:11:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHlLWXKzjkDYJCcvUKBM9NipPqJyE3f107uFZbqslvgYkn1WQZdgE0yG7thg8iRJRVCmu8Jg==
X-Received: by 2002:a05:6000:657:b0:42b:394a:9b1 with SMTP id ffacd0b85a97d-42b4bdb2a8amr77449f8f.37.1762884710169;
        Tue, 11 Nov 2025 10:11:50 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm29390759f8f.30.2025.11.11.10.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 10:11:49 -0800 (PST)
Message-ID: <33eacd6f-5598-49cb-bb11-ca3a47bfb111@redhat.com>
Date: Tue, 11 Nov 2025 19:11:48 +0100
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

Please leave these as kvm_gpr_{read,write}_raw.  It's easier to review 
than the leading underscore.  (It's not hard to undo if you use "git 
format-patch --stdout", do a mass replace on the resulting patch file, 
and then reapply the patch with "git am").

Paolo

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


