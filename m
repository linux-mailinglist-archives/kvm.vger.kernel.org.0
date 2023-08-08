Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF0D77406C
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjHHRDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbjHHRCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:02:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21E958F9C;
        Tue,  8 Aug 2023 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691510476; x=1723046476;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3palZx49tqBoZNpzk9Gws7e+TxRV8umZj8mk+CdEWmg=;
  b=lPkl5HXKWexEQISzphCswh3jF4PsL95xc32VshyKCstgwLaCtKyIFUAH
   TMGtxpgV+JM4/bq0IXF/q9IRwg1sez8NzUE3djNRuuVx7xdGgbIj/rL8B
   u+78DaCC+YdvNNgyttHmpRmW53WwBEHQ35dxOdupbwklAWNc6JBvvBAAu
   Ngabe2tWwc+YmjAADaC28DFnHEFz/ykHRuruVK47gtUoj+5n1zSfYyySN
   jVklfUJbns3FKX5LZNOymglPwUqWBVRuif9JXLDk9T77IsJpudAeJnPNQ
   tPeJc3oLk0p5/fjMV3glxOU/eFdRcZHdsnWrqDfxMTw1Y9fdEK3YnQdRp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="373477846"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="373477846"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 22:15:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="977717350"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="977717350"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2023 22:14:54 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
Date:   Tue,  8 Aug 2023 13:15:02 +0800
Message-Id: <20230808051502.1831199-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/perf_event.h |  2 ++
 arch/x86/kvm/pmu.c                | 16 +++++++---------
 arch/x86/kvm/pmu.h                | 10 +++++++---
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 85a9fd5a3ec3..018441211af1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -38,6 +38,8 @@
 #define INTEL_FIXED_0_USER				(1ULL << 1)
 #define INTEL_FIXED_0_ANYTHREAD			(1ULL << 2)
 #define INTEL_FIXED_0_ENABLE_PMI			(1ULL << 3)
+#define INTEL_FIXED_0_ENABLE	\
+	(INTEL_FIXED_0_KERNEL |	INTEL_FIXED_0_USER)
 
 #define HSW_IN_TX					(1ULL << 32)
 #define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..03fb6b4bca2c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -418,13 +418,12 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
 	if (pmc_is_fixed(pmc)) {
-		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-						  pmc->idx - INTEL_PMC_IDX_FIXED);
-		if (fixed_ctr_ctrl & 0x1)
+		fixed_ctr_ctrl = pmu_fixed_ctrl_field(pmu, pmc->idx);
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
@@ -747,10 +746,9 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
 		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
 	} else {
-		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
-					  pmc->idx - INTEL_PMC_IDX_FIXED);
-		select_os = config & 0x1;
-		select_user = config & 0x2;
+		config = pmu_fixed_ctrl_field(pmc_to_pmu(pmc), pmc->idx);
+		select_os = config & INTEL_FIXED_0_KERNEL;
+		select_user = config & INTEL_FIXED_0_USER;
 	}
 
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..2d098aa2fcc6 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -12,7 +12,11 @@
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
-#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
+#define fixed_ctrl_field(ctrl_reg, idx) \
+	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
+
+#define pmu_fixed_ctrl_field(pmu, idx)	\
+	fixed_ctrl_field((pmu)->fixed_ctr_ctrl, (idx) - INTEL_PMC_IDX_FIXED)
 
 #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
@@ -164,8 +168,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
 	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+		return pmu_fixed_ctrl_field(pmu, pmc->idx) &
+		       INTEL_FIXED_0_ENABLE;
 
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
-- 
2.34.1

