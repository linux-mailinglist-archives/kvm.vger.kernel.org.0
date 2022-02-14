Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47C34B4E6A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351726AbiBNLaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351596AbiBNLaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:04 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF33F33B;
        Mon, 14 Feb 2022 03:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837033; x=1676373033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MumzNFerN8Kg+a86MQl5JClrAkhxHBuOsiVbGau8KNY=;
  b=BgLPP79MdUOy5fuh8CTAWuqG6oNLUk9W6tYaAcgHNbtAp2pkDnAkHWJi
   X3X1v+1AXiOqyZwk/3MawJSwIpcbLjvj0/J20/kBXNOdW8giyhxU9IPIk
   cwZJRtlEPXwfCUKbFVUe2NJejcnHO4oiId83Whp2h8jqeZpgGx3n17YUE
   Nas/qjCepXz8Xyo0Lr4krk2COWT6vDJ3494MsVmO3g4MkS4FWG7CSRuJ3
   PmZ7wLjnOOa5Iw0kTGKVPnO7RQ6PGExkC8NEE6h0PhUMzlKLtQtNbH9Xg
   XfV5CqBDsH5Dp662JzDrGEwXWvR4XcrgUhI4MZXl7onEAb3uh7RrqSxC9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="274639453"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="274639453"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103714"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:10:05 -0800
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
Subject: [PATCH V2 07/11] perf tools: Add perf_read_tsc_conv_for_clockid()
Date:   Mon, 14 Feb 2022 13:09:10 +0200
Message-Id: <20220214110914.268126-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 tools/perf/util/tsc.c | 58 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/tsc.h |  2 ++
 2 files changed, 60 insertions(+)

diff --git a/tools/perf/util/tsc.c b/tools/perf/util/tsc.c
index f19791d46e99..0bcedaa5fa5d 100644
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
@@ -71,6 +76,59 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
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
+int perf_read_tsc_conv_for_clockid(s32 clockid, bool ns_clock,
+				   struct perf_tsc_conversion *tc)
+{
+	struct perf_event_attr attr = {
+		.size		= sizeof(attr),
+		.type		= PERF_TYPE_SOFTWARE,
+		.config		= PERF_COUNT_SW_DUMMY,
+		.exclude_kernel	= 1,
+		.use_clockid	= 1,
+		.ns_clockid	= ns_clock,
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
index 7d83a31732a7..af3f9e6a1beb 100644
--- a/tools/perf/util/tsc.h
+++ b/tools/perf/util/tsc.h
@@ -21,6 +21,8 @@ struct perf_event_mmap_page;
 
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc);
+int perf_read_tsc_conv_for_clockid(s32 clockid, bool ns_clockid,
+				   struct perf_tsc_conversion *tc);
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
 u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
-- 
2.25.1

