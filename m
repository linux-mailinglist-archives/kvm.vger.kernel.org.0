Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3372E95F8
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbhADN3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:29:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:23242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbhADN3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:29:07 -0500
IronPort-SDR: /p4PNWsAiwyDZjxp1I1+u/0dKDU8A/HqUWoKOS+EPhplqNig7Fq2rscVeCabDdocLCnaHVXaKE
 PVpDAOW6BYwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034382"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034382"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:39 -0800
IronPort-SDR: MfCm3DJ8qA3KJSkleaVGOGTNFA5J6/ZgQM+1ZXpfTVL1bXj4NeIXO1ySHba0R7N1/TtzbHvBXv
 wHWzPbXfk42Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944637"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:36 -0800
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
Subject: [PATCH v3 12/17] KVM: x86/pmu: Disable guest PEBS when counters are cross-mapped
Date:   Mon,  4 Jan 2021 21:15:37 +0800
Message-Id: <20210104131542.495413-13-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
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
index 4ff6aa00a325..5de4c14cf526 100644
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
index 67c20ab81991..3bfed803ed17 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -550,3 +550,28 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
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
index 341794b67f9a..bc30c83e0a62 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6542,6 +6542,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
+	if (pmu->counter_cross_mapped)
+		msrs[1].guest = 0;
+
 	if (nr_msrs > 2 && msrs[1].guest) {
 		msrs[2].guest = pmu->ds_area;
 		if (nr_msrs > 3)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 213368e47500..4ab1ce26244d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8936,6 +8936,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
2.29.2

