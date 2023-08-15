Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8101A77D44A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbjHOUht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbjHOUhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D909C1FF9
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589f986ab8aso42915797b3.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131819; x=1692736619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WBkpDKr6jj4NzlnIGGdQVal1P0a3ByasoO5IEWSIJRE=;
        b=PohXGEt5p5Gq1eWQMfSEBAlCwCuyTp0UUAhPLRCgxqzUZpMgn02SBiu69mZXoWEq3y
         3ZvimOOCTpl9ZMhcK/3SP14PXFtJl02TzytZHA5VrIs+SxLBlTFJAtkwxwpIszrGxQyG
         ypiMSggFd6oqDl5CNl8HLMEeTp//ytZeEG1RV4iGa4fPCPfUUtGX76EHoruSxAd6waDS
         ilzsqaA+xcc1M22yoAx/4E9Y8WyWUj4ZXujOWv2hnid1bWf9iyRpweqgXAUtIzCFl8Gx
         Dpe/2zsa44Nj5cfs9qPSwK98v6C+6XwIl5ozo3wSr2dw9S7RFD0Ka0T65AiEf9w6pykt
         7jiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131819; x=1692736619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBkpDKr6jj4NzlnIGGdQVal1P0a3ByasoO5IEWSIJRE=;
        b=bTEQzOluBd/HPVmKA9yoaTNHL8oRXo1bLYWHYLyZPqkBejtIgq9nbbkO0RXZUvobL3
         jY9CVBamNrPXTfsRk2Ii8NPG82AE/DvYh4rnCPOsAmr9XjjjKEACjHHDhXRz7vhBBbQh
         jZVK3w0ubE/Uq11hsZEUD7t7yAhGdoBlavUzF9IosJIsxfkjzEKxnm+AlXvgnTuO+C+r
         dGFfMNaZd6eqSJTQKhubWJ675WDulyYBfUqMtI8JeMVkEvy2ylNGcA9O7gKc1Rt4qlpo
         cN9AP8qb9dlwDYpmT29bcT0xTTwYfhlrcxu6Kbc21O/W5Oqtrig8juQzAHiFgHibLOup
         LsBQ==
X-Gm-Message-State: AOJu0YzLY+hQOnhCaOuUnKrPCZ9XkfdGCooTkw0OLh9N8yWNCABrAi7J
        p79wI2pBc5HdaQedZ2ZD5xaxs+pozvQ=
X-Google-Smtp-Source: AGHT+IEsB6TpySeJzscsreqlViYCX5OPRs/9V0pFq6s7NBXcybCVD+S+fZLYmnQdMHuHjRmXkoZYZ4UlaF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3013:b0:576:e268:903d with SMTP id
 ey19-20020a05690c301300b00576e268903dmr48638ywb.2.1692131819462; Tue, 15 Aug
 2023 13:36:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:40 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-3-seanjc@google.com>
Subject: [PATCH v3 02/15] KVM: x86/mmu: Use KVM-governed feature framework to
 track "GBPAGES enabled"
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

Use the governed feature framework to track whether or not the guest can
use 1GiB pages, and drop the one-off helper that wraps the surprisingly
non-trivial logic surrounding 1GiB page usage in the guest.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c             | 17 +++++++++++++++++
 arch/x86/kvm/governed_features.h |  2 ++
 arch/x86/kvm/mmu/mmu.c           | 20 +++-----------------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4ba43ae008cb..67e9f79fe059 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -312,11 +312,28 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
+	bool allow_gbpages;
 
 	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
 	bitmap_zero(vcpu->arch.governed_features.enabled,
 		    KVM_MAX_NR_GOVERNED_FEATURES);
 
+	/*
+	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
+	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
+	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
+	 * walk for performance and complexity reasons.  Not to mention KVM
+	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
+	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
+	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
+	 * If TDP is disabled, honor *only* guest CPUID as KVM has full control
+	 * and can install smaller shadow pages if the host lacks 1GiB support.
+	 */
+	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
+				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
+	if (allow_gbpages)
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
index 5bdda75bfd10..9e4cd8b4a202 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4779,28 +4779,13 @@ static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
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
@@ -4877,7 +4862,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->root_role.level,
 				context->root_role.efer_nx,
-				guest_can_use_gbpages(vcpu), is_pse, is_amd);
+				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
+				is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
-- 
2.41.0.694.ge786442a9b-goog

