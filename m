Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284A94CF411
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiCGIy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiCGIyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:50 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BF917E3E;
        Mon,  7 Mar 2022 00:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643226; x=1678179226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tK8YcYd3WE7o/03bsGHBPo57y7a9U/7AOoyubu+SryY=;
  b=MxrprauOUedSCA40Mute6pgkDIUcz4urAo1ttjt3x4Q8ui+mLTwzNbWD
   d+4XETTJ8PNSsdhnQ0WKkJxJCJsQL5Pj3eRvEuIb+fmashYjgzOlVt4yt
   EcB8I0So3oMGtnb6+K61akK9OLVXNJqYiVZkEqpM6ADDq5NcKmRznhbU0
   Hc+aQJuEkLHMQa/W34wmnpyHR6owfVC3Xc8mbWGnIE3uKuo3IfFNenljU
   YKbczfP0c/B7/LkyzWUqOTupaylcMDBvW5btzS4dNTktzT/CMTVn8+L3U
   fj3oIEUwwBc0GwwKrttOuXuIdNywoGj0l2CMIjy9mjlfPVek4DZMkngcJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771860"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771860"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033595"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:42 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH V3 07/10] perf tools: Add perf_read_tsc_conv_for_clockid()
Date:   Mon,  7 Mar 2022 10:53:09 +0200
Message-Id: <20220307085312.1814506-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307085312.1814506-1-adrian.hunter@intel.com>
References: <20220307085312.1814506-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function to read TSC conversion information for a particular clock
ID. It will be used in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/tsc.c | 56 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/tsc.h |  1 +
 2 files changed, 57 insertions(+)

diff --git a/tools/perf/util/tsc.c b/tools/perf/util/tsc.c
index f19791d46e99..92ae0e75c749 100644
--- a/tools/perf/util/tsc.c
+++ b/tools/perf/util/tsc.c
@@ -3,6 +3,8 @@
 #include <inttypes.h>
 #include <string.h>
 
+#include <sys/mman.h>
+
 #include <linux/compiler.h>
 #include <linux/perf_event.h>
 #include <linux/stddef.h>
@@ -14,6 +16,9 @@
 #include "synthetic-events.h"
 #include "debug.h"
 #include "tsc.h"
+#include "cpumap.h"
+#include "perf-sys.h"
+#include <internal/lib.h> /* page_size */
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
 {
@@ -71,6 +76,57 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 	return 0;
 }
 
+static int perf_read_tsc_conv_attr_cpu(struct perf_event_attr *attr,
+				       struct perf_cpu cpu,
+				       struct perf_tsc_conversion *tc)
+{
+	size_t len = 2 * page_size;
+	int fd, err = -EINVAL;
+	void *addr;
+
+	fd = sys_perf_event_open(attr, 0, cpu.cpu, -1, 0);
+	if (fd == -1)
+		return -EINVAL;
+
+	addr = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED)
+		goto out_close;
+
+	err = perf_read_tsc_conversion(addr, tc);
+
+	munmap(addr, len);
+out_close:
+	close(fd);
+	return err;
+}
+
+static struct perf_cpu find_a_cpu(void)
+{
+	struct perf_cpu_map *cpus;
+	struct perf_cpu cpu = { .cpu = 0 };
+
+	cpus = perf_cpu_map__new(NULL);
+	if (!cpus)
+		return cpu;
+	cpu = cpus->map[0];
+	perf_cpu_map__put(cpus);
+	return cpu;
+}
+
+int perf_read_tsc_conv_for_clockid(s32 clockid, struct perf_tsc_conversion *tc)
+{
+	struct perf_event_attr attr = {
+		.size		= sizeof(attr),
+		.type		= PERF_TYPE_SOFTWARE,
+		.config		= PERF_COUNT_SW_DUMMY,
+		.exclude_kernel	= 1,
+		.use_clockid	= 1,
+		.clockid	= clockid,
+	};
+
+	return perf_read_tsc_conv_attr_cpu(&attr, find_a_cpu(), tc);
+}
+
 int perf_event__synth_time_conv(const struct perf_event_mmap_page *pc,
 				struct perf_tool *tool,
 				perf_event__handler_t process,
diff --git a/tools/perf/util/tsc.h b/tools/perf/util/tsc.h
index 7d83a31732a7..ba9a52a9d70f 100644
--- a/tools/perf/util/tsc.h
+++ b/tools/perf/util/tsc.h
@@ -21,6 +21,7 @@ struct perf_event_mmap_page;
 
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc);
+int perf_read_tsc_conv_for_clockid(s32 clockid, struct perf_tsc_conversion *tc);
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
 u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
-- 
2.25.1

