Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3222E64A73E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiLLShg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiLLSh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:27 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4513CD6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:26 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id k2-20020a17090a514200b002198214abdcso362448pjm.8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u6UAGW3/Io5GoR5tI0/CPAU8V5g3s3Idfnam9vnKvqk=;
        b=L38A7iHh3uqIXih8k74HgcrpsYnrQ/nAUTtgYVxRc92FcvQ3W0Gxz+EFoEk19j/acy
         9DXUYj6eOLQqBKut0qTLAVeYJFXvXZMpEiHpxYu1+Fdtc9LILxIAaGb1F4AXVMnzlosw
         YnNb4tBaOi3YXs4T2w1oeYRgH004R2uwODNm36nUaAOc+iJik8iFV4H3eUJtRNqToReC
         8NTnCCgsT+CLwNLSgb81ezDiDpZw61gj4T75TC+0exybEEFw7BhKNcx+1nIDgsUl6GFj
         3qNy1fZglWFwqO5rHgJemS5y0CoVXozOxzmDEpTYB9qWunLwWO7aLiXVmwnVxLnTTXZt
         HVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6UAGW3/Io5GoR5tI0/CPAU8V5g3s3Idfnam9vnKvqk=;
        b=533xfGqTvlxro0uLWoKS/DNxJRw1B+i3XO1c/irQp5HOSPzxUEb6hedylNC150FDIW
         tPxpjYjXqRRyWUlnKu5XHyj+dWAraXxQiJXOlaEafkKaW0oU91xNQeu2IfhLJXtBaZ9q
         zwqUKthO2AASDOQGVJbLoIlu7JtnP72cwDiQ/jJSC00D+gIZGaEsEt9U8i+T4dMDArqV
         6luZeRKZEHSajERkU+jY0H3JtkHVasN6vvvWUGe5k9K+BWXhrSkErh3r47hWdKzLmzk+
         GVWV7n7sSr/9OlIIT1MDavTSmk/RNl1t4svkLquYQeBpJiIR6Aq0mXdLphR854q7sXqn
         WzMw==
X-Gm-Message-State: ANoB5pkMHr5C79Dugg7AIRvjJRd7UYJCZhmuPj1pbgUYGK5+BE/vaG9H
        0MKhVv3QWOmahK1H9NWYeRWd1IjBMTyQ
X-Google-Smtp-Source: AA0mqf6Ff4Gd85wV0oYQdDGXJzUAd5lFzhW44ds9HNxPcETWoC3SNASPnpDrVqRehLxFyj16YZ+tok7QilOh
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:5d21:0:b0:46f:188c:3312 with SMTP id
 r33-20020a635d21000000b0046f188c3312mr67834128pgb.562.1670870246240; Mon, 12
 Dec 2022 10:37:26 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:09 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-3-vipinsh@google.com>
Subject: [Patch v4 02/13] KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

CPUID_8000_0007_EDX may come handy when X86_FEATURE_CONSTANT_TSC
needs to be checked.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c         | 8 ++++++--
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 723502181a3a..42913695fedd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -701,6 +701,10 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
+		SF(CONSTANT_TSC)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
@@ -1153,8 +1157,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
-		/* invariant TSC is CPUID.80000007H:EDX[8] */
-		entry->edx &= (1 << 8);
+		cpuid_entry_override(entry, CPUID_8000_0007_EDX);
+
 		/* mask against host */
 		entry->edx &= boot_cpu_data.x86_power;
 		entry->eax = entry->ebx = entry->ecx = 0;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 203fdad07bae..25b9b51abb20 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -14,6 +14,7 @@
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
+	CPUID_8000_0007_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -42,6 +43,9 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
+/* CPUID level 0x80000007 (EDX). */
+#define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -67,6 +71,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
+	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 };
 
 /*
@@ -97,6 +102,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX1;
 	else if (x86_feature == X86_FEATURE_SGX2)
 		return KVM_X86_FEATURE_SGX2;
+	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
+		return KVM_X86_FEATURE_CONSTANT_TSC;
 
 	return x86_feature;
 }
-- 
2.39.0.rc1.256.g54fd8350bd-goog

