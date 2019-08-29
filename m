Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32DFDA10F8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfH2FjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:39:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:42165 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfH2FjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:39:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:39:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416286"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:39:16 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 6/9] KVM: x86: Add shadow value of PEBS status
Date:   Thu, 29 Aug 2019 13:34:06 +0800
Message-Id: <1567056849-14608-7-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The performance counter used by guest perspective may different
with the counter allocated from real hardware (e.g. Guest driver
get counter 0 for PEBS but the host PMU driver may alloc other
counters for this event).

Introduce a new parameter for the mapping of PEBS enable status from
guest to real hardware. Update the shadow value of PEBS before
VM-entry when PT is enabled in guest.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/vmx/vmx.c          |  8 +++++++-
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b930b5..07d3b21 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -473,6 +473,7 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
 	u64 pebs_enable;
+	u64 pebs_enable_shadow;
 	u64 pebs_enable_mask;
 	u8 version;
 	bool pebs_pt;	/* PEBS output to Intel PT */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 6bdc282..89d3e4c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -257,6 +257,40 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
+void kvm_pmu_pebs_shadow(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+	int i;
+
+	if (!pmu->pebs_pt)
+		return;
+
+	pmu->pebs_enable_shadow = MSR_IA32_PEBS_OUTPUT_PT;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		if (!test_bit(i, (unsigned long *)&pmu->pebs_enable))
+			continue;
+
+		event = pmu->gp_counters[i].perf_event;
+		if (event && (event->hw.idx != -1))
+			set_bit(event->hw.idx,
+				(unsigned long *)&pmu->pebs_enable_shadow);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		if (!test_bit(i + INTEL_PMC_IDX_FIXED,
+					(unsigned long *)&pmu->pebs_enable))
+			continue;
+
+		event = pmu->fixed_counters[i].perf_event;
+		if (event && (event->hw.idx != -1))
+			set_bit(event->hw.idx,
+				(unsigned long *)&pmu->pebs_enable_shadow);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_pebs_shadow);
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0c59a15..81c35c9 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -119,6 +119,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx,
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_pmu_pebs_shadow(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c030c96..4090c08 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1019,6 +1019,7 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_IA32_RTIT_CTL, 0);
 		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
 		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
+		kvm_pmu_pebs_shadow(&vmx->vcpu);
 	}
 }
 
@@ -6365,12 +6366,17 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
-	for (i = 0; i < nr_msrs; i++)
+	for (i = 0; i < nr_msrs; i++) {
+		if (msrs[i].msr == MSR_IA32_PEBS_ENABLE)
+			msrs[i].guest =
+				vcpu_to_pmu(&vmx->vcpu)->pebs_enable_shadow;
+
 		if (msrs[i].host == msrs[i].guest)
 			clear_atomic_switch_msr(vmx, msrs[i].msr);
 		else
 			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
 					msrs[i].host, false);
+	}
 }
 
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
-- 
1.8.3.1

