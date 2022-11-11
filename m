Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43B62584B
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiKKK1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiKKK1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:14 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA6E98;
        Fri, 11 Nov 2022 02:27:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q1so4065264pgl.11;
        Fri, 11 Nov 2022 02:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXFlkTlXiqsouryTb00Gx7uKP0VCgkUhq3ndg42xdm4=;
        b=LvYb/NTN83yaloevfnuDXs//55qD6HNAr0FhuEftkILLr/VLb7bpF6P8Na3la3mVoW
         i1Dp/tNwZLNq+xxYVdR9qjT0jipwoTRpMbTqXmBLBgcuFpWP9hI3WVBo3zA3Vp1jv3oT
         WNaDS173LM2yFgIlXzLDQb6KX9U9/FYOC4uj1Tx0ftV6q5d6loTWIJUHGUeQGDlm1UrV
         Z67WmxTIYZB7Aob+QBrwPEYd5vl9yvO0DsxBKsMdHqxg1DEn8VJkAdQimimSuggeHSw5
         nUar+ofMms4HuFNyUj2FcRRZCN1FTNZD6tTyr4LxOdrBUnGW4zZk9tjVFPtXkuVV/vTe
         GjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NXFlkTlXiqsouryTb00Gx7uKP0VCgkUhq3ndg42xdm4=;
        b=UHQZg2NMwxm3KngvXDdGaRyIguhAxHX0WfBTb+pgwt3zKrWLpWQWC0IKL01Z7Ta/UV
         HryUFipUw7d2JH/y765XtuUICrqu54xDeLzYBDWHj0817ebV7WH3Jk+oSyGjk9Jv9in3
         ANndz4abZgX/aJ6Y+vxikvocNgew6mLOrJwGpUv2iFpDVQyAwnYa9RoE8vVliliT8ita
         iMs46ItREig8uaGpJhQPyMPpr4auX4BSUyFeZjIRDKDnEuz/VHoLYg20MztgugjJfYru
         w5LdlVRBeHsfOr6lw1buBpPY+8PFmqeYS5r0RVAiaFi0UsXULtFl1otM7fTdR5wB/2Vp
         tsfg==
X-Gm-Message-State: ANoB5pliGFWyhvJ0h+WSJKwfiuCHzV/pSggefA+qDw9UvnZXmM79xsTV
        fmQ50iFw13FZx4I4fkPt6wIhTLJuEXqzrd+v
X-Google-Smtp-Source: AA0mqf487xTwzRuIVLCYJWPmXRI+slzjZ7HugDITqYEoHfMBDaQzFov2Nh0UzpB1oW9V2VrYJ/QuLg==
X-Received: by 2002:a63:a50f:0:b0:46f:f26e:e8ba with SMTP id n15-20020a63a50f000000b0046ff26ee8bamr1130166pgf.250.1668162433017;
        Fri, 11 Nov 2022 02:27:13 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a KVM-only leaf entry
Date:   Fri, 11 Nov 2022 18:26:42 +0800
Message-Id: <20221111102645.82001-6-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Alias X86_FEATURE_AMD_PMU_V2 for feature AMD_PMU_V2 in KVM-only leafs that
aren't scattered by cpufeatures.h so that it can be used in KVM, e.g. to
query guest CPUID.  As a bonus, no translation is needed for these features
in __feature_translate().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/reverse_cpuid.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..7cfedb3e47c0 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0022_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -23,7 +24,15 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
+#define KVM_X86_FEATURE_AMD_PMU_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
 
+/*
+ * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
+ * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
+ * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
+ * features in __feature_translate().
+ */
+#define X86_FEATURE_AMD_PMU_V2      KVM_X86_FEATURE_AMD_PMU_V2
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -48,6 +57,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 };
 
 /*
-- 
2.38.1

