Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940F06B6492
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCLJ7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCLJ7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6091BDB
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615090; x=1710151090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/sdHpgzQ/Bd74GZ/BXtP6YpvGRP+ohbg7dz9WG0WK8=;
  b=C+45MCOIUA9+k4aFR0K0NRuqG8s0IrCp5J67pY579ssEr8BG5uvb4NQb
   3tQA33E5uWgYmHofLvIdXi2azPbkpyR3J1yck29Ebi87IcB4C2SSEUNco
   Lgg/+b3+hWcJhFiNyopZdSWa9wjfd1Cpqbqp/jjUlkQfIrIskEqNyCRWe
   YC0nsIjgyh+TKUlv4KxFE7wVbk9FnFH91h5KKqZTfMYR/1FKODMIrna8d
   lbaEmHC7ozPTYIw+DMIF8d1OBfx/eDIrdQzR68oMxoCGlPzSbK8xlfv3v
   DmOs+DrkNgyaJUCf4w5uxkHSjNlXh0IPckp0IFnr/gGR7TMNPcvETr+Qe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998127"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998127"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677753"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677753"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:28 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 17/22] pkvm: x86: Add VMPTRLD/VMCLEAR emulation
Date:   Mon, 13 Mar 2023 02:02:58 +0800
Message-Id: <20230312180303.1778492-18-jason.cj.chen@intel.com>
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

pKVM is designed to emulate VMX for host VM based on shadow vmcs.
The shadow vmcs page (vmcs02) in root mode is kept in the structure
shadow_vcpu_state, which allocated then donated from host VM when it
initialize vcpus for its launched guest (nested). Same for field of
cached_vmcs12 which used to cache no shadowed vmcs fields.

pKVM use vmcs02 as the shadow vmcs pointer of nested guest when host
VM program its vmcs fields, then switch vmcs02 to ordinary vmcs for the
vmlaunch/vmresume of same guest.

For a nested guest, during its vmcs programing from host VM, its virtual
vmcs(vmcs12) is saved in two places: one is shadowing fields in vmcs02
which host VM directly VMWRITE without vmexit, the other one is
cached_vmcs12 which saved by vmwrite vmexit handler upon the vmexit
triggered by VMWRITE instruction from host VM.

Meanwhile for cached_vmcs12, there are also two parts for its
fields: one is emulated fields, the other one is host state fields. The
emulated fields shall be emulated to the physical value then fill into
vmcs02 before vmcs02 active to do vmlaunch/vmresume for the nested guest.
The host state fields are guest state of host vcpu, it shall be restored
to guest state of host vcpu vmcs (vmcs01) before return to host VM.

Below is a summary for contents of different vmcs fields in each above
mentioned vmcs:

               host state      guest state          control
 ---------------------------------------------------------------
 vmcs12*:       host VM	      nested guest         host VM
 vmcs02*:        pKVM         nested guest      host VM + pKVM*
 vmcs01*:        pKVM           host VM              pKVM

 *vmcs12: virtual vmcs of a nested guest
 *vmcs02: vmcs of a nested guest
 *vmcs01: vmcs of host VM
 *the security related control fields of vmcs02 is controlled by pKVM
  (e.g., EPT_POINTER)

Below show the vmcs emulation method for different vmcs fields for a
nested guest:

                host state      guest state         control
 ---------------------------------------------------------------
 virutal vmcs:  cached_vmcs12*     vmcs02*          emulated*

 *cached_vmcs12: vmexit then get value from cached_vmcs12
 *vmcs02:        no-vmexit and directly shadow from vmcs02
 *emulated:      vmexit then do the emulation

This patch provide emulation for VMPTRLD and VMCLEAR vmx instructions.

For VMPTRLD, it first finds out shadow_vcpu_state (further to get its
cached_vmcs12 & vmcs02) based on vmcs12 fetched from this instruction,
then copy the whole virtual vmcs - vmcs12's content to the corresponding
cached_vmcs12. The vmcs02 is then filled based on 3 different parts:
- host state fields: initialized by pKVM as it's the real host
- shadow fields: copied from cached_vmcs12
- emulated fields: synced & emulated from cached_vmcs12

For VMCLEAR, the vmcs02 shadow fields are copied to cached_vmcs12, then
the whole cached_vmcs12 is saved to virtual vmcs pointer - vmcs12.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c   | 268 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h   |   2 +
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |   8 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   |  10 +
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |   2 +
 5 files changed, 290 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 8e6d0f01819a..dab002ff3c68 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -6,6 +6,7 @@
 #include <pkvm.h>
 
 #include "pkvm_hyp.h"
+#include "vmx.h"
 #include "debug.h"
 
 /**
@@ -223,6 +224,11 @@ static void init_emulated_vmcs_fields(void)
 	max_emulated_fields = j;
 }
 
+static bool is_host_fields(unsigned long field)
+{
+	return (((field) >> 10U) & 0x3U) == 3U;
+}
+
 static void nested_vmx_result(enum VMXResult result, int error_number)
 {
 	u64 rflags = vmcs_readl(GUEST_RFLAGS);
@@ -363,6 +369,163 @@ static bool check_vmx_permission(struct kvm_vcpu *vcpu)
 	return permit;
 }
 
+static void clear_shadow_indicator(struct vmcs *vmcs)
+{
+	vmcs->hdr.shadow_vmcs = 0;
+}
+
+static void set_shadow_indicator(struct vmcs *vmcs)
+{
+	vmcs->hdr.shadow_vmcs = 1;
+}
+
+/* current vmcs is vmcs02 */
+static void copy_shadow_fields_vmcs02_to_vmcs12(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+{
+	const struct shadow_vmcs_field *fields[] = {
+		shadow_read_write_fields,
+		shadow_read_only_fields
+	};
+	const int max_fields[] = {
+		max_shadow_read_write_fields,
+		max_shadow_read_only_fields
+	};
+	struct shadow_vmcs_field field;
+	unsigned long val;
+	int i, q;
+
+	for (q = 0; q < ARRAY_SIZE(fields); q++) {
+		for (i = 0; i < max_fields[q]; i++) {
+			field = fields[q][i];
+			val = __vmcs_readl(field.encoding);
+			if (is_host_fields((field.encoding))) {
+				pkvm_err("%s: field 0x%x is host field, please remove from shadowing!",
+						__func__, field.encoding);
+				continue;
+			}
+			vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
+		}
+	}
+}
+
+/* current vmcs is vmcs02 */
+static void copy_shadow_fields_vmcs12_to_vmcs02(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+{
+	const struct shadow_vmcs_field *fields[] = {
+		shadow_read_write_fields,
+		shadow_read_only_fields
+	};
+	const int max_fields[] = {
+		max_shadow_read_write_fields,
+		max_shadow_read_only_fields
+	};
+	struct shadow_vmcs_field field;
+	unsigned long val;
+	int i, q;
+
+	for (q = 0; q < ARRAY_SIZE(fields); q++) {
+		for (i = 0; i < max_fields[q]; i++) {
+			field = fields[q][i];
+			val = vmcs12_read_any(vmcs12, field.encoding,
+					      field.offset);
+			if (is_host_fields((field.encoding))) {
+				pkvm_err("%s: field 0x%x is host field, please remove from shadowing!",
+						__func__, field.encoding);
+				continue;
+			}
+			__vmcs_writel(field.encoding, val);
+		}
+	}
+}
+
+/* current vmcs is vmcs02*/
+static u64 emulate_field_for_vmcs02(struct vcpu_vmx *vmx, u16 field, u64 virt_val)
+{
+	u64 val = virt_val;
+
+	switch (field) {
+	case VM_ENTRY_CONTROLS:
+		/* L1 host wishes to use its own MSRs for L2 guest?
+		 * emulate it by enabling vmentry load for such guest states
+		 * then use vmcs01 saved guest states as vmcs02's guest states
+		 */
+		if ((val & VM_ENTRY_LOAD_IA32_EFER) != VM_ENTRY_LOAD_IA32_EFER)
+			val |= VM_ENTRY_LOAD_IA32_EFER;
+		if ((val & VM_ENTRY_LOAD_IA32_PAT) != VM_ENTRY_LOAD_IA32_PAT)
+			val |= VM_ENTRY_LOAD_IA32_PAT;
+		if ((val & VM_ENTRY_LOAD_DEBUG_CONTROLS) != VM_ENTRY_LOAD_DEBUG_CONTROLS)
+			val |= VM_ENTRY_LOAD_DEBUG_CONTROLS;
+		break;
+	case VM_EXIT_CONTROLS:
+		/* L1 host wishes to keep use MSRs from L2 guest after its VMExit?
+		 * emulate it by enabling vmexit save for such guest states
+		 * then vmcs01 shall take these guest states as its before L1 VMEntry
+		 *
+		 * And vmcs01 shall still keep enabling vmexit load such guest states as
+		 * pkvm need restore from its host states
+		 */
+		if ((val & VM_EXIT_LOAD_IA32_EFER) != VM_EXIT_LOAD_IA32_EFER)
+			val |= (VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER);
+		if ((val & VM_EXIT_LOAD_IA32_PAT) != VM_EXIT_LOAD_IA32_PAT)
+			val |= (VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT);
+		/* host always in 64bit mode */
+		val |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
+		break;
+	}
+	return val;
+}
+
+/* current vmcs is vmcs02*/
+static void sync_vmcs12_dirty_fields_to_vmcs02(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+{
+	struct shadow_vmcs_field field;
+	unsigned long val, phys_val;
+	int i;
+
+	if (vmx->nested.dirty_vmcs12) {
+		for (i = 0; i < max_emulated_fields; i++) {
+			field = emulated_fields[i];
+			val = vmcs12_read_any(vmcs12, field.encoding, field.offset);
+			phys_val = emulate_field_for_vmcs02(vmx, field.encoding, val);
+			__vmcs_writel(field.encoding, phys_val);
+		}
+		vmx->nested.dirty_vmcs12 = false;
+	}
+}
+
+static void nested_release_vmcs12(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *cur_shadow_vcpu = pkvm_hvcpu->current_shadow_vcpu;
+	struct vmcs *vmcs02;
+	struct vmcs12 *vmcs12;
+
+	if (vmx->nested.current_vmptr == INVALID_GPA)
+		return;
+
+	/* cur_shadow_vcpu must be valid here */
+	vmcs02 = (struct vmcs *)cur_shadow_vcpu->vmcs02;
+	vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
+	vmcs_load_track(vmx, vmcs02);
+	copy_shadow_fields_vmcs02_to_vmcs12(vmx, vmcs12);
+
+	vmcs_clear_track(vmx, vmcs02);
+	clear_shadow_indicator(vmcs02);
+
+	/*disable shadowing*/
+	vmcs_load_track(vmx, vmx->loaded_vmcs->vmcs);
+	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
+	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
+
+	write_gpa(vcpu, vmx->nested.current_vmptr, vmcs12, VMCS12_SIZE);
+	vmx->nested.dirty_vmcs12 = false;
+	vmx->nested.current_vmptr = INVALID_GPA;
+	pkvm_hvcpu->current_shadow_vcpu = NULL;
+
+	put_shadow_vcpu(cur_shadow_vcpu->shadow_vcpu_handle);
+}
+
 int handle_vmxon(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -379,6 +542,8 @@ int handle_vmxon(struct kvm_vcpu *vcpu)
 		} else if (!validate_vmcs_revision_id(vcpu, vmptr)) {
 			nested_vmx_result(VMfailInvalid, 0);
 		} else {
+			vmx->nested.current_vmptr = INVALID_GPA;
+			vmx->nested.dirty_vmcs12 = false;
 			vmx->nested.vmxon_ptr = vmptr;
 			vmx->nested.vmxon = true;
 
@@ -403,6 +568,109 @@ int handle_vmxoff(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int handle_vmptrld(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *shadow_vcpu;
+	struct vmcs *vmcs02;
+	struct vmcs12 *vmcs12;
+	gpa_t vmptr;
+	int r;
+
+	if (check_vmx_permission(vcpu)) {
+		if (nested_vmx_get_vmptr(vcpu, &vmptr, &r)) {
+			nested_vmx_result(VMfailValid, VMXERR_VMPTRLD_INVALID_ADDRESS);
+			return r;
+		} else if (vmptr == vmx->nested.vmxon_ptr) {
+			nested_vmx_result(VMfailValid, VMXERR_VMPTRLD_VMXON_POINTER);
+		} else if (!validate_vmcs_revision_id(vcpu, vmptr)) {
+			nested_vmx_result(VMfailValid, VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
+		} else {
+			if (vmx->nested.current_vmptr != vmptr) {
+				s64 handle;
+
+				nested_release_vmcs12(vcpu);
+
+				handle = find_shadow_vcpu_handle_by_vmcs(vmptr);
+				shadow_vcpu = handle > 0 ? get_shadow_vcpu(handle) : NULL;
+				if ((handle > 0) && shadow_vcpu) {
+					vmcs02 = (struct vmcs *)shadow_vcpu->vmcs02;
+					vmcs12 = (struct vmcs12 *) shadow_vcpu->cached_vmcs12;
+
+					read_gpa(vcpu, vmptr, vmcs12, VMCS12_SIZE);
+					vmx->nested.dirty_vmcs12 = true;
+
+					if (!shadow_vcpu->vmcs02_inited) {
+						memset(vmcs02, 0, pkvm_hyp->vmcs_config.size);
+						vmcs02->hdr.revision_id = pkvm_hyp->vmcs_config.revision_id;
+						vmcs_load_track(vmx, vmcs02);
+						pkvm_init_host_state_area(pkvm_hvcpu->pcpu, vcpu->cpu);
+						vmcs_writel(HOST_RIP, (unsigned long)__pkvm_vmx_vmexit);
+						shadow_vcpu->last_cpu = vcpu->cpu;
+						shadow_vcpu->vmcs02_inited = true;
+					} else {
+						vmcs_load_track(vmx, vmcs02);
+						if (shadow_vcpu->last_cpu != vcpu->cpu) {
+							pkvm_init_host_state_area(pkvm_hvcpu->pcpu, vcpu->cpu);
+							shadow_vcpu->last_cpu = vcpu->cpu;
+						}
+					}
+					copy_shadow_fields_vmcs12_to_vmcs02(vmx, vmcs12);
+					sync_vmcs12_dirty_fields_to_vmcs02(vmx, vmcs12);
+					vmcs_clear_track(vmx, vmcs02);
+					set_shadow_indicator(vmcs02);
+
+					/* enable shadowing */
+					vmcs_load_track(vmx, vmx->loaded_vmcs->vmcs);
+					vmcs_write64(VMREAD_BITMAP, __pkvm_pa_symbol(vmx_vmread_bitmap));
+					vmcs_write64(VMWRITE_BITMAP, __pkvm_pa_symbol(vmx_vmwrite_bitmap));
+					secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
+					vmcs_write64(VMCS_LINK_POINTER, __pkvm_pa(vmcs02));
+
+					vmx->nested.current_vmptr = vmptr;
+					pkvm_hvcpu->current_shadow_vcpu = shadow_vcpu;
+
+					nested_vmx_result(VMsucceed, 0);
+				} else {
+					nested_vmx_result(VMfailValid, VMXERR_VMPTRLD_INVALID_ADDRESS);
+				}
+			} else {
+				nested_vmx_result(VMsucceed, 0);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int handle_vmclear(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gpa_t vmptr;
+	u32 zero = 0;
+	int r;
+
+	if (check_vmx_permission(vcpu)) {
+		if (nested_vmx_get_vmptr(vcpu, &vmptr, &r)) {
+			nested_vmx_result(VMfailValid, VMXERR_VMPTRLD_INVALID_ADDRESS);
+			return r;
+		} else if (vmptr == vmx->nested.vmxon_ptr) {
+			nested_vmx_result(VMfailValid, VMXERR_VMCLEAR_VMXON_POINTER);
+		} else {
+			if (vmx->nested.current_vmptr == vmptr)
+				nested_release_vmcs12(vcpu);
+
+			write_gpa(vcpu, vmptr + offsetof(struct vmcs12, launch_state),
+					&zero, sizeof(zero));
+
+			nested_vmx_result(VMsucceed, 0);
+		}
+	}
+
+	return 0;
+}
+
 void pkvm_init_nest(void)
 {
 	init_vmcs_shadow_fields();
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index 16b70b13e80e..a228b0fdc15d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -7,6 +7,8 @@
 
 int handle_vmxon(struct kvm_vcpu *vcpu);
 int handle_vmxoff(struct kvm_vcpu *vcpu);
+int handle_vmptrld(struct kvm_vcpu *vcpu);
+int handle_vmclear(struct kvm_vcpu *vcpu);
 void pkvm_init_nest(void);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index c574831c6d18..82a59b5d7fd5 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -23,8 +23,16 @@ struct shadow_vcpu_state {
 
 	struct hlist_node hnode;
 	unsigned long vmcs12_pa;
+	bool vmcs02_inited;
 
 	struct vcpu_vmx vmx;
+
+	/* assume vmcs02 is one page */
+	u8 vmcs02[PAGE_SIZE] __aligned(PAGE_SIZE);
+	u8 cached_vmcs12[VMCS12_SIZE] __aligned(PAGE_SIZE);
+
+	/* The last cpu this vmcs02 runs with */
+	int last_cpu;
 } __aligned(PAGE_SIZE);
 
 #define SHADOW_VM_HANDLE_SHIFT		32
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index fa67cab803a8..b2cfb87983a8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -206,6 +206,16 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			handle_vmxoff(vcpu);
 			skip_instruction = true;
 			break;
+		case EXIT_REASON_VMPTRLD:
+			pkvm_dbg("CPU%d vmexit reason: VMPTRLD.\n", vcpu->cpu);
+			handle_vmptrld(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_VMCLEAR:
+			pkvm_dbg("CPU%d vmexit reason: VMCLEAR.\n", vcpu->cpu);
+			handle_vmclear(vcpu);
+			skip_instruction = true;
+			break;
 		case EXIT_REASON_XSETBV:
 			handle_xsetbv(vcpu);
 			skip_instruction = true;
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index d5393d477df1..9b45627853b3 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -35,6 +35,8 @@ struct pkvm_host_vcpu {
 	struct vmcs *vmxarea;
 	struct vmcs *current_vmcs;
 
+	void *current_shadow_vcpu;
+
 	bool pending_nmi;
 };
 
-- 
2.25.1

