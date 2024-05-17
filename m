Return-Path: <kvm+bounces-17604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 358F28C875C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69FEDB22E0F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3639856742;
	Fri, 17 May 2024 13:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="octkb9Ae"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564AA54BFB
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715953218; cv=none; b=Z8qIGdhKT0NriPOG5UMQgtpDnMtnxOITIvclmhF+ygVNTQn1BFRTcFlx1chZB4u1SAWoitSibK5KGYfsjr2bB1IsFv0vsfSNbGvGxCs94IO22V/MQ/Xkaig5v1bb+RAn4xAnQ2YYZwtWSZbbHztWz3M2SpBEuIdMklK7uFfiuDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715953218; c=relaxed/simple;
	bh=D9SbEZpb74wmEYyt9oWlS/gX1rcdTxjFEK1RwhdSSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZgJ+yejsBXViUD3tj37p1ODOsOD85vM1L2SHDuU9rS7KJkzpisQb6KdT/H3dr/jUDH9Ya5XyP3oKSQO+kDNDbA3bZH6NoNs2WQRU0FcH0LMi1QCek5Iu4GvVY11yAAczj0GOree3+sw0YvD0xaW7qnFB3OjHqWNGjsGuQq+siI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=octkb9Ae; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4201033aeb4so198195e9.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715953214; x=1716558014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uULTfJpUxv0cHbNED0YCMQ2Ed2aowh8NFmnRBg6dlM=;
        b=octkb9AeGaRpq/lpgfUIcr/JWcmamD9M+c/sAqyaq33DvNz2gpe71pJnNtTxAW4pLw
         BQCICVO9WBpHgNlAinzPKDTaBNFZH6rUlEPMc8WmOlEKx9e3m4rYwNWjf/iWAYcCQaZ2
         9c0KWTh28W9L9LWE2itvZ0dZndAfcLVc65JVJhBv8hCp6bVk3oDr67EHzVvDt8mTKKYz
         VKoJT8Yqz9Q02RANAI/9/mG675IFFAXSEijmqJ0La452Pu1l1JFIbzxYOEL9U8oRvo3P
         I/OLe4BvWeEV5xmy6BvEz+7TnVnzkdykjFmB+A0H2kDs69O7pozV2W9HkGht42Wc0pov
         WlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715953214; x=1716558014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2uULTfJpUxv0cHbNED0YCMQ2Ed2aowh8NFmnRBg6dlM=;
        b=iN5tHQwgGq/TdtvmogAhjmGM3Ix2JFJj8+LgT+BikvcuAwzqaPhfLb586a60edcmHq
         u6u1t3mvdXvlsNEQ+hWJ7T/qbF9NhuNrud3xKxQYFM5UNlKOjFR4TtNofZyEZk08X3lX
         VrylYDTD6ymGfoXe5yLlC6/5AMvpMNvEAm33i5JqMW0AKXxIiOSDxp4hx6rXHKzqR5NS
         kTpp62+MQAapiCFJFpLuCoNh1l6Ta4I18/XxoUJX16RLCEdTeWbZBFyBg4HtW+HVGmCW
         +jhufisRlQLImQU2mV32DcTDty9KMeS+oFZk3WaElsOlWf2eSjpS36ZfFH2dQ5E+sZt3
         V7mg==
X-Gm-Message-State: AOJu0YyNy91PmUr7uA0AryL9obztj+PHEUZT//8oz1R0RoLaBw8sp0Rb
	XGdmb7x+te0D1P4TRuNmhEA/kC6JhEHb1ujc7/9K72R2TyEdSqVMYztMbIP3lRy31RCmaUhN7C4
	63bQ=
X-Google-Smtp-Source: AGHT+IHOY4EdaWkIkYGC/BuZM092fUgU/spg4q6sIjw+u3kQJdyzIQ3bQH3dAR1kSMeXc/bpocpyjQ==
X-Received: by 2002:a05:600c:1d0a:b0:418:1303:c3d1 with SMTP id 5b1f17b1804b1-41fead6ae1bmr183977285e9.3.1715953213910;
        Fri, 17 May 2024 06:40:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4200e518984sm240669275e9.23.2024.05.17.06.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 06:40:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v1 3/4] riscv: add SSE assembly entry handling
Date: Fri, 17 May 2024 15:40:04 +0200
Message-ID: <20240517134007.928539-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517134007.928539-1-cleger@rivosinc.com>
References: <20240517134007.928539-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a SSE entry assembly code to handle SSE events. Events should be
registered with a struct sse_handler_arg containing a correct stack and
handler function.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile          |   1 +
 lib/riscv/asm/sse.h     |  16 +++++++
 lib/riscv/sse_entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/asm-offsets.c |   9 ++++
 4 files changed, 126 insertions(+)
 create mode 100644 lib/riscv/asm/sse.h
 create mode 100644 lib/riscv/sse_entry.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb..c7810359 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -37,6 +37,7 @@ cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
+cflatobjs += lib/riscv/sse_entry.o
 cflatobjs += lib/riscv/stack.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
new file mode 100644
index 00000000..557f6680
--- /dev/null
+++ b/lib/riscv/asm/sse.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_SSE_H_
+#define _ASMRISCV_SSE_H_
+
+typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
+
+struct sse_handler_arg {
+	unsigned long reg_tmp;
+	sse_handler_fn handler;
+	void *handler_data;
+	void *stack;
+};
+
+extern void sse_entry(void);
+
+#endif /* _ASMRISCV_SSE_H_ */
diff --git a/lib/riscv/sse_entry.S b/lib/riscv/sse_entry.S
new file mode 100644
index 00000000..bedc47e9
--- /dev/null
+++ b/lib/riscv/sse_entry.S
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * SBI SSE entry code
+ *
+ * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+
+.global sse_entry
+sse_entry:
+	/* Save stack temporarily */
+	REG_S sp, SSE_REG_TMP(a6)
+	/* Set entry stack */
+	REG_L sp, SSE_HANDLER_STACK(a6)
+
+	addi sp, sp, -(PT_SIZE)
+	REG_S ra, PT_RA(sp)
+	REG_S s0, PT_S0(sp)
+	REG_S s1, PT_S1(sp)
+	REG_S s2, PT_S2(sp)
+	REG_S s3, PT_S3(sp)
+	REG_S s4, PT_S4(sp)
+	REG_S s5, PT_S5(sp)
+	REG_S s6, PT_S6(sp)
+	REG_S s7, PT_S7(sp)
+	REG_S s8, PT_S8(sp)
+	REG_S s9, PT_S9(sp)
+	REG_S s10, PT_S10(sp)
+	REG_S s11, PT_S11(sp)
+	REG_S tp, PT_TP(sp)
+	REG_S t0, PT_T0(sp)
+	REG_S t1, PT_T1(sp)
+	REG_S t2, PT_T2(sp)
+	REG_S t3, PT_T3(sp)
+	REG_S t4, PT_T4(sp)
+	REG_S t5, PT_T5(sp)
+	REG_S t6, PT_T6(sp)
+	REG_S gp, PT_GP(sp)
+	REG_S a0, PT_A0(sp)
+	REG_S a1, PT_A1(sp)
+	REG_S a2, PT_A2(sp)
+	REG_S a3, PT_A3(sp)
+	REG_S a4, PT_A4(sp)
+	REG_S a5, PT_A5(sp)
+	csrr a1, CSR_SEPC
+	REG_S a1, PT_EPC(sp)
+	csrr a2, CSR_SSTATUS
+	REG_S a2, PT_STATUS(sp)
+
+	REG_L a0, SSE_REG_TMP(a6)
+	REG_S a0, PT_SP(sp)
+
+	REG_L t0, SSE_HANDLER(a6)
+	REG_L a0, SSE_HANDLER_DATA(a6)
+	move a1, sp
+	move a2, a7
+	jalr t0
+
+
+	REG_L a1, PT_EPC(sp)
+	REG_L a2, PT_STATUS(sp)
+	csrw CSR_SEPC, a1
+	csrw CSR_SSTATUS, a2
+
+	REG_L ra, PT_RA(sp)
+	REG_L s0, PT_S0(sp)
+	REG_L s1, PT_S1(sp)
+	REG_L s2, PT_S2(sp)
+	REG_L s3, PT_S3(sp)
+	REG_L s4, PT_S4(sp)
+	REG_L s5, PT_S5(sp)
+	REG_L s6, PT_S6(sp)
+	REG_L s7, PT_S7(sp)
+	REG_L s8, PT_S8(sp)
+	REG_L s9, PT_S9(sp)
+	REG_L s10, PT_S10(sp)
+	REG_L s11, PT_S11(sp)
+	REG_L tp, PT_TP(sp)
+	REG_L t0, PT_T0(sp)
+	REG_L t1, PT_T1(sp)
+	REG_L t2, PT_T2(sp)
+	REG_L t3, PT_T3(sp)
+	REG_L t4, PT_T4(sp)
+	REG_L t5, PT_T5(sp)
+	REG_L t6, PT_T6(sp)
+	REG_L gp, PT_GP(sp)
+	REG_L a0, PT_A0(sp)
+	REG_L a1, PT_A1(sp)
+	REG_L a2, PT_A2(sp)
+	REG_L a3, PT_A3(sp)
+	REG_L a4, PT_A4(sp)
+	REG_L a5, PT_A5(sp)
+
+	REG_L sp, PT_SP(sp)
+
+	li a7, ASM_SBI_EXT_SSE
+	li a6, ASM_SBI_EXT_SSE_COMPLETE
+	ecall
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index a2a32438..a5e25332 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -2,7 +2,9 @@
 #include <kbuild.h>
 #include <elf.h>
 #include <asm/ptrace.h>
+#include <asm/sbi.h>
 #include <asm/smp.h>
+#include <asm/sse.h>
 
 int main(void)
 {
@@ -58,5 +60,12 @@ int main(void)
 	OFFSET(SECONDARY_FUNC, secondary_data, func);
 	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
 
+	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
+	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
+	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
+	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
+	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
+	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
+
 	return 0;
 }
-- 
2.43.0


