Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D7932C651
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378993AbhCDA22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:44167 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242945AbhCCOSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:04 -0500
IronPort-SDR: skKflAtxweii8+DZcb16U+hqFcOIR/NtUmhzupaQHDYJlAz1ugUZOmG8kweFrBKj75rQX3UTNh
 gcnbpcq3jrMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183819046"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183819046"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:52 -0800
IronPort-SDR: ZGZV29hhF3391vVbzakTKbsbPpuGvQwk9XF2rJEh4TH6Hi9X/zzV3yovcsRCh7Tns9Cbj2Vi0h
 M9nGT5ZHXmhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729508"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:49 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86: Update guest LBR tests for Architectural LBR
Date:   Wed,  3 Mar 2021 21:57:56 +0800
Message-Id: <20210303135756.1546253-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303135756.1546253-1-like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit-test is intended to test the KVM's support for the
Architectural LBRs which is a Architectural performance monitor
unit (PMU) feature on Intel processors.

If the LBR bit is set to 1 in the MSR_ARCH_LBR_CTL, the processor
will record a running trace of the most recent branches guest
taken in the LBR entries for guest to read.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 x86/pmu_lbr.c | 62 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 3bd9e9f..588aec8 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -6,6 +6,7 @@
 #define MAX_NUM_LBR_ENTRY	  32
 #define DEBUGCTLMSR_LBR	  (1UL <<  0)
 #define PMU_CAP_LBR_FMT	  0x3f
+#define KVM_ARCH_LBR_CTL_MASK			0x7f000f
 
 #define MSR_LBR_NHM_FROM	0x00000680
 #define MSR_LBR_NHM_TO		0x000006c0
@@ -13,6 +14,10 @@
 #define MSR_LBR_CORE_TO	0x00000060
 #define MSR_LBR_TOS		0x000001c9
 #define MSR_LBR_SELECT		0x000001c8
+#define MSR_ARCH_LBR_CTL		0x000014ce
+#define MSR_ARCH_LBR_DEPTH		0x000014cf
+#define MSR_ARCH_LBR_FROM_0		0x00001500
+#define MSR_ARCH_LBR_TO_0		0x00001600
 
 volatile int count;
 
@@ -66,6 +71,9 @@ int main(int ac, char **av)
 	struct cpuid id = cpuid(10);
 	u64 perf_cap;
 	int max, i;
+	bool arch_lbr = false;
+	u32 ctl_msr = MSR_IA32_DEBUGCTLMSR;
+	u64 ctl_value = DEBUGCTLMSR_LBR;
 
 	setup_vm();
 	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
@@ -80,8 +88,23 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
+	/*
+	 * On processors that support Architectural LBRs,
+	 * IA32_PERF_CAPABILITIES.LBR_FMT will have the value 03FH.
+	 */
+	if (0x3f == (perf_cap & PMU_CAP_LBR_FMT)) {
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
@@ -90,27 +113,46 @@ int main(int ac, char **av)
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
 	}
-
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
-- 
2.29.2

