Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905FB2EBCBD
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbhAFKvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:51:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbhAFKvq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:51:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVVaAXkGgO4GgKOX11xqpYlF88SD+dCjinIgZUO1i3Y=;
        b=YuKI3QUdUHL9MCirEIPZT4ExPrzAsDPneK5BCClUXvbjnxo/O7BC5GsC72V1kFs5/1d5gq
        mtAKEPKCuY5f1RP8trMbP/eUhgq8QV+hD3Cf0LzRaMjALDZCKELEfyJgpzq88UkueHfD+Y
        /rTXzSZq3aa3tJz3ykaWbOxqHC8IjDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-dv_TR8n5OKudYvjPd54RuA-1; Wed, 06 Jan 2021 05:50:14 -0500
X-MC-Unique: dv_TR8n5OKudYvjPd54RuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 106E21005504;
        Wed,  6 Jan 2021 10:50:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8942537A0;
        Wed,  6 Jan 2021 10:50:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/6] KVM: SVM: create svm_process_injected_event
Date:   Wed,  6 Jan 2021 12:49:56 +0200
Message-Id: <20210106105001.449974-2-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the logic that is dealing with parsing of an injected event to a
separate function.

This will be used in the next patch to deal with the events that L1 wants to
inject to L2 in a way that survives migration.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 58 ++++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h |  4 +++
 2 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13fe..01f1655d9e6f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3584,38 +3584,21 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
 }
 
-static void svm_complete_interrupts(struct vcpu_svm *svm)
+void svm_process_injected_event(struct vcpu_svm *svm,
+				u32 event,
+				u32 event_err_code)
 {
-	u8 vector;
-	int type;
-	u32 exitintinfo = svm->vmcb->control.exit_int_info;
-	unsigned int3_injected = svm->int3_injected;
+	u8 vector = event & SVM_EXITINTINFO_VEC_MASK;
+	int type = event & SVM_EXITINTINFO_TYPE_MASK;
 
+	unsigned int int3_injected = svm->int3_injected;
 	svm->int3_injected = 0;
 
-	/*
-	 * If we've made progress since setting HF_IRET_MASK, we've
-	 * executed an IRET and can allow NMI injection.
-	 */
-	if ((svm->vcpu.arch.hflags & HF_IRET_MASK) &&
-	    (sev_es_guest(svm->vcpu.kvm) ||
-	     kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip)) {
-		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
-		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
-	}
-
-	svm->vcpu.arch.nmi_injected = false;
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
-
-	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
+	if (!(event & SVM_EXITINTINFO_VALID))
 		return;
 
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
-	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
-
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
 		svm->vcpu.arch.nmi_injected = true;
@@ -3640,7 +3623,7 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 					      int3_injected);
 			break;
 		}
-		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
+		if (event & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(&svm->vcpu, vector, err);
 
@@ -3653,6 +3636,31 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	default:
 		break;
 	}
+
+}
+
+static void svm_complete_interrupts(struct vcpu_svm *svm)
+{
+
+	/*
+	 * If we've made progress since setting HF_IRET_MASK, we've
+	 * executed an IRET and can allow NMI injection.
+	 */
+	if ((svm->vcpu.arch.hflags & HF_IRET_MASK) &&
+	    (sev_es_guest(svm->vcpu.kvm) ||
+	     kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip)) {
+		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
+		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	}
+
+	svm->vcpu.arch.nmi_injected = false;
+	kvm_clear_exception_queue(&svm->vcpu);
+	kvm_clear_interrupt_queue(&svm->vcpu);
+
+	svm_process_injected_event(svm,
+				   svm->vmcb->control.exit_int_info,
+				   svm->vmcb->control.exit_int_info_err);
+
 }
 
 static void svm_cancel_injection(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5431e6335e2e8..b5587650181f2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -420,6 +420,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
+
+void svm_process_injected_event(struct vcpu_svm *svm, u32 event,
+				u32 event_err_code);
+
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
-- 
2.26.2

