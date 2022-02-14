Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552734B4E88
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351270AbiBNLaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351594AbiBNLaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBFE3F33A;
        Mon, 14 Feb 2022 03:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837031; x=1676373031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d4gqQmFd8HKigRRVK6Ipw7DFq3XyjtHucg7QwMwyDq8=;
  b=XKC0D+i5xXBw+oc6ikO1bgGA+HLCmskZmKMczpJPLno4K+BZV/75Kj+K
   nQtyU8lx6Wy6FzhifjOErX+OlKbM+yX6fTXHYGhdsiTJke/kMrKaQJwo8
   284VATYxL93wd+MwhAo/hkQxde3ey5YJLFMGzijWUqbuJEd5Bz9CLRRN8
   zbyfeJzczCjjDOWb5aWp+i1afum9B3P0UW0SF7SQbUXCn7XukKzvd6OLX
   d9iWHvc2zb+u6DUbh0APoMcD4ogMN0AuXtULQDqNM31rJmXE3F3z6kuq6
   BGVLGlV/E6lNKN6k3UzLs4lozggHUwVZtVWqN1hU5Rycy44u0p4SAcFTl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="313347292"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="313347292"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103812"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:10:18 -0800
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
Subject: [PATCH V2 09/11] perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
Date:   Mon, 14 Feb 2022 13:09:12 +0200
Message-Id: <20220214110914.268126-10-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make CLOCK_PERF_HW_CLOCK_NS the default for Intel PT if it is supported.
To allow that to be overridden, support also --no-clockid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/intel-pt.c | 6 ++++++
 tools/perf/util/clockid.c           | 1 +
 tools/perf/util/record.h            | 1 +
 3 files changed, 8 insertions(+)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 5424c42337e7..bba55b6f75b6 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -927,6 +927,12 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 		evsel__reset_sample_bit(tracking_evsel, BRANCH_STACK);
 	}
 
+	if (!opts->use_clockid && !opts->no_clockid && perf_can_perf_clock_hw_clock_ns()) {
+		opts->use_clockid = true;
+		opts->ns_clockid = true;
+		opts->clockid = CLOCK_PERF_HW_CLOCK_NS;
+	}
+
 	/*
 	 * Warn the user when we do not have enough information to decode i.e.
 	 * per-cpu with no sched_switch (except workload-only).
diff --git a/tools/perf/util/clockid.c b/tools/perf/util/clockid.c
index 2fcffee690e1..f9c0200e1ec2 100644
--- a/tools/perf/util/clockid.c
+++ b/tools/perf/util/clockid.c
@@ -81,6 +81,7 @@ int parse_clockid(const struct option *opt, const char *str, int unset)
 
 	if (unset) {
 		opts->use_clockid = 0;
+		opts->no_clockid = true;
 		return 0;
 	}
 
diff --git a/tools/perf/util/record.h b/tools/perf/util/record.h
index 1dbbf6b314dc..9a1dabfd158b 100644
--- a/tools/perf/util/record.h
+++ b/tools/perf/util/record.h
@@ -68,6 +68,7 @@ struct record_opts {
 	int	      initial_delay;
 	bool	      use_clockid;
 	bool	      ns_clockid;
+	bool	      no_clockid;
 	clockid_t     clockid;
 	u64	      clockid_res_ns;
 	int	      nr_cblocks;
-- 
2.25.1

