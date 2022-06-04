Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2353D48D
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350055AbiFDBWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350112AbiFDBWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:07 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B5E5A151
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j10-20020aa783ca000000b00518265c7cacso4730682pfn.3
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Vy11JEwxDol9yQABs4uZhD4BvSA+Z1desEZgyJ4yEtQ=;
        b=aDZjX+PI5EStIvuZnD6AeuIEtDn0K15jv1n9s425Z/XP24yXpXu4jn7lWOooIO/n8r
         5DKDTUf92SxVFCU8BZAajz9rSi+tMZ9MrkWRltJ0oZwB1kvf8frh41tafEj1Nq6AC/dk
         WaVx3K0U0wD1B7ZYXYMUtP+f41O9M0WVCA+5qg1NQtay3KdnTnVKLw3/L4yNISa0OGHK
         v3FYDHFIGuYAASAnudgDAdQZ6xqIh9yyCdjUkSuq7kkQnPiE0jLWhAmR+dTm+2DBr+Kq
         Y5wV/0m7vMLNlVteRGGSI/U/P3tiMlwGJWeDztpXvxbptehRyh9zeDm5toiDeeht6aHW
         HDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Vy11JEwxDol9yQABs4uZhD4BvSA+Z1desEZgyJ4yEtQ=;
        b=uqJ9u+ZqegOrW/bHL/owzleZ2EvoyeizxyhWf97e9t1kU7lw2y9ClxJkQATrIunpSL
         GdKOFSZV1iPtSqsp7tayNN4xxTDFV99EIfNMeuNGr+qg/v+GQ6HgEfnDH+fHrl6IPQcj
         E7mRMDW6crw9fVdIAXk6m2lf/+XjGcz6QyHScc5DZ+vzfuA+z2yrI3dOJcOSJkfGUJCd
         ink+iwEMQMjsWHBD48V4jZitmeKskqYpcJbkMIb92r9yqChQB882oqhCfIVdV2YBTz/N
         fL8cZEySin9xWVsFqq76fxY50SnpT8h4OCg+MokMMf5Sk6iGtiy++SckkO9qjixeAz+I
         MtxQ==
X-Gm-Message-State: AOAM530OFh9mI5dhL/dJkyNiDVlQy+BILQweHfFxBw1gNrqDT9wKK2Sl
        K6DGPdvKQF5FIcveEpAiYuu/ID4vVP0=
X-Google-Smtp-Source: ABdhPJwfWI7j5d/X8xCz5NqbiIFJDxY9H895jE9GkwASlCmqB2nwKTHmG66Glb8OWebvZ6a4IRXsPvj/TSA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:f806:0:b0:51b:6ea0:43cd with SMTP id
 d6-20020a62f806000000b0051b6ea043cdmr12794825pfh.28.1654305686771; Fri, 03
 Jun 2022 18:21:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:31 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 15/42] KVM: selftests: Use kvm_cpu_has() for nSVM soft INT
 injection test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Use kvm_cpu_has() to query for NRIPS support instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h     | 3 ---
 .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c     | 7 ++-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4701798736cf..f4345961d447 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -162,9 +162,6 @@ struct kvm_x86_cpu_feature {
 #define CPUID_XSAVE		(1ul << 26)
 #define CPUID_OSXSAVE		(1ul << 27)
 
-/* CPUID.0x8000_000A.EDX */
-#define CPUID_NRIPS		BIT(3)
-
 /* Page table bitfield declarations */
 #define PTE_PRESENT_MASK        BIT_ULL(0)
 #define PTE_WRITABLE_MASK       BIT_ULL(1)
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 3c21b997fe3a..edf7f2378c76 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -195,16 +195,13 @@ static void run_test(bool is_nmi)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *cpuid;
-
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
-	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
-	TEST_ASSERT(cpuid->edx & CPUID_NRIPS,
-		    "KVM with nSVM is supposed to unconditionally advertise nRIP Save\n");
+	TEST_ASSERT(kvm_cpu_has(X86_FEATURE_NRIPS),
+		    "KVM with nSVM is supposed to unconditionally advertise nRIP Save");
 
 	atomic_init(&nmi_stage, 0);
 
-- 
2.36.1.255.ge46751e96f-goog

