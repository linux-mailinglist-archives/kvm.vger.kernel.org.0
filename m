Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0C9444308
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKCOJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:09:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231932AbhKCOJF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635948389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QcVev1Ykpkrc32brdMrevNpi1w0zxnAXd00Dazz9is=;
        b=O0N61zsS7RHUqZ91fCXGE901yw8MJML4Af/AOg0cdoFzLWi++u+gpewbf3avpVEK8hbFNX
        n5CpBsXO0wctQinobZKKAcapGDNySuckKhpqcluVnxfjekC+O3kvk8YdXFeEnREYpJ+EQk
        zcRQAPNJ4nvHuHrjn8JJUVxXyBLBo3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-JR-doC3aPiWFWe5aS_4eKg-1; Wed, 03 Nov 2021 10:06:25 -0400
X-MC-Unique: JR-doC3aPiWFWe5aS_4eKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6244100CFB2;
        Wed,  3 Nov 2021 14:06:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9DBE100239F;
        Wed,  3 Nov 2021 14:06:22 +0000 (UTC)
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
Subject: [PATCH v5 4/7] nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
Date:   Wed,  3 Nov 2021 10:05:24 -0400
Message-Id: <20211103140527.752797-5-eesposit@redhat.com>
In-Reply-To: <20211103140527.752797-1-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 162b338a6c74..64fb43234e06 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -245,8 +245,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+static bool _nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				     struct vmcb_save_area_cached *save)
 {
 	/*
 	 * FIXME: these should be done after copying the fields,
@@ -286,6 +286,14 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
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
@@ -694,7 +702,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -1330,6 +1338,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
 	struct vmcb_save_area *save;
+	struct vmcb_save_area_cached save_cached;
 	unsigned long cr0;
 	int ret;
 
@@ -1397,10 +1406,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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

