Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8D56FE5C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiGKKKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiGKKKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F71BFAFE;
        Mon, 11 Jul 2022 02:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531976; x=1689067976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EQmJPhIRVFDcY2WyYLRk47c63sx+cSKRVC+YAWr9f2E=;
  b=nwODpKNyYyHWtB4p8hSquZX+QRNhBLtwulewXQIbWYAy/KfYXXDgq0do
   alMhpaZQbmo7bGd2Ld6bwx9Y/JDBo0TZs3LBZTosaByEkThb1gRHNjqSZ
   9ID53IplxIFC7LwxNK5Ba7YiuyGo8Qmtrr+QuEfmSnYg6ruihVNF6xHY0
   RRiMfwt+TpcFMZ+BtzZbxR4FNPXhpeaV4uxYrL4GkkvL1ehqP8RX8gl90
   2gTxsL4vETu2WEyttSyZI4XeptIPFxHTCvReZG2iS/3eYRSnmejJPcTyT
   o630SCBnM/cMGXV0a1WYx4WSB0Zrn6iCPHuUmGv5IfW0xdLg0QROm1/M6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371540"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371540"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387031"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:54 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 06/35] perf tools: Add perf_event__synthesize_id_sample()
Date:   Mon, 11 Jul 2022 12:31:49 +0300
Message-Id: <20220711093218.10967-7-adrian.hunter@intel.com>
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

Add perf_event__synthesize_id_sample() to enable the synthesis of
ID samples.

This is needed by perf inject. When injecting events from a guest perf.data
file, there is a possibility that the sample ID numbers conflict. In that
case, perf_event__synthesize_id_sample() can be used to re-write the ID
sample.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/synthetic-events.c | 47 ++++++++++++++++++++++++++++++
 tools/perf/util/synthetic-events.h |  1 +
 2 files changed, 48 insertions(+)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index fe5db4bf0042..ed9623702f34 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1712,6 +1712,53 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_fo
 	return 0;
 }
 
+int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample)
+{
+	__u64 *start = array;
+
+	/*
+	 * used for cross-endian analysis. See git commit 65014ab3
+	 * for why this goofiness is needed.
+	 */
+	union u64_swap u;
+
+	if (type & PERF_SAMPLE_TID) {
+		u.val32[0] = sample->pid;
+		u.val32[1] = sample->tid;
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		*array = sample->time;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		*array = sample->id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		*array = sample->stream_id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u.val32[0] = sample->cpu;
+		u.val32[1] = 0;
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		*array = sample->id;
+		array++;
+	}
+
+	return (void *)array - (void *)start;
+}
+
 int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
 				    struct evlist *evlist, struct machine *machine)
 {
diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
index 78a0450db164..b136ec3ec95d 100644
--- a/tools/perf/util/synthetic-events.h
+++ b/tools/perf/util/synthetic-events.h
@@ -55,6 +55,7 @@ int perf_event__synthesize_extra_attr(struct perf_tool *tool, struct evlist *evs
 int perf_event__synthesize_extra_kmaps(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_features(struct perf_tool *tool, struct perf_session *session, struct evlist *evlist, perf_event__handler_t process);
 int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine);
+int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
 int perf_event__synthesize_mmap_events(struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine, bool mmap_data);
 int perf_event__synthesize_modules(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
-- 
2.25.1

