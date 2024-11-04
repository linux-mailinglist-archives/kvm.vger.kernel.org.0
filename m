Return-Path: <kvm+bounces-30486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1D09BB0BF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AF8B283465
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59FA1AF0DD;
	Mon,  4 Nov 2024 10:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHFm9Fly"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32B120ED;
	Mon,  4 Nov 2024 10:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715348; cv=none; b=V1gRVtfWoBL1AZ0rYaS34UxOL7a/k5T7d4dYs0AVSPE9Urtyv5DWFvXYDgOljfuSC/Xqv3rWPElDatvKrmOss9GBDwGSL+jpvRdmjIAixZApqRcnIcOPHzYprMdDtSyERxuWtMXqVXCYQ4V8F6xw8Nz3mVmTPmtsW/O+HBkA9Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715348; c=relaxed/simple;
	bh=InWUU3D2Dk79W7Gl9bItAteAnFGljFzsGKpkdweMKHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLBSSlDiOgkAjzE0pvqaakKwZ/Mf1EEV8jbksaLUbhxyka+o3/uAxoex2jqDhWe8DXRunT+DSuigh5fbky4Ss0xwXeGaiYz4fTGwmXls/xwQS5MDpNO9ubMmBYu6a5Y17RgzvRc/6cEAam5ATo1wh17cKOKPMzvkV6vQ0BqS1Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHFm9Fly; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA24CC4CECE;
	Mon,  4 Nov 2024 10:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730715348;
	bh=InWUU3D2Dk79W7Gl9bItAteAnFGljFzsGKpkdweMKHY=;
	h=From:To:Cc:Subject:Date:From;
	b=EHFm9FlyAD2DFhNZT2J0RbMcZoapYZ2+aOcmOxGsdi67+47XT64Qi+Av8s7/MzsE+
	 F4Z/WUczB7PISowE3ja8a83AFgLl/q1gGnL1cD5+Len9SQY3VrsxeT93jL6n8RhlUi
	 4BzhV4nhkeR5LExaV8M17SbLJW8OfUnHBnPwBotvZn9N2CBLppQVz5c8beqzyZe/n5
	 cjw1xtsmne12YIdNpcrog7cdF8eIEzbdnRBhRKt4bLP3mEcqMUEFNjIM2A10TUaSrE
	 hVmzFsDbiPLBnjHR5NkU3hDLCl0ssFDEGREA6N1v+n/ZpJzsr9uOt+TuKUDEpGygI4
	 68xVBJ5GfeFgQ==
From: Borislav Petkov <bp@kernel.org>
To: X86 ML <x86@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Date: Mon,  4 Nov 2024 11:15:43 +0100
Message-ID: <20241104101543.31885-1-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

If the machine has:

  CPUID Fn8000_0021_EAX[30] (SRSO_USER_KERNEL_NO) -- If this bit is 1, it
  indicates the CPU is not subject to the SRSO vulnerability across
  user/kernel boundaries.

have it fall back to IBPB on VMEXIT only, in the case it is going to run
VMs:

  Speculative Return Stack Overflow: CPU user/kernel transitions protected, falling back to IBPB-on-VMEXIT
  Speculative Return Stack Overflow: Mitigation: IBPB on VMEXIT only

Then, upon KVM module load and in case the machine has

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it indicates
  that software may use MSR BP_CFG[BpSpecReduce] to mitigate SRSO.

enable this BpSpecReduce bit to mitigate SRSO across guest/host
boundaries.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeatures.h |  2 ++
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/kernel/cpu/bugs.c         | 16 +++++++++++++++-
 arch/x86/kernel/cpu/common.c       |  1 +
 arch/x86/kvm/cpuid.c               |  1 +
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/lib/msr.c                 |  2 ++
 7 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 924f530129d7..9d71f06e09a4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -462,6 +462,8 @@
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
+#define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_MSR_FIX	(20*32+31) /* MSR BP_CFG[BpSpecReduce] can be used to mitigate SRSO */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..1372a569fb58 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -717,6 +717,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 83b34a522dd7..5dffd1e679da 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2536,6 +2536,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2553,7 +2554,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2628,6 +2630,11 @@ static void __init srso_select_mitigation(void)
 		break;
 
 	case SRSO_CMD_SAFE_RET:
+		if (boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO)) {
+			pr_notice("CPU user/kernel transitions protected, falling back to IBPB-on-VMEXIT\n");
+			goto ibpb_on_vmexit;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			/*
 			 * Enable the return thunk for generated code
@@ -2671,7 +2678,14 @@ static void __init srso_select_mitigation(void)
 		}
 		break;
 
+ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_MSR_FIX)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8f41ab219cf1..ca3b588b51aa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1273,6 +1273,7 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_AMD(0x17, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_AMD(0x19, SRSO),
+	VULNBL_AMD(0x1a, SRSO),
 	{}
 };
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..d54cd67c8c50 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -799,6 +799,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_USER_KERNEL_NO);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..03f29912a638 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -608,6 +608,9 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
+
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -685,6 +688,9 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
 	return 0;
 }
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4bf4fad5b148..5a18ecc04a6c 100644
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
2.43.0


