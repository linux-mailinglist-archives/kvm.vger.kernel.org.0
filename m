Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F1F2AAF57
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgKICRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:64940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729406AbgKICRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:41 -0500
IronPort-SDR: QTcoxYNBSx9DY28Upe4qlUMOa1PWli1vED5iIEPmwiHfehGUATzyhq5HMtL8GcC0PLovHRDo8Y
 NsHyIzqiK53w==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684647"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684647"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:41 -0800
IronPort-SDR: 9sRnK9CDdGsfGnWmzEA/DNbJMWbubFNiwCiZGcQDFxpncvlUiFyakvm5hygfRlJ4+LIgrxkfxS
 nZuRkFTt5obw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646259"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:37 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 13/17] KVM: x86/pmu: Add hook to emulate pebs for cross-mapped counters
Date:   Mon,  9 Nov 2020 10:12:50 +0800
Message-Id: <20201109021254.79755-14-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To emulate PEBS facility, KVM may needs setup context such as
guest DS PEBS fields correctly before vm-entry and this part
will be implemented in the vmx handle_event() hook.

When the cross-map happens to any enabled PEBS counter, it will make
PMU request and exit to kvm_pmu_handle_event() for some rewrite stuff
and then back to cross-map check again and finally to vm-entry.

In this hook, KVM would rewrite the state for the guest and it won't
move events, hence races with the NMI PMI are not a problem.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           | 3 +++
 arch/x86/kvm/pmu.h           | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c       | 3 ---
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a6c5951a5728..f87be3c2140e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -339,6 +339,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(pmu->need_cleanup))
 		kvm_pmu_cleanup(vcpu);
+
+	if (kvm_x86_ops.pmu_ops->handle_event)
+		kvm_x86_ops.pmu_ops->handle_event(vcpu);
 }
 
 /* check if idx is a valid index to access PMU */
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f5ec94e9a1dc..b1e52e33f08c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -45,6 +45,7 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	void (*handle_event)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 99d9453e0176..2917105e584e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -491,6 +491,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!(pmu->global_ctrl & pmu->pebs_enable))
+		return;
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -505,4 +513,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.handle_event = intel_pmu_handle_event,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 302808ec9699..3b62907c8959 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6556,9 +6556,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
-	if (pmu->counter_cross_mapped)
-		msrs[1].guest = 0;
-
 	if (nr_msrs > 2 && msrs[1].guest) {
 		msrs[2].guest = pmu->ds_area;
 		if (nr_msrs > 3)
-- 
2.21.3

