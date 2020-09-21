Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487DC27254A
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgIUNT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgIUNT6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 09:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600694396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTVs6wZ7Ib1exBQyAL1+uyq/0LNw24JXNVsOL/OAWA0=;
        b=TG9k5ddcwRFPunvCbPuaOZcrPslY2W9XgD7uOGn6Yihpq9ccUKOMDSTCCefPj7Yg0S0/27
        UwSwHNohg37V4xvIO9U3hh8R2OXEo2HlPRYbxKDSVjrFN65SunQ7yUtYOWd+Yn5I5d9GRY
        RwAteebSPUYW4vlHQ7kHxQsj8PiJYaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-tRjOsUNHPwe015HxQHXMXw-1; Mon, 21 Sep 2020 09:19:54 -0400
X-MC-Unique: tRjOsUNHPwe015HxQHXMXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 197DB1022E2D;
        Mon, 21 Sep 2020 13:19:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 662BB55765;
        Mon, 21 Sep 2020 13:19:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 4/4] KVM: nSVM: implement ondemand allocation of the nested state
Date:   Mon, 21 Sep 2020 16:19:23 +0300
Message-Id: <20200921131923.120833-5-mlevitsk@redhat.com>
In-Reply-To: <20200921131923.120833-1-mlevitsk@redhat.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 arch/x86/kvm/svm/svm.c    | 55 ++++++++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h    |  6 +++++
 3 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 09417f5197410..dd13856818a03 100644
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
+		return -ENOMEM;
+
+	svm->nested.hsave = page_address(hsave_page);
+
+	svm->nested.msrpm = svm_vcpu_init_msrpm();
+	if (!svm->nested.msrpm)
+		goto err_free_hsave;
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
index 18f8af55e970a..a77a95bff7d0a 100644
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
+			 * Free the nested state unless we are in SMM, in which
+			 * case the exit from SVM mode is only for duration of the SMI
+			 * handler
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
@@ -610,7 +629,7 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static u32 *svm_vcpu_init_msrpm(void)
+u32 *svm_vcpu_init_msrpm(void)
 {
 	int i;
 	u32 *msrpm;
@@ -630,7 +649,7 @@ static u32 *svm_vcpu_init_msrpm(void)
 	return msrpm;
 }
 
-static void svm_vcpu_free_msrpm(u32 *msrpm)
+void svm_vcpu_free_msrpm(u32 *msrpm)
 {
 	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
 }
@@ -1204,7 +1223,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
-	struct page *hsave_page;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1215,13 +1233,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1229,15 +1243,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1249,10 +1257,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-error_free_msrpm:
-	svm_vcpu_free_msrpm(svm->msrpm);
-error_free_hsave_page:
-	__free_page(hsave_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1278,10 +1282,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -3964,6 +3968,9 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
+			if (svm_allocate_nested(svm))
+				return 1;
+
 			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
 			kvm_vcpu_unmap(&svm->vcpu, &map, true);
 		}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1e1842de0efe7..10453abc5bed3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,8 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+
+	bool initialized;
 };
 
 struct vcpu_svm {
@@ -339,6 +341,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 u32 svm_msrpm_offset(u32 msr);
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+u32 *svm_vcpu_init_msrpm(void);
+void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void svm_flush_tlb(struct kvm_vcpu *vcpu);
@@ -379,6 +383,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
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

