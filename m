Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4628A1DBB36
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgETRWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728028AbgETRWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=k7Sc93Zn4QsH2GU65eODDtauPatAqQ0wxlzFfaptHRM=;
        b=TsK2xj19gTApN5kOa663XZduTN30p5L3LNMyx1Qu4gMuMGn5Ip1wZ40kiPkBMoKtfK51Jw
        1OGD/QMyZ0n7J+FoqPO6l71puHoLYSDpGlC9bTBgJPEMA6hm4yKVuHMBNvteLS+BpioX1h
        arm3hv6sxW0Y3V2VrYTl0rUbxd5INZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-qj4_7bDCOsuxnDdb_ElROQ-1; Wed, 20 May 2020 13:22:07 -0400
X-MC-Unique: qj4_7bDCOsuxnDdb_ElROQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43A061855A21;
        Wed, 20 May 2020 17:21:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75B2482A33;
        Wed, 20 May 2020 17:21:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 08/24] KVM: nSVM: extract preparation of VMCB for nested run
Date:   Wed, 20 May 2020 13:21:29 -0400
Message-Id: <20200520172145.23284-9-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out filling svm->vmcb.save and svm->vmcb.control before VMRUN.
Only the latter will be useful when restoring nested SVM state.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 52 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b1d0d0519664..4f81c2196bf6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -245,24 +245,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 	svm->vcpu.arch.tsc_offset += control->tsc_offset;
 }
 
-void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb)
+static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
-	bool evaluate_pending_interrupts =
-		is_intercept(svm, INTERCEPT_VINTR) ||
-		is_intercept(svm, INTERCEPT_IRET);
-
-	svm->nested.vmcb = vmcb_gpa;
-	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
-		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
-
-	load_nested_vmcb_control(svm, &nested_vmcb->control);
-
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
-		nested_svm_init_mmu_context(&svm->vcpu);
-
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -280,9 +264,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	} else
 		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
-	/* Guest paging mode is active - reset mmu */
-	kvm_mmu_reset_context(&svm->vcpu);
-
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
 	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
@@ -295,6 +276,15 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
 	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+}
+
+static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+{
+	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+		nested_svm_init_mmu_context(&svm->vcpu);
+
+	/* Guest paging mode is active - reset mmu */
+	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
@@ -325,6 +315,26 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	 */
 	recalc_intercepts(svm);
 
+	mark_all_dirty(svm->vmcb);
+}
+
+void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
+			  struct vmcb *nested_vmcb)
+{
+	bool evaluate_pending_interrupts =
+		is_intercept(svm, INTERCEPT_VINTR) ||
+		is_intercept(svm, INTERCEPT_IRET);
+
+	svm->nested.vmcb = vmcb_gpa;
+	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
+		svm->vcpu.arch.hflags |= HF_HIF_MASK;
+	else
+		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
+
+	load_nested_vmcb_control(svm, &nested_vmcb->control);
+	nested_prepare_vmcb_save(svm, nested_vmcb);
+	nested_prepare_vmcb_control(svm, nested_vmcb);
+
 	/*
 	 * If L1 had a pending IRQ/NMI before executing VMRUN,
 	 * which wasn't delivered because it was disallowed (e.g.
@@ -340,8 +350,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	enable_gif(svm);
 	if (unlikely(evaluate_pending_interrupts))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
-
-	mark_all_dirty(svm->vmcb);
 }
 
 int nested_svm_vmrun(struct vcpu_svm *svm)
-- 
2.18.2


