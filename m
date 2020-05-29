Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1051E8231
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgE2Ple (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:41:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31833 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727890AbgE2Pjr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCRqK3XvGGUebpbdCpOiBRXW31KmI/ecO4GNeAX0Rdk=;
        b=SS4Xp2dtUA3UcK3r33n52a5gIqHTdMerpmJoE6pdSqk4GZvXeygUZICin7D0u+OAIyGshp
        8K4yKVAMcESkS75BpBPnoJgS6ROAKpL3tG6Goov9gNfU8h5G4rMt63LIbEJU6wXJQjYsHL
        o1rTnqM7cGJ6q6tk2PnfF+CSViI6jxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Wxhp6VV5P8SJFmStEvs7BA-1; Fri, 29 May 2020 11:39:43 -0400
X-MC-Unique: Wxhp6VV5P8SJFmStEvs7BA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD6E8835B46;
        Fri, 29 May 2020 15:39:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650FB78366;
        Fri, 29 May 2020 15:39:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 13/30] KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
Date:   Fri, 29 May 2020 11:39:17 -0400
Message-Id: <20200529153934.11694-14-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 5ca403a69148..fd9742c1a860 100644
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
@@ -419,7 +417,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
 
-	copy_vmcb_control_area(hsave, vmcb);
+	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
 	svm->nested.nested_run_pending = 1;
 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
@@ -550,7 +548,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
-	copy_vmcb_control_area(vmcb, hsave);
+	copy_vmcb_control_area(&vmcb->control, &hsave->control);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
-- 
2.26.2


