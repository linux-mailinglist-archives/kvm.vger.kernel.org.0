Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FF51E8237
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgE2Plu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:41:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59612 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727884AbgE2Pjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zQVDwhQ1YLwV0EQy4DfFQEK18/DKMwM3J2CB4WB3Kw=;
        b=Ldx+JP9f9zbPj03r9PpNz5DTomSFslvmnxrVp5OWbsZKmSeKPntNgf7Tei9Yeycjzs5Mos
        jhowwfRNTOtAf/QfofvBUgbD5hKSrPHvogSgLwOMCEBsuNiwh3zsKpkjyJ45ReKBPgeYue
        5Ig5j/WF4tNLcfV1Ue9LhOTe5DF7MiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-CBjEqmbuP_GAsjZbFMdkZQ-1; Fri, 29 May 2020 11:39:41 -0400
X-MC-Unique: CBjEqmbuP_GAsjZbFMdkZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45D20800D24;
        Fri, 29 May 2020 15:39:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1DE95D9D5;
        Fri, 29 May 2020 15:39:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 09/30] KVM: nSVM: extract load_nested_vmcb_control
Date:   Fri, 29 May 2020 11:39:13 -0400
Message-Id: <20200529153934.11694-10-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When restoring SVM nested state, the control state cache in svm->nested
will have to be filled, but the save state will not have to be moved
into svm->vmcb.  Therefore, pull the code that handles the control area
into a separate function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8e98d5e420a5..fc0c6d1678eb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -228,6 +228,23 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	return true;
 }
 
+static void load_nested_vmcb_control(struct vcpu_svm *svm,
+				     struct vmcb_control_area *control)
+{
+	svm->nested.nested_cr3 = control->nested_cr3;
+
+	svm->nested.vmcb_msrpm = control->msrpm_base_pa & ~0x0fffULL;
+	svm->nested.vmcb_iopm  = control->iopm_base_pa  & ~0x0fffULL;
+
+	/* cache intercepts */
+	svm->nested.intercept_cr         = control->intercept_cr;
+	svm->nested.intercept_dr         = control->intercept_dr;
+	svm->nested.intercept_exceptions = control->intercept_exceptions;
+	svm->nested.intercept            = control->intercept;
+
+	svm->vcpu.arch.tsc_offset += control->tsc_offset;
+}
+
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
@@ -235,15 +252,16 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 		is_intercept(svm, INTERCEPT_VINTR) ||
 		is_intercept(svm, INTERCEPT_IRET);
 
+	svm->nested.vmcb = vmcb_gpa;
 	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
 
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
-		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
+	load_nested_vmcb_control(svm, &nested_vmcb->control);
+
+	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
-	}
 
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
@@ -274,25 +292,15 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
-	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
-	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
-
-	/* cache intercepts */
-	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
-	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
-	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
-	svm->nested.intercept            = nested_vmcb->control.intercept;
-
 	svm_flush_tlb(&svm->vcpu);
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
 
+	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
@@ -313,8 +321,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	 */
 	recalc_intercepts(svm);
 
-	svm->nested.vmcb = vmcb_gpa;
-
 	/*
 	 * If L1 had a pending IRQ/NMI before executing VMRUN,
 	 * which wasn't delivered because it was disallowed (e.g.
-- 
2.26.2


