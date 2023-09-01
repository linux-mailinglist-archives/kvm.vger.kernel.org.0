Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AD678F947
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbjIAHln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348538AbjIAHlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:41:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D765410E9
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693554095; x=1725090095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H/bSAPousThChjmlEm+2gbhh8OYU/OslzvQbDwzHwFE=;
  b=Y9rpSxjEV6pPt7OVUrwjuv17Mx+UYbOkqKI0+D8Paow7bJecaydJlESH
   52NplHc1VUSD7+3WJme6KDC6hGpKwS3f6PrmFkMvKOzmn1egMBa3kqo9D
   jFR56S1y2yUjFsA43PBvPZ2M5pmxPYVCbkeYJrf13oEAxRJrSsnuSpU9+
   UPfpIBASIeKczM/hGVekdjt9jSMFMhqmdPoAv+WQ6DpHNFlwBGmHF7sP0
   vee/nTkaZR8nGwNyZmuE0PG/NlTM6gmJowQJIql/VrzmJsgxzjtgYFubN
   yQRBffSvB7sjbniwntW34tm1sPRncFO9x72mJBEgwWyWwYtD6QTZ26R+E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="378886174"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="378886174"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="733448098"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="733448098"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:41:32 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [kvm-unit-tests 5/6] x86: pmu: Limit vcpu's fixed counter into fixed_events[]
Date:   Fri,  1 Sep 2023 15:40:51 +0800
Message-Id: <20230901074052.640296-6-xiong.y.zhang@intel.com>
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

Arch PMU v5 has Fixed Counter Enumeration feature, user can specify a
fixed counter which has index greater than fixed_events[] array through
CPUID.0AH.ECX, so limit fixed counter index into fixed_events[] array.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 x86/pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0ec0062..416e9d7 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -53,6 +53,7 @@ char *buf;
 
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
+static unsigned int fixed_events_size;
 
 static inline void loop(void)
 {
@@ -256,6 +257,8 @@ static void check_fixed_counters(void)
 	int i;
 
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+		if (i >= fixed_events_size)
+			continue;
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
@@ -277,6 +280,8 @@ static void check_counters_many(void)
 		n++;
 	}
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+		if (i >= fixed_events_size)
+			continue;
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
 		n++;
@@ -700,6 +705,7 @@ int main(int ac, char **av)
 		}
 		gp_events = (struct pmu_event *)intel_gp_events;
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+		fixed_events_size = sizeof(fixed_events)/sizeof(fixed_events[0]);
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
-- 
2.34.1

