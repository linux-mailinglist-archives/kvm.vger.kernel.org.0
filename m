Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DE35F5D59
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJEXwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJEXw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7D86803
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w9-20020a17090a780900b002093deb1701so65430pjk.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3+WMuDYNlF82PPFKJIPfxPe7cGmV3+Nfbl2Iptcws2U=;
        b=EhDfoLEdag1FwY6yzprPBmQVPeW5JWPuUa3QivORMnl+N/SnazOBDi+dVHTcztwqb8
         d/OqbIKIIygvHisqYG8fI57iQGAY9RbIif2EHAI86a6SJ6FoZ3PwI4MIz6dGRTUbUdi9
         GKksDCgRjQakDdatgGdt5HiG/vjLIw2/rg6eVugZgB8jEiQjNqL4RODqWvc3BROp04uO
         qb/uKYo2E8H0nt1yGd9XgYOh7eTb5gACv0c4T/H0XVOxoroKkt6WZVbSRa5ioCuAdkti
         QNdU8uA55woYQBjX+Ahg9MDZFLrH+EefVaBE2mwt3Iu9sN6ytHyaxPfij1XG3K5euMcr
         20uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+WMuDYNlF82PPFKJIPfxPe7cGmV3+Nfbl2Iptcws2U=;
        b=eNN/pS+Y7+w7sLqOJoTDfYQyrqCu22qYeEXKbWOsqBO9W1QJE2Nj98w2+BZdX9Ncih
         wllrLXL0A2kDjNLVnowyHuZBObus/ty9ofB4tnPIM5e31pwFWAPOPvM0J6KXWrywLP1R
         z2Iwkh9X0qT602BE/O/dNHxhOfpd/ENViMQqAv8l6bU6RgVaOJVTLiNKjkQyN2wLNmuc
         GV/cP3Pp3PUQIr+cf1FRIf9lDgV2VyUf3bdgsOz1xc6U8Ko2w4Nfkn0Hd56vc9uORgDn
         7wWSaztm3+1ngyuH5hphCtlzg2OOk9aLtorAIz01fhBPBXuZuPwfzWOJdHg11DtGtI0L
         e9OQ==
X-Gm-Message-State: ACrzQf23dTWYR/ayKJD6h31B/u0bIbqZRmPqcKwXr6l/HPUly1s526rV
        EkqBgQfaGq0xziKXVGlKXGCB2OAhNv0=
X-Google-Smtp-Source: AMsMyM4SPL4zEuInhJzA2phfYgh8pdAmntFYw/josKBtCha3JuvKnRepP534uPV2lxer+EoTws0AjCbl+4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c2:b0:178:2eca:9dea with SMTP id
 u2-20020a170902e5c200b001782eca9deamr1760117plf.73.1665013945879; Wed, 05 Oct
 2022 16:52:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:10 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 7/9] x86: nSVM: Move #OF test to exception
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

Remove the boiler plate code for #OF test and move #OF exception test in
exception test framework.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 50 +------------------------------------------------
 1 file changed, 1 insertion(+), 49 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1285f98..0870cc5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2756,54 +2756,6 @@ static void pause_filter_test(void)
 	}
 }
 
-
-static int of_test_counter;
-
-static void guest_test_of_handler(struct ex_regs *r)
-{
-	of_test_counter++;
-}
-
-static void svm_of_test_guest(struct svm_test *test)
-{
-	struct far_pointer32 fp = {
-		.offset = (uintptr_t)&&into,
-		.selector = KERNEL_CS32,
-	};
-	uintptr_t rsp;
-
-	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
-
-	if (fp.offset != (uintptr_t)&&into) {
-		printf("Codee address too high.\n");
-		return;
-	}
-
-	if ((u32)rsp != rsp) {
-		printf("Stack address too high.\n");
-	}
-
-	asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
-	return;
-into:
-
-	asm volatile (".code32;"
-		      "movl $0x7fffffff, %eax;"
-		      "addl %eax, %eax;"
-		      "into;"
-		      "lret;"
-		      ".code64");
-	__builtin_unreachable();
-}
-
-static void svm_into_test(void)
-{
-	handle_exception(OF_VECTOR, guest_test_of_handler);
-	test_set_guest(svm_of_test_guest);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && of_test_counter == 1,
-	       "#OF is generated in L2 exception handler");
-}
-
 static int nm_test_counter;
 
 static void guest_test_nm_handler(struct ex_regs *r)
@@ -3294,6 +3246,7 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ DB_VECTOR, generate_single_step_db },
 	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, svm_l2_ac_test },
+	{ OF_VECTOR, generate_of },
 };
 
 static u8 svm_exception_test_vector;
@@ -3444,7 +3397,6 @@ struct svm_test svm_tests[] = {
 	TEST(svm_vmload_vmsave),
 	TEST(svm_test_singlestep),
 	TEST(svm_nm_test),
-	TEST(svm_into_test),
 	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

