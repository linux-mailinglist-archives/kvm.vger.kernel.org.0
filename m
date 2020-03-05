Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C03F17A2AD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgCEJ7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:34 -0500
Received: from mga04.intel.com ([192.55.52.120]:14648 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgCEJ7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366585"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:26 -0800
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
        kan.liang@linux.intel.com, like.xu@linux.intel.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 06/11] KVM: x86/pmu: Implement is_pebs_via_ds_supported pmu ops
Date:   Fri,  6 Mar 2020 01:57:00 +0800
Message-Id: <1583431025-19802-7-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS virtualization enabling in KVM guest via DS is only supported on
Icelake server. This patch introduce a new pmu ops is_pebs_via_ds_supported
to check if PEBS feature can be supported in KVM guest.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/vmx/pmu_intel.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1333298..476780b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,6 +32,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
+	bool (*is_pebs_via_ds_supported)(void);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ebadc33..a67bd34 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -12,6 +12,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
+#include <asm/intel-family.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -172,6 +173,22 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+static bool intel_is_pebs_via_ds_supported(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_PEBS))
+		return false;
+
+	switch (boot_cpu_data.x86_model) {
+	case INTEL_FAM6_ICELAKE_D:
+	case INTEL_FAM6_ICELAKE_X:
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -401,6 +418,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
 	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
+	.is_pebs_via_ds_supported = intel_is_pebs_via_ds_supported,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
 	.refresh = intel_pmu_refresh,
-- 
1.8.3.1

