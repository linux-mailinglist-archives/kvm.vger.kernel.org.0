Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903E456FE55
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiGKKKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiGKKKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B199F4332D;
        Mon, 11 Jul 2022 02:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531971; x=1689067971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RBbXX7qaIoqHIXjBzFEPU7bF82bk5P3sOeLB5375eY0=;
  b=LjfQbfI9xQWDxL3UJE4wQL2GY8W2K8Zl+4WgUW2l0EtmAkjOtVfdlvG4
   nJUopmcXSlkqgbrKo+nrRroRGzWx5CZkTFUeo7Ek1bYHMlZ5TfFA++c3W
   mQpMVwN8gRBe6hb3kaSi/de+a7nwkeGcsWx/fqA8nfk+QYPf6+wCkTWRB
   96nfPllBX0UHVQsLchNa67Rtyzbp5baO3V3bXAmv0REVjfbhXcsOonR5f
   q1abbpXIqKlMrBhHkzqo2Uigzo++raU+ik6xgarirmKGBOFCInaJ6pben
   Pm3fkIx4JiH17FQ1sJ1miBikUKPNdUe3t2MJUOykVLiv+L1K3ZUpj1Ufw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371529"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371529"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387021"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:49 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 04/35] perf tools: Export perf_event__process_finished_round()
Date:   Mon, 11 Jul 2022 12:31:47 +0300
Message-Id: <20220711093218.10967-5-adrian.hunter@intel.com>
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

Export perf_event__process_finished_round() so it can be used elsewhere.

This is needed in perf inject to obey finished-round ordering.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 12 ++++--------
 tools/perf/util/session.h |  4 ++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 37f833c3c81b..4c9513bc6d89 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -374,10 +374,6 @@ static int process_finished_round_stub(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static int process_finished_round(struct perf_tool *tool,
-				  union perf_event *event,
-				  struct ordered_events *oe);
-
 static int skipn(int fd, off_t n)
 {
 	char buf[4096];
@@ -534,7 +530,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->build_id = process_event_op2_stub;
 	if (tool->finished_round == NULL) {
 		if (tool->ordered_events)
-			tool->finished_round = process_finished_round;
+			tool->finished_round = perf_event__process_finished_round;
 		else
 			tool->finished_round = process_finished_round_stub;
 	}
@@ -1069,9 +1065,9 @@ static perf_event__swap_op perf_event__swap_ops[] = {
  *      Flush every events below timestamp 7
  *      etc...
  */
-static int process_finished_round(struct perf_tool *tool __maybe_unused,
-				  union perf_event *event __maybe_unused,
-				  struct ordered_events *oe)
+int perf_event__process_finished_round(struct perf_tool *tool __maybe_unused,
+				       union perf_event *event __maybe_unused,
+				       struct ordered_events *oe)
 {
 	if (dump_trace)
 		fprintf(stdout, "\n");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 34500a3da735..be5871ea558f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -155,4 +155,8 @@ int perf_session__deliver_synth_event(struct perf_session *session,
 int perf_event__process_id_index(struct perf_session *session,
 				 union perf_event *event);
 
+int perf_event__process_finished_round(struct perf_tool *tool,
+				       union perf_event *event,
+				       struct ordered_events *oe);
+
 #endif /* __PERF_SESSION_H */
-- 
2.25.1

