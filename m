Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9CC54BB70
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357122AbiFNUII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357154AbiFNUH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB741EAFB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30ffc75d920so34434587b3.2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A5Yqv/oATZC7iG9rkjQz5o5BXjSdlLOP6pd+ZfOPJAo=;
        b=AgVOhQGu0SLIY5ajIXV9p1vIDBjR2/ZUJNw+6fyWRAty92D2bTHaQK6z1KolqWCRkU
         WQL/3tX6ShDRgEasqeVc8tGjuRwq8kbQEyTwzx7JfyF7RsZ/TBaixjA4nebXHtaLKPrL
         sdVcYiE7xpsZIOB8DopL+O5Dgw0cDl0rJeWdBmoOdk/k/9FUmmhOZVkYRSfBEKU4DvVX
         cdMMcNvbyi9WYqci05dFIUQJ9cXEpt8yrIRhLtp45mDAkNgniwU422YQCb8UQwK74FKk
         IVdn2Bb6ELAWP61Lk3J5LaeHA0PEPTI+XZAztcGU/gZeQsf2mkhC75YWXnSWHMVJSQFe
         jhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A5Yqv/oATZC7iG9rkjQz5o5BXjSdlLOP6pd+ZfOPJAo=;
        b=1IBwDWDKB6bqJsp+IGcrHTfOnGwQ6q1l6bywufhqxV2/1AWktzkeS9OE04Eyk7lAS5
         jO0QtDqcPFMAHOYHVzYj4mxE1vP/m5sMhR/bxgXnEBz5Ou8tqzBYEQQnxaIPWqg0vMIw
         R4pxPgSgGVH5XEL/6SxIPkm6oiJvsNmtFV59rvHAbi8YGc2Dnw5NxqRq7M7MrlPtxn7t
         u7TojPLJ4byxmBiwIjNMIOWijqK26SmOuIBDzZR9Wg6tqsT6Puf9txqsCsOj1dtERWDF
         1qFxqSLVxwXRfvIHrX5VB00nL595wjP6dG2kPTG/ZILhr0nFKsH6LWdFDgPW4Jf9YR06
         3G2A==
X-Gm-Message-State: AJIora+ge/qx0ADLYq+lbmFvTTSmtraDP0+hld+Ux6grxqPO1q7O1m2s
        4MPIOvQK3hKh7I8fD4XkUHE42pW5MWU=
X-Google-Smtp-Source: AGRyM1sOeU3iBT+j7fHxZMpCvarktKuhg8iqjlJ/iEqvX51llTGOjwpDec4lLKGXwU7IelXZigbq5n/S3Hc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:ca17:0:b0:664:60ce:9369 with SMTP id
 a23-20020a25ca17000000b0066460ce9369mr6537797ybg.455.1655237259955; Tue, 14
 Jun 2022 13:07:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:40 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 15/42] KVM: selftests: Use kvm_cpu_has() for nSVM soft INT
 injection test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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
index db8d5a2775dd..f5fa7d2e44a6 100644
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
2.36.1.476.g0c4daa206d-goog

