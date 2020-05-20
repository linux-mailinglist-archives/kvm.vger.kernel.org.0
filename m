Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B41DBB44
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgETRXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728101AbgETRWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=jrWjpTjo0hJ0e6dSEiSVY2FHCSjGptHFhRGJP2ZKJJk=;
        b=TqlxQ1g2eoRUnDFizmsN6gaC7izqFJAI6bjxC3BnahaXrKvGX0sZjcYvmH9he9WDfkyx8+
        PIbBq2N6iocMumtoQQLcHiRuBK46k4c9M9hXEe9l1VZGf/1hr4amBTeVd2zguJFSgLwBR5
        BxP+InJojaODcvSyB/qmzm+0eE8kNIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-_SsBqXp-N7eYy7Xf57Uqig-1; Wed, 20 May 2020 13:22:11 -0400
X-MC-Unique: _SsBqXp-N7eYy7Xf57Uqig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C578730A2;
        Wed, 20 May 2020 17:22:10 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF5E79C31;
        Wed, 20 May 2020 17:22:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 19/24] KVM: nSVM: extract svm_set_gif
Date:   Wed, 20 May 2020 13:21:40 -0400
Message-Id: <20200520172145.23284-20-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the code that is needed to implement CLGI and STGI,
so that we can run it from VMRUN and vmexit (and in the future,
KVM_SET_NESTED_STATE).  Skip the request for KVM_REQ_EVENT unless needed,
subsuming the evaluate_pending_interrupts optimization that is found
in enter_svm_guest_mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/irq.c        |  1 +
 arch/x86/kvm/svm/nested.c | 22 ++------------------
 arch/x86/kvm/svm/svm.c    | 44 +++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h    |  1 +
 4 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 54f7ea68083b..99d118ffc67d 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -83,6 +83,7 @@ int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
 
 	return kvm_apic_has_interrupt(v) != -1; /* LAPIC */
 }
+EXPORT_SYMBOL_GPL(kvm_cpu_has_injectable_intr);
 
 /*
  * check if there is pending interrupt without
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3e37410d0b94..a4a9516ff8b5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -312,30 +312,12 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
-	bool evaluate_pending_interrupts =
-		is_intercept(svm, INTERCEPT_VINTR) ||
-		is_intercept(svm, INTERCEPT_IRET);
-
 	svm->nested.vmcb = vmcb_gpa;
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
 	nested_prepare_vmcb_control(svm);
 
-	/*
-	 * If L1 had a pending IRQ/NMI before executing VMRUN,
-	 * which wasn't delivered because it was disallowed (e.g.
-	 * interrupts disabled), L0 needs to evaluate if this pending
-	 * event should cause an exit from L2 to L1 or be delivered
-	 * directly to L2.
-	 *
-	 * Usually this would be handled by the processor noticing an
-	 * IRQ/NMI window request.  However, VMRUN can unblock interrupts
-	 * by implicitly setting GIF, so force L0 to perform pending event
-	 * evaluation by requesting a KVM_REQ_EVENT.
-	 */
-	enable_gif(svm);
-	if (unlikely(evaluate_pending_interrupts))
-		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	svm_set_gif(svm, true);
 }
 
 int nested_svm_vmrun(struct vcpu_svm *svm)
@@ -478,7 +460,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	/* Give the current vmcb to the guest */
-	disable_gif(svm);
+	svm_set_gif(svm, false);
 
 	nested_vmcb->save.es     = vmcb->save.es;
 	nested_vmcb->save.cs     = vmcb->save.cs;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 09b345892fc9..d8187d25fe04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1977,6 +1977,30 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	return nested_svm_vmrun(svm);
 }
 
+void svm_set_gif(struct vcpu_svm *svm, bool value)
+{
+	if (value) {
+		/*
+		 * If VGIF is enabled, the STGI intercept is only added to
+		 * detect the opening of the SMI/NMI window; remove it now.
+		 */
+		if (vgif_enabled(svm))
+			clr_intercept(svm, INTERCEPT_STGI);
+
+		enable_gif(svm);
+		if (svm->vcpu.arch.smi_pending ||
+		    svm->vcpu.arch.nmi_pending ||
+		    kvm_cpu_has_injectable_intr(&svm->vcpu))
+			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	} else {
+		disable_gif(svm);
+
+		/* After a CLGI no interrupts should come */
+		if (!kvm_vcpu_apicv_active(&svm->vcpu))
+			svm_clear_vintr(svm);
+	}
+}
+
 static int stgi_interception(struct vcpu_svm *svm)
 {
 	int ret;
@@ -1984,18 +2008,8 @@ static int stgi_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	/*
-	 * If VGIF is enabled, the STGI intercept is only added to
-	 * detect the opening of the SMI/NMI window; remove it now.
-	 */
-	if (vgif_enabled(svm))
-		clr_intercept(svm, INTERCEPT_STGI);
-
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
-
-	enable_gif(svm);
-
+	svm_set_gif(svm, true);
 	return ret;
 }
 
@@ -2007,13 +2021,7 @@ static int clgi_interception(struct vcpu_svm *svm)
 		return 1;
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-
-	disable_gif(svm);
-
-	/* After a CLGI no interrupts should come */
-	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		svm_clear_vintr(svm);
-
+	svm_set_gif(svm, false);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4d57270cac3f..6733f9036499 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -357,6 +357,7 @@ void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
+void svm_set_gif(struct vcpu_svm *svm, bool value);
 
 /* nested.c */
 
-- 
2.18.2


