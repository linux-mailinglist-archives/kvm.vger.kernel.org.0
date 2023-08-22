Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF887838FA
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjHVFDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjHVFDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:03:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C03618B;
        Mon, 21 Aug 2023 22:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680626; x=1724216626;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vG6JB09+GdX1oexJrBx3ofjZYO0vUM/vdHaobdJsMXA=;
  b=Q4jILDNFN6tZA61/D1uxf4Yr5pWpyr9S5nZ6/Qwk2EDzAOsnHwapRRkv
   P6D9XVp8Xa+01L067BaJfIc7Gf1igQhyzZFnbkJNvnHMxpT+aRxBUOWvf
   4vB4op9B49DQGz+edHVEmcRQxNUho3SsqqJiq9mVAX4U328Y3dApevHBt
   qojAzkP2pygx5XTtXT/zFFW3VNbx+alxfWnBzsNpm7s2aR2SuAcdl/M51
   w9w2w1pNOwT5H5Dbo9zq+KJdlEmV09roctYUjqLqnRXAqF9zuklge6EGz
   dvH30v0RkodLX/G6NlxLDe1Wm+u6mjjmTqSVI8rrWsBzlp4kHXcrybMbh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146422"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146422"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736621"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736621"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:03:40 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH RFC v3 01/13] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
Date:   Tue, 22 Aug 2023 13:11:28 +0800
Message-Id: <20230822051140.512879-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
References: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for the architectural topdown slots event which
is hinted by CPUID.0AH.EBX.

The topdown slots event counts the total number of available slots for
an unhalted logical processor. Software can use this event as the
denominator for the top-level metrics of the topDown Microarchitecture
Analysis method.

Although the MSR_PERF_METRICS MSR required for topdown events is not
currently available in the guest, relying only on the data provided by
the slots event is sufficient for pmu users to perceive differences in
cpu pipeline machine-width across micro-architectures.

The standalone slots event, like the instruction event, can be counted
with gp counter or fixed counter 3 (if any). Its availability is also
controlled by CPUID.AH.EBX. On Linux, perf user may encode
"-e cpu/event=0xa4,umask=0x01/" or "-e cpu/slots/" to count slots events.

This patch only enables slots event on GP counters. The enabling on fixed
counter 3 will be supported in subsequent patches.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f2efa0bf7ae8..7322f0c18565 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -34,6 +34,7 @@ enum intel_pmu_architectural_events {
 	INTEL_ARCH_LLC_MISSES,
 	INTEL_ARCH_BRANCHES_RETIRED,
 	INTEL_ARCH_BRANCHES_MISPREDICTED,
+	INTEL_ARCH_TOPDOWN_SLOTS,
 
 	NR_REAL_INTEL_ARCH_EVENTS,
 
@@ -58,6 +59,7 @@ static struct {
 	[INTEL_ARCH_LLC_MISSES]			= { 0x2e, 0x41 },
 	[INTEL_ARCH_BRANCHES_RETIRED]		= { 0xc4, 0x00 },
 	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
+	[INTEL_ARCH_TOPDOWN_SLOTS]		= { 0xa4, 0x01 },
 	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
 };
 
-- 
2.34.1

