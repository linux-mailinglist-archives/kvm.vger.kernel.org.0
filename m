Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528E856FE5F
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiGKKLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiGKKKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8635774A0;
        Mon, 11 Jul 2022 02:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531980; x=1689067980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uvOjO7SAHwYws30A/h/vjMwuhgOCudN5JHVzUoXQMg4=;
  b=Gi+hAIKSqFs6s3AUVq2CnmqjnyZavA+tlOqGMLzwwQRFed2g7l6kgx2B
   /zldkF5Xo5+wpwhY+FS8KHmnMld2ygIFg32Jzlm/L2FMh1YiLkBdTnoqM
   BMXRfNE/fRfk765FVQhspe4pp0sd4vbTAOJOf8hdvq02ySjfRf1AbUBR6
   lno6n6JDBs69y1kKXLd4WJDsJySohKfRjMuf9LQNEeaJWRSDba2d9s7Nj
   tzdmUxL3xaLlr+LBQs/hddK/UsQrwBjJ829zAzktjwqvNWBNvAl6sB9uF
   xkyoxNSzgC1vUAkRV8ewj9qdK5I5hFv9DtvVaSUtXhUYbFW4lyPHwEPhd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371544"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371544"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387035"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:56 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 07/35] perf script: Add --dump-unsorted-raw-trace option
Date:   Mon, 11 Jul 2022 12:31:50 +0300
Message-Id: <20220711093218.10967-8-adrian.hunter@intel.com>
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

When reviewing the results of perf inject, it is useful to be able to see
the events in the order they appear in the file.

So add --dump-unsorted-raw-trace option to do an unsorted dump.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt | 3 +++
 tools/perf/builtin-script.c              | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 1a557ff8f210..e250ff5566cf 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -79,6 +79,9 @@ OPTIONS
 --dump-raw-trace=::
         Display verbose dump of the trace data.
 
+--dump-unsorted-raw-trace=::
+        Same as --dump-raw-trace but not sorted in time order.
+
 -L::
 --Latency=::
         Show latency attributes (irqs/preemption disabled, etc).
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7cf21ab16f4f..4b00a50faf00 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3746,6 +3746,7 @@ int cmd_script(int argc, const char **argv)
 	bool header = false;
 	bool header_only = false;
 	bool script_started = false;
+	bool unsorted_dump = false;
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
@@ -3794,6 +3795,8 @@ int cmd_script(int argc, const char **argv)
 	const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "dump-unsorted-raw-trace", &unsorted_dump,
+		    "dump unsorted raw trace in ASCII"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('L', "Latency", &latency_format,
@@ -3956,6 +3959,11 @@ int cmd_script(int argc, const char **argv)
 	data.path  = input_name;
 	data.force = symbol_conf.force;
 
+	if (unsorted_dump) {
+		dump_trace = true;
+		script.tool.ordered_events = false;
+	}
+
 	if (symbol__validate_sym_arguments())
 		return -1;
 
-- 
2.25.1

