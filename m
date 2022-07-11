Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAE256FE97
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiGKKOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiGKKNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:13:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A111CAC06C;
        Mon, 11 Jul 2022 02:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532049; x=1689068049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uD6eM9PySK2Xd/GIu8V/XBu1JFyCDD9F/L1xE8yv2z0=;
  b=H2o4HN72rmbjV02CU9+NQQ3v9nGirroMCXrF3D9tCHeyvX2YoV9L9TX6
   lEZnUgaUrmUG2ju4ldsS3XicBl1ZbDhe+UDi5rmzvGtVa9JokKBMn7ScH
   kiVCqzKS2/55wSNw81MJZQuvBGw6fet8bdxBma/fy5VjRviK5/wZznJrU
   h5hqhbi/q3r6jbvOp0PXskNVMWy7TEdGjjklEosMD5tINKLGVMXvvqWrF
   fBeyAsHqxtKSwPTfYVYvH3yHvWUbKag/0eE3hhAIS/kv6U1DkfTsHPDrZ
   c4cOJERXhgGsnC4F7qv9F8rcBDIjD0Gcdt6WI898GNAkduCu7uZ7sZ6fI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371715"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371715"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387267"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:50 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 30/35] perf intel-pt: Track guest context switches
Date:   Mon, 11 Jul 2022 12:32:13 +0300
Message-Id: <20220711093218.10967-31-adrian.hunter@intel.com>
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

Use guest context switch events to keep track of which guest thread is
running on a particular guest machine and VCPU.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index a8798b5bb311..98b097fec476 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -78,6 +78,7 @@ struct intel_pt {
 	bool use_thread_stack;
 	bool callstack;
 	bool cap_event_trace;
+	bool have_guest_sideband;
 	unsigned int br_stack_sz;
 	unsigned int br_stack_sz_plus;
 	int have_sched_switch;
@@ -3079,6 +3080,25 @@ static int intel_pt_context_switch_in(struct intel_pt *pt,
 	return machine__set_current_tid(pt->machine, cpu, pid, tid);
 }
 
+static int intel_pt_guest_context_switch(struct intel_pt *pt,
+					 union perf_event *event,
+					 struct perf_sample *sample)
+{
+	bool out = event->header.misc & PERF_RECORD_MISC_SWITCH_OUT;
+	struct machines *machines = &pt->session->machines;
+	struct machine *machine = machines__find(machines, sample->machine_pid);
+
+	pt->have_guest_sideband = true;
+
+	if (out)
+		return 0;
+
+	if (!machine)
+		return -EINVAL;
+
+	return machine__set_current_tid(machine, sample->vcpu, sample->pid, sample->tid);
+}
+
 static int intel_pt_context_switch(struct intel_pt *pt, union perf_event *event,
 				   struct perf_sample *sample)
 {
@@ -3086,6 +3106,9 @@ static int intel_pt_context_switch(struct intel_pt *pt, union perf_event *event,
 	pid_t pid, tid;
 	int cpu, ret;
 
+	if (perf_event__is_guest(event))
+		return intel_pt_guest_context_switch(pt, event, sample);
+
 	cpu = sample->cpu;
 
 	if (pt->have_sched_switch == 3) {
-- 
2.25.1

