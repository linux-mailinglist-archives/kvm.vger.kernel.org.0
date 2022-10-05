Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE25F5D58
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJEXwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJEXw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:26 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C148320E
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cb7-20020a056a00430700b00561b86e0265so183182pfb.13
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rKB/plFswAlnO6SdAH1HZmuRlQeaaliiQzrmKlYyGW8=;
        b=KZHCDVvLlBKRD8XKHLpxO2HDZlwc48cXCwFKgqwFlk9r3Njz4j+HT25Du81MUFYirg
         Sm9fgI+U0bUMZZ6ONF6vWnfep+mlCXRIw0ekS9cVoxCxwVGQx8i2iiFtsikIh2FH1/Sy
         KYYzzBdThcumGBxGIa3DDFJ8JD9I8/Ga+Q4Y9FkuT2wSGAF59h7MaAEgQyRgcNhSeFam
         uL7D0vpf7of/i9P32qeUrbDZm7zL32eIub8jtzmg+Vz/FujdXxbFlhCaymApaWTLL67R
         1XPPyEr90jmiDUcNUScIwDPCbW+TlhYxsZKCnRpDfkLBhljnfiP7/rb2FZBNZhXd7cR+
         sy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rKB/plFswAlnO6SdAH1HZmuRlQeaaliiQzrmKlYyGW8=;
        b=C6j5GqTim73KQD4BP7FrxZe39m4QFpLVvbNz7R0wvDdrxEfY/1ujYmBEqH39tNukxb
         Kpg7QTONyQlAUrd3OhzRQ+KSExQ3ukaFnv53B9STlAVaJ3sdn49MzhLkolXKlKCPgief
         mgJ2wuHhah1T5NoykzzMJaxoIJG3/GvcHCp4MqXo5LiEwnnmojZlAgW4yThb0VmNYPb6
         Z4FH2i7w/9r76NiMVc1e1a3f6lEF2lO8j8WvNrIoWsDRBeK9vGr0Z7bkW2cF1++BwCjU
         3V6ZST8c0oYSqpLO+uf74r+wwsnrP6pyd1ikMhUTxrFZAsT2OpAR03DVmenAcSZO0inG
         fujQ==
X-Gm-Message-State: ACrzQf1oGP1YKE/vviAyy/PQmNNrMz6c9I/UB9hjXTChYuXbYjxm81xl
        UuIql53ku8lr7vlMHmcCx2Nw5mxVwrI=
X-Google-Smtp-Source: AMsMyM7eSRXC8tfz78BAhOKtrPhx1x8Sd60sUuV2d7kCFldJCPu48an53jGYm4C1T9ZPWxrAn89qR+jvAjM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0e:b0:547:1cf9:40e8 with SMTP id
 g14-20020a056a001a0e00b005471cf940e8mr2160586pfv.82.1665013944195; Wed, 05
 Oct 2022 16:52:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:09 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 6/9] x86: nSVM: Move #BP test to exception
 test framework
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
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

From: Manali Shukla <manali.shukla@amd.com>

Remove boiler plate code for #BP test and move #BP exception test into
the exception test framework.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 805b2e0..1285f98 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2804,26 +2804,6 @@ static void svm_into_test(void)
 	       "#OF is generated in L2 exception handler");
 }
 
-static int bp_test_counter;
-
-static void guest_test_bp_handler(struct ex_regs *r)
-{
-	bp_test_counter++;
-}
-
-static void svm_bp_test_guest(struct svm_test *test)
-{
-	asm volatile("int3");
-}
-
-static void svm_int3_test(void)
-{
-	handle_exception(BP_VECTOR, guest_test_bp_handler);
-	test_set_guest(svm_bp_test_guest);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && bp_test_counter == 1,
-	       "#BP is handled in L2 exception handler");
-}
-
 static int nm_test_counter;
 
 static void guest_test_nm_handler(struct ex_regs *r)
@@ -3312,6 +3292,7 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ UD_VECTOR, generate_ud },
 	{ DE_VECTOR, generate_de },
 	{ DB_VECTOR, generate_single_step_db },
+	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, svm_l2_ac_test },
 };
 
@@ -3463,7 +3444,6 @@ struct svm_test svm_tests[] = {
 	TEST(svm_vmload_vmsave),
 	TEST(svm_test_singlestep),
 	TEST(svm_nm_test),
-	TEST(svm_int3_test),
 	TEST(svm_into_test),
 	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

