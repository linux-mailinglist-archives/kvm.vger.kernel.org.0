Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453B844805
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfFMRDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34832 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393295AbfFMRDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so10919614wml.0;
        Thu, 13 Jun 2019 10:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8i/Lk0dKOu8S5u7s7nKPOMRr8rjMiLrDGND0Dn6g25I=;
        b=sRQhp0dYx+yRPsMImhlRVcWSaz6X7J9Si/S0611S7OF60+scXFLcBtWuMcNFo4fw1C
         2VlgiW1qUb31IIln83F/pcC6V4PC1SpeF1eiKxTlN2eWBsPpVog3/1qVR+P530KDMhOy
         J7LWcGEowSRde6tob/E6w7AmaT4tgDE1NtynCVjSUsglCGUJACgLvcDB4Gz7EeeNIuwS
         8JNSR2IHPs5/nbsWJrTq7+VcsJUx4KGdp62fZDkZ0UfzoTx6ksiKWSm9QPDdDXV9W//3
         WGi/yOx3j9aLsng9aaaWYJY3i+JaDjT+YG4N9pGSW2qTvRDO4PEnBL7GGht79pVD/2Ov
         jYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=8i/Lk0dKOu8S5u7s7nKPOMRr8rjMiLrDGND0Dn6g25I=;
        b=GZ5W+ZnUtb+fFXjrckiO2mkUuVXxqxEJo8RhoCqNtB2avJa6gBLeJNIvXBkmBugWKT
         tft0+zBjzIWk2L5/7CAB3wldIP4a7yMeG/kxW7Qte1faqDb4lVzHjzhgB2hIwtxzMQ35
         WGkYCHWOribWko8MyoNyANBt12YC1oBNWZbS2rvIhCngmNSBDtImlX1Gd7c7jsjXjvMW
         75DK4sh9Ymk7sQTl+k/ZMsOePVS/SvQ63g2qK0x0ce5eAKxnbYCvSGsyh8eO7vXMUeaS
         fZQUidgKfLiUZhW9YaXGvn9Pu+J/Rx0gL2yqr/JcBtR7UalrGRoUKXYcBbpcpdAQEQdo
         xIrg==
X-Gm-Message-State: APjAAAVwRR/9ZSmGWNM2Lte8FpTZ0jBvXpqwHX/ub47awK+R0SrxRvok
        mmhCzjNOr5jAAXYB5J831IMife5S
X-Google-Smtp-Source: APXvYqxRWhG41sa+469foGM6zKyf4TyncnVVIC5x+TEwNSpkVtt2RtWHO8VgmkLVtzKrHx41Br7QPg==
X-Received: by 2002:a1c:f916:: with SMTP id x22mr4788079wmh.81.1560445419569;
        Thu, 13 Jun 2019 10:03:39 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 09/43] KVM: nVMX: Track vmcs12 offsets for shadowed VMCS fields
Date:   Thu, 13 Jun 2019 19:02:55 +0200
Message-Id: <1560445409-17363-10-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The vmcs12 fields offsets are constant and known at compile time.  Store
the associated offset for each shadowed field to avoid the costly lookup
in vmcs_field_to_offset() when copying between vmcs12 and the shadow
VMCS.  Avoiding the costly lookup reduces the latency of copying by
~100 cycles in each direction.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c             | 96 +++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmcs12.h             | 57 +++++++--------------
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 74 +++++++++++++--------------
 3 files changed, 108 insertions(+), 119 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cd51ef68434e..376fd9eabe42 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -41,15 +41,19 @@ enum {
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
@@ -63,37 +67,39 @@ static void init_vmcs_shadow_fields(void)
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
 
 		WARN_ONCE(field >= GUEST_ES_AR_BYTES &&
 			  field <= GUEST_TR_AR_BYTES,
-			  "Update vmcs12_write_any() to expose AR_BYTES RW");
+			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
 		/*
 		 * PML and the preemption timer can be emulated, but the
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
@@ -1308,7 +1314,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 {
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 	struct vmcs12 *vmcs12 = get_vmcs12(&vmx->vcpu);
-	unsigned long field;
+	struct shadow_vmcs_field field;
+	unsigned long val;
 	int i;
 
 	preempt_disable();
@@ -1317,7 +1324,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 
 	for (i = 0; i < max_shadow_read_write_fields; i++) {
 		field = shadow_read_write_fields[i];
-		vmcs12_write_any(vmcs12, field, __vmcs_readl(field));
+		val = __vmcs_readl(field.encoding);
+		vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
 	}
 
 	vmcs_clear(shadow_vmcs);
@@ -1328,7 +1336,7 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 
 static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 {
-	const u16 *fields[] = {
+	const struct shadow_vmcs_field *fields[] = {
 		shadow_read_write_fields,
 		shadow_read_only_fields
 	};
@@ -1336,18 +1344,20 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 		max_shadow_read_write_fields,
 		max_shadow_read_only_fields
 	};
-	int i, q;
-	unsigned long field;
-	u64 field_value = 0;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
+	struct vmcs12 *vmcs12 = get_vmcs12(&vmx->vcpu);
+	struct shadow_vmcs_field field;
+	unsigned long val;
+	int i, q;
 
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
 
@@ -2144,6 +2154,8 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write32(GUEST_TR_LIMIT, vmcs12->guest_tr_limit);
 		vmcs_write32(GUEST_GDTR_LIMIT, vmcs12->guest_gdtr_limit);
 		vmcs_write32(GUEST_IDTR_LIMIT, vmcs12->guest_idtr_limit);
+		vmcs_write32(GUEST_CS_AR_BYTES, vmcs12->guest_cs_ar_bytes);
+		vmcs_write32(GUEST_SS_AR_BYTES, vmcs12->guest_ss_ar_bytes);
 		vmcs_write32(GUEST_ES_AR_BYTES, vmcs12->guest_es_ar_bytes);
 		vmcs_write32(GUEST_DS_AR_BYTES, vmcs12->guest_ds_ar_bytes);
 		vmcs_write32(GUEST_FS_AR_BYTES, vmcs12->guest_fs_ar_bytes);
@@ -2240,23 +2252,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -4372,6 +4373,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	int len;
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
+	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4393,11 +4395,15 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
-	/* Read the field, zero-extended to a u64 field_value */
-	if (vmcs12_read_any(vmcs12, field, &field_value) < 0)
+
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
+	/* Read the field, zero-extended to a u64 field_value */
+	field_value = vmcs12_read_any(vmcs12, field, offset);
+
 	/*
 	 * Now copy part of this value to register or memory, as requested.
 	 * Note that the number of bits actually copied is 32 or 64 depending
@@ -4437,6 +4443,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	u64 field_value = 0;
 	struct x86_exception e;
 	struct vmcs12 *vmcs12;
+	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4481,6 +4488,11 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
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
@@ -4492,9 +4504,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
 		field_value &= 0x1f0ff;
 
-	if (vmcs12_write_any(vmcs12, field, field_value) < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+	vmcs12_write_any(vmcs12, field, offset, field_value);
 
 	/*
 	 * Do not track vmcs12 dirty-state if in guest-mode
@@ -4502,7 +4512,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	if (!is_guest_mode(vcpu)) {
 		switch (field) {
-#define SHADOW_FIELD_RW(x) case x:
+#define SHADOW_FIELD_RW(x, y) case x:
 #include "vmcs_shadow_fields.h"
 			/*
 			 * The fields that can be updated by L1 without a vmexit are
@@ -4511,7 +4521,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
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
1.8.3.1


