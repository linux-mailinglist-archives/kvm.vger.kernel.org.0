Return-Path: <kvm+bounces-53288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F48BB0F9B1
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEC711CC016C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCA5238C12;
	Wed, 23 Jul 2025 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jyV49IEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1F623182D;
	Wed, 23 Jul 2025 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293263; cv=none; b=iZZI7sBjbCqd9a4OmdNEY6YL4RsJ6Xv17KdsPYZyypXPuMWgHyWEwi7t9hLf/iBD9CMmOTws0j8ejrtPfSm4TkMWdo+m5+RckF4FkorypDuc+yu1MeSoW/v8FtXmvwto5cKz5hu3TxUf9IGQlDZmqEKXAWo8iX/n7Kd1+oIJOeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293263; c=relaxed/simple;
	bh=9A4Q42upgg66IrTK5yoJS98/5wWKyZ4SWNrLAsUlKtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo78LsgGHkhvWyZmqG0jT+z2oDekDYnhS535AqppOKRBYxBR1dAw6OJqV/sliI3j9QrBS4ODRccgMhNvCw/tpGsxiLNHs1jXeObvyVIMh7UCMAAHwH8iiui2cU0ZUUdpoLGhlztwOAwrqewl7UoUFEJvBQcL5SLBpb5s4nlEwoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jyV49IEG; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf0D1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:54:07 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf0D1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293247;
	bh=cB0qFffZfZC4uW/TD2Ynm34XI3kmi421N2abXu5XwFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyV49IEGEIlnRGMT9Zfu5K7CNCpzQigjLdBDAWcOFss9/r6pwSQXuE/2dPnNrhoXP
	 eGTGSNZ0lgBiV3BzYEfaMX/hKcG58T+sxTp/l+QN0qyfpgaXlWpUHuK8DkMViWkXMB
	 xlBmIdlx7rpghmV+LhJdKQ7M7qAqwGKMI7YkJ3JO2QdntpJzFkPM2vv80swDBaYsDN
	 Sha4+5ituj4Uv0XyL384aFHIIx1i/Ftd5Jb22ukR2bbUMCoOWwbrkA0A1V1/cevrur
	 x9ZesNd5+eM62GZvGtjMNLCnfEfTgm+kQiSxzbYC2bRuh3RYwF88fbCXniDYyZxrUG
	 U6c3QLL+esGnA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 23/23] KVM: nVMX: Add prerequisites to SHADOW_FIELD_R[OW] macros
Date: Wed, 23 Jul 2025 10:53:41 -0700
Message-ID: <20250723175341.1284463-24-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Add VMX feature checks before accessing VMCS fields via SHADOW_FIELD_R[OW]
macros, as some fields may not be supported on all CPUs.

Functions like copy_shadow_to_vmcs12() and copy_vmcs12_to_shadow() access
VMCS fields that may not exist on certain hardware, such as
INJECTED_EVENT_DATA.  To avoid VMREAD/VMWRITE warnings, skip syncing fields
tied to unsupported VMX features.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change since v2:
* Add __SHADOW_FIELD_R[OW] for better readability or maintability (Sean).
---
 arch/x86/kvm/vmx/nested.c             | 79 +++++++++++++++++++--------
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 41 +++++++++-----
 2 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3554701ec43b..72c23f7267d3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -55,14 +55,14 @@ struct shadow_vmcs_field {
 	u16	offset;
 };
 static struct shadow_vmcs_field shadow_read_only_fields[] = {
-#define SHADOW_FIELD_RO(x, y) { x, offsetof(struct vmcs12, y) },
+#define __SHADOW_FIELD_RO(x, y, c) { x, offsetof(struct vmcs12, y) },
 #include "vmcs_shadow_fields.h"
 };
 static int max_shadow_read_only_fields =
 	ARRAY_SIZE(shadow_read_only_fields);
 
 static struct shadow_vmcs_field shadow_read_write_fields[] = {
-#define SHADOW_FIELD_RW(x, y) { x, offsetof(struct vmcs12, y) },
+#define __SHADOW_FIELD_RW(x, y, c) { x, offsetof(struct vmcs12, y) },
 #include "vmcs_shadow_fields.h"
 };
 static int max_shadow_read_write_fields =
@@ -85,6 +85,17 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_only_field %x\n",
 			       field + 1);
 
+		switch (field) {
+#define __SHADOW_FIELD_RO(x, y, c)		\
+		case x:				\
+			if (!(c))		\
+				continue;	\
+			break;
+#include "vmcs_shadow_fields.h"
+		default:
+			break;
+		}
+
 		clear_bit(field, vmx_vmread_bitmap);
 		if (field & 1)
 #ifdef CONFIG_X86_64
@@ -110,24 +121,13 @@ static void init_vmcs_shadow_fields(void)
 			  field <= GUEST_TR_AR_BYTES,
 			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
-		/*
-		 * PML and the preemption timer can be emulated, but the
-		 * processor cannot vmwrite to fields that don't exist
-		 * on bare metal.
-		 */
 		switch (field) {
-		case GUEST_PML_INDEX:
-			if (!cpu_has_vmx_pml())
-				continue;
-			break;
-		case VMX_PREEMPTION_TIMER_VALUE:
-			if (!cpu_has_vmx_preemption_timer())
-				continue;
-			break;
-		case GUEST_INTR_STATUS:
-			if (!cpu_has_vmx_apicv())
-				continue;
+#define __SHADOW_FIELD_RW(x, y, c)		\
+		case x:				\
+			if (!(c))		\
+				continue;	\
 			break;
+#include "vmcs_shadow_fields.h"
 		default:
 			break;
 		}
@@ -1617,8 +1617,8 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 /*
  * Copy the writable VMCS shadow fields back to the VMCS12, in case they have
  * been modified by the L1 guest.  Note, "writable" in this context means
- * "writable by the guest", i.e. tagged SHADOW_FIELD_RW; the set of
- * fields tagged SHADOW_FIELD_RO may or may not align with the "read-only"
+ * "writable by the guest", i.e. tagged __SHADOW_FIELD_RW; the set of
+ * fields tagged __SHADOW_FIELD_RO may or may not align with the "read-only"
  * VM-exit information fields (which are actually writable if the vCPU is
  * configured to support "VMWRITE to any supported field in the VMCS").
  */
@@ -1639,6 +1639,18 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 
 	for (i = 0; i < max_shadow_read_write_fields; i++) {
 		field = shadow_read_write_fields[i];
+
+		switch (field.encoding) {
+#define __SHADOW_FIELD_RW(x, y, c)		\
+		case x:				\
+			if (!(c))		\
+				continue;	\
+			break;
+#include "vmcs_shadow_fields.h"
+		default:
+			break;
+		}
+
 		val = __vmcs_readl(field.encoding);
 		vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
 	}
@@ -1673,6 +1685,23 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
 		for (i = 0; i < max_fields[q]; i++) {
 			field = fields[q][i];
+
+			switch (field.encoding) {
+#define __SHADOW_FIELD_RO(x, y, c)			\
+			case x:				\
+				if (!(c))		\
+					continue;	\
+				break;
+#define __SHADOW_FIELD_RW(x, y, c)			\
+			case x:				\
+				if (!(c))		\
+					continue;	\
+				break;
+#include "vmcs_shadow_fields.h"
+			default:
+				break;
+			}
+
 			val = vmcs12_read_any(vmcs12, field.encoding,
 					      field.offset);
 			__vmcs_writel(field.encoding, val);
@@ -5815,9 +5844,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 static bool is_shadow_field_rw(unsigned long field)
 {
 	switch (field) {
-#define SHADOW_FIELD_RW(x, y) case x:
+#define __SHADOW_FIELD_RW(x, y, c)	\
+	case x:				\
+		return c;
 #include "vmcs_shadow_fields.h"
-		return true;
 	default:
 		break;
 	}
@@ -5827,9 +5857,10 @@ static bool is_shadow_field_rw(unsigned long field)
 static bool is_shadow_field_ro(unsigned long field)
 {
 	switch (field) {
-#define SHADOW_FIELD_RO(x, y) case x:
+#define __SHADOW_FIELD_RO(x, y, c)	\
+	case x:				\
+		return c;
 #include "vmcs_shadow_fields.h"
-		return true;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index da338327c2b3..607945ada35f 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,14 +1,17 @@
-#if !defined(SHADOW_FIELD_RO) && !defined(SHADOW_FIELD_RW)
+#if !defined(__SHADOW_FIELD_RO) && !defined(__SHADOW_FIELD_RW)
 BUILD_BUG_ON(1)
 #endif
 
-#ifndef SHADOW_FIELD_RO
-#define SHADOW_FIELD_RO(x, y)
+#ifndef __SHADOW_FIELD_RO
+#define __SHADOW_FIELD_RO(x, y, c)
 #endif
-#ifndef SHADOW_FIELD_RW
-#define SHADOW_FIELD_RW(x, y)
+#ifndef __SHADOW_FIELD_RW
+#define __SHADOW_FIELD_RW(x, y, c)
 #endif
 
+#define SHADOW_FIELD_RO(x, y) __SHADOW_FIELD_RO(x, y, true)
+#define SHADOW_FIELD_RW(x, y) __SHADOW_FIELD_RW(x, y, true)
+
 /*
  * We do NOT shadow fields that are modified when L0
  * traps and emulates any vmx instruction (e.g. VMPTRLD,
@@ -32,8 +35,12 @@ BUILD_BUG_ON(1)
  */
 
 /* 16-bits */
-SHADOW_FIELD_RW(GUEST_INTR_STATUS, guest_intr_status)
-SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index)
+__SHADOW_FIELD_RW(GUEST_INTR_STATUS, guest_intr_status, cpu_has_vmx_apicv())
+/*
+ * PML can be emulated, but the processor cannot vmwrite to the VMCS field
+ * GUEST_PML_INDEX that doesn't exist on bare metal.
+ */
+__SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index, cpu_has_vmx_pml())
 SHADOW_FIELD_RW(HOST_FS_SELECTOR, host_fs_selector)
 SHADOW_FIELD_RW(HOST_GS_SELECTOR, host_gs_selector)
 
@@ -41,9 +48,9 @@ SHADOW_FIELD_RW(HOST_GS_SELECTOR, host_gs_selector)
 SHADOW_FIELD_RO(VM_EXIT_REASON, vm_exit_reason)
 SHADOW_FIELD_RO(VM_EXIT_INTR_INFO, vm_exit_intr_info)
 SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len)
+SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code)
 SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field)
 SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code)
-SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code)
 SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
 SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
@@ -54,7 +61,12 @@ SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
 SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len)
 SHADOW_FIELD_RW(TPR_THRESHOLD, tpr_threshold)
 SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info)
-SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value)
+/*
+ * The preemption timer can be emulated, but the processor cannot vmwrite to
+ * the VMCS field VMX_PREEMPTION_TIMER_VALUE that doesn't exist on bare metal.
+ */
+__SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value,
+		  cpu_has_vmx_preemption_timer())
 
 /* Natural width */
 SHADOW_FIELD_RO(EXIT_QUALIFICATION, exit_qualification)
@@ -74,10 +86,13 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 /* 64-bit */
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
-SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data)
-SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data)
-SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data)
-SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data)
+__SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data, cpu_has_vmx_fred())
 
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW
+
+#undef __SHADOW_FIELD_RO
+#undef __SHADOW_FIELD_RW
-- 
2.50.1


