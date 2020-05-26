Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A256B1E289E
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389465AbgEZRY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:24:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389364AbgEZRX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDFGStacU6y8BHWos0njpMbsBpxbZ4FiwUoqxBwRu1c=;
        b=Lqsw6BQj8j1l3XRZzwYitNlk+iYdtRSC78t6DrYEYGPH0E96jJV4pqG8c0TmJJ5IRXPaQd
        AmkAotM5PhbiZlo1nuvm5r2f5Dvcc8b60BOt4w7hGpyhSMGUgstkWC0faFUz4zBzn/0OWA
        eqfSppXn8Vo+kiBpg07DQ8zLPTRa0NM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-KitqJE1aPYqCfw_z7RzDMA-1; Tue, 26 May 2020 13:23:55 -0400
X-MC-Unique: KitqJE1aPYqCfw_z7RzDMA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0698CA0C04;
        Tue, 26 May 2020 17:23:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8775D9E7;
        Tue, 26 May 2020 17:23:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 25/28] KVM: nSVM: leave guest mode when clearing EFER.SVME
Date:   Tue, 26 May 2020 13:23:05 -0400
Message-Id: <20200526172308.111575-26-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index a504963ef532..e63e62d12acd 100644
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
index f0da6f0ebf1b..c1e746ccd7da 100644
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


