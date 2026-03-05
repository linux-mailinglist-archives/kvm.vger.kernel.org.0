Return-Path: <kvm+bounces-72892-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHaSOuTBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72892-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B70B21677E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDCDB3188535
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0203E5ECF;
	Thu,  5 Mar 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSWES8Ww"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918263E5ECA;
	Thu,  5 Mar 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732677; cv=none; b=LC6d5PyaPS/+gF+Xcx+AyWS0UIjrEYdbRnPWhixp18aRCuu2Rc9kuSEYa0+or6fzFD8LumvYpGYKEHiz1iW+jQIlzwlU7O2rZBJ0funviL7/n9ziI+MkDPiwA/ykqL2Cl+40GewMBytaEbA+iHDlWTW0L7vfxmhQu7RLogg9No0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732677; c=relaxed/simple;
	bh=08yovv4kHpvB18sUdnUiqahcaPf2xrtmKjUIG/qy/84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6XUQc0ni/SyB6LmJAaYgxCRDX6az0sjrH2s5Nw4MIvK+uLNCECjoEBfbzcig274uBKQK8/V8WzMBN1aRa9YC2XS4u5akmtUscZPFakEETJID1HGtyH7bO5t62eISSGk2Yk/ZjbEF1UJ/F79+9ZK4Cc9//OCjkV4ySQb7TVO+k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSWES8Ww; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732676; x=1804268676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=08yovv4kHpvB18sUdnUiqahcaPf2xrtmKjUIG/qy/84=;
  b=SSWES8Ww4Clo0LpVrJPeppuqfJ3npcjGJmthzO2k6CkMCnenLl20OUCm
   h66wvXNWgngkeVhPRlxCaIW7X2eOnJBQUnckQ8wIA2pbGJWhNO1Uw82yG
   72SNtya3soYFdK2F+l4U/SIkIlSernoqq+fdSiuK3+HFLHLho1oGDCLZp
   nfmNLyovH545wC8VHGaPd1uupEr10Z6/mbKjzCBMigMLs3IHej0G0r2fG
   5fBFuyl8fGFyNP7Hpj+5sFHv3kfwNACnX/32MS1iWe/fbUE/T6/rQi3Rd
   qGwSPtL3rFndZy3rRx6KmsmOrfLJ5X/skHl7Ixw9osnRnLHZoKgg75jls
   A==;
X-CSE-ConnectionGUID: Letf9nEZT5Cgw+fY5c/9Dw==
X-CSE-MsgGUID: oWzqppd0QGqPP/UIfvgaWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431558"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431558"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
X-CSE-ConnectionGUID: J7zvM55GTB2ZQKjv5n9KSQ==
X-CSE-MsgGUID: 9Cgu3wgjTF2q9alRznE3iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447857"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH v2 06/36] KVM: VMX: Implement the hooks for VMX guest virtual deadline timer
Date: Thu,  5 Mar 2026 09:43:46 -0800
Message-ID: <865b011e272dce6995119cbe41cdbd367bc2d8ad.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B70B21677E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72892-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Implement the hooks for the VMX backend for APIC timer virtualization to
access the related VMCS fields.

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
Move kvm_cpu_apicv_active() before kvm_lapic_lvtt_timer_mode() as
it checks in-kernel apic check.
---
 arch/x86/kvm/lapic.h            |  5 ++
 arch/x86/kvm/vmx/capabilities.h |  6 +++
 arch/x86/kvm/vmx/main.c         |  5 ++
 arch/x86/kvm/vmx/vmx.c          | 83 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h      |  5 ++
 5 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 5e96299c31f7..2f510503f5b3 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -237,6 +237,11 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 	return lapic_in_kernel(vcpu) && test_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
 }
 
+static inline int kvm_lapic_lvtt_timer_mode(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.apic->lapic_timer.timer_mode;
+}
+
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
 bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4e371c93ae16..c5cb098f579b 100644
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
index dbebddf648be..ed20c859def3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -994,6 +994,11 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 4ccb2e42322d..b70641bfecab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2802,7 +2802,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					      & ~TERTIARY_EXEC_GUEST_APIC_TIMER,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
-	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
+	if (!IS_ENABLED(CONFIG_X86_64) ||
+	    !(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
 		_cpu_based_3rd_exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
 
 	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
@@ -8364,6 +8365,86 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
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
+		/* SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY and in-kernel apic */
+		kvm_vcpu_apicv_active(vcpu) &&
+		/* VMX guest virtual timer supports only TSC deadline mode. */
+		kvm_lapic_lvtt_timer_mode(vcpu) == APIC_LVT_TIMER_TSCDEADLINE &&
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
+	 * practical time frame.
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


