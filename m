Return-Path: <kvm+bounces-31423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AC19C3A5A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E03FB216FD
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E8716CD1D;
	Mon, 11 Nov 2024 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3XRrk42"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AE3A933;
	Mon, 11 Nov 2024 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731315630; cv=none; b=YhQpMKkSaXbqvbbYRFLci5dOx0dYacC0Ji7MzwrdNz+eIsZvBtnEg24vqQrl2h5VJYkDV2SHu746ty5d+e/HTxirSmEaVtcynwWL1s6Gi74lnQR+m5+sq9z7rrCdzJRiX/9vmi4hhgP0rH+dYWfSX0aum1Ho8uAtvRXT/5OhpRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731315630; c=relaxed/simple;
	bh=loTNOLmAdA71QdyDe/0WgDlOoKF9wgs054AZGs6HB9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hT7mJx/KHHqpZRpGa2gunMzOKZFzNROFUMqqtLFM4ExkemhjWcgZk7HbsoJf9RsVHloeTZcpnLuksU5fNtUQewwD8/nPlLxnHNEFd2ke+TVK8dJ24UibImznDYFmoH9CRNHo2gzRZaK54Z54+TH8JciWsc8ZyJCGLMDIuNzxe88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3XRrk42; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731315628; x=1762851628;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=loTNOLmAdA71QdyDe/0WgDlOoKF9wgs054AZGs6HB9U=;
  b=g3XRrk423JgNfacFdn4vWFMhD1ebsnMSSzEi9ueBKBCcec+nVCIe97HF
   y0al1jU4a0gK42hl+Er2EAYpe9+wVrNj8HJmPfIn8bMwdoDAUNn5Ou73+
   gvVRj3+yrhBb25weMeiQht5DxL+iDjekZouDX6mgkZIxMXW7wz1PkyrQD
   rg+AorC9sjayXbimnmrH/W+2SlMvXa87J+/RbrxrbppH387GK2/gFwiRA
   9ImMMeXg+8/b8Gx8tj+4nR3n4HcWnYQM4oopG7JHZPi/XBWravtEldXPS
   ii7I8wyjfrCuFIxVjY5xX7PEY1+7ZB9gu+VZKiz0hchdckAzGY1hBzEBM
   A==;
X-CSE-ConnectionGUID: /nsM4j5MTfaugOFWZYe3Gg==
X-CSE-MsgGUID: R45FHKmiSviBKVkO9oFBXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="30526945"
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="30526945"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:00:26 -0800
X-CSE-ConnectionGUID: r2wigX/3QuqjEy20I10C0g==
X-CSE-MsgGUID: FfJ5VEcJRp2PHfmypg3kew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="86928885"
Received: from spr.sh.intel.com ([10.239.53.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:00:23 -0800
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Remove hwapic_irr_update() from kvm_x86_ops
Date: Mon, 11 Nov 2024 16:59:46 +0800
Message-ID: <20241111085947.432645-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the redundant .hwapic_irr_update() ops.

If a vCPU has APICv enabled, KVM updates its RVI before VM-enter to L1
in vmx_sync_pir_to_irr(). This guarantees RVI is up-to-date and aligned
with the vIRR in the virtual APIC. So, no need to update RVI every time
the vIRR changes.

Note that KVM never updates vmcs02 RVI in .hwapic_irr_update() or
vmx_sync_pir_to_irr(). So, removing .hwapic_irr_update() has no
impact to the nested case.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  1 -
 arch/x86/kvm/lapic.c               |  6 ------
 arch/x86/kvm/vmx/main.c            |  1 -
 arch/x86/kvm/vmx/vmx.c             | 14 --------------
 arch/x86/kvm/vmx/x86_ops.h         |  1 -
 6 files changed, 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 861d080ed4c6..68505a9ac3c6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -82,7 +82,6 @@ KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP_OPTIONAL(hwapic_irr_update)
 KVM_X86_OP_OPTIONAL(hwapic_isr_update)
 KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
 KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..f654ecb99917 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1732,7 +1732,6 @@ struct kvm_x86_ops {
 	const unsigned long required_apicv_inhibits;
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
-	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..6a81233c304d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -734,10 +734,7 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
 	if (unlikely(apic->apicv_active)) {
-		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		kvm_x86_call(hwapic_irr_update)(apic->vcpu,
-						apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
@@ -2766,7 +2763,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	apic_update_ppr(apic);
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_irr_update)(vcpu, -1);
 		kvm_x86_call(hwapic_isr_update)(-1);
 	}
 
@@ -3083,8 +3079,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_irr_update)(vcpu,
-						apic_find_highest_irr(apic));
 		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7668e2fb8043..7ba7d416af58 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -99,7 +99,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b1bb64890cb2..17fc191efd5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6888,20 +6888,6 @@ static void vmx_set_rvi(int vector)
 	}
 }
 
-void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-{
-	/*
-	 * When running L2, updating RVI is only relevant when
-	 * vmcs12 virtual-interrupt-delivery enabled.
-	 * However, it can be enabled only when L1 also
-	 * intercepts external-interrupts and in that case
-	 * we should not update vmcs02 RVI but instead intercept
-	 * interrupt. Therefore, do nothing when running L2.
-	 */
-	if (!is_guest_mode(vcpu))
-		vmx_set_rvi(max_irr);
-}
-
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index a55981c5216e..847080d5fb70 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -47,7 +47,6 @@ bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
-void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
 void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.46.1


