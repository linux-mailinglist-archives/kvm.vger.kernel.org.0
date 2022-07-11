Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8F556FE72
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiGKKLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbiGKKKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FF045079;
        Mon, 11 Jul 2022 02:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531999; x=1689067999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FqQdpjTqWQVvim+9bsHNS/QprUCFxf3kl2b4kFsDg9o=;
  b=AbDYK9dZ0g1uNm0PJz+J2mxyzE6+FJMYPYpoygMRhrr1KRpeFQj5T3pD
   ldH9mU5DyipKtb0M3j3yorME1So00mjGDscbFMcvcCFwutu2iB8PaBFrg
   SBMhgKajktK777lV9DrK/6CtLG1yqrk+hrVMD7cDnCo2HKd2NdUavDHNm
   aeTgHz6K5xW52O6HUyXh6xOy8f554TwsEr3KjWSzmgc6IM9G0XmLp7be0
   AwViWVG2SkayNPSe7fPABMg0LdWWArpilzek5be9ph2bjDnfeJZGv5lFY
   5L2PFTg0jINGUDXXupy6aumkFW3Q01M1Ph7ZEfScynkoOWGEtWPkB0/ke
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371590"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371590"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387121"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:17 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 16/35] perf dlfilter: Add machine_pid and vcpu
Date:   Mon, 11 Jul 2022 12:31:59 +0300
Message-Id: <20220711093218.10967-17-adrian.hunter@intel.com>
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

Add machine_pid and vcpu to struct perf_dlfilter_sample. The 'size' can be
used to determine if the values are present, however machine_pid is zero if
unused in any case. vcpu should be ignored if machine_pid is zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-dlfilter.txt | 22 ++++++++++++++++++++++
 tools/perf/include/perf/perf_dlfilter.h    |  8 ++++++++
 tools/perf/util/dlfilter.c                 |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/tools/perf/Documentation/perf-dlfilter.txt b/tools/perf/Documentation/perf-dlfilter.txt
index 594f5a5a0c9e..fb22e3b31dc5 100644
--- a/tools/perf/Documentation/perf-dlfilter.txt
+++ b/tools/perf/Documentation/perf-dlfilter.txt
@@ -107,9 +107,31 @@ struct perf_dlfilter_sample {
 	__u64 raw_callchain_nr;	/* Number of raw_callchain entries */
 	const __u64 *raw_callchain; /* Refer <linux/perf_event.h> */
 	const char *event;
+	__s32 machine_pid;
+	__s32 vcpu;
 };
 ----
 
+Note: 'machine_pid' and 'vcpu' are not original members, but were added together later.
+'size' can be used to determine their presence at run time.
+PERF_DLFILTER_HAS_MACHINE_PID will be defined if they are present at compile time.
+For example:
+[source,c]
+----
+#include <perf/perf_dlfilter.h>
+#include <stddef.h>
+#include <stdbool.h>
+
+static inline bool have_machine_pid(const struct perf_dlfilter_sample *sample)
+{
+#ifdef PERF_DLFILTER_HAS_MACHINE_PID
+	return sample->size >= offsetof(struct perf_dlfilter_sample, vcpu) + sizeof(sample->vcpu);
+#else
+	return false;
+#endif
+}
+----
+
 The perf_dlfilter_fns structure
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/tools/perf/include/perf/perf_dlfilter.h b/tools/perf/include/perf/perf_dlfilter.h
index 3eef03d661b4..a26e2f129f83 100644
--- a/tools/perf/include/perf/perf_dlfilter.h
+++ b/tools/perf/include/perf/perf_dlfilter.h
@@ -9,6 +9,12 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+/*
+ * The following macro can be used to determine if this header defines
+ * perf_dlfilter_sample machine_pid and vcpu.
+ */
+#define PERF_DLFILTER_HAS_MACHINE_PID
+
 /* Definitions for perf_dlfilter_sample flags */
 enum {
 	PERF_DLFILTER_FLAG_BRANCH	= 1ULL << 0,
@@ -62,6 +68,8 @@ struct perf_dlfilter_sample {
 	__u64 raw_callchain_nr;	/* Number of raw_callchain entries */
 	const __u64 *raw_callchain; /* Refer <linux/perf_event.h> */
 	const char *event;
+	__s32 machine_pid;
+	__s32 vcpu;
 };
 
 /*
diff --git a/tools/perf/util/dlfilter.c b/tools/perf/util/dlfilter.c
index db964d5a52af..54e4d4495e00 100644
--- a/tools/perf/util/dlfilter.c
+++ b/tools/perf/util/dlfilter.c
@@ -495,6 +495,8 @@ int dlfilter__do_filter_event(struct dlfilter *d,
 	ASSIGN(misc);
 	ASSIGN(raw_size);
 	ASSIGN(raw_data);
+	ASSIGN(machine_pid);
+	ASSIGN(vcpu);
 
 	if (sample->branch_stack) {
 		d_sample.brstack_nr = sample->branch_stack->nr;
-- 
2.25.1

