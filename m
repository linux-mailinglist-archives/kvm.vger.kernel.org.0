Return-Path: <kvm+bounces-41200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D68A649CD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3254F3A93B8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F06E242936;
	Mon, 17 Mar 2025 10:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RNvspK65"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C1A238141
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206820; cv=none; b=Xkk25lXQ93dZp5qR7ANavJ85M1Ff98kG1fvoLMDEDvncrdSebl+sixs7MPpfDFdVXr7lclCdfiZXz+ZfxG9mpS43Iu8myrjRjuT6VFaoNGxTU13GzQ6+MVnLBrYvIsGwp0rQUYlVTnHUmYbwPSkm64qcM6wQ6+z6/H0i7XWRjm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206820; c=relaxed/simple;
	bh=GSaX0YKATHndxJfB7aqAX1f9ztBKudXh5IoPDIunleM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOq98VHfgrCieNRi/w2ffiY99/NoOkEredtvZMwG/SwtNL6IVA9jr4tKuhBecRncS9dgoHZJGfE/r8A9uv1agmL7o0+v1CmzHtLJOz/eW/Od1pv4NyG8U9ULL+a1AL81b25G1MAVlMR9T5Aheax5D7ZuY0lY6OjtixXD1obMKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RNvspK65; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so16338655e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206816; x=1742811616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CexTyXQ8AXojiJm8C0nnEWW+MYK+BKBddIyTZMy3oVI=;
        b=RNvspK65w/B5gE43XZ2auPXzHw8y4W8egHH/Ags7bHZK+GBd40nBzbys6PKDLWalyH
         2Fq5YqtGAxsSibC4xxAo9uGrN6MXUgLwIDwEGlxJk0uLlIct7/N8PINDgR/Lcaqf/5iQ
         48FXrWnhayN28vb5GJUf7B77uVL3Uf/4eDwaePCHsIrquv2KqzylGV2kapuZvh3qid8A
         bYmwPOaUus6B0OCAaD5LAm7XJx3UMNzHk+jVi+JSI92cvRSgMGiKPZmOFLkUvm56pmNT
         l4t1RIOao/SYQas/8yzDA5i954OS6ltJb9rb2WatyhiS7rVQk9lESLOcrmezlNSXaH8g
         QQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206816; x=1742811616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CexTyXQ8AXojiJm8C0nnEWW+MYK+BKBddIyTZMy3oVI=;
        b=sryPJCnaXSQZpNLfdFEIAqeCq2mp2mC97dRHbWJfj+jDawHFBrQsP7pHDRNzO8hFxa
         05dcWAOVk3I204lKZme3fF5fZJr70pRU+jmY5B65TxFYsGMKaZdgnzz9UstD4XfSKPIo
         8PZn+fPg3FDPJ4miLjQo3HbBv0099GzRgNrAPyqkKbK210xvnKyYiVQktHSKm+yMmiNv
         FW0+EdZZcP0XbxXqWYV2I1Y8zOx8lBP9TbWNJL1uDn0BM+4Kb9MRC8DXcwANN526WlZn
         GL4c+bqdvwZCu77xp0EYD2k0ktX2av6Sdh0/p2qa1sxcl+fmD3/0PhmaYf94gGzkVGqA
         /riw==
X-Gm-Message-State: AOJu0YxnDn7/LD0snWFPrBkHmW/rvMKbhgBq2QkkEpMUPZOMlcJyXxfs
	DgFcCgO2RXp84nUEPajTSuDD6kkoH6vET+JenhI1SqwlrKwDr0wOXG56tD6l8HAWdGW4LP2ic88
	4wrg=
X-Gm-Gg: ASbGncv897XmCsVoIa13mHXPjxpY1y8mBuRmr56zF0uVw/9qdWeWeUZHU7FoDMWGVp1
	Z5qeUaRmcAIgVnQhBTHZjkMrFxt4k4JpVf5PVf1FP/km9PppT2wmzFUcnnq4knIKrF3JzaIYwRU
	AEyajo6TcyzM0JXO/ImTYlwdBzm2IwzOZHzQ0NYu1gahESo2SlDIsGucKErv1WrgXn80XTUh9wf
	ywS+z60vBK4cmDawtMdywzFLRMla/WDPfH832qaxdUfiS0fJJZgcrbUOmSlbBY3EUzRuuroxUH2
	HQVLoiaGSHOGU7tAiUjCOLpOO9WFtREoe9sTUjWuyoiztw==
X-Google-Smtp-Source: AGHT+IG3R6GcX6U+hxuiaKCzmURSVoYZKtxzo9rQPocTfa3VxxtvmsPM8w6creeBvBq+11xHiR3xaA==
X-Received: by 2002:adf:a3dd:0:b0:391:13d6:c9e5 with SMTP id ffacd0b85a97d-3971e2ae200mr11638164f8f.19.1742206816150;
        Mon, 17 Mar 2025 03:20:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:15 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v10 7/8] lib: riscv: Add SBI SSE support
Date: Mon, 17 Mar 2025 11:19:53 +0100
Message-ID: <20250317101956.526834-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile          |   1 +
 lib/riscv/asm/csr.h     |   1 +
 lib/riscv/asm/sbi.h     |  36 ++++++++++++++
 lib/riscv/sbi-sse-asm.S | 102 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/asm-offsets.c |   9 ++++
 lib/riscv/sbi.c         |  76 ++++++++++++++++++++++++++++++
 6 files changed, 225 insertions(+)
 create mode 100644 lib/riscv/sbi-sse-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 02d2ac39..16fc125b 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 cflatobjs += lib/riscv/stack.o
 cflatobjs += lib/riscv/timer.o
+cflatobjs += lib/riscv/sbi-sse-asm.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index c7fc87a9..3e4b5fca 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -17,6 +17,7 @@
 #define CSR_TIME		0xc01
 
 #define SR_SIE			_AC(0x00000002, UL)
+#define SR_SPP			_AC(0x00000100, UL)
 
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index b8688e47..ebc89c10 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -275,5 +275,41 @@ static inline bool sbi_check_impl(unsigned long impl)
 	return ret.value == impl;
 }
 
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
+struct sbiret sbi_sse_disable(unsigned long event_id);
+struct sbiret sbi_sse_hart_mask(void);
+struct sbiret sbi_sse_hart_unmask(void);
+struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi-sse-asm.S b/lib/riscv/sbi-sse-asm.S
new file mode 100644
index 00000000..b9e951f5
--- /dev/null
+++ b/lib/riscv/sbi-sse-asm.S
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * RISC-V SSE events entry point.
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+#include <generated/sbi-asm-offsets.h>
+
+.section .text
+.global sbi_sse_entry
+sbi_sse_entry:
+	/* Save stack temporarily */
+	REG_S	sp, SBI_SSE_REG_TMP(a7)
+	/* Set entry stack */
+	REG_L	sp, SBI_SSE_HANDLER_STACK(a7)
+
+	addi	sp, sp, -(PT_SIZE)
+	REG_S	ra, PT_RA(sp)
+	REG_S	s0, PT_S0(sp)
+	REG_S	s1, PT_S1(sp)
+	REG_S	s2, PT_S2(sp)
+	REG_S	s3, PT_S3(sp)
+	REG_S	s4, PT_S4(sp)
+	REG_S	s5, PT_S5(sp)
+	REG_S	s6, PT_S6(sp)
+	REG_S	s7, PT_S7(sp)
+	REG_S	s8, PT_S8(sp)
+	REG_S	s9, PT_S9(sp)
+	REG_S	s10, PT_S10(sp)
+	REG_S	s11, PT_S11(sp)
+	REG_S	tp, PT_TP(sp)
+	REG_S	t0, PT_T0(sp)
+	REG_S	t1, PT_T1(sp)
+	REG_S	t2, PT_T2(sp)
+	REG_S	t3, PT_T3(sp)
+	REG_S	t4, PT_T4(sp)
+	REG_S	t5, PT_T5(sp)
+	REG_S	t6, PT_T6(sp)
+	REG_S	gp, PT_GP(sp)
+	REG_S	a0, PT_A0(sp)
+	REG_S	a1, PT_A1(sp)
+	REG_S	a2, PT_A2(sp)
+	REG_S	a3, PT_A3(sp)
+	REG_S	a4, PT_A4(sp)
+	REG_S	a5, PT_A5(sp)
+	csrr	a1, CSR_SEPC
+	REG_S	a1, PT_EPC(sp)
+	csrr	a2, CSR_SSTATUS
+	REG_S	a2, PT_STATUS(sp)
+
+	REG_L	a0, SBI_SSE_REG_TMP(a7)
+	REG_S	a0, PT_SP(sp)
+
+	REG_L	t0, SBI_SSE_HANDLER(a7)
+	REG_L	a0, SBI_SSE_HANDLER_DATA(a7)
+	mv	a1, sp
+	mv	a2, a6
+	jalr	t0
+
+	REG_L	a1, PT_EPC(sp)
+	REG_L	a2, PT_STATUS(sp)
+	csrw	CSR_SEPC, a1
+	csrw	CSR_SSTATUS, a2
+
+	REG_L	ra, PT_RA(sp)
+	REG_L	s0, PT_S0(sp)
+	REG_L	s1, PT_S1(sp)
+	REG_L	s2, PT_S2(sp)
+	REG_L	s3, PT_S3(sp)
+	REG_L	s4, PT_S4(sp)
+	REG_L	s5, PT_S5(sp)
+	REG_L	s6, PT_S6(sp)
+	REG_L	s7, PT_S7(sp)
+	REG_L	s8, PT_S8(sp)
+	REG_L	s9, PT_S9(sp)
+	REG_L	s10, PT_S10(sp)
+	REG_L	s11, PT_S11(sp)
+	REG_L	tp, PT_TP(sp)
+	REG_L	t0, PT_T0(sp)
+	REG_L	t1, PT_T1(sp)
+	REG_L	t2, PT_T2(sp)
+	REG_L	t3, PT_T3(sp)
+	REG_L	t4, PT_T4(sp)
+	REG_L	t5, PT_T5(sp)
+	REG_L	t6, PT_T6(sp)
+	REG_L	gp, PT_GP(sp)
+	REG_L	a0, PT_A0(sp)
+	REG_L	a1, PT_A1(sp)
+	REG_L	a2, PT_A2(sp)
+	REG_L	a3, PT_A3(sp)
+	REG_L	a4, PT_A4(sp)
+	REG_L	a5, PT_A5(sp)
+
+	REG_L	sp, PT_SP(sp)
+
+	li	a7, ASM_SBI_EXT_SSE
+	li	a6, ASM_SBI_EXT_SSE_COMPLETE
+	ecall
+
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 6c511c14..a96c6e97 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -3,6 +3,7 @@
 #include <elf.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
+#include <asm/sbi.h>
 #include <asm/smp.h>
 
 int main(void)
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
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 9cb5757e..8249cb1b 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -2,6 +2,7 @@
 #include <libcflat.h>
 #include <cpumask.h>
 #include <limits.h>
+#include <asm/io.h>
 #include <asm/sbi.h>
 #include <asm/setup.h>
 
@@ -31,6 +32,81 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
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
+	return sbi_sse_register_raw(event_id, (unsigned long)sbi_sse_entry, (unsigned long)arg);
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
+
 void sbi_shutdown(void)
 {
 	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
-- 
2.47.2


