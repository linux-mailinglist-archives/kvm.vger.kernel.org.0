Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FCE667B03
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbjALQh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbjALQhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA4EB840;
        Thu, 12 Jan 2023 08:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541219; x=1705077219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qOo8AxotZf7VPiTsIv/soNSc4sWmmHtBVYc32167hw4=;
  b=BXTVzSwuZRNsszQX+Bu62KF6nEn+Q2jHRmSEUKQwpSwibGtjiceEiLsA
   cJ18Vfr7b/QzLM+hXv7K3AGkw3U8hmnJABAZDn3W8D51qHEhX6eBwPX25
   11kt0lwagOK27jNiqm1HmrIzbn9Lxdxd+a78198VfgnjyBVsK61AAGqXO
   tZXL9jcs0hf7c8DyFjK9J6EmhlGdAlk8rdejD1byCXNvtKHjCBj7SjPyt
   733AThyOlIy39MBoRH3SXmGfV9aPzD5WYm2qxM4vZAlaFDpc0jYWcVyPj
   BasNkEc+lQQnV1qx1J+6x0oxW5ZgzZHIGe+H8J2FFXh6nJLV2goyGLyyb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089651"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089651"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372499"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372499"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:33 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 078/113] KVM: TDX: Implement interrupt injection
Date:   Thu, 12 Jan 2023 08:32:26 -0800
Message-Id: <629c97aa2fdc4bac484010de84f54789612d4375.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX supports interrupt inject into vcpu with posted interrupt.  Wire up the
corresponding kvm x86 operations to posted interrupt.  Move
kvm_vcpu_trigger_posted_interrupt() from vmx.c to common.h to share the
code.

VMX can inject interrupt by setting interrupt information field,
VM_ENTRY_INTR_INFO_FIELD, of VMCS.  TDX supports interrupt injection only
by posted interrupt.  Ignore the execution path to access
VM_ENTRY_INTR_INFO_FIELD.

As cpu state is protected and apicv is enabled for the TDX guest, VMM can
inject interrupt by updating posted interrupt descriptor.  Treat interrupt
can be injected always.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/common.h      | 71 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/main.c        | 93 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/posted_intr.c |  2 +-
 arch/x86/kvm/vmx/posted_intr.h |  2 +
 arch/x86/kvm/vmx/tdx.c         | 25 +++++++++
 arch/x86/kvm/vmx/vmx.c         | 67 +-----------------------
 arch/x86/kvm/vmx/x86_ops.h     |  7 ++-
 7 files changed, 190 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 235908f3e044..747f993cf7de 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 
+#include "posted_intr.h"
 #include "mmu.h"
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -30,4 +31,74 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
+						     int pi_vec)
+{
+#ifdef CONFIG_SMP
+	if (vcpu->mode == IN_GUEST_MODE) {
+		/*
+		 * The vector of the virtual has already been set in the PIR.
+		 * Send a notification event to deliver the virtual interrupt
+		 * unless the vCPU is the currently running vCPU, i.e. the
+		 * event is being sent from a fastpath VM-Exit handler, in
+		 * which case the PIR will be synced to the vIRR before
+		 * re-entering the guest.
+		 *
+		 * When the target is not the running vCPU, the following
+		 * possibilities emerge:
+		 *
+		 * Case 1: vCPU stays in non-root mode. Sending a notification
+		 * event posts the interrupt to the vCPU.
+		 *
+		 * Case 2: vCPU exits to root mode and is still runnable. The
+		 * PIR will be synced to the vIRR before re-entering the guest.
+		 * Sending a notification event is ok as the host IRQ handler
+		 * will ignore the spurious event.
+		 *
+		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
+		 * has already synced PIR to vIRR and never blocks the vCPU if
+		 * the vIRR is not empty. Therefore, a blocked vCPU here does
+		 * not wait for any requested interrupts in PIR, and sending a
+		 * notification event also results in a benign, spurious event.
+		 */
+
+		if (vcpu != kvm_get_running_vcpu())
+			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		return;
+	}
+#endif
+	/*
+	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
+	 * otherwise do nothing as KVM will grab the highest priority pending
+	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
+	 */
+	kvm_vcpu_wake_up(vcpu);
+}
+
+/*
+ * Send interrupt to vcpu via posted interrupt way.
+ * 1. If target vcpu is running(non-root mode), send posted interrupt
+ * notification to vcpu and hardware will sync PIR to vIRR atomically.
+ * 2. If target vcpu isn't running(root mode), kick it to pick up the
+ * interrupt from PIR in next vmentry.
+ */
+static inline void __vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu,
+						  struct pi_desc *pi_desc, int vector)
+{
+	if (pi_test_and_set_pir(vector, pi_desc))
+		return;
+
+	/* If a previous notification has sent the IPI, nothing to do.  */
+	if (pi_test_and_set_on(pi_desc))
+		return;
+
+	/*
+	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
+	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
+	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
+	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
+	 */
+	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
+}
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 91696d5d183f..d5a838e87fb5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -166,6 +166,34 @@ static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return tdx_protected_apic_has_interrupt(vcpu);
 }
 
+static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
+
+	pi_clear_on(pi);
+	memset(pi->pir, 0, sizeof(pi->pir));
+}
+
+static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return -1;
+
+	return vmx_sync_pir_to_irr(vcpu);
+}
+
+static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector)
+{
+	if (is_td_vcpu(apic->vcpu)) {
+		tdx_deliver_interrupt(apic, delivery_mode, trig_mode,
+					     vector);
+		return;
+	}
+
+	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -232,6 +260,53 @@ static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
 	vmx_sched_in(vcpu, cpu);
 }
 
+static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+	vmx_set_interrupt_shadow(vcpu, mask);
+}
+
+static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_interrupt_shadow(vcpu);
+}
+
+static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_inject_irq(vcpu, reinjected);
+}
+
+static void vt_cancel_injection(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_cancel_injection(vcpu);
+}
+
+static int vt_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_interrupt_allowed(vcpu, for_injection);
+}
+
+static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_enable_irq_window(vcpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -320,31 +395,31 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
+	.set_interrupt_shadow = vt_set_interrupt_shadow,
+	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
-	.inject_irq = vmx_inject_irq,
+	.inject_irq = vt_inject_irq,
 	.inject_nmi = vmx_inject_nmi,
 	.inject_exception = vmx_inject_exception,
-	.cancel_injection = vmx_cancel_injection,
-	.interrupt_allowed = vmx_interrupt_allowed,
+	.cancel_injection = vt_cancel_injection,
+	.interrupt_allowed = vt_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
 	.enable_nmi_window = vmx_enable_nmi_window,
-	.enable_irq_window = vmx_enable_irq_window,
+	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_post_state_restore = vmx_apicv_post_state_restore,
+	.apicv_post_state_restore = vt_apicv_post_state_restore,
 	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
-	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_interrupt = vmx_deliver_interrupt,
+	.sync_pir_to_irr = vt_sync_pir_to_irr,
+	.deliver_interrupt = vt_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 	.protected_apic_has_interrupt = vt_protected_apic_has_interrupt,
 
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 92de016852ca..2b2da6c18504 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -52,7 +52,7 @@ static inline struct vcpu_pi *vcpu_to_pi(struct kvm_vcpu *vcpu)
 	return (struct vcpu_pi *)vcpu;
 }
 
-static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
+struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
 	return &vcpu_to_pi(vcpu)->pi_desc;
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 2fe8222308b2..0f9983b6910b 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -105,6 +105,8 @@ struct vcpu_pi {
 	/* Until here common layout betwwn vcpu_vmx and vcpu_tdx. */
 };
 
+struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu);
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b6a893d90893..742f0747d4d0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "common.h"
 #include "tdx.h"
 #include "vmx.h"
 #include "x86.h"
@@ -488,6 +489,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_state_protected =
 		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
 
+	tdx->pi_desc.nv = POSTED_INTR_VECTOR;
+	tdx->pi_desc.sn = 1;
+
 	tdx->host_state_need_save = true;
 	tdx->host_state_need_restore = false;
 
@@ -498,6 +502,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	vmx_vcpu_pi_load(vcpu, cpu);
 	if (vcpu->cpu == cpu)
 		return;
 
@@ -679,6 +684,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_entry(vcpu);
 
+	if (pi_test_on(&tdx->pi_desc)) {
+		apic->send_IPI_self(POSTED_INTR_VECTOR);
+
+		kvm_wait_lapic_expire(vcpu);
+	}
+
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
 	tdx_user_return_update_cache();
@@ -1010,6 +1021,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
 }
 
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	/* TDX supports only posted interrupt.  No lapic emulation. */
+	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -1705,6 +1726,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	if (ret)
 		return ret;
 
+	td_vmcs_write16(tdx, POSTED_INTR_NV, POSTED_INTR_VECTOR);
+	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->pi_desc));
+	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
+
 	tdx->vcpu_initialized = true;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d67877a7dcc6..051952544375 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4202,50 +4202,6 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 		pt_update_intercept_for_msr(vcpu);
 }
 
-static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-						     int pi_vec)
-{
-#ifdef CONFIG_SMP
-	if (vcpu->mode == IN_GUEST_MODE) {
-		/*
-		 * The vector of the virtual has already been set in the PIR.
-		 * Send a notification event to deliver the virtual interrupt
-		 * unless the vCPU is the currently running vCPU, i.e. the
-		 * event is being sent from a fastpath VM-Exit handler, in
-		 * which case the PIR will be synced to the vIRR before
-		 * re-entering the guest.
-		 *
-		 * When the target is not the running vCPU, the following
-		 * possibilities emerge:
-		 *
-		 * Case 1: vCPU stays in non-root mode. Sending a notification
-		 * event posts the interrupt to the vCPU.
-		 *
-		 * Case 2: vCPU exits to root mode and is still runnable. The
-		 * PIR will be synced to the vIRR before re-entering the guest.
-		 * Sending a notification event is ok as the host IRQ handler
-		 * will ignore the spurious event.
-		 *
-		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
-		 * has already synced PIR to vIRR and never blocks the vCPU if
-		 * the vIRR is not empty. Therefore, a blocked vCPU here does
-		 * not wait for any requested interrupts in PIR, and sending a
-		 * notification event also results in a benign, spurious event.
-		 */
-
-		if (vcpu != kvm_get_running_vcpu())
-			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
-		return;
-	}
-#endif
-	/*
-	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
-	 * otherwise do nothing as KVM will grab the highest priority pending
-	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
-	 */
-	kvm_vcpu_wake_up(vcpu);
-}
-
 static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 						int vector)
 {
@@ -4298,20 +4254,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!vcpu->arch.apic->apicv_active)
 		return -1;
 
-	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
-		return 0;
-
-	/* If a previous notification has sent the IPI, nothing to do.  */
-	if (pi_test_and_set_on(&vmx->pi_desc))
-		return 0;
-
-	/*
-	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
-	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
-	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
-	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
-	 */
-	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
+	__vmx_deliver_posted_interrupt(vcpu, &vmx->pi_desc, vector);
 	return 0;
 }
 
@@ -6944,14 +6887,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	pi_clear_on(&vmx->pi_desc);
-	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
-}
-
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
 static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 32e045480bdb..fa7a431c45da 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -62,7 +62,6 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
@@ -164,6 +163,9 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -194,6 +196,9 @@ static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
+static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+					 int trig_mode, int vector) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

