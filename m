Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F7B34C345
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhC2Fuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:50:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhC2FuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:50:14 -0400
IronPort-SDR: IHgzc0ppDbQ7KJX4ymut1QS0INGxii+YrIvWbeRE5o7dZYXgKGDnZWHDtmcUZ9qDi15F3f0LBl
 ExS343Gcy5JQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478761"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478761"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:50:13 -0700
IronPort-SDR: PbnLHocxv/0fpwu+6XV1lk7VnUbrwtLJ7UxYcuJeONvSKzVVmcnjLEdpIVJ6TvCZyisF4z0FHd
 ibaseluhBPuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417507057"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:50:10 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 13/16] KVM: x86/pmu: Disable guest PEBS before vm-entry in two cases
Date:   Mon, 29 Mar 2021 13:41:34 +0800
Message-Id: <20210329054137.120994-14-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest PEBS will be disabled when some users try to perf KVM and
its user-space through the same PEBS facility OR when the host perf
doesn't schedule the guest PEBS counter in a one-to-one mapping manner
(neither of these are typical scenarios).

The PEBS records in the guest DS buffer is still accurate and the
above two restrictions will be checked before each vm-entry only if
guest PEBS is deemed to be enabled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c    |  8 +++++++-
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 3bbdfc4f6931..20ee1b3fd06b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3858,7 +3858,13 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	if (pmu && x86_pmu.pebs) {
 		arr[1].msr = MSR_IA32_PEBS_ENABLE;
 		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
-		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+		if (!arr[1].host) {
+			arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+			/* Disable guest PEBS for cross-mapped PEBS counters. */
+			arr[1].guest &= ~pmu->host_cross_mapped_mask;
+		} else
+			/* Disable guest PEBS if host PEBS is enabled. */
+			arr[1].guest = 0;
 
 		arr[2].msr = MSR_IA32_DS_AREA;
 		arr[2].host = (unsigned long)ds;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94366da2dfee..cfb5467be7e6 100644
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
index 4dcf66e6c398..55caa941e336 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -767,6 +767,22 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+{
+	struct kvm_pmc *pmc = NULL;
+	int bit;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+			continue;
+
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx))
+			pmu->host_cross_mapped_mask |= BIT_ULL(pmc->perf_event->hw.idx);
+	}
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 594c058f6f0f..966fa7962808 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6516,6 +6516,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
index 0fb3236b0283..0029aaad8eda 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -96,6 +96,7 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-- 
2.29.2

