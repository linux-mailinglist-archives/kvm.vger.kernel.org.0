Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FE41DBB4B
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgETRWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728007AbgETRWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Jil/RFj0RTK+aVNqnSvLRnL3kfX+SWb+xHtGZMZ+Xnk=;
        b=B+YdVMjsAGav5bo3WwIEkM0QPR3R8FsFuNoK4hKzC55nm4JgHJRIzB6OoqYjDMRKSb2uxp
        aea8bhkmD6A+gbTu0MhXdjP8O5/+9YTdM6nR/JN7fKmgFlVJGomADnOxRRGdDV0Rkm/9nA
        Mk9KGBZ0YNPe+mUpa93RZeNB9PTeGOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-jDjkQTl3OHaL_WsEyO9qWQ-1; Wed, 20 May 2020 13:22:04 -0400
X-MC-Unique: jDjkQTl3OHaL_WsEyO9qWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8ABF106B21C;
        Wed, 20 May 2020 17:21:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 606B160610;
        Wed, 20 May 2020 17:21:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 09/24] KVM: nSVM: clean up tsc_offset update
Date:   Wed, 20 May 2020 13:21:30 -0400
Message-Id: <20200520172145.23284-10-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
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
index 4f81c2196bf6..2aaa539482ae 100644
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
@@ -292,7 +290,8 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *neste
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset + nested_vmcb->control.tsc_offset;
 
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
 	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
@@ -557,7 +556,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Restore the original control entries */
 	copy_vmcb_control_area(vmcb, hsave);
 
-	svm->vcpu.arch.tsc_offset = svm->vmcb->control.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
+		svm->vcpu.arch.l1_tsc_offset;
+
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-- 
2.18.2


