Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B1E32B5A9
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382414AbhCCHTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835988AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNatpjb+n7DNrLR6jP5bTK+enSkas3E4ZuMQHMLy71g=;
        b=Zn/HmtO0WYXgKtUbDI3RhfYog3PWPt1lXxPkjM/7IoMvvtYE5QUasEy7NGwZU6BnY6Frf0
        MU9Er+ze3l6yYB9fbFMm6/g+Zx4slDtorlCa7WFpcy3JEeQRVWIovjej2Vs3YVt1KxnZl7
        DXADabMKqKZRmsflOYjfsKwS42biZaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41--375uUIFPPOjRtNviYirrw-1; Tue, 02 Mar 2021 14:33:49 -0500
X-MC-Unique: -375uUIFPPOjRtNviYirrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 698D118B613D;
        Tue,  2 Mar 2021 19:33:48 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12C2260BFA;
        Tue,  2 Mar 2021 19:33:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 07/23] KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit
Date:   Tue,  2 Mar 2021 14:33:27 -0500
Message-Id: <20210302193343.313318-8-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since L1 and L2 now use different VMCBs, most of the fields remain the
same in VMCB02 from one L2 run to the next.  Since KVM itself is not
looking at VMCB12's clean field, for now not much can be optimized.
However, in the future we could avoid more copies if the VMCB12's SEG
and DT sections are clean.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4fc742ba1f1f..945c2a48b591 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -404,24 +404,32 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	svm->vmcb->save.cs = vmcb12->save.cs;
 	svm->vmcb->save.ss = vmcb12->save.ss;
 	svm->vmcb->save.ds = vmcb12->save.ds;
+	svm->vmcb->save.cpl = vmcb12->save.cpl;
+	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
+
 	svm->vmcb->save.gdtr = vmcb12->save.gdtr;
 	svm->vmcb->save.idtr = vmcb12->save.idtr;
+	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
+
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
 	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
 	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
-	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+
+	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
 	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
 	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2;
 	svm->vmcb->save.rax = vmcb12->save.rax;
 	svm->vmcb->save.rsp = vmcb12->save.rsp;
 	svm->vmcb->save.rip = vmcb12->save.rip;
+
 	svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
 	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
-	svm->vmcb->save.cpl = vmcb12->save.cpl;
+	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
@@ -473,12 +481,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	enter_guest_mode(&svm->vcpu);
 
 	/*
-	 * Merge guest and host intercepts - must be called  with vcpu in
-	 * guest-mode to take affect here
+	 * Merge guest and host intercepts - must be called with vcpu in
+	 * guest-mode to take effect.
 	 */
 	recalc_intercepts(svm);
-
-	vmcb_mark_all_dirty(svm->vmcb);
 }
 
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
-- 
2.26.2


