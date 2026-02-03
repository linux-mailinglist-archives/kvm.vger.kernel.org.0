Return-Path: <kvm+bounces-70037-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCVHGfQ7gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70037-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:18:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 862A7DD735
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3FA843010901
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF4D3D2FFC;
	Tue,  3 Feb 2026 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aaqWCCJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C2236681F;
	Tue,  3 Feb 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142656; cv=none; b=NYEjBjM3ZgYZtUFMzep0VBmxycY9cDf5rmiE08ALqpf5M9sqMTzYOFb1i9OsGDoCxKrdpCdxPNrYW4qGa8tddnZKgCq168wetxze8J2DpgzxdAxmVPMbXPitbN0yRw2/O+9LhY/i3HfOkr1/UlCAPFxB5LNjnWl73GrRpjFvQ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142656; c=relaxed/simple;
	bh=aCKhLSC9cSpDGKMJzFvx5enOYQp21sjnziHx6Q4aa+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irVg8uFyzohOgVTNVx+IYeAFOcCzNqBaB9gGrrdqK86KUfLeKZhfV5cw7JEQxtynCTUl1wPkalrcNsQLjudM6xgSQt05b2Btj5AAWj3ixW4Z935PWWyhL6BDVBYYgC4zXGLPZdl3WX+OuCAdwv/h/FmbYbAj43zG9sco2FraJWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aaqWCCJ4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142653; x=1801678653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aCKhLSC9cSpDGKMJzFvx5enOYQp21sjnziHx6Q4aa+4=;
  b=aaqWCCJ4edrB+Yn2kFBFdUFGwxOSVzf7No8GxvmUN9JOAHaNVHoQrRG1
   W1PnM92mtk8Kqkcy9yxXt53dSYfmuqKPmBqM2FpjN+NG/CLNSpO18wO8+
   WrLfzdhhI5kCovQkG2OnO47EvDBOhXtT2fZqG5CKzRMm86pkTrKIrusM/
   VGRHYN0p7l+q76jOjpsVenZ2rZP+vHyci9ABsVWvJhMuTYRWXOAgYNEmC
   +I0Xjy6Z5QsT8Repdpw8yLr+5+cSPvS+4J7mygmg7G6H5sQZcHj/HW+7E
   5bKxlcayzz5jHdvhVUVAFcI+CTCTLKHdkFEg/2mM/5ZuyRJ4bnn9j5Y2U
   Q==;
X-CSE-ConnectionGUID: oGljXx1KQBmZ2vDHcyTaYQ==
X-CSE-MsgGUID: XO+94rEHTfangXGpNUeamw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433166"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433166"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:32 -0800
X-CSE-ConnectionGUID: s2E7sISEREuaqrGICI+fUg==
X-CSE-MsgGUID: OT/LvNxWQHmvYHzo0fXkSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727474"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH 03/32] KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
Date: Tue,  3 Feb 2026 10:16:46 -0800
Message-ID: <0ff98f7888b5ff26d5a2c546587dcb52234aafe9.1770116050.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70037-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 862A7DD735
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Switch to use software timer when a vCPU is blocked by instructions such as
HLT similar to the hv timer case.

The guest deadline shadow field is read to obtain the guest_tsc value,
which is then used to program an hrtimer for the duration of the vCPU
block. Upon completion of the block, if the LAPIC timer has pending
interrupts, the LAPIC timer is transitioned to APIC virt timer mode to
continue providing timer services to the guest.
Set the guest TSC deadline to 0 when injecting a timer interrupt, as the
TSC deadline is cleared to zero when a timer interrupt is injected.  Do so
when injecting a timer interrupt to the vCPU.

Co-developed-by: Yang Zhong <yang.zhong@linux.intel.com>
Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c | 20 +++++++++++++++++---
 arch/x86/kvm/lapic.h |  6 ++++++
 arch/x86/kvm/x86.c   |  7 +++++--
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b942210c6a25..ee15d3bf5ef9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2041,6 +2041,8 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	kvm_apic_local_deliver(apic, APIC_LVTT);
 	if (apic_lvtt_tscdeadline(apic)) {
 		ktimer->tscdeadline = 0;
+		if (apic->lapic_timer.apic_virt_timer_in_use)
+			kvm_x86_call(set_guest_tsc_deadline_virt)(apic->vcpu, 0);
 	} else if (apic_lvtt_oneshot(apic)) {
 		ktimer->tscdeadline = 0;
 		ktimer->target_expiration = 0;
@@ -2320,8 +2322,10 @@ static void start_sw_timer(struct kvm_lapic *apic)
 	struct kvm_timer *ktimer = &apic->lapic_timer;
 
 	WARN_ON(preemptible());
-	if (apic->lapic_timer.hv_timer_in_use)
+	if (apic->lapic_timer.hv_timer_in_use) {
 		cancel_hv_timer(apic);
+		trace_kvm_hv_timer_state(apic->vcpu->vcpu_id, false);
+	}
 	if (!apic_lvtt_period(apic) && atomic_read(&ktimer->pending))
 		return;
 
@@ -2329,7 +2333,6 @@ static void start_sw_timer(struct kvm_lapic *apic)
 		start_sw_period(apic);
 	else if (apic_lvtt_tscdeadline(apic))
 		start_sw_tscdeadline(apic);
-	trace_kvm_hv_timer_state(apic->vcpu->vcpu_id, false);
 }
 
 static void restart_apic_timer(struct kvm_lapic *apic)
@@ -2374,13 +2377,24 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 	restart_apic_timer(vcpu->arch.apic);
 }
 
+void kvm_lapic_switch_to_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	hrtimer_cancel(&vcpu->arch.apic->lapic_timer.timer);
+}
+
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	preempt_disable();
+
+	if (apic->lapic_timer.apic_virt_timer_in_use)
+		apic->lapic_timer.tscdeadline =
+			kvm_x86_call(get_guest_tsc_deadline_virt)(vcpu);
+
 	/* Possibly the TSC deadline timer is not enabled yet */
-	if (apic->lapic_timer.hv_timer_in_use)
+	if (apic->lapic_timer.hv_timer_in_use ||
+	    apic->lapic_timer.apic_virt_timer_in_use)
 		start_sw_timer(apic);
 	preempt_enable();
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 42fbb66f1e4e..67172fef1b5b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -241,10 +241,16 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_lapic_switch_to_apic_virt_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.apic->lapic_timer.apic_virt_timer_in_use;
+}
+
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63afdb6bb078..2a72709aeb03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11563,7 +11563,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 /* Called within kvm->srcu read side.  */
 static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {
-	bool hv_timer;
+	bool hv_timer, virt_timer;
 
 	if (!kvm_arch_vcpu_runnable(vcpu)) {
 		/*
@@ -11574,7 +11574,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 		 * timer before blocking.
 		 */
 		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
-		if (hv_timer)
+		virt_timer = kvm_lapic_apic_virt_timer_in_use(vcpu);
+		if (hv_timer || virt_timer)
 			kvm_lapic_switch_to_sw_timer(vcpu);
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
@@ -11586,6 +11587,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
+		else if (virt_timer)
+			kvm_lapic_switch_to_apic_virt_timer(vcpu);
 
 		/*
 		 * If the vCPU is not runnable, a signal or another host event
-- 
2.45.2


