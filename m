Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15435C8BF9
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJBOvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 10:51:13 -0400
Received: from foss.arm.com ([217.140.110.172]:46350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbfJBOvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 10:51:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B0E128;
        Wed,  2 Oct 2019 07:51:12 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 499033F706;
        Wed,  2 Oct 2019 07:51:10 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/10] arm/arm64: Make use of the SMCCC 1.1 wrapper
Date:   Wed,  2 Oct 2019 15:50:36 +0100
Message-Id: <20191002145037.51630-10-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002145037.51630-1-steven.price@arm.com>
References: <20191002145037.51630-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than directly choosing which function to use based on
psci_ops.conduit, use the new arm_smccc_1_1 wrapper instead.

In some cases we still need to do some operations based on the
conduit, but the code duplication is removed.

No functional change.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm/mm/proc-v7-bugs.c     | 13 +++---
 arch/arm64/kernel/cpu_errata.c | 80 ++++++++++++----------------------
 2 files changed, 33 insertions(+), 60 deletions(-)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 9a07916af8dd..8eb52f3385e7 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -78,12 +78,13 @@ static void cpu_v7_spectre_init(void)
 		if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 			break;
 
+		arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				     ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+		if ((int)res.a0 != 0)
+			return;
+
 		switch (psci_ops.conduit) {
 		case PSCI_CONDUIT_HVC:
-			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-			if ((int)res.a0 != 0)
-				break;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_hvc_arch_workaround_1;
 			cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
@@ -91,10 +92,6 @@ static void cpu_v7_spectre_init(void)
 			break;
 
 		case PSCI_CONDUIT_SMC:
-			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-			if ((int)res.a0 != 0)
-				break;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_smc_arch_workaround_1;
 			cpu_do_switch_mm = cpu_v7_smc_switch_mm;
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1e43ba5c79b7..400a49aaae85 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -215,40 +215,31 @@ static int detect_harden_bp_fw(void)
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 		return -1;
 
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+
+	switch ((int)res.a0) {
+	case 1:
+		/* Firmware says we're just fine */
+		return 0;
+	case 0:
+		break;
+	default:
+		return -1;
+	}
+
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		switch ((int)res.a0) {
-		case 1:
-			/* Firmware says we're just fine */
-			return 0;
-		case 0:
-			cb = call_hvc_arch_workaround_1;
-			/* This is a guest, no need to patch KVM vectors */
-			smccc_start = NULL;
-			smccc_end = NULL;
-			break;
-		default:
-			return -1;
-		}
+		cb = call_hvc_arch_workaround_1;
+		/* This is a guest, no need to patch KVM vectors */
+		smccc_start = NULL;
+		smccc_end = NULL;
 		break;
 
 	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		switch ((int)res.a0) {
-		case 1:
-			/* Firmware says we're just fine */
-			return 0;
-		case 0:
-			cb = call_smc_arch_workaround_1;
-			smccc_start = __smccc_workaround_1_smc_start;
-			smccc_end = __smccc_workaround_1_smc_end;
-			break;
-		default:
-			return -1;
-		}
+		cb = call_smc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_smc_start;
+		smccc_end = __smccc_workaround_1_smc_end;
 		break;
 
 	default:
@@ -338,6 +329,7 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
 void arm64_set_ssbd_mitigation(bool state)
 {
+	int conduit;
 	if (!IS_ENABLED(CONFIG_ARM64_SSBD)) {
 		pr_info_once("SSBD disabled by kernel configuration\n");
 		return;
@@ -351,19 +343,10 @@ void arm64_set_ssbd_mitigation(bool state)
 		return;
 	}
 
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
-		break;
+	conduit = arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_WORKAROUND_2, state,
+				       NULL);
 
-	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
-		break;
-
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	WARN_ON_ONCE(conduit == PSCI_CONDUIT_NONE);
 }
 
 static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
@@ -373,6 +356,7 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	bool required = true;
 	s32 val;
 	bool this_cpu_safe = false;
+	int conduit;
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
@@ -397,18 +381,10 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		return false;
 	}
 
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
-		break;
-
-	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
-		break;
+	conduit = arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				       ARM_SMCCC_ARCH_WORKAROUND_2, &res);
 
-	default:
+	if (conduit == PSCI_CONDUIT_NONE) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
 		if (!this_cpu_safe)
 			__ssb_safe = false;
-- 
2.20.1

