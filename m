Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34781767A9F
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbjG2BRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbjG2BQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65F949EC
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584126c65d1so29402387b3.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593388; x=1691198188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OeX+CuubSaKKTeg9YUHiYCwLGztaZPXmiwSd5vwTnGo=;
        b=tczXnxVR/+BbWdcXZzl16Zjac9Ua038CcCQZlGqLyrjqqJA8FnbTg//UO8FJYiqmLY
         bTheeO1XRmDgq5B0p1UTPzDHqUoZePinMfEwTVlLSLupYGg3UtaMSrQDuZLMBmksB1kY
         /ZibaeRhEWniSleStOuqcs+QbMglMUexLC3HWcSWhg+imS8D1XTSRDYw4VIGfDXngXiF
         yA0MLBkGp6BTuyJco3d6fa58/C31vKQ9PpcZId1xL2u3XuuFJTkdwby9axhAZX5MSkMf
         On5p9uy1VV3x+9bGcxgT7AO/fPmQ/vrmqcVD70Oe05qaAKI7xSOLVWDn9TNpD53phozU
         DXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593388; x=1691198188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OeX+CuubSaKKTeg9YUHiYCwLGztaZPXmiwSd5vwTnGo=;
        b=BhS43nymZhHCNCE3TCYN9/pS2S0DwGsP/UpxqjuJIk889p2fS56zRcgJmi1+ICWUv6
         mzlKx8odD01X7wJgi1ad+Tlv0iVEHRXZXu2KiPaxXa9B4EnHMuMHfL3FQ78SgEUXuS7T
         eD1pQZZPLDPhQ4vRT+WmH06KhkjLTzDhTWRMANJdAzJMW1IAXOUtoIhLtBuPpXC9Nuu+
         oFlkU9zIJk8EEfG8PXewlzA705frBYhF2T2IyQpIjy2H/M4fp87qwPKWh+vZEA2dl2PR
         XVA0Afsz741MJGJVGYMaq7s9ijv8wBHfLmbH5/BRUKhTwcC45otRZO2Oguov6Oolkdlt
         IAkg==
X-Gm-Message-State: ABy/qLaI3QT3k/aUiF2XWXLBmLOVJQB7GXh+epJgdcMPPwhdEdmkVKoQ
        oG9YmBoCEqGuWeHAxh9f5LiKd8ulbCU=
X-Google-Smtp-Source: APBJJlGBvNCfyxKuG1R4NNoZpfFF1I/ljW+Qw9NESSIYSbL8hQok5yLiRGghpWLn+saGaQJuw1Daom1ZinM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c094:0:b0:c6a:caf1:e601 with SMTP id
 c142-20020a25c094000000b00c6acaf1e601mr18754ybf.13.1690593388698; Fri, 28 Jul
 2023 18:16:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:55 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-9-seanjc@google.com>
Subject: [PATCH v2 08/21] KVM: x86/mmu: Use KVM-governed feature framework to
 track "GBPAGES enabled"
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
index ef826568c222..f74d6c404551 100644
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
index ec169f5c7dce..7b9104b054bc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4808,28 +4808,13 @@ static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
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
@@ -4906,7 +4891,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->root_role.level,
 				context->root_role.efer_nx,
-				guest_can_use_gbpages(vcpu), is_pse, is_amd);
+				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
+				is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
-- 
2.41.0.487.g6d72f3e995-goog

