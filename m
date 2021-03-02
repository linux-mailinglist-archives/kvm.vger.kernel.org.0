Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7298832B5A1
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381972AbhCCHS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835980AbhCBTfa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJjMpLhEpKR1pWhzoFkmrE5/lb6HEsJ/fHrc7LkNWZQ=;
        b=bXpHS9xjmVLKJDNnYNOXlyYWjn7O6Hye/zKhHDEBkdmZUoDsyDHD/Qy1WnaWeLNQCVAggF
        C4aDho4NrXKJxmefCGGUgD/npY/Al7ILgCOrUbtXW5oPOW3dVnEpAlbf8Q2dq3NC7aWPiG
        v7JkmW6jj4mIwkJn1jy6ah1iDKemE4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-JkNdCSPkM2qIKqmX8UiNnA-1; Tue, 02 Mar 2021 14:33:49 -0500
X-MC-Unique: JkNdCSPkM2qIKqmX8UiNnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAB7518B6141;
        Tue,  2 Mar 2021 19:33:48 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 850C360BFA;
        Tue,  2 Mar 2021 19:33:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 08/23] KVM: nSVM: only copy L1 non-VMLOAD/VMSAVE data in svm_set_nested_state()
Date:   Tue,  2 Mar 2021 14:33:28 -0500
Message-Id: <20210302193343.313318-9-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMLOAD/VMSAVE data is not taken from userspace, since it will
not be restored on VMEXIT (it will be copied from VMCB02 to VMCB01).
For clarity, replace the wholesale copy of the VMCB save area
with a copy of that state only.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 945c2a48b591..585b5aa1914f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -715,7 +715,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
-	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags | X86_EFLAGS_FIXED);
+	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags);
 	svm_set_efer(&svm->vcpu, svm->vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
 	svm_set_cr4(&svm->vcpu, svm->vmcb->save.cr4);
@@ -1250,7 +1250,23 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 	if (svm->current_vmcb == &svm->vmcb01)
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
-	svm->vmcb01.ptr->save = *save;
+
+	svm->vmcb01.ptr->save.es = save->es;
+	svm->vmcb01.ptr->save.cs = save->cs;
+	svm->vmcb01.ptr->save.ss = save->ss;
+	svm->vmcb01.ptr->save.ds = save->ds;
+	svm->vmcb01.ptr->save.gdtr = save->gdtr;
+	svm->vmcb01.ptr->save.idtr = save->idtr;
+	svm->vmcb01.ptr->save.rflags = save->rflags | X86_EFLAGS_FIXED;
+	svm->vmcb01.ptr->save.efer = save->efer;
+	svm->vmcb01.ptr->save.cr0 = save->cr0;
+	svm->vmcb01.ptr->save.cr3 = save->cr3;
+	svm->vmcb01.ptr->save.cr4 = save->cr4;
+	svm->vmcb01.ptr->save.rax = save->rax;
+	svm->vmcb01.ptr->save.rsp = save->rsp;
+	svm->vmcb01.ptr->save.rip = save->rip;
+	svm->vmcb01.ptr->save.cpl = 0;
+
 	nested_load_control_from_vmcb12(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-- 
2.26.2


