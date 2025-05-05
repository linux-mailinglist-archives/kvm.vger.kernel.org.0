Return-Path: <kvm+bounces-45476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1F9AAA494
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 01:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BD20464E2F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C4830225C;
	Mon,  5 May 2025 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpJzzTvh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA430223C;
	Mon,  5 May 2025 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484013; cv=none; b=edd9/n1m8Jyng/oZ2t7DszeaohsA6wxDB3P9aA1f43Q2Iq/SexyZaINx1RfNne+/n+b34rG0olsfu494zeHu0SIkwPfzD4B5di65+TVDxZ8EskBBAb+zPdI4i+LxwmUUtGVMshCaG6Wk2Kht4cRoX3YNB8Zaz7gllewOUlyRiy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484013; c=relaxed/simple;
	bh=uV8i8xX3QK1VfInKsw8e5L4q6lQiJySUKPZUNex7KHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jNURP/LDfwE2+GxuG20cvyX70zGAMY8WriuXVou/9y4nqUpIwkYoAnFu7+YJ72SDaKx4tFzdd4ebRJe98GiiaO4k0SlAi3O7RYqg58IfRpYM/wyKnQeA/RkaZs/3dPuJvNO5ZpduNBJtMuTrIU0lj8Gep4Ac4Iw9K/OdukbFtDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpJzzTvh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE67C4CEE4;
	Mon,  5 May 2025 22:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484013;
	bh=uV8i8xX3QK1VfInKsw8e5L4q6lQiJySUKPZUNex7KHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpJzzTvhhoOhgPQNSPxkPFUqULlK/figwUt4RAy4MMZKvn4X3Q6OECRKeYqY4+c6a
	 lGcS76L2Z3+h7Vg0bRMx0S6sINFzzQiebeoqNi+XZtN6cgoCdpgHpLQAuKXyjJLytI
	 k5Qz5ztw7C+G8BbJSNfSgy0QB6FJV9VguJEq+G7Igdf2BKtFPWM7pAhikEkMWvkCQQ
	 Vi410MKNilyhcSsWPZ/AbrFQR2qyGTED1sv9YFnVLdTTfk3Y0WldLMBWEvr7/WeCvx
	 7Qw0b15T7dgr+c1w+citmrECek9i4+cTr6YcAldCVZ3ViCT/S22KbsmyCHQKAiLUrD
	 i1YWlbx4xir2g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	pbonzini@redhat.com,
	thomas.lendacky@amd.com,
	mario.limonciello@amd.com,
	perry.yuan@amd.com,
	kai.huang@intel.com,
	xiaoyao.li@intel.com,
	tony.luck@intel.com,
	xin3.li@intel.com,
	kan.liang@linux.intel.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 317/642] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Date: Mon,  5 May 2025 18:08:53 -0400
Message-Id: <20250505221419.2672473-317-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Borislav Petkov <bp@alien8.de>

[ Upstream commit 8442df2b49ed9bcd67833ad4f091d15ac91efd00 ]

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

Enable BpSpecReduce to mitigate SRSO across guest/host boundaries.

Switch back to enabling the bit when virtualization is enabled and to
clear the bit when virtualization is disabled because using a MSR slot
would clear the bit when the guest is exited and any training the guest
has done, would potentially influence the host kernel when execution
enters the kernel and hasn't VMRUN the guest yet.

More detail on the public thread in Link below.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241202120416.6054-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 13 ++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  4 ++++
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 24 ++++++++++++++++++----
 arch/x86/kvm/svm/svm.c                     |  6 ++++++
 arch/x86/lib/msr.c                         |  2 ++
 6 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index 2ad1c05b8c883..66af95251a3d1 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -104,7 +104,20 @@ The possible values in this file are:
 
    (spec_rstack_overflow=ibpb-vmexit)
 
+ * 'Mitigation: Reduced Speculation':
 
+   This mitigation gets automatically enabled when the above one "IBPB on
+   VMEXIT" has been selected and the CPU supports the BpSpecReduce bit.
+
+   It gets automatically enabled on machines which have the
+   SRSO_USER_KERNEL_NO=1 CPUID bit. In that case, the code logic is to switch
+   to the above =ibpb-vmexit mitigation because the user/kernel boundary is
+   not affected anymore and thus "safe RET" is not needed.
+
+   After enabling the IBPB on VMEXIT mitigation option, the BpSpecReduce bit
+   is detected (functionality present on all such machines) and that
+   practically overrides IBPB on VMEXIT as it has a lot less performance
+   impact and takes care of the guest->host attack vector too.
 
 In order to exploit vulnerability, an attacker needs to:
 
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116bc..43653f2704c93 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,10 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE	(20*32+31) /*
+						    * BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs.
+						    * (SRSO_MSR_FIX in the official doc).
+						    */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 72765b2fe0d87..d35519b337ba2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -721,6 +721,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4f9898836da13..fee115316dd3e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2526,6 +2526,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2543,7 +2544,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2582,7 +2584,7 @@ static void __init srso_select_mitigation(void)
 	    srso_cmd == SRSO_CMD_OFF) {
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
-		return;
+		goto out;
 	}
 
 	if (has_microcode) {
@@ -2594,7 +2596,7 @@ static void __init srso_select_mitigation(void)
 		 */
 		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
-			return;
+			goto out;
 		}
 
 		if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
@@ -2674,6 +2676,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2695,7 +2703,15 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-	pr_info("%s\n", srso_strings[srso_mitigation]);
+	/*
+	 * Clear the feature flag if this mitigation is not selected as that
+	 * feature flag controls the BpSpecReduce MSR bit toggling in KVM.
+	 */
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
+	if (srso_mitigation != SRSO_MITIGATION_NONE)
+		pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e67de787fc714..0660b85883de4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,6 +607,9 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
+
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -684,6 +687,9 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
 	return 0;
 }
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4bf4fad5b148e..5a18ecc04a6c3 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -103,6 +103,7 @@ int msr_set_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, true);
 }
+EXPORT_SYMBOL_GPL(msr_set_bit);
 
 /**
  * msr_clear_bit - Clear @bit in a MSR @msr.
@@ -118,6 +119,7 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
+EXPORT_SYMBOL_GPL(msr_clear_bit);
 
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(unsigned int msr, u64 val, int failed)
-- 
2.39.5


