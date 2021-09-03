Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154EC3FFE26
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 12:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbhICKWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 06:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349112AbhICKWj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 06:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630664499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZd3jRLUUu1Oy1RGPc5d71idLDLNiXdx75BhhAmTkyE=;
        b=O0KIrlZxGyHNl8jiLacbfeX8VQY4h+/kGBTNRCh1K7fqjOfhsNPH0AcAwrF+VmpGSmiJBl
        uRtgu2zyAstxBsXx6AFFbX5DZTkQYZLZElMNJfOZToUEWPYyeOga89mEPHr92UgPRG3f/E
        HZrgVd3R4VwSAHN1EsNS5RQGmyaVWvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-FuHjKf-cNY6BIGXsNvaQRg-1; Fri, 03 Sep 2021 06:21:38 -0400
X-MC-Unique: FuHjKf-cNY6BIGXsNvaQRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E591501E1;
        Fri,  3 Sep 2021 10:21:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE2CF5D9C6;
        Fri,  3 Sep 2021 10:21:32 +0000 (UTC)
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
Subject: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU races
Date:   Fri,  3 Sep 2021 12:20:39 +0200
Message-Id: <20210903102039.55422-4-eesposit@redhat.com>
In-Reply-To: <20210903102039.55422-1-eesposit@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the checks done by nested_vmcb_valid_sregs and
nested_vmcb_check_controls directly in enter_svm_guest_mode,
and use svm->nested.save cached fields (EFER, CR0, CR4)
instead of vmcb12's.
This prevents from creating TOC/TOU races.

This also avoids the need of force-setting EFER_SVME in
nested_vmcb02_prepare_save.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2491c77203c7..487810cfefde 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -280,13 +280,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 				    struct vmcb_save_area *save)
 {
-	/*
-	 * FIXME: these should be done after copying the fields,
-	 * to avoid TOC/TOU races.  For these save area checks
-	 * the possible damage is limited since kvm_set_cr0 and
-	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
-	 * so it is force-set later in nested_prepare_vmcb_save.
-	 */
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
 
@@ -459,7 +452,8 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
-static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_vmcb02_prepare_save(struct vcpu_svm *svm,
+				       struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
 
@@ -488,15 +482,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
-	/*
-	 * Force-set EFER_SVME even though it is checked earlier on the
-	 * VMCB12, because the guest can flip the bit between the check
-	 * and now.  Clearing EFER_SVME would call svm_free_nested.
-	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
 
-	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
-	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
+	svm_set_cr4(&svm->vcpu, svm->nested.save.cr4);
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
@@ -671,7 +660,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	nested_load_save_from_vmcb12(svm, &vmcb12->save);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
-- 
2.27.0

