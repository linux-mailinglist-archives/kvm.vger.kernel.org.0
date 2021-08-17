Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03843EE9E8
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhHQJcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237640AbhHQJcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111532"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111532"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200730"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:37 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 4/5] KVM: x86: nVMX: Respect vmcs12 field existence when calc vmx_vmcs_enum_msr
Date:   Tue, 17 Aug 2021 17:31:12 +0800
Message-Id: <1629192673-9911-5-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check each fields existence when calculating vmx_vmcs_enum_msr.
Note, in initial nested VMX Ctrl MSRs setup, the early stage before VM is
created, we have no idea about VMX features user space would set, therefore
set to raw physical MSR's value for user space's reference.
After vCPU features are settled, we update dynamic field's existence.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 15 ++++++++++++---
 arch/x86/kvm/vmx/nested.h |  1 +
 arch/x86/kvm/vmx/vmx.c    |  5 ++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9a35953ede22..9a733c703662 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6421,8 +6421,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
  * that madness to get the encoding for comparison.
  */
 #define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) << 10)))
-
-static u64 nested_vmx_calc_vmcs_enum_msr(void)
+u64 nested_vmx_calc_vmcs_enum_msr(struct nested_vmx *nvmx)
 {
 	/*
 	 * Note these are the so called "index" of the VMCS field encoding, not
@@ -6442,6 +6441,15 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
 		if (!vmcs_field_to_offset_table[i])
 			continue;
 
+		if (unlikely(!nvmx->vmcs12_field_existence_bitmap)) {
+			WARN_ON(1);
+			break;
+		}
+
+		if (!test_bit(vmcs_field_to_offset_table[i] / sizeof(u16),
+		    nvmx->vmcs12_field_existence_bitmap))
+			continue;
+
 		idx = vmcs_field_index(VMCS12_IDX_TO_ENC(i));
 		if (idx > max_idx)
 			max_idx = idx;
@@ -6695,7 +6703,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, msrs->cr0_fixed1);
 	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, msrs->cr4_fixed1);
 
-	msrs->vmcs_enum = nested_vmx_calc_vmcs_enum_msr();
+	/* In initial setup, simply read HW value for reference */
+	rdmsrl(MSR_IA32_VMX_VMCS_ENUM, msrs->vmcs_enum);
 }
 
 void nested_vmx_hardware_unsetup(void)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b69a80f43b37..34235d276aad 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -36,6 +36,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
+u64 nested_vmx_calc_vmcs_enum_msr(struct nested_vmx *nvmx);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ab37e1d04c9..f44a4971cc8d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7156,10 +7156,13 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmcs_set_secondary_exec_control(vmx);
 	}
 
-	if (nested_vmx_allowed(vcpu))
+	if (nested_vmx_allowed(vcpu)) {
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
+		to_vmx(vcpu)->nested.msrs.vmcs_enum =
+			nested_vmx_calc_vmcs_enum_msr(&to_vmx(vcpu)->nested);
+	}
 	else
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
-- 
2.27.0

