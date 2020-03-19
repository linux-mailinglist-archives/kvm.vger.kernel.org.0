Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9611418ACD5
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCSGf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:35:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:25738 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCSGfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:35:55 -0400
IronPort-SDR: iUfOJtqCGhrX6WU2c0IoTQgWKl2CFcub+QriIdOzOplYNYJVX1oMWhFfllN1COMExF+Jza1HXF
 sE/gzZ/3CVkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:35:46 -0700
IronPort-SDR: XcYWylahaQaFSFIOqNeh8si3MqUvyp0HdDYnjxb+ALKukoSYI1ma1h8nyJbO7YjrmBMzDPby0J
 yE/1NYK+RagA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439124"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:35:40 -0700
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
Subject: [PATCH v2 2/5] KVM: x86/pmu: Expose PDCM feature when PEBS output to PT
Date:   Thu, 19 Mar 2020 22:33:47 +0800
Message-Id: <1584628430-23220-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
References: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PDCM(Perfmon and Debug Capability) indicates the processor supports
the performance and debug feature indication IA32_PERF_CAPABILITIES.

Expose PDCM feature when PEBS virtualization via Intel PT is supported
in KVM guest.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/pmu.h               |  1 +
 arch/x86/kvm/vmx/capabilities.h  |  9 +++++++--
 arch/x86/kvm/vmx/pmu_intel.c     | 13 +++++++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d3d6e48..750a2d5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -155,6 +155,7 @@
 #define PERF_CAP_ARCH_REG		BIT_ULL(7)
 #define PERF_CAP_PEBS_FORMAT		0xf00
 #define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
+#define PERF_CAP_PEBS_OUTPUT_PT		BIT_ULL(16)
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_IA32_RTIT_CTL		0x00000570
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d640628..ba8c68d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -33,6 +33,7 @@ struct kvm_pmu_ops {
 	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*is_pebs_via_ds_supported)(void);
+	bool (*is_pebs_via_pt_supported)(void);
 	bool (*is_pebs_baseline_supported)(void);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 9e352b5..dc480c9 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -154,10 +154,15 @@ static inline bool vmx_pku_supported(void)
 
 static inline bool vmx_pdcm_supported(void)
 {
+	bool ret = 0;
+
 	if (kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported)
-		return kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported();
+		ret |= kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported();
 
-	return false;
+	if (kvm_x86_ops->pmu_ops->is_pebs_via_pt_supported)
+		ret |= kvm_x86_ops->pmu_ops->is_pebs_via_pt_supported();
+
+	return ret;
 }
 
 static inline bool vmx_dtes64_supported(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2db9b9e..f04e5eb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -221,6 +221,18 @@ static bool intel_is_pebs_via_ds_supported(void)
 	return true;
 }
 
+static bool intel_is_pebs_via_pt_supported(void)
+{
+	u64 misc, perf_cap;
+
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc);
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	return (!(misc & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) &&
+		(perf_cap & PERF_CAP_PEBS_OUTPUT_PT) &&
+		(pt_mode == PT_MODE_HOST_GUEST));
+}
+
 static bool intel_is_pebs_baseline_supported(void)
 {
 	u64 perf_cap;
@@ -529,6 +541,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
 	.is_pebs_via_ds_supported = intel_is_pebs_via_ds_supported,
+	.is_pebs_via_pt_supported = intel_is_pebs_via_pt_supported,
 	.is_pebs_baseline_supported = intel_is_pebs_baseline_supported,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
-- 
1.8.3.1

