Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD571E8206
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgE2Pjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:39:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727882AbgE2Pjq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wlb/oMG4W+kYrW8nSXiXsnmCAJeQf8FdrtnlRlOHU/Q=;
        b=hAEqBakDcQc9qo8aId3yWBENb7KSZVilmrEXIGRJ5RWQPwrMxro5RkwyqWMCDpi2bq4/gw
        TwDIcgu9QnuVn0PjAlno+Ep2vVqZtlxIEsS1/k8p9CjEM2SYHnQp9J4RIBUAKqi2rOFPOq
        MRqe/k9sqIINIloi+mW/DvMdpXafHgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-m0EWHI5kO7aGMWJpBhN-Sg-1; Fri, 29 May 2020 11:39:43 -0400
X-MC-Unique: m0EWHI5kO7aGMWJpBhN-Sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E22F835B42;
        Fri, 29 May 2020 15:39:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9E9E78366;
        Fri, 29 May 2020 15:39:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 12/30] KVM: nSVM: clean up tsc_offset update
Date:   Fri, 29 May 2020 11:39:16 -0400
Message-Id: <20200529153934.11694-13-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use l1_tsc_offset to compute svm->vcpu.arch.tsc_offset and
svm->vmcb->control.tsc_offset, instead of relying on hsave.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a85cc7376a82..5ca403a69148 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -241,8 +241,6 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 	svm->nested.intercept_dr         = control->intercept_dr;
 	svm->nested.intercept_exceptions = control->intercept_exceptions;
 	svm->nested.intercept            = control->intercept;
-
-	svm->vcpu.arch.tsc_offset += control->tsc_offset;
 }
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
@@ -288,7 +286,8 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *neste
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset + nested_vmcb->control.tsc_offset;
 
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
@@ -553,7 +552,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Restore the original control entries */
 	copy_vmcb_control_area(vmcb, hsave);
 
-	svm->vcpu.arch.tsc_offset = svm->vmcb->control.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset;
+
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-- 
2.26.2


