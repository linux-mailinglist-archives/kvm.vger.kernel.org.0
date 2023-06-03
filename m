Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE2D720CE4
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbjFCBLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbjFCBL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779B4E74
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bad475920a8so8800728276.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754676; x=1688346676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9mEKg+5dKinZ3o/gKM2CFOEFc6et6wjklTlAkP2Ylko=;
        b=q6p+9D8qbbuObxrHFz+nYKPtoZwhdWYziXBWxqr37YSs6to0F7StpHNbvtTfIWq0Sw
         lBR26pE0sYw6CXLdXhJHydn11m66uJ4O1XHwgnYOyebl03LpxV6tFqOb0Gl13HfZHZA2
         V2lfNXHNbh0lHwcbvkE7GMb1EA/EyRgDUzJ8GXp4UpoFxcjkihJm19pzeeeoy2ApqcFq
         owrzIU6aIVCvXuxeJnGf2CVjh0Z7LP+BQSLa5+8otX7ul9UvzUA3AVJzndHLva9e6kRr
         pkzIgbnSD8GJ94RDO0EXbm10j3jsdpWcWz6ebGFS3BVJTxsu1wAi8nGtuimZ1iZ0pF20
         g5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754676; x=1688346676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9mEKg+5dKinZ3o/gKM2CFOEFc6et6wjklTlAkP2Ylko=;
        b=jV4jrJY8sHGDv7qGgqQGSgg5bY1LTAYwySMiFW4OIOyEJLqbib9dI3X3jk8QRv9enq
         qjQZfeKsQnPHUnvKK57Kp7qPMpd/30xZBmnsj2tHc3/4JuiFbXfcZFSRxVAMCrl7/Bzx
         Gc5OK3eM0zAHzSRmC3yYRxzuWfl59A4pJdoo2Q9zyrqCD7pobTzs64b9umb5SWGS4RQP
         S9wK3k7nnjRx/NCd+pHF2ST/2d+OHteVqAIH11DhQYPcSEbBRn91KsCP5pSGkoe2+U0Z
         00nVtLoYppWcxiuHThAt4LjfAf8tz8+01/KZzqYgRpjYCr8KJ88S4gV4WPWqGGhVauia
         pBZQ==
X-Gm-Message-State: AC+VfDwYGoFo4rEw35cQGHOT3w74BIVkttFTN/EzSky7BmszKtk5voQn
        BeLwzBfaBEhvEyr45DJJ2fNm2+nHilw=
X-Google-Smtp-Source: ACHHUZ7zFWMBwqK2A328pbGfSmAyVdVtLXmwv119oW090cAAvAY5vcpazqYtCNQZ7iz27J7VR0Yl6Wn8Fao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6d56:0:b0:bb1:d903:eae9 with SMTP id
 i83-20020a256d56000000b00bb1d903eae9mr2423730ybc.2.1685754676575; Fri, 02 Jun
 2023 18:11:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:54 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-9-seanjc@google.com>
Subject: [PATCH v7 08/12] KVM: x86/pmu: Advertise PERFCTR_CORE iff the min nr
 of counters is met
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

Enable and advertise PERFCTR_CORE if and only if the minimum number of
required counters are available, i.e. if perf says there are less than six
general purpose counters.

Opportunistically, use kvm_cpu_cap_check_and_set() instead of open coding
the check for host support.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: massage shortlog and changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..d9669e3cc00a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5025,9 +5025,18 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
-	/* AMD PMU PERFCTR_CORE CPUID */
-	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+	if (enable_pmu) {
+		/*
+		 * Enumerate support for PERFCTR_CORE if and only if KVM has
+		 * access to enough counters to virtualize "core" support,
+		 * otherwise limit vPMU support to the legacy number of counters.
+		 */
+		if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
+			kvm_pmu_cap.num_counters_gp = min(AMD64_NUM_COUNTERS,
+							  kvm_pmu_cap.num_counters_gp);
+		else
+			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

