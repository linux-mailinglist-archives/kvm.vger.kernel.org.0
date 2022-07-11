Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E9056FE69
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiGKKLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiGKKKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E73A45045;
        Mon, 11 Jul 2022 02:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531990; x=1689067990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvQDeEVrAbIyF4HuhXZfOKtXRE1qctyELzoePKMwEPQ=;
  b=X7deRruWUJJYfC3R7QEt5XnzKNUNQugLR6JC9C4eu0L9TkuQW//lx+sH
   7p6+I+miYOz8/9iKr1X4LgswiNYs/wIrwcKTih3zmppIz76cEaK62Gxkz
   dqfaix3BmcG72r2oHk9/IBrezH9XhK3N4S8rFkgGfn6W9e3Rwdkvfg+tW
   l7/56622TgAsLjQ8hYGKr6j108kRPEzV+tGZK/6apRX0vpN/y4iYX6THu
   ZtHcCkYWsHXiwCrsLKdx+k0CT5vmjYafcdDSB7XcrIXDprhr89u+5UeV4
   mM02n+17w0fab3ldLy2Y623vDUk5AlCN+ZTs3j2/GWrKYnDIfHypfh+N4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371566"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371566"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387079"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:08 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 12/35] perf tools: Add guest_cpu to hypervisor threads
Date:   Mon, 11 Jul 2022 12:31:55 +0300
Message-Id: <20220711093218.10967-13-adrian.hunter@intel.com>
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

It is possible to know which guest machine was running at a point in time
based on the PID of the currently running host thread. That is, perf
identifies guest machines by the PID of the hypervisor.

To determine the guest CPU, put it on the hypervisor (QEMU) thread for
that VCPU.

This is done when processing the id_index which provides the necessary
information.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 18 ++++++++++++++++++
 tools/perf/util/thread.c  |  1 +
 tools/perf/util/thread.h  |  1 +
 3 files changed, 20 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1af981d5ad3c..91a091c35945 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2769,6 +2769,20 @@ static int perf_session__register_guest(struct perf_session *session, pid_t mach
 	return 0;
 }
 
+static int perf_session__set_guest_cpu(struct perf_session *session, pid_t pid,
+				       pid_t tid, int guest_cpu)
+{
+	struct machine *machine = &session->machines.host;
+	struct thread *thread = machine__findnew_thread(machine, pid, tid);
+
+	if (!thread)
+		return -ENOMEM;
+	thread->guest_cpu = guest_cpu;
+	thread__put(thread);
+
+	return 0;
+}
+
 int perf_event__process_id_index(struct perf_session *session,
 				 union perf_event *event)
 {
@@ -2845,6 +2859,10 @@ int perf_event__process_id_index(struct perf_session *session,
 			last_pid = sid->machine_pid;
 			perf_guest = true;
 		}
+
+		ret = perf_session__set_guest_cpu(session, sid->machine_pid, e->tid, e2->vcpu);
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 665e5c0618ed..e3e5427e1c3c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -47,6 +47,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->tid = tid;
 		thread->ppid = -1;
 		thread->cpu = -1;
+		thread->guest_cpu = -1;
 		thread->lbr_stitch_enable = false;
 		INIT_LIST_HEAD(&thread->namespaces_list);
 		INIT_LIST_HEAD(&thread->comm_list);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index b066fb30d203..241f300d7d6e 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -39,6 +39,7 @@ struct thread {
 	pid_t			tid;
 	pid_t			ppid;
 	int			cpu;
+	int			guest_cpu; /* For QEMU thread */
 	refcount_t		refcnt;
 	bool			comm_set;
 	int			comm_len;
-- 
2.25.1

