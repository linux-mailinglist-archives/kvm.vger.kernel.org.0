Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E345D1B5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353403AbhKYAY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:16253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353010AbhKYAYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432226"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432226"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:20 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042323"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:19 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 40/59] KVM: VMX: Move NMI/exception handler to common helper
Date:   Wed, 24 Nov 2021 16:20:23 -0800
Message-Id: <a3113cf940d30e2853e2f7aca1c6c85238f8ed21.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 52 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 52 ++++++---------------------------------
 2 files changed, 60 insertions(+), 44 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
new file mode 100644
index 000000000000..81c73f30d01d
--- /dev/null
+++ b/arch/x86/kvm/vmx/common.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_X86_VMX_COMMON_H
+#define __KVM_X86_VMX_COMMON_H
+
+#include <linux/kvm_host.h>
+
+#include <asm/traps.h>
+
+#include "vmcs.h"
+#include "x86.h"
+
+extern unsigned long vmx_host_idt_base;
+void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
+
+static inline void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
+				     unsigned long entry)
+{
+	kvm_before_interrupt(vcpu);
+	vmx_do_interrupt_nmi_irqoff(entry);
+	kvm_after_interrupt(vcpu);
+}
+
+static inline void vmx_handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu,
+						   u32 intr_info)
+{
+	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
+
+	/* if exit due to PF check for async PF */
+	if (is_page_fault(intr_info))
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	/* Handle machine checks before interrupts are enabled */
+	else if (is_machine_check(intr_info))
+		kvm_machine_check();
+	/* We need to handle NMIs before interrupts are enabled */
+	else if (is_nmi(intr_info))
+		vmx_handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
+}
+
+static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+							u32 intr_info)
+{
+	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
+	gate_desc *desc = (gate_desc *)vmx_host_idt_base + vector;
+
+	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
+	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
+		return;
+
+	vmx_handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+}
+
+#endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f243d5ecf543..4730fd15bea6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -49,6 +49,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "evmcs.h"
 #include "hyperv.h"
@@ -452,7 +453,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
-static unsigned long host_idt_base;
+unsigned long vmx_host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
@@ -3995,7 +3996,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
+	vmcs_writel(HOST_IDTR_BASE, vmx_host_idt_base);   /* 22.2.4 */
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
@@ -4726,7 +4727,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	intr_info = vmx_get_intr_info(vcpu);
 
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
-		return 1; /* handled by handle_exception_nmi_irqoff() */
+		return 1; /* handled by vmx_handle_exception_nmi_irqoff() */
 
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
@@ -6292,44 +6293,6 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
-					unsigned long entry)
-{
-	kvm_before_interrupt(vcpu);
-	vmx_do_interrupt_nmi_irqoff(entry);
-	kvm_after_interrupt(vcpu);
-}
-
-static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
-{
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
-
-	/* if exit due to PF check for async PF */
-	if (is_page_fault(intr_info))
-		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
-	/* Handle machine checks before interrupts are enabled */
-	else if (is_machine_check(intr_info))
-		kvm_machine_check();
-	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
-}
-
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
-					     u32 intr_info)
-{
-	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
-
-	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
-	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
-		return;
-
-	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
-}
-
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6338,9 +6301,10 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		vmx_handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
@@ -7678,7 +7642,7 @@ static __init int hardware_setup(void)
 	int r, ept_lpage_level;
 
 	store_idt(&dt);
-	host_idt_base = dt.address;
+	vmx_host_idt_base = dt.address;
 
 	vmx_setup_user_return_msrs();
 
-- 
2.25.1

