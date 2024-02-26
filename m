Return-Path: <kvm+bounces-9717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7498C866D58
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E14EA1F216C5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AB57CF0D;
	Mon, 26 Feb 2024 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afHs07nx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AD57AE4B;
	Mon, 26 Feb 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936133; cv=none; b=dvzLU4Q/Nwt5IAduafUMd6BZ808gchZBN/57W49a/himxPw8EXWULqJV8Ov69LgTUfByh5qocBuwgwuuT+cd5kZKoh9/5S93cwcjji7mOIxJH77caf/M1iMR6gfIS0QUhEqD17CilkmkxLdnvvQssXs7/dpN2i13eyH551abILw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936133; c=relaxed/simple;
	bh=PyikNyG7fKJSTvY484nYih3zF/u6N+ZdYnoP25Ocepo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OERPMMD6Oj8xikjs9vPyM+mMUm4m7xYZ8w0uIPN8B+SphxbIFjGCllIRC6P3Vy3wNzKaOZe3aaymmmV+EzsC/IhSBXC/jrM4wVCLPBxTu/YEonqCV47629olxs5/0zVvh3CmbcFmDlV+DFWQ88Vsz6m+dZLWz8d1fBqssstB5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afHs07nx; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936132; x=1740472132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PyikNyG7fKJSTvY484nYih3zF/u6N+ZdYnoP25Ocepo=;
  b=afHs07nxATRYSzSJD41ixUbnBTr5Q4PGgIxjZUnLqgMmQzVP2Bta426o
   6aI4ivjgBVJ2sm/WvmX8YGda6qJFfKlNL0TqhGUgX2xwTOMlsmrEzvmKC
   QTDhTzgCQ9AalPxP6MClGJ+TIzmKSktNtGUpTO34oeLT9M2LYzngRmIdB
   pUQx7qO9YlN39z0+lxSiGvo4ZycJVRF9ye4Y2pJzhJO2S/vgjuDHMyTIW
   svFxxfyzrEcYdzU/cBcQ/VZZ5ucHDjHuHuCyg0j2amJEi16+DdCYB8fHu
   wgRa73i7D5rKiFWFTneG/0pEqVzOprDycLe1xl7j0/Z1z1h++2PkDAmHN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069564"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069564"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272647"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:50 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 092/130] KVM: TDX: Implement interrupt injection
Date: Mon, 26 Feb 2024 00:26:34 -0800
Message-Id: <b2d9539b23f155b95864db3eacce55e0e24eed4d.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 235908f3e044..6f21d0d48809 100644
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
+			__apic_send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
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
index 5fd99e844b86..f2c9d6358f9e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -228,6 +228,34 @@ static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return tdx_protected_apic_has_interrupt(vcpu);
 }
 
+static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
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
 	if (is_td_vcpu(vcpu)) {
@@ -297,6 +325,53 @@ static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
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
@@ -426,31 +501,31 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
-	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
+	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
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
index b66add9da0f3..c86768b83f0b 100644
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
index 1da58c36217c..1dfa9b503e0d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "common.h"
 #include "mmu.h"
 #include "tdx_arch.h"
 #include "tdx.h"
@@ -603,6 +604,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	tdx->host_state_need_save = true;
 	tdx->host_state_need_restore = false;
 
+	tdx->pi_desc.nv = POSTED_INTR_VECTOR;
+	tdx->pi_desc.sn = 1;
+
 	return 0;
 }
 
@@ -610,6 +614,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	vmx_vcpu_pi_load(vcpu, cpu);
 	if (vcpu->cpu == cpu)
 		return;
 
@@ -848,6 +853,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_entry(vcpu);
 
+	if (pi_test_on(&tdx->pi_desc)) {
+		apic->send_IPI_self(POSTED_INTR_VECTOR);
+
+		kvm_wait_lapic_expire(vcpu);
+	}
+
 	tdx_vcpu_enter_exit(tdx);
 
 	tdx_user_return_update_cache(vcpu);
@@ -1213,6 +1224,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
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
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -1972,6 +1993,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	if (ret)
 		return ret;
 
+	td_vmcs_write16(tdx, POSTED_INTR_NV, POSTED_INTR_VECTOR);
+	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->pi_desc));
+	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
+
 	tdx->initialized = true;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 162bb134aae6..1349ec438837 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4157,50 +4157,6 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
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
-			__apic_send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
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
@@ -4253,20 +4209,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
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
 
@@ -6946,14 +6889,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	pi_clear_on(&vmx->pi_desc);
-	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
-}
-
 void vmx_do_interrupt_irqoff(unsigned long entry);
 void vmx_do_nmi_irqoff(void);
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f3f90186926c..12a212e71827 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,7 +58,6 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
@@ -158,6 +157,9 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector);
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
 void tdx_flush_tlb(struct kvm_vcpu *vcpu);
@@ -198,6 +200,9 @@ static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
+static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+					 int trig_mode, int vector) {}
+
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
 static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
-- 
2.25.1


