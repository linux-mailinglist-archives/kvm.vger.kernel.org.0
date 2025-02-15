Return-Path: <kvm+bounces-38272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FE3A36B22
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5D86188C922
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC9418C01D;
	Sat, 15 Feb 2025 01:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rGXifRTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6564153808
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583430; cv=none; b=rjwJq/6XQHex5BIwB8klnbSzKfB78Pk7inndWLbra3iufL7U35QCUMn57Gfb4/TJzeWmCPI4OsbcXdaAbMWFaCvHB7fPOeh9pmmgQuhdbZ82AwhzqmGVCICiNdlGg+R+5LINz9VO2mR9NFuzZyqsNv45DUPDIRGEn00jlCL/MQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583430; c=relaxed/simple;
	bh=36dJ7FDtSrg2Z/pZcoXiQHNuDF/bjf6j18BvsMPgzms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gWZ1XHFxhLLBMAPvZ3nSrNFrKF49LyurjnjIJk1CuAu3bNQtMUY77I42KBa4O2Etptuhi/8eiu1XT2bYbsSgkepswbEkrHLAFCA+yevGyBTicoGM4HHWpnBnEYb/U263qz7f/RcVA5E3Y37FkmPhYKsah3e9C75q7x7RSzWMVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rGXifRTT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc17c3eeb5so4582603a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583428; x=1740188228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=b+q3rVTk6PbBybfg3P/acra/gw9LCBvWZOjGLA9BEbQ=;
        b=rGXifRTTpuA4INKMLaKRvjLQfa6rFQSQGNajPok9vP8+DPWUcfBMIUnpmb0lYxS4WU
         FSTN2/JbzOQun7SWpiRzIArF9IM8B9tRD30I7DhSITuBhbQVUU+DccmR+uHemI/3WvSn
         a90qX4gDe78n8w3lL76lubBQXg+QMZqdI7O3pZcwXsoQOh9+Oj3ZdAo154uTb5PAieJo
         +s+G9NZ9gd+GYI2MuzVtKMP4ndb/2ZsWe1MLfjTzH4hQm+e13CsQ6k33IvL/tGZJ6ecb
         dCXNJhAjmdgSCOdeBKFrYqVQ4SAWdBDpm1Io+fHkgSbsELXblFADSMpoX19Qv6I/prZ9
         S62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583428; x=1740188228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+q3rVTk6PbBybfg3P/acra/gw9LCBvWZOjGLA9BEbQ=;
        b=SotgIWUCPBYdaHItzpHK4YzPzOwD3PlcWjE0oIssx/5yn7v/LUkH5xFO8tsHb7X1TX
         9j9M18010DuQY3ZtTB8zA57OarmU7yOKI85CCc5fnHemWuorjink0VCYnlxqhlYMWO4b
         mPZnReV3wNCnKTrXqhvdLSMFvN16SchC2p2yNcVH55JZeJi+C4SkWAj00sAoOdRiGZGU
         LMO6kEDSM0bokQr0ly9et4Yy71aX0IE++voACwY2nzNt9PxlzdT7Q9GlshQHD7El1Zcy
         jZqkxq94aulTjN19jwDiE6raOoAVcE8te3t5F/dHjgRGwtwLZ/y1FpeqFJeMbr4iNt2l
         cHOQ==
X-Gm-Message-State: AOJu0YxYt9flqUi6hXULZV9xv7VEFIwIwIvF7OyTvMXxiIHRLSv9Oa1h
	v67JBcOOmm4+rifVASiHGd94ztDVat9WH9I+lxVUmSyayyICEomU9LZ3stB5F8r4q0Io0raTDT0
	Mmw==
X-Google-Smtp-Source: AGHT+IFXL5Lw92NC9HZ3n2MZzClI9LGnJV6RFl4t4mLov4BZdmEnj1JCF2mDV6hc9Z1/uIEywCCHZ6tpl14=
X-Received: from pfbfi6.prod.google.com ([2002:a05:6a00:3986:b0:732:2df9:b513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:198c:b0:730:8386:6070
 with SMTP id d2e1a72fcca58-73261445ce1mr2925225b3a.0.1739583428439; Fri, 14
 Feb 2025 17:37:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:35 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-19-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 18/18] x86: pmu: Optimize emulated
 instruction validation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

For support CPUs supporting PERF_GLOBAL_CTRL MSR, the validation for
emulated instruction can be improved to check against precise counts for
instructions and branches events instead of a rough range.

Move enabling and disabling PERF_GLOBAL_CTRL MSR into kvm_fep_asm blob,
thus instructions and branches events can be verified against precise
counts.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 108 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 43 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 3133abed..108eab4b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -14,11 +14,6 @@
 
 #define N 1000000
 
-// These values match the number of instructions and branches in the
-// assembly block in check_emulated_instr().
-#define EXPECTED_INSTR 17
-#define EXPECTED_BRNCH 5
-
 #define IBPB_JMP_INSNS		9
 #define IBPB_JMP_BRANCHES	2
 
@@ -71,6 +66,40 @@ do {								\
 		     : "edi");					\
 } while (0)
 
+/* the number of instructions and branches of the kvm_fep_asm() blob */
+#define KVM_FEP_INSNS		22
+#define KVM_FEP_BRANCHES	5
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
@@ -668,6 +697,7 @@ static void check_running_counter_wrmsr(void)
 
 static void check_emulated_instr(void)
 {
+	u32 eax, edx, ecx;
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
@@ -675,6 +705,7 @@ static void check_emulated_instr(void)
 	unsigned int instruction_idx = pmu.is_intel ?
 				       INTEL_INSTRUCTIONS_IDX :
 				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -690,55 +721,46 @@ static void check_emulated_instr(void)
 	if (this_cpu_has_perf_global_status())
 		pmu_clear_global_status();
 
-	start_event(&brnch_cnt);
-	start_event(&instr_cnt);
+	__start_event(&brnch_cnt, 0);
+	__start_event(&instr_cnt, 0);
 
-	brnch_start = -EXPECTED_BRNCH;
-	instr_start = -EXPECTED_INSTR;
+	brnch_start = -KVM_FEP_BRANCHES;
+	instr_start = -KVM_FEP_INSNS;
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
+		report(instr_cnt.count - instr_start == KVM_FEP_INSNS,
+		       "instruction count");
+		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES,
+		       "branch count");
+	} else {
+		report(instr_cnt.count - instr_start >= KVM_FEP_INSNS,
+		       "instruction count");
+		report(brnch_cnt.count - brnch_start >= KVM_FEP_BRANCHES,
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
2.48.1.601.g30ceb7b040-goog


