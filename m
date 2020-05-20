Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687891DBB2D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgETRWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728216AbgETRW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=lZ6+W3bZGAYBVzQ44Q5AecbK6sCDrUFzmYj52X2emww=;
        b=GvB36WyCxERgAYuM+onyE58ukO7abeUFb/fqaNAU6ERqmDiVaihvZ8pVus6OojFEhOKldo
        IpRoIs9mYoY1G7KVfbPsFBmx7pI7/MYO9wribphXaTsBN6zbcV4NLGCUGXpQGnIy3Z5GcE
        UCJjAh9W4TB3FRru35TA72iEGPk4JGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-l6M-og0uPU2_iDDsCdYagA-1; Wed, 20 May 2020 13:22:19 -0400
X-MC-Unique: l6M-og0uPU2_iDDsCdYagA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0F7F18FF696;
        Wed, 20 May 2020 17:22:05 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 180B879589;
        Wed, 20 May 2020 17:22:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 16/24] KVM: nSVM: split nested_vmcb_check_controls
Date:   Wed, 20 May 2020 13:21:37 -0400
Message-Id: <20200520172145.23284-17-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The authoritative state does not come from the VMCB once in guest mode,
but KVM_SET_NESTED_STATE can still perform checks on L1's provided SVM
controls because we get them from userspace.

Therefore, split out a function to do them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cbe96a08b080..024e27bebba3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -203,26 +203,31 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vmcb *vmcb)
+static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((vmcb->save.efer & EFER_SVME) == 0)
+	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
-	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
-	    (vmcb->save.cr0 & X86_CR0_NW))
+	if (control->asid == 0)
 		return false;
 
-	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+	if ((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	    !npt_enabled)
 		return false;
 
-	if (vmcb->control.asid == 0)
+	return true;
+}
+
+static bool nested_vmcb_checks(struct vmcb *vmcb)
+{
+	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
-	if ((vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
-	    !npt_enabled)
+	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
+	    (vmcb->save.cr0 & X86_CR0_NW))
 		return false;
 
-	return true;
+	return nested_vmcb_check_controls(&vmcb->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
-- 
2.18.2


