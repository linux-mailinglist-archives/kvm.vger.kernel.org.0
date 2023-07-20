Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A475B20A
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 17:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjGTPIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 11:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjGTPIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 11:08:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E68726B5
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 08:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689865731; x=1721401731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OHmDEH9+XesVkzD1Y/zJmM7o20D4QQZEWfbK2AkhALA=;
  b=IPV8ZHKoHuQ9u1pWvWTIJkVL9HpQfwuPh2BAEQQGFls544BhYNXDnFnX
   tprPn7DKNuFMvNnhrR8wd/mjHFThfWkckBHfmcHXmtZrA290jxm3uIZyu
   2OB+BbWpKeOMd8mVnGZhgX7Ws4rGseffsiUMdFjd+plloBTvr6vYzRWRo
   8bg65gZBmA+VrdXuFgd1iMTsMXbCuVUNkzghoQ02RRgIiTzdwZBw3LYYT
   dzXWJVwBfzPIKwOgIxjLViQnvb2m1RBCfy9powZ8Vz7WsXJKp7IAwrE/K
   qo6kAtU+6fKK6PwlRYbdUiyRh3l/12kkkcxb9pE16/BIkA8FNlMZ2NB7L
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="356751107"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="356751107"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 08:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="724418775"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="724418775"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 08:08:50 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH] KVM:selftests: Add selftests for CET MSRs
Date:   Thu, 20 Jul 2023 08:04:01 -0400
Message-Id: <20230720120401.105770-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test all CET related MSRs with both valid and invalid values
in different guest CET support modes. The intent is to test
whether any fault/invalid values escape KVM's check or not.

The test doesn't cover all possible valid or invalid msr values
but select at least one case of each categories to accelerate
tests.

AMD platform support will be added after MSR test framework is
fixed.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/arch/x86/include/asm/msr-index.h        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/cet_msrs_test.c      | 369 ++++++++++++++++++
 3 files changed, 371 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/cet_msrs_test.c

diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index ad35355ee43e..d3668f60e59d 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -438,7 +438,7 @@
 #define CET_LEG_IW_EN			BIT_ULL(3)
 #define CET_NO_TRACK_EN			BIT_ULL(4)
 #define CET_SUPPRESS_DISABLE		BIT_ULL(5)
-#define CET_RESERVED			(BIT_ULL(6) | BIT_ULL(7) | BIT_ULL(8) | BIT_ULL(9))
+#define CET_INTEL_RESERVED		GENMASK_ULL(9, 6)
 #define CET_SUPPRESS			BIT_ULL(10)
 #define CET_WAIT_ENDBR			BIT_ULL(11)
 
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index de10581ea108..10aa8dcad2ee 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -117,6 +117,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/cet_msrs_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c b/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c
new file mode 100644
index 000000000000..5189663ad457
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests for CET control and data MSRs.
+ */
+
+#include <sys/ioctl.h>
+#include <linux/bitmap.h>
+#include "asm/msr-index.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+/*
+ * #define CET_SELFTEST_VERBOSE
+ * Enable it to see verbose output of tests.
+ */
+
+#define SET_MSR2_T(msr, msr_values, f1, f2) 	\
+{						\
+	.idx = msr, 				\
+	.name = #msr, 				\
+	.valid = true,				\
+	.has_f1 = (f1) ? true : false,   	\
+	.has_f2 = (f2) ? true : false,   	\
+	.nr_values = ARRAY_SIZE(msr_values), 	\
+	.values = msr_values  			\
+}
+
+#define SET_MSR2_F(msr, msr_values, f1, f2) 	\
+{						\
+	.idx = msr, 				\
+	.name = #msr, 				\
+	.valid = false,				\
+	.has_f1 = (f1) ? true : false,   	\
+	.has_f2 = (f2) ? true : false,   	\
+	.nr_values = ARRAY_SIZE(msr_values), 	\
+	.values = msr_values  			\
+}
+
+#define SET_MSR1_T(msr, msr_values, f)		\
+	SET_MSR2_T(msr, msr_values, f, 0)
+
+#define SET_MSR0_T(msr, msr_values)		\
+	SET_MSR2_T(msr, msr_values, 0, 0)
+
+#define SET_MSR1_F(msr, msr_values, f)		\
+	SET_MSR2_F(msr, msr_values, f, 0)
+
+#define SET_MSR0_F(msr, msr_values)		\
+	SET_MSR2_F(msr, msr_values, 0, 0)
+
+#define CET_SHSTK_BITS (CET_SHSTK_EN | CET_WRSS_EN)
+
+#define CET_IBT_BITS	(CET_LEG_IW_EN  | CET_NO_TRACK_EN |	\
+			 CET_SUPPRESS_DISABLE | CET_SUPPRESS | 	\
+			 CET_WAIT_ENDBR)
+#define CET_EB_LEG_BITMAP_BASE		(0xFFFFFFFFFFFFC000)
+#define CET_EB_LEG_BITMAP_BASE_INVALID	(0xFFFFFFFFFFFFE000)
+#define CET_SSP_BASE1			(0xFFFFFFFFFFFFFFFC)
+#define CET_SSP_BASE2			(0xFFFFFFFFFFFFFFF8)
+#define CET_SSP_BASE1_INVALID		(0xFFFFFFFFFFFFFFFE)
+#define CET_SSP_BASE2_INVALID		(0xFFFFFFFFFFFFFFFF)
+#define CET_SSP_BASE3_INVALID		(0x00000FFFFFFFFFFF)
+struct msr_data {
+	const uint32_t idx;
+	const char *name;
+	const bool valid;
+	const bool has_f1;
+	const bool has_f2;
+	uint32_t nr_values;
+	const uint64_t *values;
+};
+
+static const uint64_t cet_ctrl_values[] = {
+	CET_SHSTK_EN,
+	CET_SHSTK_EN | CET_WRSS_EN,
+
+	CET_ENDBR_EN | CET_NO_TRACK_EN,
+	CET_ENDBR_EN | CET_SUPPRESS_DISABLE,
+	CET_ENDBR_EN | CET_WAIT_ENDBR,
+	CET_ENDBR_EN | CET_LEG_IW_EN,
+
+	CET_ENDBR_EN | CET_NO_TRACK_EN | CET_SUPPRESS_DISABLE,
+	CET_ENDBR_EN | CET_NO_TRACK_EN | CET_WAIT_ENDBR,
+	CET_ENDBR_EN | CET_NO_TRACK_EN | CET_LEG_IW_EN,
+	CET_ENDBR_EN | CET_SUPPRESS_DISABLE | CET_WAIT_ENDBR,
+	CET_ENDBR_EN | CET_SUPPRESS_DISABLE | CET_LEG_IW_EN,
+	CET_ENDBR_EN | CET_WAIT_ENDBR | CET_LEG_IW_EN,
+
+	CET_ENDBR_EN | (CET_IBT_BITS & ~CET_SUPPRESS),
+
+	CET_SHSTK_EN | CET_ENDBR_EN | CET_NO_TRACK_EN,
+	CET_SHSTK_EN | CET_ENDBR_EN | CET_SUPPRESS_DISABLE,
+	CET_SHSTK_EN | CET_ENDBR_EN | CET_WAIT_ENDBR,
+	CET_SHSTK_EN | CET_ENDBR_EN | CET_LEG_IW_EN | CET_EB_LEG_BITMAP_BASE,
+
+	CET_SHSTK_EN | CET_WRSS_EN | CET_ENDBR_EN | CET_NO_TRACK_EN,
+	CET_SHSTK_EN | CET_WRSS_EN | CET_ENDBR_EN | CET_SUPPRESS_DISABLE,
+	CET_SHSTK_EN | CET_WRSS_EN | CET_ENDBR_EN | CET_WAIT_ENDBR,
+	CET_SHSTK_EN | CET_WRSS_EN | CET_ENDBR_EN | CET_LEG_IW_EN,
+
+	CET_SHSTK_EN | CET_WRSS_EN | CET_ENDBR_EN | (CET_IBT_BITS & ~CET_SUPPRESS),
+};
+
+static const uint64_t cet_ctrl_invalid_values[] = {
+	CET_INTEL_RESERVED,
+	CET_SUPPRESS | CET_WAIT_ENDBR,
+	CET_SHSTK_EN | CET_ENDBR_EN | CET_LEG_IW_EN | CET_EB_LEG_BITMAP_BASE_INVALID,
+};
+
+static const uint64_t cet_ssp_values[] = {
+	CET_SSP_BASE1,
+	CET_SSP_BASE2,
+};
+
+static const uint64_t cet_ssp_invalid_values[] = {
+	CET_SSP_BASE1_INVALID,
+	CET_SSP_BASE2_INVALID,
+	CET_SSP_BASE3_INVALID
+};
+
+static const struct msr_data msr_cet_ctrl[] = {
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_U_CET, cet_ctrl_values, 1),
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_U_CET, cet_ctrl_values),
+
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_S_CET, cet_ctrl_values, 1),
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_S_CET, cet_ctrl_values),
+};
+
+static const struct msr_data msr_cet_ctrl_invalid[] = {
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_U_CET, cet_ctrl_invalid_values),
+
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_S_CET, cet_ctrl_invalid_values),
+};
+
+static const struct msr_data msr_cet_ssp[] = {
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_PL0_SSP, cet_ssp_values, 1),
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_PL0_SSP, cet_ssp_values),
+
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_PL1_SSP, cet_ssp_values, 1),
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_PL1_SSP, cet_ssp_values),
+
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_PL2_SSP, cet_ssp_values, 1),
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_PL2_SSP, cet_ssp_values),
+
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_PL3_SSP, cet_ssp_values, 1),
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_PL3_SSP, cet_ssp_values),
+
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_values, 1, 1),
+	SET_MSR1_T(MSR_IA32_INT_SSP_TAB, cet_ssp_values, 1),
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_values, 0, 1),
+	SET_MSR0_T(MSR_IA32_INT_SSP_TAB, cet_ssp_values),
+};
+
+static const struct msr_data msr_cet_ssp_invalid[] = {
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values),
+
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values),
+
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values),
+
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values),
+
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_invalid_values, 1, 1),
+	SET_MSR1_F(MSR_IA32_INT_SSP_TAB, cet_ssp_invalid_values, 1),
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_invalid_values, 0, 1),
+	SET_MSR0_F(MSR_IA32_INT_SSP_TAB, cet_ssp_invalid_values),
+};
+static bool kvm_shstk_supported;
+
+#ifdef CET_SELFTEST_VERBOSE
+static inline char* get_cet_msr_string(uint32_t msr)
+{
+	return msr == MSR_IA32_U_CET ? "MSR_IA32_U_CET" :
+		msr == MSR_IA32_S_CET ? "MSR_IA32_S_CET" :
+		msr == MSR_IA32_PL3_SSP ? "MSR_IA32_PL3_SSP" :
+		msr == MSR_IA32_PL2_SSP ? "MSR_IA32_PL2_SSP" :
+		msr == MSR_IA32_PL1_SSP ? "MSR_IA32_PL1_SSP" :
+		msr == MSR_IA32_PL0_SSP ? "MSR_IA32_PL0_SSP" :
+		msr == MSR_IA32_INT_SSP_TAB ? "MSR_IA32_INT_SSP_TAB" :
+		"Invalid CET msr!";
+}
+#endif
+
+static inline int get_expected_result(uint32_t msr, uint64_t val,
+				      bool has_shstk, bool has_ibt)
+{
+	int ret = 0;
+	bool f1 = has_shstk, f2 = has_ibt;
+
+	switch(msr) {
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		ret = ((f1 && f2) || (f1 && !(CET_IBT_BITS & val)) ||
+			(f2 && !(CET_SHSTK_BITS & val))) ? 1 : 0;
+		break;
+	case MSR_IA32_PL0_SSP:
+	case MSR_IA32_PL1_SSP:
+	case MSR_IA32_PL2_SSP:
+	case MSR_IA32_PL3_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		ret = (kvm_shstk_supported && !(val & 0x3)) ? 1 : 0;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+static void cet_msr_test(struct kvm_vcpu *vcpu, uint32_t msr,
+			      uint64_t val, bool f1, bool f2,
+			      bool valid)
+{
+	int nr_msr;
+	uint64_t ret;
+
+	if (f1)
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_SHSTK);
+	else
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_SHSTK);
+
+	if (f2)
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_IBT);
+	else
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_IBT);
+
+	nr_msr = get_expected_result(msr, val, f1, f2);
+
+	if (!valid)
+		nr_msr = 0;
+
+	TEST_ASSERT(_vcpu_set_msr(vcpu, msr, val) == nr_msr,
+		    "KVM_SET_MSRS should %s on 0x%x, value = 0x%lx",
+		    nr_msr ? "succeed" : "fail", msr, val);
+
+	if (!valid || !nr_msr)
+		goto out;
+
+	ret = vcpu_get_msr(vcpu, msr);
+
+	TEST_ASSERT(ret == val,
+		    "KVM_GET_MSRS returned different value = 0x%lx, origin = 0x%lx",
+		    ret, val);
+out:
+#ifdef CET_SELFTEST_VERBOSE
+	printf("Pass: %s %s with: %s && %s, msr val = 0x%lx\n",
+		valid && !!nr_msr ? "Write/Read" : "Write",
+		get_cet_msr_string(msr),
+		f1 ? "SHSTK" : "No SHSTK",
+		f2 ? "IBT" : "No IBT",
+		val);
+#endif
+	return;
+}
+
+static void run_intel_cet_msr_tests(struct kvm_vcpu *vcpu)
+{
+	uint32_t msr;
+	bool valid;
+	bool shstk;
+	bool ibt;
+	int i, j;
+
+	kvm_shstk_supported = kvm_cpu_has(X86_FEATURE_SHSTK);
+
+	for (i = 0; i < ARRAY_SIZE(msr_cet_ctrl); i++) {
+
+		msr = msr_cet_ctrl[i].idx;
+		shstk = msr_cet_ctrl[i].has_f1;
+		ibt = msr_cet_ctrl[i].has_f2;
+		valid = msr_cet_ctrl[i].valid;
+
+		for (j = 0; j < ARRAY_SIZE(cet_ctrl_values); j++) {
+			cet_msr_test(vcpu, msr, cet_ctrl_values[j], shstk, ibt, valid);
+		}
+	}
+	for (i = 0; i < ARRAY_SIZE(msr_cet_ssp); i++) {
+
+		msr = msr_cet_ssp[i].idx;
+		shstk = msr_cet_ssp[i].has_f1;
+		ibt = msr_cet_ssp[i].has_f2;
+		valid = msr_cet_ssp[i].valid;
+
+		for (j = 0; j < ARRAY_SIZE(cet_ssp_values); j++) {
+			cet_msr_test(vcpu, msr, cet_ssp_values[j], shstk, ibt, valid);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(msr_cet_ctrl_invalid); i++) {
+
+		msr = msr_cet_ctrl_invalid[i].idx;
+		shstk = msr_cet_ctrl_invalid[i].has_f1;
+		ibt = msr_cet_ctrl_invalid[i].has_f2;
+		valid = msr_cet_ctrl_invalid[i].valid;
+
+		for (j = 0; j < ARRAY_SIZE(cet_ctrl_invalid_values); j++) {
+			cet_msr_test(vcpu, msr, cet_ctrl_invalid_values[j], shstk, ibt, valid);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(msr_cet_ssp_invalid); i++) {
+
+		msr = msr_cet_ssp_invalid[i].idx;
+		shstk = msr_cet_ssp_invalid[i].has_f1;
+		ibt = msr_cet_ssp_invalid[i].has_f2;
+		valid = msr_cet_ssp_invalid[i].valid;
+
+		for (j = 0; j < ARRAY_SIZE(cet_ssp_invalid_values); j++) {
+			cet_msr_test(vcpu, msr, cet_ssp_invalid_values[j], shstk, ibt, valid);
+		}
+	}
+}
+
+static void run_amd_cet_msr_tests(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TODO: After pass initial review, will add this part.
+	 */
+	return;
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SHSTK));
+
+	if (host_cpu_is_intel)
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_IBT));
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	if (host_cpu_is_intel)
+		run_intel_cet_msr_tests(vcpu);
+	else if (host_cpu_is_amd)
+		run_amd_cet_msr_tests(vcpu);
+
+	kvm_vm_free(vm);
+}
-- 
2.27.0

