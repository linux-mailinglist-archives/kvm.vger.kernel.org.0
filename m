Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86C1B840D
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDYHCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32302 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726278AbgDYHC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=CneAOrsq0789icg4fZmRZ78yyM0UfIEH4gc21K3W3eI=;
        b=PQTaKJjXUumMvgeaOdQyf9LOcvhIAEA/W2CTUQcZarD2AU/YPF7aBC+nif0DU5I/GWZNZv
        ieFfo9euXS7qGWQ/ukrx5dmd8Zny3K9h9FtzcZK00YksArap9HTcHXkjeoNCYOWHTOCNBr
        XnZVeEWDopgNSdR8KECSbtRE1tzOLew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-xXnlrmfYOsGyvwk4lPi7ow-1; Sat, 25 Apr 2020 03:02:19 -0400
X-MC-Unique: xXnlrmfYOsGyvwk4lPi7ow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F2C51895951;
        Sat, 25 Apr 2020 07:02:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CA0600E8;
        Sat, 25 Apr 2020 07:02:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 22/22] KVM: x86: Replace late check_nested_events() hack with more precise fix
Date:   Sat, 25 Apr 2020 03:02:15 -0400
Message-Id: <20200425070215.251397-3-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument to interrupt_allowed and nmi_allowed, to checking if
interrupt injection is blocked.  Use the hook to handle the case where
an interrupt arrives between check_nested_events() and the injection
logic.  Drop the retry of check_nested_events() that hack-a-fixed the
same condition.

Blocking injection is also a bit of a hack, e.g. KVM should do exiting
and non-exiting interrupt processing in a single pass, but it's a more
precise hack.  The old comment is also misleading, e.g. KVM_REQ_EVENT is
purely an optimization, setting it on every run loop (which KVM doesn't
do) should not affect functionality, only performance.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-13-sean.j.christopherson@intel.com>
[Extend to SVM, add SMI and NMI.  Even though NMI and SMI cannot come
 asynchronously right now, making the fix generic is easy and removes a
 special case. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/svm/svm.c          | 25 ++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c          | 17 +++++++++++++---
 arch/x86/kvm/x86.c              | 36 +++++++++++----------------------
 4 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index efaddc68a694..7cd68d1d0627 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1139,8 +1139,8 @@ struct kvm_x86_ops {
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
-	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu);
-	bool (*nmi_allowed)(struct kvm_vcpu *vcpu);
+	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	bool (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
@@ -1238,7 +1238,7 @@ struct kvm_x86_ops {
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
-	bool (*smi_allowed)(struct kvm_vcpu *vcpu);
+	bool (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	int (*enable_smi_window)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0bbb2cd24eb7..8f8fc65bfa3e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3080,13 +3080,17 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static bool svm_nmi_allowed(struct kvm_vcpu *vcpu)
+static bool svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
 		return false;
 
-        return !svm_nmi_blocked(vcpu);
+	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
+	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
+		return false;
+
+	return !svm_nmi_blocked(vcpu);
 }
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
@@ -3135,13 +3139,20 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
-static bool svm_interrupt_allowed(struct kvm_vcpu *vcpu)
+static bool svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
 		return false;
 
-        return !svm_interrupt_blocked(vcpu);
+	/*
+	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
+	 * e.g. if the IRQ arrived asynchronously after checking nested events.
+	 */
+	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
+		return false;
+
+	return !svm_interrupt_blocked(vcpu);
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
@@ -3800,12 +3811,16 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu);
 }
 
-static bool svm_smi_allowed(struct kvm_vcpu *vcpu)
+static bool svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
 		return false;
 
+	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
+	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
+		return false;
+
 	return !svm_smi_blocked(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e2ba1f96cd1..3ab6ca6062ce 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4524,11 +4524,15 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 		 GUEST_INTR_STATE_NMI));
 }
 
-static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
+	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
+	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
+		return false;
+
 	return !vmx_nmi_blocked(vcpu);
 }
 
@@ -4542,11 +4546,18 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
-static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
+       /*
+        * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
+        * e.g. if the IRQ arrived asynchronously after checking nested events.
+        */
+	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
+		return false;
+
 	return !vmx_interrupt_blocked(vcpu);
 }
 
@@ -7688,7 +7699,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
-static bool vmx_smi_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 44b9d834621c..856b6fc2c2ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7746,32 +7746,20 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	if (kvm_event_needs_reinjection(vcpu))
 		return 0;
 
-	if (vcpu->arch.smi_pending && kvm_x86_ops.smi_allowed(vcpu)) {
+	if (vcpu->arch.smi_pending &&
+	    kvm_x86_ops.smi_allowed(vcpu, true)) {
 		vcpu->arch.smi_pending = false;
 		++vcpu->arch.smi_count;
 		enter_smm(vcpu);
-	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) {
+	} else if (vcpu->arch.nmi_pending &&
+		   kvm_x86_ops.nmi_allowed(vcpu, true)) {
 		--vcpu->arch.nmi_pending;
 		vcpu->arch.nmi_injected = true;
 		kvm_x86_ops.set_nmi(vcpu);
-	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
-		/*
-		 * Because interrupts can be injected asynchronously, we are
-		 * calling check_nested_events again here to avoid a race condition.
-		 * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
-		 * proposal and current concerns.  Perhaps we should be setting
-		 * KVM_REQ_EVENT only on certain events and not unconditionally?
-		 */
-		if (is_guest_mode(vcpu)) {
-			r = kvm_x86_ops.nested_ops->check_events(vcpu);
-			if (r != 0)
-				return r;
-		}
-		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
-					    false);
-			kvm_x86_ops.set_irq(vcpu);
-		}
+	} else if (kvm_cpu_has_injectable_intr(vcpu) &&
+		   kvm_x86_ops.interrupt_allowed(vcpu, true)) {
+		kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
+		kvm_x86_ops.set_irq(vcpu);
 	}
 
 	return 0;
@@ -10171,12 +10159,12 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
 	    (vcpu->arch.nmi_pending &&
-	     kvm_x86_ops.nmi_allowed(vcpu)))
+	     kvm_x86_ops.nmi_allowed(vcpu, false)))
 		return true;
 
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
 	    (vcpu->arch.smi_pending &&
-	     kvm_x86_ops.smi_allowed(vcpu)))
+	     kvm_x86_ops.smi_allowed(vcpu, false)))
 		return true;
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
@@ -10228,7 +10216,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops.interrupt_allowed(vcpu);
+	return kvm_x86_ops.interrupt_allowed(vcpu, false);
 }
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
@@ -10393,7 +10381,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	 * If interrupts are off we cannot even use an artificial
 	 * halt state.
 	 */
-	return kvm_x86_ops.interrupt_allowed(vcpu);
+	return kvm_arch_interrupt_allowed(vcpu);
 }
 
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
-- 
2.18.2

