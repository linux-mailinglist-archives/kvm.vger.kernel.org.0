Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1732B5AF
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382701AbhCCHTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835986AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JiAvKrhCFYlMB7gNxjIjhqa2+u7SdPG1DbYrFBxwPrI=;
        b=it7O8oFQcGmBS4Aj+gjbGHjrbanpFWUg96x1H8ujcp7mCBzKVbVJMoXTtD57A/14iy/6n1
        6eloGA++cECbpe4T49o3yyvYEyzrpFqvy8tKgCbWZCS+//omQceQBrnY/HvxBxZiueUia6
        08caC0BrQ1UConj/vXsVOC0M8q95B2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-VQJMy_ZDPVi75VUL0a0ezw-1; Tue, 02 Mar 2021 14:33:52 -0500
X-MC-Unique: VQJMy_ZDPVi75VUL0a0ezw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AD1880196E;
        Tue,  2 Mar 2021 19:33:51 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A747D60CC5;
        Tue,  2 Mar 2021 19:33:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 11/23] KVM: nSVM: Trace VM-Enter consistency check failures
Date:   Tue,  2 Mar 2021 14:33:31 -0500
Message-Id: <20210302193343.313318-12-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Use trace_kvm_nested_vmenter_failed() and its macro magic to trace
consistency check failures on nested VMRUN.  Tracing such failures by
running the buggy VMM as a KVM guest is often the only way to get a
precise explanation of why VMRUN failed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210204000117.3303214-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cadf776f58f7..03a06f959bc8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -29,6 +29,8 @@
 #include "lapic.h"
 #include "svm.h"
 
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
+
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 				       struct x86_exception *fault)
 {
@@ -233,14 +235,13 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
+	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
 
-	if (control->asid == 0)
+	if (CC(control->asid == 0))
 		return false;
 
-	if ((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
-	    !npt_enabled)
+	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
 		return false;
 
 	return true;
@@ -257,32 +258,36 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 	 * CR0.PG && EFER.LME.
 	 */
 	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
-		if (!(save->cr4 & X86_CR4_PAE) || !(save->cr0 & X86_CR0_PE) ||
-		    kvm_vcpu_is_illegal_gpa(vcpu, save->cr3))
+		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
+		    CC(!(save->cr0 & X86_CR0_PE)) ||
+		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
 			return false;
 	}
 
-	return kvm_is_valid_cr4(&svm->vcpu, save->cr4);
+	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
+		return false;
+
+	return true;
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_valid_sregs(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save)
 {
-	if (!(save->efer & EFER_SVME))
+	if (CC(!(save->efer & EFER_SVME)))
 		return false;
 
-	if (((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
-	    (save->cr0 & ~0xffffffffULL))
+	if (CC((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
+	    CC(save->cr0 & ~0xffffffffULL))
 		return false;
 
-	if (!kvm_dr6_valid(save->dr6) || !kvm_dr7_valid(save->dr7))
+	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
 		return false;
 
 	if (!nested_vmcb_check_cr3_cr4(svm, save))
 		return false;
 
-	if (!kvm_valid_efer(&svm->vcpu, save->efer))
+	if (CC(!kvm_valid_efer(&svm->vcpu, save->efer)))
 		return false;
 
 	return true;
@@ -384,12 +389,12 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt)
 {
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3)))
 		return -EINVAL;
 
 	if (!nested_npt && is_pae_paging(vcpu) &&
 	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
-		if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
 			return -EINVAL;
 	}
 
-- 
2.26.2


