Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476B86DB731
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDGXdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDGXdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9530946BF
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:33:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c119a5c44so58610777b3.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wA6lfngRXZVpklaLjiriPrH5qpw5LclbO2CmToyI5iQ=;
        b=DidCns1eogzfnGA7ctKYZPnpPHf0RhdJlC3C/yPBnzoxvT+wirVFqTWv2RQkAqpd9n
         BFNi7kjwiJtvnwtJrpIooNFGblDc74yKXGxGV7xhAFBQlLJMNNdCKD7fC0rMwbUISL3N
         vw8v5YAYW8Z3CwjExOzArfn3Bx13yBivsxwdGfkF9nCG0S8nSYNUNn+xxlLuR0vj/0X1
         gaRZaVJUvbsCZ6GB4luXJ9/ze0E+6lQq1DTCJETUKPz5mCDx4ncvs1RGKxlq/SYQ8drN
         ZxcKdVjCcKLFDXjTEUgON52RVrHpPSD7cCwzJYoAkwAtIP+hx5NSGYIyFifaNtHe/yEt
         4aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wA6lfngRXZVpklaLjiriPrH5qpw5LclbO2CmToyI5iQ=;
        b=Yh/KxJ2PwK2eiGausm89YsWj9fCLZELHoZUXliZAI+2P0DK4xrupEeTBnZVGSf1upa
         jZqDKeU6MHvH4ozOAFUIvtWPC2+cf7PplTkv3XqIk6hy+3TcJ8/ILg5L3N39fa352HNs
         4obKL+436kMpuYv2z7l+9gRo/OhHlEH3rB8Wf1TAWOw2OV4JzD0j9n/aB1ws0vjhjaO+
         p05+QgUNhYU4xoRFo8z/ZsLtsh3auGpUPXvVxu/DphwaeF9EJJgo6UAkD82y2RSdsdWa
         iQf+/qJu9oLuBna6NwU0W+9rmuOKeSb8BANGA5BAAPaGu0A+fYWInLmXQWNkl0iwG92Z
         cxjw==
X-Gm-Message-State: AAQBX9eC/saaWg9GXB0nTHjd1JvEotFBe/oBLqxGhpLdWPzKU7qKS9cG
        XyGat2RqC+PJwSleFznqdIB0b9L01uI=
X-Google-Smtp-Source: AKy350ZAiwHhmlimNWrndNmW7v+NzI1e8jrkXIbHi3JEOTpcDfOdc/5MEbD06TRRNtnlqtR7N9VHXsXBGBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab67:0:b0:b75:e15a:a91b with SMTP id
 u94-20020a25ab67000000b00b75e15aa91bmr5293109ybi.6.1680910382893; Fri, 07 Apr
 2023 16:33:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:51 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-4-seanjc@google.com>
Subject: [PATCH v4 3/6] KVM: selftests: Print detailed info in PMU event
 filter asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Provide the actual vs. expected count in the PMU event filter test's
asserts instead of relying on pr_info() to provide the context, e.g. so
that all information needed to triage a failure is readily available even
if the environment in which the test is run captures only the assert
itself.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_event_filter_test.c      | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 9b53e02a0565..ef07aaca2168 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -246,18 +246,17 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 
 #define ASSERT_PMC_COUNTING_INSTRUCTIONS(count)						\
 do {											\
-	if (count != NUM_BRANCHES)							\
+	if (count && count != NUM_BRANCHES)						\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
 			__func__, count, NUM_BRANCHES);					\
-	TEST_ASSERT(count, "Allowed PMU event is not counting.");			\
+	TEST_ASSERT(count, "%s: Branch instructions retired = %lu (expected > 0)",	\
+		    __func__, count);							\
 } while (0)
 
 #define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count)					\
 do {											\
-	if (count)									\
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",		\
-			__func__, count);						\
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");			\
+	TEST_ASSERT(!count, "%s: Branch instructions retired = %lu (expected 0)",	\
+		    __func__, count);							\
 } while (0)
 
 static void test_without_filter(struct kvm_vcpu *vcpu)
-- 
2.40.0.577.gac1e443424-goog

