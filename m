Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311515F5D5A
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJEXwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJEXwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D34C86825
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j3-20020a170902da8300b001782a6fbc87so102696plx.5
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AkISx+be9PCfI+mUAkLc2un/+P1MGDt2SqNRMV4pOyE=;
        b=tOoq6Fcig/uamb6OsRnaA2fsghEd4kGYhlAqfY07aqT7p17+qoIStsvJNrg5tskxfN
         v+ydSPgL2eEwuY9/Y3IXhN66zxG091VDugwLif+tO9qtO5+O/BuwtslioXq2nRc3VjpQ
         VrXMyBKxZSNyKkFOzlsUGxJaESLfFwt/GQiiuGmS3JlBbn3LfiQUEccInvZTDM00UYvJ
         cYncbHcMbiSmzmx2M0BjlLTRYBttrzt/xEXYvsL5uw9jkj10Oo9btEpzlW5CSHTUTEon
         ftqrnI1VrqNJmT6iQo1S9zs3VObEK78JJNP7aBALldKVzPY32ilL2z/5EV/E5Pbj4ns/
         +kTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkISx+be9PCfI+mUAkLc2un/+P1MGDt2SqNRMV4pOyE=;
        b=oGox1aAtSN6sMCv3ppOpQIfi5lnSnj8WIzcJbqh+GNU8nEL+MC0eUjf9Pj73+/Wu0F
         dPyeAnVRjeFzqMCEk9//SQ3UTv7bjFp8GGK6DcjuLzATATXaOFMfrnszvjwyxexmUDiB
         ZtItLV7ILJ4Q5EZTiMz7RipgoDOPMCulc1RsVE5lsQvSANG8jt7a3bnbh1Evqh6pdnYz
         X26UEIgx29T89wkMTFnnsf6WkRgWBbai/vB0mr3HhEGC2w4p+3bCGHbpJyvYky3rPqdA
         zzBHECGa9mFH8rl24PyLwj07c8nREhIbDXV5WEiyalItBj/YoTJio2sT/nmtO4B9qfB4
         24Xw==
X-Gm-Message-State: ACrzQf3934k+YSMb5bJyB8Q3Ex5D+sW36/H+tBW54siKyfkTNfcsDu0P
        j6dVY1xouLADo97rGYmmXNqbbeTN4T4=
X-Google-Smtp-Source: AMsMyM6o0xAoxLE4IXi97CXq+a4TtNhHn7V+aB7xW+NIzYlGL0sSczjxZ9sEG0w4zp4p8eg6FXumox+NMmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c103:b0:17f:da5:35c2 with SMTP id
 3-20020a170902c10300b0017f0da535c2mr1776855pli.20.1665013947615; Wed, 05 Oct
 2022 16:52:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:11 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 8/9] x86: nSVM: Move part of #NM test to
 exception test framework
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

Remove the boiler plate code for #NM test and move #NM exception test
into the exception test framework.

Keep the test case for the condition where #NM exception is not
generated, but drop the #NM handler entirely and rely on an unexpected
exception being reported as such (the VMMCALL assertion would also fail).

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 19 +++++++++++++++++++
 x86/svm_tests.c     | 46 +++++++--------------------------------------
 2 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 5865933..c178998 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -869,6 +869,25 @@ into:
 	__builtin_unreachable();
 }
 
+static inline void fnop(void)
+{
+	asm volatile("fnop");
+}
+
+/* If CR0.TS is set in L2, #NM is generated. */
+static inline void generate_cr0_ts_nm(void)
+{
+	write_cr0((read_cr0() & ~X86_CR0_EM) | X86_CR0_TS);
+	fnop();
+}
+
+/* If CR0.TS is cleared and CR0.EM is set, #NM is generated. */
+static inline void generate_cr0_em_nm(void)
+{
+	write_cr0((read_cr0() & ~X86_CR0_TS) | X86_CR0_EM);
+	fnop();
+}
+
 static inline u8 pmu_version(void)
 {
 	return cpuid(10).a & 0xff;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0870cc5..27ce47b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2756,48 +2756,14 @@ static void pause_filter_test(void)
 	}
 }
 
-static int nm_test_counter;
-
-static void guest_test_nm_handler(struct ex_regs *r)
+/* If CR0.TS and CR0.EM are cleared in L2, no #NM is generated. */
+static void svm_no_nm_test(void)
 {
-	nm_test_counter++;
 	write_cr0(read_cr0() & ~X86_CR0_TS);
-	write_cr0(read_cr0() & ~X86_CR0_EM);
-}
-
-static void svm_nm_test_guest(struct svm_test *test)
-{
-	asm volatile("fnop");
-}
-
-/* This test checks that:
- *
- * (a) If CR0.TS is set in L2, #NM is handled by L2 when
- *     just an L2 handler is registered.
- *
- * (b) If CR0.TS is cleared and CR0.EM is set, #NM is handled
- *     by L2 when just an l2 handler is registered.
- *
- * (c) If CR0.TS and CR0.EM are cleared in L2, no exception
- *     is generated.
- */
-
-static void svm_nm_test(void)
-{
-	handle_exception(NM_VECTOR, guest_test_nm_handler);
-	write_cr0(read_cr0() & ~X86_CR0_TS);
-	test_set_guest(svm_nm_test_guest);
-
-	vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
-	       "fnop with CR0.TS set in L2, #NM is triggered");
-
-	vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-	       "fnop with CR0.EM set in L2, #NM is triggered");
+	test_set_guest((test_guest_func)fnop);
 
 	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+	report(svm_vmrun() == SVM_EXIT_VMMCALL,
 	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
@@ -3247,6 +3213,8 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, svm_l2_ac_test },
 	{ OF_VECTOR, generate_of },
+	{ NM_VECTOR, generate_cr0_ts_nm },
+	{ NM_VECTOR, generate_cr0_em_nm },
 };
 
 static u8 svm_exception_test_vector;
@@ -3396,7 +3364,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_vmrun_errata_test),
 	TEST(svm_vmload_vmsave),
 	TEST(svm_test_singlestep),
-	TEST(svm_nm_test),
+	TEST(svm_no_nm_test),
 	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

