Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED63A0366
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfH1Ni4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:38:56 -0400
Received: from foss.arm.com ([217.140.110.172]:59544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfH1Ni4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:38:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F81F360;
        Wed, 28 Aug 2019 06:38:55 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 616733F246;
        Wed, 28 Aug 2019 06:38:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add prefetch abort test
Date:   Wed, 28 Aug 2019 14:38:19 +0100
Message-Id: <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
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
The fault injection path is broken for nested guests [1]. You can use the
last patch from the thread [2] to successfully run the test at EL2.

[1] https://www.spinics.net/lists/arm-kernel/msg745391.html
[2] https://www.spinics.net/lists/arm-kernel/msg750310.html

 lib/arm64/asm/esr.h |  3 ++
 arm/selftest.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 96 insertions(+), 3 deletions(-)

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
index 176231f32ee1..18cc0ad8f729 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -16,6 +16,8 @@
 #include <asm/psci.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
 
 static void __user_psci_system_off(void)
 {
@@ -60,9 +62,38 @@ static void check_setup(int argc, char **argv)
 		report_abort("missing input");
 }
 
+extern pgd_t *mmu_idmap;
+static void prep_io_exec(void)
+{
+	pgd_t *pgd = pgd_offset(mmu_idmap, 0);
+	unsigned long sctlr;
+
+	/*
+	 * AArch64 treats all regions writable at EL0 as PXN. Clear the user bit
+	 * so we can execute code from the bottom I/O space (0G-1G) to simulate
+	 * a misbehaved guest.
+	 */
+	pgd_val(*pgd) &= ~PMD_SECT_USER;
+	flush_dcache_addr((unsigned long)pgd);
+	flush_tlb_page(0);
+
+	/* Make sure we can actually execute from a writable region */
+#ifdef __arm__
+	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
+	sctlr &= ~CR_ST;
+	asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
+#else
+	sctlr = read_sysreg(sctlr_el1);
+	sctlr &= ~SCTLR_EL1_WXN;
+	write_sysreg(sctlr, sctlr_el1);
+#endif
+	isb();
+}
+
 static struct pt_regs expected_regs;
 static bool und_works;
 static bool svc_works;
+static bool pabt_works;
 #if defined(__arm__)
 /*
  * Capture the current register state and execute an instruction
@@ -86,7 +117,7 @@ static bool svc_works;
 		"str	r1, [r0, #" xstr(S_PC) "]\n"		\
 		excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "r0", "r1")
+	:: "r" (&expected_regs) : "r0", "r1", "r2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -166,6 +197,32 @@ static void user_psci_system_off(struct pt_regs *regs)
 {
 	__user_psci_system_off();
 }
+
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EXCPTN_PABT, NULL);
+
+	report("pabt", pabt_works);
+	exit(report_summary());
+}
+
+static void pabt_handler(struct pt_regs *regs)
+{
+	expected_regs.ARM_pc = 0;
+	pabt_works = check_regs(regs);
+
+	regs->ARM_pc = (unsigned long)&check_pabt_exit;
+}
+
+static void check_pabt(void)
+{
+	install_exception_handler(EXCPTN_PABT, pabt_handler);
+
+	prep_io_exec();
+
+	test_exception("mov r2, #0x0", "bx r2", "");
+	__builtin_unreachable();
+}
 #elif defined(__aarch64__)
 
 /*
@@ -207,7 +264,7 @@ static void user_psci_system_off(struct pt_regs *regs)
 		"stp	 x0,  x1, [x1]\n"			\
 	"1:"	excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "x0", "x1")
+	:: "r" (&expected_regs) : "x0", "x1", "x2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -279,6 +336,37 @@ static bool check_svc(void)
 	return svc_works;
 }
 
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report("pabt", pabt_works);
+	exit(report_summary());
+}
+
+static void pabt_handler(struct pt_regs *regs, unsigned int esr)
+{
+	bool is_extabt;
+
+	expected_regs.pc = 0;
+	is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
+	pabt_works = check_regs(regs) && is_extabt;
+
+	regs->pc = (u64)&check_pabt_exit;
+}
+
+static void check_pabt(void)
+{
+	enum vector v = check_vector_prep();
+
+	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
+
+	prep_io_exec();
+
+	test_exception("mov x2, xzr", "br x2", "");
+	__builtin_unreachable();
+}
+
 static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
@@ -289,7 +377,9 @@ static void check_vectors(void *arg __unused)
 {
 	report("und", check_und());
 	report("svc", check_svc());
-	if (is_user()) {
+	if (!is_user()) {
+		check_pabt();
+	} else {
 #ifdef __arm__
 		install_exception_handler(EXCPTN_UND, user_psci_system_off);
 #else
-- 
2.7.4

