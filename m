Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226CB4440D6
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 12:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCL4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 07:56:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhKCL4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 07:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635940414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PBCDUPBeDW8iF31Qz39WZCL9VVYXxbHCI/wd2pMkgyE=;
        b=Uow0O9jEZQemT0/34GZN9BLshtkdjNjJEEBaxm0jJQMf0sT8mhHa0dyixuwwBKva8+16nM
        yWPadSfO0dLFcUn4yrIjky+YDo/ZPIDcwNNZKzc+wvE4Z4XEnEP2gSJjWnL68dVGlEFvHf
        HNaMGtNLCf5g5IM4Lq2heLn/lWbdHPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-3JNURkOsOGm74vDTJZGJ4g-1; Wed, 03 Nov 2021 07:53:30 -0400
X-MC-Unique: 3JNURkOsOGm74vDTJZGJ4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 567461006AA2;
        Wed,  3 Nov 2021 11:53:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19E4D196E5;
        Wed,  3 Nov 2021 11:53:26 +0000 (UTC)
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
Subject: [PATCH v4 1/7] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
Date:   Wed,  3 Nov 2021 07:52:24 -0400
Message-Id: <20211103115230.720154-2-eesposit@redhat.com>
In-Reply-To: <20211103115230.720154-1-eesposit@redhat.com>
References: <20211103115230.720154-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 510b833cbd39..9470933c77cd 100644
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

