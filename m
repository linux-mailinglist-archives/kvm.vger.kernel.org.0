Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6CB56FE57
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiGKKKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiGKKKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDEDBFAF9;
        Mon, 11 Jul 2022 02:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531974; x=1689067974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hL21TJrX9GOGzRml4dqgYs6puEA8/R32Vt5xw54wtNQ=;
  b=T0jdFu2+FTWBZ5BjSssisLx/JcH3g0YwW6OULzg0Ar/ONmkXy7Cmyntk
   YK3c24iwoTqcitNOztJ33JX+91lIjoTf9pCntI4HQFjr1yagS8BhLYQZf
   w7lNKC1k5EX7DFKywT7q8bbK1FbsOb17GSR1Lai9kLk5gEOf8ZUsJ7kHR
   J9rbezbfoJ5/9HBMT20zoRuUqBsUzpN5bfKr68ePrI3gVmPwsg9YpcFgB
   TkTdimvkrdK+SySGw9JK/nIeg584A8QSlqJp/QOslMbubSmqd/BSaR94e
   5EmjjQ9EGr8P9aj1EBUoHysx6zQ7DNb4i0FnRtjPZSAA4kTerrfM0Tj8+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371531"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371531"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387025"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:51 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 05/35] perf tools: Factor out evsel__id_hdr_size()
Date:   Mon, 11 Jul 2022 12:31:48 +0300
Message-Id: <20220711093218.10967-6-adrian.hunter@intel.com>
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

Factor out evsel__id_hdr_size() so it can be reused.

This is needed by perf inject. When injecting events from a guest perf.data
file, there is a possibility that the sample ID numbers conflict. To
re-write an ID sample, the old one needs to be removed first, which means
determining how big it is with evsel__id_hdr_size() and then subtracting
that from the event size.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 28 +---------------------------
 tools/perf/util/evsel.c  | 26 ++++++++++++++++++++++++++
 tools/perf/util/evsel.h  |  2 ++
 3 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 48af7d379d82..03fbe151b0c4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1244,34 +1244,8 @@ bool evlist__valid_read_format(struct evlist *evlist)
 u16 evlist__id_hdr_size(struct evlist *evlist)
 {
 	struct evsel *first = evlist__first(evlist);
-	struct perf_sample *data;
-	u64 sample_type;
-	u16 size = 0;
 
-	if (!first->core.attr.sample_id_all)
-		goto out;
-
-	sample_type = first->core.attr.sample_type;
-
-	if (sample_type & PERF_SAMPLE_TID)
-		size += sizeof(data->tid) * 2;
-
-       if (sample_type & PERF_SAMPLE_TIME)
-		size += sizeof(data->time);
-
-	if (sample_type & PERF_SAMPLE_ID)
-		size += sizeof(data->id);
-
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		size += sizeof(data->stream_id);
-
-	if (sample_type & PERF_SAMPLE_CPU)
-		size += sizeof(data->cpu) * 2;
-
-	if (sample_type & PERF_SAMPLE_IDENTIFIER)
-		size += sizeof(data->id);
-out:
-	return size;
+	return first->core.attr.sample_id_all ? evsel__id_hdr_size(first) : 0;
 }
 
 bool evlist__valid_sample_id_all(struct evlist *evlist)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a67cc3f2fa74..9a30ccb7b104 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2724,6 +2724,32 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
 	return 0;
 }
 
+u16 evsel__id_hdr_size(struct evsel *evsel)
+{
+	u64 sample_type = evsel->core.attr.sample_type;
+	u16 size = 0;
+
+	if (sample_type & PERF_SAMPLE_TID)
+		size += sizeof(u64);
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		size += sizeof(u64);
+
+	if (sample_type & PERF_SAMPLE_ID)
+		size += sizeof(u64);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		size += sizeof(u64);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		size += sizeof(u64);
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(u64);
+
+	return size;
+}
+
 struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
 {
 	return tep_find_field(evsel->tp_format, name);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 92bed8e2f7d8..699448f2bc2b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -381,6 +381,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
 				  u64 *timestamp);
 
+u16 evsel__id_hdr_size(struct evsel *evsel);
+
 static inline struct evsel *evsel__next(struct evsel *evsel)
 {
 	return list_entry(evsel->core.node.next, struct evsel, core.node);
-- 
2.25.1

