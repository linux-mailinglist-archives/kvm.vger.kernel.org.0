Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F76B648D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCLJ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCLJ7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68DA468E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615080; x=1710151080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9QCLLgNdQ1RFN3SfcSpS+D2OIFMPyXlOZQQ5JpcsFdE=;
  b=n95fimLKO6e4lC3agQyioIMdKmhZb5nXPa1rPK04t256DmHxpXg55GMP
   IJaglVga1Ptdh90Ym/ivHTLHXO+uWTsRi6d8vyLABLYNduCKrYIYePLlO
   Y/UabhZmBAm1tmNKt82NEm9xvP8F0WgDqxlrZPEKwmHh2Ovza2GcTMrLn
   aQeWX8ilJ7iRCqLVPQKSYd2S6Qft+T9ZNb4aAdyXMHFnJwdZRenChPrwc
   pZmfQg/KmYAIK2oAL57dqwPWpVPqyXPcEpAPbvuj8IJI96m3olcdoKCd7
   ZXQVssbOmrT18CQ4IbDPR1huJSRtCBRmYzE0s1wDmCQnGCKnnDkRHgIgl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998121"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998121"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677743"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677743"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:25 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 15/22] pkvm: x86: Move _init_host_state_area to pKVM hypervisor
Date:   Mon, 13 Mar 2023 02:02:56 +0800
Message-Id: <20230312180303.1778492-16-jason.cj.chen@intel.com>
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

During the VMPTRLD emulation for nested guest, pKVM need to initialize
shadow vmcs's host state area based on hypervisor's setting as well, so
move this function from pkvm_host.c to hypervisor dir.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/vmx.c      | 77 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h      |  2 +
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  1 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 75 +--------------------------
 5 files changed, 82 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 660fd611395f..ca6d43509ddc 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o ept.o idt.o irq.o nested.o
+		   init_finalise.o ept.o idt.o irq.o nested.o vmx.o
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.c b/arch/x86/kvm/vmx/pkvm/hyp/vmx.c
new file mode 100644
index 000000000000..fec99c567d07
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.c
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <pkvm.h>
+#include "cpu.h"
+
+void pkvm_init_host_state_area(struct pkvm_pcpu *pcpu, int cpu)
+{
+	unsigned long a;
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	u32 high, low;
+	struct desc_ptr dt;
+	u16 selector;
+#endif
+
+	vmcs_writel(HOST_CR0, native_read_cr0() & ~X86_CR0_TS);
+	vmcs_writel(HOST_CR3, pcpu->cr3);
+	vmcs_writel(HOST_CR4, native_read_cr4());
+
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	savesegment(cs, selector);
+	vmcs_write16(HOST_CS_SELECTOR, selector);
+	savesegment(ss, selector);
+	vmcs_write16(HOST_SS_SELECTOR, selector);
+	savesegment(ds, selector);
+	vmcs_write16(HOST_DS_SELECTOR, selector);
+	savesegment(es, selector);
+	vmcs_write16(HOST_ES_SELECTOR, selector);
+	savesegment(fs, selector);
+	vmcs_write16(HOST_FS_SELECTOR, selector);
+	pkvm_rdmsrl(MSR_FS_BASE, a);
+	vmcs_writel(HOST_FS_BASE, a);
+	savesegment(gs, selector);
+	vmcs_write16(HOST_GS_SELECTOR, selector);
+	pkvm_rdmsrl(MSR_GS_BASE, a);
+	vmcs_writel(HOST_GS_BASE, a);
+
+	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
+	vmcs_writel(HOST_TR_BASE, (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
+
+	native_store_gdt(&dt);
+	vmcs_writel(HOST_GDTR_BASE, dt.address);
+	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
+
+	pkvm_rdmsr(MSR_IA32_SYSENTER_CS, low, high);
+	vmcs_write32(HOST_IA32_SYSENTER_CS, low);
+
+	pkvm_rdmsrl(MSR_IA32_SYSENTER_ESP, a);
+	vmcs_writel(HOST_IA32_SYSENTER_ESP, a);
+
+	pkvm_rdmsrl(MSR_IA32_SYSENTER_EIP, a);
+	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);
+#else
+	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);
+	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);
+	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);
+	vmcs_write16(HOST_ES_SELECTOR, 0);
+	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
+	vmcs_write16(HOST_FS_SELECTOR, 0);
+	vmcs_write16(HOST_GS_SELECTOR, 0);
+	vmcs_writel(HOST_FS_BASE, 0);
+	vmcs_writel(HOST_GS_BASE, 0);
+
+	vmcs_writel(HOST_TR_BASE, (unsigned long)&pcpu->tss);
+	vmcs_writel(HOST_GDTR_BASE, (unsigned long)(&pcpu->gdt_page));
+	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
+
+	vmcs_write16(HOST_GS_SELECTOR, __KERNEL_DS);
+	vmcs_writel(HOST_GS_BASE, cpu);
+#endif
+
+	/* MSR area */
+	pkvm_rdmsrl(MSR_EFER, a);
+	vmcs_write64(HOST_IA32_EFER, a);
+
+	pkvm_rdmsrl(MSR_IA32_CR_PAT, a);
+	vmcs_write64(HOST_IA32_PAT, a);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 178139d1b61f..35369cc3b646 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -50,4 +50,6 @@ static inline void vmx_enable_irq_window(struct vcpu_vmx *vmx)
 	exec_controls_setbit(vmx, CPU_BASED_INTR_WINDOW_EXITING);
 }
 
+void pkvm_init_host_state_area(struct pkvm_pcpu *pcpu, int cpu);
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 292d48d8ee44..d5393d477df1 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -98,6 +98,7 @@ extern struct pkvm_hyp *pkvm_sym(pkvm_hyp);
 
 PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
 PKVM_DECLARE(int, pkvm_main(struct kvm_vcpu *vcpu));
+PKVM_DECLARE(void, pkvm_init_host_state_area(struct pkvm_pcpu *pcpu, int cpu));
 
 PKVM_DECLARE(void *, pkvm_early_alloc_contig(unsigned int nr_pages));
 PKVM_DECLARE(void *, pkvm_early_alloc_page(void));
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 4ea82a147af5..cbba3033ba63 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -240,84 +240,11 @@ static __init void init_guest_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 }
 
-static __init void _init_host_state_area(struct pkvm_pcpu *pcpu, int cpu)
-{
-	unsigned long a;
-#ifdef CONFIG_PKVM_INTEL_DEBUG
-	u32 high, low;
-	struct desc_ptr dt;
-	u16 selector;
-#endif
-
-	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);
-	vmcs_writel(HOST_CR3, pcpu->cr3);
-	vmcs_writel(HOST_CR4, native_read_cr4());
-
-#ifdef CONFIG_PKVM_INTEL_DEBUG
-	savesegment(cs, selector);
-	vmcs_write16(HOST_CS_SELECTOR, selector);
-	savesegment(ss, selector);
-	vmcs_write16(HOST_SS_SELECTOR, selector);
-	savesegment(ds, selector);
-	vmcs_write16(HOST_DS_SELECTOR, selector);
-	savesegment(es, selector);
-	vmcs_write16(HOST_ES_SELECTOR, selector);
-	savesegment(fs, selector);
-	vmcs_write16(HOST_FS_SELECTOR, selector);
-	rdmsrl(MSR_FS_BASE, a);
-	vmcs_writel(HOST_FS_BASE, a);
-	savesegment(gs, selector);
-	vmcs_write16(HOST_GS_SELECTOR, selector);
-	rdmsrl(MSR_GS_BASE, a);
-	vmcs_writel(HOST_GS_BASE, a);
-
-	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
-	vmcs_writel(HOST_TR_BASE, (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
-
-	native_store_gdt(&dt);
-	vmcs_writel(HOST_GDTR_BASE, dt.address);
-	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
-
-	rdmsr(MSR_IA32_SYSENTER_CS, low, high);
-	vmcs_write32(HOST_IA32_SYSENTER_CS, low);
-
-	rdmsrl(MSR_IA32_SYSENTER_ESP, a);
-	vmcs_writel(HOST_IA32_SYSENTER_ESP, a);
-
-	rdmsrl(MSR_IA32_SYSENTER_EIP, a);
-	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);
-#else
-	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);
-	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);
-	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);
-	vmcs_write16(HOST_ES_SELECTOR, 0);
-	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
-	vmcs_write16(HOST_FS_SELECTOR, 0);
-	vmcs_write16(HOST_GS_SELECTOR, 0);
-	vmcs_writel(HOST_FS_BASE, 0);
-	vmcs_writel(HOST_GS_BASE, 0);
-
-	vmcs_writel(HOST_TR_BASE, (unsigned long)&pcpu->tss);
-	vmcs_writel(HOST_GDTR_BASE, (unsigned long)(&pcpu->gdt_page));
-	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
-
-	vmcs_write16(HOST_GS_SELECTOR, __KERNEL_DS);
-	vmcs_writel(HOST_GS_BASE, cpu);
-#endif
-
-	/* MSR area */
-	rdmsrl(MSR_EFER, a);
-	vmcs_write64(HOST_IA32_EFER, a);
-
-	rdmsrl(MSR_IA32_CR_PAT, a);
-	vmcs_write64(HOST_IA32_PAT, a);
-}
-
 static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 {
 	struct pkvm_pcpu *pcpu = vcpu->pcpu;
 
-	_init_host_state_area(pcpu, cpu);
+	pkvm_sym(pkvm_init_host_state_area)(pcpu, cpu);
 
 	/*host RIP*/
 	vmcs_writel(HOST_RIP, (unsigned long)pkvm_sym(__pkvm_vmx_vmexit));
-- 
2.25.1

