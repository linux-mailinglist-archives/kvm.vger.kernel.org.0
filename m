Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6111E8230
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgE2Pld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:41:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727900AbgE2Pjr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tbC746Ng7u54CWQHzjQlLztB6tMtOzUCvIu4ZwcdqQ=;
        b=Fq9FTMGV0JDNXzYPfL7edw7aWG46K3Sw1sOd5AI64/nKvOOEYmm1gnknuPANNb8sJq+z0L
        VawREjxWW8cqMHwdtpGtmshGzGrgjvElcCDFAp3mCvqjaozMS4nqRbtjQAl4nO9iTqSRqo
        ihOTbyCp2Md2hgC++mh9lZPnjklsGlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-KnTZSfwQOh6taQDUI-ii9A-1; Fri, 29 May 2020 11:39:42 -0400
X-MC-Unique: KnTZSfwQOh6taQDUI-ii9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B398119057A9;
        Fri, 29 May 2020 15:39:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AAC7A09A5;
        Fri, 29 May 2020 15:39:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 11/30] KVM: nSVM: move MMU setup to nested_prepare_vmcb_control
Date:   Fri, 29 May 2020 11:39:15 -0400
Message-Id: <20200529153934.11694-12-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everything that is needed during nested state restore is now part of
nested_prepare_vmcb_control.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 73be7af79453..a85cc7376a82 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,9 +247,6 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
-	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
-		nested_svm_init_mmu_context(&svm->vcpu);
-
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -263,9 +260,6 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
 	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
-	/* Guest paging mode is active - reset mmu */
-	kvm_mmu_reset_context(&svm->vcpu);
-
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
 	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
@@ -282,6 +276,12 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
+	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+		nested_svm_init_mmu_context(&svm->vcpu);
+
+	/* Guest paging mode is active - reset mmu */
+	kvm_mmu_reset_context(&svm->vcpu);
+
 	svm_flush_tlb(&svm->vcpu);
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-- 
2.26.2


