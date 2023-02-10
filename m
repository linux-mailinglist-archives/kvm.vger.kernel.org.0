Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F3F691571
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBJAcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjBJAb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:31:59 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5742B2597C
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:31:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p202-20020a25d8d3000000b00858a2a2cc15so3488427ybg.21
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eucldSXV9a5xphj/g+7fXk4AWtyJg6Cxj5iwvnUWa+8=;
        b=roWXO+FTDdPfR+Ekt+fGOQKYnHFb/UMtzN+5w1pAUu1FgDsAu/ybD87OWogEBv5CRZ
         iymrfJBVfHA/n6eI4tDBLQfCNL5rYzZMCL9ouvZLjOn8TIYeNYsLiRLDM01uGgh/GqFZ
         5lGLegMFgWy17DEJUtf2xmi/PRnFGdbcP6jdTb6M1Y84L7QKbdMFqJrhNYIpBpKxauJa
         nfhJmjCIwCxqCNOEuKtr3cjAXFryDFPyliyeudyaf17coxLr9Xk3ZAUtaYrYfpzM0h2V
         LKYNvpuONpKkXlrYhT/qdgTY34I6un0LWPUopi10YPpvKImcEtW50J3PHyG7+nY7alix
         F+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eucldSXV9a5xphj/g+7fXk4AWtyJg6Cxj5iwvnUWa+8=;
        b=UZAZGT+4F4NQB+x4m/SIocFgRSRtb0QwNSxgDIjMt3AIX9u3X/GEiyGYctwweiROqU
         2qh/avGWqWFQI5tKtABxxk3ahudtG4SupX3rs0accAUCR10c5Oxa3Uc2Bium8qPtTEti
         lDj5oKV/m7LNvCfogULam1ND03I5U/JQ/YaDZLvWqt0t9tHHs0jdGM6jigcnc/gg4v1N
         d7C/NASMoncMmOx0GYnIJlJyTyafPKhsgma9BB7tzh4C/wllRByj2uSrHEl1ocefrJNm
         UJcJ2FXgCYP6eMqejOenhy8BgygLKIAUCLD7OCH3VJLElC9a9nHQEXN1lOuSsYgw1oz4
         Xytg==
X-Gm-Message-State: AO0yUKUYq1CLofRFfT0n7CbzMs3D+BnKjlaIuDwhmuMQgbiWKDrCBmEv
        tSPDhmgNmYtwZxM3ylfb3Au2zToIKSg=
X-Google-Smtp-Source: AK7set+xfl4rvD/uDp1yogYEOo3AdGu55fLzRd0Kl71cCiw5/Jp+NwyLM2DReGT+967aSjw+ARhxQt7tWUM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:180c:b0:8bd:9c6c:6498 with SMTP id
 cf12-20020a056902180c00b008bd9c6c6498mr53ybb.11.1675989116184; Thu, 09 Feb
 2023 16:31:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:30 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-4-seanjc@google.com>
Subject: [PATCH v2 03/21] KVM: x86: Add macros to track first...last VMX
 feature MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add macros to track the range of VMX feature MSRs that are emulated by
KVM to reduce the maintenance cost of extending the set of emulated MSRs.

Note, KVM doesn't necessarily emulate all known/consumed VMX MSRs, e.g.
PROCBASED_CTLS3 is consumed by KVM to enable IPI virtualization, but is
not emulated as KVM doesn't emulate/virtualize IPI virtualization for
nested guests.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 arch/x86/kvm/x86.h     | 8 ++++++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b43775490074..a5b9ebd6f2c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4107,7 +4107,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47abd9101e68..ee86db130519 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1945,7 +1945,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
@@ -2030,7 +2030,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
@@ -2366,7 +2366,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->msr_ia32_sgxlepubkeyhash
 			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
 		if (!nested_vmx_allowed(vcpu))
@@ -6960,7 +6960,7 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 		 * real mode.
 		 */
 		return enable_unrestricted_guest || emulate_invalid_guest_state;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		return nested;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 	case MSR_AMD64_TSC_RATIO:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 754190af1791..4bc483d082ee 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -40,6 +40,14 @@ void kvm_spurious_fault(void);
 	failed;								\
 })
 
+/*
+ * The first...last VMX feature MSRs that are emulated by KVM.  This may or may
+ * not cover all known VMX MSRs, as KVM doesn't emulate an MSR until there's an
+ * associated feature that KVM supports for nested virtualization.
+ */
+#define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
+#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
+
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
 #define KVM_DEFAULT_PLE_WINDOW_GROW	2
-- 
2.39.1.581.gbfd45094c4-goog

