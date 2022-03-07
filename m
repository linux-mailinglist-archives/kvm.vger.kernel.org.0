Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787924CF404
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiCGIyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiCGIyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E6817E3E;
        Mon,  7 Mar 2022 00:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643201; x=1678179201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NlMzKT33h6Q6qqc7z4CyhD39p7yWH93N/HDO0fmlpcU=;
  b=B88QsVAbzPv7IhwKbPHn3PQbq+M5H0fJiV6f8h6G8RRw1dulhqgzpArr
   Cp2Bs/6GLd5x0+7AefmmWPHFUZLwVON3vNqLwc99WPDKGqw4kxzaDNHdv
   1LpIZty7/aFUjRuhBqhZ4WCaXHesZ8ukzzNqb6Atl5+cdQzgMWVH9e7bw
   MQog/UJ553gt3bIJTb/c4TOUhh6TokmK6EADHhlJLAshyJG0C6fQuYLFE
   NASOQrH9+RnPoobt/Ng4eY08R1/mJpdsA/g5+ENZ6emeKCYokGU3HaTBr
   JR2Ggvh4IOoTKdRjvFiPRxrBXfp2mHbXLjeALqrjcqwX5fMXna1RRGe9j
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771776"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771776"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033482"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:16 -0800
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
Subject: [PATCH V3 01/10] perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
Date:   Mon,  7 Mar 2022 10:53:03 +0200
Message-Id: <20220307085312.1814506-2-adrian.hunter@intel.com>
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

