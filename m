Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1DE377DE3
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhEJISM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:18:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:42733 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhEJISF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:18:05 -0400
IronPort-SDR: /XGzkQGVQV2BJNpY165EhKlNdY/wwdnxxAg7RyFYyTdrm3tLt1mFfCgDBtxedoNug5eaSHkuR4
 Mj11kG0G8BLA==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727881"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727881"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:45 -0700
IronPort-SDR: P2M3+YHXwHkX5cD1X+feZBZomgYx+G/uOKZDGLhArqa13V51r1biWQ88bXUYHTvzz1/75N6ZGq
 g8xqjFxo/wAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250982"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:41 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND kvm-unit-tests PATCH v2] x86: Update guest LBR tests for Architectural LBR
Date:   Mon, 10 May 2021 16:15:35 +0800
Message-Id: <20210510081535.94184-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit-test is intended to test the basic KVM's support for
Architectural LBRs which is a Architectural performance monitor
unit (PMU) feature on Intel processors including negative testing
on the MSR LBR_DEPTH values.

If the LBR bit is set to 1 in the MSR_ARCH_LBR_CTL, the processor
will record a running trace of the most recent branches guest
taken in the LBR entries for guest to read.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 x86/pmu_lbr.c | 88 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 79 insertions(+), 9 deletions(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 3bd9e9f..5257f76 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -6,6 +6,7 @@
 #define MAX_NUM_LBR_ENTRY	  32
 #define DEBUGCTLMSR_LBR	  (1UL <<  0)
 #define PMU_CAP_LBR_FMT	  0x3f
+#define KVM_ARCH_LBR_CTL_MASK	  0x7f000f
 
 #define MSR_LBR_NHM_FROM	0x00000680
 #define MSR_LBR_NHM_TO		0x000006c0
@@ -13,6 +14,10 @@
 #define MSR_LBR_CORE_TO	0x00000060
 #define MSR_LBR_TOS		0x000001c9
 #define MSR_LBR_SELECT		0x000001c8
+#define MSR_ARCH_LBR_CTL	0x000014ce
+#define MSR_ARCH_LBR_DEPTH	0x000014cf
+#define MSR_ARCH_LBR_FROM_0	0x00001500
+#define MSR_ARCH_LBR_TO_0	0x00001600
 
 volatile int count;
 
@@ -61,11 +66,26 @@ static bool test_init_lbr_from_exception(u64 index)
 	return test_for_exception(GP_VECTOR, init_lbr, &index);
 }
 
+static void change_archlbr_depth(void *depth)
+{
+	wrmsr(MSR_ARCH_LBR_DEPTH, *(u64 *)depth);
+}
+
+static bool test_change_archlbr_depth_from_exception(u64 depth)
+{
+	return test_for_exception(GP_VECTOR, change_archlbr_depth, &depth);
+}
+
 int main(int ac, char **av)
 {
 	struct cpuid id = cpuid(10);
+	struct cpuid id_7 = cpuid(7);
+	struct cpuid id_1c;
 	u64 perf_cap;
 	int max, i;
+	bool arch_lbr = false;
+	u32 ctl_msr = MSR_IA32_DEBUGCTLMSR;
+	u64 ctl_value = DEBUGCTLMSR_LBR;
 
 	setup_vm();
 	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
@@ -80,8 +100,19 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
+	if (id_7.d & (1UL << 19)) {
+		arch_lbr = true;
+		ctl_msr = MSR_ARCH_LBR_CTL;
+		/* DEPTH defaults to the maximum number of LBRs entries. */
+		max = rdmsr(MSR_ARCH_LBR_DEPTH) - 1;
+		ctl_value = KVM_ARCH_LBR_CTL_MASK;
+	}
+
 	printf("PMU version:		 %d\n", eax.split.version_id);
-	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
+	if (!arch_lbr)
+		printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
+	else
+		printf("Architectural LBR depth:		 %d\n", max + 1);
 
 	/* Look for LBR from and to MSRs */
 	lbr_from = MSR_LBR_CORE_FROM;
@@ -90,32 +121,71 @@ int main(int ac, char **av)
 		lbr_from = MSR_LBR_NHM_FROM;
 		lbr_to = MSR_LBR_NHM_TO;
 	}
+	if (test_init_lbr_from_exception(0)) {
+		lbr_from = MSR_ARCH_LBR_FROM_0;
+		lbr_to = MSR_ARCH_LBR_TO_0;
+	}
 
 	if (test_init_lbr_from_exception(0)) {
 		printf("LBR on this platform is not supported!\n");
 		return report_summary();
 	}
 
-	wrmsr(MSR_LBR_SELECT, 0);
-	wrmsr(MSR_LBR_TOS, 0);
-	for (max = 0; max < MAX_NUM_LBR_ENTRY; max++) {
-		if (test_init_lbr_from_exception(max))
-			break;
+	if (arch_lbr) {
+		/*
+		 * On processors that support Architectural LBRs,
+		 * IA32_PERF_CAPABILITIES.LBR_FMT will have the value 03FH.
+		 */
+		report(0x3f == (perf_cap & PMU_CAP_LBR_FMT), "The guest LBR_FMT value is good.");
 	}
 
+	/* Reset the guest LBR entries. */
+	if (arch_lbr) {
+		/* On a software write to IA32_LBR_DEPTH, all LBR entries are reset to 0.*/
+		wrmsr(MSR_ARCH_LBR_DEPTH, max + 1);
+	} else {
+		wrmsr(MSR_LBR_SELECT, 0);
+		wrmsr(MSR_LBR_TOS, 0);
+		for (max = 0; max < MAX_NUM_LBR_ENTRY; max++) {
+			if (test_init_lbr_from_exception(max))
+				break;
+		}
+	}
 	report(max > 0, "The number of guest LBR entries is good.");
 
+	/* Check the guest LBR entries are initialized. */
+	for (i = 0; i < max; ++i) {
+		if (rdmsr(lbr_to + i) || rdmsr(lbr_from + i))
+			break;
+	}
+	report(i == max, "The guest LBR initialized FROM_IP/TO_IP values are good.");
+
 	/* Do some branch instructions. */
-	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	wrmsr(ctl_msr, ctl_value);
 	lbr_test();
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	wrmsr(ctl_msr, 0);
 
-	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
+	/* Check if the guest LBR has recorded some branches. */
+	if (!arch_lbr) {
+		report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
+	}
 	for (i = 0; i < max; ++i) {
 		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
 			break;
 	}
 	report(i == max, "The guest LBR FROM_IP/TO_IP values are good.");
 
+	if (!arch_lbr)
+		return report_summary();
+
+	/* Negative testing on the LBR_DEPTH MSR values */
+	id_1c = cpuid(0x1c);
+	for (i = 0; i < 8; i++) {
+		if (id_1c.a & (1UL << i))
+			continue;
+		report(test_change_archlbr_depth_from_exception(8*(i+1)) == 1,
+			"Negative test: guest LBR depth %d is unsupported.", 8*(i+1));
+	}
+
 	return report_summary();
 }
-- 
2.31.1

