Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887823E2BA8
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344395AbhHFNkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:40:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:4281 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344351AbhHFNjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:39:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214398071"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214398071"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:34 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463758"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:29 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 15/18] KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
Date:   Fri,  6 Aug 2021 21:37:59 +0800
Message-Id: <20210806133802.3528-16-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The guest PEBS will be disabled when some users try to perf KVM and
its user-space through the same PEBS facility OR when the host perf
doesn't schedule the guest PEBS counter in a one-to-one mapping manner
(neither of these are typical scenarios).

The PEBS records in the guest DS buffer are still accurate and the
above two restrictions will be checked before each vm-entry only if
guest PEBS is deemed to be enabled.

Suggested-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 11 +++++++++--
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a698aae54fcb..8fa0b57989f6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3975,8 +3975,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
 	};
 
-	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-	arr[0].guest |= arr[*nr].guest;
+	if (arr[pebs_enable].host) {
+		/* Disable guest PEBS if host PEBS is enabled. */
+		arr[pebs_enable].guest = 0;
+	} else {
+		/* Disable guest PEBS for cross-mapped PEBS counters. */
+		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+		arr[global_ctrl].guest |= arr[pebs_enable].guest;
+	}
 
 	return arr;
 }
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0fc1fef1af70..637685485ddd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,6 +511,15 @@ struct kvm_pmu {
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
index 296246bf253d..afdc9796fe4e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -770,6 +770,26 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
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
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx)) {
+			pmu->host_cross_mapped_mask |=
+				BIT_ULL(pmc->perf_event->hw.idx);
+		}
+	}
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 063e869b4e19..d8552dbece6f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6514,6 +6514,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
index db88ed4f2121..86fa1a08feca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -94,6 +94,7 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-- 
2.27.0

