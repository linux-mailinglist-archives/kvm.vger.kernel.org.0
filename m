Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3474440D7
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 12:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhKCL4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 07:56:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231982AbhKCL4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 07:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635940417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rV9jvKAnOsN8eW7GKNYQpE+5cN/AYEkqM3lTfBRzW0=;
        b=IKhEsTDVO9GXAs9eBdNR4JlARtmtP/2fPDsPB06pdEMZWdY6c9/B0KpI0YSMnfVPWF4Qkg
        H2vYj+egmz3s1alW1oQ9zyU98gV0m5ie5dVL7EM4xHPTc9ev2fB5GUOVI2L1Tton1wF36w
        zZ5H7j8PMYp1Wdz0J1F/zeyYm8vgDI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-dPbW7TryP3ylWyjWXO95ig-1; Wed, 03 Nov 2021 07:53:34 -0400
X-MC-Unique: dPbW7TryP3ylWyjWXO95ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 970D610A8E03;
        Wed,  3 Nov 2021 11:53:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69EE119741;
        Wed,  3 Nov 2021 11:53:31 +0000 (UTC)
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
Subject: [PATCH v4 4/7] nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
Date:   Wed,  3 Nov 2021 07:52:27 -0400
Message-Id: <20211103115230.720154-5-eesposit@redhat.com>
In-Reply-To: <20211103115230.720154-1-eesposit@redhat.com>
References: <20211103115230.720154-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that struct vmcb_save_area_cached contains the required
vmcb fields values (done in nested_load_save_from_vmcb12()),
check them to see if they are correct in nested_vmcb_valid_sregs().

While at it, rename nested_vmcb_valid_sregs in nested_vmcb_check_save.
_nested_vmcb_check_save takes the additional @save parameter, so it
is helpful when we want to check a non-svm save state, like in
svm_set_nested_state. The reason for that is that save is the L1
state, not L2, so we just check it.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c04f8750e1f7..692bd38025a9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -230,8 +230,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+static bool _nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				     struct vmcb_save_area_cached *save)
 {
 	/*
 	 * FIXME: these should be done after copying the fields,
@@ -271,6 +271,14 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_save_area_cached *save = &svm->nested.save;
+
+	return _nested_vmcb_check_save(vcpu, save);
+}
+
 static
 void _nested_copy_vmcb_control_to_cache(struct vmcb_control_area *to,
 					struct vmcb_control_area *from)
@@ -673,7 +681,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -1298,6 +1306,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
 	struct vmcb_save_area *save;
+	struct vmcb_save_area_cached save_cached;
 	unsigned long cr0;
 	int ret;
 
@@ -1365,10 +1374,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
 	 */
+	_nested_copy_vmcb_save_to_cache(&save_cached, save);
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
+	    !_nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
 	/*
-- 
2.27.0

