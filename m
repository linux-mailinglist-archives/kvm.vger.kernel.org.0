Return-Path: <kvm+bounces-72889-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBZpJYTBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72889-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C52216715
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B262311959C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E7F3E5EF5;
	Thu,  5 Mar 2026 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baGCU8Oy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA53CB2E7;
	Thu,  5 Mar 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732675; cv=none; b=XUlhY46ftzHypNN2qzILw2yVSw9G4hbIykES6HmbKqgoldShiK4UBg0MUvkFwkf4oLlk7aXWCnULRNuzMwOFjqzEssMleIC1f6hBdsOCNouMkwxHjUX7/llAR1DKDDjSV5CgysRCz8lcJ/3H5esm9tgndjwVWe+NL352DI2rSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732675; c=relaxed/simple;
	bh=Y5oFD1dFQoDoxlnAH522ekzm2CBreC7DXdzIfJhmY+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bebHrscZWKs/x/7eWN5lBVDrUDJtG4YlAl9fUwmOih/r5o2q5dg+I9ZyfQZJn73UKKuot3ZqLL2/BZNBaJvJAMZQD0ZtDqXvzKEfKKetsQqifIjHS5hZ/JNSP3A3vW5GjjHTfbOCOZnBounyTzJOWDV0ggua8OON8pNrXHNZzwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=baGCU8Oy; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732674; x=1804268674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y5oFD1dFQoDoxlnAH522ekzm2CBreC7DXdzIfJhmY+c=;
  b=baGCU8OyEXiMXJJY2LsZCuhtwV9oepTLV3n0GQAvzpVnY/KErnp+Zg46
   DcMrYl0VsXbqZLwATIDZCGP60hMb4WxSFlnDyjrDzSgOhrqnHSmhO9AnW
   t1DgJCW75KRq+Tgh/J2P7Dr6IVcCkAIrTGm6kjNaFNDAyqHemlb0jaKeH
   e7QswhZf7+vVD0+FQ4ZVKBZ0IhoCSbQhYu7UZb688o1Qq6pHPL190BQWp
   HHLzR9whwR1jGU299gXX0Mw82UYuzo/yU2qATHVJOyQ0+Ft76RoHuLWoN
   b5hGVSQnhGdDlY6LQqrU9C0Kmvh6zqm7CIFRSaaB0uq/ynbHxOtqiqszj
   A==;
X-CSE-ConnectionGUID: 5J+Dbkn+QR+j1L6iU4CoHA==
X-CSE-MsgGUID: rVll0GyjSiWB1/n9UZMq9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431544"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431544"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:34 -0800
X-CSE-ConnectionGUID: 4xmyJKVBQgKBtXyx18s1MQ==
X-CSE-MsgGUID: 0hcfeRzsR4en7dREdIY3TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447846"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH v2 03/36] KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
Date: Thu,  5 Mar 2026 09:43:43 -0800
Message-ID: <2361bfeb235613efc6d2532970bf3e5dcc93a384.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 24C52216715
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
	TAGGED_FROM(0.00)[bounces-72889-lists,kvm=lfdr.de];
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

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- Add inkernel apic check as apic timer virtualizaion requires it.
---
 arch/x86/kvm/lapic.c | 20 +++++++++++++++++---
 arch/x86/kvm/lapic.h |  9 +++++++++
 arch/x86/kvm/x86.c   |  7 +++++--
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0d91834d972c..ab59722e291e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2089,6 +2089,8 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	kvm_apic_local_deliver(apic, APIC_LVTT);
 	if (apic_lvtt_tscdeadline(apic)) {
 		ktimer->tscdeadline = 0;
+		if (apic->lapic_timer.apic_virt_timer_in_use)
+			kvm_x86_call(set_guest_tsc_deadline_virt)(apic->vcpu, 0);
 	} else if (apic_lvtt_oneshot(apic)) {
 		ktimer->tscdeadline = 0;
 		ktimer->target_expiration = 0;
@@ -2368,8 +2370,10 @@ static void start_sw_timer(struct kvm_lapic *apic)
 	struct kvm_timer *ktimer = &apic->lapic_timer;
 
 	WARN_ON(preemptible());
-	if (apic->lapic_timer.hv_timer_in_use)
+	if (apic->lapic_timer.hv_timer_in_use) {
 		cancel_hv_timer(apic);
+		trace_kvm_hv_timer_state(apic->vcpu->vcpu_id, false);
+	}
 	if (!apic_lvtt_period(apic) && atomic_read(&ktimer->pending))
 		return;
 
@@ -2377,7 +2381,6 @@ static void start_sw_timer(struct kvm_lapic *apic)
 		start_sw_period(apic);
 	else if (apic_lvtt_tscdeadline(apic))
 		start_sw_tscdeadline(apic);
-	trace_kvm_hv_timer_state(apic->vcpu->vcpu_id, false);
 }
 
 static void restart_apic_timer(struct kvm_lapic *apic)
@@ -2422,13 +2425,24 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
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
index ba1090f9a3c8..5e96299c31f7 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -250,10 +250,19 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_lapic_switch_to_apic_virt_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu))
+		return false;
+
+	return vcpu->arch.apic->lapic_timer.apic_virt_timer_in_use;
+}
+
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 879cdeb6adde..1922e8699101 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11661,7 +11661,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 /* Called within kvm->srcu read side.  */
 static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {
-	bool hv_timer;
+	bool hv_timer, virt_timer;
 
 	if (!kvm_arch_vcpu_runnable(vcpu)) {
 		/*
@@ -11672,7 +11672,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 		 * timer before blocking.
 		 */
 		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
-		if (hv_timer)
+		virt_timer = kvm_lapic_apic_virt_timer_in_use(vcpu);
+		if (hv_timer || virt_timer)
 			kvm_lapic_switch_to_sw_timer(vcpu);
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
@@ -11684,6 +11685,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
+		else if (virt_timer)
+			kvm_lapic_switch_to_apic_virt_timer(vcpu);
 
 		/*
 		 * If the vCPU is not runnable, a signal or another host event
-- 
2.45.2


