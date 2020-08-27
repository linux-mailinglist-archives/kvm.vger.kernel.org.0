Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F364D254BC5
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgH0RNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:13:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727926AbgH0RMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 13:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598548367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUHpH0p58RXd9F5tC26xxqbPOkXpUxjXrNqrdx4sRqQ=;
        b=gGk0kF3gAZDIF3yrffNGihgrQ6IkBNH/WEqa9gaix1K1Tlb3aiquxahKxLDkcAk45byXKK
        Cy8icqmQyYS5nHvX+On6Yv9j1btdOiuQe0zthzVIOl5IB7Dm5TNt/nE9vX35gHEO4Fh+Pi
        8RhdP+i1GE9nOKm0fWsuhcRc3IixcdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-3ewbowh5ONiXNPbJWTAj_w-1; Thu, 27 Aug 2020 13:12:44 -0400
X-MC-Unique: 3ewbowh5ONiXNPbJWTAj_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 000D418B9EC2;
        Thu, 27 Aug 2020 17:12:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FB795D9E8;
        Thu, 27 Aug 2020 17:12:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 8/8] KVM: nSVM: implement ondemand allocation of the nested state
Date:   Thu, 27 Aug 2020 20:11:45 +0300
Message-Id: <20200827171145.374620-9-mlevitsk@redhat.com>
In-Reply-To: <20200827171145.374620-1-mlevitsk@redhat.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way we don't waste memory on VMs which don't use
nesting virtualization even if it is available to them.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 42 +++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 52 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h    |  6 +++++
 3 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7b1c98826c365..e2f8e94e6b83c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -471,6 +471,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb12 = map.hva;
 
+	if (WARN_ON(!svm->nested.initialized))
+		return 1;
+
 	if (!nested_vmcb_checks(svm, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -686,6 +689,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
index 4c92432e33e27..7ab142ed9c5c0 100644
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
 
-static u32 *svm_vcpu_init_msrpm(void)
+u32 *svm_vcpu_init_msrpm(void)
 {
 	int i;
 	u32 *msrpm;
@@ -630,7 +648,7 @@ static u32 *svm_vcpu_init_msrpm(void)
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
@@ -1209,15 +1222,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1229,10 +1236,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-error_free_msrpm:
-	svm_vcpu_free_msrpm(svm->msrpm);
-error_free_hsave_page:
-	__free_page(hsave_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1258,10 +1261,10 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -3919,6 +3922,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
+			svm_allocate_nested(svm);
 			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
 			kvm_vcpu_unmap(&svm->vcpu, &map, true);
 		}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 468c58a915347..cb9c4a8f26f50 100644
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
+u32 *svm_vcpu_init_msrpm(void);
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

