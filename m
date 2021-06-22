Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DBB3B009E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhFVJrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:47:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:20236 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFVJqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:46:37 -0400
IronPort-SDR: WFQGeUauLdnBXyG8IIz53J3qNmY6+KTTrF9f6UY2KCjt6SvLY7Lu0BJegiaa7OFYDZQrKp9MYT
 9xBcMyqgXnUg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194331055"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194331055"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:44:20 -0700
IronPort-SDR: YYD3TWXJJloI8zRUYIBMBTqpWloVF3NTmtxdEfw/42H9kBKtbdey5K9rUn4ohPgHITamPKA9sE
 WAusI3CDcTIA==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600298"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:44:16 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 14/18] KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
Date:   Tue, 22 Jun 2021 17:43:02 +0800
Message-Id: <20210622094306.8336-15-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

It allows this inline function to be reused by more callers in
more files, such as pmu_intel.c.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/kvm/pmu.c | 11 -----------
 arch/x86/kvm/pmu.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b907aba35ff3..d957c1e83ec9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -481,17 +481,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1af86ae1d3f2..5795bb113e76 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -149,6 +149,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
-- 
2.27.0

