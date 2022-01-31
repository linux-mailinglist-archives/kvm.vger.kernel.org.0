Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942B14A3E2D
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357974AbiAaHZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:25:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:60950 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357929AbiAaHZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613913; x=1675149913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7YiqLJH+Y+xZ0VB3H4HRhAWvsbIOgFigXzJmDCkkxus=;
  b=lriXpmMsAs/Nf8xjH+2M2v5r49HpYzBRsxjdgobXnOE9bJQFHkx00IUC
   iIBti2PYjyA6xxhtda/O87MB5THirPm5R3pbdv99Ypmb6I2Ws5vZyZjKp
   eVtIr8Yv+xubQAGUmwzTnKmlv1XmauH0rrFQQn3I9TKvgq8sCaQCX4loa
   4ajjtWz1RqRrBvHchgV2fngph/k9vLsaVb2lWMDxScV5HEHH/KIFRdB/v
   /ba1aSu9zchrKbPyL1riDIX806Hi6ElYTdlS4mxAedUUYYCn8lRCEqvGU
   Zt1L8/ouPyyw0aX73CrydNeJ7fsTj0baqocRnFdgxv7fee9N4vLMTprjc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367046"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367046"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:25:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515228"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:25:08 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 3/5] perf/core: Fix address filter parser for multiple filters
Date:   Mon, 31 Jan 2022 09:24:51 +0200
Message-Id: <20220131072453.2839535-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset appropriate variables in the parser loop between parsing separate
filters, so that they do not interfere with parsing the next filter.

Fixes: 375637bc524952 ("perf/core: Introduce address range filtering")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fc18664f49b0..af043a1a06ca 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10497,8 +10497,11 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 			}
 
 			/* ready to consume more filters */
+			kfree(filename);
+			filename = NULL;
 			state = IF_STATE_ACTION;
 			filter = NULL;
+			kernel = 0;
 		}
 	}
 
-- 
2.25.1

