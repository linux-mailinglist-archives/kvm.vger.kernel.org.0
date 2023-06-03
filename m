Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F0720CE7
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbjFCBL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbjFCBLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40A10E6
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bad06cc7fb7so3997163276.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754680; x=1688346680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7zN3kqHNvCh1Otwz2V0BbGSa363179wUZXnCVirEw3o=;
        b=fQ2ArVgdVKtsRKDC1mFspyqAB1rKkpyxJ+tHZ4JpKxAOHj30bXemR+G/PUS39TSKjC
         jUj2rKGBVe8m8+UkbZ62AU666oR5aZcP67CvMfwcT2u1Ko6o3HLtZTXFIysnLaeIi4g0
         +4fadOqdCCssLPqH+5i4HiE6nzRVXRJnojd6SXAKZqEmMfDp0fTSljRTbDxnnE2dfrOy
         xVb39pj77YBjOORmEYsq9UAJ8XpCZHE7LVxFdaSUrZiVajML8qgMWHh9h06CRWX9Vvz2
         /wWQLRqmRNykDOtmJVA6Q3gjlGX+X4HjnRqZrEQj0IfvLKmE2kFuiKRALuPdeGrA+Hj8
         dY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754680; x=1688346680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7zN3kqHNvCh1Otwz2V0BbGSa363179wUZXnCVirEw3o=;
        b=Moun8mgUMtsvxaqN5SpuEj2ep5qdnLyRAuxTz6PJMH9E9UxoCOt2b797zu4QFnpuHj
         ZzVa5zybzD9T++4Q5IjBlS0ojy4psS0S0TS01ZCXSQH6EUFrQNX7+ABkjUdthlEX7NDS
         ejiDZgE0yYADwNb679YxzxSpq2VAohc+hZXDegM/+ufAEFYY6TLidcPKg0XBfr5u6t8R
         dy0uZNfbGkV4XyfmhRKucLcUD2Z7zChzKgtU9WyXO2WkDdg7wn8MX1c9hZ5iH1diFeUP
         XTuTvwu2vW8Q5FMchrlXPt5ZXYcP+BFkxbSm4LOR5S0QeqFNYCnE0Hg/y+i716ZH/bMw
         aQEw==
X-Gm-Message-State: AC+VfDwyrbSP/2ikclxfbh92GSdR/D5DQRF4E22da1/eH5FB1cmKa2m1
        /Vqa5U0VgHGtL1YDGxQk1uTvkpC+qqg=
X-Google-Smtp-Source: ACHHUZ6M56Lc+0oNspslFzbSVvTeJtlLsggZcvJQZNDQswnP85AG+PH1oRPTtIqzQRXOU552Np0uogO3+is=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4aa:b0:ba8:939b:6574 with SMTP id
 r10-20020a05690204aa00b00ba8939b6574mr2808892ybs.12.1685754680252; Fri, 02
 Jun 2023 18:11:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:56 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-11-seanjc@google.com>
Subject: [PATCH v7 10/12] KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD
 PerfMonV2 flag
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add a KVM-only leaf for AMD's PerfMonV2 to redirect the kernel's scattered
version to its architectural location, e.g. so that KVM can query guest
support via guest_cpuid_has().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a5717282bb9c..56cbdb24400a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_0022_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
+/* CPUID level 0x80000022 (EAX) */
+#define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -74,6 +78,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
+	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 };
 
 /*
@@ -108,6 +113,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX_EDECCSSA;
 	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
 		return KVM_X86_FEATURE_CONSTANT_TSC;
+	else if (x86_feature == X86_FEATURE_PERFMON_V2)
+		return KVM_X86_FEATURE_PERFMON_V2;
 
 	return x86_feature;
 }
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

