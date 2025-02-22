Return-Path: <kvm+bounces-38942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BB5A404E4
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C88B119E234E
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08B4201100;
	Sat, 22 Feb 2025 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QW3uBhvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E371378F44;
	Sat, 22 Feb 2025 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188798; cv=none; b=n6osJ3nnIfcq7DJ7xhAvXzTu7EkGUZrr607FkzQy30DTAWoAc7rDCJWmd2s3JX7mMackm2JKLWuuVYL9qxuqQymVOqGhS8YHmYenxQAiMZzr7t+A7DfQFnOZSMQPKp9WkbzqBEZgla0yqJBzSvIzUgxD01WiothPfouSiRd/dbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188798; c=relaxed/simple;
	bh=xBc91LWC0B9ZOTHIGP7MG2wXDah3Hq4eFZDHV4ZPZ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeDW6/o/7NAOscoQbi+qlEY0AIQaR9ZQT3Gz78mVjWhu+kT/RVg/YjDPsEiW/1fshXSzVsWsCZ3BGmxm+mO2slrYRFDojGLhiO/GfRQ1BqSg92ccpPIpwQkmLGM/V8e3Ql0WtnaBuCywiViMiiM0/lAtZnIeBECmPIpn5UxwlSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QW3uBhvp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188797; x=1771724797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBc91LWC0B9ZOTHIGP7MG2wXDah3Hq4eFZDHV4ZPZ/M=;
  b=QW3uBhvpj5WOD11hF+FE1f5zyx34VRJl5uNoBnUc6QVtJMrrGsSTPtfY
   XBXDLoi0xZTSe3x/fwBaNGO/m7T/vKphB/kgFheBO7GG5l0U9RyVt+L7y
   w+UfUtwcZ9YaN4JtRvBjstRnsHGuR0+MFj2hMufz31su+1UBcEDrIHhnR
   jr4pWjKIiKy7We+QLQQDDuypPPcxrXH9rUhjePhg9gybhYMNiksUWK3r1
   R0Pc7Jm4b3SWCw+6QQMBV8z4ZIr+jC2ptI3UXKTWvf7hnLPGTM2k0RHEt
   SagQYh4Une4Xm0XWUuadrIgYTVEx5IC654Gjh8noCw1UGWiVCSXTu7u//
   w==;
X-CSE-ConnectionGUID: DBNTWk1QQtWkxRbsQ+4yzw==
X-CSE-MsgGUID: VGaA/nGDR2afpSRdrj1dFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449024"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449024"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:37 -0800
X-CSE-ConnectionGUID: PlwyTx77R0CbJpgHQv2zAQ==
X-CSE-MsgGUID: R5l2VSYKQcqHbtpOhmDAvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621626"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:33 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 04/16] KVM: TDX: Implement non-NMI interrupt injection
Date: Sat, 22 Feb 2025 09:47:45 +0800
Message-ID: <20250222014757.897978-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement non-NMI interrupt injection for TDX via posted interrupt.

As CPU state is protected and APICv is enabled for the TDX guest, TDX
supports non-NMI interrupt injection only by posted interrupt. Posted
interrupt descriptors (PIDs) are allocated in shared memory, KVM can
update them directly.  If target vCPU is in non-root mode, send posted
interrupt notification to the vCPU and hardware will sync PIR to vIRR
atomically.  Otherwise, kick it to pick up the interrupt from PID. To
post pending interrupts in the PID, KVM can generate a self-IPI with
notification vector prior to TD entry.

Since the guest status of TD vCPU is protected, assume interrupt is
always allowed.  Ignore the code path for event injection mechanism or
LAPIC emulation for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts v3:
 - Fix whitespace (Chao)
 - Add trace_kvm_apicv_accept_irq() in tdx_deliver_interrupt() to match
   VMX. (Chao)

TDX interrupts v2:
- Rebased due to moving pi_desc to vcpu_vt.

TDX interrupts v1:
- Renamed from "KVM: TDX: Implement interrupt injection"
  to "KVM: TDX: Implement non-NMI interrupt injection"
- Rewrite changelog.
- Add a blank line. (Binbin)
- Split posted interrupt delivery code movement to a separate patch.
- Split kvm_wait_lapic_expire() out to a separate patch. (Chao)
- Use __pi_set_sn() to resolve upstream conflicts.
- Use kvm_x86_call()
---
 arch/x86/kvm/vmx/main.c        | 94 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/posted_intr.c |  2 +-
 arch/x86/kvm/vmx/posted_intr.h |  2 +
 arch/x86/kvm/vmx/tdx.c         | 24 ++++++++-
 arch/x86/kvm/vmx/vmx.c         |  8 ---
 arch/x86/kvm/vmx/x86_ops.h     |  6 +++
 6 files changed, 117 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 42a62be9a035..312433635bee 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -191,6 +191,34 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
 	return vmx_handle_exit(vcpu, fastpath);
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
@@ -238,6 +266,54 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
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
 static void vt_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
 {
 	*intr_info = 0;
@@ -359,19 +435,19 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.handle_exit = vt_handle_exit,
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
 
 	.x2apic_icr_is_split = false,
@@ -379,11 +455,11 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
+	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_interrupt = vmx_deliver_interrupt,
+	.sync_pir_to_irr = vt_sync_pir_to_irr,
+	.deliver_interrupt = vt_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 25f8a19e2831..895bbe85b818 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  */
 static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
-static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
+struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
 	return &(to_vt(vcpu)->pi_desc);
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index ad9116a99bcc..68605ca7ef68 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -5,6 +5,8 @@
 #include <linux/bitmap.h>
 #include <asm/posted_intr.h>
 
+struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu);
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b52a8a6a7838..e8d14b22b144 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -680,6 +680,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
 
+	tdx->vt.pi_desc.nv = POSTED_INTR_VECTOR;
+	__pi_set_sn(&tdx->vt.pi_desc);
+
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 
 	return 0;
@@ -689,6 +692,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	vmx_vcpu_pi_load(vcpu, cpu);
 	if (vcpu->cpu == cpu)
 		return;
 
@@ -953,6 +957,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	trace_kvm_entry(vcpu, force_immediate_exit);
 
+	if (pi_test_on(&vt->pi_desc))
+		apic->send_IPI_self(POSTED_INTR_VECTOR);
+
 	tdx_vcpu_enter_exit(vcpu);
 
 	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
@@ -1617,6 +1624,18 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
 }
 
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	/* TDX supports only posted interrupt.  No lapic emulation. */
+	__vmx_deliver_posted_interrupt(vcpu, &tdx->vt.pi_desc, vector);
+
+	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
+}
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -2587,8 +2606,11 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	/* TODO: freeze vCPU model before kvm_update_cpuid_runtime() */
 	kvm_update_cpuid_runtime(vcpu);
 
-	tdx->state = VCPU_TD_STATE_INITIALIZED;
+	td_vmcs_write16(tdx, POSTED_INTR_NV, POSTED_INTR_VECTOR);
+	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->vt.pi_desc));
+	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
 
+	tdx->state = VCPU_TD_STATE_INITIALIZED;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d4185df1581..d4868e3bd9a2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6908,14 +6908,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vt *vt = to_vt(vcpu);
-
-	pi_clear_on(&vt->pi_desc);
-	memset(vt->pi_desc.pir, 0, sizeof(vt->pi_desc.pir));
-}
-
 void vmx_do_interrupt_irqoff(unsigned long entry);
 void vmx_do_nmi_irqoff(void);
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9d2e76c5a5a7..b0b9d7bc8a0b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -139,6 +139,9 @@ void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath);
+
+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
@@ -178,6 +181,9 @@ static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath) { return 0; }
+
+static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+					 int trig_mode, int vector) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
 
-- 
2.46.0


