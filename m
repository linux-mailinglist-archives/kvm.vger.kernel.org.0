Return-Path: <kvm+bounces-43795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BED5AA96218
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CE0B1892AF0
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4519E292908;
	Tue, 22 Apr 2025 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IynnEWzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE1428FFF7
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 08:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310502; cv=none; b=B4nmX+esAxGgmEPqpE5YGfdkuZUFrmPWAKxaOQukri5VZqjL5pI+FVI1joHTkSFrYYFMlyljC+COaRB6Gz9LwVGneKrjpc6hQXQ43codi7//BYhB0xQyQPjZBOefKX7PZynbH4J4TNPORCUosV9CH8orNVAI+029HFJh35TO6W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310502; c=relaxed/simple;
	bh=01rcpKrzs+odJLFnHWNWCdarjNy5/MHgnnaxXm8Sj/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aZNvMIm3shgyskI3tDgc/8QCH4VjsANlGFjgL8XuwhPdK4a+oekIzVWaNU2qiURID0EKbxYkNIhDvQtKKLvUSofigAR521jg5RxmYgVl5BDBOectHxr5G0sAujaR3DUgq32UH7eMbDwA0/VhCwE+cTsE6ys6R/iDkcaeDEar+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IynnEWzL; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39ee623fe64so4175623f8f.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 01:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745310499; x=1745915299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/CWCUS8RZp7wYAyaOgQhTSp6Kw3lGqKkpYYUX0Fosc=;
        b=IynnEWzLKpXYz56sUMDKpJkUlubkN/u7/VarsOMccfgUck0SaP3H/S37jXSthXcrj7
         4ouMS47tfBxwXNQwnyRra2sVTGRsn1MTiaNjz0VC65XOYNrhnjWp0SSaaJUPe059osCS
         2fggBuhK2Oh9vNEiQcDOpbcTE/Z/8gCDk3qnGrOTF1cc2caB7W8bwvS5WTxRyxVE+LLa
         56LgDMSJmEvsaeR2f15iUve5Wn+cH7TMs+NmakSxwzKC4IQXmVl1q/2rhUpLq+VFvrw5
         zkW9ixLdX8GoSkLMRTTlDDHKCwAb6gDzWC6g7BY0dqtR9l8yCE7oRcv12KaSLm33R+YY
         Y1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745310499; x=1745915299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/CWCUS8RZp7wYAyaOgQhTSp6Kw3lGqKkpYYUX0Fosc=;
        b=KF4/L8sexwdNIXeu2jaZpKWw4tQcM3uurZqh2vjdnUJ42fpNUXm+0PZQuzMlsRm+Vs
         Tl60lp7an9HsIqTyMblWmbWu1OANxvp9B6a8wfsZN0eh4E+JRbsE0QcqZ3ozGnh4QCK/
         BLog12U83K7egCuzi96A/yapW4wQ+UqXWPA0ZxdgshrRrbm7fFuTmQ5SZnkZmK0jyDi3
         jcmpSwNrw0J/+zoKkfJLy7G5mj7ZO74vB8EZbEiIpbgMr8UFCrrY+Uf4aUmQ1/CDpmtR
         jUG0jJH6vGTLb1AbGVfNQNHQnUQ54edTIFpZHtlHfQxgcVIC6G31F4t9f3wTSgRyMAXl
         mlNA==
X-Forwarded-Encrypted: i=1; AJvYcCUkfOdWRhnON1Q2CHGndS7eG/e8DfjZCprPYyw92Ddqcp/x1PzDGPzgijJwCfIv71UnuFk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0MgBMZX0D/jKFej8pPIa0uDqHY955L7CPOidRa9XbdGaapL75
	5WmrCYPhqGAcp5M4kFTe7Qqz/SV3b6DcCZC82qH9RztqjwUNWamOqiGgPC9wAvR0XchCLj34zk2
	5
X-Gm-Gg: ASbGncuWwNfY17FZeHTpHh23A0pEl85Yvi1aCrzsbQhgEWQ+MJ/0wFvWBjIONOmIeko
	igsQIvdoVAzm9rTNeN+icUnvjJn9gu4HLFnCZ63/Aqp3mS9aLAq+rZZMqM6AYaN3cehkb8jgG78
	mnLdLn36d675v8gHwY5yKdRIjb+qejA191kcTrhMXCR+0nG2NwyTWKqMMIeinL8zWW/ftLgHHia
	36judXpIHf5JhGhqfGB/D88sH4oHZayACA/b5MbwxxOikIcL79gDI2l+X08doV45mNHLHDLhz0X
	KyO5QkjGjmB47RlPz7SViAiSC65pNk2Kf8hrIzJI6uEvz37eXc6bRamvecAK
X-Google-Smtp-Source: AGHT+IFSWVo9NWDw8V+FnM5OEUrKvEr9dTbKJocHVSXXrmftZ+qP74WovMP3SHSeGzg2pLC8DuboWQ==
X-Received: by 2002:a05:6000:2907:b0:38d:e304:7470 with SMTP id ffacd0b85a97d-39efba5aa2cmr12153663f8f.25.1745310498759;
        Tue, 22 Apr 2025 01:28:18 -0700 (PDT)
Received: from localhost.localdomain ([2001:861:3382:ef90:9fbe:20e3:2fc3:8d19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4207afsm14573930f8f.12.2025.04.22.01.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 01:28:18 -0700 (PDT)
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
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 2/3] riscv: Strengthen duplicate and inconsistent definition of RV_X()
Date: Tue, 22 Apr 2025 10:25:44 +0200
Message-Id: <20250422082545.450453-3-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250422082545.450453-1-alexghiti@rivosinc.com>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RV_X() macro is defined in two different ways which is error prone.

So harmonize its first definition and add another macro RV_X_mask() for
the second one.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/include/asm/insn.h        | 39 ++++++++++++++--------------
 arch/riscv/kernel/elf_kexec.c        |  1 -
 arch/riscv/kernel/traps_misaligned.c |  1 -
 arch/riscv/kvm/vcpu_insn.c           |  1 -
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 2a589a58b291..4063ca35be9b 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -288,43 +288,44 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 
 #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
 #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
-#define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
-#define RVC_X(X, s, mask) RV_X(X, s, mask)
+#define RV_X(X, s, n) (((X) >> (s)) & ((1 << (n)) - 1))
+#define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
+#define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
 
 #define RV_EXTRACT_RS1_REG(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
+	(RV_X_mask(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
 
 #define RV_EXTRACT_RD_REG(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
+	(RV_X_mask(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
 
 #define RV_EXTRACT_UTYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RV_U_IMM_31_12_OPOFF, RV_U_IMM_31_12_MASK)); })
+	(RV_X_mask(x_, RV_U_IMM_31_12_OPOFF, RV_U_IMM_31_12_MASK)); })
 
 #define RV_EXTRACT_JTYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RV_J_IMM_10_1_OPOFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OFF) | \
-	(RV_X(x_, RV_J_IMM_11_OPOFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OFF) | \
-	(RV_X(x_, RV_J_IMM_19_12_OPOFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OFF) | \
+	(RV_X_mask(x_, RV_J_IMM_10_1_OPOFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OFF) | \
+	(RV_X_mask(x_, RV_J_IMM_11_OPOFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OFF) | \
+	(RV_X_mask(x_, RV_J_IMM_19_12_OPOFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OFF) | \
 	(RV_IMM_SIGN(x_) << RV_J_IMM_SIGN_OFF); })
 
 #define RV_EXTRACT_ITYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RV_I_IMM_11_0_OPOFF, RV_I_IMM_11_0_MASK)) | \
+	(RV_X_mask(x_, RV_I_IMM_11_0_OPOFF, RV_I_IMM_11_0_MASK)) | \
 	(RV_IMM_SIGN(x_) << RV_I_IMM_SIGN_OFF); })
 
 #define RV_EXTRACT_BTYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RV_B_IMM_4_1_OPOFF, RV_B_IMM_4_1_MASK) << RV_B_IMM_4_1_OFF) | \
-	(RV_X(x_, RV_B_IMM_10_5_OPOFF, RV_B_IMM_10_5_MASK) << RV_B_IMM_10_5_OFF) | \
-	(RV_X(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF) | \
+	(RV_X_mask(x_, RV_B_IMM_4_1_OPOFF, RV_B_IMM_4_1_MASK) << RV_B_IMM_4_1_OFF) | \
+	(RV_X_mask(x_, RV_B_IMM_10_5_OPOFF, RV_B_IMM_10_5_MASK) << RV_B_IMM_10_5_OFF) | \
+	(RV_X_mask(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF) | \
 	(RV_IMM_SIGN(x_) << RV_B_IMM_SIGN_OFF); })
 
 #define RVC_EXTRACT_C2_RS1_REG(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
+	(RV_X_mask(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
 
 #define RVC_EXTRACT_JTYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
@@ -346,10 +347,10 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
 
 #define RVG_EXTRACT_SYSTEM_CSR(x) \
-	({typeof(x) x_ = (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
+	({typeof(x) x_ = (x); RV_X_mask(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
 
 #define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
-	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
+	({typeof(x) x_ = (x); RV_X_mask(x_, RVFDQ_FL_FS_WIDTH_OFF, \
 				   RVFDQ_FL_FS_WIDTH_MASK); })
 
 #define RVV_EXTRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
@@ -375,10 +376,10 @@ static inline void riscv_insn_insert_jtype_imm(u32 *insn, s32 imm)
 {
 	/* drop the old IMMs, all jal IMM bits sit at 31:12 */
 	*insn &= ~GENMASK(31, 12);
-	*insn |= (RV_X(imm, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) |
-		 (RV_X(imm, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) |
-		 (RV_X(imm, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) |
-		 (RV_X(imm, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF);
+	*insn |= (RV_X_mask(imm, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) |
+		 (RV_X_mask(imm, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) |
+		 (RV_X_mask(imm, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) |
+		 (RV_X_mask(imm, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF);
 }
 
 /*
diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index e783a72d051f..15e6a8f3d50b 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -336,7 +336,6 @@ static void *elf_kexec_load(struct kimage *image, char *kernel_buf,
 	return ret ? ERR_PTR(ret) : NULL;
 }
 
-#define RV_X(x, s, n)  (((x) >> (s)) & ((1 << (n)) - 1))
 #define RISCV_IMM_BITS 12
 #define RISCV_IMM_REACH (1LL << RISCV_IMM_BITS)
 #define RISCV_CONST_HIGH_PART(x) \
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 4354c87c0376..fb2599d62752 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -105,7 +105,6 @@
 #define SH_RS2				20
 #define SH_RS2C				2
 
-#define RV_X(x, s, n)			(((x) >> (s)) & ((1 << (n)) - 1))
 #define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
 					 (RV_X(x, 10, 3) << 3) | \
 					 (RV_X(x, 5, 1) << 6))
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..ba4813673f95 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -91,7 +91,6 @@
 #define SH_RS2C			2
 #define MASK_RX			0x1f
 
-#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
 #define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
 				 (RV_X(x, 10, 3) << 3) | \
 				 (RV_X(x, 5, 1) << 6))
-- 
2.39.2


