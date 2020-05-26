Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E88B1E28AB
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389513AbgEZRZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389192AbgEZRXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckMDI9BFwuRNDxnJTMIWYnDb9LBkqe0U2657m4saxOg=;
        b=PRlUc6OQfNwpb0B+RhDqpIHcPPTtl4VRDCLXnipJLUa+b6AsNwCne5M9wfYNWruruLR14m
        9T03eeNb7mzljEI/iUlm0S7phec8lDMwmTvBuBPwTexSOkSQCPygtslExBVSIO8m3Tcs6/
        4IUte/kfWXJTVBSS24ExNV+81oG1/ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-OmZ1dbyVNqq9nzkAD8sRVw-1; Tue, 26 May 2020 13:23:22 -0400
X-MC-Unique: OmZ1dbyVNqq9nzkAD8sRVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B67511855A1A;
        Tue, 26 May 2020 17:23:21 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FC0F5C1D6;
        Tue, 26 May 2020 17:23:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 13/28] KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
Date:   Tue, 26 May 2020 13:22:53 -0400
Message-Id: <20200526172308.111575-14-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 5a9d131a153e..0dfd9c8c2ca7 100644
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


