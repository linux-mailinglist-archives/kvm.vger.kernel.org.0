Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4392121A29C
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgGIOya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728086AbgGIOy1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 10:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RDP7UWXzptqztnR4mRMBKSTx9BUceM8HzJkwE6PwPM=;
        b=h6+xrb1vjgTVhOPEWSzQOGjB5dO7VMZkCouKjRTxTARddelcCBXRg2VhZVJNiJSPvePi4P
        GfEfD8aoYD+taUVZEFGV3L2TZR+pjRRitTWuk8nwQ5CZZvByYutsSBaSWvXikutoHUa1ZV
        k4MNWi0D8dyceYXkzbJJCU/CMxMSI6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-RnTv1b5SPhKpgcv-2drM8A-1; Thu, 09 Jul 2020 10:54:22 -0400
X-MC-Unique: RnTv1b5SPhKpgcv-2drM8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55F4680040A;
        Thu,  9 Jul 2020 14:54:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C21756106A;
        Thu,  9 Jul 2020 14:54:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/9] KVM: nSVM: introduce nested_svm_load_cr3()
Date:   Thu,  9 Jul 2020 16:53:54 +0200
Message-Id: <20200709145358.1560330-6-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparatory change for implementing nested specifig PGD switch for
nSVM (following nVMX' nested_vmx_load_cr3()) instead of relying on
kvm_set_cr3() introduce nested_svm_load_cr3().

The only intended functional change for now is that errors from
kvm_set_cr3() are propagated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e6c988a4e6b..d0fd63e8d835 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -311,8 +311,25 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
 	nested_vmcb->control.exit_int_info = exit_int_info;
 }
 
-static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
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
+static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+{
+	int ret = 0;
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -324,7 +341,9 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+
+	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
+				  nested_npt_enabled(svm));
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
@@ -338,12 +357,14 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
 	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+
+	return ret;
 }
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
-	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(&svm->vcpu);
 
 	/* Guest paging mode is active - reset mmu */
@@ -382,9 +403,15 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
+	int ret;
+
 	svm->nested.vmcb = vmcb_gpa;
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
-	nested_prepare_vmcb_save(svm, nested_vmcb);
+
+	ret = nested_prepare_vmcb_save(svm, nested_vmcb);
+	if (ret)
+		return ret;
+
 	nested_prepare_vmcb_control(svm);
 
 	svm_set_gif(svm, true);
-- 
2.25.4

