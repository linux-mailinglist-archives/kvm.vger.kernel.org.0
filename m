Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9426C1D582A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEORl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:41:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55833 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgEORlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=L5glrC7ruHWRvC4BN/6woG/tfXJGi9h4QDq5CC9pJHU=;
        b=C1r90wSf41n27CQ/YNKoS5bbCC0S9DTYsgf7Ma63QB3J1wPxotjlQN5JtGKz39HxtTy46O
        l1xCcunbxI6xDUoVFf5xdVMhQm6ALltxjkHWHChn4e7fHoEXEMjxCbVd9GVu8K0cDzx0HH
        FnKbHa4pfN6xkuvxoXucKLf4dIndrgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-QECq06BkN_SVHAtpJRXoig-1; Fri, 15 May 2020 13:41:49 -0400
X-MC-Unique: QECq06BkN_SVHAtpJRXoig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D37781005512;
        Fri, 15 May 2020 17:41:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366D110002CD;
        Fri, 15 May 2020 17:41:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 3/7] KVM: SVM: extract preparation of VMCB for nested run
Date:   Fri, 15 May 2020 13:41:40 -0400
Message-Id: <20200515174144.1727-4-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out filling svm->vmcb.save and svm->vmcb.control before VMRUN.
Only the latter will be useful when restoring nested SVM state.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 42 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e79acc852000..7807f6cc01fc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -246,19 +246,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
 }
 
-void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb)
+static void load_nested_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
-	bool evaluate_pending_interrupts =
-		is_intercept(svm, INTERCEPT_VINTR) ||
-		is_intercept(svm, INTERCEPT_IRET);
-
-	svm->nested.vmcb = vmcb_gpa;
-	load_nested_vmcb_control(svm, nested_vmcb);
-
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
-		nested_svm_init_mmu_context(&svm->vcpu);
-
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -276,9 +265,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	} else
 		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
-	/* Guest paging mode is active - reset mmu */
-	kvm_mmu_reset_context(&svm->vcpu);
-
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
 	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
@@ -291,6 +277,15 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
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
@@ -321,6 +316,21 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
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
+	load_nested_vmcb_control(svm, nested_vmcb);
+	load_nested_vmcb_save(svm, nested_vmcb);
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
2.18.2


