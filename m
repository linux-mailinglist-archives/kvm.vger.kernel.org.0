Return-Path: <kvm+bounces-45849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D08AAFAA5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D93619E46BB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D9A2253B2;
	Thu,  8 May 2025 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Z9Dj1+pj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BA2224AF3
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708911; cv=none; b=WuR43ToGpREu7XXCX5wrfOCABaN59P/e4KdNnMpuqGS3XrnLzHARk932uZzX8rjwDSQnXBP1G8gGP2a1GwLg5ppBLotsCY8tRDf75xdLXw7YsIKvWMggOLS9rrgMTFL64kAj7wzfCAukzSmCgOPmcyWTNhEz2OoClWlr50r6cxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708911; c=relaxed/simple;
	bh=zmRZ81V1/VwCdN9OvMxZHCzZfeOm9H6vz3GOqtV86C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aB+cpB8bczYBL6GVXD31B5E2dcG7q9QyQVhEcIMp3TVZ1zi4w4j/jZTZWBj4dbhwTD7WCeP4tQcCbSMtJL1q9J67Pxws3QHNrFxirzpe7khYoNDKlz3waRl2UO7fw0ICAk7ujzr5+ewLryBjuhAWp1OUsklEqe8MQup3psulP7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Z9Dj1+pj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a0b308856fso633522f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746708907; x=1747313707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjP92Dgao3WheTtCnMb8PQS0fKXLA8jj1ej1e7nNvls=;
        b=Z9Dj1+pjxXPcktAknNHFee+kkRjDedUJD9R3O39FI1tzpJ74UaxRO1TzlsXmLsqiK6
         TGAdAe3GGl7KyZaskjFoJSzd7Q/HpE8GoKmuBB3fOcgwCnNLPrNX10sfFyraqZ/Iy2r3
         WcZjTnHmjPnjTiPVafiTpqMXvgihAF/Hb0Fd7NGlTfns2FJiW0aoLey9CoM7as0Htbxc
         xb2kKFfUL3XQuMpdsTlAtT3RTaw7gMfugK1tVXyTYJJD3zGlicIc0PV2DGja4MrpP9Aw
         83Z7qBKFDPJAHd59ZXVeqtL2nF+hUUz7dSswLUXgmDot1JiO+90bF8ujCtU04aKTqI2X
         MIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708907; x=1747313707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjP92Dgao3WheTtCnMb8PQS0fKXLA8jj1ej1e7nNvls=;
        b=u/TJKUffbvOz6Dkt+MfhOH05jFISCYO0x41/I+lSsucmfFKlOZBLurfuXuiDNidem0
         6M5N+jSkw1K/0f/I+GRD+C+A5sqA4ISCuT0l5p+zdPVW2hjH9w/KeRgH0htyBdH0ItSk
         V2Mr0KD8PMPjw4AYwsGygeLEDFPuDnvooptGh0xG3Hpe2YwflhF47fwWBQto/5f8065K
         oseVFMikZm7MWrvcnGeDjWPiw604biKxvTIxcACPMK53yMd1a4EJpwTQl+Lui34BEPbO
         sXDRYFRMB1TCvygJz3PJuee+o4pY4whnRuSHs8y+AuMaBeqwY98UcmTRwJ0EksCxNihD
         gtHA==
X-Forwarded-Encrypted: i=1; AJvYcCUFkdRebCd9XYG7/odefH0z6rM3RWwikRPjUucC8DPcKEiFvPeZdSKUbLu7uFmTxblqFto=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOr8xdu8xJ9QMvF0i8kSIVmxqERedOV9G/PfIMLsLxjYcSzkhx
	PAzpPN3dIZdma1OnMtjBzJh7BazrMi2cDAsWbTHvWZXdPQvfxk1/QI1Z95BfIGU=
X-Gm-Gg: ASbGncvDwR5q35H52+CKSgd8GtubM98cZ/XUWVuu1nUlvE9WUQrtOqpUtP+4Xpkk3vT
	ApM/JjjFU1AmHvyseVBIV6OjUxqKCNiimiETnigH5+I1tdG+p8pI0W5NxHbXrop+iT8PIihToeF
	zHmdEZaTnza/MrmGwAOJWqvlHDJFE23fCJJt/AR8yCjD5Lb1WlhpWLJ4P9wwSp126F95cHSV1SP
	FqPmyMJZZtHvYrGJbpm0JzMozd0PziAjWbdxU/qk6UGYiEVXISxSq99bj1qftvs2nW3w8TBAj+D
	reUZA8dPAVnrpl3l2BzUmaDU4CMcdXCT4SpbTYXs2LcVxolO180L9xTVu1U63A==
X-Google-Smtp-Source: AGHT+IFJfOj05cLpR53RyCGXvmTHyxh1LK+91krrzXyzRgEyBIjiOA3R0VM9GrB0bxdYyPUWsn7WKw==
X-Received: by 2002:a5d:648f:0:b0:3a0:77d0:ba3 with SMTP id ffacd0b85a97d-3a0ba0958a8mr2099326f8f.5.1746708907364;
        Thu, 08 May 2025 05:55:07 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:e3eb:2939:f761:f7f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0be7839bfsm1271100f8f.60.2025.05.08.05.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 05:55:07 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 3/3] riscv: Move all duplicate insn parsing macros into asm/insn.h
Date: Thu,  8 May 2025 14:52:02 +0200
Message-Id: <20250508125202.108613-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250508125202.108613-1-alexghiti@rivosinc.com>
References: <20250508125202.108613-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kernel/traps_misaligned.c and kvm/vcpu_insn.c define the same macros to
extract information from the instructions.

Let's move the definitions into asm/insn.h to avoid this duplication.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/include/asm/insn.h        | 164 ++++++++++++++++++++++++++-
 arch/riscv/kernel/traps_misaligned.c | 135 ----------------------
 arch/riscv/kvm/vcpu_insn.c           | 126 --------------------
 3 files changed, 159 insertions(+), 266 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index ac3e606feca2..7c65fc8baeed 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -286,11 +286,165 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 	       (code & RVC_INSN_J_RS1_MASK) != 0;
 }
 
-#define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
-#define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
-#define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
-#define RV_X(X, s, n) RV_X_mask(X, s, ((1 << (n)) - 1))
-#define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
+#define INSN_MATCH_LB		0x3
+#define INSN_MASK_LB		0x707f
+#define INSN_MATCH_LH		0x1003
+#define INSN_MASK_LH		0x707f
+#define INSN_MATCH_LW		0x2003
+#define INSN_MASK_LW		0x707f
+#define INSN_MATCH_LD		0x3003
+#define INSN_MASK_LD		0x707f
+#define INSN_MATCH_LBU		0x4003
+#define INSN_MASK_LBU		0x707f
+#define INSN_MATCH_LHU		0x5003
+#define INSN_MASK_LHU		0x707f
+#define INSN_MATCH_LWU		0x6003
+#define INSN_MASK_LWU		0x707f
+#define INSN_MATCH_SB		0x23
+#define INSN_MASK_SB		0x707f
+#define INSN_MATCH_SH		0x1023
+#define INSN_MASK_SH		0x707f
+#define INSN_MATCH_SW		0x2023
+#define INSN_MASK_SW		0x707f
+#define INSN_MATCH_SD		0x3023
+#define INSN_MASK_SD		0x707f
+
+#define INSN_MATCH_C_LD		0x6000
+#define INSN_MASK_C_LD		0xe003
+#define INSN_MATCH_C_SD		0xe000
+#define INSN_MASK_C_SD		0xe003
+#define INSN_MATCH_C_LW		0x4000
+#define INSN_MASK_C_LW		0xe003
+#define INSN_MATCH_C_SW		0xc000
+#define INSN_MASK_C_SW		0xe003
+#define INSN_MATCH_C_LDSP	0x6002
+#define INSN_MASK_C_LDSP	0xe003
+#define INSN_MATCH_C_SDSP	0xe002
+#define INSN_MASK_C_SDSP	0xe003
+#define INSN_MATCH_C_LWSP	0x4002
+#define INSN_MASK_C_LWSP	0xe003
+#define INSN_MATCH_C_SWSP	0xc002
+#define INSN_MASK_C_SWSP	0xe003
+
+#define INSN_OPCODE_MASK	0x007c
+#define INSN_OPCODE_SHIFT	2
+#define INSN_OPCODE_SYSTEM	28
+
+#define INSN_MASK_WFI		0xffffffff
+#define INSN_MATCH_WFI		0x10500073
+
+#define INSN_MASK_WRS		0xffffffff
+#define INSN_MATCH_WRS		0x00d00073
+
+#define INSN_MATCH_CSRRW	0x1073
+#define INSN_MASK_CSRRW		0x707f
+#define INSN_MATCH_CSRRS	0x2073
+#define INSN_MASK_CSRRS		0x707f
+#define INSN_MATCH_CSRRC	0x3073
+#define INSN_MASK_CSRRC		0x707f
+#define INSN_MATCH_CSRRWI	0x5073
+#define INSN_MASK_CSRRWI	0x707f
+#define INSN_MATCH_CSRRSI	0x6073
+#define INSN_MASK_CSRRSI	0x707f
+#define INSN_MATCH_CSRRCI	0x7073
+#define INSN_MASK_CSRRCI	0x707f
+
+#define INSN_MATCH_FLW		0x2007
+#define INSN_MASK_FLW		0x707f
+#define INSN_MATCH_FLD		0x3007
+#define INSN_MASK_FLD		0x707f
+#define INSN_MATCH_FLQ		0x4007
+#define INSN_MASK_FLQ		0x707f
+#define INSN_MATCH_FSW		0x2027
+#define INSN_MASK_FSW		0x707f
+#define INSN_MATCH_FSD		0x3027
+#define INSN_MASK_FSD		0x707f
+#define INSN_MATCH_FSQ		0x4027
+#define INSN_MASK_FSQ		0x707f
+
+#define INSN_MATCH_C_FLD	0x2000
+#define INSN_MASK_C_FLD		0xe003
+#define INSN_MATCH_C_FLW	0x6000
+#define INSN_MASK_C_FLW		0xe003
+#define INSN_MATCH_C_FSD	0xa000
+#define INSN_MASK_C_FSD		0xe003
+#define INSN_MATCH_C_FSW	0xe000
+#define INSN_MASK_C_FSW		0xe003
+#define INSN_MATCH_C_FLDSP	0x2002
+#define INSN_MASK_C_FLDSP	0xe003
+#define INSN_MATCH_C_FSDSP	0xa002
+#define INSN_MASK_C_FSDSP	0xe003
+#define INSN_MATCH_C_FLWSP	0x6002
+#define INSN_MASK_C_FLWSP	0xe003
+#define INSN_MATCH_C_FSWSP	0xe002
+#define INSN_MASK_C_FSWSP	0xe003
+
+#define INSN_16BIT_MASK		0x3
+#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
+#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
+
+#define SHIFT_RIGHT(x, y)		\
+	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
+
+#define REG_MASK			\
+	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
+
+#define REG_OFFSET(insn, pos)		\
+	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
+
+#define REG_PTR(insn, pos, regs)	\
+	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
+
+#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
+#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
+#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
+#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
+#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
+#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
+#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
+#define IMM_I(insn)		((s32)(insn) >> 20)
+#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
+				 (s32)(((insn) >> 7) & 0x1f))
+
+#define SH_RD			7
+#define SH_RS1			15
+#define SH_RS2			20
+#define SH_RS2C			2
+#define MASK_RX			0x1f
+
+#if defined(CONFIG_64BIT)
+#define LOG_REGBYTES		3
+#else
+#define LOG_REGBYTES		2
+#endif
+
+#define MASK_FUNCT3		0x7000
+
+#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
+
+#define RV_IMM_SIGN(x)		(-(((x) >> 31) & 1))
+#define RVC_IMM_SIGN(x)		(-(((x) >> 12) & 1))
+#define RV_X_mask(X, s, mask)	(((X) >> (s)) & (mask))
+#define RV_X(X, s, n)		RV_X_mask(X, s, ((1 << (n)) - 1))
+#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
+				 (RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 1) << 6))
+#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 2) << 6))
+#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 2) << 6))
+#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 3) << 6))
+#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
+				 (RV_X(x, 7, 2) << 6))
+#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 7, 3) << 6))
+#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
+#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
+#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
+#define RVC_X(X, s, mask)	RV_X_mask(X, s, mask)
 
 #define RV_EXTRACT_RS1_REG(x) \
 	({typeof(x) x_ = (x); \
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 3d0e5eadfac3..0151f670cd46 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -19,141 +19,6 @@
 #include <asm/vector.h>
 #include <asm/insn.h>
 
-#define INSN_MATCH_LB			0x3
-#define INSN_MASK_LB			0x707f
-#define INSN_MATCH_LH			0x1003
-#define INSN_MASK_LH			0x707f
-#define INSN_MATCH_LW			0x2003
-#define INSN_MASK_LW			0x707f
-#define INSN_MATCH_LD			0x3003
-#define INSN_MASK_LD			0x707f
-#define INSN_MATCH_LBU			0x4003
-#define INSN_MASK_LBU			0x707f
-#define INSN_MATCH_LHU			0x5003
-#define INSN_MASK_LHU			0x707f
-#define INSN_MATCH_LWU			0x6003
-#define INSN_MASK_LWU			0x707f
-#define INSN_MATCH_SB			0x23
-#define INSN_MASK_SB			0x707f
-#define INSN_MATCH_SH			0x1023
-#define INSN_MASK_SH			0x707f
-#define INSN_MATCH_SW			0x2023
-#define INSN_MASK_SW			0x707f
-#define INSN_MATCH_SD			0x3023
-#define INSN_MASK_SD			0x707f
-
-#define INSN_MATCH_FLW			0x2007
-#define INSN_MASK_FLW			0x707f
-#define INSN_MATCH_FLD			0x3007
-#define INSN_MASK_FLD			0x707f
-#define INSN_MATCH_FLQ			0x4007
-#define INSN_MASK_FLQ			0x707f
-#define INSN_MATCH_FSW			0x2027
-#define INSN_MASK_FSW			0x707f
-#define INSN_MATCH_FSD			0x3027
-#define INSN_MASK_FSD			0x707f
-#define INSN_MATCH_FSQ			0x4027
-#define INSN_MASK_FSQ			0x707f
-
-#define INSN_MATCH_C_LD			0x6000
-#define INSN_MASK_C_LD			0xe003
-#define INSN_MATCH_C_SD			0xe000
-#define INSN_MASK_C_SD			0xe003
-#define INSN_MATCH_C_LW			0x4000
-#define INSN_MASK_C_LW			0xe003
-#define INSN_MATCH_C_SW			0xc000
-#define INSN_MASK_C_SW			0xe003
-#define INSN_MATCH_C_LDSP		0x6002
-#define INSN_MASK_C_LDSP		0xe003
-#define INSN_MATCH_C_SDSP		0xe002
-#define INSN_MASK_C_SDSP		0xe003
-#define INSN_MATCH_C_LWSP		0x4002
-#define INSN_MASK_C_LWSP		0xe003
-#define INSN_MATCH_C_SWSP		0xc002
-#define INSN_MASK_C_SWSP		0xe003
-
-#define INSN_MATCH_C_FLD		0x2000
-#define INSN_MASK_C_FLD			0xe003
-#define INSN_MATCH_C_FLW		0x6000
-#define INSN_MASK_C_FLW			0xe003
-#define INSN_MATCH_C_FSD		0xa000
-#define INSN_MASK_C_FSD			0xe003
-#define INSN_MATCH_C_FSW		0xe000
-#define INSN_MASK_C_FSW			0xe003
-#define INSN_MATCH_C_FLDSP		0x2002
-#define INSN_MASK_C_FLDSP		0xe003
-#define INSN_MATCH_C_FSDSP		0xa002
-#define INSN_MASK_C_FSDSP		0xe003
-#define INSN_MATCH_C_FLWSP		0x6002
-#define INSN_MASK_C_FLWSP		0xe003
-#define INSN_MATCH_C_FSWSP		0xe002
-#define INSN_MASK_C_FSWSP		0xe003
-
-#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
-
-#if defined(CONFIG_64BIT)
-#define LOG_REGBYTES			3
-#define XLEN				64
-#else
-#define LOG_REGBYTES			2
-#define XLEN				32
-#endif
-#define REGBYTES			(1 << LOG_REGBYTES)
-#define XLEN_MINUS_16			((XLEN) - 16)
-
-#define SH_RD				7
-#define SH_RS1				15
-#define SH_RS2				20
-#define SH_RS2C				2
-
-#define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
-					 (RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 3) << 2) | \
-					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 2) << 3) | \
-					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 4) << 2) | \
-					 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)			(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)			RV_X(insn, SH_RS2C, 5)
-
-#define SHIFT_RIGHT(x, y)		\
-	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
-
-#define REG_MASK			\
-	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
-
-#define REG_OFFSET(insn, pos)		\
-	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
-
-#define REG_PTR(insn, pos, regs)	\
-	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
-
-#define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
-#define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
-#define GET_RS2S(insn, regs)		(*REG_PTR(RVC_RS2S(insn), 0, regs))
-#define GET_RS2C(insn, regs)		(*REG_PTR(insn, SH_RS2C, regs))
-#define GET_SP(regs)			(*REG_PTR(2, 0, regs))
-#define SET_RD(insn, regs, val)		(*REG_PTR(insn, SH_RD, regs) = (val))
-#define IMM_I(insn)			((s32)(insn) >> 20)
-#define IMM_S(insn)			(((s32)(insn) >> 25 << 5) | \
-					 (s32)(((insn) >> 7) & 0x1f))
-#define MASK_FUNCT3			0x7000
-
-#define GET_PRECISION(insn) (((insn) >> 25) & 3)
-#define GET_RM(insn) (((insn) >> 12) & 7)
-#define PRECISION_S 0
-#define PRECISION_D 1
-
 #ifdef CONFIG_FPU
 
 #define FP_GET_RD(insn)		(insn >> 7 & 0x1F)
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 62cb2ab4b636..de1f96ea6225 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -10,132 +10,6 @@
 #include <asm/cpufeature.h>
 #include <asm/insn.h>
 
-#define INSN_OPCODE_MASK	0x007c
-#define INSN_OPCODE_SHIFT	2
-#define INSN_OPCODE_SYSTEM	28
-
-#define INSN_MASK_WFI		0xffffffff
-#define INSN_MATCH_WFI		0x10500073
-
-#define INSN_MASK_WRS		0xffffffff
-#define INSN_MATCH_WRS		0x00d00073
-
-#define INSN_MATCH_CSRRW	0x1073
-#define INSN_MASK_CSRRW		0x707f
-#define INSN_MATCH_CSRRS	0x2073
-#define INSN_MASK_CSRRS		0x707f
-#define INSN_MATCH_CSRRC	0x3073
-#define INSN_MASK_CSRRC		0x707f
-#define INSN_MATCH_CSRRWI	0x5073
-#define INSN_MASK_CSRRWI	0x707f
-#define INSN_MATCH_CSRRSI	0x6073
-#define INSN_MASK_CSRRSI	0x707f
-#define INSN_MATCH_CSRRCI	0x7073
-#define INSN_MASK_CSRRCI	0x707f
-
-#define INSN_MATCH_LB		0x3
-#define INSN_MASK_LB		0x707f
-#define INSN_MATCH_LH		0x1003
-#define INSN_MASK_LH		0x707f
-#define INSN_MATCH_LW		0x2003
-#define INSN_MASK_LW		0x707f
-#define INSN_MATCH_LD		0x3003
-#define INSN_MASK_LD		0x707f
-#define INSN_MATCH_LBU		0x4003
-#define INSN_MASK_LBU		0x707f
-#define INSN_MATCH_LHU		0x5003
-#define INSN_MASK_LHU		0x707f
-#define INSN_MATCH_LWU		0x6003
-#define INSN_MASK_LWU		0x707f
-#define INSN_MATCH_SB		0x23
-#define INSN_MASK_SB		0x707f
-#define INSN_MATCH_SH		0x1023
-#define INSN_MASK_SH		0x707f
-#define INSN_MATCH_SW		0x2023
-#define INSN_MASK_SW		0x707f
-#define INSN_MATCH_SD		0x3023
-#define INSN_MASK_SD		0x707f
-
-#define INSN_MATCH_C_LD		0x6000
-#define INSN_MASK_C_LD		0xe003
-#define INSN_MATCH_C_SD		0xe000
-#define INSN_MASK_C_SD		0xe003
-#define INSN_MATCH_C_LW		0x4000
-#define INSN_MASK_C_LW		0xe003
-#define INSN_MATCH_C_SW		0xc000
-#define INSN_MASK_C_SW		0xe003
-#define INSN_MATCH_C_LDSP	0x6002
-#define INSN_MASK_C_LDSP	0xe003
-#define INSN_MATCH_C_SDSP	0xe002
-#define INSN_MASK_C_SDSP	0xe003
-#define INSN_MATCH_C_LWSP	0x4002
-#define INSN_MASK_C_LWSP	0xe003
-#define INSN_MATCH_C_SWSP	0xc002
-#define INSN_MASK_C_SWSP	0xe003
-
-#define INSN_16BIT_MASK		0x3
-
-#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
-
-#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
-
-#ifdef CONFIG_64BIT
-#define LOG_REGBYTES		3
-#else
-#define LOG_REGBYTES		2
-#endif
-#define REGBYTES		(1 << LOG_REGBYTES)
-
-#define SH_RD			7
-#define SH_RS1			15
-#define SH_RS2			20
-#define SH_RS2C			2
-#define MASK_RX			0x1f
-
-#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
-				 (RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
-				 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
-
-#define SHIFT_RIGHT(x, y)		\
-	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
-
-#define REG_MASK			\
-	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
-
-#define REG_OFFSET(insn, pos)		\
-	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
-
-#define REG_PTR(insn, pos, regs)	\
-	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
-
-#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
-
-#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
-#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
-#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
-#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
-#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
-#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
-#define IMM_I(insn)		((s32)(insn) >> 20)
-#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
-				 (s32)(((insn) >> 7) & 0x1f))
-
 struct insn_func {
 	unsigned long mask;
 	unsigned long match;
-- 
2.39.2


