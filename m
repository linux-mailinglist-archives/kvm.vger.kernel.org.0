Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA84559613
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 11:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiFXJJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 05:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiFXJJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 05:09:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B34F1DD
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 02:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656061761; x=1687597761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5UgISola8I03cHb1gjJsUYZEvKvIFeYtnshjcKfjKrE=;
  b=aOLj0tWEEbFXVe1MSndm2VKrfl95w1c9kkwQSEylRCgTQux+Wkn9wJYm
   oVq4ifyNIGSJwCdXjvDvQS6zzyTcPc7u0G3DI8AlBqsO6n3nHMQs9ZmVQ
   xD+L5Aoo5Ik3TtOIvXGOQ0oviPziKwTilsAmd4eD97UMX9fgbqa8dkgt3
   hXRnskHkW1rbhYaJby14+A870O2ErBD4xGygvZk1VlDMivhiYoY2YWedh
   godGswzFr7YTWkeWeIPROHU2ke3r9blxkg0TMMUQsBlIWkQuezTPQ5zmK
   oX6tvaKZ0j7iSaTurcxv6rfX8BxqdshdPkUVqLx8PE3OZZJMnp0MB7gsX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="278509306"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="278509306"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="539222088"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 3/3] x86: Check platform vPMU capabilities before run lbr tests
Date:   Fri, 24 Jun 2022 05:08:28 -0400
Message-Id: <20220624090828.62191-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220624090828.62191-1-weijiang.yang@intel.com>
References: <20220624090828.62191-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new helper to check whether pmu is available and Perfmon/Debug
capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
avoid test failure. The issue can be captured when enable_pmu=0.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 lib/x86/processor.h |  2 +-
 x86/pmu_lbr.c       | 32 +++++++++++++-------------------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 70b9193..bb917b0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -193,7 +193,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
-
+#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
 
 static inline bool this_cpu_has(u64 feature)
 {
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

