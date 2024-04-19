Return-Path: <kvm+bounces-15202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B125A8AA77D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E69A5B2147A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E8C1118B;
	Fri, 19 Apr 2024 03:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OIaSYVNR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348B67F7F3;
	Fri, 19 Apr 2024 03:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498385; cv=none; b=gReezH3LIZNu5jzaKw0LC5/Y0ZFqbTS7ZAMih1Ooz12Qri5K3osiPoqIIJqrfggygazCJHv4Z1uFVt74DJJwdKDSAUf61z99Wtv2w74d69aWu/nV/D+EvBsoaIkgb4z4AzQCUGOs/S74KBJk0X5fXMHDe/12be2N0qnDY8WeQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498385; c=relaxed/simple;
	bh=BOCLUCvoA9G68ezGtgdPML+FLT+IPlvWgEm4jrl3wZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FFShIcOKZcCzAKjlKw/st5u7ReQ5gh2xOCJ/XXjnn9SO9VMHNmSuVwCp2dzt8it9knpsuE/gC+GnocuRKn4dC+G+DOGmSzIYO7IUHDkqzgru4DsBprXIaVf16nxZSSHfu6vx1PTOR+UVI1Ye1qOxeQFAuBkvT/KGYIclCeDuIBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OIaSYVNR; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498384; x=1745034384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BOCLUCvoA9G68ezGtgdPML+FLT+IPlvWgEm4jrl3wZ0=;
  b=OIaSYVNReAEV4ErJWbnBoj1irinwA7QDKPsE8NLhtGJfQ+MaqjuOgEm9
   8JFyTB7WrOXaWU13sfP3BiYRpdfXRCoYxldMFa2yIKljkI14Y4f9G3afx
   hTZRSYBIrgUUvNIAo+SSJPHS70UmMB4y44B7rR+ITuNxMeMIG17/FbBuY
   cceo2ihB169k5T3jSio9sNpJREBzJplnc5tmxcd61DGxHUX7qw6LVUIia
   0/Ui2O2fKJLoHOXpPE0wwDF1TW/JhOSmbbSOG+G5R6Fz6uazvNSy3OtXj
   8BSKMSGXfHQihjQIPLG7mM73rA19eA3/Vex5jvDy2sBRSBJUslpKAdKgv
   g==;
X-CSE-ConnectionGUID: T6PqFqejRJypdV6FLXpTMw==
X-CSE-MsgGUID: hULK0nvkQ9OLmC61io0snw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565516"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565516"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:24 -0700
X-CSE-ConnectionGUID: jlJk7cBbRPer8HCEfwmGnQ==
X-CSE-MsgGUID: WVXnpKhDTVOGVm/e0gRkGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410340"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:21 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 17/17] x86: pmu: Optimize emulated instruction validation
Date: Fri, 19 Apr 2024 11:52:33 +0800
Message-Id: <20240419035233.3837621-18-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For support CPUs supporting PERF_GLOBAL_CTRL MSR, the validation for
emulated instruction can be improved to check against precise counts for
instructions and branches events instead of a rough range.

Move enabling and disabling PERF_GLOBAL_CTRL MSR into kvm_fep_asm blob,
thus instructions and branches events can be verified against precise
counts.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 108 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 43 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index e0da522c004b..dd83f157b35c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -13,11 +13,6 @@
 
 #define N 1000000
 
-// These values match the number of instructions and branches in the
-// assembly block in check_emulated_instr().
-#define EXPECTED_INSTR 17
-#define EXPECTED_BRNCH 5
-
 #define IBPB_JMP_INSTRNS      7
 #define IBPB_JMP_BRANCHES     1
 #define IBPB_JMP_ASM(_wrmsr)				\
@@ -54,6 +49,40 @@ do {								\
 		     : "edi");					\
 } while (0)
 
+/* the number of instructions and branches of the kvm_fep_asm() blob */
+#define KVM_FEP_INSTR	22
+#define KVM_FEP_BRNCH	5
+
+/*
+ * KVM_FEP is a magic prefix that forces emulation so
+ * 'KVM_FEP "jne label\n"' just counts as a single instruction.
+ */
+#define kvm_fep_asm(_wrmsr)			\
+do {						\
+	asm volatile(				\
+		_wrmsr "\n\t"			\
+		"mov %%ecx, %%edi;\n\t"		\
+		"mov $0x0, %%eax;\n\t"		\
+		"cmp $0x0, %%eax;\n\t"		\
+		KVM_FEP "jne 1f\n\t"		\
+		KVM_FEP "jne 1f\n\t"		\
+		KVM_FEP "jne 1f\n\t"		\
+		KVM_FEP "jne 1f\n\t"		\
+		KVM_FEP "jne 1f\n\t"		\
+		"mov $0xa, %%eax; cpuid;\n\t"	\
+		"mov $0xa, %%eax; cpuid;\n\t"	\
+		"mov $0xa, %%eax; cpuid;\n\t"	\
+		"mov $0xa, %%eax; cpuid;\n\t"	\
+		"mov $0xa, %%eax; cpuid;\n\t"	\
+		"1: mov %%edi, %%ecx; \n\t"	\
+		"xor %%eax, %%eax; \n\t"	\
+		"xor %%edx, %%edx;\n\t"		\
+		_wrmsr "\n\t"			\
+		:				\
+		: "a"(eax), "d"(edx), "c"(ecx)	\
+		: "ebx", "edi");		\
+} while (0)
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -639,6 +668,7 @@ static void check_running_counter_wrmsr(void)
 
 static void check_emulated_instr(void)
 {
+	u32 eax, edx, ecx;
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
@@ -646,6 +676,7 @@ static void check_emulated_instr(void)
 	unsigned int instruction_idx = pmu.is_intel ?
 				       INTEL_INSTRUCTIONS_IDX :
 				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -661,55 +692,46 @@ static void check_emulated_instr(void)
 	if (this_cpu_has_perf_global_status())
 		pmu_clear_global_status();
 
-	start_event(&brnch_cnt);
-	start_event(&instr_cnt);
+	__start_event(&brnch_cnt, 0);
+	__start_event(&instr_cnt, 0);
 
-	brnch_start = -EXPECTED_BRNCH;
-	instr_start = -EXPECTED_INSTR;
+	brnch_start = -KVM_FEP_BRNCH;
+	instr_start = -KVM_FEP_INSTR;
 	wrmsr(MSR_GP_COUNTERx(0), brnch_start & gp_counter_width);
 	wrmsr(MSR_GP_COUNTERx(1), instr_start & gp_counter_width);
-	// KVM_FEP is a magic prefix that forces emulation so
-	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
-	asm volatile(
-		"mov $0x0, %%eax\n"
-		"cmp $0x0, %%eax\n"
-		KVM_FEP "jne label\n"
-		KVM_FEP "jne label\n"
-		KVM_FEP "jne label\n"
-		KVM_FEP "jne label\n"
-		KVM_FEP "jne label\n"
-		"mov $0xa, %%eax\n"
-		"cpuid\n"
-		"mov $0xa, %%eax\n"
-		"cpuid\n"
-		"mov $0xa, %%eax\n"
-		"cpuid\n"
-		"mov $0xa, %%eax\n"
-		"cpuid\n"
-		"mov $0xa, %%eax\n"
-		"cpuid\n"
-		"label:\n"
-		:
-		:
-		: "eax", "ebx", "ecx", "edx");
 
-	if (this_cpu_has_perf_global_ctrl())
-		wrmsr(pmu.msr_global_ctl, 0);
+	if (this_cpu_has_perf_global_ctrl()) {
+		eax = BIT(0) | BIT(1);
+		ecx = pmu.msr_global_ctl;
+		edx = 0;
+		kvm_fep_asm("wrmsr");
+	} else {
+		eax = ecx = edx = 0;
+		kvm_fep_asm("nop");
+	}
 
-	stop_event(&brnch_cnt);
-	stop_event(&instr_cnt);
+	__stop_event(&brnch_cnt);
+	__stop_event(&instr_cnt);
 
 	// Check that the end count - start count is at least the expected
 	// number of instructions and branches.
-	report(instr_cnt.count - instr_start >= EXPECTED_INSTR,
-	       "instruction count");
-	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
-	       "branch count");
+	if (this_cpu_has_perf_global_ctrl()) {
+		report(instr_cnt.count - instr_start == KVM_FEP_INSTR,
+		       "instruction count");
+		report(brnch_cnt.count - brnch_start == KVM_FEP_BRNCH,
+		       "branch count");
+	} else {
+		report(instr_cnt.count - instr_start >= KVM_FEP_INSTR,
+		       "instruction count");
+		report(brnch_cnt.count - brnch_start >= KVM_FEP_BRNCH,
+		       "branch count");
+	}
+
 	if (this_cpu_has_perf_global_status()) {
 		// Additionally check that those counters overflowed properly.
 		status = rdmsr(pmu.msr_global_status);
-		report(status & 1, "branch counter overflow");
-		report(status & 2, "instruction counter overflow");
+		report(status & BIT_ULL(0), "branch counter overflow");
+		report(status & BIT_ULL(1), "instruction counter overflow");
 	}
 
 	report_prefix_pop();
-- 
2.34.1


