Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2E65B1D
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 17:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfGKP6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 11:58:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:21774 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfGKP6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 11:58:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 08:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="365312099"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jul 2019 08:58:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: nVMX: add tracepoint for failed nested VM-Enter
Date:   Thu, 11 Jul 2019 08:58:29 -0700
Message-Id: <20190711155830.15178-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190711155830.15178-1-sean.j.christopherson@intel.com>
References: <20190711155830.15178-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Debugging a failed VM-Enter is often like searching for a needle in a
haystack, e.g. there are over 80 consistency checks that funnel into
the "invalid control field" error code.  One way to expedite debug is
to run the buggy code as an L1 guest under KVM (and pray that the
failing check is detected by KVM).  However, extracting useful debug
information out of L0 KVM requires attaching a debugger to KVM and/or
modifying the source, e.g. to log which check is failing.

Make life a little less painful for VMM developers and add a tracepoint
for failed VM-Enter consistency checks.  Ideally the tracepoint would
capture both what check failed and precisely why it failed, but logging
why a checked failed is difficult to do in a generic tracepoint without
resorting to invasive techniques, e.g. generating a custom string on
failure.  That being said, for the vast majority of VM-Enter failures
the most difficult step is figuring out exactly what to look at, e.g.
figuring out which bit was incorrectly set in a control field is usually
not too painful once the guilty field as been identified.

To reach a happy medium between precision and ease of use, simply log
the code that detected a failed check, using a macro to execute the
check and log the trace event on failure.  This approach enables tracing
arbitrary code, e.g. it's not limited to function calls or specific
formats of checks, and the changes to the existing code are minimally
invasive.  A macro with a two-character name is desirable as usage of
the macro doesn't result in overly long lines or confusing alignment,
while still retaining some amount of readability.  I.e. a one-character
name is a little too terse, and a three-character name results in the
contents being passed to the macro aligning with an indented line when
the macro is used an in if-statement, e.g.:

        if (VCC(nested_vmx_check_long_line_one(...) &&
                nested_vmx_check_long_line_two(...)))
                return -EINVAL;

And that is the story of how the CC(), a.k.a. Consistency Check, macro
got its name.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/trace.h      |  19 +++
 arch/x86/kvm/vmx/nested.c | 256 ++++++++++++++++++++------------------
 arch/x86/kvm/x86.c        |   1 +
 3 files changed, 153 insertions(+), 123 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e79094..50fbe2d5db83 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1462,6 +1462,25 @@ TRACE_EVENT(kvm_hv_send_ipi_ex,
 		  __entry->vector, __entry->format,
 		  __entry->valid_bank_mask)
 );
+
+/*
+ * Tracepoint for failed nested VMX VM-Enter.
+ */
+TRACE_EVENT(kvm_nested_vmenter_failed,
+	TP_PROTO(const char *msg),
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__field(const char *, msg)
+	),
+
+	TP_fast_assign(
+		__entry->msg = msg;
+	),
+
+	TP_printk("%s", __entry->msg)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e88f459b323..85bb5fc5028f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -19,6 +19,14 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __read_mostly nested_early_check = 0;
 module_param(nested_early_check, bool, S_IRUGO);
 
+#define CC(consistency_check)						\
+({									\
+	bool failed = (consistency_check);				\
+	if (failed)							\
+		trace_kvm_nested_vmenter_failed(#consistency_check);	\
+	failed;								\
+})
+
 /*
  * Hyper-V requires all of these, so mark them as supported even though
  * they are just treated the same as all-context.
@@ -425,8 +433,8 @@ static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
 		return 0;
 
-	if (!page_address_valid(vcpu, vmcs12->io_bitmap_a) ||
-	    !page_address_valid(vcpu, vmcs12->io_bitmap_b))
+	if (CC(!page_address_valid(vcpu, vmcs12->io_bitmap_a)) ||
+	    CC(!page_address_valid(vcpu, vmcs12->io_bitmap_b)))
 		return -EINVAL;
 
 	return 0;
@@ -438,7 +446,7 @@ static int nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
 		return 0;
 
-	if (!page_address_valid(vcpu, vmcs12->msr_bitmap))
+	if (CC(!page_address_valid(vcpu, vmcs12->msr_bitmap)))
 		return -EINVAL;
 
 	return 0;
@@ -450,7 +458,7 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
 		return 0;
 
-	if (!page_address_valid(vcpu, vmcs12->virtual_apic_page_addr))
+	if (CC(!page_address_valid(vcpu, vmcs12->virtual_apic_page_addr)))
 		return -EINVAL;
 
 	return 0;
@@ -683,7 +691,7 @@ static int nested_vmx_check_apic_access_controls(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) &&
-	    !page_address_valid(vcpu, vmcs12->apic_access_addr))
+	    CC(!page_address_valid(vcpu, vmcs12->apic_access_addr)))
 		return -EINVAL;
 	else
 		return 0;
@@ -702,16 +710,15 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 	 * If virtualize x2apic mode is enabled,
 	 * virtualize apic access must be disabled.
 	 */
-	if (nested_cpu_has_virt_x2apic_mode(vmcs12) &&
-	    nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+	if (CC(nested_cpu_has_virt_x2apic_mode(vmcs12) &&
+	       nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)))
 		return -EINVAL;
 
 	/*
 	 * If virtual interrupt delivery is enabled,
 	 * we must exit on external interrupts.
 	 */
-	if (nested_cpu_has_vid(vmcs12) &&
-	   !nested_exit_on_intr(vcpu))
+	if (CC(nested_cpu_has_vid(vmcs12) && !nested_exit_on_intr(vcpu)))
 		return -EINVAL;
 
 	/*
@@ -722,15 +729,15 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 	 * bits 5:0 of posted_intr_desc_addr should be zero.
 	 */
 	if (nested_cpu_has_posted_intr(vmcs12) &&
-	   (!nested_cpu_has_vid(vmcs12) ||
-	    !nested_exit_intr_ack_set(vcpu) ||
-	    (vmcs12->posted_intr_nv & 0xff00) ||
-	    (vmcs12->posted_intr_desc_addr & 0x3f) ||
-	    (vmcs12->posted_intr_desc_addr >> cpuid_maxphyaddr(vcpu))))
+	   (CC(!nested_cpu_has_vid(vmcs12)) ||
+	    CC(!nested_exit_intr_ack_set(vcpu)) ||
+	    CC((vmcs12->posted_intr_nv & 0xff00)) ||
+	    CC((vmcs12->posted_intr_desc_addr & 0x3f)) ||
+	    CC((vmcs12->posted_intr_desc_addr >> cpuid_maxphyaddr(vcpu)))))
 		return -EINVAL;
 
 	/* tpr shadow is needed by all apicv features. */
-	if (!nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+	if (CC(!nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)))
 		return -EINVAL;
 
 	return 0;
@@ -754,10 +761,12 @@ static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_exit_msr_switch_controls(struct kvm_vcpu *vcpu,
 						     struct vmcs12 *vmcs12)
 {
-	if (nested_vmx_check_msr_switch(vcpu, vmcs12->vm_exit_msr_load_count,
-					vmcs12->vm_exit_msr_load_addr) ||
-	    nested_vmx_check_msr_switch(vcpu, vmcs12->vm_exit_msr_store_count,
-					vmcs12->vm_exit_msr_store_addr))
+	if (CC(nested_vmx_check_msr_switch(vcpu,
+					   vmcs12->vm_exit_msr_load_count,
+					   vmcs12->vm_exit_msr_load_addr)) ||
+	    CC(nested_vmx_check_msr_switch(vcpu,
+					   vmcs12->vm_exit_msr_store_count,
+					   vmcs12->vm_exit_msr_store_addr)))
 		return -EINVAL;
 
 	return 0;
@@ -766,8 +775,9 @@ static int nested_vmx_check_exit_msr_switch_controls(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_entry_msr_switch_controls(struct kvm_vcpu *vcpu,
                                                       struct vmcs12 *vmcs12)
 {
-	if (nested_vmx_check_msr_switch(vcpu, vmcs12->vm_entry_msr_load_count,
-                                        vmcs12->vm_entry_msr_load_addr))
+	if (CC(nested_vmx_check_msr_switch(vcpu,
+					   vmcs12->vm_entry_msr_load_count,
+					   vmcs12->vm_entry_msr_load_addr)))
                 return -EINVAL;
 
 	return 0;
@@ -779,8 +789,8 @@ static int nested_vmx_check_pml_controls(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has_pml(vmcs12))
 		return 0;
 
-	if (!nested_cpu_has_ept(vmcs12) ||
-	    !page_address_valid(vcpu, vmcs12->pml_address))
+	if (CC(!nested_cpu_has_ept(vmcs12)) ||
+	    CC(!page_address_valid(vcpu, vmcs12->pml_address)))
 		return -EINVAL;
 
 	return 0;
@@ -789,8 +799,8 @@ static int nested_vmx_check_pml_controls(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_unrestricted_guest_controls(struct kvm_vcpu *vcpu,
 							struct vmcs12 *vmcs12)
 {
-	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST) &&
-	    !nested_cpu_has_ept(vmcs12))
+	if (CC(nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST) &&
+	       !nested_cpu_has_ept(vmcs12)))
 		return -EINVAL;
 	return 0;
 }
@@ -798,8 +808,8 @@ static int nested_vmx_check_unrestricted_guest_controls(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_mode_based_ept_exec_controls(struct kvm_vcpu *vcpu,
 							 struct vmcs12 *vmcs12)
 {
-	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_MODE_BASED_EPT_EXEC) &&
-	    !nested_cpu_has_ept(vmcs12))
+	if (CC(nested_cpu_has2(vmcs12, SECONDARY_EXEC_MODE_BASED_EPT_EXEC) &&
+	       !nested_cpu_has_ept(vmcs12)))
 		return -EINVAL;
 	return 0;
 }
@@ -810,8 +820,8 @@ static int nested_vmx_check_shadow_vmcs_controls(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has_shadow_vmcs(vmcs12))
 		return 0;
 
-	if (!page_address_valid(vcpu, vmcs12->vmread_bitmap) ||
-	    !page_address_valid(vcpu, vmcs12->vmwrite_bitmap))
+	if (CC(!page_address_valid(vcpu, vmcs12->vmread_bitmap)) ||
+	    CC(!page_address_valid(vcpu, vmcs12->vmwrite_bitmap)))
 		return -EINVAL;
 
 	return 0;
@@ -821,12 +831,12 @@ static int nested_vmx_msr_check_common(struct kvm_vcpu *vcpu,
 				       struct vmx_msr_entry *e)
 {
 	/* x2APIC MSR accesses are not allowed */
-	if (vcpu->arch.apic_base & X2APIC_ENABLE && e->index >> 8 == 0x8)
+	if (CC(vcpu->arch.apic_base & X2APIC_ENABLE && e->index >> 8 == 0x8))
 		return -EINVAL;
-	if (e->index == MSR_IA32_UCODE_WRITE || /* SDM Table 35-2 */
-	    e->index == MSR_IA32_UCODE_REV)
+	if (CC(e->index == MSR_IA32_UCODE_WRITE) || /* SDM Table 35-2 */
+	    CC(e->index == MSR_IA32_UCODE_REV))
 		return -EINVAL;
-	if (e->reserved != 0)
+	if (CC(e->reserved != 0))
 		return -EINVAL;
 	return 0;
 }
@@ -834,9 +844,9 @@ static int nested_vmx_msr_check_common(struct kvm_vcpu *vcpu,
 static int nested_vmx_load_msr_check(struct kvm_vcpu *vcpu,
 				     struct vmx_msr_entry *e)
 {
-	if (e->index == MSR_FS_BASE ||
-	    e->index == MSR_GS_BASE ||
-	    e->index == MSR_IA32_SMM_MONITOR_CTL || /* SMM is not supported */
+	if (CC(e->index == MSR_FS_BASE) ||
+	    CC(e->index == MSR_GS_BASE) ||
+	    CC(e->index == MSR_IA32_SMM_MONITOR_CTL) || /* SMM is not supported */
 	    nested_vmx_msr_check_common(vcpu, e))
 		return -EINVAL;
 	return 0;
@@ -845,7 +855,7 @@ static int nested_vmx_load_msr_check(struct kvm_vcpu *vcpu,
 static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 				      struct vmx_msr_entry *e)
 {
-	if (e->index == MSR_IA32_SMBASE || /* SMM is not supported */
+	if (CC(e->index == MSR_IA32_SMBASE) || /* SMM is not supported */
 	    nested_vmx_msr_check_common(vcpu, e))
 		return -EINVAL;
 	return 0;
@@ -950,7 +960,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 			       u32 *entry_failure_code)
 {
 	if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
-		if (!nested_cr3_valid(vcpu, cr3)) {
+		if (CC(!nested_cr3_valid(vcpu, cr3))) {
 			*entry_failure_code = ENTRY_FAIL_DEFAULT;
 			return -EINVAL;
 		}
@@ -960,7 +970,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		 * must not be dereferenced.
 		 */
 		if (is_pae_paging(vcpu) && !nested_ept) {
-			if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
+			if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
 				*entry_failure_code = ENTRY_FAIL_PDPTE;
 				return -EINVAL;
 			}
@@ -2400,12 +2410,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 static int nested_vmx_check_nmi_controls(struct vmcs12 *vmcs12)
 {
-	if (!nested_cpu_has_nmi_exiting(vmcs12) &&
-	    nested_cpu_has_virtual_nmis(vmcs12))
+	if (CC(!nested_cpu_has_nmi_exiting(vmcs12) &&
+	       nested_cpu_has_virtual_nmis(vmcs12)))
 		return -EINVAL;
 
-	if (!nested_cpu_has_virtual_nmis(vmcs12) &&
-	    nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_NMI_PENDING))
+	if (CC(!nested_cpu_has_virtual_nmis(vmcs12) &&
+	       nested_cpu_has(vmcs12, CPU_BASED_VIRTUAL_NMI_PENDING)))
 		return -EINVAL;
 
 	return 0;
@@ -2419,11 +2429,11 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 	/* Check for memory type validity */
 	switch (address & VMX_EPTP_MT_MASK) {
 	case VMX_EPTP_MT_UC:
-		if (!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT))
+		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT)))
 			return false;
 		break;
 	case VMX_EPTP_MT_WB:
-		if (!(vmx->nested.msrs.ept_caps & VMX_EPTP_WB_BIT))
+		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_WB_BIT)))
 			return false;
 		break;
 	default:
@@ -2431,16 +2441,16 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 	}
 
 	/* only 4 levels page-walk length are valid */
-	if ((address & VMX_EPTP_PWL_MASK) != VMX_EPTP_PWL_4)
+	if (CC((address & VMX_EPTP_PWL_MASK) != VMX_EPTP_PWL_4))
 		return false;
 
 	/* Reserved bits should not be set */
-	if (address >> maxphyaddr || ((address >> 7) & 0x1f))
+	if (CC(address >> maxphyaddr || ((address >> 7) & 0x1f)))
 		return false;
 
 	/* AD, if set, should be supported */
 	if (address & VMX_EPTP_AD_ENABLE_BIT) {
-		if (!(vmx->nested.msrs.ept_caps & VMX_EPT_AD_BIT))
+		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_AD_BIT)))
 			return false;
 	}
 
@@ -2455,21 +2465,21 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx_control_verify(vmcs12->pin_based_vm_exec_control,
-				vmx->nested.msrs.pinbased_ctls_low,
-				vmx->nested.msrs.pinbased_ctls_high) ||
-	    !vmx_control_verify(vmcs12->cpu_based_vm_exec_control,
-				vmx->nested.msrs.procbased_ctls_low,
-				vmx->nested.msrs.procbased_ctls_high))
+	if (CC(!vmx_control_verify(vmcs12->pin_based_vm_exec_control,
+				   vmx->nested.msrs.pinbased_ctls_low,
+				   vmx->nested.msrs.pinbased_ctls_high)) ||
+	    CC(!vmx_control_verify(vmcs12->cpu_based_vm_exec_control,
+				   vmx->nested.msrs.procbased_ctls_low,
+				   vmx->nested.msrs.procbased_ctls_high)))
 		return -EINVAL;
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
-	    !vmx_control_verify(vmcs12->secondary_vm_exec_control,
-				 vmx->nested.msrs.secondary_ctls_low,
-				 vmx->nested.msrs.secondary_ctls_high))
+	    CC(!vmx_control_verify(vmcs12->secondary_vm_exec_control,
+				   vmx->nested.msrs.secondary_ctls_low,
+				   vmx->nested.msrs.secondary_ctls_high)))
 		return -EINVAL;
 
-	if (vmcs12->cr3_target_count > nested_cpu_vmx_misc_cr3_count(vcpu) ||
+	if (CC(vmcs12->cr3_target_count > nested_cpu_vmx_misc_cr3_count(vcpu)) ||
 	    nested_vmx_check_io_bitmap_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_msr_bitmap_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_tpr_shadow_controls(vcpu, vmcs12) ||
@@ -2480,7 +2490,7 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 	    nested_vmx_check_unrestricted_guest_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_mode_based_ept_exec_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_shadow_vmcs_controls(vcpu, vmcs12) ||
-	    (nested_cpu_has_vpid(vmcs12) && !vmcs12->virtual_processor_id))
+	    CC(nested_cpu_has_vpid(vmcs12) && !vmcs12->virtual_processor_id))
 		return -EINVAL;
 
 	if (!nested_cpu_has_preemption_timer(vmcs12) &&
@@ -2488,17 +2498,17 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (nested_cpu_has_ept(vmcs12) &&
-	    !valid_ept_address(vcpu, vmcs12->ept_pointer))
+	    CC(!valid_ept_address(vcpu, vmcs12->ept_pointer)))
 		return -EINVAL;
 
 	if (nested_cpu_has_vmfunc(vmcs12)) {
-		if (vmcs12->vm_function_control &
-		    ~vmx->nested.msrs.vmfunc_controls)
+		if (CC(vmcs12->vm_function_control &
+		       ~vmx->nested.msrs.vmfunc_controls))
 			return -EINVAL;
 
 		if (nested_cpu_has_eptp_switching(vmcs12)) {
-			if (!nested_cpu_has_ept(vmcs12) ||
-			    !page_address_valid(vcpu, vmcs12->eptp_list_address))
+			if (CC(!nested_cpu_has_ept(vmcs12)) ||
+			    CC(!page_address_valid(vcpu, vmcs12->eptp_list_address)))
 				return -EINVAL;
 		}
 	}
@@ -2514,10 +2524,10 @@ static int nested_check_vm_exit_controls(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx_control_verify(vmcs12->vm_exit_controls,
-				vmx->nested.msrs.exit_ctls_low,
-				vmx->nested.msrs.exit_ctls_high) ||
-	    nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
+	if (CC(!vmx_control_verify(vmcs12->vm_exit_controls,
+				    vmx->nested.msrs.exit_ctls_low,
+				    vmx->nested.msrs.exit_ctls_high)) ||
+	    CC(nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12)))
 		return -EINVAL;
 
 	return 0;
@@ -2531,9 +2541,9 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx_control_verify(vmcs12->vm_entry_controls,
-				vmx->nested.msrs.entry_ctls_low,
-				vmx->nested.msrs.entry_ctls_high))
+	if (CC(!vmx_control_verify(vmcs12->vm_entry_controls,
+				    vmx->nested.msrs.entry_ctls_low,
+				    vmx->nested.msrs.entry_ctls_high)))
 		return -EINVAL;
 
 	/*
@@ -2553,31 +2563,31 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
 
 		/* VM-entry interruption-info field: interruption type */
-		if (intr_type == INTR_TYPE_RESERVED ||
-		    (intr_type == INTR_TYPE_OTHER_EVENT &&
-		     !nested_cpu_supports_monitor_trap_flag(vcpu)))
+		if (CC(intr_type == INTR_TYPE_RESERVED) ||
+		    CC(intr_type == INTR_TYPE_OTHER_EVENT &&
+		       !nested_cpu_supports_monitor_trap_flag(vcpu)))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: vector */
-		if ((intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
-		    (intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
-		    (intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
+		if (CC(intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
+		    CC(intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
+		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: deliver error code */
 		should_have_error_code =
 			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
 			x86_exception_has_error_code(vector);
-		if (has_error_code != should_have_error_code)
+		if (CC(has_error_code != should_have_error_code))
 			return -EINVAL;
 
 		/* VM-entry exception error code */
-		if (has_error_code &&
-		    vmcs12->vm_entry_exception_error_code & GENMASK(31, 15))
+		if (CC(has_error_code &&
+		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 15)))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: reserved bits */
-		if (intr_info & INTR_INFO_RESVD_BITS_MASK)
+		if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
 			return -EINVAL;
 
 		/* VM-entry instruction length */
@@ -2585,9 +2595,9 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		case INTR_TYPE_SOFT_EXCEPTION:
 		case INTR_TYPE_SOFT_INTR:
 		case INTR_TYPE_PRIV_SW_EXCEPTION:
-			if ((vmcs12->vm_entry_instruction_len > 15) ||
-			    (vmcs12->vm_entry_instruction_len == 0 &&
-			     !nested_cpu_has_zero_length_injection(vcpu)))
+			if (CC(vmcs12->vm_entry_instruction_len > 15) ||
+			    CC(vmcs12->vm_entry_instruction_len == 0 &&
+			    CC(!nested_cpu_has_zero_length_injection(vcpu))))
 				return -EINVAL;
 		}
 	}
@@ -2614,40 +2624,40 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 {
 	bool ia32e;
 
-	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0) ||
-	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
-	    !nested_cr3_valid(vcpu, vmcs12->host_cr3))
+	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
+	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
+	    CC(!nested_cr3_valid(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
-	if (is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu))
+	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
 
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) &&
-	    !kvm_pat_valid(vmcs12->host_ia32_pat))
+	    CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
 		return -EINVAL;
 
 	ia32e = (vmcs12->vm_exit_controls &
 		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
 
-	if (vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
-	    vmcs12->host_cs_selector == 0 ||
-	    vmcs12->host_tr_selector == 0 ||
-	    (vmcs12->host_ss_selector == 0 && !ia32e))
+	if (CC(vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
+	    CC(vmcs12->host_cs_selector == 0) ||
+	    CC(vmcs12->host_tr_selector == 0) ||
+	    CC(vmcs12->host_ss_selector == 0 && !ia32e))
 		return -EINVAL;
 
 #ifdef CONFIG_X86_64
-	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
-	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
+	if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)))
 		return -EINVAL;
 #endif
 
@@ -2658,9 +2668,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	 * the host address-space size VM-exit control.
 	 */
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER) {
-		if (!kvm_valid_efer(vcpu, vmcs12->host_ia32_efer) ||
-		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LMA) ||
-		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LME))
+		if (CC(!kvm_valid_efer(vcpu, vmcs12->host_ia32_efer)) ||
+		    CC(ia32e != !!(vmcs12->host_ia32_efer & EFER_LMA)) ||
+		    CC(ia32e != !!(vmcs12->host_ia32_efer & EFER_LME)))
 			return -EINVAL;
 	}
 
@@ -2677,16 +2687,16 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 	if (vmcs12->vmcs_link_pointer == -1ull)
 		return 0;
 
-	if (!page_address_valid(vcpu, vmcs12->vmcs_link_pointer))
+	if (CC(!page_address_valid(vcpu, vmcs12->vmcs_link_pointer)))
 		return -EINVAL;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->vmcs_link_pointer), &map))
+	if (CC(kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->vmcs_link_pointer), &map)))
 		return -EINVAL;
 
 	shadow = map.hva;
 
-	if (shadow->hdr.revision_id != VMCS12_REVISION ||
-	    shadow->hdr.shadow_vmcs != nested_cpu_has_shadow_vmcs(vmcs12))
+	if (CC(shadow->hdr.revision_id != VMCS12_REVISION) ||
+	    CC(shadow->hdr.shadow_vmcs != nested_cpu_has_shadow_vmcs(vmcs12)))
 		r = -EINVAL;
 
 	kvm_vcpu_unmap(vcpu, &map, false);
@@ -2698,8 +2708,8 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
  */
 static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 {
-	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
-	    vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT)
+	if (CC(vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
+	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT))
 		return -EINVAL;
 
 	return 0;
@@ -2713,12 +2723,12 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
 
-	if (!nested_guest_cr0_valid(vcpu, vmcs12->guest_cr0) ||
-	    !nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4))
+	if (CC(!nested_guest_cr0_valid(vcpu, vmcs12->guest_cr0)) ||
+	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
-	    !kvm_pat_valid(vmcs12->guest_ia32_pat))
+	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
 		return -EINVAL;
 
 	if (nested_vmx_check_vmcs_link_ptr(vcpu, vmcs12)) {
@@ -2738,16 +2748,16 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
 		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
-		if (!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer) ||
-		    ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA) ||
-		    ((vmcs12->guest_cr0 & X86_CR0_PG) &&
-		     ia32e != !!(vmcs12->guest_ia32_efer & EFER_LME)))
+		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
+		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
+		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
+		     ia32e != !!(vmcs12->guest_ia32_efer & EFER_LME))))
 			return -EINVAL;
 	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
-	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
-	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
+	    (CC(is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu)) ||
+	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
 	if (nested_check_guest_non_reg_state(vmcs12))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c323118f0b3..fdb23a7b32a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10063,6 +10063,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
-- 
2.22.0

