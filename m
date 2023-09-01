Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3C78F948
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348529AbjIAHln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348527AbjIAHlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:41:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BD10F3
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554091; x=1725090091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R+yBScRB0q5rh7mW2Qf6L5MIpz4dEffD7KeZDRfhbzs=;
  b=gu0ArEnky83YvFGLKLIRx6FariXBt11u1i1BUXZ5HwkUJZUdinfn3Se6
   AQEUIOWRpdrskZbBij2ob83OiSpet4Us7TLatzholtidGf1g6JUgOzx1D
   vmQk9MfjP8KVcclfD2+eoYcUypbCMSju8wJG1f1BV0xZCU2hO/3KNxh9O
   u90zBYQKTJi/mtvCziJ3Dnx8GKFs0bojJFZqRPe4A29sCvBZCmmBiJXGt
   /tJaw3P1jY4nfdn9ebI0iM++0M4/2RJSuxH7HZ5gSN+BB+v+ATQcVMls8
   ITcXSrKzNbm/6F/MJoXW1JFezR7mGqlMMElI7r6g0GRtl/e8i6/X0/9XO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886164"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886164"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448089"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448089"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:28 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 4/6] x86: pmu: PERF_GLOBAL_INUSE MSR verification for vPMU v4
Date:   Fri,  1 Sep 2023 15:40:50 +0800
Message-Id: <20230901074052.640296-5-xiong.y.zhang@intel.com>
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

Arch PMU v4 introduces a new MSR, IA32_PERF_GLOBAL_INUSE. It provides
as "InUse" bit for each GP counter and fixed counter in processor.
Additionally PMI InUse[bit 63] indicates if the PMI mechanisam has
been configured.

This commit add the test case for this MSR, when a counter is started,
its index bit must be set in this MSR, when a counter is stopped through
writing 0 into counter's control MSR, its index bit must be cleared in
this MSR.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 lib/x86/msr.h |  4 ++++
 x86/pmu.c     | 14 ++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 63b8539..3bffe80 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -430,6 +430,10 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 #define MSR_CORE_PERF_GLOBAL_STATUS_SET	0x00000391
+#define MSR_CORE_PERF_GLOBAL_INUSE      0x00000392
+
+/* PERF_GLOBAL_INUSE bits */
+#define MSR_CORE_PERF_GLOBAL_INUSE_PMI_BIT       63
 
 /* PERF_GLOBAL_OVF_CTRL bits */
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE  (1ULL << 58)
diff --git a/x86/pmu.c b/x86/pmu.c
index a171e9e..0ec0062 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -155,6 +155,15 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
+    if (pmu.version >= 4) {
+	    u64 inuse = rdmsr(MSR_CORE_PERF_GLOBAL_INUSE);
+	    int idx = event_to_global_idx(evt);
+
+	    report(inuse & BIT_ULL(idx), "start counter_idx: %d", idx);
+	    if (evt->config & EVNTSEL_INT)
+		    report(inuse & BIT_ULL(MSR_CORE_PERF_GLOBAL_INUSE_PMI_BIT),
+			   "INT, start counter_idx: %d", idx);
+    }
     global_enable(evt);
     apic_write(APIC_LVTPC, PMI_VECTOR);
 }
@@ -168,14 +177,15 @@ static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
 	if (is_gp(evt)) {
-		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
-		      evt->config & ~EVNTSEL_EN);
+		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)), 0);
 	} else {
 		uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 		int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl & ~(0xf << shift));
 	}
 	evt->count = rdmsr(evt->ctr);
+	if (pmu.version >= 4)
+		report((rdmsr(MSR_CORE_PERF_GLOBAL_INUSE) & BIT_ULL(evt->idx)) == 0, "stop counter idx: %d", evt->idx);
 }
 
 static noinline void measure_many(pmu_counter_t *evt, int count)
-- 
2.34.1

