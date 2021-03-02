Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70632B5AA
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382572AbhCCHTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835996AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yg+UqaTHKD1zwt7TFKVYRo42xjHGk/cj7e9BrHR0/KA=;
        b=eyDUZpLiLsfF4URSG910j9vxErIQVuhjpgSFrDCewxm8uEFFAvQyQab43NnIaQtqXWHsOP
        SZ2O+6c03P8aBEjS9QCy3M4WxOVG2f4uQVDsVlVPs5a/O8uu13QzhNr/70nYzl0ekg0Ef1
        Ngt9tenI8ZjE0Alqjk+AmBsbwGI4IEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-gNLpy0ShPZiD-sPSF9BcWg-1; Tue, 02 Mar 2021 14:33:51 -0500
X-MC-Unique: gNLpy0ShPZiD-sPSF9BcWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84EC91E562;
        Tue,  2 Mar 2021 19:33:49 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 037E260BFA;
        Tue,  2 Mar 2021 19:33:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 09/23] KVM: nSVM: Add missing checks for reserved bits to svm_set_nested_state()
Date:   Tue,  2 Mar 2021 14:33:29 -0500
Message-Id: <20210302193343.313318-10-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

The path for SVM_SET_NESTED_STATE needs to have the same checks for the CPU
registers, as we have in the VMRUN path for a nested guest. This patch adds
those missing checks to svm_set_nested_state().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-Id: <20201006190654.32305-3-krish.sadhukhan@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 54 ++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 585b5aa1914f..cadf776f58f7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -246,29 +246,51 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
+				      struct vmcb_save_area *save)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	bool vmcb12_lma;
 
-	if ((vmcb12->save.efer & EFER_SVME) == 0)
+	/*
+	 * These checks are also performed by KVM_SET_SREGS,
+	 * except that EFER.LMA is not checked by SVM against
+	 * CR0.PG && EFER.LME.
+	 */
+	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
+		if (!(save->cr4 & X86_CR4_PAE) || !(save->cr0 & X86_CR0_PE) ||
+		    kvm_vcpu_is_illegal_gpa(vcpu, save->cr3))
+			return false;
+	}
+
+	return kvm_is_valid_cr4(&svm->vcpu, save->cr4);
+}
+
+/* Common checks that apply to both L1 and L2 state.  */
+static bool nested_vmcb_valid_sregs(struct vcpu_svm *svm,
+				    struct vmcb_save_area *save)
+{
+	if (!(save->efer & EFER_SVME))
 		return false;
 
-	if (((vmcb12->save.cr0 & X86_CR0_CD) == 0) && (vmcb12->save.cr0 & X86_CR0_NW))
+	if (((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
+	    (save->cr0 & ~0xffffffffULL))
 		return false;
 
-	if (!kvm_dr6_valid(vmcb12->save.dr6) || !kvm_dr7_valid(vmcb12->save.dr7))
+	if (!kvm_dr6_valid(save->dr6) || !kvm_dr7_valid(save->dr7))
 		return false;
 
-	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
+	if (!nested_vmcb_check_cr3_cr4(svm, save))
+		return false;
 
-	if (vmcb12_lma) {
-		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
-		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
-		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
-			return false;
-	}
-	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_valid_efer(&svm->vcpu, save->efer))
+		return false;
+
+	return true;
+}
+
+static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+{
+	if (!nested_vmcb_valid_sregs(svm, &vmcb12->save))
 		return false;
 
 	return nested_vmcb_check_controls(&vmcb12->control);
@@ -1232,9 +1254,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	/*
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
-	 * TODO: validate reserved bits for all saved state.
 	 */
-	if (!(save->cr0 & X86_CR0_PG))
+	if (!(save->cr0 & X86_CR0_PG) ||
+	    !(save->cr0 & X86_CR0_PE) ||
+	    (save->rflags & X86_EFLAGS_VM) ||
+	    !nested_vmcb_valid_sregs(svm, save))
 		goto out_free;
 
 	/*
-- 
2.26.2


