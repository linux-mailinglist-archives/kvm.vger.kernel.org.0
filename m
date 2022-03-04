Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBA4CDDA4
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiCDUAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F81FC2F7;
        Fri,  4 Mar 2022 11:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423440; x=1677959440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o5IWFHcsPLYxZ5JvaXH7Km8ss44oU5hwBPZ9jvUf4tM=;
  b=VkzUyt5ZNBJLB+N+dlXnOsMaElVW4Zv24fesw5RehUW1izxr8xGWO7LP
   ITmZxcuHjpoNdSLwPYDSGRkVVDtDXLIixYAxd9k+MPYZUAl0Mjq6CUXby
   xZkU0AlkArGrrNuueZgRj0jneAT9qbHEmIjtO6DVSkXc7dGVJtrMBBctV
   oocmcc3FZ6RIqk5XWWaxmKGjcs0fokahLsDY4ZVrfA823yHjGAzAAydMy
   5J2BBlAVJp7OoezfNRN3bNxX+aUFUicLgrccfHH+l3TudwUmJgdK5NL+J
   eBjlvYr+lOZIjJg5gFPip2xBZ7m2D2u4UUL+wQYpw9G1VoRTh28A2exux
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779632"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779632"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:39 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344509"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:38 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 080/104] KVM: TDX: Implement methods to inject NMI
Date:   Fri,  4 Mar 2022 11:49:36 -0800
Message-Id: <c88c21250feaf720cc718ecfcd483d93b65819d3.1646422845.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX vcpu control structure defines one bit for pending NMI for VMM to
inject NMI by setting the bit without knowing TDX vcpu NMI states.  Because
the vcpu state is protected, VMM can't know about NMI states of TDX vcpu.
The TDX module handles actual injection and NMI states transition.

Add methods for NMI and treat NMI can be injected always.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 62 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     |  5 +++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 404a260796e4..aa84c13f8ee1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -216,6 +216,58 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vmx_flush_tlb_guest(vcpu);
 }
 
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_inject_nmi(vcpu);
+
+	vmx_inject_nmi(vcpu);
+}
+
+static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/*
+	 * The TDX module manages NMI windows and NMI reinjection, and hides NMI
+	 * blocking, all KVM can do is throw an NMI over the wall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_nmi_allowed(vcpu, for_injection);
+}
+
+static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Assume NMIs are always unmasked.  KVM could query PEND_NMI and treat
+	 * NMIs as masked if a previous NMI is still pending, but SEAMCALLs are
+	 * expensive and the end result is unchanged as the only relevant usage
+	 * of get_nmi_mask() is to limit the number of pending NMIs, i.e. it
+	 * only changes whether KVM or the TDX module drops an NMI.
+	 */
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_get_nmi_mask(vcpu);
+}
+
+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_nmi_mask(vcpu, masked);
+}
+
+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	/* Refer the comment in vt_get_nmi_mask(). */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_enable_nmi_window(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			int pgd_level)
 {
@@ -366,14 +418,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.set_irq = vt_inject_irq,
-	.set_nmi = vmx_inject_nmi,
+	.set_nmi = vt_inject_nmi,
 	.queue_exception = vmx_queue_exception,
 	.cancel_injection = vt_cancel_injection,
 	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
+	.nmi_allowed = vt_nmi_allowed,
+	.get_nmi_mask = vt_get_nmi_mask,
+	.set_nmi_mask = vt_set_nmi_mask,
+	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bdc658ca9e4f..273898de9f7a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -763,6 +763,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c3768a20347f..31be5e8a1d5c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -150,6 +150,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -180,6 +181,7 @@ static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
 static inline void tdx_deliver_interrupt(
 	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
+static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

