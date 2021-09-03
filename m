Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38413FFE22
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349114AbhICKWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 06:22:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349025AbhICKWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 06:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630664461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yHnSpPsgYRjNZZZnnzHmx7RnMLQoBqihwjdY9jE0GBs=;
        b=Gxdu0HFdYOipaHhEyBchruhoxN6SMumS8ZcGvDHYeJ6MsjbPKoFE8DhUsJ88q12PAlagnB
        vDTnguek3GgmqArXXvfXqD1gn/Sjoep09F0j2nfARLuwedo46wZ+gp8NYjWnspQwilIrva
        y7WZkxwd/t6zjpMQrDr81npWG1rHdZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-QrOY35GXNoim9XjygKjU8g-1; Fri, 03 Sep 2021 06:20:59 -0400
X-MC-Unique: QrOY35GXNoim9XjygKjU8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BEDB824FA6;
        Fri,  3 Sep 2021 10:20:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C5825D9C6;
        Fri,  3 Sep 2021 10:20:54 +0000 (UTC)
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
Subject: [RFC PATCH 1/3] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
Date:   Fri,  3 Sep 2021 12:20:37 +0200
Message-Id: <20210903102039.55422-2-eesposit@redhat.com>
In-Reply-To: <20210903102039.55422-1-eesposit@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inline nested_vmcb_check_cr3_cr4 as it is not called by anyone else.
Doing so simplifies next patches.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e5515477c30a..d2fe65e2a7a4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -260,27 +260,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
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
@@ -302,7 +281,19 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
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

