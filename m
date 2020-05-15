Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67381D5835
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgEORmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:42:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23151 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgEORly (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=TIWcd4+TI33lUHU9iof3DvH/a4WvLIe/J3URqYcylYo=;
        b=MhD0CgqYs2XPm1clxDRQtvJ6zhApRckIJMeTy53LrpSKnFGF7PYLjAxNIiT3N/Rpetv9NV
        jdODby20PHurQn0TMoKIPvA2hZCmkgxTz4doiJg6PLXJU+uJ8Agqq+tQtq7+JO2cvkS2rK
        9p3UXDWXh7sHX2KKrcbp6K6X2RZe848=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-VYqjRigbN6CbjL118ySnVg-1; Fri, 15 May 2020 13:41:50 -0400
X-MC-Unique: VYqjRigbN6CbjL118ySnVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0BB7835B40;
        Fri, 15 May 2020 17:41:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04DC510002CD;
        Fri, 15 May 2020 17:41:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 4/7] KVM: SVM: save all control fields in svm->nested
Date:   Fri, 15 May 2020 13:41:41 -0400
Message-Id: <20200515174144.1727-5-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for nested SVM save/restore, store all data that matters
from the VMCB control area into svm->nested.  It will then become part
of the nested SVM state that is saved by KVM_SET_NESTED_STATE and
restored by KVM_GET_NESTED_STATE, just like the cached vmcs12 for nVMX.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 37 ++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c    |  6 ++++++
 arch/x86/kvm/svm/svm.h    | 22 ++++++++++++++++------
 3 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7807f6cc01fc..54be341322d8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -237,7 +237,16 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
 	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
 
-	/* cache intercepts */
+	svm->nested.nested_ctl           = nested_vmcb->control.nested_ctl;
+	svm->nested.int_ctl              = nested_vmcb->control.int_ctl;
+	svm->nested.virt_ext             = nested_vmcb->control.virt_ext;
+	svm->nested.int_vector           = nested_vmcb->control.int_vector;
+	svm->nested.int_state            = nested_vmcb->control.int_state;
+	svm->nested.event_inj     	 = nested_vmcb->control.event_inj;
+	svm->nested.event_inj_err 	 = nested_vmcb->control.event_inj_err;
+	svm->nested.pause_filter_count   = nested_vmcb->control.pause_filter_count;
+	svm->nested.pause_filter_thresh  = nested_vmcb->control.pause_filter_thresh;
+
 	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
 	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
@@ -279,33 +288,31 @@ static void load_nested_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 }
 
-static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+	if (svm->nested.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
-	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
+	if (svm->nested.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
 
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
-	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
-	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
-	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
-	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
-	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
+	svm->vmcb->control.int_ctl             = svm->nested.int_ctl | V_INTR_MASKING_MASK;
+	svm->vmcb->control.virt_ext            = svm->nested.virt_ext;
+	svm->vmcb->control.int_vector          = svm->nested.int_vector;
+	svm->vmcb->control.int_state           = svm->nested.int_state;
+	svm->vmcb->control.event_inj           = svm->nested.event_inj;
+	svm->vmcb->control.event_inj_err       = svm->nested.event_inj_err;
 
-	svm->vmcb->control.pause_filter_count =
-		nested_vmcb->control.pause_filter_count;
-	svm->vmcb->control.pause_filter_thresh =
-		nested_vmcb->control.pause_filter_thresh;
+	svm->vmcb->control.pause_filter_count  = svm->nested.pause_filter_count;
+	svm->vmcb->control.pause_filter_thresh = svm->nested.pause_filter_thresh;
 
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
@@ -329,7 +336,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->nested.vmcb = vmcb_gpa;
 	load_nested_vmcb_control(svm, nested_vmcb);
 	load_nested_vmcb_save(svm, nested_vmcb);
-	nested_prepare_vmcb_control(svm, nested_vmcb);
+	nested_prepare_vmcb_control(svm);
 
 	/*
 	 * If L1 had a pending IRQ/NMI before executing VMRUN,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dc12a03d16f6..2b63d15328ba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3343,6 +3343,12 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->nested.exit_required))
 		return EXIT_FASTPATH_NONE;
 
+	if (unlikely(svm->nested.nested_run_pending)) {
+		/* After this vmentry, these fields will be used up.  */
+		svm->nested.event_inj     = 0;
+		svm->nested.event_inj_err = 0;
+	}
+
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
 	 * We don't want our modified rflags to be pushed on the stack where
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 730eb7242930..5cabed9c733a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -90,10 +90,6 @@ struct nested_state {
 	/* These are the merged vectors */
 	u32 *msrpm;
 
-	/* gpa pointers to the real vectors */
-	u64 vmcb_msrpm;
-	u64 vmcb_iopm;
-
 	/* A VMEXIT is required but not yet emulated */
 	bool exit_required;
 
@@ -101,13 +97,27 @@ struct nested_state {
 	 * we cannot inject a nested vmexit yet.  */
 	bool nested_run_pending;
 
-	/* cache for intercepts of the guest */
+	/* cache for control fields of the guest */
+	u64 vmcb_msrpm;
+	u64 vmcb_iopm;
+
 	u32 intercept_cr;
 	u32 intercept_dr;
 	u32 intercept_exceptions;
 	u64 intercept;
 
-	/* Nested Paging related state */
+	u32 event_inj;
+	u32 event_inj_err;
+
+	u64 virt_ext;
+	u32 int_ctl;
+	u32 int_vector;
+	u32 int_state;
+
+	u16 pause_filter_thresh;
+	u16 pause_filter_count;
+
+	u64 nested_ctl;
 	u64 nested_cr3;
 };
 
-- 
2.18.2


