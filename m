Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E551727050
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbjFGVKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbjFGVKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0589D1
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-653a5de0478so754374b3a.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172212; x=1688764212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rRVOMLH2o4tEt224inR1kyxO+gcGF2nsf1FQN7RGL8c=;
        b=uRa9BckVbZ/D278OIH5cCVchVFyHPD3+7tBLJQxhz+CCdIi6KypP0o9HpVXYxrauNk
         7uzN3eMkLwHUK+rkqm6Jl+VMLaNpJ+0Y1z84IBXyDJzPdTZxcGwMWdQ3MAjK4TFIcn87
         eHQ1qAtYlxJ06jDip2vA/dFEco/nMSwa+ljAAwffxkNjgXiSOUMXbOcQSHOE8+efvP+5
         2KzFQ8PPNytuT6d8vJQZy67p5aLdYrgSvGrvmC0na2o0JdanKzU3DHG651hdQY7K/p5F
         0oamttGOnNwk9e5laFOZyoBxPffJx5Kru5mpuZSyu23ZJEvJOU83mK15Y3EcGBNu8sze
         gssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172212; x=1688764212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRVOMLH2o4tEt224inR1kyxO+gcGF2nsf1FQN7RGL8c=;
        b=IWWh2KgBh/Nyq9KDdgm0wuUbuQPKZAR1F5YGDb26IkJ4ZCORRA+skH0YhIUhCfqzxg
         hV9+H8DAUyDs2XujidVlH3BauQ9DfwMDpt3HPom1HEjygzszwj8tm5NLNmiP3Lv8x3Gl
         cjqzQ7wOcUZriHzf35xwDk80sYSE0P/XCxtD4gb89LT0A1fr0HUf/ooBebjvBF9iq37a
         nPz8pjreJ3FhuQhOXlw7SGvO0+BzWVZ20JRm4Vu6VP6c3jOEPHHFy9W//AT8N2pfZ2Z1
         TjTaCMMpbYEnW1Dq0+Tm3TUp0Gqo99ged3+VZHQXRgj9gtxpRwPpfmAHRb9pQMIz1jHA
         4J9Q==
X-Gm-Message-State: AC+VfDynGplRqu4MRcS1cbMWClt5EfyAECMU/bFwQbPy9Lv/yjQgvVbU
        FypI4b7jH2xJJ82PsUiVehZMxfDDQr4=
X-Google-Smtp-Source: ACHHUZ5quQ1eve69OyHrbV2pYFgJ+rze0Pz9m3YHWO//rVKY4qktc8hIUjXqksXXHWNoN027UKlOvlYCzqc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10:b0:662:129b:6a54 with SMTP id
 h16-20020a056a00001000b00662129b6a54mr65813pfk.1.1686172212182; Wed, 07 Jun
 2023 14:10:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:58 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/6] x86: nSVM: Replace check_dbgctl() with
 TEST_EXPECT_EQ() in LBRV test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Use TEST_EXPECT_EQ() to check the expected vs. actual DEBUGCTL instead
of using a one-off implementation that doesn't even print the expected
value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 9a89155a..de2cedc8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2791,15 +2791,6 @@ do {										\
 		asm volatile("ud2");						\
 } while (0)
 
-static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
-{
-	if (dbgctl != dbgctl_expected) {
-		report(false, "Unexpected MSR_IA32_DEBUGCTLMSR value 0x%lx", dbgctl);
-		return false;
-	}
-	return true;
-}
-
 #define DO_BRANCH(branch_name)				\
 	asm volatile (					\
 		      # branch_name "_from:"		\
@@ -2877,9 +2868,9 @@ static void svm_lbrv_test0(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	check_dbgctl(dbgctl, 0);
+	TEST_EXPECT_EQ(dbgctl, 0);
 
 	HOST_CHECK_LBR(&host_branch0_from, &host_branch0_to);
 }
@@ -2902,7 +2893,7 @@ static void svm_lbrv_test1(void)
 		return;
 	}
 
-	check_dbgctl(dbgctl, 0);
+	TEST_EXPECT_EQ(dbgctl, 0);
 	HOST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
 }
 
@@ -2926,7 +2917,7 @@ static void svm_lbrv_test2(void)
 		return;
 	}
 
-	check_dbgctl(dbgctl, 0);
+	TEST_EXPECT_EQ(dbgctl, 0);
 	HOST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
 }
 
@@ -2959,7 +2950,7 @@ static void svm_lbrv_nested_test1(void)
 		return;
 	}
 
-	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
 	HOST_CHECK_LBR(&host_branch3_from, &host_branch3_to);
 }
 
@@ -2990,7 +2981,7 @@ static void svm_lbrv_nested_test2(void)
 		return;
 	}
 
-	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
 	HOST_CHECK_LBR(&host_branch4_from, &host_branch4_to);
 }
 
-- 
2.41.0.162.gfafddb0af9-goog

