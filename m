Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D1E7AF935
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjI0EWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjI0EVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:21:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03A12534;
        Tue, 26 Sep 2023 20:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785037; x=1727321037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vG6JB09+GdX1oexJrBx3ofjZYO0vUM/vdHaobdJsMXA=;
  b=Hwn0qedhm2uoU8+xuKtocMWADuuN89PY6gCL5phsX6s9FMZJRdllzB6Q
   HWhJwoZoOl/l2jwfwyf9yeK/+O2DN9tk2A4v2Ixuwhhm1ylmvlXKO7wUD
   mQSGyRjQoOva1CI5KYBUQm9ByxgKifS2Etbfhgvau6eHKseWc//zEjeCc
   90F9CEBVmpUT4DRrrp9CRwrTZrukCy108sBmsvSrYvIJZ2KyJRBr/kitc
   Gmsl/1UsAip0GOM9zi+1Ojt/cICpk4uaiLhkrtcErBy6iLV178BvAnh5C
   SykGgPMljvVYjRW7jLj6N+/E4XiY1jWhSdFvvLV9mMv2t0g1tcE7NMrN7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780709"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780709"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864636942"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864636942"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:23:52 -0700
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
Subject: [Patch v4 01/13] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
Date:   Wed, 27 Sep 2023 11:31:12 +0800
Message-Id: <20230927033124.1226509-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

