Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A991DBB46
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgETRX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728088AbgETRWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=kz4tq35xt3C9g7L/W0gZ+sTXPcxeT9hQCry1awKznYk=;
        b=LhZnCDQ0rS+MYEubeJ7ljtVKn2fMVuACn3gbGPpw0HsmkvnYHttuEIfu/tP99exFZ5B4fb
        UMlxVHxYD7ODEI06966t7ZRmLib0xYDlp3JL4Pv1qvjZJZZCMyTwkWXuIwSiHnGGKWZlmA
        Hm7Z0XT5L3Hhty2zsBjDl1O0eY6zHUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-ruZB3uBTOGegCc9Ea_tGXQ-1; Wed, 20 May 2020 13:22:08 -0400
X-MC-Unique: ruZB3uBTOGegCc9Ea_tGXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DADF8B5E70;
        Wed, 20 May 2020 17:21:59 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C9479C3F;
        Wed, 20 May 2020 17:21:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 10/24] KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
Date:   Wed, 20 May 2020 13:21:31 -0400
Message-Id: <20200520172145.23284-11-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will come in handy when we put a struct vmcb_control_area in
svm->nested.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2aaa539482ae..c759124ed6af 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -141,11 +141,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept |= g->intercept;
 }
 
-static void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
+static void copy_vmcb_control_area(struct vmcb_control_area *dst,
+				   struct vmcb_control_area *from)
 {
-	struct vmcb_control_area *dst  = &dst_vmcb->control;
-	struct vmcb_control_area *from = &from_vmcb->control;
-
 	dst->intercept_cr         = from->intercept_cr;
 	dst->intercept_dr         = from->intercept_dr;
 	dst->intercept_exceptions = from->intercept_exceptions;
@@ -423,7 +421,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
 
-	copy_vmcb_control_area(hsave, vmcb);
+	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
 	svm->nested.nested_run_pending = 1;
 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
@@ -554,7 +552,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
-	copy_vmcb_control_area(vmcb, hsave);
+	copy_vmcb_control_area(&vmcb->control, &hsave->control);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
-- 
2.18.2


