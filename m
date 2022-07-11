Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9356FE78
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiGKKMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiGKKLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:11:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E6EFC0;
        Mon, 11 Jul 2022 02:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532018; x=1689068018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/a5qZZGpNtndm6rUQqcl56PShNnw1rr+WD+uSPlLNzA=;
  b=dgPdmbQsjJMA+I5S0LDgqN6aM/8fmZETci3N/Qlybq6/eJ6gFoP1G1TP
   j2eRFLMtwSypJ0ipQn1Xtl+dHcAl1jcLLEX43ScFadc2GUs1BaDnBOh54
   W9txin2STEgdtFPvVXUdDXaiEUY5l0xFTkNhE16j72GrN6bdsq0NaK2/+
   yGs8xRNKqlKKQgpveJsDOd6ItqOufnTBTvzAbcHAb+0FCUMQf7c1HdOIp
   bNv51kTBo4UuVcrmsegzsuhDPD9Nv3kyikgaP2O9DpYqpGVkr3hjcc8/M
   Al2blgGtJEfUPldhOY0+BkyQ3zd2AVxpZJaR5jw6p6I3gfsIJQKDCp++7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371600"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371600"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387132"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:19 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 17/35] perf auxtrace: Add machine_pid and vcpu to auxtrace_error
Date:   Mon, 11 Jul 2022 12:32:00 +0300
Message-Id: <20220711093218.10967-18-adrian.hunter@intel.com>
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

Add machine_pid and vcpu to struct perf_record_auxtrace_error. The existing
fmt member is used to identify the new format.

The new members make it possible to easily differentiate errors from guest
machines.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/lib/perf/include/perf/event.h           |  2 ++
 tools/perf/util/auxtrace.c                    | 30 +++++++++++++++----
 tools/perf/util/auxtrace.h                    |  4 +++
 .../scripting-engines/trace-event-python.c    |  4 ++-
 tools/perf/util/session.c                     |  4 +++
 5 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index c2dbd3e88885..556bb06798f2 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -279,6 +279,8 @@ struct perf_record_auxtrace_error {
 	__u64			 ip;
 	__u64			 time;
 	char			 msg[MAX_AUXTRACE_ERROR_MSG];
+	__u32			 machine_pid;
+	__u32			 vcpu;
 };
 
 struct perf_record_aux {
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 511dd3caa1bc..6edab8a16de6 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1189,9 +1189,10 @@ void auxtrace_buffer__free(struct auxtrace_buffer *buffer)
 	free(buffer);
 }
 
-void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
-			  int code, int cpu, pid_t pid, pid_t tid, u64 ip,
-			  const char *msg, u64 timestamp)
+void auxtrace_synth_guest_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
+				int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+				const char *msg, u64 timestamp,
+				pid_t machine_pid, int vcpu)
 {
 	size_t size;
 
@@ -1207,12 +1208,26 @@ void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int
 	auxtrace_error->ip = ip;
 	auxtrace_error->time = timestamp;
 	strlcpy(auxtrace_error->msg, msg, MAX_AUXTRACE_ERROR_MSG);
-
-	size = (void *)auxtrace_error->msg - (void *)auxtrace_error +
-	       strlen(auxtrace_error->msg) + 1;
+	if (machine_pid) {
+		auxtrace_error->fmt = 2;
+		auxtrace_error->machine_pid = machine_pid;
+		auxtrace_error->vcpu = vcpu;
+		size = sizeof(*auxtrace_error);
+	} else {
+		size = (void *)auxtrace_error->msg - (void *)auxtrace_error +
+		       strlen(auxtrace_error->msg) + 1;
+	}
 	auxtrace_error->header.size = PERF_ALIGN(size, sizeof(u64));
 }
 
+void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
+			  int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+			  const char *msg, u64 timestamp)
+{
+	auxtrace_synth_guest_error(auxtrace_error, type, code, cpu, pid, tid,
+				   ip, msg, timestamp, 0, -1);
+}
+
 int perf_event__synthesize_auxtrace_info(struct auxtrace_record *itr,
 					 struct perf_tool *tool,
 					 struct perf_session *session,
@@ -1662,6 +1677,9 @@ size_t perf_event__fprintf_auxtrace_error(union perf_event *event, FILE *fp)
 	if (!e->fmt)
 		msg = (const char *)&e->time;
 
+	if (e->fmt >= 2 && e->machine_pid)
+		ret += fprintf(fp, " machine_pid %d vcpu %d", e->machine_pid, e->vcpu);
+
 	ret += fprintf(fp, " cpu %d pid %d tid %d ip %#"PRI_lx64" code %u: %s\n",
 		       e->cpu, e->pid, e->tid, e->ip, e->code, msg);
 	return ret;
diff --git a/tools/perf/util/auxtrace.h b/tools/perf/util/auxtrace.h
index cd0d25c2751c..6a4fbfd34c6b 100644
--- a/tools/perf/util/auxtrace.h
+++ b/tools/perf/util/auxtrace.h
@@ -595,6 +595,10 @@ int auxtrace_index__process(int fd, u64 size, struct perf_session *session,
 			    bool needs_swap);
 void auxtrace_index__free(struct list_head *head);
 
+void auxtrace_synth_guest_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
+				int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+				const char *msg, u64 timestamp,
+				pid_t machine_pid, int vcpu);
 void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
 			  int code, int cpu, pid_t pid, pid_t tid, u64 ip,
 			  const char *msg, u64 timestamp);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index adba01b7d9dd..3367c5479199 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1559,7 +1559,7 @@ static void python_process_auxtrace_error(struct perf_session *session __maybe_u
 		msg = (const char *)&e->time;
 	}
 
-	t = tuple_new(9);
+	t = tuple_new(11);
 
 	tuple_set_u32(t, 0, e->type);
 	tuple_set_u32(t, 1, e->code);
@@ -1570,6 +1570,8 @@ static void python_process_auxtrace_error(struct perf_session *session __maybe_u
 	tuple_set_u64(t, 6, tm);
 	tuple_set_string(t, 7, msg);
 	tuple_set_u32(t, 8, cpumode);
+	tuple_set_s32(t, 9, e->machine_pid);
+	tuple_set_s32(t, 10, e->vcpu);
 
 	call_object(handler, t, handler_name);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f3e9fa557bc9..7ea0b91013ea 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -895,6 +895,10 @@ static void perf_event__auxtrace_error_swap(union perf_event *event,
 	event->auxtrace_error.ip   = bswap_64(event->auxtrace_error.ip);
 	if (event->auxtrace_error.fmt)
 		event->auxtrace_error.time = bswap_64(event->auxtrace_error.time);
+	if (event->auxtrace_error.fmt >= 2) {
+		event->auxtrace_error.machine_pid = bswap_32(event->auxtrace_error.machine_pid);
+		event->auxtrace_error.vcpu = bswap_32(event->auxtrace_error.vcpu);
+	}
 }
 
 static void perf_event__thread_map_swap(union perf_event *event,
-- 
2.25.1

