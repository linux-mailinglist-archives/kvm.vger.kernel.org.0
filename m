Return-Path: <kvm+bounces-26913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 839D6978EBD
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B945AB27C73
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F411D1737;
	Sat, 14 Sep 2024 07:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XK7UerGB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682361D12EA;
	Sat, 14 Sep 2024 07:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297323; cv=none; b=uUUNO/mIEbD4FVbIlgqZkaWyqSNZ9jiHkwbMn+lKNciX7vn8URXvcsMGusprsECuArTF02RTDEIRAdJaUu+5HFHYYF3jWHf1HU9QEZkgXMGMKdluo3auuT2NDr/zrWMAci32qcKXiMaJGsSmXzCrJXxi+9iQ3D2ol8lBgFV/XTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297323; c=relaxed/simple;
	bh=M4FmLtoUVjDaLJG+tUmv0c1pIfIWLYH5Bz71t6kstTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P97t05FJPfDA7sX3WBrcMmmv15EGnExirYin21siezJgvFIeYRu+uiAjKP6Y8BC5zYCQgD9Vr1hmdBTguHnRWLaeI85eEYBVIvyyVOAzf8kYwAghA0Q5lZD2NXep0kwEyWLHXGV+OzzcE5sOX9nBD6ZoZkTBWnNlCPmoB+OOUuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XK7UerGB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297322; x=1757833322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M4FmLtoUVjDaLJG+tUmv0c1pIfIWLYH5Bz71t6kstTk=;
  b=XK7UerGBQWPJJq6U5+UUErH8aVe4yFiDko5YXGF5ZfnagahZMYyvJ2ZW
   GRVZEqZ8T4rPcSBdCU7/G4QeybRLSkebk+kJIAQTvnnEqqXyhdydj2bh8
   l7qbmq/cp549v2xSnUd1rtihVIbQEf8xKf8q0I0lqV/eC/7T1mc7lBp++
   GBdjTZ721qAZ39nnbzkZnbwt2Y+AmqgEavBNrM9HT+U5/rhYWyQLN5FEw
   CMyrO6mZzq8lbvXddCKWptbwNDQOT9IfNVIvluJfzrP1K/WZb5FOUro97
   9utEJotSsm4wDZv+koYi6FebmCfyeVywcHDCKxuXBtBNC+OrV+Jav4uly
   w==;
X-CSE-ConnectionGUID: uNThJpO9Rk2ecFFYHAsemQ==
X-CSE-MsgGUID: LG8Msil4Tp2QgYOHPZNtwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778899"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778899"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:02:02 -0700
X-CSE-ConnectionGUID: TuQxA9nDRt+TpaV1XfE+6g==
X-CSE-MsgGUID: FqI4piiFRryiZ6XGpGAoYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67951026"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:59 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 18/18] x86: pmu: Optimize emulated instruction validation
Date: Sat, 14 Sep 2024 10:17:28 +0000
Message-Id: <20240914101728.33148-19-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
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
index c7848fd1..3a5659b2 100644
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
@@ -672,6 +701,7 @@ static void check_running_counter_wrmsr(void)
 
 static void check_emulated_instr(void)
 {
+	u32 eax, edx, ecx;
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
@@ -679,6 +709,7 @@ static void check_emulated_instr(void)
 	unsigned int instruction_idx = pmu.is_intel ?
 				       INTEL_INSTRUCTIONS_IDX :
 				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -694,55 +725,46 @@ static void check_emulated_instr(void)
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


