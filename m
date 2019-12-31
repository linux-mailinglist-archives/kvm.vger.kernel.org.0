Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B4012DA1F
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfLaQKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:34 -0500
Received: from foss.arm.com ([217.140.110.172]:35546 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbfLaQKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B03C328;
        Tue, 31 Dec 2019 08:10:33 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85B073F68F;
        Tue, 31 Dec 2019 08:10:31 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 10/18] arm/arm64: selftest: Add prefetch abort test
Date:   Tue, 31 Dec 2019 16:09:41 +0000
Message-Id: <1577808589-31892-11-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest tries to execute code from MMIO memory, KVM injects an
external abort into that guest. We have now fixed the psci test to not
fetch instructions from the I/O region, and it's not that often that a
guest misbehaves in such a way. Let's expand our coverage by adding a
proper test targetting this corner case.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/esr.h |   3 ++
 arm/selftest.c      | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 8e5af4d90767..8c351631b0a0 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -44,4 +44,7 @@
 #define ESR_EL1_EC_BKPT32	(0x38)
 #define ESR_EL1_EC_BRK64	(0x3C)
 
+#define ESR_EL1_FSC_MASK	(0x3F)
+#define ESR_EL1_FSC_EXTABT	(0x10)
+
 #endif /* _ASMARM64_ESR_H_ */
diff --git a/arm/selftest.c b/arm/selftest.c
index 89759cf9f592..11dd432f4e6f 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -16,6 +16,8 @@
 #include <asm/psci.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
 
 static cpumask_t ready, valid;
 
@@ -68,6 +70,7 @@ static void check_setup(int argc, char **argv)
 static struct pt_regs expected_regs;
 static bool und_works;
 static bool svc_works;
+static bool pabt_works;
 #if defined(__arm__)
 /*
  * Capture the current register state and execute an instruction
@@ -91,7 +94,7 @@ static bool svc_works;
 		"str	r1, [r0, #" xstr(S_PC) "]\n"		\
 		excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "r0", "r1")
+	:: "r" (&expected_regs) : "r0", "r1", "r2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -171,6 +174,55 @@ static void user_psci_system_off(struct pt_regs *regs)
 {
 	__user_psci_system_off();
 }
+
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EXCPTN_PABT, NULL);
+
+	report(pabt_works, "pabt");
+	exit(report_summary());
+}
+
+/* The page below the vmalloc region at 3G, assuming that PAGE_SIZE = 4K. */
+#define PABT_ADDR	0xbffff000
+static void pabt_handler(struct pt_regs *regs)
+{
+	expected_regs.ARM_pc = PABT_ADDR;
+	pabt_works = check_regs(regs);
+
+	regs->ARM_pc = (unsigned long)&check_pabt_exit;
+}
+
+static void check_pabt(void)
+{
+	unsigned long sctlr;
+
+	if (PABT_ADDR < __phys_end) {
+		report_skip("pabt: physical memory overlap");
+		return;
+	}
+
+	mmu_set_range_ptes(current_thread_info()->pgtable, PABT_ADDR,
+			PABT_ADDR, PABT_ADDR + PAGE_SIZE, __pgprot(PTE_WBWA));
+
+	/* Make sure we can actually execute from a writable region */
+	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
+	if (sctlr & CR_ST) {
+		sctlr &= ~CR_ST;
+		asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
+		isb();
+		/*
+		 * Required according to the sequence in ARM DDI 0406C.d, page
+		 * B3-1358.
+		 */
+		flush_tlb_all();
+	}
+
+	install_exception_handler(EXCPTN_PABT, pabt_handler);
+
+	test_exception("ldr r2, =" xstr(PABT_ADDR), "bx r2", "");
+	__builtin_unreachable();
+}
 #elif defined(__aarch64__)
 
 /*
@@ -212,7 +264,7 @@ static void user_psci_system_off(struct pt_regs *regs)
 		"stp	 x0,  x1, [x1]\n"			\
 	"1:"	excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "x0", "x1")
+	:: "r" (&expected_regs) : "x0", "x1", "x2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -288,6 +340,60 @@ static bool check_svc(void)
 	return svc_works;
 }
 
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report(pabt_works, "pabt");
+	exit(report_summary());
+}
+
+/* The page below the MMIO region at 256G, assuming that PAGE_SIZE = 64K. */
+#define PABT_ADDR	0x3fffff0000
+static void pabt_handler(struct pt_regs *regs, unsigned int esr)
+{
+	bool is_extabt;
+
+	expected_regs.pc = PABT_ADDR;
+	is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
+	pabt_works = check_regs(regs) && is_extabt;
+
+	regs->pc = (u64)&check_pabt_exit;
+}
+
+static void check_pabt(void)
+{
+	enum vector v = check_vector_prep();
+	unsigned long sctlr;
+
+	if (PABT_ADDR < __phys_end) {
+		report_skip("pabt: physical memory overlap");
+		return;
+	}
+
+	/*
+	 * According to ARM DDI 0487E.a, table D5-33, footnote c, all regions
+	 * writable at EL0 are treated as PXN. Map the page without the user bit
+	 * set.
+	 */
+	mmu_set_range_ptes(current_thread_info()->pgtable, PABT_ADDR,
+			PABT_ADDR, PABT_ADDR + PAGE_SIZE, __pgprot(PTE_WBWA));
+
+	/* Make sure we can actually execute from a writable region */
+	sctlr = read_sysreg(sctlr_el1);
+	if (sctlr & SCTLR_EL1_WXN) {
+		write_sysreg(sctlr & ~SCTLR_EL1_WXN, sctlr_el1);
+		isb();
+		/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
+		flush_tlb_all();
+	}
+
+	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
+
+	test_exception("ldr x2, =" xstr(PABT_ADDR), "br x2", "");
+	__builtin_unreachable();
+}
+
 static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
@@ -305,6 +411,8 @@ static void check_vectors(void *arg __unused)
 		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
 					  user_psci_system_off);
 #endif
+	} else {
+		check_pabt();
 	}
 	exit(report_summary());
 }
-- 
2.7.4

