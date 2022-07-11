Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3956FE65
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiGKKL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiGKKK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB857820F;
        Mon, 11 Jul 2022 02:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531985; x=1689067985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yN8l0HnChol0FDVhQIhHHh94ut1DeNTcvpI2bpWYEZM=;
  b=fnpRaxrWyi3lkOEeAXBDBGLJzqM/n2YVZs3l4jL76NBgtQTtaYN/qQ6+
   YFu8u0TzpGK73/axld1ic4XgJbgZBjoEDRlnp/fyxODQ2h0X1acgE4V59
   rAxxWtxAMFOTbGsD3YWy/+UEgzMPkKdM0P5mASnpNFU2+MVbks8ghervK
   ZfWMqkgz641mPo+7w4VpOj4iZeFHgv/1eo3KFgpr4ObPWSflnQdeZIDG8
   RcYiZnUwPProS7c0xtb7NPiSE6JUQkrVdTbLZ89CR+X7ZcJaqGvsq721l
   H/zAgaQ4475mQPMqGRRQ8zbN3oe0zeSvomanODluW9Lp6cAWc8pTP1HH8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371557"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371557"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387060"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:03 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 10/35] perf tools: Add machine_pid and vcpu to id_index
Date:   Mon, 11 Jul 2022 12:31:53 +0300
Message-Id: <20220711093218.10967-11-adrian.hunter@intel.com>
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

When injecting events from a guest perf.data file, the events will have
separate sample ID numbers. These ID numbers can then be used to determine
which machine an event belongs to. To facilitate that, add machine_pid and
vcpu to id_index records. For backward compatibility, these are added at
the end of the record, and the length of the record is used to determine
if they are present or not.

Note, this is needed because the events from a guest perf.data file contain
the pid/tid of the process running at that time inside the VM not the
pid/tid of the (QEMU) hypervisor thread. So a way is needed to relate
guest events back to the guest machine and VCPU, and using sample ID
numbers for that is relatively simple and convenient.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/lib/perf/include/internal/evsel.h |  4 ++
 tools/lib/perf/include/perf/event.h     |  5 +++
 tools/perf/util/session.c               | 40 ++++++++++++++++---
 tools/perf/util/synthetic-events.c      | 51 +++++++++++++++++++------
 tools/perf/util/synthetic-events.h      |  1 +
 5 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/tools/lib/perf/include/internal/evsel.h b/tools/lib/perf/include/internal/evsel.h
index 2a912a1f1989..a99a75d9e78f 100644
--- a/tools/lib/perf/include/internal/evsel.h
+++ b/tools/lib/perf/include/internal/evsel.h
@@ -30,6 +30,10 @@ struct perf_sample_id {
 	struct perf_cpu		 cpu;
 	pid_t			 tid;
 
+	/* Guest machine pid and VCPU, valid only if machine_pid is non-zero */
+	pid_t			 machine_pid;
+	struct perf_cpu		 vcpu;
+
 	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
 	u64			 period;
 };
diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 9f7ca070da87..c2dbd3e88885 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -237,6 +237,11 @@ struct id_index_entry {
 	__u64			 tid;
 };
 
+struct id_index_entry_2 {
+	__u64			 machine_pid;
+	__u64			 vcpu;
+};
+
 struct perf_record_id_index {
 	struct perf_event_header header;
 	__u64			 nr;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4c9513bc6d89..5141fe164e97 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2756,18 +2756,35 @@ int perf_event__process_id_index(struct perf_session *session,
 {
 	struct evlist *evlist = session->evlist;
 	struct perf_record_id_index *ie = &event->id_index;
+	size_t sz = ie->header.size - sizeof(*ie);
 	size_t i, nr, max_nr;
+	size_t e1_sz = sizeof(struct id_index_entry);
+	size_t e2_sz = sizeof(struct id_index_entry_2);
+	size_t etot_sz = e1_sz + e2_sz;
+	struct id_index_entry_2 *e2;
 
-	max_nr = (ie->header.size - sizeof(struct perf_record_id_index)) /
-		 sizeof(struct id_index_entry);
+	max_nr = sz / e1_sz;
 	nr = ie->nr;
-	if (nr > max_nr)
+	if (nr > max_nr) {
+		printf("Too big: nr %zu max_nr %zu\n", nr, max_nr);
 		return -EINVAL;
+	}
+
+	if (sz >= nr * etot_sz) {
+		max_nr = sz / etot_sz;
+		if (nr > max_nr) {
+			printf("Too big2: nr %zu max_nr %zu\n", nr, max_nr);
+			return -EINVAL;
+		}
+		e2 = (void *)ie + sizeof(*ie) + nr * e1_sz;
+	} else {
+		e2 = NULL;
+	}
 
 	if (dump_trace)
 		fprintf(stdout, " nr: %zu\n", nr);
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < nr; i++, (e2 ? e2++ : 0)) {
 		struct id_index_entry *e = &ie->entries[i];
 		struct perf_sample_id *sid;
 
@@ -2775,15 +2792,28 @@ int perf_event__process_id_index(struct perf_session *session,
 			fprintf(stdout,	" ... id: %"PRI_lu64, e->id);
 			fprintf(stdout,	"  idx: %"PRI_lu64, e->idx);
 			fprintf(stdout,	"  cpu: %"PRI_ld64, e->cpu);
-			fprintf(stdout,	"  tid: %"PRI_ld64"\n", e->tid);
+			fprintf(stdout, "  tid: %"PRI_ld64, e->tid);
+			if (e2) {
+				fprintf(stdout, "  machine_pid: %"PRI_ld64, e2->machine_pid);
+				fprintf(stdout, "  vcpu: %"PRI_lu64"\n", e2->vcpu);
+			} else {
+				fprintf(stdout, "\n");
+			}
 		}
 
 		sid = evlist__id2sid(evlist, e->id);
 		if (!sid)
 			return -ENOENT;
+
 		sid->idx = e->idx;
 		sid->cpu.cpu = e->cpu;
 		sid->tid = e->tid;
+
+		if (!e2)
+			continue;
+
+		sid->machine_pid = e2->machine_pid;
+		sid->vcpu.cpu = e2->vcpu;
 	}
 	return 0;
 }
diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index ed9623702f34..2ae59c03ae77 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1759,19 +1759,26 @@ int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_s
 	return (void *)array - (void *)start;
 }
 
-int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
-				    struct evlist *evlist, struct machine *machine)
+int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
+				      struct evlist *evlist, struct machine *machine, size_t from)
 {
 	union perf_event *ev;
 	struct evsel *evsel;
-	size_t nr = 0, i = 0, sz, max_nr, n;
+	size_t nr = 0, i = 0, sz, max_nr, n, pos;
+	size_t e1_sz = sizeof(struct id_index_entry);
+	size_t e2_sz = sizeof(struct id_index_entry_2);
+	size_t etot_sz = e1_sz + e2_sz;
+	bool e2_needed = false;
 	int err;
 
-	max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) /
-		 sizeof(struct id_index_entry);
+	max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) / etot_sz;
 
-	evlist__for_each_entry(evlist, evsel)
+	pos = 0;
+	evlist__for_each_entry(evlist, evsel) {
+		if (pos++ < from)
+			continue;
 		nr += evsel->core.ids;
+	}
 
 	if (!nr)
 		return 0;
@@ -1779,31 +1786,38 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
 	pr_debug2("Synthesizing id index\n");
 
 	n = nr > max_nr ? max_nr : nr;
-	sz = sizeof(struct perf_record_id_index) + n * sizeof(struct id_index_entry);
+	sz = sizeof(struct perf_record_id_index) + n * etot_sz;
 	ev = zalloc(sz);
 	if (!ev)
 		return -ENOMEM;
 
+	sz = sizeof(struct perf_record_id_index) + n * e1_sz;
+
 	ev->id_index.header.type = PERF_RECORD_ID_INDEX;
-	ev->id_index.header.size = sz;
 	ev->id_index.nr = n;
 
+	pos = 0;
 	evlist__for_each_entry(evlist, evsel) {
 		u32 j;
 
-		for (j = 0; j < evsel->core.ids; j++) {
+		if (pos++ < from)
+			continue;
+		for (j = 0; j < evsel->core.ids; j++, i++) {
 			struct id_index_entry *e;
+			struct id_index_entry_2 *e2;
 			struct perf_sample_id *sid;
 
 			if (i >= n) {
+				ev->id_index.header.size = sz + (e2_needed ? n * e2_sz : 0);
 				err = process(tool, ev, NULL, machine);
 				if (err)
 					goto out_err;
 				nr -= n;
 				i = 0;
+				e2_needed = false;
 			}
 
-			e = &ev->id_index.entries[i++];
+			e = &ev->id_index.entries[i];
 
 			e->id = evsel->core.id[j];
 
@@ -1816,11 +1830,18 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
 			e->idx = sid->idx;
 			e->cpu = sid->cpu.cpu;
 			e->tid = sid->tid;
+
+			if (sid->machine_pid)
+				e2_needed = true;
+
+			e2 = (void *)ev + sz;
+			e2[i].machine_pid = sid->machine_pid;
+			e2[i].vcpu        = sid->vcpu.cpu;
 		}
 	}
 
-	sz = sizeof(struct perf_record_id_index) + nr * sizeof(struct id_index_entry);
-	ev->id_index.header.size = sz;
+	sz = sizeof(struct perf_record_id_index) + nr * e1_sz;
+	ev->id_index.header.size = sz + (e2_needed ? nr * e2_sz : 0);
 	ev->id_index.nr = nr;
 
 	err = process(tool, ev, NULL, machine);
@@ -1830,6 +1851,12 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
 	return err;
 }
 
+int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
+				    struct evlist *evlist, struct machine *machine)
+{
+	return __perf_event__synthesize_id_index(tool, process, evlist, machine, 0);
+}
+
 int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
 				  struct target *target, struct perf_thread_map *threads,
 				  perf_event__handler_t process, bool needs_mmap,
diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
index b136ec3ec95d..81cb3d6af0b9 100644
--- a/tools/perf/util/synthetic-events.h
+++ b/tools/perf/util/synthetic-events.h
@@ -55,6 +55,7 @@ int perf_event__synthesize_extra_attr(struct perf_tool *tool, struct evlist *evs
 int perf_event__synthesize_extra_kmaps(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_features(struct perf_tool *tool, struct perf_session *session, struct evlist *evlist, perf_event__handler_t process);
 int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine);
+int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine, size_t from);
 int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_mmap_events(struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine, bool mmap_data);
-- 
2.25.1

