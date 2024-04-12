Return-Path: <kvm+bounces-14504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D97A88A2C75
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 062671C22674
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA7956B71;
	Fri, 12 Apr 2024 10:34:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26E356B68
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918097; cv=none; b=cvOq50mH0kj3OHEvOmqmbKTNQ5Sr3eHRpoE+lu4yD3su4bx14POjGM2hI26bfdR227trVrjd6cY3vbF4IQwTbu7NWz+1447GMX3xuckGdmyrxV0pTz7aj+S/N/TYyn2Vko1Q8vicW7zZYsaFUlL+Mzxvh+ZZ8YxMYOOtopUcxMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918097; c=relaxed/simple;
	bh=a0LyLT4AlkjiccHn5dWwkFGRwYBOQwnXbsbfxKM7S8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+L4IZ2FLtEjOQ08kB9LFY326nNf6DNj45VdqqxtvJRR2b4IqtgpPnRnD5s9/87DHydXaKyoThVxFX0RsKadJZTXSBrM4qxWougEhHa3xvyeQiS85hHrT3E4z9LUa+2KkbHrYHy5qbi6Y4jhBmI3nJFHYZvb/qSaXz3HYR5V7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1B60339;
	Fri, 12 Apr 2024 03:35:24 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7D7603F64C;
	Fri, 12 Apr 2024 03:34:53 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Subhasish Ghosh <subhasish.ghosh@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 18/33] arm: realm: Add test for FPU/SIMD context save/restore
Date: Fri, 12 Apr 2024 11:33:53 +0100
Message-Id: <20240412103408.2706058-19-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Subhasish Ghosh <subhasish.ghosh@arm.com>

Test that the FPU/SIMD registers are saved and restored correctly when
context switching CPUs.

In order to test fpu/simd functionality, we need to make sure that
kvm-unit-tests doesn't generate code that uses the fpu registers, as that
might interfere with the test results. Thus make sure we compile the tests
with -mgeneral-regs-only.

Signed-off-by: Subhasish Ghosh <subhasish.ghosh@arm.com>
[ Added SVE register tests ]
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64        |   9 +
 arm/cstart64.S            |   1 +
 arm/fpu.c                 | 424 ++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |   8 +
 lib/arm64/asm/processor.h |  26 +++
 lib/arm64/asm/sysreg.h    |   7 +
 6 files changed, 475 insertions(+)
 create mode 100644 arm/fpu.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 90d95e79..5a9943c8 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -10,9 +10,17 @@ arch_LDFLAGS = -pie -n
 arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
 
+sve_flag := $(call cc-option, -march=armv8.5-a+sve, "")
+ifneq ($(strip $(sve_flag)),)
+# Don't pass the option to the compiler, we don't
+# want the compiler to generate SVE instructions.
+CFLAGS += -DCC_HAS_SVE
+endif
+
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
 CFLAGS += -DCONFIG_RELOC
+CFLAGS += -mgeneral-regs-only
 
 define arch_elf_check =
 	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
@@ -49,6 +57,7 @@ tests = $(TEST_DIR)/timer.$(exe)
 tests += $(TEST_DIR)/micro-bench.$(exe)
 tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
+tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/realm-rsi.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/arm/cstart64.S b/arm/cstart64.S
index c081365f..53acf796 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -12,6 +12,7 @@
 #include <asm/ptrace.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
+#include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 #include <asm/smc-rsi.h>
diff --git a/arm/fpu.c b/arm/fpu.c
new file mode 100644
index 00000000..06e5a845
--- /dev/null
+++ b/arm/fpu.c
@@ -0,0 +1,424 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <stdlib.h>
+
+#include <asm/rsi.h>
+
+#define CPU0_ID			0
+#define CPU1_ID			(CPU0_ID + 1)
+#define CPUS_MAX		(CPU1_ID + 1)
+#define FPU_QREG_MAX	32
+#define FPU_RESULT_PASS	(-1U)
+
+/*
+ * Write 8 bytes of random data in random. Returns true on success, false on
+ * failure.
+ */
+static inline bool arch_collect_entropy(uint64_t *random)
+{
+	unsigned long ret;
+
+	asm volatile(
+	"	mrs  %[ptr], " xstr(RNDR) "\n"
+	"	cset %[ret], ne\n" /* RNDR sets NZCV to 0b0100 on failure */
+	:
+	  [ret] "=r" (ret),
+	  [ptr] "=r" (*random)
+	:
+	: "cc"
+	);
+
+	return ret == 1;
+}
+
+#define fpu_reg_read(val)				\
+({							\
+	uint64_t *__val = (val);			\
+	asm volatile("stp q0, q1, [%0], #32\n\t"	\
+		     "stp q2, q3, [%0], #32\n\t"	\
+		     "stp q4, q5, [%0], #32\n\t"	\
+		     "stp q6, q7, [%0], #32\n\t"	\
+		     "stp q8, q9, [%0], #32\n\t"	\
+		     "stp q10, q11, [%0], #32\n\t"	\
+		     "stp q12, q13, [%0], #32\n\t"	\
+		     "stp q14, q15, [%0], #32\n\t"	\
+		     "stp q16, q17, [%0], #32\n\t"	\
+		     "stp q18, q19, [%0], #32\n\t"	\
+		     "stp q20, q21, [%0], #32\n\t"	\
+		     "stp q22, q23, [%0], #32\n\t"	\
+		     "stp q24, q25, [%0], #32\n\t"	\
+		     "stp q26, q27, [%0], #32\n\t"	\
+		     "stp q28, q29, [%0], #32\n\t"	\
+		     "stp q30, q31, [%0], #32\n\t"	\
+		     : "=r" (__val)			\
+		     :					\
+		     : "q0", "q1", "q2", "q3",		\
+			"q4", "q5", "q6", "q7",		\
+			"q8", "q9", "q10", "q11",	\
+			"q12", "q13", "q14",		\
+			"q15", "q16", "q17",		\
+			"q18", "q19", "q20",		\
+			"q21", "q22", "q23",		\
+			"q24", "q25", "q26",		\
+			"q27", "q28", "q29",		\
+			"q30", "q31", "memory");	\
+})
+
+#define fpu_reg_write(val)				\
+do {							\
+	uint64_t *__val = (val);			\
+	asm volatile("ldp q0, q1, [%0], #32\n\t"	\
+		     "ldp q2, q3, [%0], #32\n\t"	\
+		     "ldp q4, q5, [%0], #32\n\t"	\
+		     "ldp q6, q7, [%0], #32\n\t"	\
+		     "ldp q8, q9, [%0], #32\n\t"	\
+		     "ldp q10, q11, [%0], #32\n\t"	\
+		     "ldp q12, q13, [%0], #32\n\t"	\
+		     "ldp q14, q15, [%0], #32\n\t"	\
+		     "ldp q16, q17, [%0], #32\n\t"	\
+		     "ldp q18, q19, [%0], #32\n\t"	\
+		     "ldp q20, q21, [%0], #32\n\t"	\
+		     "ldp q22, q23, [%0], #32\n\t"	\
+		     "ldp q24, q25, [%0], #32\n\t"	\
+		     "ldp q26, q27, [%0], #32\n\t"	\
+		     "ldp q28, q29, [%0], #32\n\t"	\
+		     "ldp q30, q31, [%0], #32\n\t"	\
+		     :					\
+		     : "r" (__val)			\
+		     : "q0", "q1", "q2", "q3",		\
+			"q4", "q5", "q6", "q7",		\
+			"q8", "q9", "q10", "q11",	\
+			"q12", "q13", "q14",		\
+			"q15", "q16", "q17",		\
+			"q18", "q19", "q20",		\
+			"q21", "q22", "q23",		\
+			"q24", "q25", "q26",		\
+			"q27", "q28", "q29",		\
+			"q30", "q31", "memory");	\
+} while (0)
+
+#ifdef CC_HAS_SVE
+#define sve_reg_read(val)				\
+({							\
+	uint64_t *__val = (val);			\
+	asm volatile(".arch_extension sve\n"		\
+		     "str z0, [%0, #0, MUL VL]\n"	\
+		     "str z1, [%0, #1, MUL VL]\n"	\
+		     "str z2, [%0, #2, MUL VL]\n"	\
+		     "str z3, [%0, #3, MUL VL]\n"	\
+		     "str z4, [%0, #4, MUL VL]\n"	\
+		     "str z5, [%0, #5, MUL VL]\n"	\
+		     "str z6, [%0, #6, MUL VL]\n"	\
+		     "str z7, [%0, #7, MUL VL]\n"	\
+		     "str z8, [%0, #8, MUL VL]\n"	\
+		     "str z9, [%0, #9, MUL VL]\n"	\
+		     "str z10, [%0, #10, MUL VL]\n"	\
+		     "str z11, [%0, #11, MUL VL]\n"	\
+		     "str z12, [%0, #12, MUL VL]\n"	\
+		     "str z13, [%0, #13, MUL VL]\n"	\
+		     "str z14, [%0, #14, MUL VL]\n"	\
+		     "str z15, [%0, #15, MUL VL]\n"	\
+		     "str z16, [%0, #16, MUL VL]\n"	\
+		     "str z17, [%0, #17, MUL VL]\n"	\
+		     "str z18, [%0, #18, MUL VL]\n"	\
+		     "str z19, [%0, #19, MUL VL]\n"	\
+		     "str z20, [%0, #20, MUL VL]\n"	\
+		     "str z21, [%0, #21, MUL VL]\n"	\
+		     "str z22, [%0, #22, MUL VL]\n"	\
+		     "str z23, [%0, #23, MUL VL]\n"	\
+		     "str z24, [%0, #24, MUL VL]\n"	\
+		     "str z25, [%0, #25, MUL VL]\n"	\
+		     "str z26, [%0, #26, MUL VL]\n"	\
+		     "str z27, [%0, #27, MUL VL]\n"	\
+		     "str z28, [%0, #28, MUL VL]\n"	\
+		     "str z29, [%0, #29, MUL VL]\n"	\
+		     "str z30, [%0, #30, MUL VL]\n"	\
+		     "str z31, [%0, #31, MUL VL]\n"	\
+		     : "=r" (__val)			\
+		     :					\
+		     : "z0", "z1", "z2", "z3",		\
+			"z4", "z5", "z6", "z7",		\
+			"z8", "z9", "z10", "z11",	\
+			"z12", "z13", "z14",		\
+			"z15", "z16", "z17",		\
+			"z18", "z19", "z20",		\
+			"z21", "z22", "z23",		\
+			"z24", "z25", "z26",		\
+			"z27", "z28", "z29",		\
+			"z30", "z31", "memory");	\
+})
+
+#define sve_reg_write(val)				\
+({							\
+	uint64_t *__val = (val);			\
+	asm volatile(".arch_extension sve\n"		\
+		     "ldr z0, [%0, #0, MUL VL]\n"	\
+		     "ldr z1, [%0, #1, MUL VL]\n"	\
+		     "ldr z2, [%0, #2, MUL VL]\n"	\
+		     "ldr z3, [%0, #3, MUL VL]\n"	\
+		     "ldr z4, [%0, #4, MUL VL]\n"	\
+		     "ldr z5, [%0, #5, MUL VL]\n"	\
+		     "ldr z6, [%0, #6, MUL VL]\n"	\
+		     "ldr z7, [%0, #7, MUL VL]\n"	\
+		     "ldr z8, [%0, #8, MUL VL]\n"	\
+		     "ldr z9, [%0, #9, MUL VL]\n"	\
+		     "ldr z10, [%0, #10, MUL VL]\n"	\
+		     "ldr z11, [%0, #11, MUL VL]\n"	\
+		     "ldr z12, [%0, #12, MUL VL]\n"	\
+		     "ldr z13, [%0, #13, MUL VL]\n"	\
+		     "ldr z14, [%0, #14, MUL VL]\n"	\
+		     "ldr z15, [%0, #15, MUL VL]\n"	\
+		     "ldr z16, [%0, #16, MUL VL]\n"	\
+		     "ldr z17, [%0, #17, MUL VL]\n"	\
+		     "ldr z18, [%0, #18, MUL VL]\n"	\
+		     "ldr z19, [%0, #19, MUL VL]\n"	\
+		     "ldr z20, [%0, #20, MUL VL]\n"	\
+		     "ldr z21, [%0, #21, MUL VL]\n"	\
+		     "ldr z22, [%0, #22, MUL VL]\n"	\
+		     "ldr z23, [%0, #23, MUL VL]\n"	\
+		     "ldr z24, [%0, #24, MUL VL]\n"	\
+		     "ldr z25, [%0, #25, MUL VL]\n"	\
+		     "ldr z26, [%0, #26, MUL VL]\n"	\
+		     "ldr z27, [%0, #27, MUL VL]\n"	\
+		     "ldr z28, [%0, #28, MUL VL]\n"	\
+		     "ldr z29, [%0, #29, MUL VL]\n"	\
+		     "ldr z30, [%0, #30, MUL VL]\n"	\
+		     "ldr z31, [%0, #31, MUL VL]\n"	\
+		     :					\
+		     : "r" (__val)			\
+		     : "z0", "z1", "z2", "z3",		\
+			"z4", "z5", "z6", "z7",		\
+			"z8", "z9", "z10", "z11",	\
+			"z12", "z13", "z14",		\
+			"z15", "z16", "z17",		\
+			"z18", "z19", "z20",		\
+			"z21", "z22", "z23",		\
+			"z24", "z25", "z26",		\
+			"z27", "z28", "z29",		\
+			"z30", "z31", "memory");	\
+})
+#else
+#define sve_reg_read(val)	report_abort("SVE: not supported")
+#define sve_reg_write(val)	report_abort("SVE: not supported")
+#endif
+
+static void nr_cpu_check(int nr)
+{
+	if (nr_cpus < nr)
+		report_abort("At least %d cpus required", nr);
+}
+
+/**
+ * @brief check if the FPU/SIMD/SVE register contents are the same as
+ * the input data provided.
+ */
+static uint32_t __fpuregs_testall(uint64_t *indata, int sve)
+{
+	/* 128b aligned array to read data into */
+	uint64_t outdata[FPU_QREG_MAX * 2]
+			 __attribute__((aligned(sizeof(__uint128_t)))) = {
+			[0 ... ((FPU_QREG_MAX * 2) - 1)] = 0 };
+	uint8_t regcnt	= 0;
+	uint32_t result	= 0;
+
+	if (indata == NULL)
+		report_abort("invalid data pointer received");
+
+	/* Read data from FPU/SVE registers */
+	if (sve)
+		sve_reg_read(outdata);
+	else
+		fpu_reg_read(outdata);
+
+	/* Check is the data is the same */
+	for (regcnt = 0; regcnt < (FPU_QREG_MAX * 2); regcnt += 2) {
+		if ((outdata[regcnt] != indata[regcnt]) ||
+			(outdata[regcnt + 1] != indata[regcnt + 1])) {
+			report_info(
+			"%s save/restore failed for reg: %c%u expected: %lx_%lx received: %lx_%lx\n",
+			sve ? "SVE" : "FPU/SIMD",
+			sve ? 'z' : 'q',
+			regcnt / 2,
+			indata[regcnt + 1], indata[regcnt],
+			outdata[regcnt + 1], outdata[regcnt]);
+		} else {
+			/* populate a bitmask indicating which
+			 * registers passed/failed
+			 */
+			result |= (1 << (regcnt / 2));
+		}
+	}
+
+	return result;
+}
+
+/**
+ * @brief writes randomly sampled data into the FPU/SIMD registers.
+ */
+static void __fpuregs_writeall_random(uint64_t **indata, int sve)
+{
+	/* allocate 128b aligned memory */
+	*indata = memalign(sizeof(__uint128_t), sizeof(uint64_t) * FPU_QREG_MAX);
+
+	if (system_supports_rndr()) {
+		/* Populate memory with random data */
+		for (unsigned int i = 0; i < (FPU_QREG_MAX * 2); i++)
+			while (!arch_collect_entropy(&(*indata)[i])) {}
+	} else {
+		/* Populate memory with data from the counter register */
+		for (unsigned int i = 0; i < (FPU_QREG_MAX * 2); i++)
+			(*indata)[i] = get_cntvct();
+	}
+
+	/* Write data into FPU registers */
+	if (sve)
+		sve_reg_write(*indata);
+	else
+		fpu_reg_write(*indata);
+}
+
+static void fpuregs_writeall_run(void *data)
+{
+	uint64_t **indata	= (uint64_t **)data;
+
+	__fpuregs_writeall_random(indata, 0);
+}
+
+static void sveregs_writeall_run(void *data)
+{
+	uint64_t **indata	= (uint64_t **)data;
+
+	__fpuregs_writeall_random(indata, 1);
+}
+
+static void fpuregs_testall_run(void *data)
+{
+	uint64_t *indata	= (uint64_t *)data;
+	uint32_t result		= 0;
+
+	result = __fpuregs_testall(indata, 0);
+	report((result == FPU_RESULT_PASS),
+	       "FPU/SIMD register save/restore mask: 0x%x", result);
+}
+
+static void sveregs_testall_run(void *data)
+{
+	uint64_t *indata	= (uint64_t *)data;
+	uint32_t result		= 0;
+
+	result = __fpuregs_testall(indata, 1);
+	report((result == FPU_RESULT_PASS),
+	       "SVE register save/restore mask: 0x%x", result);
+}
+
+/**
+ * @brief This test uses two CPUs to test FPU/SIMD save/restore
+ * @details CPU1 writes random data into FPU/SIMD registers,
+ * CPU0 corrupts/overwrites the data and finally CPU1 checks
+ * if the data remains unchanged in its context.
+ */
+static void fpuregs_context_switch_cpu1(int sve)
+{
+	int target		= CPU1_ID;
+	uint64_t *indata_remote	= NULL;
+	uint64_t *indata_local	= NULL;
+
+	/* write data from CPU1 */
+	on_cpu(target, sve ? sveregs_writeall_run
+	                   : fpuregs_writeall_run,
+	       &indata_remote);
+
+	/* Overwrite from CPU0 */
+	__fpuregs_writeall_random(&indata_local, sve);
+
+	/* Check data consistency */
+	on_cpu(target, sve ? sveregs_testall_run
+	                   : fpuregs_testall_run,
+	       indata_remote);
+
+	free(indata_remote);
+	free(indata_local);
+}
+
+/**
+ * @brief This test uses two CPUs to test FPU/SIMD save/restore
+ * @details CPU0 writes random data into FPU/SIMD registers,
+ * CPU1 corrupts/overwrites the data and finally CPU0 checks if
+ * the data remains unchanged in its context.
+ */
+static void fpuregs_context_switch_cpu0(int sve)
+{
+	int target		= CPU1_ID;
+	uint64_t *indata_local	= NULL;
+	uint64_t *indata_remote	= NULL;
+	uint32_t result		= 0;
+
+	/* write data from CPU0 */
+	__fpuregs_writeall_random(&indata_local, sve);
+
+	/* Overwrite from CPU1 */
+	on_cpu(target, sve ? sveregs_writeall_run
+	                   : fpuregs_writeall_run,
+	       &indata_remote);
+
+	/* Check data consistency */
+	result = __fpuregs_testall(indata_local, sve);
+	report((result == FPU_RESULT_PASS),
+	       "%s register save/restore mask: 0x%x", sve ? "SVE" : "FPU/SIMD", result);
+
+	free(indata_remote);
+	free(indata_local);
+}
+
+/**
+ * Checks if during context switch, FPU/SIMD registers
+ * are saved/restored.
+ */
+static void fpuregs_context_switch(void)
+{
+	fpuregs_context_switch_cpu0(0);
+	fpuregs_context_switch_cpu1(0);
+}
+
+/**
+ * Checks if during realm context switch, SVE registers
+ * are saved/restored.
+ */
+static void sveregs_context_switch(void)
+{
+	unsigned long zcr = read_sysreg(ZCR_EL1);
+
+	// Set the SVE vector length to 128-bits
+	write_sysreg(zcr & ~ZCR_EL1_LEN, ZCR_EL1);
+
+	fpuregs_context_switch_cpu0(1);
+	fpuregs_context_switch_cpu1(1);
+}
+
+static bool should_run_sve_tests(void)
+{
+#ifdef CC_HAS_SVE
+	if (system_supports_sve())
+		return true;
+#endif
+	return false;
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_pushf("fpu");
+
+	nr_cpu_check(CPUS_MAX);
+	fpuregs_context_switch();
+
+	if (should_run_sve_tests())
+		sveregs_context_switch();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index b5be6668..e35e8506 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -303,3 +303,11 @@ groups = nodefault realms
 extra_params = -append 'hvc'
 accel = kvm
 arch = arm64
+
+# FPU/SIMD test
+[fpu-context]
+file = fpu.flat
+smp = 2
+groups = nodefault realms
+accel = kvm
+arch = arm64
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 320ebaef..cc993c6a 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -122,6 +122,8 @@ static inline unsigned long get_id_aa64pfr0_el1(void)
 #define ID_AA64PFR0_EL1_EL3	(0xf << 12)
 #define ID_AA64PFR0_EL1_EL3_NI	(0x0 << 12)
 
+#define ID_AA64PFR0_EL1_SVE_SHIFT	32
+
 static inline bool system_supports_granule(size_t granule)
 {
 	u32 shift;
@@ -145,5 +147,29 @@ static inline bool system_supports_granule(size_t granule)
 	return ((mmfr0 >> shift) & 0xf) == val;
 }
 
+static inline bool system_supports_sve(void)
+{
+	return ((get_id_aa64pfr0_el1() >> ID_AA64PFR0_EL1_SVE_SHIFT) & 0xf) != 0;
+}
+
+static inline int sve_vl(void)
+{
+	int vl;
+
+	asm volatile(".arch_extension sve\n"
+		     "rdvl %0, #8"
+		     : "=r" (vl));
+
+	return vl;
+}
+
+
+static inline bool system_supports_rndr(void)
+{
+	u64 id_aa64isar0_el1 = read_sysreg(ID_AA64ISAR0_EL1);
+
+	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) != 0;
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 6cae8b84..f214a4f0 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -73,6 +73,8 @@ asm(
 );
 #endif /* __ASSEMBLY__ */
 
+#define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
+
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
@@ -102,4 +104,9 @@ asm(
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
 			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
 
+#define ZCR_EL1		S3_0_C1_C2_0
+#define ZCR_EL1_LEN	GENMASK(3, 0)
+
+#define RNDR		S3_3_C2_C4_0
+
 #endif /* _ASMARM64_SYSREG_H_ */
-- 
2.34.1


