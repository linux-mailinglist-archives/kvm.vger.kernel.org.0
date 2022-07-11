Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7033C56FE7B
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiGKKMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiGKKLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:11:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6024BDEAE;
        Mon, 11 Jul 2022 02:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532020; x=1689068020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pgd6eg3rwjK89yXrGs71hxRXZOcNGoFUVN/EP5zdtf0=;
  b=c2yyH9h/Ph3r4c8DROmuooHXmCuaRJRATPnNL1ZWWPqepOLhnXi9bPUh
   lRmlH2DJCLBEZW+h8HZ2MKdANNFaDQsvIMemx1TVmSENDgxcdFT3MQN63
   VOnhbXqSPmWJjVLoN70QWt6BnCamitumg2LzWfyG0eIY1U7v5moLvlMz2
   ExQWhnXQw57ISC8Xsgc/lembsxNKrXUnR7etz/CHyeDu6qkySkBlk7VAK
   bMmP6QIn0c5UiH8r9vnUhesGSdMTL5xW3n0JkrkaweVG0qGnKLwE7zm/9
   u5h19TX+QB4s9kvR1rWUbMU6zXCgRRQcAvyTHchd6H2NQwhcrPANa47iL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371606"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371606"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387146"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:22 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 18/35] perf script python: Add machine_pid and vcpu
Date:   Mon, 11 Jul 2022 12:32:01 +0300
Message-Id: <20220711093218.10967-19-adrian.hunter@intel.com>
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

Add machine_pid and vcpu to python sample events and context switch events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 .../perf/util/scripting-engines/trace-event-python.c  | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 3367c5479199..5bbc1b16f368 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -861,6 +861,13 @@ static PyObject *get_perf_sample_dict(struct perf_sample *sample,
 	brstacksym = python_process_brstacksym(sample, al->thread);
 	pydict_set_item_string_decref(dict, "brstacksym", brstacksym);
 
+	if (sample->machine_pid) {
+		pydict_set_item_string_decref(dict_sample, "machine_pid",
+				_PyLong_FromLong(sample->machine_pid));
+		pydict_set_item_string_decref(dict_sample, "vcpu",
+				_PyLong_FromLong(sample->vcpu));
+	}
+
 	pydict_set_item_string_decref(dict_sample, "cpumode",
 			_PyLong_FromLong((unsigned long)sample->cpumode));
 
@@ -1509,7 +1516,7 @@ static void python_do_process_switch(union perf_event *event,
 		np_tid = event->context_switch.next_prev_tid;
 	}
 
-	t = tuple_new(9);
+	t = tuple_new(11);
 	if (!t)
 		return;
 
@@ -1522,6 +1529,8 @@ static void python_do_process_switch(union perf_event *event,
 	tuple_set_s32(t, 6, machine->pid);
 	tuple_set_bool(t, 7, out);
 	tuple_set_bool(t, 8, out_preempt);
+	tuple_set_s32(t, 9, sample->machine_pid);
+	tuple_set_s32(t, 10, sample->vcpu);
 
 	call_object(handler, t, handler_name);
 
-- 
2.25.1

