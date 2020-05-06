Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F61F1C6B6E
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgEFITu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:35417 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbgEFITs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:48 -0400
IronPort-SDR: 5MI/N+cmOtyIuPbGQTWodPPRInG+PYiABSa2N4fZ9khvNhj9XY7n7FoKQ1NjMG/g32kS9na5QI
 EWe+E/ckPtGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:46 -0700
IronPort-SDR: hkMidOzCDDiVbOP6A5Z2nwCV4jD4eeU12D8FljH1J6KHFgtoPLrzyqrkly40+/jomr8Cd+q7O3
 tP0JuKfkpkGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030109"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 07/10] KVM: VMX: Enable CET support for nested VM
Date:   Wed,  6 May 2020 16:21:06 +0800
Message-Id: <20200506082110.25441-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs pass through guests for performance consideration. Configure the
MSRs to match L0/L1 settings so that nested VM is able to run with CET.

Add assertions for vmcs12 offset table initialization, these assertions can
detect the mismatch of VMCS field encoding and data type at compiling time.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  34 +++++
 arch/x86/kvm/vmx/vmcs12.c | 275 ++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmcs12.h |  14 +-
 arch/x86/kvm/vmx/vmx.c    |  10 ++
 4 files changed, 220 insertions(+), 113 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd78ffbde644..ce29475226b6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -555,6 +555,18 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 	}
 }
 
+static void nested_vmx_update_intercept_for_msr(struct kvm_vcpu *vcpu,
+						u32 msr,
+						unsigned long *msr_bitmap_l1,
+						unsigned long *msr_bitmap_l0,
+						int type)
+{
+	if (!msr_write_intercepted_l01(vcpu, msr))
+		nested_vmx_disable_intercept_for_msr(msr_bitmap_l1,
+						     msr_bitmap_l0,
+						     msr, type);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -626,6 +638,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
 
+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
+	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
+					    msr_bitmap_l1, msr_bitmap_l0,
+					    MSR_TYPE_RW);
 	/*
 	 * Checking the L0->L1 bitmap is trying to verify two things:
 	 *
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 53dfb401316d..f68ac66b1170 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -4,31 +4,76 @@
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
-#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
-#define FIELD64(number, name)						\
-	FIELD(number, name),						\
-	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
+
+#define VMCS_CHECK_SIZE16(number) \
+	(BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6001) == 0x2000) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6001) == 0x2001) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x4000) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x6000))
+
+#define VMCS_CHECK_SIZE32(number) \
+	(BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x6000))
+
+#define VMCS_CHECK_SIZE64(number) \
+	(BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6001) == 0x2001) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x4000) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x6000))
+
+#define VMCS_CHECK_SIZE_N(number) \
+	(BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6001) == 0x2000) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6001) == 0x2001) + \
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(number) && \
+	((number) & 0x6000) == 0x4000))
+
+#define FIELD16(number, name) \
+	[ROL16(number, 6)] = VMCS_CHECK_SIZE16(number) + VMCS12_OFFSET(name)
+
+#define FIELD32(number, name) \
+	[ROL16(number, 6)] = VMCS_CHECK_SIZE32(number) + VMCS12_OFFSET(name)
+
+#define FIELD64(number, name)  \
+	FIELD32(number, name), \
+	[ROL16(number##_HIGH, 6)] = VMCS_CHECK_SIZE32(number) + \
+	VMCS12_OFFSET(name) + sizeof(u32)
+#define FIELDN(number, name) \
+	[ROL16(number, 6)] = VMCS_CHECK_SIZE_N(number) + VMCS12_OFFSET(name)
 
 const unsigned short vmcs_field_to_offset_table[] = {
-	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
-	FIELD(POSTED_INTR_NV, posted_intr_nv),
-	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
-	FIELD(GUEST_CS_SELECTOR, guest_cs_selector),
-	FIELD(GUEST_SS_SELECTOR, guest_ss_selector),
-	FIELD(GUEST_DS_SELECTOR, guest_ds_selector),
-	FIELD(GUEST_FS_SELECTOR, guest_fs_selector),
-	FIELD(GUEST_GS_SELECTOR, guest_gs_selector),
-	FIELD(GUEST_LDTR_SELECTOR, guest_ldtr_selector),
-	FIELD(GUEST_TR_SELECTOR, guest_tr_selector),
-	FIELD(GUEST_INTR_STATUS, guest_intr_status),
-	FIELD(GUEST_PML_INDEX, guest_pml_index),
-	FIELD(HOST_ES_SELECTOR, host_es_selector),
-	FIELD(HOST_CS_SELECTOR, host_cs_selector),
-	FIELD(HOST_SS_SELECTOR, host_ss_selector),
-	FIELD(HOST_DS_SELECTOR, host_ds_selector),
-	FIELD(HOST_FS_SELECTOR, host_fs_selector),
-	FIELD(HOST_GS_SELECTOR, host_gs_selector),
-	FIELD(HOST_TR_SELECTOR, host_tr_selector),
+	FIELD16(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
+	FIELD16(POSTED_INTR_NV, posted_intr_nv),
+	FIELD16(GUEST_ES_SELECTOR, guest_es_selector),
+	FIELD16(GUEST_CS_SELECTOR, guest_cs_selector),
+	FIELD16(GUEST_SS_SELECTOR, guest_ss_selector),
+	FIELD16(GUEST_DS_SELECTOR, guest_ds_selector),
+	FIELD16(GUEST_FS_SELECTOR, guest_fs_selector),
+	FIELD16(GUEST_GS_SELECTOR, guest_gs_selector),
+	FIELD16(GUEST_LDTR_SELECTOR, guest_ldtr_selector),
+	FIELD16(GUEST_TR_SELECTOR, guest_tr_selector),
+	FIELD16(GUEST_INTR_STATUS, guest_intr_status),
+	FIELD16(GUEST_PML_INDEX, guest_pml_index),
+	FIELD16(HOST_ES_SELECTOR, host_es_selector),
+	FIELD16(HOST_CS_SELECTOR, host_cs_selector),
+	FIELD16(HOST_SS_SELECTOR, host_ss_selector),
+	FIELD16(HOST_DS_SELECTOR, host_ds_selector),
+	FIELD16(HOST_FS_SELECTOR, host_fs_selector),
+	FIELD16(HOST_GS_SELECTOR, host_gs_selector),
+	FIELD16(HOST_TR_SELECTOR, host_tr_selector),
 	FIELD64(IO_BITMAP_A, io_bitmap_a),
 	FIELD64(IO_BITMAP_B, io_bitmap_b),
 	FIELD64(MSR_BITMAP, msr_bitmap),
@@ -64,94 +109,100 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
-	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
-	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
-	FIELD(EXCEPTION_BITMAP, exception_bitmap),
-	FIELD(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask),
-	FIELD(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match),
-	FIELD(CR3_TARGET_COUNT, cr3_target_count),
-	FIELD(VM_EXIT_CONTROLS, vm_exit_controls),
-	FIELD(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count),
-	FIELD(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count),
-	FIELD(VM_ENTRY_CONTROLS, vm_entry_controls),
-	FIELD(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count),
-	FIELD(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field),
-	FIELD(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code),
-	FIELD(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len),
-	FIELD(TPR_THRESHOLD, tpr_threshold),
-	FIELD(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control),
-	FIELD(VM_INSTRUCTION_ERROR, vm_instruction_error),
-	FIELD(VM_EXIT_REASON, vm_exit_reason),
-	FIELD(VM_EXIT_INTR_INFO, vm_exit_intr_info),
-	FIELD(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code),
-	FIELD(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field),
-	FIELD(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code),
-	FIELD(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len),
-	FIELD(VMX_INSTRUCTION_INFO, vmx_instruction_info),
-	FIELD(GUEST_ES_LIMIT, guest_es_limit),
-	FIELD(GUEST_CS_LIMIT, guest_cs_limit),
-	FIELD(GUEST_SS_LIMIT, guest_ss_limit),
-	FIELD(GUEST_DS_LIMIT, guest_ds_limit),
-	FIELD(GUEST_FS_LIMIT, guest_fs_limit),
-	FIELD(GUEST_GS_LIMIT, guest_gs_limit),
-	FIELD(GUEST_LDTR_LIMIT, guest_ldtr_limit),
-	FIELD(GUEST_TR_LIMIT, guest_tr_limit),
-	FIELD(GUEST_GDTR_LIMIT, guest_gdtr_limit),
-	FIELD(GUEST_IDTR_LIMIT, guest_idtr_limit),
-	FIELD(GUEST_ES_AR_BYTES, guest_es_ar_bytes),
-	FIELD(GUEST_CS_AR_BYTES, guest_cs_ar_bytes),
-	FIELD(GUEST_SS_AR_BYTES, guest_ss_ar_bytes),
-	FIELD(GUEST_DS_AR_BYTES, guest_ds_ar_bytes),
-	FIELD(GUEST_FS_AR_BYTES, guest_fs_ar_bytes),
-	FIELD(GUEST_GS_AR_BYTES, guest_gs_ar_bytes),
-	FIELD(GUEST_LDTR_AR_BYTES, guest_ldtr_ar_bytes),
-	FIELD(GUEST_TR_AR_BYTES, guest_tr_ar_bytes),
-	FIELD(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info),
-	FIELD(GUEST_ACTIVITY_STATE, guest_activity_state),
-	FIELD(GUEST_SYSENTER_CS, guest_sysenter_cs),
-	FIELD(HOST_IA32_SYSENTER_CS, host_ia32_sysenter_cs),
-	FIELD(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value),
-	FIELD(CR0_GUEST_HOST_MASK, cr0_guest_host_mask),
-	FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask),
-	FIELD(CR0_READ_SHADOW, cr0_read_shadow),
-	FIELD(CR4_READ_SHADOW, cr4_read_shadow),
-	FIELD(CR3_TARGET_VALUE0, cr3_target_value0),
-	FIELD(CR3_TARGET_VALUE1, cr3_target_value1),
-	FIELD(CR3_TARGET_VALUE2, cr3_target_value2),
-	FIELD(CR3_TARGET_VALUE3, cr3_target_value3),
-	FIELD(EXIT_QUALIFICATION, exit_qualification),
-	FIELD(GUEST_LINEAR_ADDRESS, guest_linear_address),
-	FIELD(GUEST_CR0, guest_cr0),
-	FIELD(GUEST_CR3, guest_cr3),
-	FIELD(GUEST_CR4, guest_cr4),
-	FIELD(GUEST_ES_BASE, guest_es_base),
-	FIELD(GUEST_CS_BASE, guest_cs_base),
-	FIELD(GUEST_SS_BASE, guest_ss_base),
-	FIELD(GUEST_DS_BASE, guest_ds_base),
-	FIELD(GUEST_FS_BASE, guest_fs_base),
-	FIELD(GUEST_GS_BASE, guest_gs_base),
-	FIELD(GUEST_LDTR_BASE, guest_ldtr_base),
-	FIELD(GUEST_TR_BASE, guest_tr_base),
-	FIELD(GUEST_GDTR_BASE, guest_gdtr_base),
-	FIELD(GUEST_IDTR_BASE, guest_idtr_base),
-	FIELD(GUEST_DR7, guest_dr7),
-	FIELD(GUEST_RSP, guest_rsp),
-	FIELD(GUEST_RIP, guest_rip),
-	FIELD(GUEST_RFLAGS, guest_rflags),
-	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
-	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
-	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
-	FIELD(HOST_CR0, host_cr0),
-	FIELD(HOST_CR3, host_cr3),
-	FIELD(HOST_CR4, host_cr4),
-	FIELD(HOST_FS_BASE, host_fs_base),
-	FIELD(HOST_GS_BASE, host_gs_base),
-	FIELD(HOST_TR_BASE, host_tr_base),
-	FIELD(HOST_GDTR_BASE, host_gdtr_base),
-	FIELD(HOST_IDTR_BASE, host_idtr_base),
-	FIELD(HOST_IA32_SYSENTER_ESP, host_ia32_sysenter_esp),
-	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
-	FIELD(HOST_RSP, host_rsp),
-	FIELD(HOST_RIP, host_rip),
+	FIELD32(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
+	FIELD32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
+	FIELD32(EXCEPTION_BITMAP, exception_bitmap),
+	FIELD32(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask),
+	FIELD32(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match),
+	FIELD32(CR3_TARGET_COUNT, cr3_target_count),
+	FIELD32(VM_EXIT_CONTROLS, vm_exit_controls),
+	FIELD32(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count),
+	FIELD32(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count),
+	FIELD32(VM_ENTRY_CONTROLS, vm_entry_controls),
+	FIELD32(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count),
+	FIELD32(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field),
+	FIELD32(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code),
+	FIELD32(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len),
+	FIELD32(TPR_THRESHOLD, tpr_threshold),
+	FIELD32(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control),
+	FIELD32(VM_INSTRUCTION_ERROR, vm_instruction_error),
+	FIELD32(VM_EXIT_REASON, vm_exit_reason),
+	FIELD32(VM_EXIT_INTR_INFO, vm_exit_intr_info),
+	FIELD32(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code),
+	FIELD32(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field),
+	FIELD32(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code),
+	FIELD32(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len),
+	FIELD32(VMX_INSTRUCTION_INFO, vmx_instruction_info),
+	FIELD32(GUEST_ES_LIMIT, guest_es_limit),
+	FIELD32(GUEST_CS_LIMIT, guest_cs_limit),
+	FIELD32(GUEST_SS_LIMIT, guest_ss_limit),
+	FIELD32(GUEST_DS_LIMIT, guest_ds_limit),
+	FIELD32(GUEST_FS_LIMIT, guest_fs_limit),
+	FIELD32(GUEST_GS_LIMIT, guest_gs_limit),
+	FIELD32(GUEST_LDTR_LIMIT, guest_ldtr_limit),
+	FIELD32(GUEST_TR_LIMIT, guest_tr_limit),
+	FIELD32(GUEST_GDTR_LIMIT, guest_gdtr_limit),
+	FIELD32(GUEST_IDTR_LIMIT, guest_idtr_limit),
+	FIELD32(GUEST_ES_AR_BYTES, guest_es_ar_bytes),
+	FIELD32(GUEST_CS_AR_BYTES, guest_cs_ar_bytes),
+	FIELD32(GUEST_SS_AR_BYTES, guest_ss_ar_bytes),
+	FIELD32(GUEST_DS_AR_BYTES, guest_ds_ar_bytes),
+	FIELD32(GUEST_FS_AR_BYTES, guest_fs_ar_bytes),
+	FIELD32(GUEST_GS_AR_BYTES, guest_gs_ar_bytes),
+	FIELD32(GUEST_LDTR_AR_BYTES, guest_ldtr_ar_bytes),
+	FIELD32(GUEST_TR_AR_BYTES, guest_tr_ar_bytes),
+	FIELD32(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info),
+	FIELD32(GUEST_ACTIVITY_STATE, guest_activity_state),
+	FIELD32(GUEST_SYSENTER_CS, guest_sysenter_cs),
+	FIELD32(HOST_IA32_SYSENTER_CS, host_ia32_sysenter_cs),
+	FIELD32(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value),
+	FIELDN(CR0_GUEST_HOST_MASK, cr0_guest_host_mask),
+	FIELDN(CR4_GUEST_HOST_MASK, cr4_guest_host_mask),
+	FIELDN(CR0_READ_SHADOW, cr0_read_shadow),
+	FIELDN(CR4_READ_SHADOW, cr4_read_shadow),
+	FIELDN(CR3_TARGET_VALUE0, cr3_target_value0),
+	FIELDN(CR3_TARGET_VALUE1, cr3_target_value1),
+	FIELDN(CR3_TARGET_VALUE2, cr3_target_value2),
+	FIELDN(CR3_TARGET_VALUE3, cr3_target_value3),
+	FIELDN(EXIT_QUALIFICATION, exit_qualification),
+	FIELDN(GUEST_LINEAR_ADDRESS, guest_linear_address),
+	FIELDN(GUEST_CR0, guest_cr0),
+	FIELDN(GUEST_CR3, guest_cr3),
+	FIELDN(GUEST_CR4, guest_cr4),
+	FIELDN(GUEST_ES_BASE, guest_es_base),
+	FIELDN(GUEST_CS_BASE, guest_cs_base),
+	FIELDN(GUEST_SS_BASE, guest_ss_base),
+	FIELDN(GUEST_DS_BASE, guest_ds_base),
+	FIELDN(GUEST_FS_BASE, guest_fs_base),
+	FIELDN(GUEST_GS_BASE, guest_gs_base),
+	FIELDN(GUEST_LDTR_BASE, guest_ldtr_base),
+	FIELDN(GUEST_TR_BASE, guest_tr_base),
+	FIELDN(GUEST_GDTR_BASE, guest_gdtr_base),
+	FIELDN(GUEST_IDTR_BASE, guest_idtr_base),
+	FIELDN(GUEST_DR7, guest_dr7),
+	FIELDN(GUEST_RSP, guest_rsp),
+	FIELDN(GUEST_RIP, guest_rip),
+	FIELDN(GUEST_RFLAGS, guest_rflags),
+	FIELDN(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
+	FIELDN(GUEST_SYSENTER_ESP, guest_sysenter_esp),
+	FIELDN(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELDN(GUEST_S_CET, guest_s_cet),
+	FIELDN(GUEST_SSP, guest_ssp),
+	FIELDN(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
+	FIELDN(HOST_CR0, host_cr0),
+	FIELDN(HOST_CR3, host_cr3),
+	FIELDN(HOST_CR4, host_cr4),
+	FIELDN(HOST_FS_BASE, host_fs_base),
+	FIELDN(HOST_GS_BASE, host_gs_base),
+	FIELDN(HOST_TR_BASE, host_tr_base),
+	FIELDN(HOST_GDTR_BASE, host_gdtr_base),
+	FIELDN(HOST_IDTR_BASE, host_idtr_base),
+	FIELDN(HOST_IA32_SYSENTER_ESP, host_ia32_sysenter_esp),
+	FIELDN(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
+	FIELDN(HOST_RSP, host_rsp),
+	FIELDN(HOST_RIP, host_rip),
+	FIELDN(HOST_S_CET, host_s_cet),
+	FIELDN(HOST_SSP, host_ssp),
+	FIELDN(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index d0c6df373f67..62b7be68f05c 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -118,7 +118,13 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width host_s_cet;
+	natural_width host_ssp;
+	natural_width host_ssp_tbl;
+	natural_width guest_s_cet;
+	natural_width guest_ssp;
+	natural_width guest_ssp_tbl;
+	natural_width paddingl[2]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -301,6 +307,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(host_s_cet, 680);
+	CHECK_OFFSET(host_ssp, 688);
+	CHECK_OFFSET(host_ssp_tbl, 696);
+	CHECK_OFFSET(guest_s_cet, 704);
+	CHECK_OFFSET(guest_ssp, 712);
+	CHECK_OFFSET(guest_ssp_tbl, 720);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7f3a65ee64c5..32893573b630 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7189,6 +7189,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
 
 #undef cr4_fixed1_update
 }
@@ -7208,6 +7209,15 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	if (is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER |
+	    XFEATURE_MASK_CET_KERNEL)) {
+		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_CET_STATE;
+		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_CET_STATE;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;
+		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_CET_STATE;
+	}
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.17.2

