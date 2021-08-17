Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0993EE9E2
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhHQJcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235364AbhHQJcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111500"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111500"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200705"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:30 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 1/5] KVM: x86: nVMX: Add vmcs12 field existence bitmap in nested_vmx
Date:   Tue, 17 Aug 2021 17:31:09 +0800
Message-Id: <1629192673-9911-2-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bits map fields:
The bitmap correspond to VMCS12 fields. To simplify logic, we don't skip VMCS
header. And as VMCS fields width differ, use the common divisor u16 as
unit, therefore this bitmap is a little sparse.

Life cycle:
The vmcs12_field_existence_bitmap share same life cycle as vCPU, i.e.
allocated when vCPU is created, and initialized; destroyed when vCPU is
about to be freed. It cannot be allocated/freed like cached_vmcs12 is
because it's needed before guest vmx_on.

Initialize/destroy:
By the nature of each field, they can be categorized into 2 types: fixed
and dynamic. These fixed has no dependency on any VMX feature while dynamic
ones have. So the initalization is divided into 2: vmcs12_field_fixed_init()
and vmcs12_field_dynamic_init().
vmcs12_field_dynamic_init() is actually a wrapper of all
vmcs12_field_update_by_xxx() functions, these update functions will be
reused in later patch when VMX msrs are set.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c |   2 +
 arch/x86/kvm/vmx/vmcs12.c | 363 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.h |  26 +++
 arch/x86/kvm/vmx/vmx.c    |  12 +-
 arch/x86/kvm/vmx/vmx.h    |   3 +
 5 files changed, 405 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0d0dd6580cfd..125b94dc3cf1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -327,6 +327,8 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
 	vmx_leave_nested(vcpu);
+	kfree(to_vmx(vcpu)->nested.vmcs12_field_existence_bitmap);
+	to_vmx(vcpu)->nested.vmcs12_field_existence_bitmap = NULL;
 	vcpu_put(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index d9f5d7c56ae3..22fd5b21e136 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -153,3 +153,366 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(HOST_RIP, host_rip),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
+
+#define FIELD_BIT_SET(name, bitmap) set_bit(f_pos(name), bitmap)
+#define FIELD64_BIT_SET(name, bitmap)	\
+	do {set_bit(f_pos(name), bitmap);	\
+	    set_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
+	} while (0)
+
+#define FIELD_BIT_CLEAR(name, bitmap) clear_bit(f_pos(name), bitmap)
+#define FIELD64_BIT_CLEAR(name, bitmap)	\
+	do {clear_bit(f_pos(name), bitmap);	\
+	    clear_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
+	} while (0)
+
+#define FIELD_BIT_CHANGE(name, bitmap) change_bit(f_pos(name), bitmap)
+#define FIELD64_BIT_CHANGE(name, bitmap)	\
+	do {change_bit(f_pos(name), bitmap);	\
+	    change_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
+	} while (0)
+
+/*
+ * Set non-dependent fields to exist
+ */
+void vmcs12_field_fixed_init(unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	FIELD_BIT_SET(guest_es_selector, bitmap);
+	FIELD_BIT_SET(guest_cs_selector, bitmap);
+	FIELD_BIT_SET(guest_ss_selector, bitmap);
+	FIELD_BIT_SET(guest_ds_selector, bitmap);
+	FIELD_BIT_SET(guest_fs_selector, bitmap);
+	FIELD_BIT_SET(guest_gs_selector, bitmap);
+	FIELD_BIT_SET(guest_ldtr_selector, bitmap);
+	FIELD_BIT_SET(guest_tr_selector, bitmap);
+	FIELD_BIT_SET(host_es_selector, bitmap);
+	FIELD_BIT_SET(host_cs_selector, bitmap);
+	FIELD_BIT_SET(host_ss_selector, bitmap);
+	FIELD_BIT_SET(host_ds_selector, bitmap);
+	FIELD_BIT_SET(host_fs_selector, bitmap);
+	FIELD_BIT_SET(host_gs_selector, bitmap);
+	FIELD_BIT_SET(host_tr_selector, bitmap);
+	FIELD64_BIT_SET(io_bitmap_a, bitmap);
+	FIELD64_BIT_SET(io_bitmap_b, bitmap);
+	FIELD64_BIT_SET(vm_exit_msr_store_addr, bitmap);
+	FIELD64_BIT_SET(vm_exit_msr_load_addr, bitmap);
+	FIELD64_BIT_SET(vm_entry_msr_load_addr, bitmap);
+	FIELD64_BIT_SET(tsc_offset, bitmap);
+	FIELD64_BIT_SET(vmcs_link_pointer, bitmap);
+	FIELD64_BIT_SET(guest_ia32_debugctl, bitmap);
+	FIELD_BIT_SET(pin_based_vm_exec_control, bitmap);
+	FIELD_BIT_SET(cpu_based_vm_exec_control, bitmap);
+	FIELD_BIT_SET(exception_bitmap, bitmap);
+	FIELD_BIT_SET(page_fault_error_code_mask, bitmap);
+	FIELD_BIT_SET(page_fault_error_code_match, bitmap);
+	FIELD_BIT_SET(cr3_target_count, bitmap);
+	FIELD_BIT_SET(vm_exit_controls, bitmap);
+	FIELD_BIT_SET(vm_exit_msr_store_count, bitmap);
+	FIELD_BIT_SET(vm_exit_msr_load_count, bitmap);
+	FIELD_BIT_SET(vm_entry_controls, bitmap);
+	FIELD_BIT_SET(vm_entry_msr_load_count, bitmap);
+	FIELD_BIT_SET(vm_entry_intr_info_field, bitmap);
+	FIELD_BIT_SET(vm_entry_exception_error_code, bitmap);
+	FIELD_BIT_SET(vm_entry_instruction_len, bitmap);
+	FIELD_BIT_SET(vm_instruction_error, bitmap);
+	FIELD_BIT_SET(vm_exit_reason, bitmap);
+	FIELD_BIT_SET(vm_exit_intr_info, bitmap);
+	FIELD_BIT_SET(vm_exit_intr_error_code, bitmap);
+	FIELD_BIT_SET(idt_vectoring_info_field, bitmap);
+	FIELD_BIT_SET(idt_vectoring_error_code, bitmap);
+	FIELD_BIT_SET(vm_exit_instruction_len, bitmap);
+	FIELD_BIT_SET(vmx_instruction_info, bitmap);
+	FIELD_BIT_SET(guest_es_limit, bitmap);
+	FIELD_BIT_SET(guest_cs_limit, bitmap);
+	FIELD_BIT_SET(guest_ss_limit, bitmap);
+	FIELD_BIT_SET(guest_ds_limit, bitmap);
+	FIELD_BIT_SET(guest_fs_limit, bitmap);
+	FIELD_BIT_SET(guest_gs_limit, bitmap);
+	FIELD_BIT_SET(guest_ldtr_limit, bitmap);
+	FIELD_BIT_SET(guest_tr_limit, bitmap);
+	FIELD_BIT_SET(guest_gdtr_limit, bitmap);
+	FIELD_BIT_SET(guest_idtr_limit, bitmap);
+	FIELD_BIT_SET(guest_es_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_cs_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_ss_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_ds_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_fs_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_gs_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_ldtr_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_tr_ar_bytes, bitmap);
+	FIELD_BIT_SET(guest_interruptibility_info, bitmap);
+	FIELD_BIT_SET(guest_activity_state, bitmap);
+	FIELD_BIT_SET(guest_sysenter_cs, bitmap);
+	FIELD_BIT_SET(host_ia32_sysenter_cs, bitmap);
+	FIELD_BIT_SET(cr0_guest_host_mask, bitmap);
+	FIELD_BIT_SET(cr4_guest_host_mask, bitmap);
+	FIELD_BIT_SET(cr0_read_shadow, bitmap);
+	FIELD_BIT_SET(cr4_read_shadow, bitmap);
+	FIELD_BIT_SET(exit_qualification, bitmap);
+	FIELD_BIT_SET(guest_linear_address, bitmap);
+	FIELD_BIT_SET(guest_cr0, bitmap);
+	FIELD_BIT_SET(guest_cr3, bitmap);
+	FIELD_BIT_SET(guest_cr4, bitmap);
+	FIELD_BIT_SET(guest_es_base, bitmap);
+	FIELD_BIT_SET(guest_cs_base, bitmap);
+	FIELD_BIT_SET(guest_ss_base, bitmap);
+	FIELD_BIT_SET(guest_ds_base, bitmap);
+	FIELD_BIT_SET(guest_fs_base, bitmap);
+	FIELD_BIT_SET(guest_gs_base, bitmap);
+	FIELD_BIT_SET(guest_ldtr_base, bitmap);
+	FIELD_BIT_SET(guest_tr_base, bitmap);
+	FIELD_BIT_SET(guest_gdtr_base, bitmap);
+	FIELD_BIT_SET(guest_idtr_base, bitmap);
+	FIELD_BIT_SET(guest_dr7, bitmap);
+	FIELD_BIT_SET(guest_rsp, bitmap);
+	FIELD_BIT_SET(guest_rip, bitmap);
+	FIELD_BIT_SET(guest_rflags, bitmap);
+	FIELD_BIT_SET(guest_pending_dbg_exceptions, bitmap);
+	FIELD_BIT_SET(guest_sysenter_esp, bitmap);
+	FIELD_BIT_SET(guest_sysenter_eip, bitmap);
+	FIELD_BIT_SET(host_cr0, bitmap);
+	FIELD_BIT_SET(host_cr3, bitmap);
+	FIELD_BIT_SET(host_cr4, bitmap);
+	FIELD_BIT_SET(host_fs_base, bitmap);
+	FIELD_BIT_SET(host_gs_base, bitmap);
+	FIELD_BIT_SET(host_tr_base, bitmap);
+	FIELD_BIT_SET(host_gdtr_base, bitmap);
+	FIELD_BIT_SET(host_idtr_base, bitmap);
+	FIELD_BIT_SET(host_ia32_sysenter_esp, bitmap);
+	FIELD_BIT_SET(host_ia32_sysenter_eip, bitmap);
+	FIELD_BIT_SET(host_rsp, bitmap);
+	FIELD_BIT_SET(host_rip, bitmap);
+}
+
+void vmcs12_field_dynamic_init(struct nested_vmx_msrs *vmx_msrs,
+			       unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	vmcs12_field_update_by_pinbased_ctrl(0, vmx_msrs->pinbased_ctls_high,
+					     bitmap);
+
+	vmcs12_field_update_by_procbased_ctrl(0, vmx_msrs->procbased_ctls_high,
+					      bitmap);
+
+	vmcs12_field_update_by_procbased_ctrl2(0, vmx_msrs->secondary_ctls_high,
+					       bitmap);
+
+	vmcs12_field_update_by_vmentry_ctrl(vmx_msrs->exit_ctls_high, 0,
+					    vmx_msrs->entry_ctls_high,
+					    bitmap);
+
+	vmcs12_field_update_by_vmexit_ctrl(vmx_msrs->entry_ctls_high, 0,
+					   vmx_msrs->exit_ctls_high,
+					   bitmap);
+
+	vmcs12_field_update_by_vm_func(0, vmx_msrs->vmfunc_controls, bitmap);
+}
+
+void vmcs12_field_update_by_pinbased_ctrl(u32 old_val, u32 new_val,
+					  unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+
+	if (!(old_val ^ new_val))
+		return;
+	if ((old_val ^ new_val) & PIN_BASED_POSTED_INTR) {
+		FIELD_BIT_CHANGE(posted_intr_nv, bitmap);
+		FIELD64_BIT_CHANGE(posted_intr_desc_addr, bitmap);
+	}
+
+	if ((old_val ^ new_val) & PIN_BASED_VMX_PREEMPTION_TIMER)
+		FIELD_BIT_CHANGE(vmx_preemption_timer_value, bitmap);
+}
+
+void vmcs12_field_update_by_procbased_ctrl(u32 old_val, u32 new_val,
+					   unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	if (!(old_val ^ new_val))
+		return;
+
+	if ((old_val ^ new_val) & CPU_BASED_USE_MSR_BITMAPS)
+		FIELD64_BIT_CHANGE(msr_bitmap, bitmap);
+
+	if ((old_val ^ new_val) & CPU_BASED_TPR_SHADOW) {
+		FIELD64_BIT_CHANGE(virtual_apic_page_addr, bitmap);
+		FIELD_BIT_CHANGE(tpr_threshold, bitmap);
+	}
+
+	if ((old_val ^ new_val) &
+	    CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
+		FIELD_BIT_CHANGE(secondary_vm_exec_control, bitmap);
+	}
+}
+
+void vmcs12_field_update_by_procbased_ctrl2(u32 old_val, u32 new_val,
+					    unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	if (!(old_val ^ new_val))
+		return;
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_ENABLE_VPID)
+		FIELD_BIT_CHANGE(virtual_processor_id, bitmap);
+
+	if ((old_val ^ new_val) &
+	    SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) {
+		FIELD_BIT_CHANGE(guest_intr_status, bitmap);
+		FIELD64_BIT_CHANGE(eoi_exit_bitmap0, bitmap);
+		FIELD64_BIT_CHANGE(eoi_exit_bitmap1, bitmap);
+		FIELD64_BIT_CHANGE(eoi_exit_bitmap2, bitmap);
+		FIELD64_BIT_CHANGE(eoi_exit_bitmap3, bitmap);
+	}
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_ENABLE_PML) {
+		FIELD_BIT_CHANGE(guest_pml_index, bitmap);
+		FIELD64_BIT_CHANGE(pml_address, bitmap);
+	}
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)
+		FIELD64_BIT_CHANGE(apic_access_addr, bitmap);
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_ENABLE_VMFUNC)
+		FIELD64_BIT_CHANGE(vm_function_control, bitmap);
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_ENABLE_EPT) {
+		FIELD64_BIT_CHANGE(ept_pointer, bitmap);
+		FIELD64_BIT_CHANGE(guest_physical_address, bitmap);
+		FIELD64_BIT_CHANGE(guest_pdptr0, bitmap);
+		FIELD64_BIT_CHANGE(guest_pdptr1, bitmap);
+		FIELD64_BIT_CHANGE(guest_pdptr2, bitmap);
+		FIELD64_BIT_CHANGE(guest_pdptr3, bitmap);
+	}
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_SHADOW_VMCS) {
+		FIELD64_BIT_CHANGE(vmread_bitmap, bitmap);
+		FIELD64_BIT_CHANGE(vmwrite_bitmap, bitmap);
+	}
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_XSAVES)
+		FIELD64_BIT_CHANGE(xss_exit_bitmap, bitmap);
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_ENCLS_EXITING)
+		FIELD64_BIT_CHANGE(encls_exiting_bitmap, bitmap);
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_TSC_SCALING)
+		FIELD64_BIT_CHANGE(tsc_multiplier, bitmap);
+
+	if ((old_val ^ new_val) & SECONDARY_EXEC_PAUSE_LOOP_EXITING) {
+		FIELD64_BIT_CHANGE(vmread_bitmap, bitmap);
+		FIELD64_BIT_CHANGE(vmwrite_bitmap, bitmap);
+	}
+}
+
+void vmcs12_field_update_by_vmentry_ctrl(u32 vm_exit_ctrl, u32 old_val,
+					 u32 new_val, unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	if (!(old_val ^ new_val))
+		return;
+
+	if ((old_val ^ new_val) & VM_ENTRY_LOAD_IA32_PAT) {
+		if ((new_val & VM_ENTRY_LOAD_IA32_PAT) ||
+		    (vm_exit_ctrl & VM_EXIT_SAVE_IA32_PAT))
+			FIELD64_BIT_SET(guest_ia32_pat, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_ia32_pat, bitmap);
+	}
+
+	if ((old_val ^ new_val) & VM_ENTRY_LOAD_IA32_EFER) {
+		if ((new_val & VM_ENTRY_LOAD_IA32_EFER) ||
+		    (vm_exit_ctrl & VM_EXIT_SAVE_IA32_EFER))
+			FIELD64_BIT_SET(guest_ia32_efer, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_ia32_efer, bitmap);
+	}
+
+	if ((old_val ^ new_val) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+		FIELD64_BIT_CHANGE(guest_ia32_perf_global_ctrl, bitmap);
+
+	if ((old_val ^ new_val) & VM_ENTRY_LOAD_BNDCFGS) {
+		if ((new_val & VM_ENTRY_LOAD_BNDCFGS) ||
+		    (vm_exit_ctrl & VM_EXIT_CLEAR_BNDCFGS))
+			FIELD64_BIT_SET(guest_bndcfgs, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_bndcfgs, bitmap);
+	}
+}
+
+void vmcs12_field_update_by_vmexit_ctrl(u32 vm_entry_ctrl, u32 old_val,
+					u32 new_val, unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+	if (!(old_val ^ new_val))
+		return;
+
+	if ((old_val ^ new_val) & VM_EXIT_LOAD_IA32_PAT)
+		FIELD64_BIT_CHANGE(host_ia32_pat, bitmap);
+
+	if ((old_val ^ new_val) & VM_EXIT_LOAD_IA32_EFER)
+		FIELD64_BIT_CHANGE(host_ia32_efer, bitmap);
+
+	if ((old_val ^ new_val) & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+		FIELD64_BIT_CHANGE(host_ia32_perf_global_ctrl, bitmap);
+
+	if ((old_val ^ new_val) & VM_EXIT_SAVE_IA32_PAT) {
+		if ((new_val & VM_EXIT_SAVE_IA32_PAT) ||
+		    (vm_entry_ctrl & VM_ENTRY_LOAD_IA32_PAT))
+			FIELD64_BIT_SET(guest_ia32_pat, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_ia32_pat, bitmap);
+	}
+
+	if ((old_val ^ new_val) & VM_EXIT_SAVE_IA32_EFER) {
+		if ((new_val & VM_EXIT_SAVE_IA32_EFER) ||
+		    (vm_entry_ctrl & VM_ENTRY_LOAD_IA32_EFER))
+			FIELD64_BIT_SET(guest_ia32_efer, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_ia32_efer, bitmap);
+	}
+
+	if ((old_val ^ new_val) & VM_EXIT_CLEAR_BNDCFGS) {
+		if ((new_val & VM_EXIT_CLEAR_BNDCFGS) ||
+		    (vm_entry_ctrl & VM_ENTRY_LOAD_BNDCFGS))
+			FIELD64_BIT_SET(guest_bndcfgs, bitmap);
+		else
+			FIELD64_BIT_CLEAR(guest_bndcfgs, bitmap);
+	}
+}
+
+void vmcs12_field_update_by_vm_func(u64 old_val, u64 new_val,
+				    unsigned long *bitmap)
+{
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return;
+	}
+
+	if (!(old_val ^ new_val))
+		return;
+
+	if ((old_val ^ new_val) & VMFUNC_CONTROL_BIT(EPTP_SWITCHING))
+		FIELD64_BIT_CHANGE(eptp_list_address, bitmap);
+}
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 5e0e1b39f495..5c39370dff3c 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -187,6 +187,32 @@ struct __packed vmcs12 {
 	u16 guest_pml_index;
 };
 
+/*
+ * In unit of u16, each vmcs12 field's offset.
+ * Used to index each's position in bitmap
+ */
+#define f_pos(x)	(offsetof(struct vmcs12, x) / sizeof(u16))
+#define VMCS12_FIELD_BITMAP_SIZE	\
+	(sizeof(struct vmcs12) / sizeof(u16) / BITS_PER_BYTE)
+void vmcs12_field_fixed_init(unsigned long *bitmap);
+void vmcs12_field_dynamic_init(struct nested_vmx_msrs *vmx_msrs,
+					unsigned long *bitmap);
+void vmcs12_field_update_by_pinbased_ctrl(u32 old_val, u32 new_val,
+							unsigned long *bitmap);
+void vmcs12_field_update_by_procbased_ctrl(u32 old_val, u32 new_val,
+							unsigned long *bitmap);
+void vmcs12_field_update_by_procbased_ctrl2(u32 old_val, u32 new_val,
+							unsigned long *bitmap);
+void vmcs12_field_update_by_vmentry_ctrl(u32 vm_exit_ctrl, u32 old_val,
+						      u32 new_val,
+						      unsigned long *bitmap);
+void vmcs12_field_update_by_vmexit_ctrl(u32 vm_entry_ctrl, u32 old_val,
+						     u32 new_val,
+						     unsigned long *bitmap);
+void vmcs12_field_update_by_vm_func(u64 old_val, u64 new_val,
+						unsigned long *bitmap);
+
+
 /*
  * VMCS12_REVISION is an arbitrary id that should be changed if the content or
  * layout of struct vmcs12 is changed. MSR_IA32_VMX_BASIC returns this id, and
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae8e62df16dd..6ab37e1d04c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6844,8 +6844,17 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
-	if (nested)
+	if (nested) {
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
+
+		vmx->nested.vmcs12_field_existence_bitmap = (unsigned long *)
+			kzalloc(VMCS12_FIELD_BITMAP_SIZE, GFP_KERNEL_ACCOUNT);
+		if (!vmx->nested.vmcs12_field_existence_bitmap)
+			goto free_vmcs;
+		vmcs12_field_fixed_init(vmx->nested.vmcs12_field_existence_bitmap);
+		vmcs12_field_dynamic_init(&vmx->nested.msrs,
+					  vmx->nested.vmcs12_field_existence_bitmap);
+	}
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
@@ -6867,6 +6876,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+	kfree(vmx->nested.cached_shadow_vmcs12);
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_pml:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0ecc41189292..c34f1310aa36 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -141,6 +141,9 @@ struct nested_vmx {
 	 */
 	struct vmcs12 *cached_shadow_vmcs12;
 
+	/* VMCS12 field existence bitmap */
+	unsigned long *vmcs12_field_existence_bitmap;
+
 	/*
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
-- 
2.27.0

