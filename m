Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0459C56FE9A
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiGKKOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiGKKOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:14:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3011C29;
        Mon, 11 Jul 2022 02:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532053; x=1689068053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O3190nooY039Ty/FrmVIXqbtnejrADzOmSlS4bX40V0=;
  b=cBsJ2ZAZxW7cX55oCOWiUmpW1OpqIEPhfNQ7R4LDe9fl/+k0vPMrJOS8
   OZ8jZSbC8tCKLFP/XppEEQdEM2Ki+J6ffF1HWrL0//+f4IVotOSOe1vh5
   lhG6HjJeR/1nE8pfDCLSqcyQ0/tTQDVE6YsK0ufptf7V9v4GI/q+b/FP+
   3teZvohcrMQi6xhiuwKDiRhsVSw6QENQxYrXCxPsHaXz0S/8KNIsjlfpH
   aphkpN/JfsPVtKd+ke/LWJwcJ+HuWOkXpoA5ZlF+NjTA3n+akNhC1qZyF
   NT8EuZxeZTLgHiDWDHrGFtPFuu0iYQ8OVcw4xpS/Cg8AR46uv8qjnuCD5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371722"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371722"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387275"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:52 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 31/35] perf intel-pt: Disable sync switch with guest sideband
Date:   Mon, 11 Jul 2022 12:32:14 +0300
Message-Id: <20220711093218.10967-32-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711093218.10967-1-adrian.hunter@intel.com>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sync_switch facility attempts to better synchronize context switches
with the Intel PT trace, however it is not designed for guest machine
context switches, so disable it when guest sideband is detected.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 98b097fec476..dc2af64f9e31 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -74,6 +74,7 @@ struct intel_pt {
 	bool data_queued;
 	bool est_tsc;
 	bool sync_switch;
+	bool sync_switch_not_supported;
 	bool mispred_all;
 	bool use_thread_stack;
 	bool callstack;
@@ -2638,6 +2639,9 @@ static void intel_pt_enable_sync_switch(struct intel_pt *pt)
 {
 	unsigned int i;
 
+	if (pt->sync_switch_not_supported)
+		return;
+
 	pt->sync_switch = true;
 
 	for (i = 0; i < pt->queues.nr_queues; i++) {
@@ -2649,6 +2653,23 @@ static void intel_pt_enable_sync_switch(struct intel_pt *pt)
 	}
 }
 
+static void intel_pt_disable_sync_switch(struct intel_pt *pt)
+{
+	unsigned int i;
+
+	pt->sync_switch = false;
+
+	for (i = 0; i < pt->queues.nr_queues; i++) {
+		struct auxtrace_queue *queue = &pt->queues.queue_array[i];
+		struct intel_pt_queue *ptq = queue->priv;
+
+		if (ptq) {
+			ptq->sync_switch = false;
+			intel_pt_next_tid(pt, ptq);
+		}
+	}
+}
+
 /*
  * To filter against time ranges, it is only necessary to look at the next start
  * or end time.
@@ -3090,6 +3111,14 @@ static int intel_pt_guest_context_switch(struct intel_pt *pt,
 
 	pt->have_guest_sideband = true;
 
+	/*
+	 * sync_switch cannot handle guest machines at present, so just disable
+	 * it.
+	 */
+	pt->sync_switch_not_supported = true;
+	if (pt->sync_switch)
+		intel_pt_disable_sync_switch(pt);
+
 	if (out)
 		return 0;
 
-- 
2.25.1

