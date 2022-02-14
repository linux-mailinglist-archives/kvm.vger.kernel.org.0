Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975AD4B4E95
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351508AbiBNLaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351383AbiBNL3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2098919C2B;
        Mon, 14 Feb 2022 03:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836970; x=1676372970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NlMzKT33h6Q6qqc7z4CyhD39p7yWH93N/HDO0fmlpcU=;
  b=iPNJTWY/tKPy+8PQ8JLCuRhe39Pd9kzn0PU9HFTSkEAZRYkyYTZglB5t
   0/A1bZZ8joXfKMqxd8dxs6LGoYAZYrQdADmkyv8By7YGG+7LkIhrgJGFQ
   nqIUXACFsIE4xCuugMqvQrxaJhfyBPjdZPyx9LfG8/QRZhRM8A20iI26k
   4V65qv1zW7F3lAfnjdJZzzHj4iXpdKTCf5aD6pjElT5YRjSety4hnBVeY
   dOiqLFL+R2JmUzFeW+PuRL8F1PJ4gqwxEKbw3YrgsEguMlDec5YugLmx8
   m6jtQhpLdR9oinEHmAuKbyO427H1jyd2fOKn4RkQAiMImQgOPT/H5BY4u
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="247662669"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="247662669"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103214"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:22 -0800
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
Subject: [PATCH V2 01/11] perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
Date:   Mon, 14 Feb 2022 13:09:04 +0200
Message-Id: <20220214110914.268126-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

native_perf_sched_clock_from_tsc() is used to produce a time value that can
be consistent with perf_clock().  Consequently, it should be adjusted by
__sched_clock_offset, the same as perf_clock() would be.

Fixes: 698eff6355f735 ("sched/clock, x86/perf: Fix perf test tsc")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a698196377be..d9fe277c2471 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -242,7 +242,7 @@ u64 native_sched_clock(void)
  */
 u64 native_sched_clock_from_tsc(u64 tsc)
 {
-	return cycles_2_ns(tsc);
+	return cycles_2_ns(tsc) + __sched_clock_offset;
 }
 
 /* We need to define a real function for sched_clock, to override the
-- 
2.25.1

