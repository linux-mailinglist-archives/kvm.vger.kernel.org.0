Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1868256B43C
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 10:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbiGHINQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 04:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiGHINP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 04:13:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AA87E034
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657267994; x=1688803994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iTskaKRzDbpPiXGX7jALlvV+lo4Izfhj2qHiicqyfhI=;
  b=hL69tSWO7FUDL+IBt2tar+xNT7eJGGDOvX9N/qZk+LMWNoKNXY5L6f+z
   fFysfzZ7TWuBHVnxYhyZdWFkG0lLV2PxzaqjOh4AeGWc83e6RG0NzXQ/g
   08/9fYX6pgn8Q3EaGS+RNpE6EKaY0dbZcqd306EqFkqnG2szWG4c6x4kZ
   h6tP/m44KnqZsh2R4TK3uY7OS1HYAhPOag2NVqpoLfgdCt0fuMMLfNxji
   Sy76NONuLP3S4xusA70rR8/cPW8M3/0agq4U8xuNBMR3aLGWUqG0Jv/Lb
   CwtGCsK9xRxKKGgYn8VmTHSqQ3drkgWoV3ZLDdipq+Ed3si8nCqji06RY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264640244"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="264640244"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="651478982"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v5 3/3] x86: Check platform vPMU capabilities before run lbr tests
Date:   Fri,  8 Jul 2022 01:11:19 -0400
Message-Id: <20220708051119.124100-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220708051119.124100-1-weijiang.yang@intel.com>
References: <20220708051119.124100-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

---

v5:
 Use new helpers to check pmu availability and get pmu version.[Sean]

 lib/x86/processor.h |  1 +
 x86/pmu_lbr.c       | 31 ++++++++++++-------------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 59cedc9..b3b22b8 100644
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
index 688634d..c6ddabf 100644
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
@@ -63,7 +52,6 @@ static bool test_init_lbr_from_exception(u64 index)
 
 int main(int ac, char **av)
 {
-	struct cpuid id = cpuid(10);
 	u64 perf_cap;
 	int max, i;
 
@@ -74,19 +62,24 @@ int main(int ac, char **av)
 		return 0;
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
-	eax.full = id.a;
-
-	if (!eax.split.version_id) {
+	if (!cpu_has_pmu()) {
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
+	printf("PMU version:		 %d\n", pmu_version());
 	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
 
 	/* Look for LBR from and to MSRs */
-- 
2.31.1

