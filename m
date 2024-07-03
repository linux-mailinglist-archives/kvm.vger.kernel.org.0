Return-Path: <kvm+bounces-20880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F33924DB3
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51D4E1F23749
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7129130A79;
	Wed,  3 Jul 2024 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnCqVStn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB9710A1E;
	Wed,  3 Jul 2024 02:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972801; cv=none; b=pT19eSy+gNRO02rujNuff4YFXrJEVtCWukDPk3Kp6WOyCxDcyZD2T6u12egYHl1URZdgvWBayodnnNzN4z/WbWrFvW1nehLU/mzjOn6RiTz5bezdOzAtkojf42VSRiE6K3lQMqCUS+yqQaOGViLJgITc1IE8ZXBdvAxSQgPr1LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972801; c=relaxed/simple;
	bh=ciSUeWBAGQMz9pe7aSv/H22PbF+4ejL3Z1cUYp7+raY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z58imQRfFudCr9HmHOBvBlYdNRsmQfEaJ0+Z5ktmHESN+pldqqZPhXyccfSstn9T/SEJ1ZIq4hiU5XR7NcEghjPRkh9EJSp1q82SwwYq7Kgmu6Dkr6Pc3TyK5yPJeYtsjY0Wj/scGdXo7VzIGHeohfxyyqg9Mv8IgOm0G+dbA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnCqVStn; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972800; x=1751508800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ciSUeWBAGQMz9pe7aSv/H22PbF+4ejL3Z1cUYp7+raY=;
  b=BnCqVStnO17p46bgWHUEi7A8SJR9DADge4AZfi2EIRheQ1sNhQr1gHER
   14zgTcGcnYkASNu+KSO39gfLIhSzlM5QplQkScQj3fI9oJd9WTYEAzr3q
   egg8iLwj8x6g0yS+6Zx7jPxdM50Mj/gbpSWeUV2IZuATLJQFEE4pJ5eRc
   J96zjV+pLkuvT/qIgHKZBV5aQ3zxq1qh5NZBxLjQKvH+eNQNCDRNCU3Cr
   Ir0MoM1IxenTKHGBd2CGrmqetz/MkOD8AVgFEn48sQIvMOgYPMW0LDpeR
   k5qCnPMHbFuXyOm4eBeoqoWchAmzXmVc75iFDAj3argRVOOcr3dKPLQju
   w==;
X-CSE-ConnectionGUID: Fq15KemDQn6dpVEyFCBQuw==
X-CSE-MsgGUID: 9wX/M+eYSEm3VpggKjgh7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311137"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311137"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:20 -0700
X-CSE-ConnectionGUID: 73CqSKmoSW+bnksAb6sk2A==
X-CSE-MsgGUID: IK6MbL24RH6wcxDTeFU8CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148860"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:17 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 17/18] x86: pmu: Optimize emulated instruction validation
Date: Wed,  3 Jul 2024 09:57:11 +0000
Message-Id: <20240703095712.64202-18-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
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
index 4026deab..332d274c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -14,11 +14,6 @@
 
 #define N 1000000
 
-// These values match the number of instructions and branches in the
-// assembly block in check_emulated_instr().
-#define EXPECTED_INSTR 17
-#define EXPECTED_BRNCH 5
-
 #define IBPB_JMP_INSTRNS      9
 #define IBPB_JMP_BRANCHES     2
 
@@ -71,6 +66,40 @@ do {								\
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
@@ -657,6 +686,7 @@ static void check_running_counter_wrmsr(void)
 
 static void check_emulated_instr(void)
 {
+	u32 eax, edx, ecx;
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
@@ -664,6 +694,7 @@ static void check_emulated_instr(void)
 	unsigned int instruction_idx = pmu.is_intel ?
 				       INTEL_INSTRUCTIONS_IDX :
 				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -679,55 +710,46 @@ static void check_emulated_instr(void)
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
2.40.1


