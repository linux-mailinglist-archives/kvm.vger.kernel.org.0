Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D20C1E821D
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgE2Pkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20602 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727960AbgE2Pjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YG15fFy48dUmzGXuX0tdv/sc07cuUwHNkJbScW+pCU=;
        b=B1nWnb6OJs+LAEtLST5rl1YrHHz1AgdKYsPqKzfIa486PYm6V3/cHn2PZtaUkjQwaKOYPb
        rJku/Nx4ZOUqdvtMAzgMcmSHYozRVfezSRjJCBrwccC7YM7Raqrzd90nSNIRdN1+051g7q
        PMwFEJOZAkZktA7iOraMYonHT/5Vpeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-1G0u3lJ6M_mWlZVkb1vyig-1; Fri, 29 May 2020 11:39:48 -0400
X-MC-Unique: 1G0u3lJ6M_mWlZVkb1vyig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D44F8005AA;
        Fri, 29 May 2020 15:39:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA9FA10013C2;
        Fri, 29 May 2020 15:39:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 21/30] KVM: nSVM: synthesize correct EXITINTINFO on vmexit
Date:   Fri, 29 May 2020 11:39:25 -0400
Message-Id: <20200529153934.11694-22-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This bit was added to nested VMX right when nested_run_pending was
introduced, but it is not yet there in nSVM.  Since we can have pending
events that L0 injected directly into L2 on vmentry, we have to transfer
them into L1's queue.

For this to work, one important change is required: svm_complete_interrupts
(which clears the "injected" fields from the previous VMRUN, and updates them
from svm->vmcb's EXITINTINFO) must be placed before we inject the vmexit.
This is not too scary though; VMX even does it in vmx_vcpu_run.

While at it, the nested_vmexit_inject tracepoint is moved towards the
end of nested_svm_vmexit.  This ensures that the synthesized EXITINTINFO
is visible in the trace.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 59 +++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c    |  4 +--
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6c7f0bffdf01..c3c04fef11df 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -262,6 +262,43 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
 	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
 
+/*
+ * Transfer any event that L0 or L1 wanted to inject into L2 to
+ * EXIT_INT_INFO.
+ */
+static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
+					   struct vmcb *nested_vmcb)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u32 exit_int_info = 0;
+	unsigned int nr;
+
+	if (vcpu->arch.exception.injected) {
+		nr = vcpu->arch.exception.nr;
+		exit_int_info = nr | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
+
+		if (vcpu->arch.exception.has_error_code) {
+			exit_int_info |= SVM_EVTINJ_VALID_ERR;
+			nested_vmcb->control.exit_int_info_err =
+				vcpu->arch.exception.error_code;
+		}
+
+	} else if (vcpu->arch.nmi_injected) {
+		exit_int_info = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
+
+	} else if (vcpu->arch.interrupt.injected) {
+		nr = vcpu->arch.interrupt.nr;
+		exit_int_info = nr | SVM_EVTINJ_VALID;
+
+		if (vcpu->arch.interrupt.soft)
+			exit_int_info |= SVM_EVTINJ_TYPE_SOFT;
+		else
+			exit_int_info |= SVM_EVTINJ_TYPE_INTR;
+	}
+
+	nested_vmcb->control.exit_int_info = exit_int_info;
+}
+
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
 	/* Load the nested guest state */
@@ -466,13 +503,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
-	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
-				       vmcb->control.exit_info_1,
-				       vmcb->control.exit_info_2,
-				       vmcb->control.exit_int_info,
-				       vmcb->control.exit_int_info_err,
-				       KVM_ISA_SVM);
-
 	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
 	if (rc) {
 		if (rc == -EINVAL)
@@ -517,8 +547,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
 	nested_vmcb->control.exit_info_1       = vmcb->control.exit_info_1;
 	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
-	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
-	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
+
+	if (nested_vmcb->control.exit_code != SVM_EXIT_ERR)
+		nested_vmcb_save_pending_event(svm, nested_vmcb);
 
 	if (svm->nrips_enabled)
 		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
@@ -539,9 +570,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
 
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
-
 	svm->nested.ctl.nested_cr3 = 0;
 
 	/* Restore selected save entries */
@@ -570,6 +598,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	mark_all_dirty(svm->vmcb);
 
+	trace_kvm_nested_vmexit_inject(nested_vmcb->control.exit_code,
+				       nested_vmcb->control.exit_info_1,
+				       nested_vmcb->control.exit_info_2,
+				       nested_vmcb->control.exit_int_info,
+				       nested_vmcb->control.exit_int_info_err,
+				       KVM_ISA_SVM);
+
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e48e4173bc60..422b1cc62a20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2913,6 +2913,8 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
 
+	svm_complete_interrupts(svm);
+
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
@@ -2932,8 +2934,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 	}
 
-	svm_complete_interrupts(svm);
-
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
-- 
2.26.2


