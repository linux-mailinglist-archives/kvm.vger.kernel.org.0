Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF269B63B
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjBQXKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjBQXKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:10:32 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105E56855E
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o8-20020a17090a0a0800b0023699c4353eso353010pjo.6
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Jv7eFJCQHJdShrZad4wg6qbhczS1BO2S26DrILrvWfg=;
        b=PFHXa5FBY+a98Z9yhWweF+SxDQQJFEMs/DEpJGFZxDfSIxf44H5vOl3VOmkB5k/UXL
         U3qRSMbobqQF16A/BVrXRskJUiV2o0dTn/LKHqc9U2JijMlZ4cxm9EioE+Ge1KjSeugJ
         ILLisMTKa/AFV865ZWzsbS1JSwkmuPn6yF7z18WK9tugVUsjbEiBPGQNPv3f5dQabJPH
         /nHNy9lxyEQQezs5pqgLJcaAPGgIepldgdv4CCVkTaRmLij2029pBnXCp7ZCf2MZjXZo
         OawdxxDdwOLXn91PoeKTV+UXRw0EChPxEAp31Vk9jO5/uqniV2CbcKYWBO31lsjoM89w
         lebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jv7eFJCQHJdShrZad4wg6qbhczS1BO2S26DrILrvWfg=;
        b=DgPsqX/H2pGBEOITcUk2V79ICfX562CRXe0G1XwKsQaFNOqm/gzp9gbUVqBh9pZiDP
         z0LtxA+YKAO0T5SSU3mfWXFUyerc0iw4YlkB2Z+YUmnWeleLSjrOhMrMSSppyAMB/JKd
         pWoL704OjnH1aDp1DQafaUF/JRDLswU8FCScaaBIxSnAn+MO5gwdORIkEcmc2zuuUgOx
         164RfibR0PF1pcuHqGKQgi6BqruDLX/kTP+ih6nrwzX0WSmp4sT/kBZHJ4QCwyXPoMVV
         1gjHLv3UF1GbAq3Tx1twduzasbX6CvWA8iqxKtTImOk6opwpdHr9Gj8WkFZTfEzwfy35
         ahfg==
X-Gm-Message-State: AO0yUKVYn4aR6WUS1lsANXgNYv4K1ujkKuwu8IAUwkuYJQVm2uzQHnSO
        bKn8aM1qoXcW/cxx6zCVVJa4WhM6sm4=
X-Google-Smtp-Source: AK7set/aRqzoIGn2r6hKGdQL2yk7USvE3Z3o494g7U9jz+D7bYJ70gxPWaaOqXWw6886u2sgHjajnJplNP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab0e:b0:19b:c29:3932 with SMTP id
 ik14-20020a170902ab0e00b0019b0c293932mr427871plb.3.1676675430051; Fri, 17 Feb
 2023 15:10:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:12 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-3-seanjc@google.com>
Subject: [PATCH 02/12] KVM: x86/mmu: Use KVM-governed feature framework to
 track "GBPAGES enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Use the governed feature framework to track whether or not the guest can
use 1GiB pages, and drop the one-off helper that wraps the surprisingly
non-trivial logic surrounding 1GiB page usage in the guest.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c             | 16 ++++++++++++++++
 arch/x86/kvm/governed_features.h |  2 ++
 arch/x86/kvm/mmu/mmu.c           | 20 +++-----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 013fdc27fc8f..3b604499c35c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -337,6 +337,22 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.governed_features.enabled = 0;
 
+	/*
+	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
+	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
+	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
+	 * walk for performance and complexity reasons.  Not to mention KVM
+	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
+	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
+	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
+	 * If TDP is disabled, honor guest CPUID as KVM has full visibility and
+	 * can install smaller shadow pages if the host lacks 1GiB support.
+	 */
+	if (!tdp_enabled)
+		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_GBPAGES);
+	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
+
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 40ce8e6608cd..b29c15d5e038 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -5,5 +5,7 @@ BUILD_BUG()
 
 #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
 
+KVM_GOVERNED_X86_FEATURE(GBPAGES)
+
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..36e4561554ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4728,28 +4728,13 @@ __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 	}
 }
 
-static bool guest_can_use_gbpages(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
-	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
-	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
-	 * walk for performance and complexity reasons.  Not to mention KVM
-	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
-	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
-	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
-	 */
-	return tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
-			     guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
-}
-
 static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *context)
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
 				context->cpu_role.base.level, is_efer_nx(context),
-				guest_can_use_gbpages(vcpu),
+				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
 }
@@ -4826,7 +4811,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->root_role.level,
 				context->root_role.efer_nx,
-				guest_can_use_gbpages(vcpu), is_pse, is_amd);
+				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
+				is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
-- 
2.39.2.637.g21b0678d19-goog

