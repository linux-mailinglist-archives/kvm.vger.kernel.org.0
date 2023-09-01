Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5E178F94C
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348535AbjIAHmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbjIAHmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:42:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61AE10FA
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554114; x=1725090114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sk6Ogx2mLzmy0w0eLZHuab1j4cSKcLY4fjeqoreEUS8=;
  b=BguMQBD9jJDrIBZkDe2JgVHcAAgFa2mBS2xkpY35qf/QS7R6/5xx0pIi
   OncsO/kq6S4yc1NnI4cOnvWIDRBD59Abqq+e/y+AWp8bgQ+F4Ji21PFhR
   hNO/Afk/vW1eVvWCS2sKXa/llb8c5ZZ/5FVnFUnvsRTm48Nd8fyEWiwyQ
   +wPP2/rTCfDUQjkT2KcnLY6eeuL4C6UiVKYwilZ93epoTKvTdU7T/7W3z
   JpsumerXhy1QcFJ257EmCynnyw2Tvbp+PH7hLagWf9WSTkwciMQUCLNuq
   HDSv1HL34pIHjyP4ILRpjSIMtebjHTTrRN+9fvQ31Szo8SpCOC2rCBVLC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886185"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886185"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448109"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448109"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:36 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 6/6] x86: pmu: Support fixed counter enumeration in vPMU v5
Date:   Fri,  1 Sep 2023 15:40:52 +0800
Message-Id: <20230901074052.640296-7-xiong.y.zhang@intel.com>
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

With Architectural Performance Monitoring Version 5, register
CPUID.0AH.ECX indicates Fixed Counter enumeration. It is a bit mask
which enumerates the supported Fixed Counters in a processor. If bit
'i' is set, it implies that Fixed Counter 'i' is supported.

So user can specify non-continuous Fixed Counters, i.e. CPUID.0AH.ECX=
0x77, CPUID.0AH.EDX.EDX[4:0] = 3, this means fixed counters 0,1,2, 4,5,6
are supported, while Fixed counter 3 isn't supported.

This commit add the non-continuous fixed counters support. If vPMU
version < 5, nr_fixed_counters is continuous fixed counter number
starting from 0. If vPMU version >= 5, nr_fixed_counters is highest
bit set index in fixed_counter_mask bitmap, finxed counters with
index [0, nr_fixed_counters) may be not all supported.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 lib/x86/pmu.c  |  5 +++++
 lib/x86/pmu.h  |  6 ++++++
 x86/pmu.c      |  8 +++++---
 x86/pmu_pebs.c | 12 +++++++++---
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index d06e945..e6492ed 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -14,6 +14,11 @@ void pmu_init(void)
 		if (pmu.version > 1) {
 			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
 			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
+			pmu.fixed_counter_mask = (1u << pmu.nr_fixed_counters) - 1;
+			if (pmu.version >= 5) {
+				pmu.fixed_counter_mask = cpuid_10.c;
+				pmu.nr_fixed_counters = fls(cpuid_10.c) + 1;
+			}
 		}
 
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 8465e3c..038d74e 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -57,6 +57,7 @@ struct pmu_caps {
 	u8 version;
 	u8 nr_fixed_counters;
 	u8 fixed_counter_width;
+	u32 fixed_counter_mask;
 	u8 nr_gp_counters;
 	u8 gp_counter_width;
 	u8 gp_counter_mask_length;
@@ -106,6 +107,11 @@ static inline bool this_cpu_has_perf_global_status(void)
 	return pmu.version > 1;
 }
 
+static inline bool pmu_fixed_counter_supported(int i)
+{
+	return pmu.fixed_counter_mask & BIT(i);
+}
+
 static inline bool pmu_gp_counter_is_available(int i)
 {
 	return pmu.gp_counter_available & BIT(i);
diff --git a/x86/pmu.c b/x86/pmu.c
index 416e9d7..9806f29 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -257,7 +257,7 @@ static void check_fixed_counters(void)
 	int i;
 
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
-		if (i >= fixed_events_size)
+		if (i >= fixed_events_size || !pmu_fixed_counter_supported(i))
 			continue;
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
@@ -280,7 +280,7 @@ static void check_counters_many(void)
 		n++;
 	}
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
-		if (i >= fixed_events_size)
+		if (i >= fixed_events_size || !pmu_fixed_counter_supported(i))
 			continue;
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
@@ -437,7 +437,8 @@ static void check_rdpmc(void)
 		else
 			report(cnt.count == (u32)val, "fast-%d", i);
 	}
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < pmu.nr_fixed_counters && pmu_fixed_counter_supported(i);
+	     i++) {
 		uint64_t x = val & ((1ull << pmu.fixed_counter_width) - 1);
 		pmu_counter_t cnt = {
 			.ctr = MSR_CORE_PERF_FIXED_CTR0 + i,
@@ -720,6 +721,7 @@ int main(int ac, char **av)
 	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
+	printf("Supported Fixed counter mask: 0x%x\n", pmu.fixed_counter_mask);
 
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 894ae6c..bc8e64d 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -222,7 +222,9 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
 	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
 		get_adaptive_pebs_record_size(pebs_data_cfg);
 
-	for (idx = 0; idx < pmu.nr_fixed_counters; idx++) {
+	for (idx = 0;
+	     idx < pmu.nr_fixed_counters && pmu_fixed_counter_supported(idx);
+	     idx++) {
 		if (!(BIT_ULL(FIXED_CNT_INDEX + idx) & bitmask))
 			continue;
 		if (has_baseline)
@@ -357,13 +359,17 @@ static void check_pebs_counters(u64 pebs_data_cfg)
 	unsigned int idx;
 	u64 bitmask = 0;
 
-	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
+	for (idx = 0;
+	     idx < pmu.nr_fixed_counters && pmu_fixed_counter_supported(idx);
+	     idx++)
 		check_one_counter(FIXED, idx, pebs_data_cfg);
 
 	for (idx = 0; idx < max_nr_gp_events; idx++)
 		check_one_counter(GP, idx, pebs_data_cfg);
 
-	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
+	for (idx = 0;
+	     idx < pmu.nr_fixed_counters && pmu_fixed_counter_supported(idx);
+	     idx++)
 		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
 	for (idx = 0; idx < max_nr_gp_events; idx += 2)
 		bitmask |= BIT_ULL(idx);
-- 
2.34.1

