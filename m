Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16104AF075
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiBIL7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbiBIL5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:57:52 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36491E00FED8;
        Wed,  9 Feb 2022 03:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404429; x=1675940429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BRMP6Uo4uFbPv2FKo1aqyoKoVbyJUj8pdBISKbB0UIU=;
  b=Qu8WFE0elgPxYW8h6dTZY6XvqQnPkDirDJjgBE52FqenZGYfwwGlZqt0
   YXzm5sEmdAkGFjJk470ifmiAq5h1Riqnxvb1/O+nUG0R6wVtEw6cTOsA3
   4K9zy2W3H7ekDn2qrAt1GOYSYahqosWOTA6tDF9cDqY2H/2Kr3X22YxG7
   4EzhUfrlLoqGDHiBbPb298mWGTQWxV4eml8bTS2uV7DINl6KgoPwfALr+
   S0rx2p95I+t6eP337i1DMHB1PKJ90htsxPbV5MnDlNJs8Av8WourmAfNK
   PgRlohKpqhv2MNbIuPRtnejBkE/gFe8f3JwrA4FJ334xo+f7uqR6d/07g
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="247992184"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="247992184"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169190"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:34 -0800
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
Subject: [PATCH 01/11] perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
Date:   Wed,  9 Feb 2022 10:49:19 +0200
Message-Id: <20220209084929.54331-2-adrian.hunter@intel.com>
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

native_perf_sched_clock_from_tsc() is used to produce a time value that can
be consistent with perf_clock().  Consequently, it should be adjusted by
__sched_clock_offset, the same as perf_clock() would be.

Fixes: 698eff6355f735 ("sched/clock, x86/perf: Fix perf test tsc")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kernel/tsc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a698196377be..c1c73fe324cd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -242,7 +242,8 @@ u64 native_sched_clock(void)
  */
 u64 native_sched_clock_from_tsc(u64 tsc)
 {
-	return cycles_2_ns(tsc);
+	return cycles_2_ns(tsc) +
+	       (sched_clock_stable() ? __sched_clock_offset : 0);
 }
 
 /* We need to define a real function for sched_clock, to override the
-- 
2.25.1

