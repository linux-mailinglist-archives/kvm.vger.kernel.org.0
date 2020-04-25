Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1C1B8405
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDYHCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726307AbgDYHCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ASlviBxFLp+Z3Ulj6MCrDwXnWDa6GkiqlDL/SqVZeZg=;
        b=VHpGcwkVD7qu0fqoSIb5ZcEuRgZfeazIWuYLkAw4PWS+iYtnpY3tawvK6r02kyGhoKQjqw
        HBCOamNOfsq7mn+KEPVWL6m41psvNljI6gDULgDgFNP7a0vt/tdI3Rhc3+7w/vHkWQMTZe
        bP8ay/HK7Lk2DLZmYkkZXqBXSh6TqcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-K5LGcn-VOBe4kFRGf0a0lQ-1; Sat, 25 Apr 2020 03:02:03 -0400
X-MC-Unique: K5LGcn-VOBe4kFRGf0a0lQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7515107ACF5;
        Sat, 25 Apr 2020 07:02:01 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27F955D9C5;
        Sat, 25 Apr 2020 07:02:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 17/22] KVM: nSVM: Report interrupts as allowed when in L2 and exit-on-interrupt is set
Date:   Sat, 25 Apr 2020 03:01:49 -0400
Message-Id: <20200425070154.251290-8-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report interrupts as allowed when the vCPU is in L2 and L2 is being run with
exit-on-interrupts enabled and EFLAGS.IF=1 (either on the host or on the guest
according to VINTR).  Interrupts are always unblocked from L1's perspective
in this case.

While moving nested_exit_on_intr to svm.h, use INTERCEPT_INTR properly instead
of assuming it's zero (which it is of course).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  5 -----
 arch/x86/kvm/svm/svm.c    | 23 +++++++++++++++++------
 arch/x86/kvm/svm/svm.h    |  5 +++++
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 226d5a0d677b..a7a3d695405e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -805,11 +805,6 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 }
 
-static bool nested_exit_on_intr(struct vcpu_svm *svm)
-{
-	return (svm->nested.intercept & 1ULL);
-}
-
 static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e284b62d384..0bbb2cd24eb7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3114,14 +3114,25 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
-	if (!gif_set(svm) ||
-	     (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK))
+	if (!gif_set(svm))
 		return true;
 
-	if (is_guest_mode(vcpu) && (svm->vcpu.arch.hflags & HF_VINTR_MASK))
-		return !(svm->vcpu.arch.hflags & HF_HIF_MASK);
-	else
-		return !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF);
+	if (is_guest_mode(vcpu)) {
+		/* As long as interrupts are being delivered...  */
+		if ((svm->vcpu.arch.hflags & HF_VINTR_MASK)
+		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
+		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
+			return true;
+
+		/* ... vmexits aren't blocked by the interrupt shadow  */
+		if (nested_exit_on_intr(svm))
+			return false;
+	} else {
+		if (!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
+			return true;
+	}
+
+	return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
 static bool svm_interrupt_allowed(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f6d604b72a4c..5cc559ab862d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -386,6 +386,11 @@ static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
 	return (svm->nested.intercept & (1ULL << INTERCEPT_SMI));
 }
 
+static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & (1ULL << INTERCEPT_INTR));
+}
+
 static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 {
 	return (svm->nested.intercept & (1ULL << INTERCEPT_NMI));
-- 
2.18.2


