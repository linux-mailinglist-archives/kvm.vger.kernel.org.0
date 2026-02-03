Return-Path: <kvm+bounces-70039-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABFXM2c8gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70039-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:20:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A61DD7AE
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D19F430B19DB
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E6F36656F;
	Tue,  3 Feb 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aoDz/iyE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD21369986;
	Tue,  3 Feb 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142659; cv=none; b=meuIUzPTkVfiK0tVoB0IxbSmfkMBEXuTTKJyznp2KdFMjsOxcylZQq9dGx+Q1Db1Tm4m5jYHYjFaSq5srMLwLUl0D2s96TlXbzDfox1oM/xCthSLN0gliWGU8Lnhk1tLCyyeum1tjSKmWq5GxX7Dkh/b1kSRJAHFYYJMyVf64Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142659; c=relaxed/simple;
	bh=vbBFzFGGMBaUVVXq5gBrNuL4GVQbi4JRrKzQPeO1JBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIPVFtwRmGmHytvmrMDzyNCzT5qus71qUVQ6MnEW1tfGT+Ah1Gu57dmedmlAEoyBk9looDg8VuE1bbIMod/uaYlTlXHGWmLZbVUMyFfwsBCW7hghd7IqL9cAyQvJwB3NvjzB2sD5F90PLyemIHtBRJPK+kNDfJf4n7odyltRfz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aoDz/iyE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142656; x=1801678656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vbBFzFGGMBaUVVXq5gBrNuL4GVQbi4JRrKzQPeO1JBo=;
  b=aoDz/iyE8Q0geAkf2QpT9E+3z1+TYEjPtAPJag9N4zIIHtalft86dGKm
   eLQ/rOgTycwr2G2aUrgHtSe1LBuKBD6ZemJVmx6xL2qdbZL3jE+GWKhZP
   Xqim0gB8J4JhXSL/9CrkRwTcOCo+rsZhkxiqFJci2H6k2UFd4npBRge7S
   jZsdr7ErvLHeKccVvAUw6pPGE2YHYpWTtMr+maRIgBR9EzAE2LcJnv2Md
   Z6ig1tvOGnxIFzMYnCUocKr3I8MgqZ4akEDGaojywFzWJNly5FrtiXeLW
   Nwj74jUWsTHH54unpM/lmfyV9CFWE6Gv1qKW1c/qvaiAH1zqRW6wQ7KCe
   w==;
X-CSE-ConnectionGUID: 6IAsTQmkRIiGHgOnx7q61w==
X-CSE-MsgGUID: UPxaJZllRxCoNP6pR9EqbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433179"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433179"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:35 -0800
X-CSE-ConnectionGUID: MXEsmSjcQQ6venxgoiUfiw==
X-CSE-MsgGUID: zuC3c9LhRRKjOfZ1zVlmIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727492"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:35 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH 06/32] KVM: VMX: Implement the hooks for VMX guest virtual deadline timer
Date: Tue,  3 Feb 2026 10:16:49 -0800
Message-ID: <67503c138899e2f5ebb84d9c4a19c2fd632fb1e7.1770116050.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70039-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 86A61DD7AE
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Implement the hooks for the VMX backend for APIC timer virtualization to
access the related VMCS fields.

Co-developed-by: Yang Zhong <yang.zhong@linux.intel.com>
Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.h            |  5 ++
 arch/x86/kvm/vmx/capabilities.h |  6 +++
 arch/x86/kvm/vmx/main.c         |  5 ++
 arch/x86/kvm/vmx/vmx.c          | 83 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h      |  5 ++
 5 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 67172fef1b5b..d3fad67a4e78 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -230,6 +230,11 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 	return lapic_in_kernel(vcpu) && test_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
 }
 
+static inline int kvm_lapic_lvtt_timer_mode(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.apic->lapic_timer.timer_mode;
+}
+
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 02aadb9d730e..ffc51fe9a455 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -90,6 +90,12 @@ static inline bool cpu_has_vmx_preemption_timer(void)
 		PIN_BASED_VMX_PREEMPTION_TIMER;
 }
 
+static inline bool cpu_has_vmx_apic_timer_virt(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl &
+		TERTIARY_EXEC_GUEST_APIC_TIMER;
+}
+
 static inline bool cpu_has_vmx_posted_intr(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a46ccd670785..56387c3412e1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -989,6 +989,11 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vt_op(set_hv_timer),
 	.cancel_hv_timer = vt_op(cancel_hv_timer),
+	.can_use_apic_virt_timer = vmx_can_use_apic_virt_timer,
+	.set_apic_virt_timer = vmx_set_apic_virt_timer,
+	.cancel_apic_virt_timer = vmx_cancel_apic_virt_timer,
+	.set_guest_tsc_deadline_virt = vmx_set_guest_tsc_deadline_virt,
+	.get_guest_tsc_deadline_virt = vmx_get_guest_tsc_deadline_virt,
 #endif
 
 	.setup_mce = vt_op(setup_mce),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d0d2d8ebcff..dcb04fc0b8a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2789,7 +2789,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
-	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
+	if (!IS_ENABLED(CONFIG_X86_64) ||
+	    !(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
 		_cpu_based_3rd_exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
 
 	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
@@ -8268,6 +8269,86 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->hv_deadline_tsc = -1;
 }
+
+bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+		return false;
+
+	return cpu_has_vmx_apic_timer_virt() &&
+		/* VMX guest virtual timer supports only TSC deadline mode. */
+		kvm_lapic_lvtt_timer_mode(vcpu) == APIC_LVT_TIMER_TSCDEADLINE &&
+		/* Require SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY  */
+		kvm_vcpu_apicv_active(vcpu) &&
+		/* KVM doesn't use RDTSC existing. Safeguard. */
+		!(exec_controls_get(to_vmx(vcpu)) & CPU_BASED_RDTSC_EXITING);
+}
+
+void vmx_set_apic_virt_timer(struct kvm_vcpu *vcpu, u16 vector)
+{
+	vmcs_write16(GUEST_APIC_TIMER_VECTOR, vector);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE, MSR_TYPE_RW);
+	tertiary_exec_controls_setbit(to_vmx(vcpu), TERTIARY_EXEC_GUEST_APIC_TIMER);
+}
+
+void vmx_cancel_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	vmx_enable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE, MSR_TYPE_RW);
+	tertiary_exec_controls_clearbit(to_vmx(vcpu), TERTIARY_EXEC_GUEST_APIC_TIMER);
+}
+
+static u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc)
+{
+	u64 host_tsc_now = rdtsc();
+	u64 l1_tsc_now = kvm_read_l1_tsc(vcpu, host_tsc_now);
+	u64 host_tsc;
+
+	/* 0 means that timer is disarmed. */
+	if (!l1_tsc)
+		return 0;
+
+	host_tsc = l1_tsc - vcpu->arch.l1_tsc_offset;
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_caps.default_tsc_scaling_ratio)
+		if (u64_shl_div_u64(l1_tsc,
+				    kvm_caps.tsc_scaling_ratio_frac_bits,
+				    vcpu->arch.l1_tsc_scaling_ratio,
+				    &host_tsc))
+			host_tsc = ~0ull;
+
+	/*
+	 * Clamp the result on overflow.
+	 * TSC deadline isn't supposed to overflow in practice.
+	 * ~0ull is considered that the timer is armed, but won't fire in
+	 * practical timer frame.
+	 */
+	if (l1_tsc > l1_tsc_now && host_tsc <= host_tsc_now)
+		host_tsc = ~0ull;
+	/*
+	 * Clamp the result on underflow.
+	 * The past value means fire the timer immediately.
+	 * Pick the obvious past value.
+	 */
+	if (l1_tsc <= l1_tsc_now && host_tsc > host_tsc_now)
+		host_tsc = 1ull;
+
+	if (!host_tsc)
+		host_tsc = 1ull;
+
+	return host_tsc;
+}
+
+void vmx_set_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu,
+				     u64 guest_deadline_virt)
+{
+	vmcs_write64(GUEST_DEADLINE_VIR, guest_deadline_virt);
+	vmcs_write64(GUEST_DEADLINE_PHY,
+		     vmx_calc_deadline_l1_to_host(vcpu, guest_deadline_virt));
+}
+
+u64 vmx_get_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read64(GUEST_DEADLINE_VIR);
+}
 #endif
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d09abeac2b56..364050e0427c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -117,6 +117,11 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		     bool *expired);
 void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
+bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu);
+void vmx_set_apic_virt_timer(struct kvm_vcpu *vcpu, u16 vector);
+void vmx_cancel_apic_virt_timer(struct kvm_vcpu *vcpu);
+void vmx_set_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc);
+u64 vmx_get_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
-- 
2.45.2


