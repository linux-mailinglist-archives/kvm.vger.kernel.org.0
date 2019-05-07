Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98474166E8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfEGPgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:51035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGPgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 3/7] KVM: nVMX: Track vmcs12 offsets for shadowed VMCS fields
Date:   Tue,  7 May 2019 08:36:25 -0700
Message-Id: <20190507153629.3681-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vmcs12 fields offsets are constant and known at compile time.  Store
the associated offset for each shadowed field to avoid the costly lookup
in vmcs_field_to_offset() when copying between vmcs12 and the shadow
VMCS.  Avoiding the costly lookup reduces the latency of copying by
~100 cycles in each direction.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c             | 96 +++++++++++++++------------
 arch/x86/kvm/vmx/vmcs12.h             | 57 +++++-----------
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 74 ++++++++++-----------
 3 files changed, 108 insertions(+), 119 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9310c6db9e80..4528c8ff3c9c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -41,15 +41,19 @@ static unsigned long *vmx_bitmap[VMX_BITMAP_NR];
 #define vmx_vmread_bitmap                    (vmx_bitmap[VMX_VMREAD_BITMAP])
 #define vmx_vmwrite_bitmap                   (vmx_bitmap[VMX_VMWRITE_BITMAP])
 
-static u16 shadow_read_only_fields[] = {
-#define SHADOW_FIELD_RO(x) x,
+struct shadow_vmcs_field {
+	u16	encoding;
+	u16	offset;
+};
+static struct shadow_vmcs_field shadow_read_only_fields[] = {
+#define SHADOW_FIELD_RO(x, y) { x, offsetof(struct vmcs12, y) },
 #include "vmcs_shadow_fields.h"
 };
 static int max_shadow_read_only_fields =
 	ARRAY_SIZE(shadow_read_only_fields);
 
-static u16 shadow_read_write_fields[] = {
-#define SHADOW_FIELD_RW(x) x,
+static struct shadow_vmcs_field shadow_read_write_fields[] = {
+#define SHADOW_FIELD_RW(x, y) { x, offsetof(struct vmcs12, y) },
 #include "vmcs_shadow_fields.h"
 };
 static int max_shadow_read_write_fields =
@@ -63,31 +67,33 @@ static void init_vmcs_shadow_fields(void)
 	memset(vmx_vmwrite_bitmap, 0xff, PAGE_SIZE);
 
 	for (i = j = 0; i < max_shadow_read_only_fields; i++) {
-		u16 field = shadow_read_only_fields[i];
+		struct shadow_vmcs_field entry = shadow_read_only_fields[i];
+		u16 field = entry.encoding;
 
 		if (vmcs_field_width(field) == VMCS_FIELD_WIDTH_U64 &&
 		    (i + 1 == max_shadow_read_only_fields ||
-		     shadow_read_only_fields[i + 1] != field + 1))
+		     shadow_read_only_fields[i + 1].encoding != field + 1))
 			pr_err("Missing field from shadow_read_only_field %x\n",
 			       field + 1);
 
 		clear_bit(field, vmx_vmread_bitmap);
-#ifdef CONFIG_X86_64
 		if (field & 1)
+#ifdef CONFIG_X86_64
 			continue;
+#else
+			entry.offset += sizeof(u32);
 #endif
-		if (j < i)
-			shadow_read_only_fields[j] = field;
-		j++;
+		shadow_read_only_fields[j++] = entry;
 	}
 	max_shadow_read_only_fields = j;
 
 	for (i = j = 0; i < max_shadow_read_write_fields; i++) {
-		u16 field = shadow_read_write_fields[i];
+		struct shadow_vmcs_field entry = shadow_read_write_fields[i];
+		u16 field = entry.encoding;
 
 		if (vmcs_field_width(field) == VMCS_FIELD_WIDTH_U64 &&
 		    (i + 1 == max_shadow_read_write_fields ||
-		     shadow_read_write_fields[i + 1] != field + 1))
+		     shadow_read_write_fields[i + 1].encoding != field + 1))
 			pr_err("Missing field from shadow_read_write_field %x\n",
 			       field + 1);
 
@@ -119,13 +125,13 @@ static void init_vmcs_shadow_fields(void)
 
 		clear_bit(field, vmx_vmwrite_bitmap);
 		clear_bit(field, vmx_vmread_bitmap);
-#ifdef CONFIG_X86_64
 		if (field & 1)
+#ifdef CONFIG_X86_64
 			continue;
+#else
+			entry.offset += sizeof(u32);
 #endif
-		if (j < i)
-			shadow_read_write_fields[j] = field;
-		j++;
+		shadow_read_write_fields[j++] = entry;
 	}
 	max_shadow_read_write_fields = j;
 }
@@ -1305,7 +1311,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 {
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 	struct vmcs12 *vmcs12 = get_vmcs12(&vmx->vcpu);
-	unsigned long field;
+	struct shadow_vmcs_field field;
+	unsigned long val;
 	int i;
 
 	preempt_disable();
@@ -1314,7 +1321,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 
 	for (i = 0; i < max_shadow_read_write_fields; i++) {
 		field = shadow_read_write_fields[i];
-		vmcs12_write_any(vmcs12, field, __vmcs_readl(field));
+		val = __vmcs_readl(field.encoding);
+		vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
 	}
 
 	vmcs_clear(shadow_vmcs);
@@ -1325,7 +1333,7 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 
 static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 {
-	const u16 *fields[] = {
+	const struct shadow_vmcs_field *fields[] = {
 		shadow_read_write_fields,
 		shadow_read_only_fields
 	};
@@ -1333,18 +1341,20 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 		max_shadow_read_write_fields,
 		max_shadow_read_only_fields
 	};
+	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
+	struct vmcs12 *vmcs12 = get_vmcs12(&vmx->vcpu);
+	struct shadow_vmcs_field field;
+	unsigned long val;
 	int i, q;
-	unsigned long field;
-	u64 field_value = 0;
-	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 
 	vmcs_load(shadow_vmcs);
 
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
 		for (i = 0; i < max_fields[q]; i++) {
 			field = fields[q][i];
-			vmcs12_read_any(get_vmcs12(&vmx->vcpu), field, &field_value);
-			__vmcs_writel(field, field_value);
+			val = vmcs12_read_any(vmcs12, field.encoding,
+					      field.offset);
+			__vmcs_writel(field.encoding, val);
 		}
 	}
 
@@ -2141,6 +2151,8 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write32(GUEST_TR_LIMIT, vmcs12->guest_tr_limit);
 		vmcs_write32(GUEST_GDTR_LIMIT, vmcs12->guest_gdtr_limit);
 		vmcs_write32(GUEST_IDTR_LIMIT, vmcs12->guest_idtr_limit);
+		vmcs_write32(GUEST_CS_AR_BYTES, vmcs12->guest_cs_ar_bytes);
+		vmcs_write32(GUEST_SS_AR_BYTES, vmcs12->guest_ss_ar_bytes);
 		vmcs_write32(GUEST_ES_AR_BYTES, vmcs12->guest_es_ar_bytes);
 		vmcs_write32(GUEST_DS_AR_BYTES, vmcs12->guest_ds_ar_bytes);
 		vmcs_write32(GUEST_FS_AR_BYTES, vmcs12->guest_fs_ar_bytes);
@@ -2237,23 +2249,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  u32 *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
 		prepare_vmcs02_full(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
 	}
 
-	/*
-	 * First, the fields that are shadowed.  This must be kept in sync
-	 * with vmcs_shadow_fields.h.
-	 */
-	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
-			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
-		vmcs_write32(GUEST_CS_AR_BYTES, vmcs12->guest_cs_ar_bytes);
-		vmcs_write32(GUEST_SS_AR_BYTES, vmcs12->guest_ss_ar_bytes);
-	}
-
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
@@ -4367,6 +4368,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
+	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4388,10 +4390,14 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
+		return nested_vmx_failValid(vcpu,
+			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	/* Read the field, zero-extended to a u64 field_value */
-	if (vmcs12_read_any(vmcs12, field, &field_value) < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+	field_value = vmcs12_read_any(vmcs12, field, offset);
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.
@@ -4431,6 +4437,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	u64 field_value = 0;
 	struct x86_exception e;
 	struct vmcs12 *vmcs12;
+	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4475,6 +4482,11 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		vmcs12 = get_shadow_vmcs12(vcpu);
 	}
 
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
+		return nested_vmx_failValid(vcpu,
+			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	/*
 	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
 	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
@@ -4486,9 +4498,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
 		field_value &= 0x1f0ff;
 
-	if (vmcs12_write_any(vmcs12, field, field_value) < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+	vmcs12_write_any(vmcs12, field, offset, field_value);
 
 	/*
 	 * Do not track vmcs12 dirty-state if in guest-mode
@@ -4496,7 +4506,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	if (!is_guest_mode(vcpu)) {
 		switch (field) {
-#define SHADOW_FIELD_RW(x) case x:
+#define SHADOW_FIELD_RW(x, y) case x:
 #include "vmcs_shadow_fields.h"
 			/*
 			 * The fields that can be updated by L1 without a vmexit are
@@ -4505,7 +4515,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			 */
 			break;
 
-#define SHADOW_FIELD_RO(x) case x:
+#define SHADOW_FIELD_RO(x, y) case x:
 #include "vmcs_shadow_fields.h"
 			/*
 			 * L1 can read these fields without exiting, ensure the
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 3a742428ad17..9cd26099fcc0 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -394,69 +394,48 @@ static inline short vmcs_field_to_offset(unsigned long field)
 
 #undef ROL16
 
-/*
- * Read a vmcs12 field. Since these can have varying lengths and we return
- * one type, we chose the biggest type (u64) and zero-extend the return value
- * to that size. Note that the caller, handle_vmread, might need to use only
- * some of the bits we return here (e.g., on 32-bit guests, only 32 bits of
- * 64-bit fields are to be returned).
- */
-static inline int vmcs12_read_any(struct vmcs12 *vmcs12,
-				  unsigned long field, u64 *ret)
+static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
+				  u16 offset)
 {
-	short offset = vmcs_field_to_offset(field);
-	char *p;
-
-	if (offset < 0)
-		return offset;
-
-	p = (char *)vmcs12 + offset;
+	char *p = (char *)vmcs12 + offset;
 
 	switch (vmcs_field_width(field)) {
 	case VMCS_FIELD_WIDTH_NATURAL_WIDTH:
-		*ret = *((natural_width *)p);
-		return 0;
+		return *((natural_width *)p);
 	case VMCS_FIELD_WIDTH_U16:
-		*ret = *((u16 *)p);
-		return 0;
+		return *((u16 *)p);
 	case VMCS_FIELD_WIDTH_U32:
-		*ret = *((u32 *)p);
-		return 0;
+		return *((u32 *)p);
 	case VMCS_FIELD_WIDTH_U64:
-		*ret = *((u64 *)p);
-		return 0;
+		return *((u64 *)p);
 	default:
-		WARN_ON(1);
-		return -ENOENT;
+		WARN_ON_ONCE(1);
+		return -1;
 	}
 }
 
-static inline int vmcs12_write_any(struct vmcs12 *vmcs12,
-				   unsigned long field, u64 field_value){
-	short offset = vmcs_field_to_offset(field);
+static inline void vmcs12_write_any(struct vmcs12 *vmcs12, unsigned long field,
+				    u16 offset, u64 field_value)
+{
 	char *p = (char *)vmcs12 + offset;
 
-	if (offset < 0)
-		return offset;
-
 	switch (vmcs_field_width(field)) {
 	case VMCS_FIELD_WIDTH_U16:
 		*(u16 *)p = field_value;
-		return 0;
+		break;
 	case VMCS_FIELD_WIDTH_U32:
 		*(u32 *)p = field_value;
-		return 0;
+		break;
 	case VMCS_FIELD_WIDTH_U64:
 		*(u64 *)p = field_value;
-		return 0;
+		break;
 	case VMCS_FIELD_WIDTH_NATURAL_WIDTH:
 		*(natural_width *)p = field_value;
-		return 0;
+		break;
 	default:
-		WARN_ON(1);
-		return -ENOENT;
+		WARN_ON_ONCE(1);
+		break;
 	}
-
 }
 
 #endif /* __KVM_X86_VMX_VMCS12_H */
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 97dd5295be31..2cfa19ca158e 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,8 +1,8 @@
 #ifndef SHADOW_FIELD_RO
-#define SHADOW_FIELD_RO(x)
+#define SHADOW_FIELD_RO(x, y)
 #endif
 #ifndef SHADOW_FIELD_RW
-#define SHADOW_FIELD_RW(x)
+#define SHADOW_FIELD_RW(x, y)
 #endif
 
 /*
@@ -28,47 +28,47 @@
  */
 
 /* 16-bits */
-SHADOW_FIELD_RW(GUEST_INTR_STATUS)
-SHADOW_FIELD_RW(GUEST_PML_INDEX)
-SHADOW_FIELD_RW(HOST_FS_SELECTOR)
-SHADOW_FIELD_RW(HOST_GS_SELECTOR)
+SHADOW_FIELD_RW(GUEST_INTR_STATUS, guest_intr_status)
+SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index)
+SHADOW_FIELD_RW(HOST_FS_SELECTOR, host_fs_selector)
+SHADOW_FIELD_RW(HOST_GS_SELECTOR, host_gs_selector)
 
 /* 32-bits */
-SHADOW_FIELD_RO(VM_EXIT_REASON)
-SHADOW_FIELD_RO(VM_EXIT_INTR_INFO)
-SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN)
-SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD)
-SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE)
-SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE)
-SHADOW_FIELD_RO(GUEST_CS_AR_BYTES)
-SHADOW_FIELD_RO(GUEST_SS_AR_BYTES)
-SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL)
-SHADOW_FIELD_RW(EXCEPTION_BITMAP)
-SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE)
-SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD)
-SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN)
-SHADOW_FIELD_RW(TPR_THRESHOLD)
-SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO)
-SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE)
+SHADOW_FIELD_RO(VM_EXIT_REASON, vm_exit_reason)
+SHADOW_FIELD_RO(VM_EXIT_INTR_INFO, vm_exit_intr_info)
+SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len)
+SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field)
+SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code)
+SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code)
+SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
+SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
+SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
+SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
+SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code)
+SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
+SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len)
+SHADOW_FIELD_RW(TPR_THRESHOLD, tpr_threshold)
+SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info)
+SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value)
 
 /* Natural width */
-SHADOW_FIELD_RO(EXIT_QUALIFICATION)
-SHADOW_FIELD_RO(GUEST_LINEAR_ADDRESS)
-SHADOW_FIELD_RW(GUEST_RIP)
-SHADOW_FIELD_RW(GUEST_RSP)
-SHADOW_FIELD_RW(GUEST_CR0)
-SHADOW_FIELD_RW(GUEST_CR3)
-SHADOW_FIELD_RW(GUEST_CR4)
-SHADOW_FIELD_RW(GUEST_RFLAGS)
-SHADOW_FIELD_RW(CR0_GUEST_HOST_MASK)
-SHADOW_FIELD_RW(CR0_READ_SHADOW)
-SHADOW_FIELD_RW(CR4_READ_SHADOW)
-SHADOW_FIELD_RW(HOST_FS_BASE)
-SHADOW_FIELD_RW(HOST_GS_BASE)
+SHADOW_FIELD_RO(EXIT_QUALIFICATION, exit_qualification)
+SHADOW_FIELD_RO(GUEST_LINEAR_ADDRESS, guest_linear_address)
+SHADOW_FIELD_RW(GUEST_RIP, guest_rip)
+SHADOW_FIELD_RW(GUEST_RSP, guest_rsp)
+SHADOW_FIELD_RW(GUEST_CR0, guest_cr0)
+SHADOW_FIELD_RW(GUEST_CR3, guest_cr3)
+SHADOW_FIELD_RW(GUEST_CR4, guest_cr4)
+SHADOW_FIELD_RW(GUEST_RFLAGS, guest_rflags)
+SHADOW_FIELD_RW(CR0_GUEST_HOST_MASK, cr0_guest_host_mask)
+SHADOW_FIELD_RW(CR0_READ_SHADOW, cr0_read_shadow)
+SHADOW_FIELD_RW(CR4_READ_SHADOW, cr4_read_shadow)
+SHADOW_FIELD_RW(HOST_FS_BASE, host_fs_base)
+SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 
 /* 64-bit */
-SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS)
-SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH)
+SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
+SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
 
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW
-- 
2.21.0

