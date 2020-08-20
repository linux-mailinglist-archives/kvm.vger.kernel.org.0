Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7EE24B1E0
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHTJO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:14:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43264 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgHTJOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2GO/ekihvTaQm7HCtkeS85AogNNM/HDnW7xAaWMsro=;
        b=GImhwjeaCMnDz4JLl73oIsHBSgXY0L9Es6iZsft7NvDO7vcVfvjROu8m5XJxfehR8EtKmW
        UiFNlRUtRiRpbX/T29UQQNUpGPQPmvpWtOxH4CnUYHwDmbDKhiGNOJkuLvigA38tEdayuN
        FLLrxVX5BXFXeS75fdvv5hoTJhX+nYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-jdS6GFKRNNedpR9pGK4lMA-1; Thu, 20 Aug 2020 05:14:01 -0400
X-MC-Unique: jdS6GFKRNNedpR9pGK4lMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1856B8030AD;
        Thu, 20 Aug 2020 09:14:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9272747B0;
        Thu, 20 Aug 2020 09:13:56 +0000 (UTC)
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
Subject: [PATCH 7/8] KVM: nSVM: implement caching of nested vmcb save area
Date:   Thu, 20 Aug 2020 12:13:26 +0300
Message-Id: <20200820091327.197807-8-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Soon we will have some checks on the save area and this caching will allow
us to read the guest's vmcb save area once and then use it, thus avoiding
case when a malicious guest changes it after we verified it, but before we
copied parts of it to the main vmcb.

On nested vmexit also sync the updated save state area of the guest,
to the cache, although this is probably overkill.


Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 131 ++++++++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.c    |   6 +-
 arch/x86/kvm/svm/svm.h    |   4 +-
 3 files changed, 97 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c9bb17e9ba11..acc4b26fcfcc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,9 +215,11 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
+static bool nested_vmcb_checks(struct vcpu_svm *svm)
 {
 	bool nested_vmcb_lma;
+	struct vmcb *vmcb = svm->nested.vmcb;
+
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
@@ -263,6 +265,43 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 	svm->nested.vmcb->control.iopm_base_pa  &= ~0x0fffULL;
 }
 
+static void load_nested_vmcb_save(struct vcpu_svm *svm,
+				  struct vmcb_save_area *save)
+{
+	svm->nested.vmcb->save.rflags = save->rflags;
+	svm->nested.vmcb->save.rax    = save->rax;
+	svm->nested.vmcb->save.rsp    = save->rsp;
+	svm->nested.vmcb->save.rip    = save->rip;
+
+	svm->nested.vmcb->save.es  = save->es;
+	svm->nested.vmcb->save.cs  = save->cs;
+	svm->nested.vmcb->save.ss  = save->ss;
+	svm->nested.vmcb->save.ds  = save->ds;
+	svm->nested.vmcb->save.cpl = save->cpl;
+
+	svm->nested.vmcb->save.gdtr = save->gdtr;
+	svm->nested.vmcb->save.idtr = save->idtr;
+
+	svm->nested.vmcb->save.efer = save->efer;
+	svm->nested.vmcb->save.cr3 = save->cr3;
+	svm->nested.vmcb->save.cr4 = save->cr4;
+	svm->nested.vmcb->save.cr0 = save->cr0;
+
+	svm->nested.vmcb->save.cr2 = save->cr2;
+
+	svm->nested.vmcb->save.dr7 = save->dr7;
+	svm->nested.vmcb->save.dr6 = save->dr6;
+
+	svm->nested.vmcb->save.g_pat = save->g_pat;
+}
+
+void load_nested_vmcb(struct vcpu_svm *svm, struct vmcb *nested_vmcb, u64 vmcb_gpa)
+{
+	svm->nested.vmcb_gpa = vmcb_gpa;
+	load_nested_vmcb_control(svm, &nested_vmcb->control);
+	load_nested_vmcb_save(svm, &nested_vmcb->save);
+}
+
 /*
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the nested_vmcb.
@@ -364,31 +403,31 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
+static void nested_prepare_vmcb_save(struct vcpu_svm *svm)
 {
 	/* Load the nested guest state */
-	svm->vmcb->save.es = nested_vmcb->save.es;
-	svm->vmcb->save.cs = nested_vmcb->save.cs;
-	svm->vmcb->save.ss = nested_vmcb->save.ss;
-	svm->vmcb->save.ds = nested_vmcb->save.ds;
-	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
-	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
-	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
-	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
-	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
-	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
-	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
-	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
-	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
+	svm->vmcb->save.es = svm->nested.vmcb->save.es;
+	svm->vmcb->save.cs = svm->nested.vmcb->save.cs;
+	svm->vmcb->save.ss = svm->nested.vmcb->save.ss;
+	svm->vmcb->save.ds = svm->nested.vmcb->save.ds;
+	svm->vmcb->save.gdtr = svm->nested.vmcb->save.gdtr;
+	svm->vmcb->save.idtr = svm->nested.vmcb->save.idtr;
+	kvm_set_rflags(&svm->vcpu, svm->nested.vmcb->save.rflags);
+	svm_set_efer(&svm->vcpu, svm->nested.vmcb->save.efer);
+	svm_set_cr0(&svm->vcpu, svm->nested.vmcb->save.cr0);
+	svm_set_cr4(&svm->vcpu, svm->nested.vmcb->save.cr4);
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = svm->nested.vmcb->save.cr2;
+	kvm_rax_write(&svm->vcpu, svm->nested.vmcb->save.rax);
+	kvm_rsp_write(&svm->vcpu, svm->nested.vmcb->save.rsp);
+	kvm_rip_write(&svm->vcpu, svm->nested.vmcb->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.rax = nested_vmcb->save.rax;
-	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
-	svm->vmcb->save.rip = nested_vmcb->save.rip;
-	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
-	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
-	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+	svm->vmcb->save.rax = svm->nested.vmcb->save.rax;
+	svm->vmcb->save.rsp = svm->nested.vmcb->save.rsp;
+	svm->vmcb->save.rip = svm->nested.vmcb->save.rip;
+	svm->vmcb->save.dr7 = svm->nested.vmcb->save.dr7;
+	svm->vcpu.arch.dr6  = svm->nested.vmcb->save.dr6;
+	svm->vmcb->save.cpl = svm->nested.vmcb->save.cpl;
 }
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
@@ -426,17 +465,13 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	vmcb_mark_all_dirty(svm->vmcb);
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb)
+int enter_svm_guest_mode(struct vcpu_svm *svm)
 {
 	int ret;
-
-	svm->nested.vmcb_gpa = vmcb_gpa;
-	load_nested_vmcb_control(svm, &nested_vmcb->control);
-	nested_prepare_vmcb_save(svm, nested_vmcb);
+	nested_prepare_vmcb_save(svm);
 	nested_prepare_vmcb_control(svm);
 
-	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
+	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.vmcb->save.cr3,
 				  nested_npt_enabled(svm));
 	if (ret)
 		return ret;
@@ -476,7 +511,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	if (WARN_ON(!svm->nested.initialized))
 		return 1;
 
-	if (!nested_vmcb_checks(svm, nested_vmcb)) {
+	load_nested_vmcb(svm, nested_vmcb, vmcb_gpa);
+
+	if (!nested_vmcb_checks(svm)) {
 		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
 		nested_vmcb->control.exit_code_hi = 0;
 		nested_vmcb->control.exit_info_1  = 0;
@@ -485,15 +522,15 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	}
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
-			       nested_vmcb->save.rip,
-			       nested_vmcb->control.int_ctl,
-			       nested_vmcb->control.event_inj,
-			       nested_vmcb->control.nested_ctl);
+			       svm->nested.vmcb->save.rip,
+			       svm->nested.vmcb->control.int_ctl,
+			       svm->nested.vmcb->control.event_inj,
+			       svm->nested.vmcb->control.nested_ctl);
 
-	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
-				    nested_vmcb->control.intercept_cr >> 16,
-				    nested_vmcb->control.intercept_exceptions,
-				    nested_vmcb->control.intercept);
+	trace_kvm_nested_intercepts(svm->nested.vmcb->control.intercept_cr & 0xffff,
+				    svm->nested.vmcb->control.intercept_cr >> 16,
+				    svm->nested.vmcb->control.intercept_exceptions,
+				    svm->nested.vmcb->control.intercept);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
@@ -525,7 +562,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb))
+	if (enter_svm_guest_mode(svm))
 		goto out_exit_err;
 
 	if (nested_svm_vmrun_msrpm(svm))
@@ -632,6 +669,15 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
+	/*
+	 * Write back the nested vmcb state that we just updated
+	 * to the nested vmcb cache to keep it up to date
+	 *
+	 * Note: since CPU might have changed the values we can't
+	 * trust clean bits
+	 */
+	load_nested_vmcb_save(svm, &nested_vmcb->save);
+
 	/* Restore the original control entries */
 	copy_vmcb_control_area(&vmcb->control, &hsave->control);
 
@@ -1191,6 +1237,13 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	load_nested_vmcb_control(svm, &ctl);
 	nested_prepare_vmcb_control(svm);
 
+	/*
+	 * TODO: cached nested guest vmcb data area is not restored, thus
+	 * it will be invalid till nested guest vmexits.
+	 * It shoudn't matter much since the area is not supposed to be
+	 * in sync with cpu anyway while nested guest is running
+	 */
+
 out_set_gif:
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0af51b54c9f5..06668e0f93e7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3904,7 +3904,6 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *nested_vmcb;
 	struct kvm_host_map map;
 	u64 guest;
 	u64 vmcb_gpa;
@@ -3925,8 +3924,9 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
 			return 1;
 
-		nested_vmcb = map.hva;
-		ret = enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
+		load_nested_vmcb(svm, map.hva, vmcb);
+		ret = enter_svm_guest_mode(svm);
+
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1669755f796e..80231ef8de6f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -392,8 +392,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return (svm->nested.vmcb->control.intercept & (1ULL << INTERCEPT_NMI));
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			 struct vmcb *nested_vmcb);
+int enter_svm_guest_mode(struct vcpu_svm *svm);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
@@ -406,6 +405,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
+void load_nested_vmcb(struct vcpu_svm *svm, struct vmcb *nested_vmcb, u64 vmcb_gpa);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
-- 
2.26.2

