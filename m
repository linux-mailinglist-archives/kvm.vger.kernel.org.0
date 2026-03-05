Return-Path: <kvm+bounces-72890-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDR+F6vBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72890-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:47:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 050E4216750
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 484B7313CE10
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561E63E5591;
	Thu,  5 Mar 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVGZPlpW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B53D34AA;
	Thu,  5 Mar 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732676; cv=none; b=VT7crFUu3dpXFPMYV1T7XBOLQ+udOmKnP/pBm2TAO1kPVRorfoMNW5tUAwstPxTShLpYsa8FcA0BdbYQ1H/ZxF0QlqZRWi1WYoEzPtAV55WIz4j5lv83rHqFgEaJhXP8PH5qQyMuxq4bRBXt3t8f0mv/wtib0YrGLhTYLYsjhPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732676; c=relaxed/simple;
	bh=AndZdF2dnr4dl7StGRCBgKDGf0RD400+CZHrbT41vT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrD+FiCbqeT8pTxb7EslfhOLHd3vJrKUiREE+xEGdK5bR1BdW+Y5pikDAq50z38DrJqYrKe8IvHQxzD0GaBFzubY+OCPjw27tb9Qr9jeStmT9Hf4beKfGywoNvD9MnfdWoXPMNb0oecBNuiihGvbZ43Ap70/bh8FFdXtCh+AHsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVGZPlpW; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732674; x=1804268674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AndZdF2dnr4dl7StGRCBgKDGf0RD400+CZHrbT41vT0=;
  b=fVGZPlpW6Em6DLCUr23RMBr6rwtu12WsLqUK9OqFnEwDOKwEvMqy2z89
   ERaD1tOZJxrJvLR3Dp8hEl7i2ododS3FrioID1VhH/hnI0DtwGrfo6Aar
   kMrrt6WrHvGVXnx+toXHmehia2s2Ht17OjwEeZSaK8gMyRQjkfsbDCZTQ
   g/gIrOFhnA0FcHMl9KaPZZ1EgIVPt+WLB7831zk8l76Q9AOU7194mkcEn
   iLVxLj/YadZTV5RA991uUJs+FC/OAIxDISjg4wDdTBDB+iBYL3MRb7kap
   pMbohbeO63Y6v3JJz96WkIRMEmgdrHs8IfR7ki7na72SBrB8zNWHIr/zr
   g==;
X-CSE-ConnectionGUID: CXu/IdQxTlWCaxAW0Qfqiw==
X-CSE-MsgGUID: R2Bo+4odRoqKjC4wzMkqmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798204"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798204"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:33 -0800
X-CSE-ConnectionGUID: 28hV1UAVTSy2MCJA/ScLuA==
X-CSE-MsgGUID: di7V6GA2RA6PA3/7jUZHTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527245"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH v2 02/36] KVM: x86: Implement APIC virt timer helpers with callbacks
Date: Thu,  5 Mar 2026 09:43:42 -0800
Message-ID: <727502c8f79850fae6a8a476a624e5902861db39.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 050E4216750
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
	TAGGED_FROM(0.00)[bounces-72890-lists,kvm=lfdr.de];
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

Add an additional APIC emulation mode for APIC timer virtualization.  When
the guest programs the local APIC timer mode, switch to this new emulation
mode using the newly added hooks when APIC timer virtualization is
available.

Add five x86 KVM callbacks for APIC timer virtualization.  These callbacks
are analogous to those used for the preemption timer and will be invoked by
kvm/lapic.  These helpers start/stop the timer once the APIC virt timer
feature is enabled and the guest sets the MSR_IA32_TSC_DEADLINE.  Upon
updating the TSC deadline mode in the APIC_LVTT register, KVM's LAPIC will
initiate the APIC virt timer instead of the preemption timer.

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  5 ++
 arch/x86/include/asm/kvm_host.h    |  6 +++
 arch/x86/kvm/lapic.c               | 82 +++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h               |  1 +
 4 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..09f664aa72c1 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -118,6 +118,11 @@ KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
+KVM_X86_OP_OPTIONAL(can_use_apic_virt_timer)
+KVM_X86_OP_OPTIONAL(set_apic_virt_timer)
+KVM_X86_OP_OPTIONAL(cancel_apic_virt_timer)
+KVM_X86_OP_OPTIONAL(set_guest_tsc_deadline_virt)
+KVM_X86_OP_OPTIONAL(get_guest_tsc_deadline_virt)
 KVM_X86_OP(setup_mce)
 #ifdef CONFIG_KVM_SMM
 KVM_X86_OP(smi_allowed)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c94556fefb75..345ea21b45f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1934,6 +1934,12 @@ struct kvm_x86_ops {
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
 	void (*cancel_hv_timer)(struct kvm_vcpu *vcpu);
+	bool (*can_use_apic_virt_timer)(struct kvm_vcpu *vcpu);
+	void (*set_apic_virt_timer)(struct kvm_vcpu *vcpu, u16 vector);
+	void (*cancel_apic_virt_timer)(struct kvm_vcpu *vcpu);
+	void (*set_guest_tsc_deadline_virt)(struct kvm_vcpu *vcpu,
+					    u64 tscdeadline);
+	u64 (*get_guest_tsc_deadline_virt)(struct kvm_vcpu *vcpu);
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9381c58d4c85..0d91834d972c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -188,7 +188,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
 	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
-		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
+		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm)) &&
+		!vcpu->arch.apic->lapic_timer.apic_virt_timer_in_use;
 }
 
 static bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
@@ -1864,17 +1865,82 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
 }
 
 static void cancel_hv_timer(struct kvm_lapic *apic);
+static void cancel_apic_virt_timer(struct kvm_lapic *apic);
 
-static void cancel_apic_timer(struct kvm_lapic *apic)
+static void __cancel_apic_timer(struct kvm_lapic *apic)
 {
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	preempt_disable();
 	if (apic->lapic_timer.hv_timer_in_use)
 		cancel_hv_timer(apic);
+	else if (apic->lapic_timer.apic_virt_timer_in_use)
+		cancel_apic_virt_timer(apic);
 	preempt_enable();
+}
+
+static void cancel_apic_timer(struct kvm_lapic *apic)
+{
+	__cancel_apic_timer(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 }
 
+static void start_apic_timer(struct kvm_lapic *apic);
+
+static void cancel_apic_virt_timer(struct kvm_lapic *apic)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+
+	apic->lapic_timer.tscdeadline = kvm_x86_call(get_guest_tsc_deadline_virt)(vcpu);
+	kvm_x86_call(set_guest_tsc_deadline_virt)(vcpu, 0);
+
+	kvm_x86_call(cancel_apic_virt_timer)(vcpu);
+	apic->lapic_timer.apic_virt_timer_in_use = false;
+}
+
+static void apic_cancel_apic_virt_timer(struct kvm_lapic *apic)
+{
+	if (!apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	cancel_apic_virt_timer(apic);
+	start_apic_timer(apic);
+}
+
+static void apic_set_apic_virt_timer(struct kvm_lapic *apic)
+{
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	u8 vector;
+	u32 reg;
+
+	if (apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	vector = reg & APIC_VECTOR_MASK;
+
+	__cancel_apic_timer(apic);
+	kvm_x86_call(set_apic_virt_timer)(vcpu, vector);
+	kvm_x86_call(set_guest_tsc_deadline_virt)(vcpu, ktimer->tscdeadline);
+	ktimer->apic_virt_timer_in_use = true;
+}
+
+static bool kvm_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops.can_use_apic_virt_timer &&
+		lapic_in_kernel(vcpu) &&
+		apic_lvt_enabled(vcpu->arch.apic, APIC_LVTT) &&
+		kvm_x86_call(can_use_apic_virt_timer)(vcpu);
+}
+
+static void apic_update_apic_virt_timer(struct kvm_lapic *apic)
+{
+	if (kvm_can_use_apic_virt_timer(apic->vcpu))
+		apic_set_apic_virt_timer(apic);
+	else
+		apic_cancel_apic_virt_timer(apic);
+}
+
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
 	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
@@ -1887,10 +1953,19 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
+
+			if (apic->lapic_timer.apic_virt_timer_in_use)
+				kvm_x86_call(set_guest_tsc_deadline_virt)(apic->vcpu, 0);
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
 	}
+
+	/*
+	 * Update on not only timer mode change, but also mask change
+	 * for the case of timer_mode = TSCDEADLINE, mask = 1.
+	 */
+	apic_update_apic_virt_timer(apic);
 }
 
 /*
@@ -2312,6 +2387,9 @@ static void restart_apic_timer(struct kvm_lapic *apic)
 	if (!apic_lvtt_period(apic) && atomic_read(&apic->lapic_timer.pending))
 		goto out;
 
+	if (apic->lapic_timer.apic_virt_timer_in_use)
+		goto out;
+
 	if (!start_hv_timer(apic))
 		start_sw_timer(apic);
 out:
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 274885af4ebc..ba1090f9a3c8 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -57,6 +57,7 @@ struct kvm_timer {
 	u32 timer_advance_ns;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
+	bool apic_virt_timer_in_use;
 };
 
 struct kvm_lapic {
-- 
2.45.2


