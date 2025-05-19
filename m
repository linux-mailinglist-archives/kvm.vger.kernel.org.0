Return-Path: <kvm+bounces-46983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC86EABBE2B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7438189F60A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 12:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6826D27933F;
	Mon, 19 May 2025 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tMT4rrdX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AD11DFFD
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 12:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747658679; cv=none; b=C7d0ZE3JLj+ceBbo3SFO9Ww0EDiwKuOPympIdsdkEg3SAkTHz7Sd9+T2vjEvI3i9txgYSH7snh/VqrQVmRNV+VOp5n4yQzlArTgAbQrkJmFvDbuqDF+cqh2mipKAes7FT2V8LBZTHwk1yPwJZ0GMisUW1fyiz2f3k0q7A1Dhb08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747658679; c=relaxed/simple;
	bh=lIdG820zZBQObgHPsOVG/dU6qVS3fBDwsFdV5MiEFTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LbrYVteFcTRCALWZoiil6ttSBw837NTjAOH/+vcsOxpRxCqCK/MO/ZZNoTwpvWTafShAfEWZdTrNVjPBzmxxYnVT0M5VVmSUfLzUFwZdyb2bI7yvw9MuUT2zz2AyimRwlIWufLXTeS8RTIJjQHj+ed41IpgS6qo9Hu3dqBAO0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tMT4rrdX; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43edb40f357so35230135e9.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 05:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747658675; x=1748263475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGZI2w3d9JPk74Bq7tac7jVDEb3rSRXwMCi+CvM8/fs=;
        b=tMT4rrdXWNVwJMVOuDXVoVrMiR/qMIsjTd8Xf80tGGRM1FKT9ZLUSsslq302t/vNIy
         TskdPIGf+ilS6v20Yhq+BiNESnIowgSjz3E5zVv8YNo7oH8hetTejqdZhh9jB98mDu2u
         VXePMeDhfywQWNatwj0S4dL6REg28bypF5Fe0jt9aYk4Z4w8/eH1cVk5cUVQoE43zZO9
         WjgP76z4UQO7oHDGf4VQYW01+PaYHVV8mhI7TFZ0kg+NKeHYCOxal2xUcbHP5VeUbotn
         0WhlFAqsOli00bMF4dpJA1dwWMEzLqHK1j0xzFHbjv9kty55Pd8fdezBWO9wxuCr3U/9
         gTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747658675; x=1748263475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGZI2w3d9JPk74Bq7tac7jVDEb3rSRXwMCi+CvM8/fs=;
        b=Hx4lGHPedj49wCAigL8LJprp9jQhSBOe2Fqan55yNXjIMkK3nrBiyMCOQrCAzUvT9+
         hYYO/gQG49RRWhoDmRbQNSJ50nHzqWsiSQgOqAqgGf9AUxkd4+lYBrTFogfi8rvZ+slv
         FkByUm0WIdjF9VzZoVgDwR9O1fUu97mzLTGRTD3Rkl+ERQ4bTNm9qpxofdEkC9wSE4X5
         2BpqyQ4NkD8Sbp8RVVCWAcv7mt7w514NEnUDpecU5VO2fbe5ZrC9HMhL3FGaMB1Qf2tq
         0wb0zJ3Tn8+5gkj52CtFgKlWl5krAx/mT9/IMB2ky/KybTiPMvwePh9jvCxKA6pwW9SS
         Imbw==
X-Forwarded-Encrypted: i=1; AJvYcCXWLwgJ8KxmgW+wnugwR7XQ8WecBYdWnwOgXqXnIx3NGWK2EJkDxgfR9lnSHXt+ckt1D/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh4ZFwI4UUa0X+WYFDkNi7ZBnujx7AFTcgq2Lc/XkPgK79EZ0H
	kpQKZeMuD4pz4Xh50yUde/D001l38X8mZd/3v9dqAUB5t1WNLloTeTFQ1lvqIV9mCsE=
X-Gm-Gg: ASbGncs8wZHIK9NFi1RU3uT6PXiTdmDBGGyVuuyHjEPotFgzhkcMwYVGAAiZdXJBnwh
	ZP3Po5x9LtJFORMWHf4LKsmfmQl6yfXy4PAhkfMku0uElphHL/HNL0Inkar6wzYKCIPWtOLTMIS
	sDFjw5Z7LF3CT6eT5UlwDjfdJD8uvRn8AIuHmbcrpsjyHjD3pIsyNKG7eX9mIW/MgEb14gcg1SD
	0mxcuDNZHXEAR9KHNErgUQmCjpr8k029jwZiSoQwHvv03KKCWB/pQeQaymI06E0z8omp2OuGIrs
	ITeWvEl2hEkKnV1mFB/cC1WOV7kNCEpUTYkVKbajuFs71kCtrO5dyOwjQK81RBKlTJU7uVi5n8v
	/e6vfvA2hixRx8CsG7edg
X-Google-Smtp-Source: AGHT+IEu6p+HjvOihJHZXI79uTE1qb4pPrjn1f/0/ciQyCQGEzWA9UFcGn7WJaf4m/SEWtJnNOkc9A==
X-Received: by 2002:a05:600c:1d96:b0:442:f4d4:53a with SMTP id 5b1f17b1804b1-442fd60ce7dmr136586355e9.2.1747658675419;
        Mon, 19 May 2025 05:44:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d258sm12662489f8f.20.2025.05.19.05.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 05:44:34 -0700 (PDT)
Message-ID: <e1893267-24b5-4e9d-b5f2-728cc0324932@rivosinc.com>
Date: Mon, 19 May 2025 14:44:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] riscv: Move all duplicate insn parsing macros into
 asm/insn.h
To: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: Andrew Jones <ajones@ventanamicro.com>
References: <20250516140805.282770-1-alexghiti@rivosinc.com>
 <20250516140805.282770-4-alexghiti@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250516140805.282770-4-alexghiti@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 16/05/2025 16:08, Alexandre Ghiti wrote:
> kernel/traps_misaligned.c and kvm/vcpu_insn.c define the same macros to
> extract information from the instructions.
> 
> Let's move the definitions into asm/insn.h to avoid this duplication.
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h        | 171 ++++++++++++++++++++++++++-
>  arch/riscv/kernel/traps_misaligned.c | 142 ----------------------
>  arch/riscv/kvm/vcpu_insn.c           | 126 --------------------
>  3 files changed, 166 insertions(+), 273 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index ac3e606feca2..ad26f859cfe5 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -286,11 +286,172 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  	       (code & RVC_INSN_J_RS1_MASK) != 0;
>  }
>  
> -#define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
> -#define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
> -#define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
> -#define RV_X(X, s, n) RV_X_mask(X, s, ((1 << (n)) - 1))
> -#define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
> +#define INSN_MATCH_LB		0x3
> +#define INSN_MASK_LB		0x707f
> +#define INSN_MATCH_LH		0x1003
> +#define INSN_MASK_LH		0x707f
> +#define INSN_MATCH_LW		0x2003
> +#define INSN_MASK_LW		0x707f
> +#define INSN_MATCH_LD		0x3003
> +#define INSN_MASK_LD		0x707f
> +#define INSN_MATCH_LBU		0x4003
> +#define INSN_MASK_LBU		0x707f
> +#define INSN_MATCH_LHU		0x5003
> +#define INSN_MASK_LHU		0x707f
> +#define INSN_MATCH_LWU		0x6003
> +#define INSN_MASK_LWU		0x707f
> +#define INSN_MATCH_SB		0x23
> +#define INSN_MASK_SB		0x707f
> +#define INSN_MATCH_SH		0x1023
> +#define INSN_MASK_SH		0x707f
> +#define INSN_MATCH_SW		0x2023
> +#define INSN_MASK_SW		0x707f
> +#define INSN_MATCH_SD		0x3023
> +#define INSN_MASK_SD		0x707f
> +
> +#define INSN_MATCH_C_LD		0x6000
> +#define INSN_MASK_C_LD		0xe003
> +#define INSN_MATCH_C_SD		0xe000
> +#define INSN_MASK_C_SD		0xe003
> +#define INSN_MATCH_C_LW		0x4000
> +#define INSN_MASK_C_LW		0xe003
> +#define INSN_MATCH_C_SW		0xc000
> +#define INSN_MASK_C_SW		0xe003
> +#define INSN_MATCH_C_LDSP	0x6002
> +#define INSN_MASK_C_LDSP	0xe003
> +#define INSN_MATCH_C_SDSP	0xe002
> +#define INSN_MASK_C_SDSP	0xe003
> +#define INSN_MATCH_C_LWSP	0x4002
> +#define INSN_MASK_C_LWSP	0xe003
> +#define INSN_MATCH_C_SWSP	0xc002
> +#define INSN_MASK_C_SWSP	0xe003
> +
> +#define INSN_OPCODE_MASK	0x007c
> +#define INSN_OPCODE_SHIFT	2
> +#define INSN_OPCODE_SYSTEM	28
> +
> +#define INSN_MASK_WFI		0xffffffff
> +#define INSN_MATCH_WFI		0x10500073
> +
> +#define INSN_MASK_WRS		0xffffffff
> +#define INSN_MATCH_WRS		0x00d00073
> +
> +#define INSN_MATCH_CSRRW	0x1073
> +#define INSN_MASK_CSRRW		0x707f
> +#define INSN_MATCH_CSRRS	0x2073
> +#define INSN_MASK_CSRRS		0x707f
> +#define INSN_MATCH_CSRRC	0x3073
> +#define INSN_MASK_CSRRC		0x707f
> +#define INSN_MATCH_CSRRWI	0x5073
> +#define INSN_MASK_CSRRWI	0x707f
> +#define INSN_MATCH_CSRRSI	0x6073
> +#define INSN_MASK_CSRRSI	0x707f
> +#define INSN_MATCH_CSRRCI	0x7073
> +#define INSN_MASK_CSRRCI	0x707f
> +
> +#define INSN_MATCH_FLW		0x2007
> +#define INSN_MASK_FLW		0x707f
> +#define INSN_MATCH_FLD		0x3007
> +#define INSN_MASK_FLD		0x707f
> +#define INSN_MATCH_FLQ		0x4007
> +#define INSN_MASK_FLQ		0x707f
> +#define INSN_MATCH_FSW		0x2027
> +#define INSN_MASK_FSW		0x707f
> +#define INSN_MATCH_FSD		0x3027
> +#define INSN_MASK_FSD		0x707f
> +#define INSN_MATCH_FSQ		0x4027
> +#define INSN_MASK_FSQ		0x707f
> +
> +#define INSN_MATCH_C_FLD	0x2000
> +#define INSN_MASK_C_FLD		0xe003
> +#define INSN_MATCH_C_FLW	0x6000
> +#define INSN_MASK_C_FLW		0xe003
> +#define INSN_MATCH_C_FSD	0xa000
> +#define INSN_MASK_C_FSD		0xe003
> +#define INSN_MATCH_C_FSW	0xe000
> +#define INSN_MASK_C_FSW		0xe003
> +#define INSN_MATCH_C_FLDSP	0x2002
> +#define INSN_MASK_C_FLDSP	0xe003
> +#define INSN_MATCH_C_FSDSP	0xa002
> +#define INSN_MASK_C_FSDSP	0xe003
> +#define INSN_MATCH_C_FLWSP	0x6002
> +#define INSN_MASK_C_FLWSP	0xe003
> +#define INSN_MATCH_C_FSWSP	0xe002
> +#define INSN_MASK_C_FSWSP	0xe003
> +
> +#define INSN_MATCH_C_LHU		0x8400
> +#define INSN_MASK_C_LHU			0xfc43
> +#define INSN_MATCH_C_LH			0x8440
> +#define INSN_MASK_C_LH			0xfc43
> +#define INSN_MATCH_C_SH			0x8c00
> +#define INSN_MASK_C_SH			0xfc43
> +
> +#define INSN_16BIT_MASK		0x3
> +#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
> +#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
> +
> +#define SHIFT_RIGHT(x, y)		\
> +	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
> +
> +#define REG_MASK			\
> +	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
> +
> +#define REG_OFFSET(insn, pos)		\
> +	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
> +
> +#define REG_PTR(insn, pos, regs)	\
> +	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
> +
> +#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
> +#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
> +#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
> +#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
> +#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
> +#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
> +#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
> +#define IMM_I(insn)		((s32)(insn) >> 20)
> +#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
> +				 (s32)(((insn) >> 7) & 0x1f))
> +
> +#define SH_RD			7
> +#define SH_RS1			15
> +#define SH_RS2			20
> +#define SH_RS2C			2
> +#define MASK_RX			0x1f
> +
> +#if defined(CONFIG_64BIT)
> +#define LOG_REGBYTES		3
> +#else
> +#define LOG_REGBYTES		2
> +#endif
> +
> +#define MASK_FUNCT3		0x7000
> +
> +#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
> +
> +#define RV_IMM_SIGN(x)		(-(((x) >> 31) & 1))
> +#define RVC_IMM_SIGN(x)		(-(((x) >> 12) & 1))
> +#define RV_X_mask(X, s, mask)	(((X) >> (s)) & (mask))
> +#define RV_X(X, s, n)		RV_X_mask(X, s, ((1 << (n)) - 1))
> +#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
> +				 (RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 5, 1) << 6))
> +#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 5, 2) << 6))
> +#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
> +				 (RV_X(x, 12, 1) << 5) | \
> +				 (RV_X(x, 2, 2) << 6))
> +#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
> +				 (RV_X(x, 12, 1) << 5) | \
> +				 (RV_X(x, 2, 3) << 6))
> +#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
> +				 (RV_X(x, 7, 2) << 6))
> +#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> +				 (RV_X(x, 7, 3) << 6))
> +#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
> +#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
> +#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
> +#define RVC_X(X, s, mask)	RV_X_mask(X, s, mask)
>  
>  #define RV_EXTRACT_RS1_REG(x) \
>  	({typeof(x) x_ = (x); \
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index ac8f479a3f9c..b52df35a5e05 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -19,148 +19,6 @@
>  #include <asm/vector.h>
>  #include <asm/insn.h>
>  
> -#define INSN_MATCH_LB			0x3
> -#define INSN_MASK_LB			0x707f
> -#define INSN_MATCH_LH			0x1003
> -#define INSN_MASK_LH			0x707f
> -#define INSN_MATCH_LW			0x2003
> -#define INSN_MASK_LW			0x707f
> -#define INSN_MATCH_LD			0x3003
> -#define INSN_MASK_LD			0x707f
> -#define INSN_MATCH_LBU			0x4003
> -#define INSN_MASK_LBU			0x707f
> -#define INSN_MATCH_LHU			0x5003
> -#define INSN_MASK_LHU			0x707f
> -#define INSN_MATCH_LWU			0x6003
> -#define INSN_MASK_LWU			0x707f
> -#define INSN_MATCH_SB			0x23
> -#define INSN_MASK_SB			0x707f
> -#define INSN_MATCH_SH			0x1023
> -#define INSN_MASK_SH			0x707f
> -#define INSN_MATCH_SW			0x2023
> -#define INSN_MASK_SW			0x707f
> -#define INSN_MATCH_SD			0x3023
> -#define INSN_MASK_SD			0x707f
> -
> -#define INSN_MATCH_FLW			0x2007
> -#define INSN_MASK_FLW			0x707f
> -#define INSN_MATCH_FLD			0x3007
> -#define INSN_MASK_FLD			0x707f
> -#define INSN_MATCH_FLQ			0x4007
> -#define INSN_MASK_FLQ			0x707f
> -#define INSN_MATCH_FSW			0x2027
> -#define INSN_MASK_FSW			0x707f
> -#define INSN_MATCH_FSD			0x3027
> -#define INSN_MASK_FSD			0x707f
> -#define INSN_MATCH_FSQ			0x4027
> -#define INSN_MASK_FSQ			0x707f
> -
> -#define INSN_MATCH_C_LD			0x6000
> -#define INSN_MASK_C_LD			0xe003
> -#define INSN_MATCH_C_SD			0xe000
> -#define INSN_MASK_C_SD			0xe003
> -#define INSN_MATCH_C_LW			0x4000
> -#define INSN_MASK_C_LW			0xe003
> -#define INSN_MATCH_C_SW			0xc000
> -#define INSN_MASK_C_SW			0xe003
> -#define INSN_MATCH_C_LDSP		0x6002
> -#define INSN_MASK_C_LDSP		0xe003
> -#define INSN_MATCH_C_SDSP		0xe002
> -#define INSN_MASK_C_SDSP		0xe003
> -#define INSN_MATCH_C_LWSP		0x4002
> -#define INSN_MASK_C_LWSP		0xe003
> -#define INSN_MATCH_C_SWSP		0xc002
> -#define INSN_MASK_C_SWSP		0xe003
> -
> -#define INSN_MATCH_C_FLD		0x2000
> -#define INSN_MASK_C_FLD			0xe003
> -#define INSN_MATCH_C_FLW		0x6000
> -#define INSN_MASK_C_FLW			0xe003
> -#define INSN_MATCH_C_FSD		0xa000
> -#define INSN_MASK_C_FSD			0xe003
> -#define INSN_MATCH_C_FSW		0xe000
> -#define INSN_MASK_C_FSW			0xe003
> -#define INSN_MATCH_C_FLDSP		0x2002
> -#define INSN_MASK_C_FLDSP		0xe003
> -#define INSN_MATCH_C_FSDSP		0xa002
> -#define INSN_MASK_C_FSDSP		0xe003
> -#define INSN_MATCH_C_FLWSP		0x6002
> -#define INSN_MASK_C_FLWSP		0xe003
> -#define INSN_MATCH_C_FSWSP		0xe002
> -#define INSN_MASK_C_FSWSP		0xe003
> -
> -#define INSN_MATCH_C_LHU		0x8400
> -#define INSN_MASK_C_LHU			0xfc43
> -#define INSN_MATCH_C_LH			0x8440
> -#define INSN_MASK_C_LH			0xfc43
> -#define INSN_MATCH_C_SH			0x8c00
> -#define INSN_MASK_C_SH			0xfc43
> -
> -#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
> -
> -#if defined(CONFIG_64BIT)
> -#define LOG_REGBYTES			3
> -#define XLEN				64
> -#else
> -#define LOG_REGBYTES			2
> -#define XLEN				32
> -#endif
> -#define REGBYTES			(1 << LOG_REGBYTES)
> -#define XLEN_MINUS_16			((XLEN) - 16)
> -
> -#define SH_RD				7
> -#define SH_RS1				15
> -#define SH_RS2				20
> -#define SH_RS2C				2
> -
> -#define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
> -					 (RV_X(x, 10, 3) << 3) | \
> -					 (RV_X(x, 5, 1) << 6))
> -#define RVC_LD_IMM(x)			((RV_X(x, 10, 3) << 3) | \
> -					 (RV_X(x, 5, 2) << 6))
> -#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 3) << 2) | \
> -					 (RV_X(x, 12, 1) << 5) | \
> -					 (RV_X(x, 2, 2) << 6))
> -#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 2) << 3) | \
> -					 (RV_X(x, 12, 1) << 5) | \
> -					 (RV_X(x, 2, 3) << 6))
> -#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 4) << 2) | \
> -					 (RV_X(x, 7, 2) << 6))
> -#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 3) << 3) | \
> -					 (RV_X(x, 7, 3) << 6))
> -#define RVC_RS1S(insn)			(8 + RV_X(insn, SH_RD, 3))
> -#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 3))
> -#define RVC_RS2(insn)			RV_X(insn, SH_RS2C, 5)
> -
> -#define SHIFT_RIGHT(x, y)		\
> -	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
> -
> -#define REG_MASK			\
> -	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
> -
> -#define REG_OFFSET(insn, pos)		\
> -	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
> -
> -#define REG_PTR(insn, pos, regs)	\
> -	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
> -
> -#define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
> -#define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
> -#define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
> -#define GET_RS2S(insn, regs)		(*REG_PTR(RVC_RS2S(insn), 0, regs))
> -#define GET_RS2C(insn, regs)		(*REG_PTR(insn, SH_RS2C, regs))
> -#define GET_SP(regs)			(*REG_PTR(2, 0, regs))
> -#define SET_RD(insn, regs, val)		(*REG_PTR(insn, SH_RD, regs) = (val))
> -#define IMM_I(insn)			((s32)(insn) >> 20)
> -#define IMM_S(insn)			(((s32)(insn) >> 25 << 5) | \
> -					 (s32)(((insn) >> 7) & 0x1f))
> -#define MASK_FUNCT3			0x7000
> -
> -#define GET_PRECISION(insn) (((insn) >> 25) & 3)
> -#define GET_RM(insn) (((insn) >> 12) & 7)
> -#define PRECISION_S 0
> -#define PRECISION_D 1
> -
>  #ifdef CONFIG_FPU
>  
>  #define FP_GET_RD(insn)		(insn >> 7 & 0x1F)
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 62cb2ab4b636..de1f96ea6225 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -10,132 +10,6 @@
>  #include <asm/cpufeature.h>
>  #include <asm/insn.h>
>  
> -#define INSN_OPCODE_MASK	0x007c
> -#define INSN_OPCODE_SHIFT	2
> -#define INSN_OPCODE_SYSTEM	28
> -
> -#define INSN_MASK_WFI		0xffffffff
> -#define INSN_MATCH_WFI		0x10500073
> -
> -#define INSN_MASK_WRS		0xffffffff
> -#define INSN_MATCH_WRS		0x00d00073
> -
> -#define INSN_MATCH_CSRRW	0x1073
> -#define INSN_MASK_CSRRW		0x707f
> -#define INSN_MATCH_CSRRS	0x2073
> -#define INSN_MASK_CSRRS		0x707f
> -#define INSN_MATCH_CSRRC	0x3073
> -#define INSN_MASK_CSRRC		0x707f
> -#define INSN_MATCH_CSRRWI	0x5073
> -#define INSN_MASK_CSRRWI	0x707f
> -#define INSN_MATCH_CSRRSI	0x6073
> -#define INSN_MASK_CSRRSI	0x707f
> -#define INSN_MATCH_CSRRCI	0x7073
> -#define INSN_MASK_CSRRCI	0x707f
> -
> -#define INSN_MATCH_LB		0x3
> -#define INSN_MASK_LB		0x707f
> -#define INSN_MATCH_LH		0x1003
> -#define INSN_MASK_LH		0x707f
> -#define INSN_MATCH_LW		0x2003
> -#define INSN_MASK_LW		0x707f
> -#define INSN_MATCH_LD		0x3003
> -#define INSN_MASK_LD		0x707f
> -#define INSN_MATCH_LBU		0x4003
> -#define INSN_MASK_LBU		0x707f
> -#define INSN_MATCH_LHU		0x5003
> -#define INSN_MASK_LHU		0x707f
> -#define INSN_MATCH_LWU		0x6003
> -#define INSN_MASK_LWU		0x707f
> -#define INSN_MATCH_SB		0x23
> -#define INSN_MASK_SB		0x707f
> -#define INSN_MATCH_SH		0x1023
> -#define INSN_MASK_SH		0x707f
> -#define INSN_MATCH_SW		0x2023
> -#define INSN_MASK_SW		0x707f
> -#define INSN_MATCH_SD		0x3023
> -#define INSN_MASK_SD		0x707f
> -
> -#define INSN_MATCH_C_LD		0x6000
> -#define INSN_MASK_C_LD		0xe003
> -#define INSN_MATCH_C_SD		0xe000
> -#define INSN_MASK_C_SD		0xe003
> -#define INSN_MATCH_C_LW		0x4000
> -#define INSN_MASK_C_LW		0xe003
> -#define INSN_MATCH_C_SW		0xc000
> -#define INSN_MASK_C_SW		0xe003
> -#define INSN_MATCH_C_LDSP	0x6002
> -#define INSN_MASK_C_LDSP	0xe003
> -#define INSN_MATCH_C_SDSP	0xe002
> -#define INSN_MASK_C_SDSP	0xe003
> -#define INSN_MATCH_C_LWSP	0x4002
> -#define INSN_MASK_C_LWSP	0xe003
> -#define INSN_MATCH_C_SWSP	0xc002
> -#define INSN_MASK_C_SWSP	0xe003
> -
> -#define INSN_16BIT_MASK		0x3
> -
> -#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
> -
> -#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
> -
> -#ifdef CONFIG_64BIT
> -#define LOG_REGBYTES		3
> -#else
> -#define LOG_REGBYTES		2
> -#endif
> -#define REGBYTES		(1 << LOG_REGBYTES)
> -
> -#define SH_RD			7
> -#define SH_RS1			15
> -#define SH_RS2			20
> -#define SH_RS2C			2
> -#define MASK_RX			0x1f
> -
> -#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
> -				 (RV_X(x, 10, 3) << 3) | \
> -				 (RV_X(x, 5, 1) << 6))
> -#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> -				 (RV_X(x, 5, 2) << 6))
> -#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
> -				 (RV_X(x, 12, 1) << 5) | \
> -				 (RV_X(x, 2, 2) << 6))
> -#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
> -				 (RV_X(x, 12, 1) << 5) | \
> -				 (RV_X(x, 2, 3) << 6))
> -#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
> -				 (RV_X(x, 7, 2) << 6))
> -#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
> -				 (RV_X(x, 7, 3) << 6))
> -#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
> -#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
> -#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
> -
> -#define SHIFT_RIGHT(x, y)		\
> -	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
> -
> -#define REG_MASK			\
> -	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
> -
> -#define REG_OFFSET(insn, pos)		\
> -	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
> -
> -#define REG_PTR(insn, pos, regs)	\
> -	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
> -
> -#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
> -
> -#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
> -#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
> -#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
> -#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
> -#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
> -#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
> -#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
> -#define IMM_I(insn)		((s32)(insn) >> 20)
> -#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
> -				 (s32)(((insn) >> 7) & 0x1f))
> -
>  struct insn_func {
>  	unsigned long mask;
>  	unsigned long match;

LGTM,

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

