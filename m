Return-Path: <kvm+bounces-38156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D27EA35CCE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D2A9189313D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C277F263C72;
	Fri, 14 Feb 2025 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Qk94NBjt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0987021CA1F
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533517; cv=none; b=rYFZTJdUd5foqb1o/v7clmaWMWoRDNlS/mHiikkv9xLLmsFf1O8CTL54rFaAfwWc5PTtRcX4+9DCBEVIWoPFBGv+3JcXfYGPD87k+422+p03kSpM6+pmSisxX+ouUjZ21i+3HM55O9vxTIRXr+F5VUZEljYwuhEY5UQasaXciKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533517; c=relaxed/simple;
	bh=C4QiUcpyRPsdrwMu/MqArQ1CGNiIivLBG6Rphj35C7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qq6eGPX6BqE4t52QqRJLURUg1RIST9Og0YW66iFZO30JYyf1MAmOgqfYeikXS7TK2nLfMeuAAqnNYfzgQIzG7KYU7F4NXsm+5Mps9otZyeGSJ8uFVUxxlyOGj3EHPJbZgLmCJsvIG/B5kzeaVlXyer3k31xfausqqRLpO5VZBY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Qk94NBjt; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f42992f608so3126617a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739533514; x=1740138314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vPOvuamuxjiBAPe5xHpU32YlG4genFQRBOpH29Ysnw=;
        b=Qk94NBjt8Aaajvl3k9Ac4lknv99JturH30eomfjPmQDe9v7mz07+x0Jbe/qerKrYrv
         clPDkEdBnBmHMPN6/6Rd7f/4LQanGfr6aPTpnCHqLC+PvfH6Qn8ySuwi7+IwQuAmX009
         zGvFUKM61Um84PmUSwKUQpERatWXqDp57GgfbvgNAZ6KAO8QGNLIHDswHQ2RWvUlL94Q
         92YcbGHFy2jibCph9TjrnbP8kEgYgx1waMTyazE+qzvC2UUKDE6VC5E6AZntOCY11sLI
         jpzqlhoUGZHr4JKtQIieMqUwBtfSv10C4TVtHCIrJDmTJmlpv9N94L+iuAHfb9XUXvCq
         M28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533514; x=1740138314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7vPOvuamuxjiBAPe5xHpU32YlG4genFQRBOpH29Ysnw=;
        b=X/6fpgSaTNXsvy74PvpOiN6IiqMWeUaa//5xAKiYUZiEauZ40Ey9qWzT0ex9CLO29R
         YIKg4JJ0xEK/7TQOelNHxgRM4Bmekl/thxHQ5XsA3yI5/vZEabE4IQ5RzdJBc0zgd7Nk
         GYUnXKm0hpkoW8w2myY4xpMmCNVOnOLvP9laTwpv0Jfg4TlEVJR0yRD4aNPrTqbEt0Q9
         tDSPIkfS8iCtnbSl09qJF/r3IqcOTNmdA83BDTOLaVUrunci525QmNpuCZLAIwpU2mDc
         imNkRx6OdXOHEUPARPF8NqeOohfOfFxehCrQUoMx8+ObZcSUWgKjdWPkJ8hTRxORoIVS
         Iu6A==
X-Gm-Message-State: AOJu0YzwcNGjtGy3T1eWgG7Y/NxdTxSrpWZlBmvc8yXyxzKt8efN2YQv
	X3r6Bdue3rRl7vQ2cgQ+WC+o5dk3c4Il2+/l27KaWhvNItBxqCOHbU45b9NkUUkiOZgpGfYtTJg
	ntMQ=
X-Gm-Gg: ASbGncuXJa0nnhQdZBTPHDJimd7lchG3eUm2euFVV4OFcXs5WXCGRqrhcSnmUtrI+Kw
	LpqWy1DhrdaaAXasLZQ8h2u8SZFtK6fuSv+UDTknl3IY/gVtfqm5ver9V/mXTq56TQDjKbQAOi7
	KvblbQnIKR3HzWFXf5QeKEEnymTvkXN+ttGzSfsIQkniekhoLOGWaxaO91e5cBWkbFnObwLI8Of
	rEfgttGeTxto7oVe10aWbvGGok8oaNm4hmIJiFL8kGaShE8Fcd2s0hHnEjGUu7XagJUr9k+1EN/
	OscufZzWxFG2mpmg
X-Google-Smtp-Source: AGHT+IEMXT2v9ulVsEFiTxGBNrYpwVxV2PLPflSryRN5FOAz1Be8mObj5dewUDrFYm0ax3D13lkIdA==
X-Received: by 2002:a17:90b:38c6:b0:2ee:f80c:6884 with SMTP id 98e67ed59e1d1-2fc0f0db50dmr11453714a91.33.1739533513615;
        Fri, 14 Feb 2025 03:45:13 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f6965sm4948862a91.29.2025.02.14.03.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:45:13 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v7 5/6] lib: riscv: Add SBI SSE support
Date: Fri, 14 Feb 2025 12:44:18 +0100
Message-ID: <20250214114423.1071621-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214114423.1071621-1-cleger@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for registering and handling SSE events. This will be used
by sbi test as well as upcoming double trap tests.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile          |   2 +
 lib/riscv/asm/csr.h     |   1 +
 lib/riscv/asm/sbi-sse.h |  48 +++++++++++++++++++
 lib/riscv/sbi-sse-asm.S | 103 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/asm-offsets.c |   9 ++++
 lib/riscv/sbi-sse.c     |  84 ++++++++++++++++++++++++++++++++
 6 files changed, 247 insertions(+)
 create mode 100644 lib/riscv/asm/sbi-sse.h
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 lib/riscv/sbi-sse.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 02d2ac39..ed590ede 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,8 @@ cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 cflatobjs += lib/riscv/stack.o
 cflatobjs += lib/riscv/timer.o
+cflatobjs += lib/riscv/sbi-sse-asm.o
+cflatobjs += lib/riscv/sbi-sse.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 16f5ddd7..389d9850 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -17,6 +17,7 @@
 #define CSR_TIME		0xc01
 
 #define SR_SIE			_AC(0x00000002, UL)
+#define SR_SPP			_AC(0x00000100, UL)
 
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
diff --git a/lib/riscv/asm/sbi-sse.h b/lib/riscv/asm/sbi-sse.h
new file mode 100644
index 00000000..ba18ce27
--- /dev/null
+++ b/lib/riscv/asm/sbi-sse.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * SBI SSE library interface
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#ifndef _RISCV_SSE_H_
+#define _RISCV_SSE_H_
+
+#include <asm/sbi.h>
+
+typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
+
+struct sbi_sse_handler_arg {
+	unsigned long reg_tmp;
+	sbi_sse_handler_fn handler;
+	void *handler_data;
+	void *stack;
+};
+
+extern void sbi_sse_entry(void);
+
+static inline bool sbi_sse_event_is_global(uint32_t event_id)
+{
+	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
+}
+
+struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				     unsigned long attr_count, unsigned long phys_lo,
+				     unsigned long phys_hi);
+struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
+				 unsigned long attr_count, unsigned long *values);
+struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				      unsigned long attr_count, unsigned long phys_lo,
+				      unsigned long phys_hi);
+struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
+				  unsigned long attr_count, unsigned long *values);
+struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
+				   unsigned long entry_arg);
+struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg);
+struct sbiret sbi_sse_unregister(unsigned long event_id);
+struct sbiret sbi_sse_enable(unsigned long event_id);
+struct sbiret sbi_sse_hart_mask(void);
+struct sbiret sbi_sse_hart_unmask(void);
+struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
+struct sbiret sbi_sse_disable(unsigned long event_id);
+
+#endif /* !_RISCV_SSE_H_ */
diff --git a/lib/riscv/sbi-sse-asm.S b/lib/riscv/sbi-sse-asm.S
new file mode 100644
index 00000000..5f60b839
--- /dev/null
+++ b/lib/riscv/sbi-sse-asm.S
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * RISC-V SSE events entry point.
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#define __ASSEMBLY__
+#include <asm/asm.h>
+#include <asm/csr.h>
+#include <asm/asm-offsets.h>
+#include <generated/sbi-asm-offsets.h>
+
+.section .text
+.global sbi_sse_entry
+sbi_sse_entry:
+	/* Save stack temporarily */
+	REG_S sp, SBI_SSE_REG_TMP(a7)
+	/* Set entry stack */
+	REG_L sp, SBI_SSE_HANDLER_STACK(a7)
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
+	REG_L a0, SBI_SSE_REG_TMP(a7)
+	REG_S a0, PT_SP(sp)
+
+	REG_L t0, SBI_SSE_HANDLER(a7)
+	REG_L a0, SBI_SSE_HANDLER_DATA(a7)
+	mv a1, sp
+	mv a2, a6
+	jalr t0
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
+
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 6c511c14..77e5d26d 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -4,6 +4,7 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/smp.h>
+#include <asm/sbi-sse.h>
 
 int main(void)
 {
@@ -63,5 +64,13 @@ int main(void)
 	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
 	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
 
+	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
+	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
+
+	OFFSET(SBI_SSE_REG_TMP, sbi_sse_handler_arg, reg_tmp);
+	OFFSET(SBI_SSE_HANDLER, sbi_sse_handler_arg, handler);
+	OFFSET(SBI_SSE_HANDLER_DATA, sbi_sse_handler_arg, handler_data);
+	OFFSET(SBI_SSE_HANDLER_STACK, sbi_sse_handler_arg, stack);
+
 	return 0;
 }
diff --git a/lib/riscv/sbi-sse.c b/lib/riscv/sbi-sse.c
new file mode 100644
index 00000000..bc4dd10e
--- /dev/null
+++ b/lib/riscv/sbi-sse.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI SSE library
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <asm/sbi.h>
+#include <asm/sbi-sse.h>
+#include <asm/io.h>
+
+struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				     unsigned long attr_count, unsigned long phys_lo,
+				     unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
+				 unsigned long attr_count, unsigned long *values)
+{
+	phys_addr_t p = virt_to_phys(values);
+
+	return sbi_sse_read_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
+				      upper_32_bits(p));
+}
+
+struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				      unsigned long attr_count, unsigned long phys_lo,
+				      unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
+				  unsigned long attr_count, unsigned long *values)
+{
+	phys_addr_t p = virt_to_phys(values);
+
+	return sbi_sse_write_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
+				       upper_32_bits(p));
+}
+
+struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
+				   unsigned long entry_arg)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, entry_pc, entry_arg, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg)
+{
+	return sbi_sse_register_raw(event_id, virt_to_phys(sbi_sse_entry), virt_to_phys(arg));
+}
+
+struct sbiret sbi_sse_unregister(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_enable(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_disable(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_hart_mask(void)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_hart_unmask(void)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
+}
-- 
2.47.2


