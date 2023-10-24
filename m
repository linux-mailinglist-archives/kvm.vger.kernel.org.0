Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A387D4904
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjJXHwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbjJXHvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:51:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940BC19B2;
        Tue, 24 Oct 2023 00:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133892; x=1729669892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BxG6wVyvyosYY4Ew029SXkTfwIymBHDUnYzPxlYLnc0=;
  b=N8rwUd8Vfz10b3+yfXbpyIklM80BHmv79H79LfbKILrctxGFFb/eZZcY
   iYB8DzKzwrtkUORxiCYNLkl4geEdz7WmHhqqiT7pYJHBgYso28oVsxeDD
   dzC0Id5JSclHJqf1gx/MfPyGvGTscJ8y8GublJ3PhKZncKDtFqaxr3+HV
   7a/TbvMQWoanzonou9d4Z9YdIPlYkfhj/bp9ogqYkQaLEt57eyfxVeLOi
   AkS0WEL+00MChAKpMrofpPtNFMnB9V2eOWmS3uzOtir3ssluSsxrcXjTJ
   KaxteSJb/NKZuytvZaorfy6eVrU9CUK35jl8tu8PinurugJOpiTMDLwak
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235231"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235231"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766330"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766330"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:51:10 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch 5/5] x86: pmu: Add asserts to warn inconsistent fixed events and counters
Date:   Tue, 24 Oct 2023 15:57:48 +0800
Message-Id: <20231024075748.1675382-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current PMU code deosn't check whether PMU fixed counter number is
larger than pre-defined fixed events. If so, it would cause memory
access out of range.

So add assert to warn this invalid case.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 41165e168d8e..a1d615fbab3d 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -112,8 +112,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
-	} else
-		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
+	} else {
+		int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
+
+		assert(idx < ARRAY_SIZE(fixed_events));
+		return &fixed_events[idx];
+	}
 
 	return (void*)0;
 }
@@ -246,6 +250,7 @@ static void check_fixed_counters(void)
 	};
 	int i;
 
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
@@ -267,6 +272,7 @@ static void check_counters_many(void)
 			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
-- 
2.34.1

