Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C20360050
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhDODVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:10604 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhDODVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:34 -0400
IronPort-SDR: 5CSX7fI/2lti08Cd5rk7iB5Jv3a13bc6IEyivLjT1b2oq4G6KCb8OCGuP6ys4rT2AZscVYe9lj
 0wfUWwFzOvNw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="215281582"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="215281582"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:21:12 -0700
IronPort-SDR: EnmolPtiJZv+8UBz8gKwXl0dleOdSj+e9InDrLsa0n7tabMLNEblOkd/or3g/QI6bLIUMVc0ET
 mOYR54lrJ1DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425014089"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:21:08 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v5 12/16] KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
Date:   Thu, 15 Apr 2021 11:20:12 +0800
Message-Id: <20210415032016.166201-13-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It allows this inline function to be reused by more callers in
more files, such as pmu_intel.c.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 11 -----------
 arch/x86/kvm/pmu.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d3f746877d1b..666a5e90a3cb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -477,17 +477,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
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
index d9157128e6eb..6c902b2d2d5a 100644
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
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
-- 
2.30.2

