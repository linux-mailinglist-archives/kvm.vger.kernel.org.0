Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901411B7CB0
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgDXRZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:25:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728818AbgDXRYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 13:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587749078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sbDmvfNcgt+2bJjYAeYhcGP2QN7WrEsbBIbocEGJVpE=;
        b=f3Phw2PjBpKje/S7W5FI9eZZLLMmFHe2PPGojSdMOkrECi6k6LxpH7aWitaN4GrRiqyFN7
        w+xzeSRENUc5vlWzMln9LF4X7VLRWQ8K5S5NTvv/11fdmGnGFpzDxfxAC2smLvl1h5emP1
        jb21arUdm2MJ2XTWTavy84ExxJBUQ0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-kUGgYStOOqaGGw-_lhTdTA-1; Fri, 24 Apr 2020 13:24:35 -0400
X-MC-Unique: kUGgYStOOqaGGw-_lhTdTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D30C38BE4B9;
        Fri, 24 Apr 2020 17:24:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E99851FDE1;
        Fri, 24 Apr 2020 17:24:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 04/22] KVM: SVM: Implement check_nested_events for NMI
Date:   Fri, 24 Apr 2020 13:23:58 -0400
Message-Id: <20200424172416.243870-5-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

Migrate nested guest NMI intercept processing
to new check_nested_events.

Signed-off-by: Cathy Avery <cavery@redhat.com>
Message-Id: <20200414201107.22952-2-cavery@redhat.com>
[Reorder clauses as NMIs have higher priority than IRQs; inject
 immediate vmexit as is now done for IRQ vmexits. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  6 ++----
 arch/x86/kvm/svm/svm.h    | 15 ---------------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 266fde240493..c3650efd2e89 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -776,6 +776,20 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	return vmexit;
 }
 
+static bool nested_exit_on_nmi(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
+}
+
+static void nested_svm_nmi(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
+	svm->vmcb->control.exit_info_1 = 0;
+	svm->vmcb->control.exit_info_2 = 0;
+
+	nested_svm_vmexit(svm);
+}
+
 static void nested_svm_intr(struct vcpu_svm *svm)
 {
 	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
@@ -798,6 +812,13 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required ||
 		svm->nested.nested_run_pending;
 
+	if (vcpu->arch.nmi_pending && nested_exit_on_nmi(svm)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_svm_nmi(svm);
+		return 0;
+	}
+
 	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(svm)) {
 		if (block_nested_events)
 			return -EBUSY;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 77440b5953e3..8e732eb0b5c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3067,9 +3067,10 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 	int ret;
+
 	ret = !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 	      !(svm->vcpu.arch.hflags & HF_NMI_MASK);
-	ret = ret && gif_set(svm) && nested_svm_nmi(svm);
+	ret = ret && gif_set(svm);
 
 	return ret;
 }
@@ -3147,9 +3148,6 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 		return; /* STGI will cause a vm exit */
 	}
 
-	if (svm->nested.exit_required)
-		return; /* we're not going to run the guest yet */
-
 	/*
 	 * Something prevents NMI from been injected. Single step over possible
 	 * problem (IRET or exception injection or interrupt shadow)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 435f3328c99c..a2bc33aadb67 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -373,21 +373,6 @@ void disable_nmi_singlestep(struct vcpu_svm *svm);
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
 #define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
 
-/* This function returns true if it is save to enable the nmi window */
-static inline bool nested_svm_nmi(struct vcpu_svm *svm)
-{
-	if (!is_guest_mode(&svm->vcpu))
-		return true;
-
-	if (!(svm->nested.intercept & (1ULL << INTERCEPT_NMI)))
-		return true;
-
-	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
-	svm->nested.exit_required = true;
-
-	return false;
-}
-
 static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
 	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
-- 
2.18.2


