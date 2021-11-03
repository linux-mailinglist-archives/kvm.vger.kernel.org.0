Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E41444309
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhKCOJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:09:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231804AbhKCOJE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635948387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cV9LmE/tmq/c1oxFMPs6g5FELaENGhCsOQppswMfB8g=;
        b=IMLhrGgizszwWSwmC4uOIkZ0oeBR+okPLyS4eNq9H/Ry5ORwvbwir+r+wHBblRFFzL4mZr
        4mnJ1Ob9dV2traKYGPMMpkMnkDc+wJbtN6QOp9ZxNbmZn4MzHbGrLyCecClwCyRBv5y6zK
        1k8fBIA48AbT5W4zBHIaUa3ACF7QUKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-uzOEIFcbM169oTQZc8kRqg-1; Wed, 03 Nov 2021 10:06:23 -0400
X-MC-Unique: uzOEIFcbM169oTQZc8kRqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 536FD100CFB5;
        Wed,  3 Nov 2021 14:06:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29026102ADE5;
        Wed,  3 Nov 2021 14:06:19 +0000 (UTC)
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
Subject: [PATCH v5 1/7] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
Date:   Wed,  3 Nov 2021 10:05:21 -0400
Message-Id: <20211103140527.752797-2-eesposit@redhat.com>
In-Reply-To: <20211103140527.752797-1-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inline nested_vmcb_check_cr3_cr4 as it is not called by anyone else.
Doing so simplifies next patches.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f8b7bc04b3e7..946c06a25d37 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -275,27 +275,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool nested_vmcb_check_cr3_cr4(struct kvm_vcpu *vcpu,
-				      struct vmcb_save_area *save)
-{
-	/*
-	 * These checks are also performed by KVM_SET_SREGS,
-	 * except that EFER.LMA is not checked by SVM against
-	 * CR0.PG && EFER.LME.
-	 */
-	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
-		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
-		    CC(!(save->cr0 & X86_CR0_PE)) ||
-		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
-			return false;
-	}
-
-	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
-		return false;
-
-	return true;
-}
-
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 				    struct vmcb_save_area *save)
@@ -317,7 +296,19 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
 		return false;
 
-	if (!nested_vmcb_check_cr3_cr4(vcpu, save))
+	/*
+	 * These checks are also performed by KVM_SET_SREGS,
+	 * except that EFER.LMA is not checked by SVM against
+	 * CR0.PG && EFER.LME.
+	 */
+	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
+		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
+		    CC(!(save->cr0 & X86_CR0_PE)) ||
+		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
+			return false;
+	}
+
+	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
 		return false;
 
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
-- 
2.27.0

