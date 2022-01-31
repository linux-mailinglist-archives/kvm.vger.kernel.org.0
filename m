Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB7B4A3E30
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbiAaH0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:26:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:60957 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357922AbiAaHZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613923; x=1675149923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yTXAW0y1bRr1ZhmNMLZeR5QMvjVjpbYSmMclYmfKeNw=;
  b=atbyxg2K8VWDS12rxbSS0tg7PRor1lMAiYXyvchSMoKudfbGuL6t/mAY
   wBG72DSQKkZHF8FD9lHgdsDEZvpWsw6DaJX5cWceSmTo3+qsUtcnv4oA+
   dBbKan3GLjkSq/vmiuX7Mz7E5KMGO6q8RNesSK8mt21bEYvkWf3OKJSMP
   Th1GZ9QQxrsOX0+pN9zJG+1KsLP9zEZcyM8t3UsdF9JN62G8oaLpIpPW3
   keRv3cLx5gxZz1B/WeffQUnFC1ERZC1PZj3X3O4PEFkcCXov4Gg+yJHpv
   AEOklj9/23i0aikzsfWTzOTezhl/XQb56uaCyj70hwSabMSRWHFf1Kqby
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367062"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367062"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:25:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515249"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:25:18 -0800
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
Subject: [PATCH 5/5] perf/core: Allow kernel address filter when not filtering the kernel
Date:   Mon, 31 Jan 2022 09:24:53 +0200
Message-Id: <20220131072453.2839535-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The so-called 'kernel' address filter can also be useful for filtering
fixed addresses in user space.  Allow that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 kernel/events/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index af043a1a06ca..7670b0918e46 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10454,8 +10454,6 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 		 */
 		if (state == IF_STATE_END) {
 			ret = -EINVAL;
-			if (kernel && event->attr.exclude_kernel)
-				goto fail;
 
 			/*
 			 * ACTION "filter" must have a non-zero length region
-- 
2.25.1

