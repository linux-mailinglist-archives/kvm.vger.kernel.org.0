Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E627FE68
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgJALac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732048AbgJALaa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 07:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601551829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ib54Pk9pJal6XPkqcc/GkYx/eMiDtISEHgx5RDDJEIY=;
        b=CB9GKCqHKz07+YXF1EGYX7yWGzbIECJ7VGiB/z5FrA5TPYTJzQKpoe7GHHHr0Hfq62XaUE
        Cw09gFAZ6X7L8t7W+NYiH6qNEcqpabHAO/7QFPV27j8MkKHinCxxJcfC3sdgs8Yix4Vm8V
        XHDwSPGARFHyp6sEDqzcYqxtWMk8wyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-Dn0iuPenMfW_3SG0Dl4S8Q-1; Thu, 01 Oct 2020 07:30:27 -0400
X-MC-Unique: Dn0iuPenMfW_3SG0Dl4S8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9655E80B702;
        Thu,  1 Oct 2020 11:30:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0133E55772;
        Thu,  1 Oct 2020 11:30:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v7 4/4] KVM: nSVM: implement on demand allocation of the nested state
Date:   Thu,  1 Oct 2020 14:29:54 +0300
Message-Id: <20201001112954.6258-5-mlevitsk@redhat.com>
In-Reply-To: <20201001112954.6258-1-mlevitsk@redhat.com>
References: <20201001112954.6258-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way we don't waste memory on VMs which don't use nesting
virtualization even when the host enabled it for them.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 42 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 61 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h    |  8 +++++
 3 files changed, 83 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba50ff6e35c7c..9e4c226dbf7d9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -481,6 +481,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb12 = map.hva;
 
+	if (WARN_ON_ONCE(!svm->nested.initialized))
+		return -EINVAL;
+
 	if (!nested_vmcb_checks(svm, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -698,6 +701,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
+		return -ENOMEM;
+	svm->nested.hsave = page_address(hsave_page);
+
+	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
+	if (!svm->nested.msrpm)
+		goto err_free_hsave;
+	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
+
+	svm->nested.initialized = true;
+	return 0;
+
+err_free_hsave:
+	__free_page(hsave_page);
+	return -ENOMEM;
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
index 57e0f27ff7d20..dc4fe579d460e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -266,6 +266,7 @@ static int get_max_npt_level(void)
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 old_efer = vcpu->arch.efer;
 	vcpu->arch.efer = efer;
 
 	if (!npt_enabled) {
@@ -276,9 +277,27 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
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
+			 * Free the nested guest state, unless we are in SMM.
+			 * In this case we will return to the nested guest
+			 * as soon as we leave SMM.
+			 */
+			if (!is_smm(&svm->vcpu))
+				svm_free_nested(svm);
+
+		} else {
+			int ret = svm_allocate_nested(svm);
+
+			if (ret) {
+				vcpu->arch.efer = old_efer;
+				return ret;
+			}
+		}
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -650,7 +669,7 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
 }
 
-static u32 *svm_vcpu_alloc_msrpm(void)
+u32 *svm_vcpu_alloc_msrpm(void)
 {
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
 	u32 *msrpm;
@@ -664,7 +683,7 @@ static u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
-static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
+void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 {
 	int i;
 
@@ -675,7 +694,8 @@ static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	}
 }
 
-static void svm_vcpu_free_msrpm(u32 *msrpm)
+
+void svm_vcpu_free_msrpm(u32 *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
 }
@@ -1268,7 +1288,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
-	struct page *hsave_page;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1279,13 +1298,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb_page)
 		goto out;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!hsave_page)
-		goto error_free_vmcb_page;
-
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_hsave_page;
+		goto error_free_vmcb_page;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1293,21 +1308,12 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
 		svm->avic_is_running = true;
 
-	svm->nested.hsave = page_address(hsave_page);
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm)
-		goto error_free_hsave_page;
+		goto error_free_vmcb_page;
 
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
-	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
-	if (!svm->nested.msrpm)
-		goto error_free_msrpm;
-
-	/* We only need the L1 pass-through MSR state, so leave vcpu as NULL */
-	svm_vcpu_init_msrpm(vcpu, svm->nested.msrpm);
-
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
 	svm->asid_generation = 0;
@@ -1318,10 +1324,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-error_free_msrpm:
-	svm_vcpu_free_msrpm(svm->msrpm);
-error_free_hsave_page:
-	__free_page(hsave_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1347,10 +1349,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -4038,6 +4040,9 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
+			if (svm_allocate_nested(svm))
+				return 1;
+
 			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
 			kvm_vcpu_unmap(&svm->vcpu, &map, true);
 		}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e7af21e6fe1e0..1d853fe4c778b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -97,6 +97,8 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+
+	bool initialized;
 };
 
 struct vcpu_svm {
@@ -350,6 +352,10 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
+u32 *svm_vcpu_alloc_msrpm(void);
+void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
+void svm_vcpu_free_msrpm(u32 *msrpm);
+
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
@@ -391,6 +397,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
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

