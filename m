Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6AC4CDD9C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiCDT7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74148214056;
        Fri,  4 Mar 2022 11:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423439; x=1677959439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZXG9LYmwt7xN2+5/B0yR/29m/+Ip/fA/n1MMYJYW5Ro=;
  b=fxPgM8u5fcdXSbDoqNgZaUfgjEPSPcR9PD8f3XO7DdoxyTiArXH9kEdA
   UviFtIwOHj7FWRpaum/qNPB9HzkNBC65ddAD8al6WuACF3Iz/KSPMmRW+
   EzLteUi86/ZuXvs+g2zlkMIYg2o/aRauYTNMziKoatkhWvhIiXfbXlqa4
   0xqiW7/Wzk2rAM6I6N156Rj6Y2sCxL6VfyzwC1IAbbEKqN+p6wkZ7misa
   rVNKD+Y8KVjSC/wkf5831q+2aY/MlUOfHXwt6Mu2Vzuok5xZnuGu5AN1z
   5DyrK39/zzYrwuXVP7q/kiR+oyQsbB+Sd1p9ZZiIVolgl6OvB+cyFhTOu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779630"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779630"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:38 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344503"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 078/104] KVM: TDX: Implement interrupt injection
Date:   Fri,  4 Mar 2022 11:49:34 -0800
Message-Id: <776d48b5c88ebf189ffac1eb94ef190bfc7210da.1646422845.git.isaku.yamahata@intel.com>
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
---
 arch/x86/kvm/vmx/common.h      | 70 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/main.c        | 93 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/posted_intr.c |  6 +++
 arch/x86/kvm/vmx/tdx.c         | 33 ++++++++++++
 arch/x86/kvm/vmx/tdx.h         |  3 ++
 arch/x86/kvm/vmx/vmx.c         | 57 +--------------------
 arch/x86/kvm/vmx/x86_ops.h     |  7 ++-
 7 files changed, 203 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 1052b3c93eb8..79a4517e43d1 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 
+#include "posted_intr.h"
 #include "mmu.h"
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -32,4 +33,73 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
+						     int pi_vec)
+{
+#ifdef CONFIG_SMP
+	if (vcpu->mode == IN_GUEST_MODE) {
+		/*
+		 * The vector of interrupt to be delivered to vcpu had
+		 * been set in PIR before this function.
+		 *
+		 * Following cases will be reached in this block, and
+		 * we always send a notification event in all cases as
+		 * explained below.
+		 *
+		 * Case 1: vcpu keeps in non-root mode. Sending a
+		 * notification event posts the interrupt to vcpu.
+		 *
+		 * Case 2: vcpu exits to root mode and is still
+		 * runnable. PIR will be synced to vIRR before the
+		 * next vcpu entry. Sending a notification event in
+		 * this case has no effect, as vcpu is not in root
+		 * mode.
+		 *
+		 * Case 3: vcpu exits to root mode and is blocked.
+		 * vcpu_block() has already synced PIR to vIRR and
+		 * never blocks vcpu if vIRR is not cleared. Therefore,
+		 * a blocked vcpu here does not wait for any requested
+		 * interrupts in PIR, and sending a notification event
+		 * which has no effect is safe here.
+		 */
+
+		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
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
+static inline void __vmx_deliver_posted_interrupt(
+	struct kvm_vcpu *vcpu, struct pi_desc *pi_desc, int vector)
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
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d75caf0d6861..a0bcc4dca678 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -148,6 +148,34 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	return vmx_vcpu_load(vcpu, cpu);
 }
 
+static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_apicv_post_state_restore(vcpu);
+
+	return vmx_apicv_post_state_restore(vcpu);
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
 static bool vt_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -205,6 +233,53 @@ static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
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
+static void vt_inject_irq(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_inject_irq(vcpu);
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
 static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -279,31 +354,31 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
+	.set_interrupt_shadow = vt_set_interrupt_shadow,
+	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
-	.set_irq = vmx_inject_irq,
+	.set_irq = vt_inject_irq,
 	.set_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
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
 	.apicv_has_pending_interrupt = vt_apicv_has_pending_interrupt,
 
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index c8a81c916eed..e22c3015f064 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -7,6 +7,7 @@
 #include "lapic.h"
 #include "irq.h"
 #include "posted_intr.h"
+#include "tdx.h"
 #include "trace.h"
 #include "vmx.h"
 
@@ -31,6 +32,11 @@ static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (is_td_vcpu(vcpu))
+		return &(to_tdx(vcpu)->pi_desc);
+#endif
+
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3a0e826fbe0c..bdc658ca9e4f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "common.h"
 #include "mmu.h"
 #include "tdx.h"
 #include "vmx.h"
@@ -494,6 +495,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_state_protected =
 		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
 
+	tdx->pi_desc.nv = POSTED_INTR_VECTOR;
+	tdx->pi_desc.sn = 1;
+
 	tdx->host_state_need_save = true;
 	tdx->host_state_need_restore = false;
 
@@ -514,6 +518,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	vmx_vcpu_pi_load(vcpu, cpu);
 	if (vcpu->cpu == cpu)
 		return;
 
@@ -735,6 +740,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_entry(vcpu);
 
+	if (pi_test_on(&tdx->pi_desc)) {
+		apic->send_IPI_self(POSTED_INTR_VECTOR);
+
+		kvm_wait_lapic_expire(vcpu, true);
+	}
+
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
 	tdx_user_return_update_cache();
@@ -1008,6 +1019,24 @@ static void tdx_handle_changed_private_spte(
 	}
 }
 
+void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	pi_clear_on(&tdx->pi_desc);
+	memset(tdx->pi_desc.pir, 0, sizeof(tdx->pi_desc.pir));
+}
+
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
 static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -1425,6 +1454,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 		return -EIO;
 	}
 
+	td_vmcs_write16(tdx, POSTED_INTR_NV, POSTED_INTR_VECTOR);
+	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->pi_desc));
+	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
+
 	tdx->initialized = true;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 180360a65545..7cd81780f3fa 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -83,6 +83,9 @@ struct vcpu_tdx {
 
 	struct list_head cpu_list;
 
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
 	union tdx_exit_reason exit_reason;
 
 	bool initialized;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b7bd52d19a9..4bd1e61b8d45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3931,48 +3931,6 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	pt_update_intercept_for_msr(vcpu);
 }
 
-static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-						     int pi_vec)
-{
-#ifdef CONFIG_SMP
-	if (vcpu->mode == IN_GUEST_MODE) {
-		/*
-		 * The vector of interrupt to be delivered to vcpu had
-		 * been set in PIR before this function.
-		 *
-		 * Following cases will be reached in this block, and
-		 * we always send a notification event in all cases as
-		 * explained below.
-		 *
-		 * Case 1: vcpu keeps in non-root mode. Sending a
-		 * notification event posts the interrupt to vcpu.
-		 *
-		 * Case 2: vcpu exits to root mode and is still
-		 * runnable. PIR will be synced to vIRR before the
-		 * next vcpu entry. Sending a notification event in
-		 * this case has no effect, as vcpu is not in root
-		 * mode.
-		 *
-		 * Case 3: vcpu exits to root mode and is blocked.
-		 * vcpu_block() has already synced PIR to vIRR and
-		 * never blocks vcpu if vIRR is not cleared. Therefore,
-		 * a blocked vcpu here does not wait for any requested
-		 * interrupts in PIR, and sending a notification event
-		 * which has no effect is safe here.
-		 */
-
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
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
@@ -4024,20 +3982,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!vcpu->arch.apicv_active)
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
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 0f1a28f67e60..c3768a20347f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -148,7 +148,8 @@ void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 
 void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
-int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector);
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -176,6 +177,10 @@ static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 
+static inline void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
+static inline void tdx_deliver_interrupt(
+	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

