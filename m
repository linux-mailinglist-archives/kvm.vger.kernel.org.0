Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE178F945
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348530AbjIAHll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348531AbjIAHlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:41:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31010DF
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554087; x=1725090087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ds7s6N7COLxgRFjwNgLlQUgxwkf+vwrnF6OQBWIIogc=;
  b=VcoLIQtZd7nl6fFd0QXx7ugV0ZVXxtZYC1/pNj1DNWvcAXt3YOdRevZx
   xR3Al7hyTeBHDEJ18bgTzn9lZgof8/9uFzKQFD1p8vPlzVEQe5QOGluBT
   ElfWKoh1AAQmY4O+ParaO0pQAElyD4gyU9Y2QC/rksbc4qqahmCScHb84
   X0ThUYoaPbuGEhnb54y3MX2e0Y70bYZTQfKWJcHklj5e0O7E5IeCY8rIw
   +Zyq0ZU9PmmAHu+iZSGW8MCU/n+2hdcBmHBGTsFmyUIxo2Fyp2kTcXXEl
   xrzkgtviopqMjeTOp3tI/xyaOX0g/yOn608wtTmKAOFXTJVg5AwEmHjZt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886155"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886155"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448077"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448077"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:24 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 3/6] x86: pmu: PERF_GLOBAL_STATUS_SET MSR verification for vPMU v4
Date:   Fri,  1 Sep 2023 15:40:49 +0800
Message-Id: <20230901074052.640296-4-xiong.y.zhang@intel.com>
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

The IA32_PERF_GLOBAL_STATUS_SET MSR is introduced with arch PMU v4.
It allows software to set individual bits in IA32_PERF_GLOBAL_STATUS
MSR.

This commit adds the test case for this MSR. When global status is
cleared at counter overflow, guest write PERF_GLOBAL_STATUS_SET
MSR to set the counter overflow bit, then check this counter's
overflow bit in IA32_PERF_GLOABAL_STATUS MSR.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 lib/x86/msr.h | 1 +
 x86/pmu.c     | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 9748436..63b8539 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -429,6 +429,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET	0x00000391
 
 /* PERF_GLOBAL_OVF_CTRL bits */
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE  (1ULL << 58)
diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9c..a171e9e 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -350,6 +350,14 @@ static void check_counter_overflow(void)
 		status = rdmsr(pmu.msr_global_status);
 		report(!(status & (1ull << idx)), "status clear-%d", i);
 		report(check_irq() == (i % 2), "irq-%d", i);
+		if (pmu.version >= 4) {
+			wrmsr(MSR_CORE_PERF_GLOBAL_STATUS_SET, 1ull << idx);
+			status = rdmsr(pmu.msr_global_status);
+			report(status & (1ull << idx), "status set-%d", i);
+			wrmsr(pmu.msr_global_status_clr, 1ull << idx);
+			status = rdmsr(pmu.msr_global_status);
+			report(!(status & (1ull << idx)), "status set clear-%d", i);
+		}
 	}
 
 	report_prefix_pop();
-- 
2.34.1

