Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3E5559614
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 11:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiFXJJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 05:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiFXJJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 05:09:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6140A4EF7F
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 02:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656061760; x=1687597760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CgU0Fz/PQzuayBUIM5JbTAos8rVfs+5wDKXz0rUiW1c=;
  b=RFkF1u6UtEgzEUOTfX7EjQ+iuV+0Edr0287Bu7A0N3Vfj2dchaT4lXcO
   jAAz1T8yiG7RMkRSDIy+ONvZteGZX00Vh1rHwCw3Nl39NQkQ+KMwPxkID
   3XMHU1RNvDw7Nid3rESfcdyR3cSi1s+skVuPZyo6DEJ8Bq1SREaDejACs
   Bs7J+HBO+9eFaAa8ExrxT80SoUUrpdSoe2xL6SnCa5+4TfWzjD2GTZjdm
   hPWxAWGjBurMweuG0lufX9I2xU9093Sx2jhg1ZS7/IYuq0MpBu4HtlwZO
   x2jdHB+xD368QlE+M4yPQEma+FmTMuKsXEKKI6zmdvNtKhOiEgNZxGt/7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="278509305"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="278509305"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="539222086"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 2/3] x86: Skip perf related tests when platform cannot support
Date:   Fri, 24 Jun 2022 05:08:27 -0400
Message-Id: <20220624090828.62191-3-weijiang.yang@intel.com>
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

Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
are supported in KVM. When pmu is disabled with enable_pmu=0,
reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
so skip related tests in this case to avoid test failure.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 lib/x86/processor.h | 10 ++++++++++
 x86/vmx_tests.c     | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad6..70b9193 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -690,4 +690,14 @@ static inline bool cpuid_osxsave(void)
 	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
 }
 
+static inline u8 pmu_version(void)
+{
+	return cpuid(10).a & 0xff;
+}
+
+static inline bool has_perf_global_ctrl(void)
+{
+	return pmu_version() > 1;
+}
+
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..3cf0776 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -944,6 +944,14 @@ static void insn_intercept_main(void)
 			continue;
 		}
 
+		if (insn_table[cur_insn].flag == CPU_RDPMC) {
+			if (!!pmu_version()) {
+				printf("\tFeature required for %s is not supported.\n",
+				       insn_table[cur_insn].name);
+				continue;
+			}
+		}
+
 		if (insn_table[cur_insn].disabled) {
 			printf("\tFeature required for %s is not supported.\n",
 			       insn_table[cur_insn].name);
@@ -7490,6 +7498,11 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 
 static void test_load_host_perf_global_ctrl(void)
 {
+	if (!has_perf_global_ctrl()) {
+		report_skip("test_load_host_perf_global_ctrl");
+		return;
+	}
+
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
 		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
 		return;
@@ -7502,6 +7515,11 @@ static void test_load_host_perf_global_ctrl(void)
 
 static void test_load_guest_perf_global_ctrl(void)
 {
+	if (!has_perf_global_ctrl()) {
+		report_skip("test_load_guest_perf_global_ctrl");
+		return;
+	}
+
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
 		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
 		return;
-- 
2.27.0

