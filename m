Return-Path: <kvm+bounces-9712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA28866D52
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF1DBB25009
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E72B7AE44;
	Mon, 26 Feb 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mH/eZuAD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5479DDD;
	Mon, 26 Feb 2024 08:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936130; cv=none; b=H61zGj4csE9p6awGnU6cSoZZKEn70TD5ifx/jO2Ti92LU9+K0ozSEXQjI5kB0TgjMmqNPmROfEvQrkqwOVyv/CtHT/ubdFIIQyYex5xP+d3kQm3gf4hMaLANsG8TeSwZrKs55Puy0tToJdikB+ARL8sShn0ENsDDdV4b8qMuwxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936130; c=relaxed/simple;
	bh=BHP76H37q8PEr+1VCgScyEXlairXZGF6vGYRWXEvFiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qhp0FLft5igcFBQ7MfgDy2HsH4M2QkMW5chFxVb/D9yIjPl4IjSh77G2bdwqVa5NvFaxcQgIe3cvCtSYZXIljp+kPqWMAdD6YeFAdy4hjoKe0HkUyugnam5tFC9yYhJo7KBMX/cdP4ptq2kPpOSutnAQJHgBrU/61OrTC10iWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mH/eZuAD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936129; x=1740472129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BHP76H37q8PEr+1VCgScyEXlairXZGF6vGYRWXEvFiQ=;
  b=mH/eZuADpYbw3lo/AM5yvbGcE1943OqwrdHGMaJo1Z9bTDxL5w+er8qI
   SFmCgWlWhJZO9OqBEs3ke7/ZYFn6p6v5sir1Og/GM1jp5iwHFs/7Kro8q
   V4J0FHIPD+uC8YsfmwUEZManF/GQV359YT9xTfMf13kO3OY73pFuIjTbl
   XbssH54uktowGLZ/2oZm9bAShfcKCdEuod6I2DH+rzAWbRACH0mjbX0XE
   kwyVydDD6xWKhY5XDpCeSHsQG5BHWWT7f1sq5TRElztMm4mFrkLjQGk8p
   R+em5OxmBPxPP/0FZ5gZC0rM95UIJBsTyryT8qQKimgqt9jujO8ESNO5v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069549"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069549"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272633"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:47 -0800
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
Subject: [PATCH v19 089/130] KVM: TDX: Add support for find pending IRQ in a protected local APIC
Date: Mon, 26 Feb 2024 00:26:31 -0800
Message-Id: <8ea6ffce742842da725a7e3f891a38583bdb099b.1708933498.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Add flag and hook to KVM's local APIC management to support determining
whether or not a TDX guest as a pending IRQ.  For TDX vCPUs, the virtual
APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
result, registers that are virtualized by the CPU, e.g. PPR, cannot be
read or written by KVM.  To deliver interrupts for TDX guests, KVM must
send an IRQ to the CPU on the posted interrupt notification vector.  And
to determine if TDX vCPU has a pending interrupt, KVM must check if there
is an outstanding notification.

Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
protected to short-circuit the various other flows that try to pull an
IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
pending, KVM can't do anything based on _which_ IRQ is pending.

Intentionally omit sanity checks from other flows, e.g. PPR update, so as
not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
and userspace will never reach those flows for TDX guests, but reaching
them is not fatal if something does go awry.

Note, this doesn't handle interrupts that have been delivered to the vCPU
but not yet recognized by the core, i.e. interrupts that are sitting in
vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
be supported in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/irq.c                 |  3 +++
 arch/x86/kvm/lapic.c               |  3 +++
 arch/x86/kvm/lapic.h               |  2 ++
 arch/x86/kvm/vmx/main.c            | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c             |  6 ++++++
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 8 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index fb3ae97c724e..22d93d4124c8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -124,6 +124,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
 KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a9df898c6fbd..e0ffef1d377d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1800,6 +1800,7 @@ struct kvm_x86_ops {
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index ad9ca8a60144..f253f4c6bf04 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
+	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
+		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
+
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..e8034f2f2dd1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2860,6 +2860,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
+	if (apic->guest_apic_protected)
+		return -1;
+
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..749b7b629c47 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -66,6 +66,8 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	/* Select registers in the vAPIC cannot be read/written. */
+	bool guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9b336c1a6508..5fd99e844b86 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -78,6 +78,8 @@ static __init int vt_hardware_setup(void)
 	if (enable_tdx)
 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
 					   sizeof(struct kvm_tdx));
+	else
+		vt_x86_ops.protected_apic_has_interrupt = NULL;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (enable_tdx)
@@ -219,6 +221,13 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_load(vcpu, cpu);
 }
 
+static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	KVM_BUG_ON(!is_td_vcpu(vcpu), vcpu->kvm);
+
+	return tdx_protected_apic_has_interrupt(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -443,6 +452,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+	.protected_apic_has_interrupt = vt_protected_apic_has_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ab7403a19c5d..a5b52aa6d153 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -583,6 +583,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+	vcpu->arch.apic->guest_apic_protected = true;
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
@@ -624,6 +625,11 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_has_pending_interrupt(vcpu);
+}
+
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 5853f29f0af3..f3f90186926c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -155,6 +155,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -194,6 +195,7 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTP
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1


