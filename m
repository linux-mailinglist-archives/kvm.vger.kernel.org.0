Return-Path: <kvm+bounces-32468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A18599D8A33
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 623E4281FBD
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B251AE01B;
	Mon, 25 Nov 2024 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="M5EQOgAp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9F31B4144
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551768; cv=none; b=Zrh+ZoTdBMRjGWNYHsWKJLJAk5jjC56lVp5tpX+J2s5Of+ewWT1saObW7xhjpLXIAmSZsz3zxltzYZaOHjM+d6egjz3kEXZeDg4NwYlr99i/drAFVPqLP0E9gsow7Mtk8kRU8IeW6oK2HFq1bJWjJoZeLE8Cm0pzBB/Vx4S2Eqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551768; c=relaxed/simple;
	bh=AgSd+p0cO5+2ncrVCQz9XABE85W/5I0HxqSsSa2cDUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=slGux+RJsHtlFa8J4BVm6WQ24fR6cfkpdCDBzlpsEzYnmlxWhWhbba7Y+cTkuVvzHWwV3DB3Eni1BLlEn3sTkiqChSXQ2OfoNQLd9bCQc1tsj7+b4+yxg8iURKDHSqR8tSo2M0917ZcdKonoAV0w2m/ORfuyacXEgWXzsRLDbAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=M5EQOgAp; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-71d4ba17cd2so586614a34.3
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551765; x=1733156565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VodDNoT5TFVdLptPxzd64QTPNFfsf/ETRsC7P7tHitE=;
        b=M5EQOgAp9ats7f3DIt3AnyVb6ZlDN6Qql+qEFGb74jVBUbbBh8Ru5iB1zd5lR2TN1i
         QccQRQs7+VD3+J5nYSFtlAyRTobFP4HgYZBhwk1NDSSPv2mQixKcurWxoyy9tyw0iBky
         xF4RpyV+jb3TLP6NszI5J68S7/hE9wyKAHASpFLexAYCjioWbCTL+h2OLEJl/y92adS2
         tQG2gTLMcUcg1Jfmo18HpsoWfKgHEXReKdimN3Sn9KE9uilSdCTUS0SRz+EnWNbgOA4l
         PyzWcTthqeK8r8dFO1nCD3xcvvrU7EUqWGarnPwEfI+LY9ZZyEIO+Ua5qx1+HxapJTM3
         CXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551765; x=1733156565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VodDNoT5TFVdLptPxzd64QTPNFfsf/ETRsC7P7tHitE=;
        b=rqKDUoU74SyCGIEHYqclQ0ojtprTg1YKcO/qP1somIVKvxoYyeun3ljV7U6ZrDmAub
         iIJAUfpYw8g1ouJ7zLq3dKtNQ5i5ifGsC9qTygHZ7WFZSreMgkAEuiX8uDj88lKIiX97
         rsfk+TOy11uIWwgFmIG1523NXT4O/S49btDp1kXw4aZSuhSnI079H3IKk8HhiPmhZDGT
         BNtjF8/+hB+tM6Zx3C+UTVuIvgv1B/3bVgaJmpwlDoLXZaodpMUyEYQl01+D8ZXPU1zi
         jJVVuvBUpOZz7u7m7UbLW9ELl9qkJ/071s/ePGGq7fAD0WivP06dxUBYLubgvOfi24de
         BfSA==
X-Gm-Message-State: AOJu0Yy0Pvf6BmO4856MrjF/hBznFDUkQhFABfF3Heun7THeZ8y5rqco
	attY6o38pYJ6vVT/al6Cjn+2xeIkBdJsYbY2rsvsxhc762GR7ejfY1waA3ZvCXYi6ekz3N3UemX
	5
X-Gm-Gg: ASbGnctfqRW7MNxxppGR03rgjWDufDf92a2OZytmm47KyKlBQChTZGOuwUPYNreev+g
	7np4oIB82MpI3iJOGZRTrxFbHemU07ghljF+/2tnAnSa+2+slb57VNnIsn8jsWakaen+6uZvsVO
	obFIueLJpR84IW7j8IwegT5aqR0qpL+54lBn9HmlzitSohLuW1AWOf1QRy5Frlg3B1/yJ/7/exF
	Xka2JUVjAGwXG7PxM2+tpEf7hLZMGz7l8a9/z9TrC3WYGGP9rk=
X-Google-Smtp-Source: AGHT+IH88Hat8kD6eN/MWO3fmAboOs55xkdBwLYHESW74GVqTIJQ1KolzpW+ZTPaIELPMkAvBdoSgQ==
X-Received: by 2002:a05:6830:9c3:b0:71d:3e91:31b0 with SMTP id 46e09a7af769-71d3e9134ebmr5791394a34.4.1732551764519;
        Mon, 25 Nov 2024 08:22:44 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:43 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v4 5/5] riscv: sbi: Add SSE extension tests
Date: Mon, 25 Nov 2024 17:21:54 +0100
Message-ID: <20241125162200.1630845-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125162200.1630845-1-cleger@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add SBI SSE extension tests for the following features:
- Test attributes errors (invalid values, RO, etc)
- Registration errors
- Simple events (register, enable, inject)
- Events with different priorities
- Global events dispatch on different harts
- Local events on all harts
- Hart mask/unmask events

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile           |    2 +-
 lib/riscv/asm/csr.h      |    2 +
 riscv/sbi-tests.h        |   12 +
 riscv/sbi-asm.S          |   90 ++++
 riscv/asm-offsets-test.c |    7 +
 riscv/sbi-sse.c          | 1043 ++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c              |    3 +
 7 files changed, 1158 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi-sse.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 05e41d0c..5fb1b04f 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -17,7 +17,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
+$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-sse.o
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 16f5ddd7..06831380 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -21,6 +21,8 @@
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
+#define SSTATUS_SPP		_AC(0x00000100, UL) /* Previously Supervisor */
+
 /* Exception causes */
 #define EXC_INST_MISALIGNED	0
 #define EXC_INST_ACCESS		1
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index ce129968..44414995 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -33,4 +33,16 @@
 #define SBI_SUSP_TEST_HARTID	(1 << 2)
 #define SBI_SUSP_TEST_MASK	7
 
+#ifndef __ASSEMBLY__
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
+#endif /* !__ASSEMBLY__ */
 #endif /* _RISCV_SBI_TESTS_H_ */
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index 193d9606..7c2e1301 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -131,3 +131,93 @@ sbi_susp_resume:
 	call	longjmp
 6:	pause	/* unreachable */
 	j	6b
+
+.global sse_entry
+sse_entry:
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
\ No newline at end of file
diff --git a/riscv/asm-offsets-test.c b/riscv/asm-offsets-test.c
index 116fe497..7b746e91 100644
--- a/riscv/asm-offsets-test.c
+++ b/riscv/asm-offsets-test.c
@@ -7,6 +7,13 @@ int main(void)
 {
 	DEFINE(ASM_SBI_EXT_HSM, SBI_EXT_HSM);
 	DEFINE(ASM_SBI_EXT_HSM_HART_STOP, SBI_EXT_HSM_HART_STOP);
+	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
+	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
+
+	OFFSET(SBI_SSE_REG_TMP, sse_handler_arg, reg_tmp);
+	OFFSET(SBI_SSE_HANDLER, sse_handler_arg, handler);
+	OFFSET(SBI_SSE_HANDLER_DATA, sse_handler_arg, handler_data);
+	OFFSET(SBI_SSE_HANDLER_STACK, sse_handler_arg, stack);
 
 	return 0;
 }
diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
new file mode 100644
index 00000000..3637cbee
--- /dev/null
+++ b/riscv/sbi-sse.c
@@ -0,0 +1,1043 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI SSE testsuite
+ *
+ * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <alloc.h>
+#include <alloc_page.h>
+#include <bitops.h>
+#include <cpumask.h>
+#include <libcflat.h>
+#include <on-cpus.h>
+
+#include <asm/barrier.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/sbi.h>
+#include <asm/setup.h>
+
+#include "sbi-tests.h"
+
+#define SSE_STACK_SIZE	PAGE_SIZE
+
+void check_sse(void);
+void sse_entry(void);
+
+struct sse_event_info {
+	unsigned long event_id;
+	const char *name;
+	bool can_inject;
+};
+
+static struct sse_event_info sse_event_infos[] = {
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_RAS,
+		.name = "local_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP,
+		.name = "double_trap",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_RAS,
+		.name = "global_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_PMU,
+		.name = "local_pmu",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,
+		.name = "local_software",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,
+		.name = "global_software",
+	},
+};
+
+static const char *const attr_names[] = {
+	[SBI_SSE_ATTR_STATUS] = "status",
+	[SBI_SSE_ATTR_PRIORITY] = "prio",
+	[SBI_SSE_ATTR_CONFIG] = "config",
+	[SBI_SSE_ATTR_PREFERRED_HART] = "preferred_hart",
+	[SBI_SSE_ATTR_ENTRY_PC] = "entry_pc",
+	[SBI_SSE_ATTR_ENTRY_ARG] = "entry_arg",
+	[SBI_SSE_ATTR_INTERRUPTED_SEPC] = "interrupted_pc",
+	[SBI_SSE_ATTR_INTERRUPTED_FLAGS] = "interrupted_flags",
+	[SBI_SSE_ATTR_INTERRUPTED_A6] = "interrupted_a6",
+	[SBI_SSE_ATTR_INTERRUPTED_A7] = "interrupted_a7",
+};
+
+static const unsigned long ro_attrs[] = {
+	SBI_SSE_ATTR_STATUS,
+	SBI_SSE_ATTR_ENTRY_PC,
+	SBI_SSE_ATTR_ENTRY_ARG,
+};
+
+static const unsigned long interrupted_attrs[] = {
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS,
+	SBI_SSE_ATTR_INTERRUPTED_SEPC,
+	SBI_SSE_ATTR_INTERRUPTED_A6,
+	SBI_SSE_ATTR_INTERRUPTED_A7,
+};
+
+static const unsigned long interrupted_flags[] = {
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP,
+};
+
+static struct sse_event_info *sse_evt_get_infos(unsigned long event_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		if (sse_event_infos[i].event_id == event_id)
+			return &sse_event_infos[i];
+	}
+
+	assert_msg(false, "Invalid event id: %ld", event_id);
+}
+
+static const char *sse_evt_name(unsigned long event_id)
+{
+	struct sse_event_info *infos = sse_evt_get_infos(event_id);
+
+	return infos->name;
+}
+
+static bool sse_evt_can_inject(unsigned long event_id)
+{
+	struct sse_event_info *infos = sse_evt_get_infos(event_id);
+
+	return infos->can_inject;
+}
+
+static bool sse_event_is_global(unsigned long event_id)
+{
+	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
+}
+
+static struct sbiret sse_event_get_attr_raw(unsigned long event_id,
+					    unsigned long base_attr_id,
+					    unsigned long attr_count,
+					    unsigned long phys_lo,
+					    unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id,
+			base_attr_id, attr_count, phys_lo, phys_hi, 0);
+}
+
+static unsigned long sse_event_get_attrs(unsigned long event_id, unsigned long attr_id,
+					 unsigned long *values, unsigned int attr_count)
+{
+	struct sbiret ret;
+
+	ret = sse_event_get_attr_raw(event_id, attr_id, attr_count, (unsigned long)values, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_get_attr(unsigned long event_id, unsigned long attr_id,
+					unsigned long *value)
+{
+	return sse_event_get_attrs(event_id, attr_id, value, 1);
+}
+
+static struct sbiret sse_event_set_attr_raw(unsigned long event_id, unsigned long base_attr_id,
+					    unsigned long attr_count, unsigned long phys_lo,
+					    unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+static unsigned long sse_event_set_attr(unsigned long event_id, unsigned long attr_id,
+					unsigned long value)
+{
+	struct sbiret ret;
+
+	ret = sse_event_set_attr_raw(event_id, attr_id, 1, (unsigned long)&value, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_register_raw(unsigned long event_id, void *entry_pc, void *entry_arg)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)entry_pc,
+			(unsigned long)entry_arg, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_register(unsigned long event_id, struct sse_handler_arg *arg)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)sse_entry,
+			(unsigned long)arg, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_unregister(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_enable(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_hart_mask(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_hart_unmask(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_inject(unsigned long event_id, unsigned long hart_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_disable(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+
+static int sse_get_state(unsigned long event_id, enum sbi_sse_state *state)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	if (ret) {
+		report_fail("Failed to get SSE event status");
+		return -1;
+	}
+
+	*state = status & SBI_SSE_ATTR_STATUS_STATE_MASK;
+
+	return 0;
+}
+
+static void sse_global_event_set_current_hart(unsigned long event_id)
+{
+	int ret;
+
+	if (!sse_event_is_global(event_id))
+		return;
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+				 current_thread_info()->hartid);
+	if (ret)
+		report_abort("set preferred hart failure");
+}
+
+static int sse_check_state(unsigned long event_id, unsigned long expected_state)
+{
+	int ret;
+	enum sbi_sse_state state;
+
+	ret = sse_get_state(event_id, &state);
+	if (ret)
+		return 1;
+	report(state == expected_state, "SSE event status == %ld", expected_state);
+
+	return state != expected_state;
+}
+
+static bool sse_event_pending(unsigned long event_id)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	if (ret) {
+		report_fail("Failed to get SSE event status");
+		return false;
+	}
+
+	return !!(status & BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET));
+}
+
+static void *sse_alloc_stack(void)
+{
+	return (alloc_page() + SSE_STACK_SIZE);
+}
+
+static void sse_free_stack(void *stack)
+{
+	free_page(stack - SSE_STACK_SIZE);
+}
+
+static void sse_test_attr(unsigned long event_id)
+{
+	unsigned long ret, value = 0;
+	unsigned long values[ARRAY_SIZE(ro_attrs)];
+	struct sbiret sret;
+	unsigned int i;
+
+	report_prefix_push("attrs");
+
+	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
+		ret = sse_event_set_attr(event_id, ro_attrs[i], value);
+		report(ret == SBI_ERR_BAD_RANGE, "RO attribute %s not writable",
+		       attr_names[ro_attrs[i]]);
+	}
+
+	for (i = SBI_SSE_ATTR_STATUS; i <= SBI_SSE_ATTR_INTERRUPTED_A7; i++) {
+		ret = sse_event_get_attr(event_id, i, &value);
+		report(ret == SBI_SUCCESS, "Read single attribute %s", attr_names[i]);
+		/* Preferred Hart reset value is defined by SBI vendor and status injectable bit
+		 * also depends on the SBI implementation
+		 */
+		if (i != SBI_SSE_ATTR_STATUS && i != SBI_SSE_ATTR_PREFERRED_HART)
+			report(value == 0, "Attribute %s reset value is 0", attr_names[i]);
+	}
+
+	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_STATUS, values,
+				  SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_STATUS);
+	report(ret == SBI_SUCCESS, "Read multiple attributes");
+
+#if __riscv_xlen > 32
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, 0xFFFFFFFFUL + 1UL);
+	report(ret == SBI_ERR_INVALID_PARAM, "Write prio > 0xFFFFFFFF error");
+#endif
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, ~SBI_SSE_ATTR_CONFIG_ONESHOT);
+	report(ret == SBI_ERR_INVALID_PARAM, "Write invalid config error");
+
+	if (sse_event_is_global(event_id)) {
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, 0xFFFFFFFFUL);
+		report(ret == SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
+	} else {
+		/* Set Hart on local event -> RO */
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+					 current_thread_info()->hartid);
+		report(ret == SBI_ERR_BAD_RANGE, "Set hart id on local event error");
+	}
+
+	/* Set/get flags, sepc, a6, a7 */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		ret = sse_event_get_attr(event_id, interrupted_attrs[i], &value);
+		report(ret == 0, "Get interrupted %s no error", attr_names[interrupted_attrs[i]]);
+
+		/* 0x1 is a valid value for all the interrupted attributes */
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 0x1);
+		report(ret == SBI_ERR_INVALID_STATE, "Set interrupted flags invalid state error");
+	}
+
+	/* Attr_count == 0 */
+	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
+	report(sret.error == SBI_ERR_INVALID_PARAM, "Read attribute attr_count == 0 error");
+
+	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
+	report(sret.error == SBI_ERR_INVALID_PARAM, "Write attribute attr_count == 0 error");
+
+	/* Invalid attribute id */
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, &value);
+	report(ret == SBI_ERR_BAD_RANGE, "Read invalid attribute error");
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, value);
+	report(ret == SBI_ERR_BAD_RANGE, "Write invalid attribute error");
+
+	/* Misaligned phys address */
+	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
+				      ((unsigned long) &value | 0x1), 0);
+	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Read attribute with invalid address error");
+	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
+				      ((unsigned long) &value | 0x1), 0);
+	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Write attribute with invalid address error");
+
+	report_prefix_pop();
+}
+
+static void sse_test_register_error(unsigned long event_id)
+{
+	unsigned long ret;
+
+	report_prefix_push("register");
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_ERR_INVALID_STATE, "SSE unregister non registered event");
+
+	ret = sse_event_register_raw(event_id, (void *) 0x1, NULL);
+	report(ret == SBI_ERR_INVALID_PARAM, "SSE register misaligned entry");
+
+	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
+	report(ret == SBI_SUCCESS, "SSE register ok");
+	if (ret)
+		goto done;
+
+	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
+	report(ret == SBI_ERR_INVALID_STATE, "SSE register twice failure");
+	if (!ret)
+		goto done;
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_SUCCESS, "SSE unregister ok");
+
+done:
+	report_prefix_pop();
+}
+
+struct sse_simple_test_arg {
+	bool done;
+	unsigned long expected_a6;
+	unsigned long event_id;
+};
+
+static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	volatile struct sse_simple_test_arg *arg = data;
+	int ret, i;
+	const char *attr_name;
+	unsigned long event_id = arg->event_id, value, prev_value, flags, attr;
+	const unsigned long regs_len = (SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_INTERRUPTED_A6) +
+				       1;
+	unsigned long interrupted_state[regs_len];
+
+	if ((regs->status & SSTATUS_SPP) == 0)
+		report_fail("Interrupted S-mode");
+
+	if (hartid != current_thread_info()->hartid)
+		report_fail("Hartid correctly passed");
+
+	sse_check_state(event_id, SBI_SSE_STATE_RUNNING);
+	if (sse_event_pending(event_id))
+		report_fail("Event is not pending");
+
+	/* Set a6, a7, sepc, flags while running */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		attr = interrupted_attrs[i];
+		attr_name = attr_names[attr];
+
+		ret = sse_event_get_attr(event_id, attr, &prev_value);
+		report(ret == 0, "Get attr %s no error", attr_name);
+
+		/* We test SBI_SSE_ATTR_INTERRUPTED_FLAGS below with specific flag values */
+		if (attr == SBI_SSE_ATTR_INTERRUPTED_FLAGS)
+			continue;
+
+		ret = sse_event_set_attr(event_id, attr, 0xDEADBEEF + i);
+		report(ret == 0, "Set attr %s invalid state no error", attr_name);
+
+		ret = sse_event_get_attr(event_id, attr, &value);
+		report(ret == 0, "Get attr %s modified value no error", attr_name);
+		report(value == 0xDEADBEEF + i, "Get attr %s modified value ok", attr_name);
+
+		ret = sse_event_set_attr(event_id, attr, prev_value);
+		report(ret == 0, "Restore attr %s value no error", attr_name);
+	}
+
+	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS*/
+	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
+	attr_name = attr_names[attr];
+	ret = sse_event_get_attr(event_id, attr, &prev_value);
+	report(ret == 0, "Get attr %s no error", attr_name);
+
+	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
+		flags = interrupted_flags[i];
+		ret = sse_event_set_attr(event_id, attr, flags);
+		report(ret == 0, "Set interrupted %s value no error", attr_name);
+		ret = sse_event_get_attr(event_id, attr, &value);
+		report(value == flags, "Get attr %s modified value ok", attr_name);
+	}
+
+	ret = sse_event_set_attr(event_id, attr, prev_value);
+		report(ret == 0, "Restore attr %s value no error", attr_name);
+
+	/* Try to change HARTID/Priority while running */
+	if (sse_event_is_global(event_id)) {
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+					 current_thread_info()->hartid);
+		report(ret == SBI_ERR_INVALID_STATE, "Set hart id while running error");
+	}
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, 0);
+	report(ret == SBI_ERR_INVALID_STATE, "Set priority while running error");
+
+	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_A6, interrupted_state,
+				  regs_len);
+	report(ret == SBI_SUCCESS, "Read interrupted context from SSE handler ok");
+	if (interrupted_state[0] != arg->expected_a6)
+		report_fail("Interrupted state a6 check ok");
+	if (interrupted_state[1] != SBI_EXT_SSE)
+		report_fail("Interrupted state a7 check ok");
+
+	arg->done = true;
+}
+
+static void sse_test_inject_simple(unsigned long event_id)
+{
+	unsigned long ret;
+	struct sse_handler_arg args;
+	volatile struct sse_simple_test_arg test_arg = {.event_id = event_id, .done = 0};
+
+	args.handler = sse_simple_handler;
+	args.handler_data = (void *) &test_arg;
+	args.stack = sse_alloc_stack();
+
+	report_prefix_push("simple");
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
+	if (ret)
+		goto done;
+
+	ret = sse_event_register(event_id, &args);
+	report(ret == SBI_SUCCESS, "SSE register no error");
+	if (ret)
+		goto done;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
+	if (ret)
+		goto done;
+
+	/* Be sure global events are targeting the current hart */
+	sse_global_event_set_current_hart(event_id);
+
+	ret = sse_event_enable(event_id);
+	report(ret == SBI_SUCCESS, "SSE enable no error");
+	if (ret)
+		goto done;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_ENABLED);
+	if (ret)
+		goto done;
+
+	ret = sse_hart_mask();
+	report(ret == SBI_SUCCESS, "SSE hart mask no error");
+
+	ret = sse_event_inject(event_id, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection masked no error");
+	if (ret)
+		goto done;
+
+	barrier();
+	report(test_arg.done == 0, "SSE event masked not handled");
+
+	/*
+	 * When unmasking the SSE events, we expect it to be injected
+	 * immediately so a6 should be SBI_EXT_SSE_HART_UNMASK
+	 */
+	test_arg.expected_a6 = SBI_EXT_SSE_HART_UNMASK;
+	ret = sse_hart_unmask();
+	report(ret == SBI_SUCCESS, "SSE hart unmask no error");
+
+	barrier();
+	report(test_arg.done == 1, "SSE event unmasked handled");
+	test_arg.done = 0;
+	test_arg.expected_a6 = SBI_EXT_SSE_INJECT;
+
+	/* Set as oneshot and verify it is disabled */
+	ret = sse_event_disable(event_id);
+	report(ret == 0, "Disable event ok");
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, SBI_SSE_ATTR_CONFIG_ONESHOT);
+	report(ret == 0, "Set event attribute as ONESHOT");
+	ret = sse_event_enable(event_id);
+	report(ret == 0, "Enable event ok");
+
+	ret = sse_event_inject(event_id, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection 2 no error");
+	if (ret)
+		goto done;
+
+	barrier();
+	report(test_arg.done == 1, "SSE event handled ok");
+	test_arg.done = 0;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
+	if (ret)
+		goto done;
+
+	/* Clear ONESHOT FLAG */
+	sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, 0);
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_SUCCESS, "SSE unregister no error");
+	if (ret)
+		goto done;
+
+	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
+
+done:
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct sse_foreign_cpu_test_arg {
+	bool done;
+	unsigned int expected_cpu;
+	unsigned long event_id;
+};
+
+static void sse_foreign_cpu_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	volatile struct sse_foreign_cpu_test_arg *arg = data;
+
+	/* For arg content to be visible */
+	smp_rmb();
+	if (arg->expected_cpu != current_thread_info()->cpu)
+		report_fail("Received event on CPU (%d), expected CPU (%d)",
+			    current_thread_info()->cpu, arg->expected_cpu);
+
+	arg->done = true;
+	/* For arg update to be visible for other CPUs */
+	smp_wmb();
+}
+
+struct sse_local_per_cpu {
+	struct sse_handler_arg args;
+	unsigned long ret;
+};
+
+struct sse_local_data {
+	unsigned long event_id;
+	struct sse_local_per_cpu *cpu_args[NR_CPUS];
+};
+
+static void sse_register_enable_local(void *data)
+{
+	struct sse_local_data *local_data = data;
+	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
+
+	cpu_arg->ret = sse_event_register(local_data->event_id, &cpu_arg->args);
+	if (cpu_arg->ret)
+		return;
+
+	cpu_arg->ret = sse_event_enable(local_data->event_id);
+}
+
+static void sse_disable_unregister_local(void *data)
+{
+	struct sse_local_data *local_data = data;
+	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
+
+	cpu_arg->ret = sse_event_disable(local_data->event_id);
+	if (cpu_arg->ret)
+		return;
+
+	cpu_arg->ret = sse_event_unregister(local_data->event_id);
+}
+
+static void sse_test_inject_local(unsigned long event_id)
+{
+	int cpu;
+	unsigned long ret;
+	struct sse_local_data local_data;
+	struct sse_local_per_cpu *cpu_arg;
+	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
+
+	report_prefix_push("local_dispatch");
+	local_data.event_id = event_id;
+
+	for_each_online_cpu(cpu) {
+		cpu_arg = calloc(1, sizeof(struct sse_handler_arg));
+
+		cpu_arg->args.stack = sse_alloc_stack();
+		cpu_arg->args.handler = sse_foreign_cpu_handler;
+		cpu_arg->args.handler_data = (void *)&test_arg;
+		local_data.cpu_args[cpu] = cpu_arg;
+	}
+
+	on_cpus(sse_register_enable_local, &local_data);
+	for_each_online_cpu(cpu) {
+		if (local_data.cpu_args[cpu]->ret)
+			report_abort("CPU failed to register/enable SSE event");
+
+		test_arg.expected_cpu = cpu;
+		/* For test_arg content to be visible for other CPUs */
+		smp_wmb();
+		ret = sse_event_inject(event_id, cpus[cpu].hartid);
+		if (ret)
+			report_abort("CPU failed to register/enable SSE event");
+
+		while (!test_arg.done) {
+			/* For test_arg update to be visible */
+			smp_rmb();
+		}
+
+		test_arg.done = false;
+	}
+
+	on_cpus(sse_disable_unregister_local, &local_data);
+	for_each_online_cpu(cpu) {
+		if (local_data.cpu_args[cpu]->ret)
+			report_abort("CPU failed to disable/unregister SSE event");
+	}
+
+	for_each_online_cpu(cpu) {
+		cpu_arg = local_data.cpu_args[cpu];
+
+		sse_free_stack(cpu_arg->args.stack);
+	}
+
+	report_pass("local event dispatch on all CPUs");
+	report_prefix_pop();
+
+}
+
+static void sse_test_inject_global(unsigned long event_id)
+{
+	unsigned long ret;
+	unsigned int cpu;
+	struct sse_handler_arg args;
+	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
+	enum sbi_sse_state state;
+
+	args.handler = sse_foreign_cpu_handler;
+	args.handler_data = (void *)&test_arg;
+	args.stack = sse_alloc_stack();
+
+	report_prefix_push("global_dispatch");
+
+	ret = sse_event_register(event_id, &args);
+	if (ret)
+		goto done;
+
+	for_each_online_cpu(cpu) {
+		test_arg.expected_cpu = cpu;
+		/* For test_arg content to be visible for other CPUs */
+		smp_wmb();
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, cpu);
+		if (ret) {
+			report_fail("Failed to set preferred hart");
+			goto done;
+		}
+
+		ret = sse_event_enable(event_id);
+		if (ret) {
+			report_fail("Failed to enable SSE event");
+			goto done;
+		}
+
+		ret = sse_event_inject(event_id, cpu);
+		if (ret) {
+			report_fail("Failed to inject event");
+			goto done;
+		}
+
+		while (!test_arg.done) {
+			/* For shared test_arg structure */
+			smp_rmb();
+		}
+
+		test_arg.done = false;
+
+		/* Wait for event to be in ENABLED state */
+		do {
+			ret = sse_get_state(event_id, &state);
+			if (ret) {
+				report_fail("Failed to get event state");
+				goto done;
+			}
+		} while (state != SBI_SSE_STATE_ENABLED);
+
+		ret = sse_event_disable(event_id);
+		if (ret) {
+			report_fail("Failed to disable SSE event");
+			goto done;
+		}
+
+		report_pass("Global event on CPU %d", cpu);
+	}
+
+done:
+	ret = sse_event_unregister(event_id);
+	if (ret)
+		report_fail("Failed to unregister event");
+
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct priority_test_arg {
+	unsigned long evt;
+	bool called;
+	u32 prio;
+	struct priority_test_arg *next_evt_arg;
+	void (*check_func)(struct priority_test_arg *arg);
+};
+
+static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
+					 unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_evt_arg;
+
+	targ->called = 1;
+	if (next) {
+		sse_event_inject(next->evt, current_thread_info()->hartid);
+		if (sse_event_pending(next->evt))
+			report_fail("Higher priority event is pending");
+		if (!next->called)
+			report_fail("Higher priority event was not handled");
+	}
+}
+
+static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
+					  unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_evt_arg;
+
+	targ->called = 1;
+
+	if (next) {
+		sse_event_inject(next->evt, current_thread_info()->hartid);
+
+		if (!sse_event_pending(next->evt))
+			report_fail("Lower priority event is pending");
+
+		if (next->called)
+			report_fail("Lower priority event %s was handle before %s",
+			      sse_evt_name(next->evt), sse_evt_name(targ->evt));
+	}
+}
+
+static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
+					    unsigned int in_args_size,
+					    sse_handler_fn handler,
+					    const char *test_name)
+{
+	unsigned int i;
+	int ret;
+	unsigned long event_id;
+	struct priority_test_arg *arg;
+	unsigned int args_size = 0;
+	struct sse_handler_arg event_args[in_args_size];
+	struct priority_test_arg *args[in_args_size];
+	void *stack;
+	struct sse_handler_arg *event_arg;
+
+	report_prefix_push(test_name);
+
+	for (i = 0; i < in_args_size; i++) {
+		arg = &in_args[i];
+		event_id = arg->evt;
+		if (!sse_evt_can_inject(event_id))
+			continue;
+
+		args[args_size] = arg;
+		args_size++;
+	}
+
+	if (!args_size) {
+		report_skip("No event injectable");
+		report_prefix_pop();
+		goto skip;
+	}
+
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->evt;
+		stack = sse_alloc_stack();
+
+		event_arg = &event_args[i];
+		event_arg->handler = handler;
+		event_arg->handler_data = (void *)arg;
+		event_arg->stack = stack;
+
+		if (i < (args_size - 1))
+			arg->next_evt_arg = args[i + 1];
+		else
+			arg->next_evt_arg = NULL;
+
+		/* Be sure global events are targeting the current hart */
+		sse_global_event_set_current_hart(event_id);
+
+		sse_event_register(event_id, event_arg);
+		sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, arg->prio);
+		sse_event_enable(event_id);
+	}
+
+	/* Inject first event */
+	ret = sse_event_inject(args[0]->evt, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection no error");
+
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->evt;
+
+		if (!arg->called)
+			report_fail("Event %s handler called", sse_evt_name(arg->evt));
+
+		sse_event_disable(event_id);
+		sse_event_unregister(event_id);
+
+		event_arg = &event_args[i];
+		sse_free_stack(event_arg->stack);
+	}
+
+skip:
+	report_prefix_pop();
+}
+
+static struct priority_test_arg hi_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
+};
+
+static struct priority_test_arg low_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+};
+
+static struct priority_test_arg prio_args[] = {
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 5},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 15},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 25},
+};
+
+static struct priority_test_arg same_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 0},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 10},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
+};
+
+static void sse_test_injection_priority(void)
+{
+	report_prefix_push("prio");
+
+	sse_test_injection_priority_arg(hi_prio_args, ARRAY_SIZE(hi_prio_args),
+					sse_hi_priority_test_handler, "high");
+
+	sse_test_injection_priority_arg(low_prio_args, ARRAY_SIZE(low_prio_args),
+					sse_low_priority_test_handler, "low");
+
+	sse_test_injection_priority_arg(prio_args, ARRAY_SIZE(prio_args),
+					sse_low_priority_test_handler, "changed");
+
+	sse_test_injection_priority_arg(same_prio_args, ARRAY_SIZE(same_prio_args),
+					sse_low_priority_test_handler, "same_prio_args");
+
+	report_prefix_pop();
+}
+
+static bool sse_can_inject(unsigned long event_id)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	report(ret == 0, "SSE get attr status no error");
+	if (ret)
+		return 0;
+
+	return !!(status & BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET));
+}
+
+static void boot_secondary(void *data)
+{
+	sse_hart_unmask();
+}
+
+static void sse_check_mask(void)
+{
+	int ret;
+
+	/* Upon boot, event are masked, check that */
+	ret = sse_hart_mask();
+	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask at boot time ok");
+
+	ret = sse_hart_unmask();
+	report(ret == SBI_SUCCESS, "SSE hart no error ok");
+	ret = sse_hart_unmask();
+	report(ret == SBI_ERR_ALREADY_STOPPED, "SSE hart unmask twice error ok");
+
+	ret = sse_hart_mask();
+	report(ret == SBI_SUCCESS, "SSE hart mask no error");
+	ret = sse_hart_mask();
+	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask twice ok");
+}
+
+void check_sse(void)
+{
+	unsigned long i, event;
+
+	report_prefix_push("sse");
+	sse_check_mask();
+
+	/*
+	 * Dummy wakeup of all processors since some of them will be targeted
+	 * by global events without going through the wakeup call as well as
+	 * unmasking all 
+	 */
+	on_cpus(boot_secondary, NULL);
+
+	if (!sbi_probe(SBI_EXT_SSE)) {
+		report_skip("SSE extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		event = sse_event_infos[i].event_id;
+		report_prefix_push(sse_event_infos[i].name);
+		if (!sse_can_inject(event)) {
+			report_skip("Event does not support injection");
+			report_prefix_pop();
+			continue;
+		} else {
+			sse_event_infos[i].can_inject = true;
+		}
+		sse_test_attr(event);
+		sse_test_register_error(event);
+		sse_test_inject_simple(event);
+		if (sse_event_is_global(event))
+			sse_test_inject_global(event);
+		else
+			sse_test_inject_local(event);
+
+		report_prefix_pop();
+	}
+
+	sse_test_injection_priority();
+
+	report_prefix_pop();
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6f4ddaf1..33d5e40d 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,8 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_sse(void);
+
 static long __labs(long a)
 {
 	return __builtin_labs(a);
@@ -1451,6 +1453,7 @@ int main(int argc, char **argv)
 	check_hsm();
 	check_dbcn();
 	check_susp();
+	check_sse();
 
 	return report_summary();
 }
-- 
2.45.2


