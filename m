Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1940F70C
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhIQMFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244007AbhIQMFC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDXX1c88w+xYKfuZAff9FcmFUYO//gnFJG1uY7JP0RE=;
        b=IJLXEbTrEzKWQZQaYsDqg7zUWm3/4DAMZG9aclUPJB/sjkeEJq+gM0fxvLcQampr9etWtP
        G5otYKb7RUd03WYJq896tCeXF5L396xgGa6AU3VxnZts3UFw78U/jVs3QUl7qt+f4JMBDh
        NsDKT6EJyzaUoXY7HG0SZK7yK/CpUBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-zlQqwIloP7SbDcJuA48e2w-1; Fri, 17 Sep 2021 08:03:39 -0400
X-MC-Unique: zlQqwIloP7SbDcJuA48e2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9FA800FF4;
        Fri, 17 Sep 2021 12:03:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E1571017E27;
        Fri, 17 Sep 2021 12:03:36 +0000 (UTC)
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
Subject: [PATCH v2 3/4] nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
Date:   Fri, 17 Sep 2021 08:03:28 -0400
Message-Id: <20210917120329.2013766-4-eesposit@redhat.com>
In-Reply-To: <20210917120329.2013766-1-eesposit@redhat.com>
References: <20210917120329.2013766-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that struct vmcb_save_area_cached contains the required
vmcb fields values (done in nested_load_save_from_vmcb12()),
check them to see if they are correct in nested_vmcb_valid_sregs().

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fcbb66915403..7e4cd134946f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -278,7 +278,7 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+				    struct vmcb_save_area_cached *save)
 {
 	/*
 	 * FIXME: these should be done after copying the fields,
@@ -671,7 +671,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	nested_load_save_from_vmcb12(svm, &vmcb12->save);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -1368,11 +1368,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
 	 */
+	nested_load_save_from_vmcb12(svm, save);
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
-		goto out_free;
+	    !nested_vmcb_valid_sregs(vcpu, &svm->nested.save))
+		goto out_free_save;
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
@@ -1384,7 +1385,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
 				  nested_npt_enabled(svm), false);
 	if (WARN_ON_ONCE(ret))
-		goto out_free;
+		goto out_free_save;
 
 
 	/*
@@ -1408,12 +1409,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_load_control_from_vmcb12(svm, ctl);
-	nested_load_save_from_vmcb12(svm, save);
 
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

