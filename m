Return-Path: <kvm+bounces-46982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7825ABBE27
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25EF617E84C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 12:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0662798F7;
	Mon, 19 May 2025 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Tux9qkyt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF903279787
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747658594; cv=none; b=gvgrBtOhWL0JkpT60J5KTQmN7LD8hluB+VVCA9ny6owIrxu+F6ASAREwToxPoJ07n+EEW6gGX5NP7nCmSmUCVWARlF3an31hqPFPXykUxHchxjP6dsMttN03e38PccEwof8mYMvLB7I5dFnKv7x3TsM+s10jErXENLrtmiBBP8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747658594; c=relaxed/simple;
	bh=q5VvU6FUR4zFX4dvRdBbZAgNdJvV0SPBSK0J/Fm3VEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+6bZ++kQLBgzDRM1iDQ0VOOaMPk0ExoDnAQQaKD10axD6QptXBrywi3xGZRcCKd/RKA2Ng+kfhqyqKlUgUd/Snj2NgCmt2ErnbdqUjrT4SeqvLTo15np2b5DkedP7OOKdvP/0Dc/XlObPWJ2b67Y+u62Lta0Sus5ZlJeE1B7RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Tux9qkyt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cf257158fso31387545e9.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747658590; x=1748263390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rDyABoPn7w67bSkvz/Y52ihVjWcNwYNAbzxZJ53oHlE=;
        b=Tux9qkytc94DYq15uwUk1hM8F5rfaqVjo/0nuswwqcZsmPDsA1w/HADNTdQ8p2d6Kf
         YKVNriwjl6uDCR9YgChhGlZijOgj6/8OZ/hlPeySlcJ0K4fcwPZWHwRsRbQM2lNUNZgZ
         Z4SyG72cfomjsuCs7FUE+cICPbvbLStyFJZAkqagxGJJ1PSF+SoH4lLThMWnXnqp1voS
         K5scD+71gBTYgGgPMjXU/XBLPB2/P2duINtYyNDuaV4A2bF40mOGYODAtzLjZCYp9OLK
         y7CJgCw8tk+xkk7mAQFJx+QNUTUaaYQjb3/tR/fE39g38cTt7UcajpRVO1U7mDJqR/B0
         kQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747658590; x=1748263390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDyABoPn7w67bSkvz/Y52ihVjWcNwYNAbzxZJ53oHlE=;
        b=wRXUYBfr9ppQd7modzp0qxgd98Z/Odu/HE1Ln8QPRAKreWZlPNQLStkVH4z3GkxqbZ
         voor4zrsW1axXP8oV3eNPng1xLWRGiEn3GJi48fRysM6QMiB51y7wgsoyWE21onJb/1c
         M/B9cY0Ki32h9Upzk5/fPjNFMi/dPou8bpcq/V3cdDW4F5xfBcH6lK37j6T39uywRiJN
         T8KazYbATFfHQG7mQmGcJDX2eyGLBA/Urr6seiOd5fWwlmAzO/LQH6vhEYo0eGI7rJIW
         YlngGxQM0B+yEd9zYBtO0Rsl9xlYz4XKe1Aod3jDk46WM2URkFr7AdEmIeI3pX0VLmtI
         BaRw==
X-Forwarded-Encrypted: i=1; AJvYcCWHpMox5fsYkdCxEbgCd47+dwgzRNjMeXcEyqPcwZRFQRcfmBnWKydWdVvgC+u3pBX/QUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKokJIvN1qDQijItlBweRnh6XDrN8wWDaPgmFUD09xqZ4mf/sY
	0ruWLKSH0U4eCzxA4bOdKopzmDEUoI8/7Uf9LqNJ1FBeNBH2m6zaXd6FP0pG8/oOJlw=
X-Gm-Gg: ASbGnctuL2M7VWQfFGH6/AOTw8+vhotmJ+R2bB75nLlwaG6peIKztCD63UuHVAhSLXT
	MoCAoD7fvBtkUeEzCnSlVJ/2S0Sn9zLIgpqQ40JqM0Xl9P6x7CyUJ/X44T4bZKbYGuCbHEpcxIv
	ZMp5w5X8OVzPw7iSQ8RlNpiLEgsxieLIkRyrxsYb3NMHA1XOOb9ERtybmhgjYd5ONSMGJCK28Yx
	hWJA/93GEm2KtSKOtGALUcUPyj9BmH6FO0DBBb1Y+OrFmQO2jD72ahuXYXrtUDRL50skOVe/dvI
	BHiez7QSHXQMORjFtmGGY+PBwETQEoog148a067R8A5FagJUty/uHGl7FZ7SF5adLt1DXofj/qA
	wXyOyP1MgI5Zp53AJvG40
X-Google-Smtp-Source: AGHT+IF4vTW8H4KvZqjeT3vG9sSlEYWitS+RE58pyzjPQZ378UxMUv9rUG8McrcYouYuTPznzA5U4w==
X-Received: by 2002:a05:6000:2dc4:b0:3a3:6b07:20a1 with SMTP id ffacd0b85a97d-3a36b0721bemr4973387f8f.40.1747658590070;
        Mon, 19 May 2025 05:43:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a3648baa6asm10269874f8f.91.2025.05.19.05.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 05:43:09 -0700 (PDT)
Message-ID: <0bc31024-fca2-4f94-86be-4159842b04fb@rivosinc.com>
Date: Mon, 19 May 2025 14:43:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] riscv: Strengthen duplicate and inconsistent
 definition of RV_X()
To: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: Andrew Jones <ajones@ventanamicro.com>
References: <20250516140805.282770-1-alexghiti@rivosinc.com>
 <20250516140805.282770-3-alexghiti@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250516140805.282770-3-alexghiti@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 16/05/2025 16:08, Alexandre Ghiti wrote:
> RV_X() macro is defined in two different ways which is error prone.
> 
> So harmonize its first definition and add another macro RV_X_mask() for
> the second one.
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h          | 39 +++++++++++++-------------
>  arch/riscv/kernel/machine_kexec_file.c |  2 +-
>  arch/riscv/kernel/traps_misaligned.c   |  2 +-
>  arch/riscv/kvm/vcpu_insn.c             |  2 +-
>  4 files changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 2a589a58b291..ac3e606feca2 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -288,43 +288,44 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  
>  #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
>  #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
> -#define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
> -#define RVC_X(X, s, mask) RV_X(X, s, mask)
> +#define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
> +#define RV_X(X, s, n) RV_X_mask(X, s, ((1 << (n)) - 1))
> +#define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
>  
>  #define RV_EXTRACT_RS1_REG(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
> +	(RV_X_mask(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
>  
>  #define RV_EXTRACT_RD_REG(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
> +	(RV_X_mask(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
>  
>  #define RV_EXTRACT_UTYPE_IMM(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RV_U_IMM_31_12_OPOFF, RV_U_IMM_31_12_MASK)); })
> +	(RV_X_mask(x_, RV_U_IMM_31_12_OPOFF, RV_U_IMM_31_12_MASK)); })
>  
>  #define RV_EXTRACT_JTYPE_IMM(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RV_J_IMM_10_1_OPOFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OFF) | \
> -	(RV_X(x_, RV_J_IMM_11_OPOFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OFF) | \
> -	(RV_X(x_, RV_J_IMM_19_12_OPOFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OFF) | \
> +	(RV_X_mask(x_, RV_J_IMM_10_1_OPOFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OFF) | \
> +	(RV_X_mask(x_, RV_J_IMM_11_OPOFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OFF) | \
> +	(RV_X_mask(x_, RV_J_IMM_19_12_OPOFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OFF) | \
>  	(RV_IMM_SIGN(x_) << RV_J_IMM_SIGN_OFF); })
>  
>  #define RV_EXTRACT_ITYPE_IMM(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RV_I_IMM_11_0_OPOFF, RV_I_IMM_11_0_MASK)) | \
> +	(RV_X_mask(x_, RV_I_IMM_11_0_OPOFF, RV_I_IMM_11_0_MASK)) | \
>  	(RV_IMM_SIGN(x_) << RV_I_IMM_SIGN_OFF); })
>  
>  #define RV_EXTRACT_BTYPE_IMM(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RV_B_IMM_4_1_OPOFF, RV_B_IMM_4_1_MASK) << RV_B_IMM_4_1_OFF) | \
> -	(RV_X(x_, RV_B_IMM_10_5_OPOFF, RV_B_IMM_10_5_MASK) << RV_B_IMM_10_5_OFF) | \
> -	(RV_X(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF) | \
> +	(RV_X_mask(x_, RV_B_IMM_4_1_OPOFF, RV_B_IMM_4_1_MASK) << RV_B_IMM_4_1_OFF) | \
> +	(RV_X_mask(x_, RV_B_IMM_10_5_OPOFF, RV_B_IMM_10_5_MASK) << RV_B_IMM_10_5_OFF) | \
> +	(RV_X_mask(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF) | \
>  	(RV_IMM_SIGN(x_) << RV_B_IMM_SIGN_OFF); })
>  
>  #define RVC_EXTRACT_C2_RS1_REG(x) \
>  	({typeof(x) x_ = (x); \
> -	(RV_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
> +	(RV_X_mask(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
>  
>  #define RVC_EXTRACT_JTYPE_IMM(x) \
>  	({typeof(x) x_ = (x); \
> @@ -346,10 +347,10 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
>  
>  #define RVG_EXTRACT_SYSTEM_CSR(x) \
> -	({typeof(x) x_ = (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
> +	({typeof(x) x_ = (x); RV_X_mask(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
>  
>  #define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
> -	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
> +	({typeof(x) x_ = (x); RV_X_mask(x_, RVFDQ_FL_FS_WIDTH_OFF, \
>  				   RVFDQ_FL_FS_WIDTH_MASK); })
>  
>  #define RVV_EXTRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> @@ -375,10 +376,10 @@ static inline void riscv_insn_insert_jtype_imm(u32 *insn, s32 imm)
>  {
>  	/* drop the old IMMs, all jal IMM bits sit at 31:12 */
>  	*insn &= ~GENMASK(31, 12);
> -	*insn |= (RV_X(imm, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) |
> -		 (RV_X(imm, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) |
> -		 (RV_X(imm, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) |
> -		 (RV_X(imm, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF);
> +	*insn |= (RV_X_mask(imm, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) |
> +		 (RV_X_mask(imm, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) |
> +		 (RV_X_mask(imm, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) |
> +		 (RV_X_mask(imm, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF);
>  }
>  
>  /*
> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> index e36104af2e24..5c2ed4c396e9 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -15,6 +15,7 @@
>  #include <linux/memblock.h>
>  #include <linux/vmalloc.h>
>  #include <asm/setup.h>
> +#include <asm/insn.h>
>  
>  const struct kexec_file_ops * const kexec_file_loaders[] = {
>  	&elf_kexec_ops,
> @@ -109,7 +110,6 @@ static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>  }
>  #endif
>  
> -#define RV_X(x, s, n)  (((x) >> (s)) & ((1 << (n)) - 1))
>  #define RISCV_IMM_BITS 12
>  #define RISCV_IMM_REACH (1LL << RISCV_IMM_BITS)
>  #define RISCV_CONST_HIGH_PART(x) \
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index 77c788660223..ac8f479a3f9c 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -17,6 +17,7 @@
>  #include <asm/hwprobe.h>
>  #include <asm/cpufeature.h>
>  #include <asm/vector.h>
> +#include <asm/insn.h>
>  
>  #define INSN_MATCH_LB			0x3
>  #define INSN_MASK_LB			0x707f
> @@ -112,7 +113,6 @@
>  #define SH_RS2				20
>  #define SH_RS2C				2
>  
> -#define RV_X(x, s, n)			(((x) >> (s)) & ((1 << (n)) - 1))
>  #define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
>  					 (RV_X(x, 10, 3) << 3) | \
>  					 (RV_X(x, 5, 1) << 6))
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 97dec18e6989..62cb2ab4b636 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -8,6 +8,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/cpufeature.h>
> +#include <asm/insn.h>
>  
>  #define INSN_OPCODE_MASK	0x007c
>  #define INSN_OPCODE_SHIFT	2
> @@ -91,7 +92,6 @@
>  #define SH_RS2C			2
>  #define MASK_RX			0x1f
>  
> -#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
>  #define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
>  				 (RV_X(x, 10, 3) << 3) | \
>  				 (RV_X(x, 5, 1) << 6))

LGTM,

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

