Return-Path: <kvm+bounces-44116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5E4A9AB05
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B5437B6389
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E704722F77D;
	Thu, 24 Apr 2025 10:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kwsYdY2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CBA22577C
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490933; cv=none; b=n6YjN90eP8Cn3kL7aMphO4xJIASK0LSbDkaf9cgReK1mxYl2EGYrYb6f7ZOhW6R8bDasdHXVCg7rXkAR+MJP7PxlxwK9/z5tKlcFiYp31vToYFuis0Y2Op3EPF3V1l14t7sgUNUcTdT31LQxpJH1SeSZUVBf65dllH0RFrAgzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490933; c=relaxed/simple;
	bh=g2uXMrnesmCHRKTByNsCRyxmCxolZdkyHekMxHRImIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrJ4KFO4mcMc6dNzZZmt8+dRdHeh2UcHlfh/AgodJUv0reCkGk13GiEreowTBhrxW+wQ1C/TXW/6oAE278+gTtiM84oQ9pM5tBlNUp0quSo/5CfxrcqQEono7cYXGrvjVPR3lJ1hEi+9UE62Y9fOjM+Lniv6tnqor66L33ackFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kwsYdY2a; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso7702555e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 03:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745490928; x=1746095728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8F14wHisZFmYUBGpNt7mOre3zxnZ1S4nyKvc0jYLFAs=;
        b=kwsYdY2aEIAD2VWJhjr25iXGzjzh0gqZ6dzLC6iAo5ljS/7JYM9umsSWQVcO9nFOLw
         o1pidWeX2FThOLhBXByG3x7ua0/Iuy7wpxCnwFLsI8Zy6EI2+2edBL6t33J7lrZxGCpz
         YFZp1eniBg85q1VnMFCyNjFYQv9uUSJvKTrX/HGJFFVi4m4EndgRTWRRxI5pYAns4Mcq
         fkRyyIU+febZBPo8d/qM3uxbYA50KOk/1ZsielVOLembZr+IqYl+DJI172GiQ55tO4H9
         y5KTC7tFibkGYLGEzpxPXoYjzYFuaU/wRRfb2YrasXii5h4mBQN4aDxOymuHjgsPdYBq
         g48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745490928; x=1746095728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8F14wHisZFmYUBGpNt7mOre3zxnZ1S4nyKvc0jYLFAs=;
        b=RdG05T9TPV3xe8IuCvTAz3yIFcBWk7TjhrriDV9/PTIBKptXj4Qtt/EAffnhfJwWEn
         9FyDEX88DRS58dqlFO9qHFLY9+WJgXMAePM7JAnO00hRTG9YgtrwxQW1G1YD2v2qbnKX
         W/0Hpb40y7FswXBNU6c//3g1Mp2FfJDFjofsdyeTR0f3JrH972s5JtWexvEPPm0TR1of
         Y2PeuDoUaRPmtQfEG7hAwg7bz77O5s3o4WTd3uP3NPYdCb8PGTzrfdED3z36cwvA43ht
         zJSUNNv4Dyz7UC0p5Pi/O0Mlfzc4olI64IgumbCFnLORSEaVcaJam//7l7eSotiEOfz9
         TWIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjB64MvFYQe0mOxRsM/TjfHC4mtTkAbhLVXzWGRcOgxOpBThTMGZ1ZG6hjDbiUTvBvr3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOIpE688Sv1j09EFbe83N+A7PYlWa+iGE7ILF+fkUR2nCPG9Xv
	VBupSs7ceDO/Hm0qlehmE1wrTMO2NZvwYDN4A5e6NYcbDnAKwIalOQ9PTGuD2GI=
X-Gm-Gg: ASbGnctBbGWF+qX+A0hn8VIngg5QTMoZIekoP26VgG1aQ/HKFReKX6Qwu3oHOODXTsT
	FtHZcjIMezDS8Bk+Stx0FruJjcwGE9XFxwlgwE8UOhNo8d38f9J/Qt3WRYnxE5CBw0zKZk7Jt2X
	Ylu4xalMnN3oPso8FhfNs6DTAJ3o9+RHNxIPK52V9RU85ilwQ186KJi1A+9NZifFvguPjhqLT6Q
	cIQXxA7cPj8rphKrxEEkF3/jht4UBe5GFnj/hAwPOpngQQO/qMI54a5Pm/hAFMl+0D+nB9nOCNc
	FtfgN0VNICnaHWGIRhiZNsKCeOBS
X-Google-Smtp-Source: AGHT+IGoQMYnbzGX//fc6ZE1xJ+4fax/Zt5gY/4Qwi4Zg11qB7T5+TDbupkwgT7lpU1WNNtKSDFW5Q==
X-Received: by 2002:a05:600c:83ca:b0:43c:e305:6d50 with SMTP id 5b1f17b1804b1-4409bd76dedmr20044925e9.24.1745490927855;
        Thu, 24 Apr 2025 03:35:27 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2dfc2fsm15232015e9.33.2025.04.24.03.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 03:35:27 -0700 (PDT)
Date: Thu, 24 Apr 2025 12:35:26 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 3/3] riscv: Move all duplicate insn parsing macros into
 asm/insn.h
Message-ID: <20250424-097fbd2d0fa5f8c14adc5054@orel>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-4-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422082545.450453-4-alexghiti@rivosinc.com>

On Tue, Apr 22, 2025 at 10:25:45AM +0200, Alexandre Ghiti wrote:
> kernel/traps_misaligned.c and kvm/vcpu_insn.c define the same macros to
> extract information from the instructions.
> 
> Let's move the definitions into asm/insn.h to avoid this duplication.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h        | 164 +++++++++++++++++++++++++++
>  arch/riscv/kernel/elf_kexec.c        |   1 +
>  arch/riscv/kernel/traps_misaligned.c | 136 +---------------------
>  arch/riscv/kvm/vcpu_insn.c           | 127 +--------------------
>  4 files changed, 167 insertions(+), 261 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 4063ca35be9b..35f316cdd699 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -286,9 +286,173 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  	       (code & RVC_INSN_J_RS1_MASK) != 0;
>  }
>  
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
> +#define INSN_MATCH_FLW			0x2007
> +#define INSN_MASK_FLW			0x707f
> +#define INSN_MATCH_FLD			0x3007
> +#define INSN_MASK_FLD			0x707f
> +#define INSN_MATCH_FLQ			0x4007
> +#define INSN_MASK_FLQ			0x707f
> +#define INSN_MATCH_FSW			0x2027
> +#define INSN_MASK_FSW			0x707f
> +#define INSN_MATCH_FSD			0x3027
> +#define INSN_MASK_FSD			0x707f
> +#define INSN_MATCH_FSQ			0x4027
> +#define INSN_MASK_FSQ			0x707f
> +
> +#define INSN_MATCH_C_FLD		0x2000
> +#define INSN_MASK_C_FLD			0xe003
> +#define INSN_MATCH_C_FLW		0x6000
> +#define INSN_MASK_C_FLW			0xe003
> +#define INSN_MATCH_C_FSD		0xa000
> +#define INSN_MASK_C_FSD			0xe003
> +#define INSN_MATCH_C_FSW		0xe000
> +#define INSN_MASK_C_FSW			0xe003
> +#define INSN_MATCH_C_FLDSP		0x2002
> +#define INSN_MASK_C_FLDSP		0xe003
> +#define INSN_MATCH_C_FSDSP		0xa002
> +#define INSN_MASK_C_FSDSP		0xe003
> +#define INSN_MATCH_C_FLWSP		0x6002
> +#define INSN_MASK_C_FLWSP		0xe003
> +#define INSN_MATCH_C_FSWSP		0xe002
> +#define INSN_MASK_C_FSWSP		0xe003

nit: no need to tab the last two groups out an extra tab. Check alignment
with the GET_* macro group below too.

> +
> +#define INSN_16BIT_MASK		0x3
> +
> +#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
> +
> +#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)

nit: can remove the extra blank lines between these insn-len macros

> +
> +#define SHIFT_RIGHT(x, y)               \

     spaces instead of tabs here ^^

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
> +#define GET_PRECISION(insn) (((insn) >> 25) & 3)
> +#define GET_RM(insn) (((insn) >> 12) & 7)
> +#define PRECISION_S 0
> +#define PRECISION_D 1
> +
> +#define SH_RD			7
> +#define SH_RS1			15
> +#define SH_RS2			20
> +#define SH_RS2C			2
> +#define MASK_RX			0x1f
> +
> +#if defined(CONFIG_64BIT)
> +#define LOG_REGBYTES			3
> +#define XLEN				64
> +#else
> +#define LOG_REGBYTES			2
> +#define XLEN				32
> +#endif
> +#define REGBYTES			(1 << LOG_REGBYTES)
> +#define XLEN_MINUS_16			((XLEN) - 16)
> +
> +#define MASK_FUNCT3			0x7000
> +
> +#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
> +
>  #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
>  #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
>  #define RV_X(X, s, n) (((X) >> (s)) & ((1 << (n)) - 1))
> +#define RVC_LW_IMM(x)	((RV_X(x, 6, 1) << 2) | \
> +			 (RV_X(x, 10, 3) << 3) | \
> +			 (RV_X(x, 5, 1) << 6))
> +#define RVC_LD_IMM(x)	((RV_X(x, 10, 3) << 3) | \
> +			 (RV_X(x, 5, 2) << 6))
> +#define RVC_LWSP_IMM(x)	((RV_X(x, 4, 3) << 2) | \
> +			 (RV_X(x, 12, 1) << 5) | \
> +			 (RV_X(x, 2, 2) << 6))
> +#define RVC_LDSP_IMM(x)	((RV_X(x, 5, 2) << 3) | \
> +			 (RV_X(x, 12, 1) << 5) | \
> +			 (RV_X(x, 2, 3) << 6))
> +#define RVC_SWSP_IMM(x)	((RV_X(x, 9, 4) << 2) | \
> +			 (RV_X(x, 7, 2) << 6))
> +#define RVC_SDSP_IMM(x)	((RV_X(x, 10, 3) << 3) | \
> +			 (RV_X(x, 7, 3) << 6))
> +#define RVC_RS1S(insn)	(8 + RV_X(insn, SH_RD, 3))
> +#define RVC_RS2S(insn)	(8 + RV_X(insn, SH_RS2C, 3))
> +#define RVC_RS2(insn)	RV_X(insn, SH_RS2C, 5)

nit: should tab the above group out more

>  #define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
>  #define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
>  
> diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
> index 15e6a8f3d50b..1c3b76a67356 100644
> --- a/arch/riscv/kernel/elf_kexec.c
> +++ b/arch/riscv/kernel/elf_kexec.c
> @@ -21,6 +21,7 @@
>  #include <linux/memblock.h>
>  #include <linux/vmalloc.h>
>  #include <asm/setup.h>
> +#include <asm/insn.h>
>  
>  int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  {
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index fb2599d62752..0151f670cd46 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -17,141 +17,7 @@
>  #include <asm/hwprobe.h>
>  #include <asm/cpufeature.h>
>  #include <asm/vector.h>
> -
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
> +#include <asm/insn.h>
>  
>  #ifdef CONFIG_FPU
>  
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index ba4813673f95..de1f96ea6225 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -8,132 +8,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/cpufeature.h>
> -
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
> +#include <asm/insn.h>
>  
>  struct insn_func {
>  	unsigned long mask;
> -- 
> 2.39.2
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

