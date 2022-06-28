Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6A755D579
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbiF1Jd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344429AbiF1Jcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:32:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E831EC5D
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656408766; x=1687944766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XTSXg/Qo8UXirUrVG7O0Bbe2Q2n9sZ3qonV3lgkiqI8=;
  b=LF8hcwjxotaNa0jX1YkKf0DFjpOMYIIHSbQYB0eSAXCkQu+UeOY7ppBG
   kfHjFbN62DeOxTDTalkRZdYMhSMUQ5FNxIoo09YqssN2MTwzGqq7Sefh2
   7HtHpdlIRUcIuSGw+u04s/xvQtPS4rjfDaODhwBxqsOWP1GgTZkMzKO8g
   8cnDbL4HT3FdYgR3s2fQhgoSYeNbZrEnkOMLwcSqgECjj56gpt1OmapnK
   jP4idEtcqj65WnqvQ6/inyaPI0f39W2D0gCZ0xhY59lvVXztYmBuAxeWD
   RkkuETSLxk2WJ6Fr4lxKQhshOQiaJlp3x7KAHGTjYWsTMY253Hn2j61zn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307171615"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307171615"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:32:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="565015288"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:32:45 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v4 2/2] x86: Check platform vPMU capabilities before run lbr tests
Date:   Tue, 28 Jun 2022 05:32:03 -0400
Message-Id: <20220628093203.73160-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220628093203.73160-1-weijiang.yang@intel.com>
References: <20220628093203.73160-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new helper to check whether pmu is available and Perfmon/Debug
capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
avoid test failure. The issue can be captured when enable_pmu=0.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

v4:
- Put the X86_FEATURE_PDCM to the right place. [Sean]
---
 lib/x86/processor.h |  1 +
 x86/pmu_lbr.c       | 32 +++++++++++++-------------------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 7b6ee92..7a35c7f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -146,6 +146,7 @@ static inline bool is_intel(void)
  */
 #define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
 #define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
+#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
 #define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
 #define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 688634d..497df1e 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -15,6 +15,7 @@
 #define MSR_LBR_SELECT		0x000001c8
 
 volatile int count;
+u32 lbr_from, lbr_to;
 
 static noinline int compute_flag(int i)
 {
@@ -38,18 +39,6 @@ static noinline int lbr_test(void)
 	return 0;
 }
 
-union cpuid10_eax {
-	struct {
-		unsigned int version_id:8;
-		unsigned int num_counters:8;
-		unsigned int bit_width:8;
-		unsigned int mask_length:8;
-	} split;
-	unsigned int full;
-} eax;
-
-u32 lbr_from, lbr_to;
-
 static void init_lbr(void *index)
 {
 	wrmsr(lbr_from + *(int *) index, 0);
@@ -63,7 +52,7 @@ static bool test_init_lbr_from_exception(u64 index)
 
 int main(int ac, char **av)
 {
-	struct cpuid id = cpuid(10);
+	u8 version = pmu_version();
 	u64 perf_cap;
 	int max, i;
 
@@ -74,19 +63,24 @@ int main(int ac, char **av)
 		return 0;
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
-	eax.full = id.a;
-
-	if (!eax.split.version_id) {
+	if (!version) {
 		printf("No pmu is detected!\n");
 		return report_summary();
 	}
+
+	if (!this_cpu_has(X86_FEATURE_PDCM)) {
+		printf("Perfmon/Debug Capabilities MSR isn't supported\n");
+		return report_summary();
+	}
+
+	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
-		printf("No LBR is detected!\n");
+		printf("(Architectural) LBR is not supported.\n");
 		return report_summary();
 	}
 
-	printf("PMU version:		 %d\n", eax.split.version_id);
+	printf("PMU version:		 %d\n", version);
 	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
 
 	/* Look for LBR from and to MSRs */
-- 
2.27.0

