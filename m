Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A68E4CDD7C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiCDT7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCDT7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3300A269A78;
        Fri,  4 Mar 2022 11:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423442; x=1677959442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2WFaqH30cmVv01PbFsWNWa8QUKDD/5aYmsd0YpTImc4=;
  b=f1oc17T/19L5SH3lAdXMo4ToTDR2U4vNWmFIxJUBxnIcrbfBIQVATOkv
   chmhVKSPD45ARJdqdFuOEYvXDIXoWleyr90WPv9ihP5tRmLdxEl1zgG+0
   4zNPz417T/zs4iCKg/qV33pdSEa/xNFtPPdJDd6vkWxJYGEBb7ehaq0FE
   UDG+aq+pXBkocIDRK5rcaB8OhGlsZmi/mrfef/5PabWExCB1jgScdrT7z
   Q5cVgtykiZdJP1sCfSH5HgGg6dIJBYbNNYI7Zrn+1utDHbW84PNd516/7
   0rCrfoelqOttG8dVRmcFzF9emxh5y4fnJ8WnRPag6cpTES8GkJLRhLBMM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779637"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779637"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:39 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344515"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:39 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 082/104] KVM: VMX: Move NMI/exception handler to common helper
Date:   Fri,  4 Mar 2022 11:49:38 -0800
Message-Id: <81086dc5adc8f1f8134cabd831f16d9fbab2ca00.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX mostly handles NMI/exception exit mostly the same to VMX case.  The
difference is how to retrieve exit qualification.  To share the code with
TDX, move NMI/exception to a common header

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 50 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 60 ++++++---------------------------------
 2 files changed, 59 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 79a4517e43d1..1e24ede1c581 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,8 +4,58 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/traps.h>
+
 #include "posted_intr.h"
 #include "mmu.h"
+#include "vmcs.h"
+#include "x86.h"
+
+extern unsigned long vmx_host_idt_base;
+void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu);
+void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
+
+static inline void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
+						unsigned long entry)
+{
+	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
+
+	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
+	vmx_do_interrupt_nmi_irqoff(entry);
+	kvm_after_interrupt(vcpu);
+}
+
+static inline void vmx_handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu,
+						u32 intr_info)
+{
+	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
+
+	/* if exit due to PF check for async PF */
+	if (is_page_fault(intr_info))
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	/* if exit due to NM, handle before interrupts are enabled */
+	else if (is_nm_fault(intr_info))
+		vmx_handle_nm_fault_irqoff(vcpu);
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
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 008400927144..b235541e4b27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -457,7 +457,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
-static unsigned long host_idt_base;
+unsigned long vmx_host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
@@ -4046,7 +4046,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
+	vmcs_writel(HOST_IDTR_BASE, vmx_host_idt_base);   /* 22.2.4 */
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
@@ -4789,10 +4789,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	intr_info = vmx_get_intr_info(vcpu);
 
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
-		return 1; /* handled by handle_exception_nmi_irqoff() */
+		return 1; /* handled by vmx_handle_exception_nmi_irqoff() */
 
 	/*
-	 * Queue the exception here instead of in handle_nm_fault_irqoff().
+	 * Queue the exception here instead of in vmx_handle_nm_fault_irqoff().
 	 * This ensures the nested_vmx check is not skipped so vmexit can
 	 * be reflected to L1 (when it intercepts #NM) before reaching this
 	 * point.
@@ -6410,19 +6410,7 @@ void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
-					unsigned long entry)
-{
-	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
-
-	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
-	vmx_do_interrupt_nmi_irqoff(entry);
-	kvm_after_interrupt(vcpu);
-}
-
-static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
+void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
@@ -6442,37 +6430,6 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
-{
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
-
-	/* if exit due to PF check for async PF */
-	if (is_page_fault(intr_info))
-		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
-	/* if exit due to NM, handle before interrupts are enabled */
-	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(vcpu);
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
 void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6481,9 +6438,10 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -7679,7 +7637,7 @@ __init int vmx_hardware_setup(void)
 	int r;
 
 	store_idt(&dt);
-	host_idt_base = dt.address;
+	vmx_host_idt_base = dt.address;
 
 	vmx_setup_user_return_msrs();
 
-- 
2.25.1

