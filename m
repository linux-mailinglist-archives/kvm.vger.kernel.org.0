Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A8A56FE6B
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiGKKLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiGKKKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E83D78201;
        Mon, 11 Jul 2022 02:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531992; x=1689067992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7kb4HBudqHsXBA4pBL5EI6hzUy1OLVfysrxe1GNe/1g=;
  b=Y7Z/9T5coS/cJ6q9ht1SH6Ou98Jc0rvizrC8tbkQLIb9GV8RTg26n+FG
   Vu0ppSsZ4q3xKEMnGJN5KA0wBB3n3l1OEEo8y0BZWjA5ybJnCMZMougGD
   fkTJBGDIx6c7dyyGs3RIyrOvSMURnd+6p/nEYPXF/RAnZcnOggRyM+BVm
   as1bjkGGKQ00AoJGpQqzdRkrA0RPpDoh5hZdYw6hhc2RlADSY5yiuOtBD
   vV5lUNCvz84x8yBj5fu9wAmAx2Z2adW6eVyiRoYOpICvFJxwy5aml49g2
   hqOz+7fEt3NtGSWcBkSmK4MQv5j2cjtB0SSlwreBgMZOczVLhS6ZtD/Dh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371570"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371570"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387093"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:10 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 13/35] perf tools: Add machine_pid and vcpu to perf_sample
Date:   Mon, 11 Jul 2022 12:31:56 +0300
Message-Id: <20220711093218.10967-14-adrian.hunter@intel.com>
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

When parsing a sample with a sample ID, copy machine_pid and vcpu from
perf_sample_id to perf_sample.

Note, machine_pid will be zero when unused, so only a non-zero value
represents a guest machine. vcpu should be ignored if machine_pid is zero.

Note also, machine_pid is used with events that have come from injecting a
guest perf.data file, however guest events recorded on the host (i.e. using
perf kvm) have the (QEMU) hypervisor process pid to identify them - refer
machines__find_for_cpumode().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.h  |  2 ++
 tools/perf/util/evlist.c | 14 +++++++++++++-
 tools/perf/util/evsel.c  |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cdd72e05fd28..a660f304f83c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -148,6 +148,8 @@ struct perf_sample {
 	u64 code_page_size;
 	u64 cgroup;
 	u32 flags;
+	u32 machine_pid;
+	u32 vcpu;
 	u16 insn_len;
 	u8  cpumode;
 	u16 misc;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 03fbe151b0c4..64f5a8074c0c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1507,10 +1507,22 @@ int evlist__start_workload(struct evlist *evlist)
 int evlist__parse_sample(struct evlist *evlist, union perf_event *event, struct perf_sample *sample)
 {
 	struct evsel *evsel = evlist__event2evsel(evlist, event);
+	int ret;
 
 	if (!evsel)
 		return -EFAULT;
-	return evsel__parse_sample(evsel, event, sample);
+	ret = evsel__parse_sample(evsel, event, sample);
+	if (ret)
+		return ret;
+	if (perf_guest && sample->id) {
+		struct perf_sample_id *sid = evlist__id2sid(evlist, sample->id);
+
+		if (sid) {
+			sample->machine_pid = sid->machine_pid;
+			sample->vcpu = sid->vcpu.cpu;
+		}
+	}
+	return 0;
 }
 
 int evlist__parse_sample_timestamp(struct evlist *evlist, union perf_event *event, u64 *timestamp)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9a30ccb7b104..14396ea5a968 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2365,6 +2365,7 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 	data->misc    = event->header.misc;
 	data->id = -1ULL;
 	data->data_src = PERF_MEM_DATA_SRC_NONE;
+	data->vcpu = -1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->core.attr.sample_id_all)
-- 
2.25.1

