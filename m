Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1F7767A97
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbjG2BQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbjG2BQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9547C4220
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba7a32a40so20468625ad.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593382; x=1691198182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w0TB/9gZR8BYEaJuOAquuw9fLoM6MdZQTs9CMG8qcvs=;
        b=3wx3MWt26WL60Xj9bVeqIqNc/cA6K8uIJbOqM0p0ZsGKleZ9VkfwZZcYY37I5uGVNG
         Np8SxBmmoAe8KsDMX66c/MniGkfVg2h0nGEPrNQVBDURGQdlBReM9Hr//TngwzZgzuGt
         E3nFvZTeYp6S3aEMU+cinlpk47lU5hL/Sc+1SgOYkkzm4kSsDp1l+B8Ch1i0zMD3KIx1
         dPTnowq2y6e91DvnbsS1BO4Ef+Ylm60pQmd/OVTFGxDKT/WJahH6rtuZZ+2hk9LbjI/j
         +SbsZieRKrTgkPNIrA9Rw7LOYrGONcI8HUI7T2nAoAQ5DUOL2kIzhXXOkuET13EmXizY
         fAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593382; x=1691198182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0TB/9gZR8BYEaJuOAquuw9fLoM6MdZQTs9CMG8qcvs=;
        b=gTPCKOId+j0GtubbVNlQ4919vRpdB1965UwbhrO/sYZyNK/fpdhkOnsjzO6jaYTt3a
         BGhe86Au9BnP6D1V6ThymZQofVKXWLg+Tya8vaHYJKm9DpOKGltdoJhpaCUn1cA9xd0K
         3pJRiANeGPFe4sIAhHNwlJ1Dv45BVNavEupaJQda4g9RUOKrl94TdQne9Fslq1EEULfd
         Vi7fxftNJaG/1S4Y4mHHXJ05YpYbfKg0gxlX40med5c+yEZ1ZiO+vMgcxAW3ATq0T71p
         Mou+zf6W4sJ6RxgTcknvxk5RVA8il4TED1KeUcZrdbLXIJg5GhWcTv7ecRyx0DZyY9zH
         53BQ==
X-Gm-Message-State: ABy/qLbee59AAJjmAI0K6Yqrz+kZmsvaAciBg6dxHm1ctvpOhDML6BCV
        MZ4rrAUonq0okT/2QZuYj90+JeRgYUQ=
X-Google-Smtp-Source: APBJJlFMGbsg9Sun7CSyWqpqMOUHosQ3ioKPE+f/pWq2XPuG2v86lsp7Rjsxz9Ltt5B0ZZ4qkGRyJ52Wi9U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac4:b0:1bb:91c9:d334 with SMTP id
 q4-20020a170902dac400b001bb91c9d334mr11559plx.0.1690593382395; Fri, 28 Jul
 2023 18:16:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:52 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-6-seanjc@google.com>
Subject: [PATCH v2 05/21] KVM: x86: Always write vCPU's current TSC
 offset/ratio in vendor hooks
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

Drop the @offset and @multiplier params from the kvm_x86_ops hooks for
propagating TSC offsets/multipliers into hardware, and instead have the
vendor implementations pull the information directly from the vCPU
structure.  The respective vCPU fields _must_ be written at the same
time in order to maintain consistent state, i.e. it's not random luck
that the value passed in by all callers is grabbed from the vCPU.

Explicitly grabbing the value from the vCPU field in SVM's implementation
in particular will allow for additional cleanup without introducing even
more subtle dependencies.  Specifically, SVM can skip the WRMSR if guest
state isn't loaded, i.e. svm_prepare_switch_to_guest() will load the
correct value for the vCPU prior to entering the guest.

This also reconciles KVM's handling of related values that are stored in
the vCPU, as svm_write_tsc_offset() already assumes/requires the caller
to have updated l1_tsc_offset.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm/nested.c       | 4 ++--
 arch/x86/kvm/svm/svm.c          | 8 ++++----
 arch/x86/kvm/svm/svm.h          | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 8 ++++----
 arch/x86/kvm/x86.c              | 5 ++---
 6 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..dad9331c5270 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1654,8 +1654,8 @@ struct kvm_x86_ops {
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
 	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
-	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
-	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu);
+	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu);
 
 	/*
 	 * Retrieve somewhat arbitrary exit information.  Intended to
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5d5a1d7832fb..3342cc4a5189 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1103,7 +1103,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (kvm_caps.has_tsc_control &&
 	    vcpu->arch.tsc_scaling_ratio != vcpu->arch.l1_tsc_scaling_ratio) {
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
-		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+		svm_write_tsc_multiplier(vcpu);
 	}
 
 	svm->nested.ctl.nested_cr3 = 0;
@@ -1536,7 +1536,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
 	vcpu->arch.tsc_scaling_ratio =
 		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
 					       svm->tsc_ratio_msr);
-	svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+	svm_write_tsc_multiplier(vcpu);
 }
 
 /* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9fc5e402636a..c786c8e9108f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1097,19 +1097,19 @@ static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return svm->tsc_ratio_msr;
 }
 
-static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+static void svm_write_tsc_offset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb01.ptr->control.tsc_offset = vcpu->arch.l1_tsc_offset;
-	svm->vmcb->control.tsc_offset = offset;
+	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	__svm_write_tsc_multiplier(multiplier);
+	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 	preempt_enable();
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7132c0a04817..5829a1801862 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -658,7 +658,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
+void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..ca6194b0e35e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1884,14 +1884,14 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return kvm_caps.default_tsc_scaling_ratio;
 }
 
-static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu)
 {
-	vmcs_write64(TSC_OFFSET, offset);
+	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
 }
 
-static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
-	vmcs_write64(TSC_MULTIPLIER, multiplier);
+	vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..5a14378ed4e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2615,7 +2615,7 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 	else
 		vcpu->arch.tsc_offset = l1_offset;
 
-	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
+	static_call(kvm_x86_write_tsc_offset)(vcpu);
 }
 
 static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
@@ -2631,8 +2631,7 @@ static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multipli
 		vcpu->arch.tsc_scaling_ratio = l1_multiplier;
 
 	if (kvm_caps.has_tsc_control)
-		static_call(kvm_x86_write_tsc_multiplier)(
-			vcpu, vcpu->arch.tsc_scaling_ratio);
+		static_call(kvm_x86_write_tsc_multiplier)(vcpu);
 }
 
 static inline bool kvm_check_tsc_unstable(void)
-- 
2.41.0.487.g6d72f3e995-goog

