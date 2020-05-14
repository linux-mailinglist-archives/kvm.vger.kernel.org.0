Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E2C1D2A31
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgENIbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:12089 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgENIbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:45 -0400
IronPort-SDR: CybOFdpDg/q3KVVdWkAs9JoMpKoUNfTvip2jy772PjVK4r6l3bwTkIWBUwfmbmHpYPOeKIq7+E
 Nv7VJF9XY3iw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:45 -0700
IronPort-SDR: 1+ordkhGBNpAcHCPzkHvlYddkq04iMxDBIFq59y2JBiAQHfKAWxnDoFRnMplx05jUTosTgHiev
 PSZK1Fh2Lr6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341540032"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:42 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 10/11] KVM: x86/pmu: Check guest LBR availability in case host reclaims them
Date:   Thu, 14 May 2020 16:30:53 +0800
Message-Id: <20200514083054.62538-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest LBR event exists and the LBR stack is available (defined
as 'event->oncpu != -1'), the LBR records msrs access would not be
intercepted but passthrough to the vcpu before vm-entry. This kind
of availability check is always performed before vm-entry, but as late
as possible to avoid reclaiming resources from any higher priority event.
A negative check result would bring the registers interception back, and
it also prevents real registers accesses and potential data leakage.

The KVM emits a pr_warn() on the host when the guest LBR is unavailable.
The administer is supposed to reminder users that the guest result may be
inaccurate if someone is using LBR to record hypervisor on the host side.

Suggested-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/vmx/pmu_intel.c | 38 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c       |  4 +++-
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 78f0cfe1622f..bb3f3ef3386e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -42,6 +42,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*lbr_cleanup)(struct kvm_vcpu *vcpu);
+	void (*availability_check)(struct kvm_vcpu *vcpu);
 };
 
 static inline bool event_is_oncpu(struct perf_event *event)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ea4faae56473..db185dca903d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -646,6 +646,43 @@ static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_free_lbr_event(vcpu);
 }
 
+static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!pmu->lbr_event)
+		return false;
+
+	if (event_is_oncpu(pmu->lbr_event)) {
+		intel_pmu_intercept_lbr_msrs(vcpu, false);
+	} else {
+		intel_pmu_intercept_lbr_msrs(vcpu, true);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Higher priority host perf events (e.g. cpu pinned) could reclaim the
+ * pmu resources (e.g. LBR) that were assigned to the guest. This is
+ * usually done via ipi calls (more details in perf_install_in_context).
+ *
+ * Before entering the non-root mode (with irq disabled here), double
+ * confirm that the pmu features enabled to the guest are not reclaimed
+ * by higher priority host events. Otherwise, disallow vcpu's access to
+ * the reclaimed features.
+ */
+static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	if (lbr_is_enabled(vcpu) && !intel_pmu_lbr_is_availabile(vcpu) &&
+		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		pr_warn_ratelimited("kvm: vcpu-%d: LBR is temporarily unavailable.\n",
+			vcpu->vcpu_id);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -662,4 +699,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.lbr_cleanup = intel_pmu_lbr_cleanup,
+	.availability_check = intel_pmu_availability_check,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9969d663826a..80d036c5f64a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6696,8 +6696,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	if (vcpu_to_pmu(vcpu)->version)
+	if (vcpu_to_pmu(vcpu)->version) {
 		atomic_switch_perf_msrs(vmx);
+		kvm_x86_ops.pmu_ops->availability_check(vcpu);
+	}
 
 	atomic_switch_umwait_control_msr(vmx);
 
-- 
2.21.3

