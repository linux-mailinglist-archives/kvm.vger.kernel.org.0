Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F67864FB
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 03:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbjHXB7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 21:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbjHXB60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 21:58:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B11310D0;
        Wed, 23 Aug 2023 18:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692842303; x=1724378303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zr7H0wGlnhCSbEDuWo9f0W/Bc09ig1Y26FxrMMZFams=;
  b=f+g3AcOlvcJhHgUHHQ1LPSYGF5GZbu7Gl9Zd1vt3us1E4m7fhurjh7XI
   dy8AZba1T5ZxrcQqEL3qT1ElMxPnccX6lqD1xtPLc8PjevFw21d2Z5YWz
   2nK5u3IAbwPLhWrOqTczWs+/CXElU8l+tANndSJwL2e5Pxzosij7tcrF+
   HhXmb6wieDJwGB/K8SGrQdKPFPox2bVnSDPCSqBu24OMofe2jGVgfm+Y9
   +P9MUvh6Z97kxt7x2mVY7FBun2+msXZLi9HCtnwZMxJaXEMep2UhCCtKV
   bGjFdKHBWQ6d4iaUz+vBDfXazroNzfsT42TwkyrXDP/uMioAwxEtAI//A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="460682472"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="460682472"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 18:58:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="713794457"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713794457"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2023 18:58:16 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v3] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
Date:   Thu, 24 Aug 2023 10:05:46 +0800
Message-Id: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Magic numbers are used to manipulate the bit fields of
FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
these magic numbers to increase the readability.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c           | 10 +++++-----
 arch/x86/kvm/pmu.h           |  6 ++++--
 arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++---
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..fb4ef2da3e32 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -420,11 +420,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (pmc_is_fixed(pmc)) {
 		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
 						  pmc->idx - INTEL_PMC_IDX_FIXED);
-		if (fixed_ctr_ctrl & 0x1)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
 			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
-		if (fixed_ctr_ctrl & 0x2)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
 			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
-		if (fixed_ctr_ctrl & 0x8)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
 			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
 		new_config = (u64)fixed_ctr_ctrl;
 	}
@@ -749,8 +749,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	} else {
 		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
 					  pmc->idx - INTEL_PMC_IDX_FIXED);
-		select_os = config & 0x1;
-		select_user = config & 0x2;
+		select_os = config & INTEL_FIXED_0_KERNEL;
+		select_user = config & INTEL_FIXED_0_USER;
 	}
 
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..ffda2ecc3a22 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -12,7 +12,8 @@
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
-#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
+#define fixed_ctrl_field(ctrl_reg, idx) \
+	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
 #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
@@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 
 	if (pmc_is_fixed(pmc))
 		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+					pmc->idx - INTEL_PMC_IDX_FIXED) &
+					(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
 
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f2efa0bf7ae8..b0ac55891cb7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -548,8 +548,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmu->fixed_ctr_ctrl_mask &=
+			 ~intel_fixed_bits_by_idx(i,
+						  INTEL_FIXED_0_KERNEL |
+						  INTEL_FIXED_0_USER |
+						  INTEL_FIXED_0_ENABLE_PMI);
+	}
 	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
@@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 				pmu->fixed_ctr_ctrl_mask &=
-					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+					~intel_fixed_bits_by_idx(i, ICL_FIXED_0_ADAPTIVE);
 			}
 			pmu->pebs_data_cfg_mask = ~0xff00000full;
 		} else {

base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.34.1

