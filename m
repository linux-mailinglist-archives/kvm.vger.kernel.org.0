Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0E56D69D
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiGKHVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiGKHVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:21:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85C2DF46
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657524068; x=1689060068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/lBamZVQjssKaCrXr1DnOw2Xu7R6jcPqr2nr+gHAVs4=;
  b=dru2HtxJ1l19BoH904wAoAHyxzZAscC+t9TsIKKyWiF9+UVMDJYrX4Yb
   UwMhcIufRK0Ilyhs/WVMlnClulzRcheWukFnABTuUv1zfIB2uPxVBfYzk
   grtdpLfgQJQrW24L5r7ukzoFeXt6nRQG3JVXyUE9f8aTVJ5t2JsSXr2fa
   Eq0frE+08CvyIVF0JXKY/zc51byjrQwwNanrYOp8XhTQqNXRYsqs8jAwn
   p+pCqW9F5khm7kd7wPEQSvO3R9gCSWehBaSyZwKC1v4hO9HPjApvpQLNK
   o3poRtbnsnw1oZYPm/o3rDX5oOaskObfaTZjTXU7IGGlLlZe0KfU+gJZB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267636833"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="267636833"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="627392557"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 4/4] x86: Check platform pmu capabilities before run lbr tests
Date:   Mon, 11 Jul 2022 00:18:41 -0400
Message-Id: <20220711041841.126648-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220711041841.126648-1-weijiang.yang@intel.com>
References: <20220711041841.126648-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
 lib/x86/processor.h |  1 +
 x86/pmu_lbr.c       | 33 +++++++++++++--------------------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b772cf3..c192a25 100644
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
index 688634d..22c8c69 100644
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
+	if (!cpu_has_pmu()) {
+		report_skip("No pmu is detected!");
+		return report_summary();
+	}
 
-	if (!eax.split.version_id) {
-		printf("No pmu is detected!\n");
+	if (!this_cpu_has(X86_FEATURE_PDCM)) {
+		report_skip("Perfmon/Debug Capabilities MSR isn't supported.");
 		return report_summary();
 	}
+
+	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
-		printf("No LBR is detected!\n");
+		report_skip("(Architectural) LBR is not supported.");
 		return report_summary();
 	}
 
-	printf("PMU version:		 %d\n", eax.split.version_id);
+	printf("PMU version:		 %d\n", pmu_version());
 	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
 
 	/* Look for LBR from and to MSRs */
@@ -98,7 +91,7 @@ int main(int ac, char **av)
 	}
 
 	if (test_init_lbr_from_exception(0)) {
-		printf("LBR on this platform is not supported!\n");
+		report_skip("LBR on this platform is not supported!");
 		return report_summary();
 	}
 
-- 
2.31.1

