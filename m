Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEF326D8A4
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgIQKRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:17:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgIQKR2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 06:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600337839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aiEYNjtrGt6f4jYGmJw7mmp+FjkbPI3kAnfeKkvGY8c=;
        b=FXcKsHEkz1pM6erm2Qyv43NwZ5+igwdLM1ldUeMEWBnDzrJrH9tXl+SIiPTLYFJpAghPii
        Vi0SjqU/m7a6clrlfTnxFemY5e19entQpjSZOeAp9R3RCtBJNrgQl/Y2B1u8h1kKMtDiEf
        F4VxIOkYss/maSDxBv6zup0DVvuKrCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-FAqVycjDOSWFSI9iMYQGVg-1; Thu, 17 Sep 2020 06:11:04 -0400
X-MC-Unique: FAqVycjDOSWFSI9iMYQGVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 568371084C98;
        Thu, 17 Sep 2020 10:11:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B044C101416F;
        Thu, 17 Sep 2020 10:10:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the nested state
Date:   Thu, 17 Sep 2020 13:10:48 +0300
Message-Id: <20200917101048.739691-3-mlevitsk@redhat.com>
In-Reply-To: <20200917101048.739691-1-mlevitsk@redhat.com>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way we don't waste memory on VMs which don't use
nesting virtualization even if it is available to them.

If allocation of nested state fails (which should happen,
only when host is about to OOM anyway), use new KVM_REQ_OUT_OF_MEMORY
request to shut down the guest

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 54 ++++++++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h    |  7 +++++
 3 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 09417f5197410..fe119da2ef836 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -467,6 +467,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb12 = map.hva;
 
+	if (WARN_ON(!svm->nested.initialized))
+		return 1;
+
 	if (!nested_vmcb_checks(svm, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -684,6 +687,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	return 0;
 }
 
+int svm_allocate_nested(struct vcpu_svm *svm)
+{
+	struct page *hsave_page;
+
+	if (svm->nested.initialized)
+		return 0;
+
+	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!hsave_page)
+		goto error;
+
+	svm->nested.hsave = page_address(hsave_page);
+
+	svm->nested.msrpm = svm_vcpu_init_msrpm();
+	if (!svm->nested.msrpm)
+		goto err_free_hsave;
+
+	svm->nested.initialized = true;
+	return 0;
+err_free_hsave:
+	__free_page(hsave_page);
+error:
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
index 3da5b2f1b4a19..57ea4407dcf09 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -266,6 +266,7 @@ static int get_max_npt_level(void)
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 old_efer = vcpu->arch.efer;
 	vcpu->arch.efer = efer;
 
 	if (!npt_enabled) {
@@ -276,9 +277,26 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
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
+			if (svm_allocate_nested(svm)) {
+				vcpu->arch.efer = old_efer;
+				kvm_make_request(KVM_REQ_OUT_OF_MEMORY, vcpu);
+				return;
+			}
+		}
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -609,7 +627,7 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static u32 *svm_vcpu_init_msrpm(void)
+u32 *svm_vcpu_init_msrpm(void)
 {
 	int i;
 	u32 *msrpm;
@@ -629,7 +647,7 @@ static u32 *svm_vcpu_init_msrpm(void)
 	return msrpm;
 }
 
-static void svm_vcpu_free_msrpm(u32 *msrpm)
+void svm_vcpu_free_msrpm(u32 *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
 }
@@ -1203,7 +1221,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
-	struct page *hsave_page;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1214,13 +1231,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb_page)
 		goto out;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!hsave_page)
-		goto error_free_vmcb_page;
-
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_hsave_page;
+		goto out;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1228,15 +1241,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
 		svm->avic_is_running = true;
 
-	svm->nested.hsave = page_address(hsave_page);
-
 	svm->msrpm = svm_vcpu_init_msrpm();
 	if (!svm->msrpm)
-		goto error_free_hsave_page;
-
-	svm->nested.msrpm = svm_vcpu_init_msrpm();
-	if (!svm->nested.msrpm)
-		goto error_free_msrpm;
+		goto error_free_vmcb_page;
 
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
@@ -1248,10 +1255,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-error_free_msrpm:
-	svm_vcpu_free_msrpm(svm->msrpm);
-error_free_hsave_page:
-	__free_page(hsave_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1277,10 +1280,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -3963,6 +3966,9 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
+			if (svm_allocate_nested(svm))
+				return 1;
+
 			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
 			kvm_vcpu_unmap(&svm->vcpu, &map, true);
 		}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 45496775f0db2..3bee16e1f2e73 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,8 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+
+	bool initialized;
 };
 
 struct vcpu_svm {
@@ -338,6 +340,9 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
+u32 *svm_vcpu_init_msrpm(void);
+void svm_vcpu_free_msrpm(u32 *msrpm);
+
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
@@ -379,6 +384,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
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

