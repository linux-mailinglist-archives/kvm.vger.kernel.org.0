Return-Path: <kvm+bounces-32821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDF19E0409
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 14:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A01B8B25267
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C098D20CCDB;
	Mon,  2 Dec 2024 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RL93bExF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA37E20CCC5;
	Mon,  2 Dec 2024 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733141068; cv=none; b=rcC8NmWcEHVJeNZMtuSJrhVIwOKwFJ33BPo1+4pXaz0Rdb35a2Buiu2ky3H4bMeYLDhfqsO/dsOnIOfMdqUGJ29QGcHf13s/lrOh87IEVofGzxirvh4Kt+t7wls8gHrsD4JrTvDotG/NXYVvnvwxBthtOk3oZNrE35dWJDBOC0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733141068; c=relaxed/simple;
	bh=rwIZNHK8K2cbMDrjttnAWkZObvHb0ZFLdaa8N3u5Gag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9Au7r6qOfNrNCrJClbgAytIKynZ14SS0bPq2zX205mIlbDEh7HIJv4GCDLhCXXAbe+vvQlv92uLSBvzeQ+UOLlR625wduMcw+OCPCkdAr6Fwe8FXuieLNatKCgiIujt3CoXoDZBf2GhRdUbjYGFCmu0WeiXGABIKVcVXK+SatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RL93bExF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C3CC4CED2;
	Mon,  2 Dec 2024 12:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733141067;
	bh=rwIZNHK8K2cbMDrjttnAWkZObvHb0ZFLdaa8N3u5Gag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RL93bExFYhz4owtaRmYkI8/ptRqQXYfU4Ernovq07v/1uOQ2He+CwsUA2YUnc3zlD
	 +WWf8coQU0C6LUu8BYQCqf8L3ATQ2UPx4g5VtVCnfdkkZEIHCACuOIX60SHa5jOijM
	 xIH5l/5PTRTK2UovFvfL02zG+6lxY16MSukdxXR/nL8Xx/HraryZIB+y6hdNyRwPNv
	 HZ4uy9sdMMfTrFF2K1DGtqrj5TncTVwf6zIh/JboK1r/LLTV4YbI3j0XiRUXuBCuUY
	 3yCa+w3PZbfCqDwh2TsVnx96wjcB6xcCj0qlD9gRSaeGuwTEO+0y8f0pGmiBKKLCmX
	 DeYvWhn4LDoUw==
From: Borislav Petkov <bp@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Date: Mon,  2 Dec 2024 13:04:15 +0100
Message-ID: <20241202120416.6054-4-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241202120416.6054-1-bp@kernel.org>
References: <20241202120416.6054-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

enable this BpSpecReduce bit to mitigate SRSO across guest/host
boundaries.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---

v2: Add some doc blurb about the modalities of the mitigation.

 Documentation/admin-guide/hw-vuln/srso.rst | 10 ++++++++++
 arch/x86/include/asm/cpufeatures.h         |  1 +
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 10 +++++++++-
 arch/x86/kvm/svm/svm.c                     |  6 ++++++
 arch/x86/lib/msr.c                         |  2 ++
 6 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index 2ad1c05b8c88..79a8f7dea06d 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -104,7 +104,17 @@ The possible values in this file are:
 
    (spec_rstack_overflow=ibpb-vmexit)
 
+ * 'Mitigation: Reduced Speculation':
 
+   This mitigation gets automatically enabled when the above one "IBPB on
+   VMEXIT" has been selected and the CPU supports the BpSpecReduce bit.
+
+   Currently, the mitigation is automatically enabled when KVM enables
+   virtualization and can incur some cost. If no VMs will run on the system,
+   you can either disable virtualization or set kvm.enable_virt_at_load=0 to
+   enable it only when a VM gets started and thus when really needed. See the
+   text in Documentation/admin-guide/kernel-parameters.txt on this parameter
+   for more details.
 
 In order to exploit vulnerability, an attacker needs to:
 
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2787227a8b42..94582c0ed9f2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -465,6 +465,7 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_MSR_FIX	(20*32+31) /* MSR BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs */
 
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
index 8854d9bce2a5..a2eb7c0700da 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2523,6 +2523,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2540,7 +2541,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2665,6 +2667,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..e4fad330cd25 100644
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


