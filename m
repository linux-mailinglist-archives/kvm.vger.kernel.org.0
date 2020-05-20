Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9761DBB31
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgETRW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32823 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728190AbgETRWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=X41LHQQcKbjTpdXv8eJXDQp0DsQyaAdM+H12qlhM3vA=;
        b=UrkBlrwZv1Vh4bxBl2S0t1mT26OWbd9ayVwow6l7wkVqDCGciTXdQ0YmVsGkm+phOFunBX
        gCxdVhGnt9NLI8tGRQc+orLmmNROp5fIgupoQoOIZ+vWQ2gew1vG0S64uCqE87mCddXBKK
        BV7cxCqcLoRfG3d/WnemcsdvmV1kwuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-JDCW1XAFNv25UkGcl_XfGg-1; Wed, 20 May 2020 13:22:21 -0400
X-MC-Unique: JDCW1XAFNv25UkGcl_XfGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9FBA1902ED3;
        Wed, 20 May 2020 17:22:08 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C47470461;
        Wed, 20 May 2020 17:22:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 18/24] KVM: nSVM: leave guest mode when clearing EFER.SVME
Date:   Wed, 20 May 2020 13:21:39 -0400
Message-Id: <20200520172145.23284-19-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 arch/x86/kvm/svm/svm.c    |  8 ++++++--
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 54a3384a60f8..3e37410d0b94 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -587,6 +587,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
index 6a19cb3e3b1f..09b345892fc9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -265,6 +265,7 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
 
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	vcpu->arch.efer = efer;
 
 	if (!npt_enabled) {
@@ -275,8 +276,11 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			efer &= ~EFER_LME;
 	}
 
-	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
-	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
+	if (!(efer & EFER_SVME))
+		svm_leave_nested(svm);
+
+	svm->vmcb->save.efer = efer | EFER_SVME;
+	mark_dirty(svm->vmcb, VMCB_CR);
 }
 
 static int is_external_interrupt(u32 info)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 73986f96ba2a..4d57270cac3f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -388,6 +388,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb);
+void svm_leave_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.18.2


