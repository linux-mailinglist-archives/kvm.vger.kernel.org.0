Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793803E4811
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhHIOzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235326AbhHIOzP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 10:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628520894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZYvnn5g98PxjXEQfMRGjEyYcFjOOPfx2qqowIkJGi8=;
        b=VIUZaDoRly7g165gX03ZLB6rm2QISNSGxhzZFi8w5eiTIkBeYBHj5G36SALuJ6Cqyms6+j
        f4EF6rTpkmvFgO+pPucY/35gQR+xPuQkIcLMMdYFdP/mdsqDzQVl8ZmljY+a9sQDMaMHL7
        eTTQYc+wlVx0E5jmgzHCJDopQggrQy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-vOyOKZFnNse-gxkCvwLgNA-1; Mon, 09 Aug 2021 10:54:50 -0400
X-MC-Unique: vOyOKZFnNse-gxkCvwLgNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 789FB100A614;
        Mon,  9 Aug 2021 14:54:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5F4B78AAF;
        Mon,  9 Aug 2021 14:54:24 +0000 (UTC)
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
Subject: [PATCH 1/2] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
Date:   Mon,  9 Aug 2021 16:53:42 +0200
Message-Id: <20210809145343.97685-2-eesposit@redhat.com>
In-Reply-To: <20210809145343.97685-1-eesposit@redhat.com>
References: <20210809145343.97685-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmcb_check_cr3_cr4 is not called by anyone else, and removing the
call simplifies next patch

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e13357da21e..0ac2d14add15 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -257,27 +257,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
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
@@ -299,7 +278,19 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
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
2.31.1

