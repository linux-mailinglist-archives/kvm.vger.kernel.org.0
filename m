Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8851640F70F
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344079AbhIQMFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:05:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344034AbhIQMFE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueh1uvlqpEEU70NwQEmShohJCc2secTfUtevEm9kCBY=;
        b=hJi6mJcrubdD4GJ6Kp48uddG+pqS1LJnZJGCmCPd882Pyfe8GIaJ8LAhOnwyXcmiiks03+
        Yte678igWz2pUjTU2YTJTgFP/sUq4CVzqoEpLAol7tD7UaYt9HBfD3rzwH/cVUCrgK2VIo
        aF9RNNBGsPlCgqqTYfUspUVMb8WZ/ZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Q0CXgUpPOGKitCnJkRsYYA-1; Fri, 17 Sep 2021 08:03:37 -0400
X-MC-Unique: Q0CXgUpPOGKitCnJkRsYYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B15C809CD1;
        Fri, 17 Sep 2021 12:03:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF4421009962;
        Fri, 17 Sep 2021 12:03:33 +0000 (UTC)
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
Subject: [PATCH v2 1/4] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
Date:   Fri, 17 Sep 2021 08:03:26 -0400
Message-Id: <20210917120329.2013766-2-eesposit@redhat.com>
In-Reply-To: <20210917120329.2013766-1-eesposit@redhat.com>
References: <20210917120329.2013766-1-eesposit@redhat.com>
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

