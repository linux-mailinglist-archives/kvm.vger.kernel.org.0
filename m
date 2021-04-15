Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1D360052
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhDODVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:10590 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhDODVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:38 -0400
IronPort-SDR: XAScFwTkg8/zJKSGvmwnGAxgBx324N+csvjtqmHhcwmOtO8Rjl6hZJZbD1pTtqei+VE2dfV5qY
 pbhOqUvGlsYg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="215281588"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="215281588"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:21:16 -0700
IronPort-SDR: kGvOaWxdXLHwKRIBRUKeLDpxNedOEpP7Dv/ZEL5WQNCogEosRz5o4E8PQMo/CZp5jaQr8to+C0
 mrQ982iz8Osw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425014100"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:21:12 -0700
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
Subject: [PATCH v5 13/16] KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
Date:   Thu, 15 Apr 2021 11:20:13 +0800
Message-Id: <20210415032016.166201-14-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest PEBS will be disabled when some users try to perf KVM and
its user-space through the same PEBS facility OR when the host perf
doesn't schedule the guest PEBS counter in a one-to-one mapping manner
(neither of these are typical scenarios).

The PEBS records in the guest DS buffer are still accurate and the
above two restrictions will be checked before each vm-entry only if
guest PEBS is deemed to be enabled.

Suggested-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c    | 11 +++++++++--
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index dc6335a054ff..8786a1d39940 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3895,8 +3895,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
 	};
 
-	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-	arr[0].guest |= arr[*nr].guest;
+	if (arr[*nr].host) {
+		/* Disable guest PEBS if host PEBS is enabled. */
+		arr[*nr].guest = 0;
+	} else {
+		/* Disable guest PEBS for cross-mapped PEBS counters. */
+		arr[*nr].guest &= ~pmu->host_cross_mapped_mask;
+		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+		arr[0].guest |= arr[*nr].guest;
+	}
 
 	++(*nr);
 	return arr;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e1a6b7c0537c..5aadf6060011 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -466,6 +466,15 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
+	/*
+	 * If a guest counter is cross-mapped to host counter with different
+	 * index, its PEBS capability will be temporarily disabled.
+	 *
+	 * The user should make sure that this mask is updated
+	 * after disabling interrupts and before perf_guest_get_msrs();
+	 */
+	u64 host_cross_mapped_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c846d3eef7a7..989e7245d790 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -770,6 +770,25 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+{
+	struct kvm_pmc *pmc = NULL;
+	int bit;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
+			 X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) ||
+		    !pmc_is_enabled(pmc))
+			continue;
+
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx))
+			pmu->host_cross_mapped_mask |=
+				BIT_ULL(pmc->perf_event->hw.idx);
+	}
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 58673351c475..4f0e35a0cd0f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6539,6 +6539,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
+	pmu->host_cross_mapped_mask = 0;
+	if (pmu->pebs_enable & pmu->global_ctrl)
+		intel_pmu_cross_mapped_check(pmu);
+
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
 	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7886a08505cc..1311f67046aa 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -96,6 +96,7 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-- 
2.30.2

