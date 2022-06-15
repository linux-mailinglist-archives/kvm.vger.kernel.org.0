Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AD154C3EB
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346616AbiFOIrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 04:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346564AbiFOIrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 04:47:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C6E4B1FE
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282839; x=1686818839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WlaiicrSb+fipzRN1t4aoedCo2QbYUEsTTeeogoj3sg=;
  b=oJgLfGE+azoLRwNPQ/ZZ/VrukHfSuHn4+istVZQThYLkbimOhcHFFL27
   o8BLPtJNt5Zx2QkKZ5opIsJnrNmaaXfgAS/to9eh6Bz7N56yPHtfjOVUQ
   27U1rTgr3UVa783mV9a91Z9G/L+35PNFJJrlx0gjvN0jzL6y9/Ppgr5LI
   KpfyLp+wXyf9CkvA4hRxszz+BpgfAjJ7+PJqORKkwjXIGZJ+Bd0ozwHwA
   JvnSsE/Jhx7Udg3eMiD6y5yfGWhb6gYPAC3Nm4WtyS/Xc+V0Tdze5RfE0
   6IzdYuctBUg6GE1f4eKn/tyrH08Zf1QDmIiQeramzjWGK4Iei2up6hI52
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="342848610"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="342848610"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="558944462"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     like.xu.linux@gmail.com, jmattson@google.com, kvm@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 2/3] x86: Skip running test when pmu is disabled
Date:   Wed, 15 Jun 2022 04:46:40 -0400
Message-Id: <20220615084641.6977-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220615084641.6977-1-weijiang.yang@intel.com>
References: <20220615084641.6977-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Read MSR_IA32_PERF_CAPABILITIES triggers #GP when pmu is disabled
by enable_pmu=0 in KVM. Let's check whether pmu is available before
issue msr reading to avoid the #GP. Also check PDCM bit before read
the MSR.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/pmu_lbr.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 688634d..62614a0 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -5,6 +5,7 @@
 #define N 1000000
 #define MAX_NUM_LBR_ENTRY	  32
 #define DEBUGCTLMSR_LBR	  (1UL <<  0)
+#define PDCM_ENABLED	  (1UL << 15)
 #define PMU_CAP_LBR_FMT	  0x3f
 
 #define MSR_LBR_NHM_FROM	0x00000680
@@ -74,13 +75,22 @@ int main(int ac, char **av)
 		return 0;
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	eax.full = id.a;
 
 	if (!eax.split.version_id) {
 		printf("No pmu is detected!\n");
 		return report_summary();
 	}
+
+	id = cpuid(1);
+
+	if (!(id.c & PDCM_ENABLED)) {
+		printf("No PDCM is detected!\n");
+		return report_summary();
+	}
+
+	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
 		printf("No LBR is detected!\n");
 		return report_summary();
-- 
2.31.1

