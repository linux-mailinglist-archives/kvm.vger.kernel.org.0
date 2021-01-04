Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C332A2E95F9
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbhADN3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:29:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:23246 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbhADN3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:29:12 -0500
IronPort-SDR: JQRSAhi/cIJEdkDTD/hQJBlRP/1Za9nfKVynueDFEyYjJ9hUkUDBSSUlsbgcML3kkrZzV6zFw+
 TQ817qooA48A==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034412"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034412"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:43 -0800
IronPort-SDR: lRuUij7rVOY4bgvfIQuR08zoxBK6kXrQ7F4ek7swA1XHfv7Vd2FQHDJlVWQO3t/xgCP3lrBM2g
 27uIeDzlFPRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944651"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:39 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/17] KVM: x86/pmu: Add hook to emulate pebs for cross-mapped counters
Date:   Mon,  4 Jan 2021 21:15:38 +0800
Message-Id: <20210104131542.495413-14-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
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
index 3bfed803ed17..e898da4699c9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -340,6 +340,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
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
index 99d9453e0176..2a06f923fbc7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -491,6 +491,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+static void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
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
index bc30c83e0a62..341794b67f9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6542,9 +6542,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
-	if (pmu->counter_cross_mapped)
-		msrs[1].guest = 0;
-
 	if (nr_msrs > 2 && msrs[1].guest) {
 		msrs[2].guest = pmu->ds_area;
 		if (nr_msrs > 3)
-- 
2.29.2

