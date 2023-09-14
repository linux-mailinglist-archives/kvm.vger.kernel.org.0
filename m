Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD97A00A7
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbjINJrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbjINJrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:47:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C160210C
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684824; x=1726220824;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v2iEo9oXumJMnrsRg4O/FokgM9FuveqfN+n7Tcpxuj8=;
  b=I7DoiKMHRyuioxZ3yoLlrFcVzGHMWlfEvNkEo0Z0gvex4GpZm9wtxDKi
   ZVThqLREA3bNyFNIKHg2A9XF1p+/SqXY+ECNcdfGed0Wq6QfbposXGoIw
   WaNIiWoPo/QPCij4afVfTkYh5OsePFgQ59lAhKpRAHthD8FuqWo1FnzPH
   YLz2KOrbR9c0axXB+N/uucZZaI7tSPhspd2gRdc97bnpLedCaPP22Xx4Y
   37iGxtvRJqoAMQSJxLJtlW9M5+HLDQjU+1HFInlja5xPeQTPn0WbUPMfy
   SmVoT1FMWgIPpsCCXYcZLrKsu7fCg5qHDmW5iZXpEKt/P4SZa6+uLtt7D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369178842"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="369178842"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:46:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779565320"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779565320"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:46:50 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v2] KVM:selftests: Add selftests for CET MSR access
Date:   Thu, 14 Sep 2023 02:42:01 -0400
Message-Id: <20230914064201.85605-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test all CET related MSRs with both valid and invalid values in different
guest CET support modes. The intent is to test whether KVM checks are
reliable enough for valid and invalid input data.

The test doesn't cover all possible valid or invalid msr values but select
one case of each categories to accelerate tests.

AMD platform support will be added after the MSR test framework is fixed.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/arch/x86/include/asm/msr-index.h        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   5 +
 .../selftests/kvm/x86_64/cet_msrs_test.c      | 384 ++++++++++++++++++
 4 files changed, 391 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/cet_msrs_test.c

diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index a00a53e15ab7..854834757ff2 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -440,7 +440,7 @@
 #define CET_LEG_IW_EN			BIT_ULL(3)
 #define CET_NO_TRACK_EN			BIT_ULL(4)
 #define CET_SUPPRESS_DISABLE		BIT_ULL(5)
-#define CET_RESERVED			(BIT_ULL(6) | BIT_ULL(7) | BIT_ULL(8) | BIT_ULL(9))
+#define CET_INTEL_RESERVED		GENMASK_ULL(9, 6)
 #define CET_SUPPRESS			BIT_ULL(10)
 #define CET_WAIT_ENDBR			BIT_ULL(11)
 
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..0cb0c4a7617c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -119,6 +119,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += x86_64/cet_msrs_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd042112526..122b3e7432d7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1160,6 +1160,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 	return kvm_asm_safe("xsetbv", "a" (eax), "d" (edx), "c" (index));
 }
 
+static inline bool is_canonical_addr(uint64_t la, uint8_t law)
+{
+	return (((int64_t)la << (64 - law)) >> (64 - law)) == la;
+}
+
 bool kvm_is_tdp_enabled(void);
 
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
diff --git a/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c b/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c
new file mode 100644
index 000000000000..4301ef30367b
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/cet_msrs_test.c
@@ -0,0 +1,384 @@
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
+#ifdef SELFTEST_DEBUG_MODE
+#define CET_DEBUG_MODE
+#endif
+
+#define SET_MSR2_T(msr, msr_values, f1, f2)	\
+{						\
+	.idx = msr,				\
+	.name = #msr,				\
+	.valid = true,				\
+	.has_f1 = (f1) ? true : false,		\
+	.has_f2 = (f2) ? true : false,		\
+	.nr_values = ARRAY_SIZE(msr_values),	\
+	.values = msr_values			\
+}
+
+#define SET_MSR2_F(msr, msr_values, f1, f2)	\
+{						\
+	.idx = msr,				\
+	.name = #msr,				\
+	.valid = false,				\
+	.has_f1 = (f1) ? true : false,		\
+	.has_f2 = (f2) ? true : false,		\
+	.nr_values = ARRAY_SIZE(msr_values),	\
+	.values = msr_values			\
+}
+
+#define SET_MSR1_T(msr, msr_values, f)		\
+	SET_MSR2_T(msr, msr_values, f, 0)
+
+#define SET_MSR0_T(msr, msr_values)		\
+	SET_MSR2_T(msr, msr_values, 0, 0)
+
+#define CET_SHSTK_BITS (CET_SHSTK_EN | CET_WRSS_EN)
+
+#define CET_IBT_BITS	(CET_LEG_IW_EN  | CET_NO_TRACK_EN |	\
+			 CET_SUPPRESS_DISABLE | CET_SUPPRESS |	\
+			 CET_WAIT_ENDBR)
+#define CET_EB_LEG_BITMAP_BASE		(0xFFFFFFFFFFFFC000)
+#define CET_EB_LEG_BITMAP_BASE_INVALID	(0xFFFFFFFFFFFFE000)
+#define CET_SSP_BASE1			(0xFFFFFFFFFFFFFFFC)
+#define CET_SSP_BASE2			(0xFFFFFFFFFFFFFFF8)
+#define CET_SSP_BASE1_INVALID		(0xFFFFFFFFFFFFFFFE)
+#define CET_SSP_BASE2_INVALID		(0xFFFFFFFFFFFFFFFF)
+#define CET_SSP_BASE3_INVALID		(0x0FFFFFFFFFFFFFFF)
+
+#define CET_SSP_TABLE_BASE1		(0xFFFFFFFFFFFFFFFC)
+#define CET_SSP_TABLE_BASE2		(0xFFFFFFFFFFFFFFF8)
+#define CET_SSP_TABLE_BASE3		(0xFFFFFFFFFFFFFFFE)
+#define CET_SSP_TABLE_BASE4		(0xFFFFFFFFFFFFFFFF)
+#define CET_SSP_TABLE_INVALID		(0x0FFFFFFFFFFFFFFF)
+
+uint8_t cpu_law;
+
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
+static const uint64_t cet_ssp_table_values[] = {
+	CET_SSP_TABLE_BASE1,
+	CET_SSP_TABLE_BASE2,
+	CET_SSP_TABLE_BASE3,
+	CET_SSP_TABLE_BASE4,
+};
+
+static const uint64_t cet_ssp_invalid_values[] = {
+	CET_SSP_BASE1_INVALID,
+	CET_SSP_BASE2_INVALID,
+	CET_SSP_BASE3_INVALID
+};
+
+static const uint64_t cet_ssp_table_invalid_values[] = {
+	CET_SSP_TABLE_INVALID
+};
+
+static const struct msr_data msr_cet_ctrl[] = {
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_U_CET, cet_ctrl_values, 0, 0),
+
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_S_CET, cet_ctrl_values, 0, 0),
+};
+
+static const struct msr_data msr_cet_ctrl_invalid[] = {
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_U_CET, cet_ctrl_invalid_values, 0, 0),
+
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_S_CET, cet_ctrl_invalid_values, 0, 0),
+};
+
+static const struct msr_data msr_cet_ssp[] = {
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_PL0_SSP, cet_ssp_values, 0, 0),
+
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_PL1_SSP, cet_ssp_values, 0, 0),
+
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_PL2_SSP, cet_ssp_values, 0, 0),
+
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_PL3_SSP, cet_ssp_values, 0, 0),
+};
+
+static const struct msr_data msr_cet_ssp_table[] = {
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_table_values, 1, 1),
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_table_values, 1, 0),
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_table_values, 0, 1),
+	SET_MSR2_T(MSR_IA32_INT_SSP_TAB, cet_ssp_table_values, 0, 0),
+};
+
+static const struct msr_data msr_cet_ssp_invalid[] = {
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_PL0_SSP, cet_ssp_invalid_values, 0, 0),
+
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_PL1_SSP, cet_ssp_invalid_values, 0, 0),
+
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_PL2_SSP, cet_ssp_invalid_values, 0, 0),
+
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_PL3_SSP, cet_ssp_invalid_values, 0, 0),
+};
+
+static const struct msr_data msr_cet_ssp_table_invalid[] = {
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_table_invalid_values, 1, 1),
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_table_invalid_values, 1, 0),
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_table_invalid_values, 0, 1),
+	SET_MSR2_F(MSR_IA32_INT_SSP_TAB, cet_ssp_table_invalid_values, 0, 0),
+};
+
+#ifdef CET_DEBUG_MODE
+static inline char *get_cet_msr_string(uint32_t msr)
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
+	switch (msr) {
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		ret = ((f1 && f2) || (f1 && !(CET_IBT_BITS & val)) ||
+			(f2 && !(CET_SHSTK_BITS & val))) ? 1 : 0;
+		break;
+	case MSR_IA32_PL0_SSP:
+	case MSR_IA32_PL1_SSP:
+	case MSR_IA32_PL2_SSP:
+	case MSR_IA32_PL3_SSP:
+		ret = (f1 && is_canonical_addr(val, cpu_law) && !(val & 0x3)) ? 1 : 0;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		ret = f1 && is_canonical_addr(val, cpu_law) ? 1 : 0;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+static void cet_msr_test_runner(struct kvm_vcpu *vcpu, uint32_t msr,
+				uint64_t val, bool f1, bool f2,
+				bool valid)
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
+	ret = _vcpu_set_msr(vcpu, msr, val);
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
+#ifdef CET_DEBUG_MODE
+	printf("Pass: %s %s with: %s && %s, msr val = 0x%lx\n",
+	       valid && !!nr_msr ? "Write/Read" : "Write",
+	       get_cet_msr_string(msr),
+	       f1 ? "SHSTK" : "No SHSTK",
+	       f2 ? "IBT" : "No IBT",
+	       val);
+#endif
+}
+
+static void run_cet_msr_tests(struct kvm_vcpu *vcpu,
+			      struct msr_data const *msr_list,
+			      uint32_t msr_list_size,
+			      uint64_t const *msr_values_list,
+			      uint32_t values_list_size)
+{
+	uint32_t msr;
+	bool valid;
+	bool shstk;
+	bool ibt;
+	int i, j;
+
+	for (i = 0; i < msr_list_size; i++) {
+		msr = msr_list[i].idx;
+		shstk = msr_list[i].has_f1;
+		ibt = msr_list[i].has_f2;
+		valid = msr_list[i].valid;
+
+		for (j = 0; j < values_list_size; j++)
+			cet_msr_test_runner(vcpu, msr, msr_values_list[j],
+					    shstk, ibt, valid);
+	}
+}
+
+static void run_intel_cet_msr_tests(struct kvm_vcpu *vcpu)
+{
+	run_cet_msr_tests(vcpu, msr_cet_ctrl, ARRAY_SIZE(msr_cet_ctrl),
+			  cet_ctrl_values, ARRAY_SIZE(cet_ctrl_values));
+
+	run_cet_msr_tests(vcpu, msr_cet_ssp, ARRAY_SIZE(msr_cet_ssp),
+			  cet_ssp_values, ARRAY_SIZE(cet_ssp_values));
+
+	run_cet_msr_tests(vcpu, msr_cet_ssp_table,
+			  ARRAY_SIZE(msr_cet_ssp_table),
+			  cet_ssp_table_values,
+			  ARRAY_SIZE(cet_ssp_table_values));
+
+	run_cet_msr_tests(vcpu, msr_cet_ctrl_invalid,
+			  ARRAY_SIZE(msr_cet_ctrl_invalid),
+			  cet_ctrl_invalid_values,
+			  ARRAY_SIZE(cet_ctrl_invalid_values));
+
+	run_cet_msr_tests(vcpu, msr_cet_ssp_invalid,
+			  ARRAY_SIZE(msr_cet_ssp_invalid),
+			  cet_ssp_invalid_values,
+			  ARRAY_SIZE(cet_ssp_invalid_values));
+
+	run_cet_msr_tests(vcpu, msr_cet_ssp_table_invalid,
+			  ARRAY_SIZE(msr_cet_ssp_table_invalid),
+			  cet_ssp_table_invalid_values,
+			  ARRAY_SIZE(cet_ssp_table_invalid_values));
+}
+
+static void run_amd_cet_msr_tests(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TODO: After pass initial review, will add this part.
+	 */
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
+	cpu_law = this_cpu_has(X86_FEATURE_LA57) ? 57 : 48;
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

