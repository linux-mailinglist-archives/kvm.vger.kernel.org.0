Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4618ACD8
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCSGgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:36:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:40709 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCSGgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:36:00 -0400
IronPort-SDR: vHcRuA/crpwybQlb6pd/p2d8rrqtGJQUtZchW05LofPHFwojgcYn6Y/bSpK7//JywnxrUPa4UR
 0CqNKm0l9C8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:35:59 -0700
IronPort-SDR: aqfRlXMl7BfV0TrZSGL0h+Np3nnWYK+kZZlIfPgIHOgvY9tH/ly4gXv6YGKflKuAY0D0gFQSB9
 j2JTxImSDSxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439193"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:35:53 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v2 4/5] KVM: x86/pmu: Add counter reload register to MSR list
Date:   Thu, 19 Mar 2020 22:33:49 +0800
Message-Id: <1584628430-23220-5-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
References: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest counter reload registers need to be loaded to real
HW before VM-entry. This patch add the counter reload registers to
MSR-load list when the corresponding counter is enabled, and remove
them when the counter is disabled.

Following the description in SDM, there are 3 fixed counters per
core and 4 general-purpose counters per core in Tremont
Microarchitecture. This patch extended the value of NR_LOADSTORE_MSRS
from 8 to 16 because there are 7 counter reload registers need to be
added into the MSR-load list when all the counters are enabled.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h       |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a8b0a8d..75e1d2c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,12 +68,42 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+static void intel_pmu_set_reload_counter(struct kvm_vcpu *vcpu, u64 data,
+								bool add)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	unsigned long bit;
+	u64 set, host_reload_ctr;
+	u32 msr;
+
+	set = data & ~pmu->global_ctrl_mask;
+
+	for_each_set_bit(bit, (unsigned long *)&set, X86_PMC_IDX_MAX) {
+		if (bit < INTEL_PMC_IDX_FIXED) {
+			msr = MSR_RELOAD_PMC0 + bit;
+			pmc = &pmu->gp_counters[bit];
+		} else {
+			msr = MSR_RELOAD_PMC0 + bit - INTEL_PMC_IDX_FIXED;
+			pmc = &pmu->gp_counters[bit - INTEL_PMC_IDX_FIXED];
+		}
+
+		rdmsrl_safe(msr, &host_reload_ctr);
+		if (add)
+			add_atomic_switch_msr(vmx, msr,
+				pmc->reload_cnt, host_reload_ctr, false);
+		else
+			clear_atomic_switch_msr(vmx, msr);
+	}
+}
+
 static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(pmu_to_vcpu(pmu));
 	u64 host_ds_area, host_pebs_data_cfg;
 
-	if (data) {
+	if (data && ((data & PEBS_OUTPUT_MASK) == 0)) {
 		rdmsrl_safe(MSR_IA32_DS_AREA, &host_ds_area);
 		add_atomic_switch_msr(vmx, MSR_IA32_DS_AREA,
 			pmu->ds_area, host_ds_area, false);
@@ -81,10 +111,19 @@ static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
 		rdmsrl_safe(MSR_PEBS_DATA_CFG, &host_pebs_data_cfg);
 		add_atomic_switch_msr(vmx, MSR_PEBS_DATA_CFG,
 			pmu->pebs_data_cfg, host_pebs_data_cfg, false);
+	} else if (data && ((data & PEBS_OUTPUT_MASK) == PEBS_OUTPUT_PT)) {
+		intel_pmu_set_reload_counter(pmu_to_vcpu(pmu), data, true);
 
+		rdmsrl_safe(MSR_PEBS_DATA_CFG, &host_pebs_data_cfg);
+		add_atomic_switch_msr(vmx, MSR_PEBS_DATA_CFG,
+			pmu->pebs_data_cfg, host_pebs_data_cfg, false);
 	} else {
 		clear_atomic_switch_msr(vmx, MSR_IA32_DS_AREA);
 		clear_atomic_switch_msr(vmx, MSR_PEBS_DATA_CFG);
+
+		if (pmu->has_pebs_via_pt)
+			intel_pmu_set_reload_counter(pmu_to_vcpu(pmu),
+							data, false);
 	}
 
 	pmu->pebs_enable = data;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ea899e7..f185144 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -28,7 +28,7 @@
 #define NR_SHARED_MSRS	4
 #endif
 
-#define NR_LOADSTORE_MSRS 8
+#define NR_LOADSTORE_MSRS 16
 
 struct vmx_msrs {
 	unsigned int		nr;
-- 
1.8.3.1

