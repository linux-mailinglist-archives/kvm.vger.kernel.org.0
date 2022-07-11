Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D756FEAC
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiGKKO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiGKKOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:14:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4760C7AB0C;
        Mon, 11 Jul 2022 02:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532055; x=1689068055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OO5OSxWtcVi19UaKG1wG+Lbf+qENiVNRyjc3YIAVR6Y=;
  b=RC+CLjSgYzKiXm4P6oI0cxWwyyl9lXoQjo/WFWqG8wUYd9IJ6yy5goH5
   sBJMerIpdMCoq0uf5lVUgd3CNe+PMm1Y5AhzhixTsQmhotYfXKteZ8pVY
   Ou4+lN5rcTiQUo33KG5eK7SF6AIEr4758KhE06NUv7o4WbISyoR6KlgAM
   ++21CWlI6beaUHV7LW6JklWPq23IWdsNVyJ8nfrCSUS+ZjL1MwLzAO6uz
   Ca3euZfwDvKsAIJ/W+VBGk1YL4WKBX1FUH7MJJvY5T8ywoqXkHdCTJaqQ
   d8cjXr0bvsOz36Nqr53Du6lBVYqO5RMeAQ+hTwjJuMEysVn6eWjkvH0UL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371740"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371740"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387290"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:57 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 33/35] perf intel-pt: Add machine_pid and vcpu to auxtrace_error
Date:   Mon, 11 Jul 2022 12:32:16 +0300
Message-Id: <20220711093218.10967-34-adrian.hunter@intel.com>
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

When decoding with guest sideband information, for VMX non-root (NR)
i.e. guest errors, replace the host (hypervisor) pid/tid with guest values,
and provide also the new machine_pid and vcpu values.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index a08c2f059d5a..143a096b567b 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2404,7 +2404,8 @@ static int intel_pt_synth_iflag_chg_sample(struct intel_pt_queue *ptq)
 }
 
 static int intel_pt_synth_error(struct intel_pt *pt, int code, int cpu,
-				pid_t pid, pid_t tid, u64 ip, u64 timestamp)
+				pid_t pid, pid_t tid, u64 ip, u64 timestamp,
+				pid_t machine_pid, int vcpu)
 {
 	union perf_event event;
 	char msg[MAX_AUXTRACE_ERROR_MSG];
@@ -2421,8 +2422,9 @@ static int intel_pt_synth_error(struct intel_pt *pt, int code, int cpu,
 
 	intel_pt__strerror(code, msg, MAX_AUXTRACE_ERROR_MSG);
 
-	auxtrace_synth_error(&event.auxtrace_error, PERF_AUXTRACE_ERROR_ITRACE,
-			     code, cpu, pid, tid, ip, msg, timestamp);
+	auxtrace_synth_guest_error(&event.auxtrace_error, PERF_AUXTRACE_ERROR_ITRACE,
+				   code, cpu, pid, tid, ip, msg, timestamp,
+				   machine_pid, vcpu);
 
 	err = perf_session__deliver_synth_event(pt->session, &event, NULL);
 	if (err)
@@ -2437,11 +2439,22 @@ static int intel_ptq_synth_error(struct intel_pt_queue *ptq,
 {
 	struct intel_pt *pt = ptq->pt;
 	u64 tm = ptq->timestamp;
+	pid_t machine_pid = 0;
+	pid_t pid = ptq->pid;
+	pid_t tid = ptq->tid;
+	int vcpu = -1;
 
 	tm = pt->timeless_decoding ? 0 : tsc_to_perf_time(tm, &pt->tc);
 
-	return intel_pt_synth_error(pt, state->err, ptq->cpu, ptq->pid,
-				    ptq->tid, state->from_ip, tm);
+	if (pt->have_guest_sideband && state->from_nr) {
+		machine_pid = ptq->guest_machine_pid;
+		vcpu = ptq->vcpu;
+		pid = ptq->guest_pid;
+		tid = ptq->guest_tid;
+	}
+
+	return intel_pt_synth_error(pt, state->err, ptq->cpu, pid, tid,
+				    state->from_ip, tm, machine_pid, vcpu);
 }
 
 static int intel_pt_next_tid(struct intel_pt *pt, struct intel_pt_queue *ptq)
@@ -3028,7 +3041,8 @@ static int intel_pt_process_timeless_sample(struct intel_pt *pt,
 static int intel_pt_lost(struct intel_pt *pt, struct perf_sample *sample)
 {
 	return intel_pt_synth_error(pt, INTEL_PT_ERR_LOST, sample->cpu,
-				    sample->pid, sample->tid, 0, sample->time);
+				    sample->pid, sample->tid, 0, sample->time,
+				    sample->machine_pid, sample->vcpu);
 }
 
 static struct intel_pt_queue *intel_pt_cpu_to_ptq(struct intel_pt *pt, int cpu)
-- 
2.25.1

