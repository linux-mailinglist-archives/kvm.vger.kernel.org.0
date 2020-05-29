Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA21E8221
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgE2Pkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727963AbgE2Pjw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPV+Aa6xGRPwk8+MPjto3CGci/1N6Jz7M5KOwcV4nr8=;
        b=AJ3fec4zXomFXo3sF1uZctS+Sfwo6kaT2db8Qm34vzu3HTrCN2JLAoH5NdyAvWuT3ScnGY
        yCbVuS2G7e4C22e+VTAqDIJaGu3y31Reoe6wrBCDGCmMLZppqF9K73rCWVDG6bSKhUe2nA
        S3Le5n1Vg64jV5FxoTu7jZN7pZgPleQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-tEvdIAp9PV2gjl6WeUcuOQ-1; Fri, 29 May 2020 11:39:49 -0400
X-MC-Unique: tEvdIAp9PV2gjl6WeUcuOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2112835B41;
        Fri, 29 May 2020 15:39:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CF6B10013C2;
        Fri, 29 May 2020 15:39:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 25/30] KVM: nSVM: leave guest mode when clearing EFER.SVME
Date:   Fri, 29 May 2020 11:39:29 -0400
Message-Id: <20200529153934.11694-26-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the AMD manual, the effect of turning off EFER.SVME while a
guest is running is undefined.  We make it leave guest mode immediately,
similar to the effect of clearing the VMX bit in MSR_IA32_FEAT_CTL.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 10 ++++++++--
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bd3a89cd4070..369eca73fe3e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -618,6 +618,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	return 0;
 }
 
+/*
+ * Forcibly leave nested mode in order to be able to reset the VCPU later on.
+ */
+void svm_leave_nested(struct vcpu_svm *svm)
+{
+	if (is_guest_mode(&svm->vcpu)) {
+		struct vmcb *hsave = svm->nested.hsave;
+		struct vmcb *vmcb = svm->vmcb;
+
+		svm->nested.nested_run_pending = 0;
+		leave_guest_mode(&svm->vcpu);
+		copy_vmcb_control_area(&vmcb->control, &hsave->control);
+		nested_svm_uninit_mmu_context(&svm->vcpu);
+	}
+}
+
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 offset, msr, value;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bc08221f6743..b4db9a980469 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -265,6 +265,7 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
 
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	vcpu->arch.efer = efer;
 
 	if (!npt_enabled) {
@@ -275,8 +276,13 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			efer &= ~EFER_LME;
 	}
 
-	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
-	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
+	if (!(efer & EFER_SVME)) {
+		svm_leave_nested(svm);
+		svm_set_gif(svm, true);
+	}
+
+	svm->vmcb->save.efer = efer | EFER_SVME;
+	mark_dirty(svm->vmcb, VMCB_CR);
 }
 
 static int is_external_interrupt(u32 info)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be8e830f83fa..6ac4c00a5d82 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -389,6 +389,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb);
+void svm_leave_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.26.2


