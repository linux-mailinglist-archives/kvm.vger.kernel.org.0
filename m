Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188416A3D03
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjB0I3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjB0I2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:28:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA98F1F93A;
        Mon, 27 Feb 2023 00:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486339; x=1709022339;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QOcZNbHq9/PzgJKWY9Z1cpCDbGr/g1QSckSvA57Km0g=;
  b=Ua3jMvXjiqvix1IB2fJr3DHwXrYIJaZxSVw1+02gjMoQfe8cgYTI4nqg
   ng1Zdc6MfuYj6ctX83rbh/fBEzHeuMfZAPutQD1xEwbqCowV2VdZrdC8j
   BEWB2a1JVzh0moD7QdNMciA1zJcjIA4/HE3wAfLpq4Fu0yV3WxzuQC4LH
   ttJiIT27vk3ukOlY5k8lsCwuzo8DWktBPAImwySpxUg8Uqj1eZKGaJkKQ
   MSuVnqYjQAMx0fEQ+vfLt+m5v2nsK2v8uLwYv4qOms0JgdIzC8jif64OS
   GiGYee8GpMAjITzRpGSLBBEO1TM4yZa0LuUJUhV8w+KMfgN6g6TSdK2V2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608988"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608988"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242343"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242343"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:15 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v12 074/106] KVM: VMX: Move NMI/exception handler to common helper
Date:   Mon, 27 Feb 2023 00:23:13 -0800
Message-Id: <dc51a734782069cc3b4bae5652d7ae29e0afca02.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX mostly handles NMI/exception exit mostly the same to VMX case.  The
difference is how to retrieve exit qualification.  To share the code with
TDX, move NMI/exception to a common header, common.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 70 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 79 ++++-----------------------------------
 2 files changed, 78 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 39ddead9d2bd..9e138318696c 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,8 +4,78 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/traps.h>
+
 #include "posted_intr.h"
 #include "mmu.h"
+#include "vmcs.h"
+#include "x86.h"
+
+extern unsigned long vmx_host_idt_base;
+void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
+
+static inline void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
+						   unsigned long entry)
+{
+	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
+
+	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
+	vmx_do_interrupt_nmi_irqoff(entry);
+	kvm_after_interrupt(vcpu);
+}
+
+static inline void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
+	 * MSR value is not clobbered by the host activity before the guest
+	 * has chance to consume it.
+	 *
+	 * Do not blindly read xfd_err here, since this exception might
+	 * be caused by L1 interception on a platform which doesn't
+	 * support xfd at all.
+	 *
+	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
+	 * only when xfd contains a non-zero value.
+	 *
+	 * Queuing exception is done in vmx_handle_exit. See comment there.
+	 */
+	if (vcpu->arch.guest_fpu.fpstate->xfd)
+		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
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
+	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
+		return;
+
+	vmx_handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	vcpu->arch.at_instruction_boundary = true;
+}
 
 u8 __vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio, bool check_cr0_cd);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5081679eba4a..17d047a73550 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -526,7 +526,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
-static unsigned long host_idt_base;
+unsigned long vmx_host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
@@ -4260,7 +4260,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
+	vmcs_writel(HOST_IDTR_BASE, vmx_host_idt_base);   /* 22.2.4 */
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
@@ -5151,10 +5151,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
@@ -6829,70 +6829,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
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
-{
-	/*
-	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
-	 * MSR value is not clobbered by the host activity before the guest
-	 * has chance to consume it.
-	 *
-	 * Do not blindly read xfd_err here, since this exception might
-	 * be caused by L1 interception on a platform which doesn't
-	 * support xfd at all.
-	 *
-	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
-	 * only when xfd contains a non-zero value.
-	 *
-	 * Queuing exception is done in vmx_handle_exit. See comment there.
-	 */
-	if (vcpu->arch.guest_fpu.fpstate->xfd)
-		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
-}
-
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
-	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
-		return;
-
-	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
-	vcpu->arch.at_instruction_boundary = true;
-}
-
 void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6901,9 +6837,10 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -8184,7 +8121,7 @@ __init int vmx_hardware_setup(void)
 	int r;
 
 	store_idt(&dt);
-	host_idt_base = dt.address;
+	vmx_host_idt_base = dt.address;
 
 	vmx_setup_user_return_msrs();
 
-- 
2.25.1

