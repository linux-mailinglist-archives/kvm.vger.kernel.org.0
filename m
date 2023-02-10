Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B17691576
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBJAcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBJAcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA57303F9
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:31:58 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id d11-20020a17090a628b00b0023118d626d5so1700403pjj.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=juCqi+Albnji1zaiiKR3HcTnH91vZKT8inm+htmoAik=;
        b=gs3d0bZuGZxqvCPJzEIFBUXnJOQBkCgsQ+dAE8fItXubGO+6zcIpRcPIRaTxdkO1t1
         0RuquvOafdUZee3vW3OEskw2pHBNQowP01ylnsVqjzEnkJlRMSQAxabRvdHb7s/lIYnU
         FlEAaSO1WzAZTGyuafkbyXoXBfhBxOL9R+qp0Ggua8jW15QDBCroK3sziWNm6PxVS2hg
         uXYKEUjUdhRpGEPu/7wpD3t0qU4+zwp2D03LuRqyiScvn1hLVXEh6JXrqdAlteUOI2vk
         LVQdfIU2uZU0UruQ0vcDvSpklMtLvv/4BSwNCSYfjmfX/om5DxnVbCTtjNPPDZOvr8Wa
         Fmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juCqi+Albnji1zaiiKR3HcTnH91vZKT8inm+htmoAik=;
        b=uQeschFAXIRHfQD+jzLd5nec4xpgxf5egDiXMzqQDGw9bf3gQ9aQ2WmNWvw4tJREx1
         dwRDu3GUhgcfr+99RaA4E0nYrP5Te2Qr/OhC1+M6KLVtK0B399Egfpcc05f56qx9cCrH
         AldPrx3GedUvS6/CuGfm+/CkA3tUS3Uzr9FqV5JliyoqOJUI1PkpWYSykS2rE+2tUjJJ
         9fNqctn8f6DEaoMqPFgmNS+VCSqyK0JEJQZAXvHgrnU/G4FthjiUIEPE+S4JpEI/cHgp
         8ZPuEcFkN2vsbxnmR6CHzJ+8SwDiB3QreGGBzLShj8TWs52T9B3wGD2iZ16GOPikk2Fo
         5sPw==
X-Gm-Message-State: AO0yUKWZfqtXR9wAou5miUFpPRrxKuysWCZ1nrC6gKSPUSGA1XyIijW1
        xdHQi8UU/jKgx2e1ViKG9Y/gyaYhEa8=
X-Google-Smtp-Source: AK7set+yUu/rsqEsNvliQu/mdB4NbjnoXem0Bw8neo24a82OX/TbaC2E5ce3hyRXQAuuqep3vQVMfvdOMB4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b191:b0:194:7c22:1885 with SMTP id
 s17-20020a170902b19100b001947c221885mr3057336plr.26.1675989118117; Thu, 09
 Feb 2023 16:31:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:31 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-5-seanjc@google.com>
Subject: [PATCH v2 04/21] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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
2.39.1.581.gbfd45094c4-goog

