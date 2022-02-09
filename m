Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC14AED36
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbiBIIww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 03:52:52 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbiBIIwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 03:52:51 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247E1DF48F17;
        Wed,  9 Feb 2022 00:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644396765; x=1675932765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UvkvAiHghoxYj3prOUwWIM8u+bIgeXtt/bvpfm45/LY=;
  b=Xiq8amNxyLkMLnanRTAffBrNuBPe1mc0IZT9sfuZyRsaHwIoO9qc3yKT
   Q+0XwZW6TnCU0SY7yCcuWm1hlybeVhGx5od/s1YWNU39W1JYDf/08PfC1
   zXoQyJLyasHEvIeDO/Y+CenZVi4JklRKUu1D5K+yGJUEo01R78QsBQt2Y
   Bk2gT5VH8MaG+iC25SkR85Apv+Gns5OqLc/p9KXMdxUkhZcdHb75RgFk7
   BwKXqlehXBxi8qn8P+0yd60lB0Yi2np9LoKjzXIALSEjdyxfSIBaSp6BE
   qDXSZZnXt/2QwfLThu+H5QHwWFV9hHRcivcAd8cdZOdeildA4+GwMTpW5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="309903006"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="309903006"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:50:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169321"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:50:00 -0800
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
Subject: [PATCH 07/11] perf tools: Add perf_read_tsc_conv_for_clockid()
Date:   Wed,  9 Feb 2022 10:49:25 +0200
Message-Id: <20220209084929.54331-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209084929.54331-1-adrian.hunter@intel.com>
References: <20220209084929.54331-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index f19791d46e99..175a6e43ad94 100644
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
 
+static int perf_read_tsc_conv_attr_cpu(struct perf_event_attr *attr, int cpu,
+				       struct perf_tsc_conversion *tc)
+{
+	size_t len = 2 * page_size;
+	int fd, err = -EINVAL;
+	void *addr;
+
+	fd = sys_perf_event_open(attr, 0, cpu, -1, 0);
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
+static int find_a_cpu(void)
+{
+	struct perf_cpu_map *cpus;
+	int cpu;
+
+	cpus = perf_cpu_map__new(NULL);
+	if (!cpus)
+		return 0;
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
+	int cpu = find_a_cpu();
+
+	return perf_read_tsc_conv_attr_cpu(&attr, cpu, tc);
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

