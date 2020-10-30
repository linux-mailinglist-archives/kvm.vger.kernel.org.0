Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810CA29FC67
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgJ3D5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:57:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:4255 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgJ3D5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:57:00 -0400
IronPort-SDR: qWWEDkzmRSdGQHi13R1aZgF88KuakEKn0NllvIycb6oRPMFy6WGLk5HE+BAP1p+r1y6yDTiOlU
 Mw36cwduQnnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685750"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685750"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:59 -0700
IronPort-SDR: 9Lwfykx0aMvKgG16Wd+YufHmYsOz2+IaUa7uWGCZl8PtXTF8OfbMp/8mnrLUXNbo8inEv2GzD2
 GsGEh3NiNSdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770457"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:56 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 08/10] KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
Date:   Fri, 30 Oct 2020 11:52:18 +0800
Message-Id: <20201030035220.102403-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 62aa7a701ebb..57b940c613ab 100644
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
index 72a6dd6ca0ac..8120685c43d4 100644
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
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -676,4 +705,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.deliver_pmi = intel_pmu_deliver_pmi,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aef34f967769..2da96ec410a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1964,7 +1964,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 	u64 debugctl = vmx_supported_debugctl();
 
 	if (!intel_pmu_lbr_is_enabled(vcpu))
-		debugctl &= ~DEBUGCTLMSR_LBR;
+		debugctl &= ~DEBUGCTLMSR_LBR_MASK;
 
 	return debugctl;
 }
-- 
2.21.3

