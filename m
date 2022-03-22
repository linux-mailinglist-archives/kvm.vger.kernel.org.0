Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2353F4E4550
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbiCVRmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239817AbiCVRmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 358748CDBF
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647970865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Gx3OZjbJEGNju3jC5LiJovVmBrlwEsjowZeisGHWak=;
        b=GcIzhVGTi9xLT51e8v0Q6V5s25SXVYnsmf4eySoUdYQnvtLHD2vIfBw8igLFoz+6mO9pT9
        jo/GHufrrErDW2BwRzecqpm7VpN0P2mkT3/tbRacwvuSlztI/UHF2Jm+88qmqTovi+daby
        dW7QjrKFrGLuzCJRYHZ7NPIKsWiB/VA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-mWOVEwG2OJOvvkATRwQiuQ-1; Tue, 22 Mar 2022 13:41:02 -0400
X-MC-Unique: mWOVEwG2OJOvvkATRwQiuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A04A8833959;
        Tue, 22 Mar 2022 17:41:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 714A1C07F4B;
        Tue, 22 Mar 2022 17:40:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 2/6] KVM: x86: nSVM: implement nested LBR virtualization
Date:   Tue, 22 Mar 2022 19:40:46 +0200
Message-Id: <20220322174050.241850-3-mlevitsk@redhat.com>
In-Reply-To: <20220322174050.241850-1-mlevitsk@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This was tested with kvm-unit-test that was developed
for this purpose.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c    |  7 +++++++
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 98647f5dec93..c1baa3a68ce6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -588,8 +588,17 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK))
+	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		/* Copy LBR related registers from vmcb12,
+		 * but make sure that we only pick LBR enable bit from the guest.
+		 */
+		svm_copy_lbrs(vmcb02, vmcb12);
+		vmcb02->save.dbgctl &= LBR_CTL_ENABLE_MASK;
+		svm_update_lbrv(&svm->vcpu);
+
+	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(vmcb02, vmcb01);
+	}
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
@@ -651,6 +660,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
+	if (svm->lbrv_enabled)
+		vmcb02->control.virt_ext  |=
+			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
@@ -919,7 +931,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		svm_copy_lbrs(vmcb12, vmcb02);
+		svm_update_lbrv(vcpu);
+	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
 		svm_copy_lbrs(vmcb01, vmcb02);
 		svm_update_lbrv(vcpu);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b3ba3bf2d95e..ec9a1dabdcc3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -878,6 +878,10 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
 				      LBR_CTL_ENABLE_MASK);
 
+	if (unlikely(is_guest_mode(vcpu) && svm->lbrv_enabled))
+		if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
+			enable_lbrv = true;
+
 	if (enable_lbrv == current_enable_lbrv)
 		return;
 
@@ -4012,6 +4016,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
 
 	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
+	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
 
 	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
@@ -4765,6 +4770,8 @@ static __init void svm_set_cpu_caps(void)
 
 		if (vls)
 			kvm_cpu_cap_set(X86_FEATURE_V_VMSAVE_VMLOAD);
+		if (lbrv)
+			kvm_cpu_cap_set(X86_FEATURE_LBRV);
 
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 75373cb24a39..aaf46b1fbf76 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -236,6 +236,7 @@ struct vcpu_svm {
 	bool nrips_enabled                : 1;
 	bool tsc_scaling_enabled          : 1;
 	bool v_vmload_vmsave_enabled      : 1;
+	bool lbrv_enabled                 : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.26.3

