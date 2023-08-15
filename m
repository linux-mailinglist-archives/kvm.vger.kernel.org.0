Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99F77D45E
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbjHOUi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbjHOUiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17506210B
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55c7bb27977so8940542a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131836; x=1692736636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TekLB3os5J/4eT6iwdBNnZ9rD2hON94ASFWDIn1alRU=;
        b=H6GvwrGk+BB0l/EI0GF172Oy1nU5hZOAw8Rvbk3K9BPaCaqP1yJZ65FQSaIVEL/FOH
         GSKXRjZqR9pmrmOEGndDEDv+D7c/TnCg25xjuG8Kb1nsZHOd/4dfhA0S/QKrn2X/adut
         CM933nBNHpsSXpEP4VlJ/f9wGdIcXj4cUW6tZPjUKfpoj+GoyFJaM0nhxk2NslblBr7T
         uaTZuaBiDL/2mzYe5lwBbwspnppSARUDgy39AbLXTl6SUDoyvKv9r64nARAWEKWjIpvB
         Ss34sv/naNdQx8PddpNniSHZzA/dRdvfFQCS/qjREizf6QH9fMjuMhQne8zzlpQb4rO5
         Mstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131836; x=1692736636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TekLB3os5J/4eT6iwdBNnZ9rD2hON94ASFWDIn1alRU=;
        b=A0WM5VEEE4lq3Yt8EuWdi6TgqPEvQR00E8AedwnqnotNWGbJq/uZN+TYm9bqbRlQjr
         8aLCQ5aBe7dhW021ixqJnKBRO4SsM8UCPtza4DrcuDAEMHdL1Hkp8jemCkZq2gWC/V8c
         VXpyqZRb5N3HNP5Qp2Atsl8kByRKjrit31IHOMEo/pHQmeCqpk6J2sTbi6Q9Q33PK9bL
         iHrWrwYIaG9U/kvCNlVQcAluhZ5/vgfZhFQiemLY8VC5hfiAPTHBGKbhreDTz7BYEDEG
         xd9m/6dAc3QspegHrfS6caSUiBSXUZ4CQ43SUyW7nUNXX5XFZ6A4cexDXRShnvw9E0qC
         ReAg==
X-Gm-Message-State: AOJu0Ywd2C3EJXy+jmg++sueBev+g3cu+3HT/jpcaK/kcK7Cbl3ztW6i
        FUrtDQN26xmLSmE5mQXwGWFpeKiWqG4=
X-Google-Smtp-Source: AGHT+IFa1+rQvY3jz+h72qM9pQPWLY1qxdEcfJZja1qdIu3F661j7bDBaAryA40O49aDagrx0u96PRbyO1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8c5b:0:b0:564:2c32:360a with SMTP id
 q27-20020a638c5b000000b005642c32360amr2641629pgn.12.1692131836190; Tue, 15
 Aug 2023 13:37:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:49 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-12-seanjc@google.com>
Subject: [PATCH v3 11/15] KVM: nSVM: Use KVM-governed feature framework to
 track "LBRv enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "LBR virtualization exposed to L1" via a governed feature flag
instead of using a dedicated bit/flag in vcpu_svm.

Note, checking KVM's capabilities instead of the "lbrv" param means that
the code isn't strictly equivalent, as lbrv_enabled could have been set
if nested=false where as that the governed feature cannot.  But that's a
glorified nop as the feature/flag is consumed only by paths that are
gated by nSVM being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/nested.c        | 23 +++++++++++++----------
 arch/x86/kvm/svm/svm.c           |  5 ++---
 arch/x86/kvm/svm/svm.h           |  1 -
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index f01a95fd0071..3a4c0e40e1e0 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -11,6 +11,7 @@ KVM_GOVERNED_X86_FEATURE(VMX)
 KVM_GOVERNED_X86_FEATURE(NRIPS)
 KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
 KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
+KVM_GOVERNED_X86_FEATURE(LBRV)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 24d47ebeb0e0..f50f74b1a04e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -552,6 +552,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	bool new_vmcb12 = false;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	nested_vmcb02_compute_g_pat(svm);
 
@@ -577,18 +578,18 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
-	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
+	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
-	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
+	svm_set_efer(vcpu, svm->nested.save.efer);
 
-	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
-	svm_set_cr4(&svm->vcpu, svm->nested.save.cr4);
+	svm_set_cr0(vcpu, svm->nested.save.cr0);
+	svm_set_cr4(vcpu, svm->nested.save.cr4);
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
-	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
-	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
-	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
+	kvm_rax_write(vcpu, vmcb12->save.rax);
+	kvm_rsp_write(vcpu, vmcb12->save.rsp);
+	kvm_rip_write(vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
 	vmcb02->save.rax = vmcb12->save.rax;
@@ -602,7 +603,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -734,7 +736,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
-	if (svm->lbrv_enabled)
+	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
 		vmcb02->control.virt_ext  |=
 			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
@@ -1065,7 +1067,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_exit_on_intr(svm))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
 	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7cecbb58c60f..de40745bc8a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1032,7 +1032,7 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
 	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
-			   (is_guest_mode(vcpu) && svm->lbrv_enabled &&
+			   (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
 	if (enable_lbrv == current_enable_lbrv)
@@ -4290,8 +4290,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
-
-	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
 
 	/*
 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b3fdaab57363..45cbbdeac3a3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,7 +259,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool lbrv_enabled                 : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
-- 
2.41.0.694.ge786442a9b-goog

