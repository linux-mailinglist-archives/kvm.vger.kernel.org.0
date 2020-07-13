Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D61219CA5
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 11:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGIJzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 05:55:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726302AbgGIJzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 05:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594288531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+QkB6q0IleNCeMNuLc6HQc2fnr/8fIqlOT0WR/KosmA=;
        b=HcqfDFfBs6tycicHFbwh5Xe+dvRIOnT6x5yrg/hLMjPTJy6WHilDFtq2TtmUan5AT5ut2O
        QizsXsg46o5InGUTs8pODg7yoxW26KRZK+YzV/QvMaNlQwH1otvg2ZFe+azMsFF0laKDtl
        ZkOETvcXqQf5MGBAqghzI5xmQap2G7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-kJuyZFEHNp-ZFuzIv0Ac1w-1; Thu, 09 Jul 2020 05:55:27 -0400
X-MC-Unique: kJuyZFEHNp-ZFuzIv0Ac1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E979B1083;
        Thu,  9 Jul 2020 09:55:26 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 965B210013D0;
        Thu,  9 Jul 2020 09:55:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly RFLAGS.VM
Date:   Thu,  9 Jul 2020 05:55:25 -0400
Message-Id: <20200709095525.907771-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD doesn't specify (unlike Intel) that EFER.LME, CR0.PG and
EFER.LMA must be consistent, and for SMM state restore they say that
"The EFER.LMA register bit is set to the value obtained by logically
ANDing the SMRAM values of EFER.LME, CR0.PG, and CR4.PAE".  It turns
out that this is also true for vmentry: the EFER.LMA value in the VMCB
is completely ignored, and so is EFLAGS.VM if the processor is in
long mode or real mode.

Implement these quirks; the EFER.LMA part is needed because svm_set_efer
looks at the LMA bit in order to support EFER.NX=0, while the EFLAGS.VM
part is just because we can.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 402ea5b412f0..1c82a1789e0e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -337,6 +337,24 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
+	u64 efer = nested_vmcb->save.efer;
+
+	/* The processor ignores EFER.LMA, but svm_set_efer needs it.  */
+	efer &= ~EFER_LMA;
+	if ((nested_vmcb->save.cr0 & X86_CR0_PG)
+	    && (nested_vmcb->save.cr4 & X86_CR4_PAE)
+	    && (efer & EFER_LME))
+		efer |= EFER_LMA;
+
+	/*
+	 * Likewise RFLAGS.VM is cleared if inconsistent with other processor
+	 * state.  This is sort-of documented in "10.4 Leaving SMM" but applies
+	 * to SVM as well.
+	 */
+	if (!(nested_vmcb->save.cr0 & X86_CR0_PE)
+	    || (efer & EFER_LMA))
+		nested_vmcb->save.rflags &= ~X86_EFLAGS_VM;
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -345,7 +363,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
 	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
 	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
-	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
+	svm_set_efer(&svm->vcpu, efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
 	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
-- 
2.26.2

