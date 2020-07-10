Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3723A21B7FD
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgGJOMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41096 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728196AbgGJOMV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 10:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iY42pDstBtt42lmeDfCO3psdFJJnymF8yHT6i8a7Ssc=;
        b=C/HPrIU0Qi1lpASiWNZMbWltdbm/H71AUS7rHBDb08SNRWtMvVRCjF/AZ+vDzAcxZUNKzE
        Blt63PTqFd4gpZeIkoCoiCebQZcozzl8Oro5/HSk7Ee391eS3vaykClO6P2LiY36s1TLKw
        MaDSGVBFc2uY7dOEPxu+UE3nLr1Bb0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-xY9-OyuRP4W_vWg8EuSjnw-1; Fri, 10 Jul 2020 10:12:15 -0400
X-MC-Unique: xY9-OyuRP4W_vWg8EuSjnw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 227B7102C7EC;
        Fri, 10 Jul 2020 14:12:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DC7874F44;
        Fri, 10 Jul 2020 14:12:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/9] KVM: nSVM: introduce nested_svm_load_cr3()/nested_npt_enabled()
Date:   Fri, 10 Jul 2020 16:11:53 +0200
Message-Id: <20200710141157.1640173-6-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparatory change for implementing nested specifig PGD switch for
nSVM (following nVMX' nested_vmx_load_cr3()) instead of relying on
kvm_set_cr3() introduce nested_svm_load_cr3().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e6c988a4e6b..180929f3dbef 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -311,6 +311,21 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 	nested_vmcb->control.exit_int_info = exit_int_info;
 }
 
+static inline bool nested_npt_enabled(struct vcpu_svm *svm)
+{
+	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
+}
+
+/*
+ * Load guest's cr3 at nested entry. @nested_npt is true if we are
+ * emulating VM-Entry into a guest with NPT enabled.
+ */
+static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
+			       bool nested_npt)
+{
+	return kvm_set_cr3(vcpu, cr3);
+}
+
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
 	/* Load the nested guest state */
@@ -324,7 +339,8 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+	(void)nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
+				  nested_npt_enabled(svm));
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
@@ -343,7 +359,8 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
-	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+
+	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(&svm->vcpu);
 
 	/* Guest paging mode is active - reset mmu */
-- 
2.25.4

