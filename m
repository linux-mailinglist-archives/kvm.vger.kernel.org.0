Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626456FE67
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiGKKLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiGKKK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE11C7821D;
        Mon, 11 Jul 2022 02:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531987; x=1689067987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LHhcnJuSuRIWLt7apSo+PbscteJazX7X8zRWVqb3Jk=;
  b=HOrOcqJFdX3pN7Svbg6HcD38YEZsPkEogswp/oUmjQ/DQqMky4o1fe+g
   g2mL6XWL2GwjOTfbzNzPx/vf9koAjx/rIc3V80eElqJPMncZc4byxNDpx
   M+Tq8R9b9WrVEMjlUzuK7ASZgDRv8Fewj3gMleBZ3nb4x6MTma3bcLMRY
   wiMTE08jsFKc56mQFw1ZQS+juERU9ao7aExoYTIxcuKZELQB8TNFEt/fD
   pHp/7LdshzRoPBoKw+QZy/0DNI7JlUy4vRK6iO7skqL0u4l25+bL15tnC
   T241i2vApWh6VKlEBRSfCiPBL40tQqyEBxg/wUmjk4T1eqFI1d0IsDDxw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371564"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371564"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387065"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:05 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 11/35] perf session: Create guest machines from id_index
Date:   Mon, 11 Jul 2022 12:31:54 +0300
Message-Id: <20220711093218.10967-12-adrian.hunter@intel.com>
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

Now that id_index has machine_pid, use it to create guest machines.
Create the guest machines with an idle thread because guest events
for "swapper" will be possible.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5141fe164e97..1af981d5ad3c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2751,6 +2751,24 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 	fprintf(fp, "# ========\n#\n");
 }
 
+static int perf_session__register_guest(struct perf_session *session, pid_t machine_pid)
+{
+	struct machine *machine = machines__findnew(&session->machines, machine_pid);
+	struct thread *thread;
+
+	if (!machine)
+		return -ENOMEM;
+
+	machine->single_address_space = session->machines.host.single_address_space;
+
+	thread = machine__idle_thread(machine);
+	if (!thread)
+		return -ENOMEM;
+	thread__put(thread);
+
+	return 0;
+}
+
 int perf_event__process_id_index(struct perf_session *session,
 				 union perf_event *event)
 {
@@ -2762,6 +2780,7 @@ int perf_event__process_id_index(struct perf_session *session,
 	size_t e2_sz = sizeof(struct id_index_entry_2);
 	size_t etot_sz = e1_sz + e2_sz;
 	struct id_index_entry_2 *e2;
+	pid_t last_pid = 0;
 
 	max_nr = sz / e1_sz;
 	nr = ie->nr;
@@ -2787,6 +2806,7 @@ int perf_event__process_id_index(struct perf_session *session,
 	for (i = 0; i < nr; i++, (e2 ? e2++ : 0)) {
 		struct id_index_entry *e = &ie->entries[i];
 		struct perf_sample_id *sid;
+		int ret;
 
 		if (dump_trace) {
 			fprintf(stdout,	" ... id: %"PRI_lu64, e->id);
@@ -2814,6 +2834,17 @@ int perf_event__process_id_index(struct perf_session *session,
 
 		sid->machine_pid = e2->machine_pid;
 		sid->vcpu.cpu = e2->vcpu;
+
+		if (!sid->machine_pid)
+			continue;
+
+		if (sid->machine_pid != last_pid) {
+			ret = perf_session__register_guest(session, sid->machine_pid);
+			if (ret)
+				return ret;
+			last_pid = sid->machine_pid;
+			perf_guest = true;
+		}
 	}
 	return 0;
 }
-- 
2.25.1

