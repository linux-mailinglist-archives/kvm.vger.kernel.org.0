Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09395395C2
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346749AbiEaR6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239219AbiEaR6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AB837356A
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654019924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0yvmTc+va7v0gJ9E75BePB+PuwLz7P/ysZIrz/OtMrE=;
        b=L/PbU2lHUzrmq4lS9IbmCjHpar+Tn00Q40zeYSvGtFojPecbUKSt109UDrgioZFDZESn4F
        PTX9VVln3pWL/vjaQXh6oFFTnwWt984+ALZ7dFUeWD52s+/fvpTZ+cvReRfQHepIz+Ynv7
        CRoHKiuFihfTay6ZaydPuGVM6Q7rQmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-5WHS6iSOPR2ZC3znAz-5_A-1; Tue, 31 May 2022 13:58:43 -0400
X-MC-Unique: 5WHS6iSOPR2ZC3znAz-5_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 986E2101AA45;
        Tue, 31 May 2022 17:58:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7582E492C3B;
        Tue, 31 May 2022 17:58:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: SVM: fix nested PAUSE filtering when L0 intercepts PAUSE
Date:   Tue, 31 May 2022 13:58:37 -0400
Message-Id: <20220531175837.295988-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0
doesn't intercept PAUSE") introduced passthrough support for nested pause
filtering, (when the host doesn't intercept PAUSE) (either disabled with
kvm module param, or disabled with '-overcommit cpu-pm=on')

Before this commit, L1 KVM didn't intercept PAUSE at all; afterwards,
the feature was exposed as supported by KVM cpuid unconditionally, thus
if L1 could try to use it even when the L0 KVM can't really support it.

In this case the fallback caused KVM to intercept each PAUSE instruction;
in some cases, such intercept can slow down the nested guest so much
that it can fail to boot.  Instead, before the problematic commit KVM
was already setting both thresholds to 0 in vmcb02, but after the first
userspace VM exit shrink_ple_window was called and would reset the
pause_filter_count to the default value.

To fix this, change the fallback strategy - ignore the guest threshold
values, but use/update the host threshold values unless the guest
specifically requests disabling PAUSE filtering (either simple or
advanced).

Also fix a minor bug: on nested VM exit, when PAUSE filter counter
were copied back to vmcb01, a dirty bit was not set.

Thanks a lot to Suravee Suthikulpanit for debugging this!

Fixes: 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE")
Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Co-developed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220518072709.730031-1-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 39 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c    |  4 ++--
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6d0233a2469e..88da8edbe1e1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -642,6 +642,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	u32 pause_count12;
+	u32 pause_thresh12;
 
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -721,27 +723,25 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
+	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
+	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
 	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
-		/* use guest values since host doesn't use them */
-		vmcb02->control.pause_filter_count =
-				svm->pause_filter_enabled ?
-				svm->nested.ctl.pause_filter_count : 0;
+		/* use guest values since host doesn't intercept PAUSE */
+		vmcb02->control.pause_filter_count = pause_count12;
+		vmcb02->control.pause_filter_thresh = pause_thresh12;
 
-		vmcb02->control.pause_filter_thresh =
-				svm->pause_threshold_enabled ?
-				svm->nested.ctl.pause_filter_thresh : 0;
-
-	} else if (!vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
-		/* use host values when guest doesn't use them */
+	} else {
+		/* start from host values otherwise */
 		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
 		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
-	} else {
-		/*
-		 * Intercept every PAUSE otherwise and
-		 * ignore both host and guest values
-		 */
-		vmcb02->control.pause_filter_count = 0;
-		vmcb02->control.pause_filter_thresh = 0;
+
+		/* ... but ensure filtering is disabled if so requested.  */
+		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
+			if (!pause_count12)
+				vmcb02->control.pause_filter_count = 0;
+			if (!pause_thresh12)
+				vmcb02->control.pause_filter_thresh = 0;
+		}
 	}
 
 	nested_svm_transition_tlb_flush(vcpu);
@@ -1003,8 +1003,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	if (!kvm_pause_in_guest(vcpu->kvm) && vmcb02->control.pause_filter_count)
+	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
+		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
+
+	}
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1bd42e7dfa36..4aea82f668fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -956,7 +956,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+	if (kvm_pause_in_guest(vcpu->kvm))
 		return;
 
 	control->pause_filter_count = __grow_ple_window(old,
@@ -977,7 +977,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm) || !old)
+	if (kvm_pause_in_guest(vcpu->kvm))
 		return;
 
 	control->pause_filter_count =
-- 
2.31.1

