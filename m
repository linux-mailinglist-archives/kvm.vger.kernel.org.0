Return-Path: <kvm+bounces-166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2DC7DC8CE
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9B4728137F
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C092B14A83;
	Tue, 31 Oct 2023 08:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hj290L3v"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C113AE3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:58:42 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495DDF;
	Tue, 31 Oct 2023 01:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698742720; x=1730278720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6HMFBByNeJuGrMJLEILM43k8UegRNuWkjShAtvq8eEI=;
  b=hj290L3vbOCPo5+1T3tiK20nLF/waP7bTodyuvforIJOboppxehXDXDJ
   JEkFCENAdDOJ712SfloRAna3dPtqatPM+IaiEbZRnwpruSSnmeDnvhw+n
   vSb4zPu498kywYUHJd4dHN8C650jk+DtQo8SUiTfOLpgfFecjwOobPAUA
   lOg23+hVV6Q7I3V2+sr5UmgRrd5sqnl3upJbJ3AfpuIKnqXmBpJKasqdQ
   TJfXEewlsuexUWYOKj5aki0zbJQ/d7pjMeruYulk98GuVXwU6bmSLVFHH
   b+dccN2RCMmIFbWkrQCIVP/NBJdLXPQzgOQWmLb9IRwaUFQhbI7KfvA/o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="378627571"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="378627571"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 01:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="8257906"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orviesa001.jf.intel.com with ESMTP; 31 Oct 2023 01:58:37 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Like Xu <likexu@tencent.com>
Subject: [Patch 2/2] KVM: x86/pmu: Support PMU fixed counter 3
Date: Tue, 31 Oct 2023 17:06:13 +0800
Message-Id: <20231031090613.2872700-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index d7036982332e..44b47950491a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -517,7 +517,7 @@ struct kvm_pmc {
 #define KVM_INTEL_PMC_MAX_GENERIC	8
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define KVM_PMC_MAX_FIXED	3
+#define KVM_PMC_MAX_FIXED		4
 #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e32353f1143f..d5af64b1ef69 100644
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
index 2c924075f6f1..90c60b6899a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1468,7 +1468,7 @@ static const u32 msrs_to_save_base[] = {
 
 static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
+	MSR_ARCH_PERFMON_FIXED_CTR2, MSR_ARCH_PERFMON_FIXED_CTR3,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
@@ -7318,7 +7318,7 @@ static void kvm_init_msr_lists(void)
 {
 	unsigned i;
 
-	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
+	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 4,
 			 "Please update the fixed PMCs in msrs_to_save_pmu[]");
 
 	num_msrs_to_save = 0;
-- 
2.34.1


