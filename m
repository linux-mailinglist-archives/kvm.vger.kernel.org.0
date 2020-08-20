Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E824B1EC
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHTJPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbgHTJOA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 05:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3WcKnTyZxsyoHj0AlidHgW+F6NjI0StiuW+cJ3VkHhE=;
        b=adhXtOlKbybKQWy7FPTWgND8wtvG9emhhxlU5x5m8+DYrKfRymxphBJbGSvPAhkRw14Z6K
        QoDpkkl4IK0ARaxYCquCjU5BbUtrBy8QCJfyfyBbRWRNSuc2FJ8xk4bWkK4QhTw5xiuJAk
        UYwuns83GXgVaU3N6r+KJ9/dElceePs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-7gEpQJzhOOm8FtDJnzc1DQ-1; Thu, 20 Aug 2020 05:13:53 -0400
X-MC-Unique: 7gEpQJzhOOm8FtDJnzc1DQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 718411074642;
        Thu, 20 Aug 2020 09:13:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FA1B747B0;
        Thu, 20 Aug 2020 09:13:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/8] KVM: nSVM: implement ondemand allocation of the nested state
Date:   Thu, 20 Aug 2020 12:13:24 +0300
Message-Id: <20200820091327.197807-6-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way we don't waste memory on VMs which don't enable
nesting virtualization

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 43 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 62 +++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h    |  6 ++++
 3 files changed, 85 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d9755eab2199..b6704611fc02 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -473,6 +473,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_vmcb = map.hva;
 
+	if (WARN_ON(!svm->nested.initialized))
+		return 1;
+
 	if (!nested_vmcb_checks(svm, nested_vmcb)) {
 		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
 		nested_vmcb->control.exit_code_hi = 0;
@@ -686,6 +689,46 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	return 0;
 }
 
+int svm_allocate_nested(struct vcpu_svm *svm)
+{
+	struct page *hsave_page;
+
+	if (svm->nested.initialized)
+		return 0;
+
+	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!hsave_page)
+		goto free_page1;
+
+	svm->nested.hsave = page_address(hsave_page);
+	clear_page(svm->nested.hsave);
+
+	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
+	if (!svm->nested.msrpm)
+		goto free_page2;
+
+	svm->nested.initialized = true;
+	return 0;
+free_page2:
+	__free_page(hsave_page);
+free_page1:
+	return 1;
+}
+
+void svm_free_nested(struct vcpu_svm *svm)
+{
+	if (!svm->nested.initialized)
+		return;
+
+	svm_vcpu_free_msrpm(svm->nested.msrpm);
+	svm->nested.msrpm = NULL;
+
+	__free_page(virt_to_page(svm->nested.hsave));
+	svm->nested.hsave = NULL;
+
+	svm->nested.initialized = false;
+}
+
 /*
  * Forcibly leave nested mode in order to be able to reset the VCPU later on.
  */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce0773c9a7fa..d941acc36b50 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -266,6 +266,7 @@ static int get_max_npt_level(void)
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 old_efer = vcpu->arch.efer;
 	vcpu->arch.efer = efer;
 
 	if (!npt_enabled) {
@@ -276,14 +277,31 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			efer &= ~EFER_LME;
 	}
 
-	if (!(efer & EFER_SVME)) {
-		svm_leave_nested(svm);
-		svm_set_gif(svm, true);
+	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
+		if (!(efer & EFER_SVME)) {
+			svm_leave_nested(svm);
+			svm_set_gif(svm, true);
+
+			/*
+			 * Free the nested state unless we are in SMM, in which
+			 * case the exit from SVM mode is only for duration of the SMI
+			 * handler
+			 */
+			if (!is_smm(&svm->vcpu))
+				svm_free_nested(svm);
+
+		} else {
+			if (svm_allocate_nested(svm))
+				goto error;
+		}
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 	return 0;
+error:
+	vcpu->arch.efer = old_efer;
+	return 1;
 }
 
 static int is_external_interrupt(u32 info)
@@ -610,7 +628,7 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static u32 *svm_vcpu_alloc_msrpm(void)
+u32 *svm_vcpu_alloc_msrpm(void)
 {
 	int i;
 	u32 *msrpm;
@@ -630,7 +648,7 @@ static u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
-static void svm_vcpu_free_msrpm(u32 *msrpm)
+void svm_vcpu_free_msrpm(u32 *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
 }
@@ -1184,7 +1202,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
-	struct page *hsave_page;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1195,13 +1212,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb_page)
 		goto out;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!hsave_page)
-		goto free_page1;
-
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto free_page2;
+		goto out;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1209,16 +1222,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
 		svm->avic_is_running = true;
 
-	svm->nested.hsave = page_address(hsave_page);
-	clear_page(svm->nested.hsave);
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm)
-		goto free_page2;
-
-	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
-	if (!svm->nested.msrpm)
-		goto free_page3;
+		goto free_page;
 
 	svm->vmcb = page_address(vmcb_page);
 	clear_page(svm->vmcb);
@@ -1231,11 +1237,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-free_page3:
-	svm_vcpu_free_msrpm(svm->msrpm);
-free_page2:
-	__free_page(hsave_page);
-free_page1:
+free_page:
 	__free_page(vmcb_page);
 out:
 	return err;
@@ -1260,10 +1262,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_free_nested(svm);
+
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
-	__free_page(virt_to_page(svm->nested.hsave));
-	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -3912,6 +3914,14 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	vmcb_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
 
 	if (guest) {
+		/*
+		 * This can happen if SVM was not enabled prior to #SMI,
+		 * but guest corrupted the #SMI state and marked it as
+		 * enabled it there
+		 */
+		if (!svm->nested.initialized)
+			return 1;
+
 		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
 			return 1;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ef16f708ed1c..9dca64a2edb5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -97,6 +97,8 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+
+	bool initialized;
 };
 
 struct vcpu_svm {
@@ -349,6 +351,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
+u32 *svm_vcpu_alloc_msrpm(void);
+void svm_vcpu_free_msrpm(u32 *msrpm);
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
@@ -390,6 +394,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			 struct vmcb *nested_vmcb);
 void svm_leave_nested(struct vcpu_svm *svm);
+void svm_free_nested(struct vcpu_svm *svm);
+int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.26.2

