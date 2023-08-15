Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA04277D45A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbjHOUiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbjHOUhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761E21FCC
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:24 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a55650so10751314a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131828; x=1692736628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1duX83tLmXfiLKauPTdlHGvRHH3JeEZ5FTf3herZaZE=;
        b=QpNAmErgTRq2z9Gp6bhI4e6jfzejGkr1DdynDPOyqX9+ZnBlf6jEqHo26msKm07rH2
         E3Aq0pgkEa2oIw5XajX2PGuJa7pEfakNkLXMo1L5B6LimOk0LZG73f7ou1+bzOSViXkr
         qpB6V2xxMAooAX2b9N5MGb4A7eL2GP9CUstAZUnRJAFquQ7sC6dIu0TNSpzLg4GZgyUj
         vIKIxtdfMBfwFhIgR+dejI7yY2QKMzJTkfP5Z6sfR844u48wCPFXppAiMX29ixWdkG4N
         Bn/uNY2Ut5X4LEr88AG2HGrkDZVs4TvGx3EmU1QOVg6uIenRXAGScnpeo2iY6goopDAH
         KOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131828; x=1692736628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1duX83tLmXfiLKauPTdlHGvRHH3JeEZ5FTf3herZaZE=;
        b=ZdNHVTBaBhBACodEAL/XQkZ7Ze1YPiXltIJuwdrNmytyFcHwjr/sIfQSvBfQXC0eps
         5vl99Wko+8vTJwZH7PDBjwv6Mlc9PfkoezofpnsX10uDmfwXpGjNDD9IP5Hmdrx6lrHX
         5wASTK6xX536ohFcP8FbyBC+n/DQYQod9YHxnzSKweMmOKQkhG/zo7IiNMMzvEpcHmtu
         DhRTcRRojew1C9wB0MMgvDIstaRXYLTgHCdYBrvx0G0G/NAxvAlhlIZOY7M9qWBc5vjy
         roXJfSKlXcxtiyGI1mStgDPT72kDTLwoOQPaEfTA2IEQonvSxUjqenR59VEayHIV0U+s
         fOtQ==
X-Gm-Message-State: AOJu0YyumwS0msh8c+Q9cogi23cmx11HMHE36WxpOGyi6oXxZjmsdFs2
        mJAfBiZiL3JWQhG93P/jmmIsYp2ehSI=
X-Google-Smtp-Source: AGHT+IEMC/zrqnzdAGz3ZCpbaGOXEyE5htuOnagBejjoIzBtPK/VEk+z7v1PvsJGo72sX2Oa2uV282ZaIVo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a512:b0:269:4286:3496 with SMTP id
 a18-20020a17090aa51200b0026942863496mr3062078pjq.9.1692131828211; Tue, 15 Aug
 2023 13:37:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:45 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-8-seanjc@google.com>
Subject: [PATCH v3 07/15] KVM: nVMX: Use KVM-governed feature framework to
 track "nested VMX enabled"
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

Track "VMX exposed to L1" via a governed feature flag instead of using a
dedicated helper to provide the same functionality.  The main goal is to
drive convergence between VMX and SVM with respect to querying features
that are controllable via module param (SVM likes to cache nested
features), avoiding the guest CPUID lookups at runtime is just a bonus
and unlikely to provide any meaningful performance benefits.

No functional change intended.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/vmx/nested.c        |  7 ++++---
 arch/x86/kvm/vmx/vmx.c           | 21 ++++++---------------
 arch/x86/kvm/vmx/vmx.h           |  1 -
 4 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index b896a64e4ac3..22446614bf49 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -7,6 +7,7 @@ BUILD_BUG()
 
 KVM_GOVERNED_X86_FEATURE(GBPAGES)
 KVM_GOVERNED_X86_FEATURE(XSAVES)
+KVM_GOVERNED_X86_FEATURE(VMX)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 22e08d30baef..c5ec0ef51ff7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6426,7 +6426,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	vmx = to_vmx(vcpu);
 	vmcs12 = get_vmcs12(vcpu);
 
-	if (nested_vmx_allowed(vcpu) &&
+	if (guest_can_use(vcpu, X86_FEATURE_VMX) &&
 	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
 		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
 		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
@@ -6567,7 +6567,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
 			return -EINVAL;
 	} else {
-		if (!nested_vmx_allowed(vcpu))
+		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
 			return -EINVAL;
 
 		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
@@ -6601,7 +6601,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
-		(!nested_vmx_allowed(vcpu) || !vmx->nested.enlightened_vmcs_enabled))
+	    (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
+	     !vmx->nested.enlightened_vmcs_enabled))
 			return -EINVAL;
 
 	vmx_leave_nested(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6314ca32a5cf..caeb415eb5a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1908,17 +1908,6 @@ static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 	vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 }
 
-/*
- * nested_vmx_allowed() checks whether a guest should be allowed to use VMX
- * instructions and MSRs (i.e., nested VMX). Nested VMX is disabled for
- * all guests if the "nested" module option is off, and can also be disabled
- * for a single guest by disabling its VMX cpuid bit.
- */
-bool nested_vmx_allowed(struct kvm_vcpu *vcpu)
-{
-	return nested && guest_cpuid_has(vcpu, X86_FEATURE_VMX);
-}
-
 /*
  * Userspace is allowed to set any supported IA32_FEATURE_CONTROL regardless of
  * guest CPUID.  Note, KVM allows userspace to set "VMX in SMX" to maintain
@@ -2046,7 +2035,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
 		break;
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
-		if (!nested_vmx_allowed(vcpu))
+		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
 			return 1;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				    &msr_info->data))
@@ -2354,7 +2343,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
-		if (!nested_vmx_allowed(vcpu))
+		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
@@ -7750,13 +7739,15 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
+
 	vmx_setup_uret_msrs(vmx);
 
 	if (cpu_has_secondary_exec_ctrls())
 		vmcs_set_secondary_exec_control(vmx,
 						vmx_secondary_exec_control(vmx));
 
-	if (nested_vmx_allowed(vcpu))
+	if (guest_can_use(vcpu, X86_FEATURE_VMX))
 		vmx->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
@@ -7765,7 +7756,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
-	if (nested_vmx_allowed(vcpu))
+	if (guest_can_use(vcpu, X86_FEATURE_VMX))
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cde902b44d97..c2130d2c8e24 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -374,7 +374,6 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
-bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			struct loaded_vmcs *buddy);
 int allocate_vpid(void);
-- 
2.41.0.694.ge786442a9b-goog

