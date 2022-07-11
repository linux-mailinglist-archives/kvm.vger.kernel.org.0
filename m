Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CC756FE90
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiGKKOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiGKKNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:13:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670F7AB25;
        Mon, 11 Jul 2022 02:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532049; x=1689068049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qFecBToqxPSKhX0zdcfJpK2mfhemB/pJxqRd04ez+Uo=;
  b=Xe7HTDFE6nh9doK3cvsK71w51BXwn6MExs1UrnCIvjkpnwjXY1FDMYgF
   eskwqQR0UJU2u3SLeQ6ys2kmeGbxaR8WGlZFnBO1zTHr50zN2Fc0LfQm4
   NXi6Yx0h5qaGZO8WX5W88bIbd/GQrbbg8ryrKqwsF9luN23B21yY1/5kr
   QBkTB6TB2F5li+1gaBOFyrB61vXq9Mx0LAEeRD2veNbf5blV4NpSYIMd0
   6PIzUOIhLtGz6rUBFfKEMEtsY+RAZyzegxPrcUK6rLSx+ZeA7tpIntQ5B
   urRLiO6l9hLYMCOsEf+hBOYCRW8qUlX+g0gs8XCoLia+EgLUF7TKeL74Y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371704"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371704"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387259"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:48 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 29/35] perf intel-pt: Add some more logging to intel_pt_walk_next_insn()
Date:   Mon, 11 Jul 2022 12:32:12 +0300
Message-Id: <20220711093218.10967-30-adrian.hunter@intel.com>
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

To aid debugging, add some more logging to intel_pt_walk_next_insn().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 014f9f73cc49..a8798b5bb311 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -758,27 +758,38 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 
 	if (nr) {
 		if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
-		    intel_pt_get_guest(ptq))
+		    intel_pt_get_guest(ptq)) {
+			intel_pt_log("ERROR: no guest machine\n");
 			return -EINVAL;
+		}
 		machine = ptq->guest_machine;
 		thread = ptq->guest_thread;
 		if (!thread) {
-			if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL)
+			if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL) {
+				intel_pt_log("ERROR: no guest thread\n");
 				return -EINVAL;
+			}
 			thread = ptq->unknown_guest_thread;
 		}
 	} else {
 		thread = ptq->thread;
 		if (!thread) {
-			if (cpumode != PERF_RECORD_MISC_KERNEL)
+			if (cpumode != PERF_RECORD_MISC_KERNEL) {
+				intel_pt_log("ERROR: no thread\n");
 				return -EINVAL;
+			}
 			thread = ptq->pt->unknown_thread;
 		}
 	}
 
 	while (1) {
-		if (!thread__find_map(thread, cpumode, *ip, &al) || !al.map->dso)
+		if (!thread__find_map(thread, cpumode, *ip, &al) || !al.map->dso) {
+			if (al.map)
+				intel_pt_log("ERROR: thread has no dso for %#" PRIx64 "\n", *ip);
+			else
+				intel_pt_log("ERROR: thread has no map for %#" PRIx64 "\n", *ip);
 			return -EINVAL;
+		}
 
 		if (al.map->dso->data.status == DSO_DATA_STATUS_ERROR &&
 		    dso__data_status_seen(al.map->dso,
@@ -819,8 +830,12 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 			len = dso__data_read_offset(al.map->dso, machine,
 						    offset, buf,
 						    INTEL_PT_INSN_BUF_SZ);
-			if (len <= 0)
+			if (len <= 0) {
+				intel_pt_log("ERROR: failed to read at %" PRIu64 " ", offset);
+				if (intel_pt_enable_logging)
+					dso__fprintf(al.map->dso, intel_pt_log_fp());
 				return -EINVAL;
+			}
 
 			if (intel_pt_get_insn(buf, len, x86_64, intel_pt_insn))
 				return -EINVAL;
-- 
2.25.1

