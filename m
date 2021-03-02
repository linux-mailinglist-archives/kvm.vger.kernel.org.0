Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1D32B5A4
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382096AbhCCHTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835978AbhCBTfb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZewj6CIc33keuphrKruOk2K8sZC5QpkynnS2eOBaTU=;
        b=ZF/PeKWN467ya6pvH6BWgGPQCPY0a4Ds1iiwpeQevpv2AxEp/teDVvCpNlokj4VrQNBG/V
        PZzIHBphGDYjdfzuiBHsc8B63MX0KF8zUJFhrxVSEvF48uEtVx1Z/zLiP/8/5drRMnHvjb
        mGXVWCnN5AA6Z/crSeerH5s2vCy6XTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-YW8KCrKvPtaJtHkLxagDWg-1; Tue, 02 Mar 2021 14:33:48 -0500
X-MC-Unique: YW8KCrKvPtaJtHkLxagDWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 048E3107ACF4;
        Tue,  2 Mar 2021 19:33:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1E9260BFA;
        Tue,  2 Mar 2021 19:33:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 04/23] KVM: nSVM: rename functions and variables according to vmcbXY nomenclature
Date:   Tue,  2 Mar 2021 14:33:24 -0500
Message-Id: <20210302193343.313318-5-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that SVM is using a separate vmcb01 and vmcb02 (and also uses the vmcb12
naming) we can give clearer names to functions that write to and read
from those VMCBs.  Likewise, variables and parameters can be renamed
from nested_vmcb to vmcb12.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 28 ++++++++++++++--------------
 arch/x86/kvm/svm/svm.c    | 14 +++++++-------
 arch/x86/kvm/svm/svm.h    |  5 ++---
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3bbb4acdf956..4d136465dee1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -274,8 +274,8 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	return nested_vmcb_check_controls(&vmcb12->control);
 }
 
-static void load_nested_vmcb_control(struct vcpu_svm *svm,
-				     struct vmcb_control_area *control)
+static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
+					    struct vmcb_control_area *control)
 {
 	copy_vmcb_control_area(&svm->nested.ctl, control);
 
@@ -287,9 +287,9 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 
 /*
  * Synchronize fields that are written by the processor, so that
- * they can be copied back into the nested_vmcb.
+ * they can be copied back into the vmcb12.
  */
-void sync_nested_vmcb_control(struct vcpu_svm *svm)
+void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 {
 	u32 mask;
 	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
@@ -317,8 +317,8 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
  * Transfer any event that L0 or L1 wanted to inject into L2 to
  * EXIT_INT_INFO.
  */
-static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
-					   struct vmcb *vmcb12)
+static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
+						struct vmcb *vmcb12)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u32 exit_int_info = 0;
@@ -395,7 +395,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
-static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	nested_vmcb02_compute_g_pat(svm);
 
@@ -424,7 +424,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	svm->vmcb->save.cpl = vmcb12->save.cpl;
 }
 
-static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 
@@ -486,11 +486,11 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
 	nested_svm_vmloadsave(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
-	load_nested_vmcb_control(svm, &vmcb12->control);
+	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_prepare_vmcb_control(svm);
-	nested_prepare_vmcb_save(svm, vmcb12);
+	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
 				  nested_npt_enabled(svm));
@@ -653,7 +653,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.exit_info_2       = vmcb->control.exit_info_2;
 
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
-		nested_vmcb_save_pending_event(svm, vmcb12);
+		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
 	if (svm->nrips_enabled)
 		vmcb12->control.next_rip  = vmcb->control.next_rip;
@@ -1225,11 +1225,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (svm->current_vmcb == &svm->vmcb01)
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 	svm->vmcb01.ptr->save = *save;
-	load_nested_vmcb_control(svm, ctl);
+	nested_load_control_from_vmcb12(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 
-	nested_prepare_vmcb_control(svm);
+	nested_vmcb02_prepare_control(svm);
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa1baf646ff0..e7fcd92551e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2122,7 +2122,7 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 
 static int vmload_interception(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb;
+	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	int ret;
 
@@ -2136,11 +2136,11 @@ static int vmload_interception(struct vcpu_svm *svm)
 		return 1;
 	}
 
-	nested_vmcb = map.hva;
+	vmcb12 = map.hva;
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
+	nested_svm_vmloadsave(vmcb12, svm->vmcb);
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	return ret;
@@ -2148,7 +2148,7 @@ static int vmload_interception(struct vcpu_svm *svm)
 
 static int vmsave_interception(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb;
+	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	int ret;
 
@@ -2162,11 +2162,11 @@ static int vmsave_interception(struct vcpu_svm *svm)
 		return 1;
 	}
 
-	nested_vmcb = map.hva;
+	vmcb12 = map.hva;
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
+	nested_svm_vmloadsave(svm->vmcb, vmcb12);
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	return ret;
@@ -3947,7 +3947,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->next_rip = 0;
 	if (is_guest_mode(&svm->vcpu)) {
-		sync_nested_vmcb_control(svm);
+		nested_sync_control_from_vmcb02(svm);
 		svm->nested.nested_run_pending = 0;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 993155195212..f6cad4b20d80 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -437,8 +437,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			 struct vmcb *nested_vmcb);
+int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa, struct vmcb *vmcb12);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
@@ -450,7 +449,7 @@ int nested_svm_check_permissions(struct vcpu_svm *svm);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
-void sync_nested_vmcb_control(struct vcpu_svm *svm);
+void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
-- 
2.26.2


