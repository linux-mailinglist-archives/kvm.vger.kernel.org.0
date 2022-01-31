Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6144A3E2F
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357940AbiAaH0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:26:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:60936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357914AbiAaHZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613918; x=1675149918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hwsT2KOST3M8BE5wlBZyKbhIKyHEH6Qfs9nq3qyUsdY=;
  b=brrD3QB3hBr3EYQCKMNmPY+OOkENmWV2fQ7bvjvS2Ux7JL7n/Hnk/+0a
   vOzM76zBgIsBC0+wFmyjF26gx8ucJlIpVHV1xzET5n1xU4kfT9wR6ey+e
   ktL1HW1zNj880MYmaGTN9zPom+kPIYzjUz4iK1M4kkxiEOpp3JiTjZqFN
   WW5Dyyx1s6q+OKn8oPeuqAU5VPeghfrV7zN6ojivuXxaxqN2wO0W/MVo1
   zI62NqagEm/oHGVSvZdvlPDf5dN6LDMV4eAru4pdLqn4WnUtlo8Bnlh7S
   3FXeGujAWBzu3ONKzDH/GbbpeUutRzaCCKvK67F8lbq00XsUHtsIKTEsg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367058"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367058"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:25:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515239"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:25:13 -0800
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
Subject: [PATCH 4/5] perf/x86/intel/pt: Fix address filter config for 32-bit kernel
Date:   Mon, 31 Jan 2022 09:24:52 +0200
Message-Id: <20220131072453.2839535-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change from shifting 'unsigned long' to 'u64' to prevent the config bits
being lost on a 32-bit kernel.

Fixes: eadf48cab4b6b0 ("perf/x86/intel/pt: Add support for address range filtering in PT")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 4015c1364463..aa66c0c7b18b 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -490,7 +490,7 @@ static u64 pt_config_filters(struct perf_event *event)
 			pt->filters.filter[range].msr_b = filter->msr_b;
 		}
 
-		rtit_ctl |= filter->config << pt_address_ranges[range].reg_off;
+		rtit_ctl |= (u64)filter->config << pt_address_ranges[range].reg_off;
 	}
 
 	return rtit_ctl;
-- 
2.25.1

