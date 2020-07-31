Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C04233D51
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgGaCmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730820AbgGaCmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:35 -0400
IronPort-SDR: wbFsjgTSg0Io2CPp6ghQ5ZfggKDtOo4fycjdiP6oMOGAZL0txY5D6MVevSM9F0+skpxdYkBNrQ
 K/ytRzQgIKsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290113"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290113"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:34 -0700
IronPort-SDR: gipBNjpKGibwZ96f9jHyvYi+u0BdmRvOkg8PISFMQIYTrJT2IGHSwCcBCaCFjMzE4WeAhdFUoy
 NYj/3sFegQdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304805950"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:32 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 1/9] KVM:x86: Abstract sub functions from kvm_update_cpuid_runtime() and kvm_vcpu_after_set_cpuid()
Date:   Fri, 31 Jul 2020 10:42:19 +0800
Message-Id: <1596163347-18574-2-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add below functions, whose aggregation equals kvm_update_cpuid_runtime() and
kvm_vcpu_after_set_cpuid().

void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
static void kvm_pv_unhalt_update_cpuid(struct kvm_vcpu *vcpu)
static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)

And, for some among the above, avoid double check set or clear inside function
body, but provided by caller.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/cpuid.h |  6 ++++
 2 files changed, 105 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7d92854..efa7182 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -73,6 +73,105 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+
+	if (best && boot_cpu_has(X86_FEATURE_XSAVE)) {
+		cpuid_entry_change(best, X86_FEATURE_OSXSAVE, set);
+	}
+}
+
+void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+
+	if (best && boot_cpu_has(X86_FEATURE_PKU)) {
+		cpuid_entry_change(best, X86_FEATURE_OSPKE, set);
+	}
+}
+
+void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	if (!best) {
+		vcpu->arch.guest_supported_xcr0 = 0;
+	} else {
+		vcpu->arch.guest_supported_xcr0 =
+			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
+	}
+
+	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	if (!best)
+		return;
+	if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
+				cpuid_entry_has(best, X86_FEATURE_XSAVEC))
+		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+}
+
+static void kvm_pv_unhalt_update_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
+					(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+}
+
+void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	if (best)
+		cpuid_entry_change(best, X86_FEATURE_MWAIT, set);
+}
+
+static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
+{
+
+	/* Note, maxphyaddr must be updated before tdp_level. */
+	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
+	kvm_mmu_reset_context(vcpu);
+}
+
+void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	if (!best)
+		return;
+
+	cpuid_entry_change(best, X86_FEATURE_APIC, set);
+}
+
+static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	if (!best)
+		return;
+
+	if (apic) {
+		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
+			apic->lapic_timer.timer_mode_mask = 3 << 17;
+		else
+			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	}
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3a923ae..7eabb44 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -9,6 +9,12 @@
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
+void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu);
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
-- 
1.8.3.1

