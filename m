Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3382AAF54
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgKICRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:64940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgKICRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:37 -0500
IronPort-SDR: Ws6tJ+zf5G9pBov7LRJhxm6i+WioelD+wzbqmXNmmx7vMBGlAcCKFLwmWN186atkmdrK7krC00
 SSKzXD+a7LBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684643"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684643"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:37 -0800
IronPort-SDR: 7nKCYl2yFX8BOSYMCTa6Ta/+e0A7wA1AbacO7XmTF+JimBkHnJ6ohCNdjyZoKZP4ubt3PV9cZu
 rs/JoiyPWltQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646251"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:33 -0800
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
Subject: [PATCH v2 12/17] KVM: x86/pmu: Disable guest PEBS when counters are cross-mapped
Date:   Mon,  9 Nov 2020 10:12:49 +0800
Message-Id: <20201109021254.79755-13-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM will check if a guest PEBS counter X is cross-mapped to the host
counter Y. In this case, the applicable_counter field in the guest PEBS
records is filled with the real host counter index(s) which is incorrect.

Currently, KVM will disable guest PEBS before vm-entry and the later
patches would do more emulations in the KVM to keep PEBS functionality
work as host, such as rewriting applicable_counter field in the guest
PEBS records buffer.

The cross-mapped check should be done right before vm-entry but after
local_irq_disable() since perf scheduler would rotate the pmc->perf_event
to another host counter or make the event into error state via hrtimer irq.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              | 25 +++++++++++++++++++++++++
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 arch/x86/kvm/x86.c              |  4 ++++
 5 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 37df29061a4d..bffb384485da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -455,6 +455,8 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
+	bool counter_cross_mapped;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f8aa4724d67b..a6c5951a5728 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -549,3 +549,28 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+/*
+ * The caller needs to ensure that there is no time window for
+ * perf hrtimer irq or any chance to reschedule pmc->perf_event.
+ */
+void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	int bit;
+
+	pmu->counter_cross_mapped = false;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+			continue;
+
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx)) {
+			pmu->counter_cross_mapped = true;
+			break;
+		}
+	}
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ee8f15cc4b5e..f5ec94e9a1dc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -163,6 +163,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b62907c8959..302808ec9699 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6556,6 +6556,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
+	if (pmu->counter_cross_mapped)
+		msrs[1].guest = 0;
+
 	if (nr_msrs > 2 && msrs[1].guest) {
 		msrs[2].guest = pmu->ds_area;
 		if (nr_msrs > 3)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5963a36bf6b..88a544e6379f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8859,6 +8859,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * result in virtual interrupt delivery.
 	 */
 	local_irq_disable();
+
+	if (vcpu_to_pmu(vcpu)->global_ctrl & vcpu_to_pmu(vcpu)->pebs_enable)
+		kvm_pmu_counter_cross_mapped_check(vcpu);
+
 	vcpu->mode = IN_GUEST_MODE;
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-- 
2.21.3

