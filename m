Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE8F13066
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 16:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfECOfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 10:35:55 -0400
Received: from foss.arm.com ([217.140.101.70]:34994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbfECOfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 10:35:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 428A715AD;
        Fri,  3 May 2019 07:28:01 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 885FE3F5C1;
        Fri,  3 May 2019 07:27:59 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Auger <eric.auger@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v6 1/3] arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests
Date:   Fri,  3 May 2019 15:27:48 +0100
Message-Id: <20190503142750.252793-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503142750.252793-1-andre.przywara@arm.com>
References: <20190503142750.252793-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent commits added the explicit notion of "workaround not required" to
the state of the Spectre v2 (aka. BP_HARDENING) workaround, where we
just had "needed" and "unknown" before.

Export this knowledge to the rest of the kernel and enhance the existing
kvm_arm_harden_branch_predictor() to report this new state as well.
Export this new state to guests when they use KVM's firmware interface
emulation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_host.h     | 12 +++++++++---
 arch/arm64/include/asm/cpufeature.h |  6 ++++++
 arch/arm64/include/asm/kvm_host.h   | 16 ++++++++++++++--
 arch/arm64/kernel/cpu_errata.c      | 23 ++++++++++++++++++-----
 virt/kvm/arm/psci.c                 | 10 +++++++++-
 5 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 770d73257ad9..3ae0bb6d0999 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -364,7 +364,11 @@ static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
-static inline bool kvm_arm_harden_branch_predictor(void)
+#define KVM_BP_HARDEN_UNKNOWN		-1
+#define KVM_BP_HARDEN_WA_NEEDED		0
+#define KVM_BP_HARDEN_NOT_REQUIRED	1
+
+static inline int kvm_arm_harden_branch_predictor(void)
 {
 	switch(read_cpuid_part()) {
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
@@ -372,10 +376,12 @@ static inline bool kvm_arm_harden_branch_predictor(void)
 	case ARM_CPU_PART_CORTEX_A12:
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_CORTEX_A17:
-		return true;
+		return KVM_BP_HARDEN_WA_NEEDED;
 #endif
+	case ARM_CPU_PART_CORTEX_A7:
+		return KVM_BP_HARDEN_NOT_REQUIRED;
 	default:
-		return false;
+		return KVM_BP_HARDEN_UNKNOWN;
 	}
 }
 
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6ccdc97e5d6a..7cc58a34df43 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -622,6 +622,12 @@ static inline bool system_uses_irq_prio_masking(void)
 	       cpus_have_const_cap(ARM64_HAS_IRQ_PRIO_MASKING);
 }
 
+#define ARM64_BP_HARDEN_UNKNOWN		-1
+#define ARM64_BP_HARDEN_WA_NEEDED	0
+#define ARM64_BP_HARDEN_NOT_REQUIRED	1
+
+int get_spectre_v2_workaround_state(void);
+
 #define ARM64_SSBD_UNKNOWN		-1
 #define ARM64_SSBD_FORCE_DISABLE	0
 #define ARM64_SSBD_KERNEL		1
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a01fe087e022..b1d484d49d39 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -555,9 +555,21 @@ static inline void kvm_arm_vhe_guest_exit(void)
 	isb();
 }
 
-static inline bool kvm_arm_harden_branch_predictor(void)
+#define KVM_BP_HARDEN_UNKNOWN		-1
+#define KVM_BP_HARDEN_WA_NEEDED		0
+#define KVM_BP_HARDEN_NOT_REQUIRED	1
+
+static inline int kvm_arm_harden_branch_predictor(void)
 {
-	return cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
+	switch (get_spectre_v2_workaround_state()) {
+	case ARM64_BP_HARDEN_WA_NEEDED:
+		return KVM_BP_HARDEN_WA_NEEDED;
+	case ARM64_BP_HARDEN_NOT_REQUIRED:
+		return KVM_BP_HARDEN_NOT_REQUIRED;
+	case ARM64_BP_HARDEN_UNKNOWN:
+	default:
+		return KVM_BP_HARDEN_UNKNOWN;
+	}
 }
 
 #define KVM_SSBD_UNKNOWN		-1
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1b9ce0fdd81d..04b659674f3a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -549,6 +549,17 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 static bool __hardenbp_enab = true;
 static bool __spectrev2_safe = true;
 
+int get_spectre_v2_workaround_state(void)
+{
+	if (__spectrev2_safe)
+		return ARM64_BP_HARDEN_NOT_REQUIRED;
+
+	if (!__hardenbp_enab)
+		return ARM64_BP_HARDEN_UNKNOWN;
+
+	return ARM64_BP_HARDEN_WA_NEEDED;
+}
+
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -828,13 +839,15 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	if (__spectrev2_safe)
+	switch (get_spectre_v2_workaround_state()) {
+	case ARM64_BP_HARDEN_NOT_REQUIRED:
 		return sprintf(buf, "Not affected\n");
-
-	if (__hardenbp_enab)
+        case ARM64_BP_HARDEN_WA_NEEDED:
 		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
-
-	return sprintf(buf, "Vulnerable\n");
+        case ARM64_BP_HARDEN_UNKNOWN:
+	default:
+		return sprintf(buf, "Vulnerable\n");
+	}
 }
 
 ssize_t cpu_show_spec_store_bypass(struct device *dev,
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 34d08ee63747..900b67c2720f 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -412,8 +412,16 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		feature = smccc_get_arg1(vcpu);
 		switch(feature) {
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
-			if (kvm_arm_harden_branch_predictor())
+			switch (kvm_arm_harden_branch_predictor()) {
+			case KVM_BP_HARDEN_UNKNOWN:
+				break;
+			case KVM_BP_HARDEN_WA_NEEDED:
 				val = SMCCC_RET_SUCCESS;
+				break;
+			case KVM_BP_HARDEN_NOT_REQUIRED:
+				val = SMCCC_RET_NOT_REQUIRED;
+				break;
+			}
 			break;
 		case ARM_SMCCC_ARCH_WORKAROUND_2:
 			switch (kvm_arm_have_ssbd()) {
-- 
2.17.1

