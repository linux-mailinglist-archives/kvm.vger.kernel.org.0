Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2177AA0372
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfH1NjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:09 -0400
Received: from foss.arm.com ([217.140.110.172]:59656 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfH1NjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C30A328;
        Wed, 28 Aug 2019 06:39:07 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A55983F246;
        Wed, 28 Aug 2019 06:39:06 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 13/16] arm64: selftest: Add basic test for EL2
Date:   Wed, 28 Aug 2019 14:38:28 +0100
Message-Id: <1566999511-24916-14-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a rudimentary test for EL2 that checks that we are indeed running with
VHE enabled and that we are using SMC for issuing PSCI calls.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h |  6 ++++++
 arm/selftest.c            | 36 +++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg         |  8 ++++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 4d81a4941959..b9058f140039 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -110,5 +110,11 @@ static inline u32 get_cntfrq(void)
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
index 9ebf4c6051b4..211bc8a5642b 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -19,6 +19,9 @@
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 
+#define ID_AA64MMFR1_VHE_MASK		(0xf << 8)
+#define ID_AA64MMFR1_VHE_SUPPORTED	(1 << 8)
+
 static void __user_psci_system_off(void)
 {
 	psci_system_off();
@@ -223,6 +226,11 @@ static void check_pabt(void)
 	test_exception("mov r2, #0x0", "bx r2", "");
 	__builtin_unreachable();
 }
+
+static void check_el2(void)
+{
+	report("EL2 only available on arm64", false);
+}
 #elif defined(__aarch64__)
 
 /*
@@ -372,6 +380,29 @@ static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
 }
+
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
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE supported and enabled",
+			vhe_supported() && vhe_enabled(), cpu);
+}
+
+static bool psci_check(void);
+static void check_el2(void)
+{
+	report("PSCI conduit", psci_check());
+	on_cpus(check_el2_cpu, NULL);
+}
 #endif
 
 static void check_vectors(void *arg __unused)
@@ -423,7 +454,6 @@ static bool psci_check(void)
 		printf("psci method must be smc\n");
 		return false;
 	}
-
 	if (current_level() == CurrentEL_EL1 &&
 	    strcmp(method->data, "hvc") != 0) {
 		printf("psci method must be hvc\n");
@@ -474,6 +504,10 @@ int main(int argc, char **argv)
 		report("PSCI version", psci_check());
 		on_cpus(cpu_report, NULL);
 
+	} else if (strcmp(argv[1], "el2") == 0) {
+
+		check_el2();
+
 	} else {
 		printf("Unknown subtest\n");
 		abort();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 6d3df92a4e28..c632f4e75382 100644
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

