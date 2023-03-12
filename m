Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547D96B647E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCLJ6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCLJ5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196B50993
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615041; x=1710151041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FukDJ6eH0QDmWfDu745KBCfuLtjedx9xqg0NBvVJxPU=;
  b=KrUIrgkzeGkIK+PnS94PQ6AVScvQYWlQai3oqK+GuFeV3wH3Pf/41sfK
   2e3IxOPhe+RXhQ0AeREDlCRgBL+g1YuT1rqAltb5SA9mFBaVr8lqKUzV3
   kIXtFD2CEpS+GunRBT5X5UJgoOWfzQ1GDyJoOFyguijf2SIj0PpwWQTQM
   ft2Ao9m4jYSeeeYjbcLKdUXQkfkxjsFHMY2PTjbUd0kaBMBThPRZuKU3h
   XQOAIrI6NIN+taOYlW7Kpff6JAqgtLu9TbeRCuVBDCvqvpxGto29brKkJ
   yK/j/v317mqYYdPWImDSwb7+S4MMDqoYBtp8u/AMmfsKz4uq/zMNzlmcG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998077"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998077"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677548"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677548"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:53 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-4 4/4] pkvm: x86: Handle pending nmi in pKVM runtime
Date:   Mon, 13 Mar 2023 02:02:44 +0800
Message-Id: <20230312180244.1778422-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180244.1778422-1-jason.cj.chen@intel.com>
References: <20230312180244.1778422-1-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

There is still chance that nmi will happen under root mode during
pKVM runtime, ignore it will cause nmi lost in the host VM.
Need ensure such nmi could be injected into host VM.

Add a simple handling for this kind of pending nmi by taking use
of irq window.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/idt.S      | 67 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/irq.c      | 60 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   | 26 +++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h      |  5 +++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  6 +++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 35 +++++++++++----
 7 files changed, 192 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index a7546e1d0b80..fe852bd43a7e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o ept.o
+		   init_finalise.o ept.o idt.o irq.o
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/idt.S b/arch/x86/kvm/vmx/pkvm/hyp/idt.S
new file mode 100644
index 000000000000..f2dc60f37eba
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/idt.S
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/unwind_hints.h>
+
+.macro save_frame
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+	push %r11
+	push %r10
+	push %r9
+	push %r8
+	push %_ASM_DI
+	push %_ASM_SI
+	push %_ASM_BP
+	push %_ASM_SP
+	push %_ASM_DX
+	push %_ASM_CX
+	push %_ASM_BX
+	push %_ASM_AX
+.endm
+
+.macro restore_frame
+	pop %_ASM_AX
+	pop %_ASM_BX
+	pop %_ASM_CX
+	pop %_ASM_DX
+	pop %_ASM_SP
+	pop %_ASM_BP
+	pop %_ASM_SI
+	pop %_ASM_DI
+	pop %r8
+	pop %r9
+	pop %r10
+	pop %r11
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+.endm
+
+SYM_CODE_START(noop_handler)
+	UNWIND_HINT_EMPTY
+	save_frame
+
+	call handle_noop
+
+	restore_frame
+
+	iretq
+SYM_CODE_END(noop_handler)
+
+SYM_CODE_START(nmi_handler)
+	UNWIND_HINT_EMPTY
+	save_frame
+
+	call handle_nmi
+
+	restore_frame
+
+	iretq
+SYM_CODE_END(nmi_handler)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/irq.c b/arch/x86/kvm/vmx/pkvm/hyp/irq.c
new file mode 100644
index 000000000000..342160e118f3
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/irq.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+#include "cpu.h"
+#include "pkvm_hyp.h"
+#include "vmx.h"
+#include "debug.h"
+
+void handle_noop(void)
+{
+	pkvm_err("%s: unexpected exception\n", __func__);
+}
+
+void handle_nmi(void)
+{
+	int cpu_id = get_pcpu_id();
+	struct pkvm_host_vcpu *pkvm_host_vcpu =
+		pkvm_hyp->host_vm.host_vcpus[cpu_id];
+	struct vcpu_vmx *vmx = &pkvm_host_vcpu->vmx;
+
+	if (!pkvm_host_vcpu || !vmx)
+		return;
+
+	if (pkvm_host_vcpu->pending_nmi) {
+		pkvm_dbg("%s: CPU%d already has a pending NMI\n",
+			__func__, cpu_id);
+		return;
+	}
+
+	/* load host vcpu vmcs for sure */
+	vmcs_load(vmx->loaded_vmcs->vmcs);
+
+	/*
+	 * This NMI could happen either before executing
+	 * the injection code or after.
+	 * For the before case, should record a pending NMI.
+	 * For the after case, if no NMI is injected in guest
+	 * we also need to record a pending NMI. If NMI is
+	 * injected already, it is not necessary to inject
+	 * again but injecting it in the next round should also
+	 * be fine. So simply record a pending NMI here.
+	 */
+	pkvm_host_vcpu->pending_nmi = true;
+
+	pkvm_dbg("%s: CPU%d pending NMI\n", __func__, cpu_id);
+
+	/* For case that when NMI happens the injection code is
+	 * already executed, open the irq window. For the case
+	 * happens before, opening irq window doesn't cause trouble.
+	 */
+	vmx_enable_irq_window(vmx);
+
+	/* switch if the current one is not host vcpu vmcs */
+	if (pkvm_host_vcpu->current_vmcs &&
+			(pkvm_host_vcpu->current_vmcs != vmx->loaded_vmcs->vmcs))
+		vmcs_load(pkvm_host_vcpu->current_vmcs);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 88cbd276caf8..e8015a6830b0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -117,6 +117,27 @@ static void handle_xsetbv(struct kvm_vcpu *vcpu)
 			: : "a" (eax), "d" (edx), "c" (ecx));
 }
 
+static void handle_irq_window(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 cpu_based_exec_ctrl = exec_controls_get(vmx);
+
+	exec_controls_set(vmx, cpu_based_exec_ctrl & ~CPU_BASED_INTR_WINDOW_EXITING);
+	pkvm_dbg("%s: CPU%d clear irq_window_exiting\n", __func__, vcpu->cpu);
+}
+
+static void handle_pending_events(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_host_vcpu *pkvm_host_vcpu = to_pkvm_hvcpu(vcpu);
+
+	if (pkvm_host_vcpu->pending_nmi) {
+		/* Inject if NMI is not blocked */
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			     INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
+		pkvm_host_vcpu->pending_nmi = false;
+	}
+}
+
 /* we take use of kvm_vcpu structure, but not used all the fields */
 int pkvm_main(struct kvm_vcpu *vcpu)
 {
@@ -171,6 +192,9 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			if (handle_host_ept_violation(vmcs_read64(GUEST_PHYSICAL_ADDRESS)))
 				skip_instruction = true;
 			break;
+		case EXIT_REASON_INTERRUPT_WINDOW:
+			handle_irq_window(vcpu);
+			break;
 		default:
 			pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
 			skip_instruction = true;
@@ -183,6 +207,8 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 		if (skip_instruction)
 			skip_emulated_instruction();
 
+		handle_pending_events(vcpu);
+
 		native_write_cr2(vcpu->arch.cr2);
 	} while (1);
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index c0a42cc56764..178139d1b61f 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -45,4 +45,9 @@ static inline u64 pkvm_construct_eptp(unsigned long root_hpa, int level)
 	return eptp;
 }
 
+static inline void vmx_enable_irq_window(struct vcpu_vmx *vmx)
+{
+	exec_controls_setbit(vmx, CPU_BASED_INTR_WINDOW_EXITING);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index d0a7283b0e19..292d48d8ee44 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -33,6 +33,9 @@ struct pkvm_host_vcpu {
 	struct vcpu_vmx vmx;
 	struct pkvm_pcpu *pcpu;
 	struct vmcs *vmxarea;
+	struct vmcs *current_vmcs;
+
+	bool pending_nmi;
 };
 
 struct pkvm_host_vm {
@@ -100,4 +103,7 @@ PKVM_DECLARE(void *, pkvm_early_alloc_contig(unsigned int nr_pages));
 PKVM_DECLARE(void *, pkvm_early_alloc_page(void));
 PKVM_DECLARE(void, pkvm_early_alloc_init(void *virt, unsigned long size));
 
+PKVM_DECLARE(void, noop_handler(void));
+PKVM_DECLARE(void, nmi_handler(void));
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 77cd7b654168..8ea2d64236d0 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -276,8 +276,7 @@ static __init void _init_host_state_area(struct pkvm_pcpu *pcpu, int cpu)
 
 	native_store_gdt(&dt);
 	vmcs_writel(HOST_GDTR_BASE, dt.address);
-	store_idt(&dt);
-	vmcs_writel(HOST_IDTR_BASE, dt.address);
+	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
 
 	rdmsr(MSR_IA32_SYSENTER_CS, low, high);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, low);
@@ -403,6 +402,7 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
 	vmcs_load(vmx->loaded_vmcs->vmcs);
+	vcpu->current_vmcs = vmx->loaded_vmcs->vmcs;
 
 	init_guest_state_area(vcpu, cpu);
 	init_host_state_area(vcpu, cpu);
@@ -514,11 +514,6 @@ static __init void init_gdt(struct pkvm_pcpu *pcpu)
 	pcpu->gdt_page = pkvm_gdt_page;
 }
 
-void noop_handler(void)
-{
-	/* To be added */
-}
-
 static __init void init_idt(struct pkvm_pcpu *pcpu)
 {
 	gate_desc *idt = pcpu->idt_page.idt;
@@ -533,13 +528,37 @@ static __init void init_idt(struct pkvm_pcpu *pcpu)
 	gate_desc desc;
 	int i;
 
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	gate_desc *host_idt;
+	struct desc_ptr dt;
+
+	store_idt(&dt);
+	host_idt = (gate_desc *)dt.address;
+
+	/* reuse other exception handler but control nmi handler */
+	for (i = 0; i <= X86_TRAP_IRET; i++) {
+		if (i == X86_TRAP_NMI) {
+			d.vector = i;
+			d.bits.ist = 0;
+			d.addr = (const void *)pkvm_sym(nmi_handler);
+			idt_init_desc(&desc, &d);
+			write_idt_entry(idt, i, &desc);
+		} else {
+			memcpy(&idt[i], &host_idt[i], sizeof(gate_desc));
+		}
+	}
+#else
 	for (i = 0; i <= X86_TRAP_IRET; i++) {
 		d.vector = i;
 		d.bits.ist = 0;
-		d.addr = (const void *)noop_handler;
+		if (i == X86_TRAP_NMI)
+			d.addr = (const void *)pkvm_sym(nmi_handler);
+		else
+			d.addr = (const void *)pkvm_sym(noop_handler);
 		idt_init_desc(&desc, &d);
 		write_idt_entry(idt, i, &desc);
 	}
+#endif
 }
 
 static __init void init_tss(struct pkvm_pcpu *pcpu)
-- 
2.25.1

