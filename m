Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFF03E481C
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhHIOz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:55:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235201AbhHIOzS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 10:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628520897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5n29Ns9jbHIa7w/GQmGAMNTzRkJjoUQ8KKA6Ga94Xg=;
        b=XAWXypEennYBtKob/AJCVJQvdMqodjTjsCgyfK/F3tjmD4EuChXi1GVKrDnm7hSnolQn83
        VZDF1xL8Tbpc9SpqmUf7sn/ZFTssL8u1JXEpoULcXgMA4rN/Sbx4l88kv9HnO+wanxcyH/
        EKuQjlo93f7S8WVPJS736/NN/VpWsfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-o35Qq__SN_WSsti7M_-SzA-1; Mon, 09 Aug 2021 10:54:56 -0400
X-MC-Unique: o35Qq__SN_WSsti7M_-SzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF44E100A96A;
        Mon,  9 Aug 2021 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 911F07A51F;
        Mon,  9 Aug 2021 14:54:29 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 2/2] KVM: nSVM: temporarly save vmcb12's efer, cr0 and cr4 to avoid TOC/TOU races
Date:   Mon,  9 Aug 2021 16:53:43 +0200
Message-Id: <20210809145343.97685-3-eesposit@redhat.com>
In-Reply-To: <20210809145343.97685-1-eesposit@redhat.com>
References: <20210809145343.97685-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the checks done by nested_vmcb_valid_sregs and nested_vmcb_check_controls
directly in enter_svm_guest_mode, and save the values of vmcb12's
efer, cr0 and cr4 in local variable that are then passed to
nested_vmcb02_prepare_save. This prevents from creating TOC/TOU races.

This also avoids the need of force-setting EFER_SVME in
nested_vmcb02_prepare_save.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 72 +++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0ac2d14add15..04e9e947deb9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -259,20 +259,14 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+				    struct vmcb_save_area *save,
+				    u64 efer, u64 cr0, u64 cr4)
 {
-	/*
-	 * FIXME: these should be done after copying the fields,
-	 * to avoid TOC/TOU races.  For these save area checks
-	 * the possible damage is limited since kvm_set_cr0 and
-	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
-	 * so it is force-set later in nested_prepare_vmcb_save.
-	 */
-	if (CC(!(save->efer & EFER_SVME)))
+	if (CC(!(efer & EFER_SVME)))
 		return false;
 
-	if (CC((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
-	    CC(save->cr0 & ~0xffffffffULL))
+	if (CC((cr0 & X86_CR0_CD) == 0 && (cr0 & X86_CR0_NW)) ||
+	    CC(cr0 & ~0xffffffffULL))
 		return false;
 
 	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
@@ -283,17 +277,16 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	 * except that EFER.LMA is not checked by SVM against
 	 * CR0.PG && EFER.LME.
 	 */
-	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
-		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
-		    CC(!(save->cr0 & X86_CR0_PE)) ||
+	if ((efer & EFER_LME) && (cr0 & X86_CR0_PG)) {
+		if (CC(!(cr4 & X86_CR4_PAE)) || CC(!(cr0 & X86_CR0_PE)) ||
 		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
 			return false;
 	}
 
-	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
+	if (CC(!kvm_is_valid_cr4(vcpu, cr4)))
 		return false;
 
-	if (CC(!kvm_valid_efer(vcpu, save->efer)))
+	if (CC(!kvm_valid_efer(vcpu, efer)))
 		return false;
 
 	return true;
@@ -434,7 +427,9 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
-static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_vmcb02_prepare_save(struct vcpu_svm *svm,
+				       struct vmcb *vmcb12,
+				       u64 efer, u64 cr0, u64 cr4)
 {
 	bool new_vmcb12 = false;
 
@@ -463,15 +458,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
-	/*
-	 * Force-set EFER_SVME even though it is checked earlier on the
-	 * VMCB12, because the guest can flip the bit between the check
-	 * and now.  Clearing EFER_SVME would call svm_free_nested.
-	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(&svm->vcpu, efer);
 
-	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
-	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	svm_set_cr0(&svm->vcpu, cr0);
+	svm_set_cr4(&svm->vcpu, cr4);
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
@@ -567,6 +557,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
+	u64 vmcb12_efer, vmcb12_cr0, vmcb12_cr4;
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
 			       vmcb12->save.rip,
@@ -589,8 +580,25 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+
+	/* Save vmcb12's EFER, CR0 and CR4 to avoid TOC/TOU races. */
+	vmcb12_efer = vmcb12->save.efer;
+	vmcb12_cr0 = vmcb12->save.cr0;
+	vmcb12_cr4 = vmcb12->save.cr4;
+
+	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save, vmcb12_efer,
+				     vmcb12_cr0, vmcb12_cr4) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
+		vmcb12->control.exit_code    = SVM_EXIT_ERR;
+		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_info_1  = 0;
+		vmcb12->control.exit_info_2  = 0;
+		return 1;
+	}
+
 	nested_vmcb02_prepare_control(svm);
-	nested_vmcb02_prepare_save(svm, vmcb12);
+	nested_vmcb02_prepare_save(svm, vmcb12, vmcb12_efer, vmcb12_cr0,
+				   vmcb12_cr4);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
 				  nested_npt_enabled(svm), true);
@@ -641,15 +649,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = 0;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		goto out;
-	}
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1336,7 +1335,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
+	    !nested_vmcb_valid_sregs(vcpu, save, save->efer, save->cr0,
+				     save->cr4))
 		goto out_free;
 
 	/*
-- 
2.31.1

