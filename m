Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3F6B56F8
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjCKAqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCKAqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:46:33 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D72D13D1F9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mp16-20020a17090b191000b0023ab4b5b064so3352591pjb.9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bjAmlz3HqB+H+MWnUu8RY7jRVQBDjdxPFlGV9NdkjQ0=;
        b=rEdsF7x730kYSTxUbNW+tTzBPVv37BkIJ4qZ6LT+f1AEjjskZKSd6bbHZ22kmA5Ie2
         zzLz+FWczoChypB6ChImJDDEmhyfJYNW9O9VKb1dWcymfeXQFhhvs7RZBlti6Oy2arZc
         Bjw1Xh1rvkPuQg5Ry1UV3G033HXiyU5+MDRKvuutgDAHEQhoKEBOhwZVBm4qGJSlhxel
         kV8wfoBNtyOk4tTR+8/0L74dWhsq+WwCMNyHfFO1w5lvBGZXmXasatDUbZHhqejDuWjT
         CKKykn0Vgv8CZ+A0OUZI+PDYlUeG/2CT2cw2Uo03g04S3zGiuj+PdtLcfMsL8v3GDLTQ
         sFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjAmlz3HqB+H+MWnUu8RY7jRVQBDjdxPFlGV9NdkjQ0=;
        b=KI5+0fmPt+T9HkuH6/AgZq9SKdWkAfUEAicR8TTOQ6yH/lJzseYHMa0WBPx+PQX9Ig
         mEg03Wd666qb14W/3WYdSESwfQU3S7Jo1CLTdKsVo+y9inOq2ljFiOpj10byitETyxta
         wdQSrVcHbEfenGL77mSh7c2Pq2r8bxxmxoKWb/F69mKfYd7Z68LrDiW+kFXp40Q9YwPw
         /6QyrKllHQLcif2I8aMgsQ5qlhXExt5r365iX00NJ+/VxkZG7hG9AZk/tkK22y4g+qH0
         EXxjXV5y1xIpkjvn3uzsdoqTkTdqA6JxVCc2rftC34sSAXU1DO6zmRjCczJXaMjo0GJ2
         bvJg==
X-Gm-Message-State: AO0yUKVk5TT0pa2oVVCM0Zw700/O6XvGAXzAG+wFn3dbECb2X0CF25pp
        l9HZCRMOaHUWtICHN9pSKn0ZWEFoqYU=
X-Google-Smtp-Source: AK7set99+kCypvapzRp6HXB60/UBcb3nXr34N4jI+Zgyl8MDz4bjb8ECHz+5Pl0Vo8jOvp/Eu1/vwwz+pxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7fcd:b0:19a:7bd4:5b0d with SMTP id
 t13-20020a1709027fcd00b0019a7bd45b0dmr10328292plb.8.1678495589646; Fri, 10
 Mar 2023 16:46:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:01 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-5-seanjc@google.com>
Subject: [PATCH v3 04/21] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add VMX MSRs to the runtime list of feature MSRs by iterating over the
range of emulated MSRs instead of manually defining each MSR in the "all"
list.  Using the range definition reduces the cost of emulating a new VMX
MSR, e.g. prevents forgetting to add an MSR to the list.

Extracting the VMX MSRs from the "all" list, which is a compile-time
constant, also shrinks the list to the point where the compiler can
heavily optimize code that iterates over the list.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 53 +++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b91f73a837d..7b73a0b45041 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1539,36 +1539,19 @@ static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
 static unsigned num_emulated_msrs;
 
 /*
- * List of msr numbers which are used to expose MSR-based features that
- * can be used by a hypervisor to validate requested CPU features.
+ * List of MSRs that control the existence of MSR-based features, i.e. MSRs
+ * that are effectively CPUID leafs.  VMX MSRs are also included in the set of
+ * feature MSRs, but are handled separately to allow expedited lookups.
  */
-static const u32 msr_based_features_all[] = {
-	MSR_IA32_VMX_BASIC,
-	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
-	MSR_IA32_VMX_PINBASED_CTLS,
-	MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
-	MSR_IA32_VMX_PROCBASED_CTLS,
-	MSR_IA32_VMX_TRUE_EXIT_CTLS,
-	MSR_IA32_VMX_EXIT_CTLS,
-	MSR_IA32_VMX_TRUE_ENTRY_CTLS,
-	MSR_IA32_VMX_ENTRY_CTLS,
-	MSR_IA32_VMX_MISC,
-	MSR_IA32_VMX_CR0_FIXED0,
-	MSR_IA32_VMX_CR0_FIXED1,
-	MSR_IA32_VMX_CR4_FIXED0,
-	MSR_IA32_VMX_CR4_FIXED1,
-	MSR_IA32_VMX_VMCS_ENUM,
-	MSR_IA32_VMX_PROCBASED_CTLS2,
-	MSR_IA32_VMX_EPT_VPID_CAP,
-	MSR_IA32_VMX_VMFUNC,
-
+static const u32 msr_based_features_all_except_vmx[] = {
 	MSR_AMD64_DE_CFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
 };
 
-static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
+static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
+			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
 static unsigned int num_msr_based_features;
 
 /*
@@ -6996,6 +6979,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	return r;
 }
 
+static void kvm_probe_feature_msr(u32 msr_index)
+{
+	struct kvm_msr_entry msr = {
+		.index = msr_index,
+	};
+
+	if (kvm_get_msr_feature(&msr))
+		return;
+
+	msr_based_features[num_msr_based_features++] = msr_index;
+}
+
 static void kvm_probe_msr_to_save(u32 msr_index)
 {
 	u32 dummy[2];
@@ -7097,15 +7092,11 @@ static void kvm_init_msr_lists(void)
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
 	}
 
-	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
-		struct kvm_msr_entry msr;
+	for (i = KVM_FIRST_EMULATED_VMX_MSR; i <= KVM_LAST_EMULATED_VMX_MSR; i++)
+		kvm_probe_feature_msr(i);
 
-		msr.index = msr_based_features_all[i];
-		if (kvm_get_msr_feature(&msr))
-			continue;
-
-		msr_based_features[num_msr_based_features++] = msr_based_features_all[i];
-	}
+	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++)
+		kvm_probe_feature_msr(msr_based_features_all_except_vmx[i]);
 }
 
 static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
-- 
2.40.0.rc1.284.g88254d51c5-goog

