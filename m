Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA310767AAA
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbjG2BSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbjG2BRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E353549F1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbbc4ae328so20393905ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593405; x=1691198205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XWSSoUKucCtT+zh7f53pOsw13W6cMYdZgxKQXI7Ab2I=;
        b=yhlSD1yG1el5nTNdFCwX254jnUkkNYOXgxL3vLVEESLQsoiTYOoBvmAlUHCdWGFKr7
         D6bafPmaPvha3tf+K15xZ7Mxf33c/hOon4+KQtJUGFm2WaesQWQdoVCXaHYPAieARYFU
         dZkSQpl7ZxiGnohoOgKgMpLl0Ix06KpOa2AYEFv++505rIg5haD5FZ4bxDVls6tn9dHE
         bE3KIRAhn4R3bgbpFXdkhywGti73ytsYt3MV1CVcKFc0j5H7oiBOHvbCrLPKDoSWHm3T
         XwrcEmTGkJX2ew9kDZNXmnzPZUjNY8DELPKb/nbkLJQr5igoVMRQbeaeNqPfEZLFQEMd
         JiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593405; x=1691198205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWSSoUKucCtT+zh7f53pOsw13W6cMYdZgxKQXI7Ab2I=;
        b=Zz8vaavZyBuwgEgnOFGvEdCs0NsUDlTQTNqsmNx4ezvWsZpUsHAqWmF6ypmEy/dcoo
         KkQ+A7518GzCuCoDggtfGZnBpXNun8kHUetFEdlOBe91p9XSRHH8p7QAI5E3DzGD4aSP
         kO5alLj3fO20p3K9nulqEwkCFO9djPrk9qadwLCIKa3MMNHBHogAoRHruYw8pejW6Zau
         qRL/tLQO/hw4/kGoMB5yIVb/E2lIxzStE8RslXS8U8B4Hb98sON4krCC3dLypmqtOQh1
         YRx4825RByr5kCT2dbe9X6kUpxRSFuOY8xPz6uRm0ZwQPrFlTxenNX+SIkDcNNGfNkpZ
         HKrA==
X-Gm-Message-State: ABy/qLbkiEvccQsQOQNZJFu+FYX1sLiUt6kBi/ni+NdcZlchoQWeEgP9
        aRqGItdg75EAHYp+27D92x/SDoCOJVo=
X-Google-Smtp-Source: APBJJlGenUF2lXxwYe7mb5+fWTj3m9CTsGfVbaSxOPi6qoSyfGb29NUnLKTaiqJteegpznKNZfBr46pWw9E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e542:b0:1b8:c666:207a with SMTP id
 n2-20020a170902e54200b001b8c666207amr13474plf.9.1690593405592; Fri, 28 Jul
 2023 18:16:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:04 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-18-seanjc@google.com>
Subject: [PATCH v2 17/21] KVM: nSVM: Use KVM-governed feature framework to
 track "LBRv enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
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
 arch/x86/kvm/svm/svm.c           |  7 ++++---
 arch/x86/kvm/svm/svm.h           |  1 -
 4 files changed, 18 insertions(+), 14 deletions(-)

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
index 39a69c1786ea..a83fa6df7c04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -984,9 +984,11 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
 				      LBR_CTL_ENABLE_MASK);
 
-	if (unlikely(is_guest_mode(vcpu) && svm->lbrv_enabled))
+	if (unlikely(is_guest_mode(vcpu) &&
+		     guest_can_use(vcpu, X86_FEATURE_LBRV))) {
 		if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
 			enable_lbrv = true;
+	}
 
 	if (enable_lbrv == current_enable_lbrv)
 		return;
@@ -4221,8 +4223,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
-
-	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
 
 	/*
 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b475241df6dc..0e21823e8a19 100644
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
2.41.0.487.g6d72f3e995-goog

