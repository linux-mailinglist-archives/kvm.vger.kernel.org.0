Return-Path: <kvm+bounces-46815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB4FAB9E4C
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 317317AC1B7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F2313B590;
	Fri, 16 May 2025 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="enyclx15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F83156F3C
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747404616; cv=none; b=dQK7nBdXvZouSfcimPtVzQj5SVvR0pQLsbJsD5srtECpm8ski8xmoHKKMMDlSftZJl+oD6Iz5ietmFKdM5RGfvtqLmi1E8WcwGff+scF8aA3OjDQjaovxGGR4GCdv9xNX7uBgBAY6Nxci0VNIdjuDMHpKJQIPrt3ZKyzSXkQwZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747404616; c=relaxed/simple;
	bh=YsG/n58/7UljulLIH6yQDpVvmwkZS7zuv5OmuaULh3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H7MejfxqfffYGLy4XSbDefXwqt1p9eMY/T7oJRHekh49+2vDxLvDPiPG5e00QMgPm4dU54IJXlmmoQQsq4TAuCGH/RHeItJe9obMw35bgR+yaoHcLmROT3TsrAYfa0Hqoe6NMmZEdAwawzu7LRkNZcbfq/ZA99Gqk3pNDdZN0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=enyclx15; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a1d8c0966fso1530764f8f.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747404612; x=1748009412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IFDT/Z0eU8ynKvSevEJyO30COLe0P/GAezwqL9/DGg=;
        b=enyclx15oSczzSNC9Lhbgck7Q1k4DZEyVezNBdsCMvTyMAh5qxNAhFzjvm+sNkQNs+
         33MVB81achjxvKQ5VqKdK1CjrTT25wLtG1aGgnF2H7dyggHSwDqJPVyBY6/UJvGQO2sa
         WzHkGjMdbpGx0s0+JWoMOeBWx5ZNunaXjISZ81w5qBW5VmvMzPP1C31rRu6G2EV1zc71
         bMehcXPwNavVfmM9QTlHERcvwiFpVY4xY1NjUNQiy7Ndc0xkbw0RLGf8rSOYpRHlI7BN
         udSJdioq2EqFGh91cEnGQHyQS8F4s6NgTS/eK61iDBaPs578W98vgEr0ZiF6o1oT5zRc
         6Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747404612; x=1748009412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6IFDT/Z0eU8ynKvSevEJyO30COLe0P/GAezwqL9/DGg=;
        b=SobkKTHKdvZ9rtJjg2eQo5kCc3OgC2IDyk00RsxSOIpC/32t1N6x+TTBHWUodRrJiV
         A3labA9q3bP4guXteri3+ps5X6WQFtNrJGP8CbXH07q0CBkKnZRNzvqRYzSIQBzhNqvC
         2vHeS3jXsRHVDRA20cqmAofv++IZQ6RQ1sjLqGy8alhs/4qaEG6tMCJa9HWhjwDcvx5S
         U/3wd+ZxA0qXbc+Uxv7BT/+BEmuXdk+5U/AHJFfMC7nzFmo7UZa4mhpu6lu8mD/OiLFy
         S/NOUKTWzwL8ymc9k3NloncTPGfEyJXsfSSLObaVD+bM8n4VyAPiQZyW1+BRpW6aVbHk
         1bDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5T9SOsaVflok3xUeZRKHG+fngJ7rCxnYFbYx7Qz8fq+RJcupGtojNqslqeDbMIvfikE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjyNu3GjXZoxha0/N27AVHF95/9Ngc0aOnlkGllBZHHUwsU2fw
	qZpl3PAm3rf9uqEkCDO4b9uXXXpEANDBQ1Xrvz1+s4pwWLZ/K0BmfXptAaBQDm4Ywl8=
X-Gm-Gg: ASbGncvr6BSFMKi/9wCJm2BvDHI2ZKAIiz3y6lQ7mD+1NJsKWX+eCgnNHtNoCcd9IfV
	neXfvMJy5U/mWEJ9wPEeC+GRSmpVO0gvqbrTW4WHXs3uLXURgizBmFtw3xPuigJI32uZUf8kyue
	chxF3PS6MSTojabXiLRvKMqxK6DvNZBP80FRce4kIJpVZXziaKM+XjUCfppoWrLQZXeLs9jqcWX
	PiivCt9c+JK7rp7Reeqe+/lsZaSKtmqId4SgeJOhZ/364cAtb+lvZF28ZLtFE0r0B9osD8+UFy1
	DXo9wo/JQPuvKGgUfDpG8reMPCPW4162YW/GQUH2NsjCVK86tLK8ADo69mAn3Q==
X-Google-Smtp-Source: AGHT+IE3DI05AXUI5qsb4s4PKO6MYBsqRRrry5Op3KCBIII8gOekr8aHR0w5shNYqLq6bylWnC4cOA==
X-Received: by 2002:a05:6000:2012:b0:3a0:b8ba:849f with SMTP id ffacd0b85a97d-3a35ca76681mr3216586f8f.4.1747404609957;
        Fri, 16 May 2025 07:10:09 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:b6d5:4f19:6a91:78f0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca88957sm2934229f8f.75.2025.05.16.07.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:10:09 -0700 (PDT)
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
Subject: [PATCH v4 2/3] riscv: Strengthen duplicate and inconsistent definition of RV_X()
Date: Fri, 16 May 2025 16:08:04 +0200
Message-Id: <20250516140805.282770-3-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250516140805.282770-1-alexghiti@rivosinc.com>
References: <20250516140805.282770-1-alexghiti@rivosinc.com>
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

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/include/asm/insn.h          | 39 +++++++++++++-------------
 arch/riscv/kernel/machine_kexec_file.c |  2 +-
 arch/riscv/kernel/traps_misaligned.c   |  2 +-
 arch/riscv/kvm/vcpu_insn.c             |  2 +-
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 2a589a58b291..ac3e606feca2 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -288,43 +288,44 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 
 #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
 #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
-#define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
-#define RVC_X(X, s, mask) RV_X(X, s, mask)
+#define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
+#define RV_X(X, s, n) RV_X_mask(X, s, ((1 << (n)) - 1))
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
diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
index e36104af2e24..5c2ed4c396e9 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/vmalloc.h>
 #include <asm/setup.h>
+#include <asm/insn.h>
 
 const struct kexec_file_ops * const kexec_file_loaders[] = {
 	&elf_kexec_ops,
@@ -109,7 +110,6 @@ static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
 }
 #endif
 
-#define RV_X(x, s, n)  (((x) >> (s)) & ((1 << (n)) - 1))
 #define RISCV_IMM_BITS 12
 #define RISCV_IMM_REACH (1LL << RISCV_IMM_BITS)
 #define RISCV_CONST_HIGH_PART(x) \
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 77c788660223..ac8f479a3f9c 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -17,6 +17,7 @@
 #include <asm/hwprobe.h>
 #include <asm/cpufeature.h>
 #include <asm/vector.h>
+#include <asm/insn.h>
 
 #define INSN_MATCH_LB			0x3
 #define INSN_MASK_LB			0x707f
@@ -112,7 +113,6 @@
 #define SH_RS2				20
 #define SH_RS2C				2
 
-#define RV_X(x, s, n)			(((x) >> (s)) & ((1 << (n)) - 1))
 #define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
 					 (RV_X(x, 10, 3) << 3) | \
 					 (RV_X(x, 5, 1) << 6))
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..62cb2ab4b636 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -8,6 +8,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/cpufeature.h>
+#include <asm/insn.h>
 
 #define INSN_OPCODE_MASK	0x007c
 #define INSN_OPCODE_SHIFT	2
@@ -91,7 +92,6 @@
 #define SH_RS2C			2
 #define MASK_RX			0x1f
 
-#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
 #define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
 				 (RV_X(x, 10, 3) << 3) | \
 				 (RV_X(x, 5, 1) << 6))
-- 
2.39.2


