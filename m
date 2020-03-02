Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9551768CF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgCBX7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:59:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384680"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 19/66] KVM: VMX: Add helpers to query Intel PT mode
Date:   Mon,  2 Mar 2020 15:56:22 -0800
Message-Id: <20200302235709.27467-20-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to query which of the (two) supported PT modes is active.
The primary motivation is to help document that there is a third PT mode
(host-only) that's currently not supported by KVM.  As is, it's not
obvious that PT_MODE_SYSTEM != !PT_MODE_HOST_GUEST and vice versa, e.g.
that "pt_mode == PT_MODE_SYSTEM" and "pt_mode != PT_MODE_HOST_GUEST" are
two distinct checks.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h          |  4 ++--
 4 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f486e2606247..80eec8cffbe2 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -354,4 +354,22 @@ static inline bool cpu_has_vmx_intel_pt(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
 
+/*
+ * Processor Trace can operate in one of three modes:
+ *  a. system-wide: trace both host/guest and output to host buffer
+ *  b. host-only:   only trace host and output to host buffer
+ *  c. host-guest:  trace host and guest simultaneously and output to their
+ *                  respective buffer
+ *
+ * KVM currently only supports (a) and (c).
+ */
+static inline bool vmx_pt_mode_is_system(void)
+{
+	return pt_mode == PT_MODE_SYSTEM;
+}
+static inline bool vmx_pt_mode_is_host_guest(void)
+{
+	return pt_mode == PT_MODE_HOST_GUEST;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0946122a8d3b..ae84b3c66e0d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4602,7 +4602,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
 
-	if (pt_mode == PT_MODE_HOST_GUEST) {
+	if (vmx_pt_mode_is_host_guest()) {
 		vmx->pt_desc.guest.ctl = 0;
 		pt_update_intercept_for_msr(vmx);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a04017bdae05..2dcf27e3a7a6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1059,7 +1059,7 @@ static unsigned long segment_base(u16 selector)
 
 static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
 {
-	return (pt_mode == PT_MODE_HOST_GUEST) &&
+	return vmx_pt_mode_is_host_guest() &&
 	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 }
 
@@ -1093,7 +1093,7 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
 
 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
-	if (pt_mode == PT_MODE_SYSTEM)
+	if (vmx_pt_mode_is_system())
 		return;
 
 	/*
@@ -1110,7 +1110,7 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 
 static void pt_guest_exit(struct vcpu_vmx *vmx)
 {
-	if (pt_mode == PT_MODE_SYSTEM)
+	if (vmx_pt_mode_is_system())
 		return;
 
 	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
@@ -1904,24 +1904,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-		if (pt_mode != PT_MODE_HOST_GUEST)
+		if (!vmx_pt_mode_is_host_guest())
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
-		if (pt_mode != PT_MODE_HOST_GUEST)
+		if (!vmx_pt_mode_is_host_guest())
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
+		if (!vmx_pt_mode_is_host_guest() ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
 			return 1;
 		msr_info->data = vmx->pt_desc.guest.cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
+		if (!vmx_pt_mode_is_host_guest() ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1930,7 +1930,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vmx->pt_desc.guest.output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
+		if (!vmx_pt_mode_is_host_guest() ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
@@ -1940,7 +1940,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
+		if (!vmx_pt_mode_is_host_guest() ||
 			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
@@ -2146,7 +2146,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
-		if ((pt_mode != PT_MODE_HOST_GUEST) ||
+		if (!vmx_pt_mode_is_host_guest() ||
 			vmx_rtit_ctl_check(vcpu, data) ||
 			vmx->nested.vmxon)
 			return 1;
@@ -4024,7 +4024,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 	u32 exec_control = vmcs_config.cpu_based_2nd_exec_ctrl;
 
-	if (pt_mode == PT_MODE_SYSTEM)
+	if (vmx_pt_mode_is_system())
 		exec_control &= ~(SECONDARY_EXEC_PT_USE_GPA | SECONDARY_EXEC_PT_CONCEAL_VMX);
 	if (!cpu_need_virtualize_apic_accesses(vcpu))
 		exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
@@ -4265,7 +4265,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
 
-	if (pt_mode == PT_MODE_HOST_GUEST) {
+	if (vmx_pt_mode_is_host_guest()) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
 		/* Bit[6~0] are forced to 1, writes are ignored. */
 		vmx->pt_desc.guest.output_mask = 0x7F;
@@ -6314,7 +6314,7 @@ static bool vmx_has_emulated_msr(int index)
 
 static bool vmx_pt_supported(void)
 {
-	return pt_mode == PT_MODE_HOST_GUEST;
+	return vmx_pt_mode_is_host_guest();
 }
 
 static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06c7009..9a51a3a77233 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -452,7 +452,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 static inline u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
-	if (pt_mode == PT_MODE_SYSTEM)
+	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
@@ -463,7 +463,7 @@ static inline u32 vmx_vmentry_ctrl(void)
 static inline u32 vmx_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
-	if (pt_mode == PT_MODE_SYSTEM)
+	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-- 
2.24.1

