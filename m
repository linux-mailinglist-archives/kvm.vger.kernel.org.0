Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989337746CC
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjHHTCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHHTBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:01:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1948DCD8;
        Tue,  8 Aug 2023 10:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515898; x=1723051898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fPtNZahJRPH8ZMXlj5BwpQG1xqg/GrHrKft4TWcLJSs=;
  b=lXIeEm+sNa2dkzTLVDUjC0UHYGiFvCERpY3xP8nnJv4rCrDZ3AUrcjtw
   nfzdqtXj4Bp5nG2nc0yPIneEKgplaqJ8Y744+f3p9/a466CbS9Mns4Ra5
   XWMY43J8yw1P2y7E6jNJkJ/pz4PIR+QqRMpux6SNmZOOEGN6skxXd3GtM
   lAJbFEQ9IynUWVvQFbwyeAXOBP3ZHni5umR/2wXpptEBW9CaQErbhrYpG
   uIqsgboRs98oMTOcMF/IPloM6GoI6E6dtU7I1kKNKcE0EgkMWJeJeBaq/
   8mIV/JHVMGhRB0wY8cSFUWglLp4T+SPcvGbtPN3FNccvM5M9MBC1KPys/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434581893"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434581893"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377223"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377223"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:25:42 -0700
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
Subject: [PATCH RFV v2 02/13] KVM: x86/pmu: Support PMU fixed counter 3
Date:   Tue,  8 Aug 2023 14:31:00 +0800
Message-Id: <20230808063111.1870070-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
References: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
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

The TopDown slots event can be enabled on gp counter or fixed counter 3
and it does not differ from other fixed counters in terms of the use of
count and sampling modes (except for the hardware logic for event
accumulation).

According to commit 6017608936c1 ("perf/x86/intel: Add Icelake
support"), KVM or any perf in-kernel user needs to reprogram fixed
counter 3 via the kernel-defined TopDown slots event for real fixed
counter 3 on the host.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 10 ++++++++++
 arch/x86/kvm/x86.c              |  4 ++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60d430b4650f..51fb7728c407 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -509,7 +509,7 @@ struct kvm_pmc {
 #define KVM_INTEL_PMC_MAX_GENERIC	8
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define KVM_PMC_MAX_FIXED	3
+#define KVM_PMC_MAX_FIXED		4
 #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7322f0c18565..044d61aa63dc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -45,6 +45,14 @@ enum intel_pmu_architectural_events {
 	 * core crystal clock or the bus clock (yeah, "architectural").
 	 */
 	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
+	/*
+	 * Pseudo-architectural event used to implement IA32_FIXED_CTR3, a.k.a.
+	 * topDown slots. The topdown slots event counts the total number of
+	 * available slots for an unhalted logical processor. The topdwon slots
+	 * event with PERF_METRICS MSR together provides support for topdown
+	 * micro-architecture analysis method.
+	 */
+	PSEUDO_ARCH_TOPDOWN_SLOTS,
 	NR_INTEL_ARCH_EVENTS,
 };
 
@@ -61,6 +69,7 @@ static struct {
 	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
 	[INTEL_ARCH_TOPDOWN_SLOTS]		= { 0xa4, 0x01 },
 	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
+	[PSEUDO_ARCH_TOPDOWN_SLOTS]		= { 0x00, 0x04 },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */
@@ -68,6 +77,7 @@ static int fixed_pmc_events[] = {
 	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
 	[1] = INTEL_ARCH_CPU_CYCLES,
 	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
+	[3] = PSEUDO_ARCH_TOPDOWN_SLOTS,
 };
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34945c7dba38..73db594f855b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1459,7 +1459,7 @@ static const u32 msrs_to_save_base[] = {
 
 static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
+	MSR_ARCH_PERFMON_FIXED_CTR2, MSR_ARCH_PERFMON_FIXED_CTR3,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
@@ -7181,7 +7181,7 @@ static void kvm_init_msr_lists(void)
 {
 	unsigned i;
 
-	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
+	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 4,
 			 "Please update the fixed PMCs in msrs_to_save_pmu[]");
 
 	num_msrs_to_save = 0;
-- 
2.34.1

