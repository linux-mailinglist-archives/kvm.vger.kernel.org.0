Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB976B648A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCLJ7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCLJ6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4141A4
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615076; x=1710151076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qSoxIzhzQIDKtMeiFHgmR6eN7S3PKHXpoCu+jjFpuP8=;
  b=AkLi1PpfJThT2eozX4XjpM9advE0YQXEzqwo4Je7yxh6k3dGe7Cz4C4i
   SGtD1ooenc9f0R9obIUl+QZS45PEG567HatCbauokNu0x7SkhugnDiidm
   bwH8tOVvUgYO3GJ/Z1nRqOL1AwMAUbDOmDAcI8Z+7CQ8O4UU8yvCzmN2+
   SnFhAWasYoiaJaxeB8Qc+bKALuX+nWDt7Ypx/krX+OEkWOvS3/qdn/+B2
   hyscgSUN6QNLUs3d3iFXHeez6jlNzQByCn8QiOc/H9WoxRpO7hm64kSBE
   lAxvQ9QuhEdOIMfd5lcnX1vNLiq4bmixlxszGfd94ZalUM1P4OGD/ffgF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998117"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998117"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677719"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677719"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:22 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 12/22] pkvm: x86: Init vmcs read/write bitmap for vmcs emulation
Date:   Mon, 13 Mar 2023 02:02:53 +0800
Message-Id: <20230312180303.1778492-13-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As pKVM is designed to use shadow vmcs to support nested guest, the
vmread/vmwrite bitmap are prepared by filtering out shadow field bits,
such bitmap shall finally be set into VMREAD_BITMAP/VMWRITE_BITMAP
fields to indicate the interception fields of VMREAD/VMWRITE instruction.
Meanwhile for other fields as shadowing part, host VM can directly
VMREAD/WMWRITE them without causing vmexit [1].

Introduce pkvm_nested_vmcs_fields.h to help pre-define the shadow fields
which is refer from vmx/vmcs_shadow_fields.h.

[1]: SDM: Virtual Machine Control Structures chapter, VMCS TYPES.

Signed-off-by: Jason Cthen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c     |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/nested.c            |  77 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h            |   1 +
 .../vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h    | 156 ++++++++++++++++++
 4 files changed, 237 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index 8c585a73237a..c16b53b7bcd0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -17,6 +17,7 @@
 #include "mmu.h"
 #include "ept.h"
 #include "vmx.h"
+#include "nested.h"
 #include "debug.h"
 
 void *pkvm_mmu_pgt_base;
@@ -288,6 +289,8 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 	if (ret)
 		goto out;
 
+	pkvm_init_nest();
+
 	pkvm_init = true;
 
 switch_pgt:
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 31ad33f2cdbf..8ae37feda5ff 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -129,6 +129,78 @@ enum VMXResult {
 	VMfailInvalid,
 };
 
+struct shadow_vmcs_field {
+	u16	encoding;
+	u16	offset;
+};
+
+static u8 vmx_vmread_bitmap[PAGE_SIZE] __aligned(PAGE_SIZE);
+static u8 vmx_vmwrite_bitmap[PAGE_SIZE] __aligned(PAGE_SIZE);
+
+static struct shadow_vmcs_field shadow_read_only_fields[] = {
+#define SHADOW_FIELD_RO(x, y) { x, offsetof(struct vmcs12, y) },
+#include "pkvm_nested_vmcs_fields.h"
+};
+static int max_shadow_read_only_fields =
+	ARRAY_SIZE(shadow_read_only_fields);
+static struct shadow_vmcs_field shadow_read_write_fields[] = {
+#define SHADOW_FIELD_RW(x, y) { x, offsetof(struct vmcs12, y) },
+#include "pkvm_nested_vmcs_fields.h"
+};
+static int max_shadow_read_write_fields =
+	ARRAY_SIZE(shadow_read_write_fields);
+
+static void init_vmcs_shadow_fields(void)
+{
+	int i, j;
+
+	memset(vmx_vmread_bitmap, 0xff, PAGE_SIZE);
+	memset(vmx_vmwrite_bitmap, 0xff, PAGE_SIZE);
+
+	for (i = j = 0; i < max_shadow_read_only_fields; i++) {
+		struct shadow_vmcs_field entry = shadow_read_only_fields[i];
+		u16 field = entry.encoding;
+
+		if (!has_vmcs_field(field))
+			continue;
+
+		if (vmcs_field_width(field) == VMCS_FIELD_WIDTH_U64 &&
+		    (i + 1 == max_shadow_read_only_fields ||
+		     shadow_read_only_fields[i + 1].encoding != field + 1)) {
+			pkvm_err("Missing field from shadow_read_only_field %x\n",
+			       field + 1);
+		}
+
+		clear_bit(field, (unsigned long *)vmx_vmread_bitmap);
+		if (field & 1)
+			continue;
+		shadow_read_only_fields[j++] = entry;
+	}
+	max_shadow_read_only_fields = j;
+
+	for (i = j = 0; i < max_shadow_read_write_fields; i++) {
+		struct shadow_vmcs_field entry = shadow_read_write_fields[i];
+		u16 field = entry.encoding;
+
+		if (!has_vmcs_field(field))
+			continue;
+
+		if (vmcs_field_width(field) == VMCS_FIELD_WIDTH_U64 &&
+		    (i + 1 == max_shadow_read_write_fields ||
+		     shadow_read_write_fields[i + 1].encoding != field + 1)) {
+			pkvm_err("Missing field from shadow_read_write_field %x\n",
+			       field + 1);
+		}
+
+		clear_bit(field, (unsigned long *)vmx_vmwrite_bitmap);
+		clear_bit(field, (unsigned long *)vmx_vmread_bitmap);
+		if (field & 1)
+			continue;
+		shadow_read_write_fields[j++] = entry;
+	}
+	max_shadow_read_write_fields = j;
+}
+
 static void nested_vmx_result(enum VMXResult result, int error_number)
 {
 	u64 rflags = vmcs_readl(GUEST_RFLAGS);
@@ -308,3 +380,8 @@ int handle_vmxoff(struct kvm_vcpu *vcpu)
 
 	return 0;
 }
+
+void pkvm_init_nest(void)
+{
+	init_vmcs_shadow_fields();
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index 2d21edaddb25..16b70b13e80e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -7,5 +7,6 @@
 
 int handle_vmxon(struct kvm_vcpu *vcpu);
 int handle_vmxoff(struct kvm_vcpu *vcpu);
+void pkvm_init_nest(void);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
new file mode 100644
index 000000000000..4380d415428f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#if !defined(SHADOW_FIELD_RW) && !defined(SHADOW_FIELD_RO)
+BUILD_BUG_ON(1)
+#endif
+
+#ifndef SHADOW_FIELD_RW
+#define SHADOW_FIELD_RW(x, y)
+#endif
+#ifndef SHADOW_FIELD_RO
+#define SHADOW_FIELD_RO(x, y)
+#endif
+
+/*
+ * Shadow fields for vmcs02:
+ *
+ * These fields are HW shadowing in vmcs02, we try to shadow all non-host
+ * fields except emulated ones.
+ * Host state fields need to be recorded in cached_vmcs12 and restored to vmcs01's
+ * guest state when returning to L1 host, so please ensure __NO__ host fields below.
+ */
+
+/* 16-bits */
+SHADOW_FIELD_RW(POSTED_INTR_NV, posted_intr_nv)
+SHADOW_FIELD_RW(GUEST_ES_SELECTOR, guest_es_selector)
+SHADOW_FIELD_RW(GUEST_CS_SELECTOR, guest_cs_selector)
+SHADOW_FIELD_RW(GUEST_SS_SELECTOR, guest_ss_selector)
+SHADOW_FIELD_RW(GUEST_DS_SELECTOR, guest_ds_selector)
+SHADOW_FIELD_RW(GUEST_FS_SELECTOR, guest_fs_selector)
+SHADOW_FIELD_RW(GUEST_GS_SELECTOR, guest_gs_selector)
+SHADOW_FIELD_RW(GUEST_LDTR_SELECTOR, guest_ldtr_selector)
+SHADOW_FIELD_RW(GUEST_TR_SELECTOR, guest_tr_selector)
+SHADOW_FIELD_RW(GUEST_TR_SELECTOR, guest_tr_selector)
+SHADOW_FIELD_RW(GUEST_INTR_STATUS, guest_intr_status)
+SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index)
+
+/* 32-bits */
+SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
+SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
+SHADOW_FIELD_RW(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control)
+SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
+SHADOW_FIELD_RW(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask)
+SHADOW_FIELD_RW(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match)
+SHADOW_FIELD_RW(CR3_TARGET_COUNT, cr3_target_count)
+SHADOW_FIELD_RW(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count)
+SHADOW_FIELD_RW(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count)
+SHADOW_FIELD_RW(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count)
+SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
+SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code)
+SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len)
+SHADOW_FIELD_RW(TPR_THRESHOLD, tpr_threshold)
+SHADOW_FIELD_RW(GUEST_ES_LIMIT, guest_es_limit)
+SHADOW_FIELD_RW(GUEST_CS_LIMIT, guest_cs_limit)
+SHADOW_FIELD_RW(GUEST_SS_LIMIT, guest_ss_limit)
+SHADOW_FIELD_RW(GUEST_DS_LIMIT, guest_ds_limit)
+SHADOW_FIELD_RW(GUEST_FS_LIMIT, guest_fs_limit)
+SHADOW_FIELD_RW(GUEST_GS_LIMIT, guest_gs_limit)
+SHADOW_FIELD_RW(GUEST_LDTR_LIMIT, guest_ldtr_limit)
+SHADOW_FIELD_RW(GUEST_TR_LIMIT, guest_tr_limit)
+SHADOW_FIELD_RW(GUEST_GDTR_LIMIT, guest_gdtr_limit)
+SHADOW_FIELD_RW(GUEST_IDTR_LIMIT, guest_idtr_limit)
+SHADOW_FIELD_RW(GUEST_ES_AR_BYTES, guest_es_ar_bytes)
+SHADOW_FIELD_RW(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
+SHADOW_FIELD_RW(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
+SHADOW_FIELD_RW(GUEST_DS_AR_BYTES, guest_ds_ar_bytes)
+SHADOW_FIELD_RW(GUEST_FS_AR_BYTES, guest_fs_ar_bytes)
+SHADOW_FIELD_RW(GUEST_GS_AR_BYTES, guest_gs_ar_bytes)
+SHADOW_FIELD_RW(GUEST_LDTR_AR_BYTES, guest_ldtr_ar_bytes)
+SHADOW_FIELD_RW(GUEST_TR_AR_BYTES, guest_tr_ar_bytes)
+SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info)
+SHADOW_FIELD_RW(GUEST_ACTIVITY_STATE, guest_activity_state)
+SHADOW_FIELD_RW(GUEST_SYSENTER_CS, guest_sysenter_cs)
+SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE, vmx_preemption_timer_value)
+SHADOW_FIELD_RW(PLE_GAP, ple_gap)
+SHADOW_FIELD_RW(PLE_WINDOW, ple_window)
+
+/* Natural width */
+SHADOW_FIELD_RW(CR0_GUEST_HOST_MASK, cr0_guest_host_mask)
+SHADOW_FIELD_RW(CR4_GUEST_HOST_MASK, cr4_guest_host_mask)
+SHADOW_FIELD_RW(CR0_READ_SHADOW, cr0_read_shadow)
+SHADOW_FIELD_RW(CR4_READ_SHADOW, cr4_read_shadow)
+SHADOW_FIELD_RW(GUEST_CR0, guest_cr0)
+SHADOW_FIELD_RW(GUEST_CR3, guest_cr3)
+SHADOW_FIELD_RW(GUEST_CR4, guest_cr4)
+SHADOW_FIELD_RW(GUEST_ES_BASE, guest_es_base)
+SHADOW_FIELD_RW(GUEST_CS_BASE, guest_cs_base)
+SHADOW_FIELD_RW(GUEST_SS_BASE, guest_ss_base)
+SHADOW_FIELD_RW(GUEST_DS_BASE, guest_ds_base)
+SHADOW_FIELD_RW(GUEST_FS_BASE, guest_fs_base)
+SHADOW_FIELD_RW(GUEST_GS_BASE, guest_gs_base)
+SHADOW_FIELD_RW(GUEST_LDTR_BASE, guest_ldtr_base)
+SHADOW_FIELD_RW(GUEST_TR_BASE, guest_tr_base)
+SHADOW_FIELD_RW(GUEST_GDTR_BASE, guest_gdtr_base)
+SHADOW_FIELD_RW(GUEST_IDTR_BASE, guest_idtr_base)
+SHADOW_FIELD_RW(GUEST_DR7, guest_dr7)
+SHADOW_FIELD_RW(GUEST_RSP, guest_rsp)
+SHADOW_FIELD_RW(GUEST_RIP, guest_rip)
+SHADOW_FIELD_RW(GUEST_RFLAGS, guest_rflags)
+SHADOW_FIELD_RW(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions)
+SHADOW_FIELD_RW(GUEST_SYSENTER_ESP, guest_sysenter_esp)
+SHADOW_FIELD_RW(GUEST_SYSENTER_EIP, guest_sysenter_eip)
+
+/* 64-bit */
+SHADOW_FIELD_RW(TSC_OFFSET, tsc_offset)
+SHADOW_FIELD_RW(TSC_OFFSET_HIGH, tsc_offset)
+SHADOW_FIELD_RW(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr)
+SHADOW_FIELD_RW(VIRTUAL_APIC_PAGE_ADDR_HIGH, virtual_apic_page_addr)
+SHADOW_FIELD_RW(APIC_ACCESS_ADDR, apic_access_addr)
+SHADOW_FIELD_RW(APIC_ACCESS_ADDR_HIGH, apic_access_addr)
+SHADOW_FIELD_RW(TSC_MULTIPLIER, tsc_multiplier)
+SHADOW_FIELD_RW(TSC_MULTIPLIER_HIGH, tsc_multiplier)
+SHADOW_FIELD_RW(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl)
+SHADOW_FIELD_RW(GUEST_IA32_DEBUGCTL_HIGH, guest_ia32_debugctl)
+SHADOW_FIELD_RW(GUEST_IA32_PAT, guest_ia32_pat)
+SHADOW_FIELD_RW(GUEST_IA32_PAT_HIGH, guest_ia32_pat)
+SHADOW_FIELD_RW(GUEST_IA32_EFER, guest_ia32_efer)
+SHADOW_FIELD_RW(GUEST_IA32_EFER_HIGH, guest_ia32_efer)
+SHADOW_FIELD_RW(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl)
+SHADOW_FIELD_RW(GUEST_IA32_PERF_GLOBAL_CTRL_HIGH, guest_ia32_perf_global_ctrl)
+SHADOW_FIELD_RW(GUEST_PDPTR0, guest_pdptr0)
+SHADOW_FIELD_RW(GUEST_PDPTR0_HIGH, guest_pdptr0)
+SHADOW_FIELD_RW(GUEST_PDPTR1, guest_pdptr1)
+SHADOW_FIELD_RW(GUEST_PDPTR1_HIGH, guest_pdptr1)
+SHADOW_FIELD_RW(GUEST_PDPTR2, guest_pdptr2)
+SHADOW_FIELD_RW(GUEST_PDPTR2_HIGH, guest_pdptr2)
+SHADOW_FIELD_RW(GUEST_PDPTR3, guest_pdptr3)
+SHADOW_FIELD_RW(GUEST_PDPTR3_HIGH, guest_pdptr3)
+SHADOW_FIELD_RW(GUEST_BNDCFGS, guest_bndcfgs)
+SHADOW_FIELD_RW(GUEST_BNDCFGS_HIGH, guest_bndcfgs)
+
+/* 32-bits */
+SHADOW_FIELD_RO(VM_INSTRUCTION_ERROR, vm_instruction_error)
+SHADOW_FIELD_RO(VM_EXIT_REASON, vm_exit_reason)
+SHADOW_FIELD_RO(VM_EXIT_INTR_INFO, vm_exit_intr_info)
+SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code)
+SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field)
+SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code)
+SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len)
+SHADOW_FIELD_RO(VMX_INSTRUCTION_INFO, vmx_instruction_info)
+
+/* Natural width */
+SHADOW_FIELD_RO(EXIT_QUALIFICATION, exit_qualification)
+SHADOW_FIELD_RO(EXIT_IO_RCX, exit_io_rcx)
+SHADOW_FIELD_RO(EXIT_IO_RSI, exit_io_rsi)
+SHADOW_FIELD_RO(EXIT_IO_RDI, exit_io_rdi)
+SHADOW_FIELD_RO(EXIT_IO_RIP, exit_io_rip)
+SHADOW_FIELD_RO(GUEST_LINEAR_ADDRESS, guest_linear_address)
+
+/* 64-bit */
+SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
+SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
+
+#undef SHADOW_FIELD_RW
+#undef SHADOW_FIELD_RO
-- 
2.25.1

