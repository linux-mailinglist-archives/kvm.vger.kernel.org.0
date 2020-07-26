Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6F22E0C6
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGZPfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:35:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgGZPfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:05 -0400
IronPort-SDR: dqnWT80FuFdck7iKImTy3bYPmT8iv+LdDFFjBaP4+luh6eP5EufPVYIFFyIAtoOleiK6tZxLQ8
 RJwXFWgNPp8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890989"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890989"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:35:05 -0700
IronPort-SDR: QYDg93/d6Zj3bMkMneA0CAQfhVf0E622D0EDoVdoOWNyDuiCkUFmrohn7kbXhRpSRyHMmBuod+
 pLOwjs6w4N3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177625"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:35:02 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v13 08/10] KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
Date:   Sun, 26 Jul 2020 23:32:27 +0800
Message-Id: <20200726153229.27149-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current vPMU only supports Architecture Version 2. According to
Intel SDM "17.4.7 Freezing LBR and Performance Counters on PMI", if
IA32_DEBUGCTL.Freeze_LBR_On_PMI = 1, the LBR is frozen on the virtual
PMI and the KVM would emulate to clear the LBR bit (bit 0) in
IA32_DEBUGCTL. Also, guest needs to re-enable IA32_DEBUGCTL.LBR
to resume recording branches.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c              |  5 ++++-
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/vmx/capabilities.h |  4 +++-
 arch/x86/kvm/vmx/pmu_intel.c    | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 67741d2a0308..405890c723a1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -383,8 +383,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
-	if (lapic_in_kernel(vcpu))
+	if (lapic_in_kernel(vcpu)) {
+		if (kvm_x86_ops.pmu_ops->deliver_pmi)
+			kvm_x86_ops.pmu_ops->deliver_pmi(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
+	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 067fef51760c..742a4e98df8c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -39,6 +39,7 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 26e77c6edcda..f17ab6cf152e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -21,6 +21,8 @@ extern int __read_mostly pt_mode;
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
+#define DEBUGCTLMSR_LBR_MASK		(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
+
 struct nested_vmx_msrs {
 	/*
 	 * We only store the "true" versions of the VMX capability MSRs. We
@@ -384,7 +386,7 @@ static inline u64 vmx_supported_debugctl(void)
 	u64 debugctl = DEBUGCTLMSR_BTF;
 
 	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
-		debugctl |= DEBUGCTLMSR_LBR;
+		debugctl |= DEBUGCTLMSR_LBR_MASK;
 
 	return debugctl;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 08d195e08deb..bcac0f59bbf1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -590,6 +590,35 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+/*
+ * Emulate LBR_On_PMI behavior for 1 < pmu.version < 4.
+ *
+ * If Freeze_LBR_On_PMI = 1, the LBR is frozen on PMI and
+ * the KVM emulates to clear the LBR bit (bit 0) in IA32_DEBUGCTL.
+ *
+ * Guest needs to re-enable LBR to resume branches recording.
+ */
+static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
+{
+	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
+		data &= ~DEBUGCTLMSR_LBR;
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+	}
+}
+
+static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
+{
+	u8 version = vcpu_to_pmu(vcpu)->version;
+
+	if (!intel_pmu_lbr_is_enabled(vcpu))
+		return;
+
+	if (version > 1 && version < 4)
+		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+}
+
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 {
 	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
@@ -680,4 +709,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.deliver_pmi = intel_pmu_deliver_pmi,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index daab79d1ccc3..b72fbbef56fa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1987,7 +1987,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 	u64 debugctl = vmx_supported_debugctl();
 
 	if (!intel_pmu_lbr_is_enabled(vcpu))
-		debugctl &= ~DEBUGCTLMSR_LBR;
+		debugctl &= ~DEBUGCTLMSR_LBR_MASK;
 
 	return debugctl;
 }
-- 
2.21.3

