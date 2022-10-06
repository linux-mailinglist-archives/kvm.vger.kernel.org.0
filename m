Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4005F5E0E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJFAvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJFAvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60C446611
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d14-20020a170902cece00b001784b73823aso194254plg.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KXQHf4GGreclJV8UKG8o93Lp2p7h1XuOoBqM1BAPjfg=;
        b=MsxFUJnJbSr31qkjxrcQS41clk5/JoUKMdvBOwVkSaF+YTh6E39DA5Ov5XjXyxzv74
         GgpHQzEE1F9MUE+h6qnMxBLSo+RdoIBQwA4pICJTn+AH2MbIxuOTy4/RCskc2kChcZbK
         owZXXUOah/47VaAYjbLFEoDOuAR34Nm+rTKWPjG9FTYd/ZgSoHJYdTi06swsHJQRPSko
         /NwPDXQfmnSp683jgo3l/QjJ/nsFxLL5IZuPT1qYqEz3EvMWJC8nIsby4Hl9/kLHVaZD
         t1xO3UOa6hZ2H3Qi/pUtQkFOkfu3K1qHpIxLFhLMsWYyIYoYYBAf2lkJ7xclW7rSCTLt
         C/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KXQHf4GGreclJV8UKG8o93Lp2p7h1XuOoBqM1BAPjfg=;
        b=mXfYVDre6SV/sDW54Ga9JfAIcCL1X04xAzwpqS1PwSsH0Da3QEY7PzMorqaTkOCrJW
         ZMGo3FPfX8CvqlJfUTFDHHsJT9/pUyNuMeU8GH6VN/QodF7vovB5Mxfrun2zEYpiaEdw
         KyqWgah3OqGFBYoSJRnfzhKwu2gNjHc6ZKClCC1tJnEnkUJKRo1mv0k6OPMbdyxJhr3z
         CgyygjoGU5Vo4XYTE9DZJXkhk0LtTwJpiYjfQejbYnbNTPUuAaZPA6/TJipndjLJQj7M
         06rTpGv1tK7fDXUzWzfdnynUbcQuk6W8Ooy1Y2+5xnOrN2iqqEtLrL+PSbXRHby4X6+I
         QLAw==
X-Gm-Message-State: ACrzQf09lLAkfqZ2PrOu3ssm+ROD+/cbj+v7Rx359sXBAi7pjjPsOrE6
        nXd/k3U7lRlXGjZiw+CW7YYQ0pDwemE=
X-Google-Smtp-Source: AMsMyM7OC3MEsHGB3Bg35pHH2zXARp4iXQExj7zSOZlcCvThVuxdWQkBKMUyTkqasS1rlmF0ClAmLoOPCHU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2412:b0:178:796d:c694 with SMTP id
 e18-20020a170903241200b00178796dc694mr2113381plo.42.1665017496375; Wed, 05
 Oct 2022 17:51:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:18 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-6-seanjc@google.com>
Subject: [PATCH 05/12] KVM: selftests: Refactor kvm_cpuid_has() to prep for
 X86_PROPERTY_* support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_cpuid_has() to prepare for extending X86_PROPERTY_* support
to KVM as well as "this CPU".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index fb9e90d25b60..30e8dfe2111e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -700,8 +700,9 @@ const struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
-bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
-		   struct kvm_x86_cpu_feature feature)
+static uint32_t __kvm_cpu_has(const struct kvm_cpuid2 *cpuid,
+			      uint32_t function, uint32_t index,
+			      uint8_t reg, uint8_t lo, uint8_t hi)
 {
 	const struct kvm_cpuid_entry2 *entry;
 	int i;
@@ -714,12 +715,18 @@ bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
 		 * order, but kvm_x86_cpu_feature matches that mess, so yay
 		 * pointer shenanigans!
 		 */
-		if (entry->function == feature.function &&
-		    entry->index == feature.index)
-			return (&entry->eax)[feature.reg] & BIT(feature.bit);
+		if (entry->function == function && entry->index == index)
+			return ((&entry->eax)[reg] & GENMASK(hi, lo)) >> lo;
 	}
 
-	return false;
+	return 0;
+}
+
+bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
+		   struct kvm_x86_cpu_feature feature)
+{
+	return __kvm_cpu_has(cpuid, feature.function, feature.index,
+			     feature.reg, feature.bit, feature.bit);
 }
 
 uint64_t kvm_get_feature_msr(uint64_t msr_index)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

