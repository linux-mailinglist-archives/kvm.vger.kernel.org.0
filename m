Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8771D1F81A8
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgFMILh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:64600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgFMILd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:33 -0400
IronPort-SDR: 918yfGiljIrESC7/iWY7XuNlvoy1LYbQ8ocM/zK4xX6GOU3Zq2vkdDSEXjhWnYyN4W9B5GrrLz
 9j3aEm2VaWIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:32 -0700
IronPort-SDR: IA2aq0Psj6XKnGsFTqLXpJJl3J4I5Bd0cqRpKIbdbx7qYyl+Sk6Ud0xX8CMATdQ/mD3m1pDavQ
 oKwJpUaNaUig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467442"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:29 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 09/11] KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
Date:   Sat, 13 Jun 2020 16:09:54 +0800
Message-Id: <20200613080958.132489-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
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
IA32_DEBUGCTL. Also guest needs to re-enable IA32_DEBUGCTL.LBR
to resume recording branches.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  5 ++++-
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/vmx/pmu_intel.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b86346903f2e..5053f4238218 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -378,8 +378,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 
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
index ab85eed8a6cc..095b84392b89 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,6 +37,7 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a78c440ebff2..85a675004cbb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -641,6 +641,36 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	intel_pmu_free_lbr_event(vcpu);
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
+	u64 data;
+
+	data = vmcs_read64(GUEST_IA32_DEBUGCTL);
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
+	if (!lbr_is_enabled(vcpu))
+		return;
+
+	if (version > 1 && version < 4)
+		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -655,4 +685,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.deliver_pmi = intel_pmu_deliver_pmi,
 };
-- 
2.21.3

