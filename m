Return-Path: <kvm+bounces-70045-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iC+OLVQ9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70045-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D0BDD85F
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9A1530F61DA
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853343D904A;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fJmQoijE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2973D667F;
	Tue,  3 Feb 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142665; cv=none; b=lvw89Ciny99LKxkV1eMvVl7T/wbttgDflFiVzBWeVXYrAZlGEyc7EFv0gFKr1+K58tg4flVQyAa8VNbi41/UUvrUF7Lemulj0OlIs7CuIzgeVQ86M+bcpWz3nPSbn40X5nBqjTNxbMCF6JTZe9j30k0KYFnOnibWKT+CZnSmVeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142665; c=relaxed/simple;
	bh=kZmy1PJDzMPDX74OH/nE3q+FpGgrr1mWJ3pQWgdL5PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWPjs2DXrPMQwiwp5iucV8EwYk27T0GszGFwnNRZHAugHriiHpoPH+YxFXw39RutfP4Isv7XZuyjUe2yAAlFZd68BaOWKYsIhIsoAULwn1f5N7afenTc29Q00Q73doEia/yPGEjne699yxz9PNcOb9gsfDkf0lw4a5X+i3RTLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fJmQoijE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142663; x=1801678663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kZmy1PJDzMPDX74OH/nE3q+FpGgrr1mWJ3pQWgdL5PI=;
  b=fJmQoijE2Z+2kbWghnue8mFNeDRoVCuf3iAaj4dpSvA5/+Rp54g67z9o
   yM9OBzjh5iSfMbVMGFhExleAAFkgkeYhr48QB6sFrOKynSm5v+m3+U96Z
   Efd523lpE/KgzWNYQW92ME1ar1t0C/3wVanWZZTdUUmXn4Vzkrh4vXrRN
   IF3cBpAsGaedplQRln0R1QLngIWmp4GBjNDhTP/U99lFgC+EE6YxpeugC
   j6gL/Y3/qWAr9nohaX+uOkf07qkCYaW66lrq8R5iDDN6/jtxnryen1qcW
   oXPxBSAnOzNR3L/yxauHDkbq8QPB5o/te4w3x0RoDid9wu/2FRQAmhLep
   Q==;
X-CSE-ConnectionGUID: uqUCfCJsQM26M5mUnHf+BA==
X-CSE-MsgGUID: lw3XP9d5RKKEFO/p1xS8JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433188"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433188"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:43 -0800
X-CSE-ConnectionGUID: sXOOppfjTUalWMA0ZiH1Uw==
X-CSE-MsgGUID: Ungg3JJuSaiyhWJLDLA+Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727505"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/32] KVM: nVMX: Disallow/allow guest APIC timer virtualization switch to/from L2
Date: Tue,  3 Feb 2026 10:16:51 -0800
Message-ID: <642d76482132d7b0ebc4c2468bc24e0f65cc48da.1770116050.git.isaku.yamahata@intel.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70045-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 18D0BDD85F
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable guest APIC timer virtualization on nested VMEnter, enable it on
nested vmexit.

With VMX APIC timer virtualization, the CPU directly injects a guest timer
interrupt without VMExit.  When the L1 APIC timer fires while running the
nested (L2) vCPU, KVM should emulate VMExit from L2 to L1.  Switch to the
hv timer (preemption timer) or the sw timer when VMEntering from L1 to L2,
switch to guest APIC timer virtualization when VM exiting from L2 to L1.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c      | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h      |  2 ++
 arch/x86/kvm/vmx/nested.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.c    |  5 +++++
 4 files changed, 49 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a2f714eb78b1..7c3ec0565a8f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1862,6 +1862,35 @@ static void apic_cancel_apic_virt_timer(struct kvm_lapic *apic)
 	start_apic_timer(apic);
 }
 
+void kvm_sync_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
+	if (!apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	apic->lapic_timer.tscdeadline = kvm_x86_call(get_guest_tsc_deadline_virt)(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_sync_apic_virt_timer);
+
+void kvm_cancel_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	WARN_ON_ONCE(!is_guest_mode(vcpu));
+
+	if (!apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	apic->lapic_timer.apic_virt_timer_in_use = false;
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id, false);
+
+	start_apic_timer(apic);
+}
+EXPORT_SYMBOL_GPL(kvm_cancel_apic_virt_timer);
+
 static void apic_set_apic_virt_timer(struct kvm_lapic *apic)
 {
 	struct kvm_timer *ktimer = &apic->lapic_timer;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3c597b670e7e..2ebe294fe0f9 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -251,6 +251,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu);
+void kvm_sync_apic_virt_timer(struct kvm_vcpu *vcpu);
+void kvm_cancel_apic_virt_timer(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6137e5307d0f..77521e37cfc6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3634,6 +3634,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!enable_ept)
 		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
 
+	kvm_sync_apic_virt_timer(vcpu);
+
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
 	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
@@ -3709,6 +3711,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		vmx_start_preemption_timer(vcpu, timer_value);
 	}
 
+	/*
+	 * Disable apic virtual timer for L1 to use sw timer (hr timer) or
+	 * hypervisor timer (VMX preemption timer).
+	 * When L1 timer interrupt occurs during running L2, KVM emulates
+	 * VMExit from L2 to L1.  Not directly injecting the interrupt into L2.
+	 */
+	kvm_cancel_apic_virt_timer(vcpu);
+
 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
 	 * we are no longer running L1, and VMLAUNCH/VMRESUME has not yet
@@ -5181,6 +5191,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* in case we halted in L2 */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
+	/* If apic virtual timer is supported, switch back to it. */
+	kvm_update_apic_virt_timer(vcpu);
+
 	if (likely(!vmx->fail)) {
 		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82e1a0b2a8d2..c625c46658dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8277,6 +8277,9 @@ bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
 		return false;
 
+	if (is_guest_mode(vcpu))
+		return false;
+
 	return cpu_has_vmx_apic_timer_virt() &&
 		/* VMX guest virtual timer supports only TSC deadline mode. */
 		kvm_lapic_lvtt_timer_mode(vcpu) == APIC_LVT_TIMER_TSCDEADLINE &&
@@ -8288,6 +8291,8 @@ bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
 
 void vmx_set_apic_virt_timer(struct kvm_vcpu *vcpu, u16 vector)
 {
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
 	vmcs_write16(GUEST_APIC_TIMER_VECTOR, vector);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE, MSR_TYPE_RW);
 	tertiary_exec_controls_setbit(to_vmx(vcpu), TERTIARY_EXEC_GUEST_APIC_TIMER);
-- 
2.45.2


