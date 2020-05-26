Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D531E2884
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbgEZRXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389113AbgEZRXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSd3IEYZKR/6Qwx6J8GSXbc0+/BFad6M3JkDOg/O/o8=;
        b=BZpQOanM4SNCVEDLSa9mMMe9qwaQzFtTQBF1hgoa1wBOfJ5qJ9EmwkloCrFQtacaAaTXtQ
        KrBNP+Uo8/wSmU9qFgmj+uItCiV9k++1FBHFXlLb97q/OIRDlXfcFbM38qAq3GODrF7sbq
        Clc7UxVHcdPugBEsbe8lrNaEuDXc9vY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-p6s6c6wzMamQDShczMNqaQ-1; Tue, 26 May 2020 13:23:17 -0400
X-MC-Unique: p6s6c6wzMamQDShczMNqaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B20C5100CCC4;
        Tue, 26 May 2020 17:23:16 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B34C5C1D6;
        Tue, 26 May 2020 17:23:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 10/28] KVM: nSVM: extract preparation of VMCB for nested run
Date:   Tue, 26 May 2020 13:22:50 -0400
Message-Id: <20200526172308.111575-11-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out filling svm->vmcb.save and svm->vmcb.control before VMRUN.
Only the latter will be useful when restoring nested SVM state.

This patch introduces no semantic change, so the MMU setup is still
done in nested_prepare_vmcb_save.  The next patch will clean up things.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 40 +++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ea00dcd8c39b..af7c9ce8c5ad 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -245,21 +245,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
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
 	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
@@ -291,7 +278,10 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
 	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+}
 
+static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+{
 	svm_flush_tlb(&svm->vcpu);
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
@@ -321,6 +311,26 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
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
@@ -336,8 +346,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	enable_gif(svm);
 	if (unlikely(evaluate_pending_interrupts))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
-
-	mark_all_dirty(svm->vmcb);
 }
 
 int nested_svm_vmrun(struct vcpu_svm *svm)
-- 
2.26.2


