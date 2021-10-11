Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1EE429214
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbhJKOjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:39:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241756AbhJKOjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dx5JLviDyBrF4qI11+R/4Q570OKffHh0KdIFizw4LBw=;
        b=CGQU75JOW7eYFlUEeKnZxRpNK1JsMPZd4nPDoHJ4UBWvWZFXWHhB+25XgUseCLt4jcZChg
        HZRRsFHDpSqmrIVhLKq1BhExDZ1OmXFDjt8SiIdfCX1AFqfu6y1SHNd2j7qd8eNjvjmjCU
        3TZv5rFe4HmV5xtv8u+O1CTVxt351Nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-u9ghSEfzPPCFyAvc0fNdNg-1; Mon, 11 Oct 2021 10:37:13 -0400
X-MC-Unique: u9ghSEfzPPCFyAvc0fNdNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 766621922969;
        Mon, 11 Oct 2021 14:37:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 623B719C59;
        Mon, 11 Oct 2021 14:37:10 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v3 4/8] nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
Date:   Mon, 11 Oct 2021 10:36:58 -0400
Message-Id: <20211011143702.1786568-5-eesposit@redhat.com>
In-Reply-To: <20211011143702.1786568-1-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that struct vmcb_save_area_cached contains the required
vmcb fields values (done in nested_load_save_from_vmcb12()),
check them to see if they are correct in nested_vmcb_valid_sregs().

Since we are always checking for the nested struct, it is enough
to have only the vcpu as parameter.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f6030a202bc5..d07cd4b88acd 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -230,9 +230,10 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_save_area_cached *save = &svm->nested.save;
 	/*
 	 * FIXME: these should be done after copying the fields,
 	 * to avoid TOC/TOU races.  For these save area checks
@@ -658,7 +659,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_valid_sregs(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -1355,11 +1356,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
 	 */
+	nested_copy_vmcb_save_to_cache(svm, save);
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
-		goto out_free;
+	    !nested_vmcb_valid_sregs(vcpu))
+		goto out_free_save;
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
@@ -1371,7 +1373,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
 				  nested_npt_enabled(svm), false);
 	if (WARN_ON_ONCE(ret))
-		goto out_free;
+		goto out_free_save;
 
 
 	/*
@@ -1395,12 +1397,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_copy_vmcb_control_to_cache(svm, ctl);
-	nested_copy_vmcb_save_to_cache(svm, save);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
+
+out_free_save:
+	memset(&svm->nested.save, 0, sizeof(struct vmcb_save_area_cached));
+
 out_free:
 	kfree(save);
 	kfree(ctl);
-- 
2.27.0

