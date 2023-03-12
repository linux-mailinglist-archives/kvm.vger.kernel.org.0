Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287FA6B6487
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCLJ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCLJ6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5591E59E40
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615067; x=1710151067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UBORKTSHJG2huhBSPoOas5uLzSZ8D0iXCqIjszww7LU=;
  b=kn9kwPoi5NNTvWgk+y0G0E0/SW9+AyfeeZQo6lw/UBEA95xFEen+NMOG
   CZfDZ8ymZx8H5HoADabnmr+IMGNKqxlxw2nN8tU1ocB2kiGB83auGRR4q
   CfV26HUlHh3rkf+1aF/OQ6jZuuOwfk2RXY1RgQiNE7F8PAPv44TpNID7i
   ca0iZc1poau/HmOpL+fbm4idSJldESJv2Yqu40DOJIBtHEKtPRwZN6+Tg
   TjKJvvkns6o9nFyhsWpaFv1syY4yFIqvjPStn4xIk99s4mvtJtNx+Dvj3
   mCz3oRINwNkfr1IzacJE3H+g5LejyaL1c7nEn/ZfSIauPFJ6BKK665TaM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998112"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998112"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677702"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677702"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:19 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 09/22] pkvm: x86: Add VMXON/VMXOFF emulation
Date:   Mon, 13 Mar 2023 02:02:50 +0800
Message-Id: <20230312180303.1778492-10-jason.cj.chen@intel.com>
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

Host VM keep the capability to launch its guests based on VMX, pKVM
need to provide VMX emulation for it. This includes emulations for
different VMX instructions - VMXON/VMXOFF, VMPTRLD/VMCLEAR,
VMWRITE/VMREAD, and VMRESUME/VMLAUNCH.

This patch introduces nested.c, and provide emulation for VMXON and
VMXOFF vmx instructions for host VM.

The emulation simply does state check and revision id validation for
vmxarea passed from VMXON/VMXOFF instructions, the physical VMX is kept
as enabled after the pKVM initialization.

More permission check still leaves as TODO.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile |   2 +-
 arch/x86/kvm/vmx/pkvm/hyp/nested.c | 195 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h |  11 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c |  12 ++
 4 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 7c6f71f18676..660fd611395f 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o ept.o idt.o irq.o
+		   init_finalise.o ept.o idt.o irq.o nested.o
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
new file mode 100644
index 000000000000..f5e2eb8f51c8
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+
+#include "pkvm_hyp.h"
+#include "debug.h"
+
+enum VMXResult {
+	VMsucceed,
+	VMfailValid,
+	VMfailInvalid,
+};
+
+static void nested_vmx_result(enum VMXResult result, int error_number)
+{
+	u64 rflags = vmcs_readl(GUEST_RFLAGS);
+
+	rflags &= ~(X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF |
+			X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF);
+
+	if (result == VMfailValid) {
+		rflags |= X86_EFLAGS_ZF;
+		vmcs_write32(VM_INSTRUCTION_ERROR, error_number);
+	} else if (result == VMfailInvalid) {
+		rflags |= X86_EFLAGS_CF;
+	} else {
+		/* VMsucceed, do nothing */
+	}
+
+	if (result != VMsucceed)
+		pkvm_err("VMX failed: %d/%d", result, error_number);
+
+	vmcs_writel(GUEST_RFLAGS, rflags);
+}
+
+static int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
+			u32 vmx_instruction_info, gva_t *ret)
+{
+	gva_t off;
+	struct kvm_segment s;
+
+	/*
+	 * According to Vol. 3B, "Information for VM Exits Due to Instruction
+	 * Execution", on an exit, vmx_instruction_info holds most of the
+	 * addressing components of the operand. Only the displacement part
+	 * is put in exit_qualification (see 3B, "Basic VM-Exit Information").
+	 * For how an actual address is calculated from all these components,
+	 * refer to Vol. 1, "Operand Addressing".
+	 */
+	int  scaling = vmx_instruction_info & 3;
+	int  addr_size = (vmx_instruction_info >> 7) & 7;
+	bool is_reg = vmx_instruction_info & (1u << 10);
+	int  seg_reg = (vmx_instruction_info >> 15) & 7;
+	int  index_reg = (vmx_instruction_info >> 18) & 0xf;
+	bool index_is_valid = !(vmx_instruction_info & (1u << 22));
+	int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
+	bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
+
+	if (is_reg) {
+		/* TODO: inject #UD */
+		return 1;
+	}
+
+	/* Addr = segment_base + offset */
+	/* offset = base + [index * scale] + displacement */
+	off = exit_qualification; /* holds the displacement */
+	if (addr_size == 1)
+		off = (gva_t)sign_extend64(off, 31);
+	else if (addr_size == 0)
+		off = (gva_t)sign_extend64(off, 15);
+	if (base_is_valid)
+		off += vcpu->arch.regs[base_reg];
+	if (index_is_valid)
+		off += vcpu->arch.regs[index_reg] << scaling;
+
+	if (seg_reg == VCPU_SREG_FS)
+		s.base = vmcs_readl(GUEST_FS_BASE);
+	if (seg_reg == VCPU_SREG_GS)
+		s.base = vmcs_readl(GUEST_GS_BASE);
+
+	/* TODO: support more cpu mode beside long mode */
+	/*
+	 * The effective address, i.e. @off, of a memory operand is truncated
+	 * based on the address size of the instruction.  Note that this is
+	 * the *effective address*, i.e. the address prior to accounting for
+	 * the segment's base.
+	 */
+	if (addr_size == 1) /* 32 bit */
+		off &= 0xffffffff;
+	else if (addr_size == 0) /* 16 bit */
+		off &= 0xffff;
+
+	/*
+	 * The virtual/linear address is never truncated in 64-bit
+	 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
+	 * address when using FS/GS with a non-zero base.
+	 */
+	if (seg_reg == VCPU_SREG_FS || seg_reg == VCPU_SREG_GS)
+		*ret = s.base + off;
+	else
+		*ret = off;
+
+	/* TODO: check addr is canonical, otherwise inject #GP/#SS */
+
+	return 0;
+}
+
+static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
+				int *ret)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gva_t gva;
+	struct x86_exception e;
+	int r;
+
+	if (get_vmx_mem_address(vcpu, vmx->exit_qualification,
+			vmcs_read32(VMX_INSTRUCTION_INFO), &gva)) {
+		*ret = 1;
+		return -EINVAL;
+	}
+
+	r = read_gva(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
+	if (r < 0) {
+		/*TODO: handle memory failure exception */
+		*ret = 1;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int validate_vmcs_revision_id(struct kvm_vcpu *vcpu, gpa_t vmpointer)
+{
+	struct vmcs_config *vmcs_config = &pkvm_hyp->vmcs_config;
+	u32 rev_id;
+
+	read_gpa(vcpu, vmpointer, &rev_id, sizeof(rev_id));
+
+	return (rev_id == vmcs_config->revision_id);
+}
+
+static bool check_vmx_permission(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool permit = true;
+
+	/*TODO: check more env (cr, cpl) and inject #UD/#GP */
+	if (!vmx->nested.vmxon)
+		permit = false;
+
+	return permit;
+}
+
+int handle_vmxon(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gpa_t vmptr;
+	int r;
+
+	/*TODO: check env error(cr, efer, rflags, cpl) */
+	if (vmx->nested.vmxon) {
+		nested_vmx_result(VMfailValid, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
+	} else {
+		if (nested_vmx_get_vmptr(vcpu, &vmptr, &r)) {
+			nested_vmx_result(VMfailInvalid, 0);
+			return r;
+		} else if (!validate_vmcs_revision_id(vcpu, vmptr)) {
+			nested_vmx_result(VMfailInvalid, 0);
+		} else {
+			vmx->nested.vmxon_ptr = vmptr;
+			vmx->nested.vmxon = true;
+
+			nested_vmx_result(VMsucceed, 0);
+		}
+	}
+
+	return 0;
+}
+
+int handle_vmxoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (check_vmx_permission(vcpu)) {
+		vmx->nested.vmxon = false;
+		vmx->nested.vmxon_ptr = INVALID_GPA;
+
+		nested_vmx_result(VMsucceed, 0);
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
new file mode 100644
index 000000000000..2d21edaddb25
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_NESTED_H
+#define __PKVM_NESTED_H
+
+int handle_vmxon(struct kvm_vcpu *vcpu);
+int handle_vmxoff(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 6b82b6be612c..fa67cab803a8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -9,6 +9,7 @@
 #include "vmexit.h"
 #include "ept.h"
 #include "pkvm_hyp.h"
+#include "nested.h"
 #include "debug.h"
 
 #define CR4	4
@@ -168,6 +169,7 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 
 		vcpu->arch.cr2 = native_read_cr2();
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
 
 		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
@@ -194,6 +196,16 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			handle_write_msr(vcpu);
 			skip_instruction = true;
 			break;
+		case EXIT_REASON_VMON:
+			pkvm_dbg("CPU%d vmexit reason: VMXON.\n", vcpu->cpu);
+			handle_vmxon(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_VMOFF:
+			pkvm_dbg("CPU%d vmexit reason: VMXOFF.\n", vcpu->cpu);
+			handle_vmxoff(vcpu);
+			skip_instruction = true;
+			break;
 		case EXIT_REASON_XSETBV:
 			handle_xsetbv(vcpu);
 			skip_instruction = true;
-- 
2.25.1

