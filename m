Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA156FE9C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiGKKOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGKKOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:14:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF824A83E;
        Mon, 11 Jul 2022 02:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532055; x=1689068055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TSgiek8mItA/pqYjGSTKdQzP4Ez5i64yAdOC7OFZUIs=;
  b=SURf09ATeTys7j7+58Z5OYjDXO2/HPgKK1iJ3C/gs/jHy6geL7itkRdC
   VuPNT0j3Ih34gpLErZGPcz/WAdHtHT/GQUuJYBydYY61JnDOqC9hwUfAZ
   e4nNCY13dja9K8+3cFPjnjhwYcTt8zYQNCXHR/UcV+Zo26vOEsv9IjLHa
   sCf6iFeyP0jyTKryrZNkG6g3rWr2zG70EFBn8wrrG/VHBMXgXliy7H74n
   fkfxNkB5v+q2OrUxHiB0c1l45Oq4tXTM71JAWQ2SrLzFU0pLjomCHruzi
   wLixdce8P1JxhUlA379XGHVaM9Yi6CtCkYy7et3BUh5d8vL+GfO1TlkNt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371733"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371733"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387281"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:55 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 32/35] perf intel-pt: Determine guest thread from guest sideband
Date:   Mon, 11 Jul 2022 12:32:15 +0300
Message-Id: <20220711093218.10967-33-adrian.hunter@intel.com>
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

Prior to decoding, determine what guest thread, if any, is running.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 69 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index dc2af64f9e31..a08c2f059d5a 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -196,6 +196,10 @@ struct intel_pt_queue {
 	struct machine *guest_machine;
 	struct thread *guest_thread;
 	struct thread *unknown_guest_thread;
+	pid_t guest_machine_pid;
+	pid_t guest_pid;
+	pid_t guest_tid;
+	int vcpu;
 	bool exclude_kernel;
 	bool have_sample;
 	u64 time;
@@ -759,8 +763,13 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 	cpumode = intel_pt_nr_cpumode(ptq, *ip, nr);
 
 	if (nr) {
-		if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
-		    intel_pt_get_guest(ptq)) {
+		if (ptq->pt->have_guest_sideband) {
+			if (!ptq->guest_machine || ptq->guest_machine_pid != ptq->pid) {
+				intel_pt_log("ERROR: guest sideband but no guest machine\n");
+				return -EINVAL;
+			}
+		} else if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
+			   intel_pt_get_guest(ptq)) {
 			intel_pt_log("ERROR: no guest machine\n");
 			return -EINVAL;
 		}
@@ -1385,6 +1394,55 @@ static void intel_pt_first_timestamp(struct intel_pt *pt, u64 timestamp)
 	}
 }
 
+static int intel_pt_get_guest_from_sideband(struct intel_pt_queue *ptq)
+{
+	struct machines *machines = &ptq->pt->session->machines;
+	struct machine *machine;
+	pid_t machine_pid = ptq->pid;
+	pid_t tid;
+	int vcpu;
+
+	if (machine_pid <= 0)
+		return 0; /* Not a guest machine */
+
+	machine = machines__find(machines, machine_pid);
+	if (!machine)
+		return 0; /* Not a guest machine */
+
+	if (ptq->guest_machine != machine) {
+		ptq->guest_machine = NULL;
+		thread__zput(ptq->guest_thread);
+		thread__zput(ptq->unknown_guest_thread);
+
+		ptq->unknown_guest_thread = machine__find_thread(machine, 0, 0);
+		if (!ptq->unknown_guest_thread)
+			return -1;
+		ptq->guest_machine = machine;
+	}
+
+	vcpu = ptq->thread ? ptq->thread->guest_cpu : -1;
+	if (vcpu < 0)
+		return -1;
+
+	tid = machine__get_current_tid(machine, vcpu);
+
+	if (ptq->guest_thread && ptq->guest_thread->tid != tid)
+		thread__zput(ptq->guest_thread);
+
+	if (!ptq->guest_thread) {
+		ptq->guest_thread = machine__find_thread(machine, -1, tid);
+		if (!ptq->guest_thread)
+			return -1;
+	}
+
+	ptq->guest_machine_pid = machine_pid;
+	ptq->guest_pid = ptq->guest_thread->pid_;
+	ptq->guest_tid = tid;
+	ptq->vcpu = vcpu;
+
+	return 0;
+}
+
 static void intel_pt_set_pid_tid_cpu(struct intel_pt *pt,
 				     struct auxtrace_queue *queue)
 {
@@ -1405,6 +1463,13 @@ static void intel_pt_set_pid_tid_cpu(struct intel_pt *pt,
 		if (queue->cpu == -1)
 			ptq->cpu = ptq->thread->cpu;
 	}
+
+	if (pt->have_guest_sideband && intel_pt_get_guest_from_sideband(ptq)) {
+		ptq->guest_machine_pid = 0;
+		ptq->guest_pid = -1;
+		ptq->guest_tid = -1;
+		ptq->vcpu = -1;
+	}
 }
 
 static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
-- 
2.25.1

