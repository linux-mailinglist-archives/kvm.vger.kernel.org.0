Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF86B6495
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCLJ7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCLJ7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0692B206A7
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615091; x=1710151091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDXkTd3y9b80ZILpCUsrYyckZmMX/7NQwu4kGJjbEys=;
  b=T9al7X07eRfaVK8hy3rJ169Ov8f3KxJm8IUReiXIji6hoqeHQRYNvCb3
   3kpbnB/N/qhUvAM0lL5D+/FiDP5c9XXBtAdnq4DSSF0iKKIAoWvvaq0fc
   OUth7GditeRUQgyns772qFCFqzx0VGET/dkyZ3kBuAi5xHv8joV1FAwts
   ojkS5zOlPhsuDo00JfQJceC1XN0Qd++nP3XN4KwANaa+mQsVfT1dz4qkc
   eEjv0XdPXpRyIa4E/lRcB6VjpG8X6I2T80XeHVxLjZJr0jPT44U32RUs7
   dP9sq4w+sj8qRkEJZGi5CON0rCZQKI3h/of8SJXyeJsBLxFDqotRfkjhC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998129"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998129"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677774"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677774"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:30 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 19/22] pkvm: x86: Add VMLAUNCH/VMRESUME emulation
Date:   Mon, 13 Mar 2023 02:03:00 +0800
Message-Id: <20230312180303.1778492-20-jason.cj.chen@intel.com>
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

Provide emulation for VMLAUNCH and VMRESUME vmx instructions.

As pKVM uses vmcs02 to do most part of vmcs12 guest fields shadowing,
before vmcs02 active, it does not need to take care this part of vmcs
fields. Meanwhile there are still emulated fields cached in
cached_vmcs12, so pKVM need to sync&emulate this part of vmcs12 guest
fields from cached_vmcs12 to vmcs02 before it active.

Another thing is that after nested guest vmexit(vmcs02 is current) and
before host vcpu vmentry(vmcs01 is current), pKVM need to prepare vmcs01's
guest state fields restoring from vmcs12's host state - it's vmcs12 host
state host vcpu want return back.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c | 149 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c | 170 ++++++++++++++++-------------
 3 files changed, 247 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index fd8755621cc8..73fa66ba95bd 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -450,6 +450,15 @@ static void copy_shadow_fields_vmcs12_to_vmcs02(struct vcpu_vmx *vmx, struct vmc
 	}
 }
 
+/* current vmcs is vmcs01*/
+static void save_vmcs01_fields_for_emulation(struct vcpu_vmx *vmx)
+{
+	vmx->vcpu.arch.efer = vmcs_read64(GUEST_IA32_EFER);
+	vmx->vcpu.arch.pat = vmcs_read64(GUEST_IA32_PAT);
+	vmx->vcpu.arch.dr7 = vmcs_readl(GUEST_DR7);
+	vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+}
+
 /* current vmcs is vmcs02*/
 static u64 emulate_field_for_vmcs02(struct vcpu_vmx *vmx, u16 field, u64 virt_val)
 {
@@ -505,6 +514,66 @@ static void sync_vmcs12_dirty_fields_to_vmcs02(struct vcpu_vmx *vmx, struct vmcs
 	}
 }
 
+/* current vmcs is vmcs02*/
+static void update_vmcs02_fields_for_emulation(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+{
+	/* L1 host wishes to use its own MSRs for L2 guest?
+	 * vmcs02 shall use such guest states in vmcs01 as its guest states
+	 */
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER) != VM_ENTRY_LOAD_IA32_EFER)
+		vmcs_write64(GUEST_IA32_EFER, vmx->vcpu.arch.efer);
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) != VM_ENTRY_LOAD_IA32_PAT)
+		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) != VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		vmcs_writel(GUEST_DR7, vmx->vcpu.arch.dr7);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
+	}
+}
+
+/* current vmcs is vmcs01, set vmcs01 guest state with vmcs02 host state */
+static void prepare_vmcs01_guest_state(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+{
+	vmcs_writel(GUEST_CR0, vmcs12->host_cr0);
+	vmcs_writel(GUEST_CR3, vmcs12->host_cr3);
+	vmcs_writel(GUEST_CR4, vmcs12->host_cr4);
+
+	vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->host_ia32_sysenter_esp);
+	vmcs_writel(GUEST_SYSENTER_EIP, vmcs12->host_ia32_sysenter_eip);
+	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
+
+	/* Both cases want vmcs01 to take EFER/PAT from L2
+	 * 1. L1 host wishes to load its own MSRs on L2 guest VMExit
+	 *    such vmcs12's host states shall be set as vmcs01's guest states
+	 * 2. L1 host wishes to keep use MSRs from L2 guest after its VMExit
+	 *    such vmcs02's guest state shall be set as vmcs01's guest states
+	 *    the vmcs02's guest state were recorded in vmcs12 host
+	 *
+	 * For case 1, IA32_PERF_GLOBAL_CTRL is separately checked.
+	 */
+	vmcs_write64(GUEST_IA32_EFER, vmcs12->host_ia32_efer);
+	vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, vmcs12->host_ia32_perf_global_ctrl);
+
+	vmcs_write16(GUEST_CS_SELECTOR, vmcs12->host_cs_selector);
+	vmcs_write16(GUEST_DS_SELECTOR, vmcs12->host_ds_selector);
+	vmcs_write16(GUEST_ES_SELECTOR, vmcs12->host_es_selector);
+	vmcs_write16(GUEST_FS_SELECTOR, vmcs12->host_fs_selector);
+	vmcs_write16(GUEST_GS_SELECTOR, vmcs12->host_gs_selector);
+	vmcs_write16(GUEST_SS_SELECTOR, vmcs12->host_ss_selector);
+	vmcs_write16(GUEST_TR_SELECTOR, vmcs12->host_tr_selector);
+
+	vmcs_writel(GUEST_FS_BASE, vmcs12->host_fs_base);
+	vmcs_writel(GUEST_GS_BASE, vmcs12->host_gs_base);
+	vmcs_writel(GUEST_TR_BASE, vmcs12->host_tr_base);
+	vmcs_writel(GUEST_GDTR_BASE, vmcs12->host_gdtr_base);
+	vmcs_writel(GUEST_IDTR_BASE, vmcs12->host_idtr_base);
+
+	vmcs_writel(GUEST_RIP, vmcs12->host_rip);
+	vmcs_writel(GUEST_RSP, vmcs12->host_rsp);
+	vmcs_writel(GUEST_RFLAGS, 0x2);
+}
+
 static void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -538,6 +607,38 @@ static void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 	put_shadow_vcpu(cur_shadow_vcpu->shadow_vcpu_handle);
 }
 
+static void nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *cur_shadow_vcpu = pkvm_hvcpu->current_shadow_vcpu;
+	struct vmcs *vmcs02 = (struct vmcs *)cur_shadow_vcpu->vmcs02;
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
+
+	if (vmx->nested.current_vmptr == INVALID_GPA) {
+		nested_vmx_result(VMfailInvalid, 0);
+	} else if (vmcs12->launch_state == launch) {
+		/* VMLAUNCH_NONCLEAR_VMCS or VMRESUME_NONLAUNCHED_VMCS */
+		nested_vmx_result(VMfailValid,
+			launch ? VMXERR_VMLAUNCH_NONCLEAR_VMCS : VMXERR_VMRESUME_NONLAUNCHED_VMCS);
+	} else {
+		/* save vmcs01 guest state for possible emulation */
+		save_vmcs01_fields_for_emulation(vmx);
+
+		/* switch to vmcs02 */
+		vmcs_clear_track(vmx, vmcs02);
+		clear_shadow_indicator(vmcs02);
+		vmcs_load_track(vmx, vmcs02);
+
+		sync_vmcs12_dirty_fields_to_vmcs02(vmx, vmcs12);
+
+		update_vmcs02_fields_for_emulation(vmx, vmcs12);
+
+		/* mark guest mode */
+		vcpu->arch.hflags |= HF_GUEST_MASK;
+	}
+}
+
 int handle_vmxon(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -809,6 +910,54 @@ int handle_vmread(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int handle_vmresume(struct kvm_vcpu *vcpu)
+{
+	if (check_vmx_permission(vcpu))
+		nested_vmx_run(vcpu, false);
+
+	return 0;
+}
+
+int handle_vmlaunch(struct kvm_vcpu *vcpu)
+{
+	if (check_vmx_permission(vcpu))
+		nested_vmx_run(vcpu, true);
+
+	return 0;
+}
+
+int nested_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *cur_shadow_vcpu = pkvm_hvcpu->current_shadow_vcpu;
+	struct vmcs *vmcs02 = (struct vmcs *)cur_shadow_vcpu->vmcs02;
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
+
+	/* clear guest mode if need switch back to host */
+	vcpu->arch.hflags &= ~HF_GUEST_MASK;
+
+	/* L1 host wishes to keep use MSRs from L2 guest after its VMExit?
+	 * save vmcs02 guest state for later vmcs01 guest state preparation
+	 */
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER) != VM_EXIT_LOAD_IA32_EFER)
+		vmcs12->host_ia32_efer = vmcs_read64(GUEST_IA32_EFER);
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) != VM_EXIT_LOAD_IA32_PAT)
+		vmcs12->host_ia32_pat = vmcs_read64(GUEST_IA32_PAT);
+
+	if (!vmcs12->launch_state)
+		vmcs12->launch_state = 1;
+
+	/* switch to vmcs01 */
+	vmcs_clear_track(vmx, vmcs02);
+	set_shadow_indicator(vmcs02);
+	vmcs_load_track(vmx, vmx->loaded_vmcs->vmcs);
+
+	prepare_vmcs01_guest_state(vmx, vmcs12);
+
+	return 0;
+}
+
 void pkvm_init_nest(void)
 {
 	init_vmcs_shadow_fields();
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index 5fc76bdb135a..3f785be165c2 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -11,6 +11,9 @@ int handle_vmptrld(struct kvm_vcpu *vcpu);
 int handle_vmclear(struct kvm_vcpu *vcpu);
 int handle_vmwrite(struct kvm_vcpu *vcpu);
 int handle_vmread(struct kvm_vcpu *vcpu);
+int handle_vmresume(struct kvm_vcpu *vcpu);
+int handle_vmlaunch(struct kvm_vcpu *vcpu);
+int nested_vmexit(struct kvm_vcpu *vcpu);
 void pkvm_init_nest(void);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index d4f2a408e6e9..27b6518032b5 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -159,7 +159,7 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 	int launch = 1;
 
 	do {
-		bool skip_instruction = false;
+		bool skip_instruction = false, guest_exit = false;
 
 		if (__pkvm_vmx_vcpu_run(vcpu->arch.regs, launch)) {
 			pkvm_err("%s: CPU%d run_vcpu failed with error 0x%x\n",
@@ -174,87 +174,107 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
-		switch (vmx->exit_reason.full) {
-		case EXIT_REASON_CPUID:
-			handle_cpuid(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_CR_ACCESS:
-			pkvm_dbg("CPU%d vmexit_reason: CR_ACCESS.\n", vcpu->cpu);
-			handle_cr(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_MSR_READ:
-			pkvm_dbg("CPU%d vmexit_reason: MSR_READ 0x%lx\n",
-					vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
-			handle_read_msr(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_MSR_WRITE:
-			pkvm_dbg("CPU%d vmexit_reason: MSR_WRITE 0x%lx\n",
-					vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
-			handle_write_msr(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMON:
-			pkvm_dbg("CPU%d vmexit reason: VMXON.\n", vcpu->cpu);
-			handle_vmxon(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMOFF:
-			pkvm_dbg("CPU%d vmexit reason: VMXOFF.\n", vcpu->cpu);
-			handle_vmxoff(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMPTRLD:
-			pkvm_dbg("CPU%d vmexit reason: VMPTRLD.\n", vcpu->cpu);
-			handle_vmptrld(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMCLEAR:
-			pkvm_dbg("CPU%d vmexit reason: VMCLEAR.\n", vcpu->cpu);
-			handle_vmclear(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMREAD:
-			pkvm_dbg("CPU%d vmexit reason: WMREAD.\n", vcpu->cpu);
-			handle_vmread(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMWRITE:
-			pkvm_dbg("CPU%d vmexit reason: VMWRITE.\n", vcpu->cpu);
-			handle_vmwrite(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_XSETBV:
-			handle_xsetbv(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_VMCALL:
-			vcpu->arch.regs[VCPU_REGS_RAX] = handle_vmcall(vcpu);
-			skip_instruction = true;
-			break;
-		case EXIT_REASON_EPT_VIOLATION:
-			if (handle_host_ept_violation(vmcs_read64(GUEST_PHYSICAL_ADDRESS)))
+		if (is_guest_mode(vcpu)) {
+			guest_exit = true;
+			nested_vmexit(vcpu);
+		} else {
+			switch (vmx->exit_reason.full) {
+			case EXIT_REASON_CPUID:
+				handle_cpuid(vcpu);
 				skip_instruction = true;
-			break;
-		case EXIT_REASON_INTERRUPT_WINDOW:
-			handle_irq_window(vcpu);
-			break;
-		default:
-			pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
-			skip_instruction = true;
-			break;
+				break;
+			case EXIT_REASON_CR_ACCESS:
+				pkvm_dbg("CPU%d vmexit_reason: CR_ACCESS.\n", vcpu->cpu);
+				handle_cr(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_MSR_READ:
+				pkvm_dbg("CPU%d vmexit_reason: MSR_READ 0x%lx\n",
+						vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
+				handle_read_msr(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_MSR_WRITE:
+				pkvm_dbg("CPU%d vmexit_reason: MSR_WRITE 0x%lx\n",
+						vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
+				handle_write_msr(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMLAUNCH:
+				handle_vmlaunch(vcpu);
+				break;
+			case EXIT_REASON_VMRESUME:
+				handle_vmresume(vcpu);
+				break;
+			case EXIT_REASON_VMON:
+				pkvm_dbg("CPU%d vmexit reason: VMXON.\n", vcpu->cpu);
+				handle_vmxon(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMOFF:
+				pkvm_dbg("CPU%d vmexit reason: VMXOFF.\n", vcpu->cpu);
+				handle_vmxoff(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMPTRLD:
+				pkvm_dbg("CPU%d vmexit reason: VMPTRLD.\n", vcpu->cpu);
+				handle_vmptrld(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMCLEAR:
+				pkvm_dbg("CPU%d vmexit reason: VMCLEAR.\n", vcpu->cpu);
+				handle_vmclear(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMREAD:
+				pkvm_dbg("CPU%d vmexit reason: WMREAD.\n", vcpu->cpu);
+				handle_vmread(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMWRITE:
+				pkvm_dbg("CPU%d vmexit reason: VMWRITE.\n", vcpu->cpu);
+				handle_vmwrite(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_XSETBV:
+				handle_xsetbv(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_VMCALL:
+				vcpu->arch.regs[VCPU_REGS_RAX] = handle_vmcall(vcpu);
+				skip_instruction = true;
+				break;
+			case EXIT_REASON_EPT_VIOLATION:
+				if (handle_host_ept_violation(vmcs_read64(GUEST_PHYSICAL_ADDRESS)))
+					skip_instruction = true;
+				break;
+			case EXIT_REASON_INTERRUPT_WINDOW:
+				handle_irq_window(vcpu);
+				break;
+			default:
+				pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
+				skip_instruction = true;
+				break;
+			}
 		}
 
-		/* now only need vmresume */
-		launch = 0;
+		if (is_guest_mode(vcpu)) {
+			/*
+			 * L2 VMExit -> L2 VMEntry: vmresume
+			 * L1 VMExit -> L2 VMEntry: vmlaunch
+			 * as vmcs02 is clear every time
+			 */
+			launch = guest_exit ? 0 : 1;
+		} else {
+			handle_pending_events(vcpu);
+
+			/* pkvm_host only need vmresume */
+			launch = 0;
+		}
 
 		if (skip_instruction)
 			skip_emulated_instruction();
 
-		handle_pending_events(vcpu);
-
 		native_write_cr2(vcpu->arch.cr2);
 	} while (1);
 
-- 
2.25.1

