Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4772B4F7B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbgKPSaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:30:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:20651 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388273AbgKPS2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:14 -0500
IronPort-SDR: RHulxorf8wXbsCXABFfQS/uRbN0sjVJydxuPzcgVK/sOoJS66zYmkKqRPQGN5R4v/ChAQFvI6o
 TK4WvItcHNSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410064"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410064"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:13 -0800
IronPort-SDR: A+uGQgeEKhXMSryBBIqrS0JVVZyQLf7RQ513GN58RePX+xhVjfjzSRJf5XBGz8RL1PlUJxQeLB
 iZfi8OZPjLbg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528200"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:13 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 45/67] KVM: VMX: Move NMI/exception handler to common helper
Date:   Mon, 16 Nov 2020 10:26:30 -0800
Message-Id: <81a8753361caa8d1a32a8f125cb07af1e7cc75b8.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/common.h | 54 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 42 +++++-------------------------
 2 files changed, 60 insertions(+), 36 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
new file mode 100644
index 000000000000..146f1da9c88d
--- /dev/null
+++ b/arch/x86/kvm/vmx/common.h
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
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
+void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info);
+
+/*
+ * Trigger machine check on the host. We assume all the MSRs are already set up
+ * by the CPU and that we still run on the same CPU as the MCE occurred on.
+ * We pass a fake environment to the machine check handler because we want
+ * the guest to be always treated like user space, no matter what context
+ * it used internally.
+ */
+static inline void kvm_machine_check(void)
+{
+#if defined(CONFIG_X86_MCE)
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+
+	do_machine_check(&regs);
+#endif
+}
+
+static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+							u32 intr_info)
+{
+	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
+	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
+		return;
+
+	vmx_handle_interrupt_nmi_irqoff(vcpu, intr_info);
+}
+
+static inline void vmx_handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu,
+						  u32 intr_info)
+{
+	/* Handle machine checks before interrupts are enabled */
+	if (is_machine_check(intr_info))
+		kvm_machine_check();
+	/* We need to handle NMIs before interrupts are enabled */
+	else if (is_nmi(intr_info))
+		vmx_handle_interrupt_nmi_irqoff(vcpu, intr_info);
+}
+
+#endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d6c3a50230d..e8b60d447e27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -49,6 +49,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "evmcs.h"
 #include "irq.h"
@@ -4708,25 +4709,6 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-/*
- * Trigger machine check on the host. We assume all the MSRs are already set up
- * by the CPU and that we still run on the same CPU as the MCE occurred on.
- * We pass a fake environment to the machine check handler because we want
- * the guest to be always treated like user space, no matter what context
- * it used internally.
- */
-static void kvm_machine_check(void)
-{
-#if defined(CONFIG_X86_MCE)
-	struct pt_regs regs = {
-		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
-		.flags = X86_EFLAGS_IF,
-	};
-
-	do_machine_check(&regs);
-#endif
-}
-
 static int handle_machine_check(struct kvm_vcpu *vcpu)
 {
 	/* handled by vmx_vcpu_run() */
@@ -6348,7 +6330,7 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
+void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
@@ -6363,21 +6345,8 @@ static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
 		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
-	/* Handle machine checks before interrupts are enabled */
-	else if (is_machine_check(intr_info))
-		kvm_machine_check();
-	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(vcpu, intr_info);
-}
-
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
-{
-	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
-	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
-		return;
-
-	handle_interrupt_nmi_irqoff(vcpu, intr_info);
+	else
+		vmx_handle_exception_nmi_irqoff(vcpu, intr_info);
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
@@ -6385,7 +6354,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
-- 
2.17.1

