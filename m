Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1951C88E7
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgEGLux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35129 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbgEGLuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=PfaExeimQuSozD59A7tLBDViigQKEMhsQ3YbIsYE+KU=;
        b=KkZdkpbwEDxti/1rdUv/oLBvrfeX8PXwIHBwq9uNo8rTTYF7OJ9ezaHDHCbdof/ff+Sw91
        1EVqYXckbVRBgxP+4sUdaWCzsXPklSEjz8WSs+QcTsZnbWXxdxFlLatSJ0IhMtWIqXSLV1
        yHdRsZeiLieKuPNRxPDTZ3EjzgB79Po=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-HZcRMLwLOG6CrjBlk_tcug-1; Thu, 07 May 2020 07:50:18 -0400
X-MC-Unique: HZcRMLwLOG6CrjBlk_tcug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA3578015CF;
        Thu,  7 May 2020 11:50:17 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9033F1C933;
        Thu,  7 May 2020 11:50:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 6/9] KVM: nSVM: trap #DB and #BP to userspace if guest debugging is on
Date:   Thu,  7 May 2020 07:50:08 -0400
Message-Id: <20200507115011.494562-7-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1ca939627..adab5b1c5fe1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -608,6 +608,11 @@ static int nested_svm_intercept_db(struct vcpu_svm *svm)
 {
 	unsigned long dr6;
 
+	/* Always catch it and pass it to userspace if debugging the guest.  */
+	if (svm->vcpu.guest_debug &
+	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
+		return NESTED_EXIT_HOST;
+
 	/* if we're not singlestepping, it's not ours */
 	if (!svm->nmi_singlestep)
 		return NESTED_EXIT_DONE;
@@ -682,6 +687,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		if (svm->nested.intercept_exceptions & excp_bits) {
 			if (exit_code == SVM_EXIT_EXCP_BASE + DB_VECTOR)
 				vmexit = nested_svm_intercept_db(svm);
+			else if (exit_code == SVM_EXIT_EXCP_BASE + BP_VECTOR &&
+				 svm->vcpu.guest_debug & KVM_GUESTDBG_USE_SW_BP)
+				vmexit = NESTED_EXIT_HOST;
 			else
 				vmexit = NESTED_EXIT_DONE;
 		}
-- 
2.18.2


