Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7E94AED42
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 09:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiBIIxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 03:53:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240072AbiBIIxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 03:53:05 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEB5DF48F3D;
        Wed,  9 Feb 2022 00:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644396780; x=1675932780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miD0Yf9C+MQxqIFghTdlVvKVbagPjG3BXOKwIH4J4CM=;
  b=nUv1FqocQ81NKMPgW55BTvWZ9k3LEx0TAEUC2b4bW4sDaDHQpcYnm/p6
   pY4a2RBr5Hm92t9ZOJyfYEmHx1PQbENY5lPhhHf/B2obcA8yC4v0ocepV
   wcea2VHcfC93hAC+l9uyilzCshwm+KYQfMxmnDmWSfsdq78keT5Nmxpn7
   pgILqXpbrAqSCRaptQPsfMi/rLb9/52+rDaADinpgcwD2cXf5NtmltJpE
   V73x63eX+EREn7Kzw0JcDcLX8yl1E+7mDNeqByKx2HITaLdTdgeUydQEn
   elbyZNd9DP/22mWDXElDTkZXaOZOYsCu3ZkXHbSkljhYxoQ7/HDmi9YTZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="309903054"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="309903054"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:50:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169401"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:50:09 -0800
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
Subject: [PATCH 09/11] perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
Date:   Wed,  9 Feb 2022 10:49:27 +0200
Message-Id: <20220209084929.54331-10-adrian.hunter@intel.com>
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

Make CLOCK_PERF_HW_CLOCK_NS the default for Intel PT if it is supported.
To allow that to be overridden, support also --no-clockid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/intel-pt.c | 5 +++++
 tools/perf/util/clockid.c           | 1 +
 tools/perf/util/record.h            | 1 +
 3 files changed, 7 insertions(+)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index ce5dc70e392a..d5cdc53471ff 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -926,6 +926,11 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 		evsel__reset_sample_bit(tracking_evsel, BRANCH_STACK);
 	}
 
+	if (!opts->use_clockid && !opts->no_clockid && perf_can_perf_clock_hw_clock_ns()) {
+		opts->use_clockid = true;
+		opts->clockid = CLOCK_PERF_HW_CLOCK_NS;
+	}
+
 	/*
 	 * Warn the user when we do not have enough information to decode i.e.
 	 * per-cpu with no sched_switch (except workload-only).
diff --git a/tools/perf/util/clockid.c b/tools/perf/util/clockid.c
index 380429725df1..e3500a254103 100644
--- a/tools/perf/util/clockid.c
+++ b/tools/perf/util/clockid.c
@@ -78,6 +78,7 @@ int parse_clockid(const struct option *opt, const char *str, int unset)
 
 	if (unset) {
 		opts->use_clockid = 0;
+		opts->no_clockid = true;
 		return 0;
 	}
 
diff --git a/tools/perf/util/record.h b/tools/perf/util/record.h
index ef6c2715fdd9..20bcd4310146 100644
--- a/tools/perf/util/record.h
+++ b/tools/perf/util/record.h
@@ -67,6 +67,7 @@ struct record_opts {
 	bool	      sample_transaction;
 	int	      initial_delay;
 	bool	      use_clockid;
+	bool	      no_clockid;
 	clockid_t     clockid;
 	u64	      clockid_res_ns;
 	int	      nr_cblocks;
-- 
2.25.1

