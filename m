Return-Path: <kvm+bounces-16575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A564B8BBB41
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32B991F21D26
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEF322612;
	Sat,  4 May 2024 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dcHD+80u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A71B1C695
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825780; cv=none; b=LU9z9OJcqikJXwAPGRd7VmeOtqPCnCaqa3RBDef7WkDGLffm0fKOW1Se4dwHqb6j97Oz0/lrPRrJoge8iKGmw/arVwMxXsf/VRVjoH+o8rt4e3yIfuxAQ1vL0Hun/ljzoRmsowiS1CpD/9C6BMHF0uC+BTCcUkSBLIAuoYPi7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825780; c=relaxed/simple;
	bh=eKl/c9w296fWzdD2yF2/+kKN7QYxkAmXADgpO7m1hpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1V2wwyu0upqNL+PJRupcBR0VWyPjPIvm/RIZ6DdRKp16uFcVI4hYLVH604FjVKs3CxdDPNzoQFG1x7/Ssr9vmCUHKeUtvQQPgugb8tXyiG6keEOU1a6ESrZPowpcVaMybzGag/j1HJs0lVaQ2AbCuQTMbxAOWbpsJcPr/A1x1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dcHD+80u; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6f450f43971so403007b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825778; x=1715430578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kavMBo8KNcRmoPwTE1Oe8y9GeM+kd+Ho3+bW4koygvQ=;
        b=dcHD+80u415eFLXxw66nv1ePPJSwl2grQiTd05O3FKmJrqH84yoJaEc/mRdEq+Igyq
         81DnAE4i+Iuy1aJ2FP2ryfKq99VFGk8R1e+3obQ6XdBidbbIh7QGmYZCMUJ/aNu9+GpQ
         ID1vaQFS7V12+HSvI1PL85xfOtvS96rgnhfQNVI5hn4GKIzkYFrGBAHAO5JzlzM/mx5N
         gfn0r/eqoIThwu47B15EZrIvMop0XfA0CdCSVSZv2hZEOF3JzEi9bLDcitVbf7U9eyBK
         0Quko4VO5xliwAOTxU+oMk7UaYZLE3oqcaSgwqmocEkp9wB+rD8PBRsHypBfo45iBhfk
         yJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825778; x=1715430578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kavMBo8KNcRmoPwTE1Oe8y9GeM+kd+Ho3+bW4koygvQ=;
        b=pp7EqlffDot3PgjfurJrR/g1MfyZvpFbYoPGd+VcHONrdc5XCaCrjZTguG3moLWcmW
         po649HRAfoRcT5wCc8nKAw4hIUmcUigKQ/K9mV5tSdbxAPd240YTx5l2MsL0jNuUUJPF
         M6OwvFNLfm69eeAHvBdGaKiAuLH08aAhCkH4xSysJOet3j9cjWruu2YMm6ly7S3Z+MhO
         +OFw7POobz8tYBGCM68Ujd2InfL2ka7RdsLe+H7wvOt95v80k4lqLqNZQ3QokYRyQB7j
         vHolFO34jLxaGi4wmCE4ydNkziPTT08036MGfaQp5+mPcHZatqFvZpd7ASzT39cLA2PY
         gNHw==
X-Forwarded-Encrypted: i=1; AJvYcCW78nMU7VJcxQO5o3JqzdGKU6oAEMugTGo9nG6jmMRnjVPQS1GdYAOkwJoXn9Xkh4lNMDFDMeWNoHDjXdQLm5cLPude
X-Gm-Message-State: AOJu0Yxh1HnqpqM1umvEu6fgxfTct/D2GA4FRU9LCzzHVb3ZXoQL8qQE
	fiefIHEUK5sRSjBOoXCqJ6qAomipM8CHp6NljJkHMs0kUXqwQ7E5
X-Google-Smtp-Source: AGHT+IFwIkt93HtQtERrEdSM/+DbYu5bMQSPIbkZnBHOORjt3BcqhvAcQVz2yhravkyyNcodVzppMw==
X-Received: by 2002:a05:6a00:1904:b0:6ed:d5f5:869 with SMTP id y4-20020a056a00190400b006edd5f50869mr5871153pfi.3.1714825777622;
        Sat, 04 May 2024 05:29:37 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:37 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 12/31] powerpc: general interrupt tests
Date: Sat,  4 May 2024 22:28:18 +1000
Message-ID: <20240504122841.1177683-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic testing of various kinds of interrupts, machine check,
page fault, illegal, decrementer, trace, syscall, etc.

This has a known failure on QEMU TCG pseries machines where MSR[ME]
can be incorrectly set to 0.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |   4 +
 lib/powerpc/asm/reg.h       |  17 ++
 lib/powerpc/setup.c         |  11 +
 lib/ppc64/asm/ptrace.h      |  16 ++
 powerpc/Makefile.common     |   3 +-
 powerpc/interrupts.c        | 414 ++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg       |   3 +
 7 files changed, 467 insertions(+), 1 deletion(-)
 create mode 100644 powerpc/interrupts.c

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index cf1b9d8ff..eed37d1f4 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -11,7 +11,11 @@ void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
 extern bool cpu_has_hv;
+extern bool cpu_has_power_mce;
+extern bool cpu_has_siar;
 extern bool cpu_has_heai;
+extern bool cpu_has_prefix;
+extern bool cpu_has_sc_lev;
 
 static inline uint64_t mfspr(int nr)
 {
diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
index 782e75527..d6097f48f 100644
--- a/lib/powerpc/asm/reg.h
+++ b/lib/powerpc/asm/reg.h
@@ -5,8 +5,15 @@
 
 #define UL(x) _AC(x, UL)
 
+#define SPR_DSISR	0x012
+#define SPR_DAR		0x013
+#define SPR_DEC		0x016
 #define SPR_SRR0	0x01a
 #define SPR_SRR1	0x01b
+#define   SRR1_PREFIX		UL(0x20000000)
+#define SPR_FSCR	0x099
+#define   FSCR_PREFIX		UL(0x2000)
+#define SPR_HFSCR	0x0be
 #define SPR_TB		0x10c
 #define SPR_SPRG0	0x110
 #define SPR_SPRG1	0x111
@@ -22,12 +29,17 @@
 #define   PVR_VER_POWER8	UL(0x004d0000)
 #define   PVR_VER_POWER9	UL(0x004e0000)
 #define   PVR_VER_POWER10	UL(0x00800000)
+#define SPR_HDEC	0x136
 #define SPR_HSRR0	0x13a
 #define SPR_HSRR1	0x13b
+#define SPR_LPCR	0x13e
+#define   LPCR_HDICE		UL(0x1)
+#define SPR_HEIR	0x153
 #define SPR_MMCR0	0x31b
 #define   MMCR0_FC		UL(0x80000000)
 #define   MMCR0_PMAE		UL(0x04000000)
 #define   MMCR0_PMAO		UL(0x00000080)
+#define SPR_SIAR	0x31c
 
 /* Machine State Register definitions: */
 #define MSR_LE_BIT	0
@@ -35,6 +47,11 @@
 #define MSR_HV_BIT	60			/* Hypervisor mode */
 #define MSR_SF_BIT	63			/* 64-bit mode */
 
+#define MSR_DR		UL(0x0010)
+#define MSR_IR		UL(0x0020)
+#define MSR_BE		UL(0x0200)		/* Branch Trace Enable */
+#define MSR_SE		UL(0x0400)		/* Single Step Enable */
+#define MSR_EE		UL(0x8000)
 #define MSR_ME		UL(0x1000)
 
 #endif
diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 3c81aee9e..9b665f59c 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -87,7 +87,11 @@ static void cpu_set(int fdtnode, u64 regval, void *info)
 }
 
 bool cpu_has_hv;
+bool cpu_has_power_mce; /* POWER CPU machine checks */
+bool cpu_has_siar;
 bool cpu_has_heai;
+bool cpu_has_prefix;
+bool cpu_has_sc_lev; /* sc interrupt has LEV field in SRR1 */
 
 static void cpu_init(void)
 {
@@ -112,15 +116,22 @@ static void cpu_init(void)
 
 	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
 	case PVR_VER_POWER10:
+		cpu_has_prefix = true;
+		cpu_has_sc_lev = true;
 	case PVR_VER_POWER9:
 	case PVR_VER_POWER8E:
 	case PVR_VER_POWER8NVL:
 	case PVR_VER_POWER8:
+		cpu_has_power_mce = true;
 		cpu_has_heai = true;
+		cpu_has_siar = true;
 		break;
 	default:
 		break;
 	}
+
+	if (!cpu_has_hv) /* HEIR is HV register */
+		cpu_has_heai = false;
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/lib/ppc64/asm/ptrace.h b/lib/ppc64/asm/ptrace.h
index 12de7499b..db263a59e 100644
--- a/lib/ppc64/asm/ptrace.h
+++ b/lib/ppc64/asm/ptrace.h
@@ -5,6 +5,9 @@
 #define STACK_FRAME_OVERHEAD    112     /* size of minimum stack frame */
 
 #ifndef __ASSEMBLY__
+
+#include <asm/reg.h>
+
 struct pt_regs {
 	unsigned long gpr[32];
 	unsigned long nip;
@@ -17,6 +20,19 @@ struct pt_regs {
 	unsigned long _pad; /* stack must be 16-byte aligned */
 };
 
+static inline bool regs_is_prefix(volatile struct pt_regs *regs)
+{
+	return regs->msr & SRR1_PREFIX;
+}
+
+static inline void regs_advance_insn(struct pt_regs *regs)
+{
+	if (regs_is_prefix(regs))
+		regs->nip += 8;
+	else
+		regs->nip += 4;
+}
+
 #define STACK_INT_FRAME_SIZE    (sizeof(struct pt_regs) + \
 				 STACK_FRAME_OVERHEAD + KERNEL_REDZONE_SIZE)
 
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 1e181da69..68165fc25 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -12,7 +12,8 @@ tests-common = \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
 	$(TEST_DIR)/tm.elf \
-	$(TEST_DIR)/sprs.elf
+	$(TEST_DIR)/sprs.elf \
+	$(TEST_DIR)/interrupts.elf
 
 tests-all = $(tests-common) $(tests)
 all: directories $(TEST_DIR)/boot_rom.bin $(tests-all)
diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
new file mode 100644
index 000000000..552c48ef2
--- /dev/null
+++ b/powerpc/interrupts.c
@@ -0,0 +1,414 @@
+/* SPDX-License-Identifier: LGPL-2.0-only */
+/*
+ * Test interrupts
+ *
+ * Copyright 2024 Nicholas Piggin, IBM Corp.
+ */
+#include <libcflat.h>
+#include <util.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/setup.h>
+#include <asm/handlers.h>
+#include <asm/hcall.h>
+#include <asm/processor.h>
+#include <asm/time.h>
+#include <asm/barrier.h>
+
+static volatile bool got_interrupt;
+static volatile struct pt_regs recorded_regs;
+
+static void mce_handler(struct pt_regs *regs, void *opaque)
+{
+	bool *is_fetch = opaque;
+
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	if (*is_fetch)
+		regs->nip = regs->link;
+	else
+		regs_advance_insn(regs);
+}
+
+static void fault_handler(struct pt_regs *regs, void *opaque)
+{
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	if (regs->trap == 0x400 || regs->trap == 0x480)
+		regs->nip = regs->link;
+	else
+		regs_advance_insn(regs);
+}
+
+static void test_mce(void)
+{
+	unsigned long addr = -4ULL;
+	uint8_t tmp;
+	bool is_fetch;
+
+	report_prefix_push("mce");
+
+	handle_exception(0x200, mce_handler, &is_fetch);
+	handle_exception(0x300, fault_handler, NULL);
+	handle_exception(0x380, fault_handler, NULL);
+	handle_exception(0x400, fault_handler, NULL);
+	handle_exception(0x480, fault_handler, NULL);
+
+	if (machine_is_powernv()) {
+		enable_mcheck();
+	} else {
+		report(mfmsr() & MSR_ME, "pseries machine has MSR[ME]=1");
+		if (!(mfmsr() & MSR_ME)) { /* try to fix it */
+			enable_mcheck();
+		}
+		if (mfmsr() & MSR_ME) {
+			disable_mcheck();
+			report(mfmsr() & MSR_ME, "pseries is unable to change MSR[ME]");
+			if (!(mfmsr() & MSR_ME)) { /* try to fix it */
+				enable_mcheck();
+			}
+		}
+	}
+
+	is_fetch = false;
+	asm volatile("lbz %0,0(%1)" : "=r"(tmp) : "r"(addr));
+
+	report(got_interrupt, "MCE on access to invalid real address");
+	if (got_interrupt) {
+		report(mfspr(SPR_DAR) == addr, "MCE sets DAR correctly");
+		if (cpu_has_power_mce)
+			report(recorded_regs.msr & (1ULL << 21), "d-side MCE sets SRR1[42]");
+		got_interrupt = false;
+	}
+
+	is_fetch = true;
+	asm volatile("mtctr %0 ; bctrl" :: "r"(addr) : "ctr", "lr");
+	report(got_interrupt, "MCE on fetch from invalid real address");
+	if (got_interrupt) {
+		report(recorded_regs.nip == addr, "MCE sets SRR0 correctly");
+		if (cpu_has_power_mce)
+			report(!(recorded_regs.msr & (1ULL << 21)), "i-side MCE clears SRR1[42]");
+		got_interrupt = false;
+	}
+
+	handle_exception(0x200, NULL, NULL);
+	handle_exception(0x300, NULL, NULL);
+	handle_exception(0x380, NULL, NULL);
+	handle_exception(0x400, NULL, NULL);
+	handle_exception(0x480, NULL, NULL);
+
+	report_prefix_pop();
+}
+
+static void dseg_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs_advance_insn(regs);
+	regs->msr &= ~MSR_DR;
+}
+
+static void test_dseg(void)
+{
+	uint64_t msr, tmp;
+
+	report_prefix_push("data segment");
+
+	/* Some HV start in radix mode and need 0x300 */
+	handle_exception(0x300, &dseg_handler, NULL);
+	handle_exception(0x380, &dseg_handler, NULL);
+
+	asm volatile(
+"		mfmsr	%0		\n \
+		ori	%0,%0,%2	\n \
+		mtmsrd	%0		\n \
+		lbz	%1,0(0)		"
+		: "=r"(msr), "=r"(tmp) : "i"(MSR_DR): "memory");
+
+	report(got_interrupt, "interrupt on NULL dereference");
+	got_interrupt = false;
+
+	handle_exception(0x300, NULL, NULL);
+	handle_exception(0x380, NULL, NULL);
+
+	report_prefix_pop();
+}
+
+static void dec_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs->msr &= ~MSR_EE;
+}
+
+static void test_dec(void)
+{
+	uint64_t msr;
+	uint64_t tb;
+
+	report_prefix_push("decrementer");
+
+	handle_exception(0x900, &dec_handler, NULL);
+
+	asm volatile(
+"		mtdec	%1		\n \
+		mfmsr	%0		\n \
+		ori	%0,%0,%2	\n \
+		mtmsrd	%0,1		"
+		: "=r"(msr) : "r"(10000), "i"(MSR_EE): "memory");
+
+	tb = get_tb();
+	while (!got_interrupt) {
+		if (get_tb() - tb > tb_hz * 5)
+			break; /* timeout 5s */
+	}
+
+	report(got_interrupt, "interrupt on decrementer underflow");
+	got_interrupt = false;
+
+	handle_exception(0x900, NULL, NULL);
+
+	if (!machine_is_powernv())
+		goto done; /* Skip HV tests */
+
+	handle_exception(0x980, &dec_handler, NULL);
+
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_HDICE);
+	asm volatile(
+"		mtspr	0x136,%1	\n \
+		mtdec	%3		\n \
+		mfmsr	%0		\n \
+		ori	%0,%0,%2	\n \
+		mtmsrd	%0,1		"
+		: "=r"(msr) : "r"(10000), "i"(MSR_EE), "r"(0x7fffffff): "memory");
+
+	tb = get_tb();
+	while (!got_interrupt) {
+		if (get_tb() - tb > tb_hz * 5)
+			break; /* timeout 5s */
+	}
+
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) & ~LPCR_HDICE);
+
+	report(got_interrupt, "interrupt on hdecrementer underflow");
+	got_interrupt = false;
+
+	handle_exception(0x980, NULL, NULL);
+
+done:
+	report_prefix_pop();
+}
+
+
+static volatile uint64_t recorded_heir;
+
+static void heai_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs_advance_insn(regs);
+	if (cpu_has_heai)
+		recorded_heir = mfspr(SPR_HEIR);
+}
+
+static void program_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs_advance_insn(regs);
+}
+
+/*
+ * This tests invalid instruction handling. powernv (HV) should take an
+ * HEAI interrupt with the HEIR SPR set to the instruction image. pseries
+ * (guest) should take a program interrupt. CPUs which support prefix
+ * should report prefix instruction in (H)SRR1[34].
+ */
+static void test_illegal(void)
+{
+	report_prefix_push("illegal instruction");
+
+	if (machine_is_powernv()) {
+		handle_exception(0xe40, &heai_handler, NULL);
+	} else {
+		handle_exception(0x700, &program_handler, NULL);
+	}
+
+	asm volatile(".long 0x12345678" ::: "memory");
+	report(got_interrupt, "interrupt on invalid instruction");
+	got_interrupt = false;
+	if (cpu_has_heai)
+		report(recorded_heir == 0x12345678, "HEIR: 0x%08lx", recorded_heir);
+	report(!regs_is_prefix(&recorded_regs), "(H)SRR1 prefix bit clear");
+
+	if (cpu_has_prefix) {
+		asm volatile(".balign 8 ; .long 0x04000123; .long 0x00badc0d");
+		report(got_interrupt, "interrupt on invalid prefix instruction");
+		got_interrupt = false;
+		if (cpu_has_heai)
+			report(recorded_heir == 0x0400012300badc0d, "HEIR: 0x%08lx", recorded_heir);
+		report(regs_is_prefix(&recorded_regs), "(H)SRR1 prefix bit set");
+	}
+
+	handle_exception(0xe40, NULL, NULL);
+	handle_exception(0x700, NULL, NULL);
+
+	report_prefix_pop();
+}
+
+static void sc_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+}
+
+static void test_sc(void)
+{
+	report_prefix_push("syscall");
+
+	handle_exception(0xc00, &sc_handler, NULL);
+
+	asm volatile("sc 0" ::: "memory");
+
+	report(got_interrupt, "interrupt on sc 0 instruction");
+	got_interrupt = false;
+	if (cpu_has_sc_lev)
+		report(((recorded_regs.msr >> 20) & 0x3) == 0, "SRR1 set LEV=0");
+	if (machine_is_powernv()) {
+		asm volatile("sc 1" ::: "memory");
+
+		report(got_interrupt, "interrupt on sc 1 instruction");
+		got_interrupt = false;
+		if (cpu_has_sc_lev)
+			report(((recorded_regs.msr >> 20) & 0x3) == 1, "SRR1 set LEV=1");
+	}
+
+	handle_exception(0xc00, NULL, NULL);
+
+	report_prefix_pop();
+}
+
+
+static void trace_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs->msr &= ~(MSR_SE | MSR_BE);
+}
+
+static void program_trace_handler(struct pt_regs *regs, void *data)
+{
+	regs->msr &= ~(MSR_SE | MSR_BE);
+	regs->nip += 4;
+}
+
+extern char trace_insn[];
+extern char trace_insn2[];
+extern char trace_insn3[];
+extern char trace_rfid[];
+
+static void test_trace(void)
+{
+	unsigned long msr;
+
+	report_prefix_push("trace");
+
+	handle_exception(0xd00, &trace_handler, NULL);
+
+	msr = mfmsr() | MSR_SE;
+	asm volatile(
+	"	mtmsr	%0		\n"
+	".global trace_insn		\n"
+	"trace_insn:			\n"
+	"	nop			\n"
+	: : "r"(msr) : "memory");
+
+	report(got_interrupt, "interrupt on single step");
+	got_interrupt = false;
+	report(recorded_regs.nip == (unsigned long)trace_insn + 4,
+			"single step interrupt at the correct address");
+	if (cpu_has_siar)
+		report(mfspr(SPR_SIAR) == (unsigned long)trace_insn,
+			"single step recorded SIAR at the correct address");
+
+	msr = mfmsr() | MSR_SE;
+	asm volatile(
+	"	mtmsr	%0		\n"
+	".global trace_insn2		\n"
+	"trace_insn2:			\n"
+	"	b	1f		\n"
+	"	nop			\n"
+	"1:				\n"
+	: : "r"(msr) : "memory");
+
+	report(got_interrupt, "interrupt on single step branch");
+	got_interrupt = false;
+	report(recorded_regs.nip == (unsigned long)trace_insn2 + 8,
+			"single step interrupt at the correct address");
+	if (cpu_has_siar)
+		report(mfspr(SPR_SIAR) == (unsigned long)trace_insn2,
+			"single step recorded SIAR at the correct address");
+
+	msr = mfmsr() | MSR_BE;
+	asm volatile(
+	"	mtmsr	%0		\n"
+	".global trace_insn3		\n"
+	"trace_insn3:			\n"
+	"	nop			\n"
+	"	b	1f		\n"
+	"	nop			\n"
+	"1:				\n"
+	: : "r"(msr) : "memory");
+
+	report(got_interrupt, "interrupt on branch trace");
+	got_interrupt = false;
+	report(recorded_regs.nip == (unsigned long)trace_insn3 + 12,
+			"branch trace interrupt at the correct address");
+	if (cpu_has_siar)
+		report(mfspr(SPR_SIAR) == (unsigned long)trace_insn3 + 4,
+			"branch trace recorded SIAR at the correct address");
+
+	handle_exception(0x700, &program_trace_handler, NULL);
+	msr = mfmsr() | MSR_SE;
+	asm volatile(
+	"	mtmsr	%0		\n"
+	"	trap			\n"
+	: : "r"(msr) : "memory");
+
+	report(!got_interrupt, "no interrupt on single step trap");
+	got_interrupt = false;
+	handle_exception(0x700, NULL, NULL);
+
+	msr = mfmsr() | MSR_SE;
+	mtspr(SPR_SRR0, (unsigned long)trace_rfid);
+	mtspr(SPR_SRR1, mfmsr());
+	asm volatile(
+	"	mtmsr	%0		\n"
+	"	rfid			\n"
+	".global trace_rfid		\n"
+	"trace_rfid:			\n"
+	: : "r"(msr) : "memory");
+
+	report(!got_interrupt, "no interrupt on single step rfid");
+	got_interrupt = false;
+	handle_exception(0xd00, NULL, NULL);
+
+	report_prefix_pop();
+}
+
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("interrupts");
+
+	if (cpu_has_power_mce)
+		test_mce();
+	test_dseg();
+	test_illegal();
+	test_dec();
+	test_sc();
+	test_trace();
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 4c0c6ddea..03d7b60e5 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -66,6 +66,9 @@ groups = rtas
 [emulator]
 file = emulator.elf
 
+[interrupts]
+file = interrupts.elf
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.43.0


