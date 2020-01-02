Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8DB12E6E6
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgABNrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:47:13 -0500
Received: from foss.arm.com ([217.140.110.172]:47310 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbgABNrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:47:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E5061007;
        Thu,  2 Jan 2020 05:47:12 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.9.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 16DF83F68F;
        Thu,  2 Jan 2020 05:47:10 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH v3 4/7] arm64: selftest: Add basic test for EL2
Date:   Thu,  2 Jan 2020 13:46:43 +0000
Message-Id: <1577972806-16184-5-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a rudimentary test for EL2 that checks that we are indeed running with
VHE enabled and that we are using SMC for issuing PSCI calls.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h |  6 ++++++
 arm/selftest.c            | 35 ++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg         |  8 ++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 7e9f76d73f1b..4bbd82d9bfde 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -116,5 +116,11 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(cntfrq_el0);
 }
 
+static inline bool vhe_enabled(void)
+{
+	unsigned long hcr = read_sysreg(hcr_el2);
+	return (hcr & HCR_EL2_E2H) && (hcr & HCR_EL2_TGE);
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/arm/selftest.c b/arm/selftest.c
index 1538e0e68483..a30e101a4920 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -223,6 +223,11 @@ static void check_pabt(void)
 	test_exception("ldr r2, =" xstr(PABT_ADDR), "bx r2", "");
 	__builtin_unreachable();
 }
+
+static void check_el2(void)
+{
+	report(false, "EL2 only available on arm64");
+}
 #elif defined(__aarch64__)
 static unsigned long expected_level;
 
@@ -402,6 +407,31 @@ static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
 }
+
+#define ID_AA64MMFR1_VHE_MASK		(0xf << 8)
+#define ID_AA64MMFR1_VHE_SUPPORTED	(1 << 8)
+static bool vhe_supported(void)
+{
+	u64 aa64mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+
+	return (aa64mmfr1 & ID_AA64MMFR1_VHE_MASK) == ID_AA64MMFR1_VHE_SUPPORTED;
+}
+
+static void check_el2_cpu(void *data __unused)
+{
+	int cpu = smp_processor_id();
+
+	report(current_level() == CurrentEL_EL2, "CPU(%3d) Running at EL2", cpu);
+	report(vhe_supported() && vhe_enabled(),
+			"CPU(%3d) VHE supported and enabled", cpu);
+}
+
+static bool psci_check(void);
+static void check_el2(void)
+{
+	report(psci_check(), "PSCI conduit");
+	on_cpus(check_el2_cpu, NULL);
+}
 #endif
 
 static void check_vectors(void *arg __unused)
@@ -453,7 +483,6 @@ static bool psci_check(void)
 		printf("psci method must be smc\n");
 		return false;
 	}
-
 	if (current_level() == CurrentEL_EL1 &&
 	    strcmp(method->data, "hvc") != 0) {
 		printf("psci method must be hvc\n");
@@ -516,6 +545,10 @@ int main(int argc, char **argv)
 		report(cpumask_full(&valid), "MPIDR test on all CPUs");
 		report_info("%d CPUs reported back", nr_cpus);
 
+	} else if (strcmp(argv[1], "el2") == 0) {
+
+		check_el2();
+
 	} else {
 		printf("Unknown subtest\n");
 		abort();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a09ad39..4b2054ad1e36 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -55,6 +55,14 @@ smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
 
+# Test EL2 support
+[selftest-el2]
+file = selftest.flat
+smp = 2
+extra_params = -append 'el2'
+groups = selftest
+arch = arm64
+
 # Test PCI emulation
 [pci-test]
 file = pci-test.flat
-- 
2.7.4

