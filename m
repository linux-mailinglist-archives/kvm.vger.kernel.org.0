Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE9678F946
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbjIAHlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348528AbjIAHlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:41:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FB10E7
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554083; x=1725090083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=318f20nud9Tfzfiszabdqf7SrmGNtcCTbrZd6Pqwtro=;
  b=LApvcZCH2dXRfKYhnJ0/s52rmk3MSivjj67KlowRhogF6ByL3D48JqtS
   xI3wsRCjjR2v2+CR+/0ZNNeMv/schYqWhAeSeNHS4rmcupYZ6mC2oPtRM
   MflzAfMQgusbiICmRtJdjn+MWQP4oRyPv5iptQI+eMb3uae6fDxDKeoXN
   ta9trrVO5JYMGVafIhL7M5B035dDzfeSAlWiXhe5LCNgO/aicwaZHQqNF
   x8OPW3llvuo1J9eXQ2EF8qjvagY5RILRGddmPdwhgIlLJWZUN1HBySbq5
   2UfReIti06luXToIlaT4ClDmM670TpyrcikqKdvAx//O75FXWVsSR2rnk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886141"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886141"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448068"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448068"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:20 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 2/6] x86: pmu: Add Freeze_LBRS_On_PMI test case
Date:   Fri,  1 Sep 2023 15:40:48 +0800
Message-Id: <20230901074052.640296-3-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901074052.640296-1-xiong.y.zhang@intel.com>
References: <20230901074052.640296-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once IA32_DEBUGCTL.FREEZE_LBR_ON_PMI is set, LBR stack will be frozen on
PMI. This commit add a test case to check whether LBR stack is changed
during PMI handler or not.

In PMU v2, legacy Freeze LBRS on PMI is introduced,
IA32_DEBUGCTL.FREEZE_LBR_ON_PMI will be cleared by processor when PMI
happens, SW should set it again in PMI handler to enable LBR.
In PMU v4, streamlined freeze LBRs on PMI is introduced, the new
LBR_FRZ[bit 58] bit is added into IA32_PERF_GLOBAL_STATUS MSR, this bit
is set by processor when PMI happens, this bit also serves as a control
to enable LBR stack. SW should clear this bit in PMI handler to enable
LBR.

This commit checks legacy and streamlined FREEZE_LBR_ON_PMI feature,
and their SW and HW sequence.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 lib/x86/msr.h |   3 ++
 x86/pmu_lbr.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 0e3fd03..9748436 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -430,6 +430,9 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
+/* PERF_GLOBAL_OVF_CTRL bits */
+#define MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE  (1ULL << 58)
+
 /* AMD Performance Counter Global Status and Control MSRs */
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
 #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 40b63fa..24220f0 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -2,11 +2,17 @@
 #include "x86/processor.h"
 #include "x86/pmu.h"
 #include "x86/desc.h"
+#include "x86/apic-defs.h"
+#include "x86/apic.h"
+#include "x86/isr.h"
 
 #define N 1000000
+#define MAX_LBR 64
 
 volatile int count;
 u32 lbr_from, lbr_to;
+int max;
+bool pmi_received = false;
 
 static noinline int compute_flag(int i)
 {
@@ -41,9 +47,102 @@ static bool test_init_lbr_from_exception(u64 index)
 	return test_for_exception(GP_VECTOR, init_lbr, &index);
 }
 
+static void pmi_handler(isr_regs_t *regs)
+{
+	uint64_t lbr_tos, from[MAX_LBR], to[MAX_LBR];
+	uint64_t gbl_status, debugctl = 0, lbr_cur;
+	int i;
+
+	pmi_received = true;
+
+	if (pmu.version < 4) {
+		debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+		report((debugctl & DEBUGCTLMSR_LBR) == 0,
+			"The guest LBR_EN is cleared in guest PMI");
+		gbl_status = rdmsr(pmu.msr_global_status);
+		report((gbl_status & BIT_ULL(0)) == BIT_ULL(0),
+			"GP counter 0 overflow.");
+	} else {
+		gbl_status = rdmsr(pmu.msr_global_status);
+		report((gbl_status & (MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE | BIT_ULL(0)))
+			== (MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE | BIT_ULL(0)),
+			"GP counter 0 overflow and LBR freeze.");
+	}
+
+	lbr_tos = rdmsr(MSR_LBR_TOS);
+	for (i = 0; i < max; ++i) {
+		from[i] = rdmsr(lbr_from + i);
+		to[i] = rdmsr(lbr_to + i);
+	}
+
+	lbr_test();
+
+	lbr_cur = rdmsr(MSR_LBR_TOS);
+	report(lbr_cur == lbr_tos,
+	       "LBR TOS freezed in PMI, %lx -> %lx", lbr_tos, lbr_cur);
+	for (i = 0; i < max; ++i) {
+		lbr_cur = rdmsr(lbr_from + i);
+		report(lbr_cur == from[i],
+		       "LBR from %d freezed in PMI, %lx -> %lx", i, from[i], lbr_cur);
+		lbr_cur = rdmsr(lbr_to + i);
+		report(lbr_cur == to[i],
+		       "LBR to %d freezed in PMI, %lx -> %lx", i, to[i], lbr_cur);
+	}
+
+	if (pmu.version < 4) {
+		debugctl |= DEBUGCTLMSR_LBR;
+		wrmsr(MSR_IA32_DEBUGCTLMSR, debugctl);
+	}
+
+	wrmsr(pmu.msr_global_status_clr, gbl_status);
+
+	apic_write(APIC_EOI, 0);
+}
+
+/* GP counter 0 overflow after 2 instructions. */
+static void setup_gp_counter_0_overflow(void)
+{
+	uint64_t count, ctrl;
+	int i;
+
+	count = (1ull << pmu.gp_counter_width) - 1 - 2;
+	wrmsr(pmu.msr_gp_counter_base, count);
+
+	ctrl = EVNTSEL_EN | EVNTSEL_USR | EVNTSEL_OS | EVNTSEL_INT | 0xc0;
+	wrmsr(pmu.msr_gp_event_select_base, ctrl);
+
+	wrmsr(pmu.msr_global_ctl, 0x1);
+
+	apic_write(APIC_LVTPC, PMI_VECTOR);
+
+	irq_enable();
+	asm volatile("nop; nop; nop");
+	for (i=0; i < 100000 && !pmi_received; i++)
+		asm volatile("pause");
+	irq_disable();
+}
+
+static void stop_gp_counter_0(void)
+{
+	wrmsr(pmu.msr_global_ctl, 0);
+	wrmsr(pmu.msr_gp_event_select_base, 0);
+}
+
+static void test_freeze_lbr_on_pmi(void)
+{
+	wrmsr(MSR_IA32_DEBUGCTLMSR,
+	      DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
+
+	setup_gp_counter_0_overflow();
+
+	stop_gp_counter_0();
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+}
+
 int main(int ac, char **av)
 {
-	int max, i;
+	int i;
 
 	setup_vm();
 
@@ -70,6 +169,12 @@ int main(int ac, char **av)
 	printf("PMU version:		 %d\n", pmu.version);
 	printf("LBR version:		 %ld\n", pmu_lbr_version());
 
+	handle_irq(PMI_VECTOR, pmi_handler);
+	apic_write(APIC_LVTPC, PMI_VECTOR);
+
+	if (pmu_has_full_writes())
+		pmu.msr_gp_counter_base = MSR_IA32_PMC0;
+
 	/* Look for LBR from and to MSRs */
 	lbr_from = MSR_LBR_CORE_FROM;
 	lbr_to = MSR_LBR_CORE_TO;
@@ -104,5 +209,7 @@ int main(int ac, char **av)
 	}
 	report(i == max, "The guest LBR FROM_IP/TO_IP values are good.");
 
+	test_freeze_lbr_on_pmi();
+
 	return report_summary();
 }
-- 
2.34.1

