Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B98643180
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiLETPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiLETOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:44 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6AC1F622
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:43 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id t18-20020aa79392000000b0057539377070so11459873pfe.21
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ymzZgm3kdkmvlZIFJjZckFL+Q9shQpgL5xdoQ3SJG8M=;
        b=N+f0O3TLmyG9dP6pYfSoGC632e996Xnqay8l5DVGY2PYYjTCwZogRFdlVIOVb1Ti2Y
         b9rFzEfDVcpsvLJTbMQaadyt13t1fJ0rqd971ZQcVX+e0qFY/uKe/i7Pt1b1upPM0XBp
         I7bJL9/PjJfch7lDXkJpxoww12kGDjcV5b/suDIC29TgOl3MO6DXeS9RHTsQW5a7GYIP
         UX9zukVVp2G6HQz5NLw8cis+NgJe3T5iljpo63OgjV6XAkqc4d34Mq716rbYTFUa5ggi
         OpnTIggYBz54pGeYz4Zh6emNpIofVTmjUnqcRQq0LGrexqucvzVUhz2VAP7oyhbq4iQW
         3JIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ymzZgm3kdkmvlZIFJjZckFL+Q9shQpgL5xdoQ3SJG8M=;
        b=RfKV4CuXq5hWKUpBfWpNnkvjbS72zvBbgetZC2ZB/W33CatgH6AMaLSDV9/ra408+H
         QiZAtmGc2BglWBpgkHOwZRuGCpmgPoBkRp8WKF8H6gUfsbw6uWWjRc71WswTJIxdWpo+
         oI40GJCHpm6fW4ryzzoq865S9G8Waxv5pjcwb4y0x3Lp3a2PsnsCTcfZWsBV+Mnstu30
         lfu6K38E2qKi0TEc9xpZKRguXQmMnA+PtTsmIqEXzmlDuEPtvLti/Lg0qx4aLeOB09+S
         voE6hMjVZrG5vwTWxgn3Bve0nu4lQ5g53mq/5AyR91/J0o7f4Kh/qWuvnIUql+2S/M1V
         snnA==
X-Gm-Message-State: ANoB5pkUGIBaWdOMJMW9Y0EqayNX3+RfFEuGJd4SwyY+eDogQYtq0hs7
        hQg7z8CeTtfdSUPvxSA15Pg7k84Hw3So
X-Google-Smtp-Source: AA0mqf7wPKs/8yjm9RgWTCc/RI1mi1cnj5Pu9cEE4x+4daISdREz/uc2VmbWLDy+3sH6IdnkliJHU1BjAaSp
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:4509:b0:562:641b:c1b2 with SMTP
 id cw9-20020a056a00450900b00562641bc1b2mr70604752pfb.8.1670267683289; Mon, 05
 Dec 2022 11:14:43 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:19 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-3-vipinsh@google.com>
Subject: [Patch v3 02/13] KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
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

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
2.39.0.rc0.267.gcb52ba06e7-goog

