Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F3958AEE7
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 19:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241180AbiHER35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 13:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241032AbiHER3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 13:29:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF1186F7
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 10:29:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 137-20020a250b8f000000b0067a5a14d730so2552962ybl.12
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 10:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=5nd+QHkezC7wDBMujecCebsDnqxzcfp3VqzkbDB+1ZY=;
        b=DnOb8bwV0reEzqOE8dLWn32Z17o+ZPD0gWkotVkH8nAS6CICHPt1fGcC2ElNxJdPQK
         wnb7dFEtlt1+0LPYQ3A367GH31qiMZA9pd2frkidQmgLtLCYGSShnhiPkjUMrEoKcp1Y
         JCHhRtoHKzO/W6iEa2RJBeP8cNZ0UN1oxhKSl8Fc3XvoXbg3zXigmcFeSjpptBgKyZPN
         Rm7xXwAYACIxIFybgTQ8usbzS+7Za0xZDy1f8ivYjwnIq0NVtY9x9VVnb/h9V3CDDSji
         cK8eMa+GIi7M4aZbZ59iQt+YVT6HZjUAsGQuZ4qMpX4BtZ/n/DqTAvSbUVYJUPwXmuht
         5K6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=5nd+QHkezC7wDBMujecCebsDnqxzcfp3VqzkbDB+1ZY=;
        b=aiOGGgeynWZ6wEzpjHLPoi5rKh22cS/BwCYTE2akEFyqSjuO9P99W6mNwvGOnZp8Ms
         8M6po+2d5t+wVxsYvKS6RTTIXs1uSh65reVRAoV9V/YYLeWpnJ3SwOioKTT9Oc4OhEyM
         hLku7gdFP6S7jVt1w2rMupCPfzdc+x/v/oDWkjj8C8yC22d3yTRa505HOculaRvtDYRa
         Zlvf5N3Fbpk6FAjYkRQZ8wok/01Ab9e7A/ENCSbHU4dOESAP8Rm9h1y0zcRPkv9/zTp8
         Z/RpE8SlkkYaVVx/eQr0udxIqi0KLXlnWPfu6WxzzfI1mXyllneWgfmRg4Qh0cAIUPXj
         5lAg==
X-Gm-Message-State: ACgBeo1ZF5BZ99f/MaFV2AjmOuo98NZ7J0C9ITPSiuw7B3I2GtjcQxD1
        ft6tSpxVS/kbhvbTfzcWh7jQelQCPdU=
X-Google-Smtp-Source: AA6agR6FXspFxnD/imEsB3LwRU4R1AlGUQznLhWzTAZ2mHOmrtn7vyMPakxXn/YCpqQ0NP4u6NlmA2MURVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:2f13:0:b0:329:5766:5bb7 with SMTP id
 v19-20020a812f13000000b0032957665bb7mr1974435ywv.391.1659720592290; Fri, 05
 Aug 2022 10:29:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 17:29:44 +0000
In-Reply-To: <20220805172945.35412-1-seanjc@google.com>
Message-Id: <20220805172945.35412-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220805172945.35412-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC PATCH 2/3] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
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

Add VMX MSRs to the runtime list of feature MSRs by iterating over the
range of emulated MSRs instead of manually defining each MSR in the "all"
list.  Using the range definition reduces the cost of emulating a new VMX
MSR, e.g. prevents forgetting to add an MSR to the list.

Extracting the VMX MSRs from the "all" list, which is a compile-time
constant, also shrinks the list to the point where the compiler can
heavily optimize code that iterates over the list.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 53 +++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33560bfa0cac..a1c65b77fb16 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1526,36 +1526,19 @@ static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
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
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
 };
 
-static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
+static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
+			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
 static unsigned int num_msr_based_features;
 
 static u64 kvm_get_arch_capabilities(void)
@@ -6868,6 +6851,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	return r;
 }
 
+static void kvm_proble_feature_msr(u32 msr_index)
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
 static void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
@@ -6954,15 +6949,11 @@ static void kvm_init_msr_list(void)
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
 	}
 
-	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
-		struct kvm_msr_entry msr;
+	for (i = KVM_FIRST_EMULATED_VMX_MSR; i <= KVM_LAST_EMULATED_VMX_MSR; i++)
+		kvm_proble_feature_msr(i);
 
-		msr.index = msr_based_features_all[i];
-		if (kvm_get_msr_feature(&msr))
-			continue;
-
-		msr_based_features[num_msr_based_features++] = msr_based_features_all[i];
-	}
+	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++)
+		kvm_proble_feature_msr(msr_based_features_all_except_vmx[i]);
 }
 
 static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
-- 
2.37.1.559.g78731f0fdb-goog

