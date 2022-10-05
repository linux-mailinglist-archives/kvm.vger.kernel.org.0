Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA65F5F5D5B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJEXwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJEXwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CCA86833
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z7-20020a170903018700b0017835863686so95409plg.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vd7FK6OrPoZv6Yux/Uh88ssHQBLLj+uFcVCMiEaTNlQ=;
        b=plc9OhAGdtW+UlMaohO/pUM8IppP2PVZCD0MNDIpaISilzwJKt3k+eBQvaPV4K7TNs
         5gv5h0r6v1PI5GsW78NOwue7a8WWoj5jpHWf91MLEAHDfr0PZDQAIrox5GzeCKHLvt/Z
         Dp+1WYIILczbkaZmBn9/0hXUypk78WG8zVlvQzqVXJ7H2M8HTl8I4rY26UIO9O3j2jys
         2PyMxMzmGU4P8kOUIfz4QuupdxvvEWwTqmYqtz4RxKgGEW8RtR2Uw2CYKX+a8zEsRXoj
         H3qojkqIY850gKNYTk9sHRIwq78zPHFZDYoktqzJ3IgLaH4tpN8uO+iMl8G6Yrmwre5B
         7qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vd7FK6OrPoZv6Yux/Uh88ssHQBLLj+uFcVCMiEaTNlQ=;
        b=pPJmGU3cslLhhlPJzNKKv8Idfdz4dcWtGmS/ZCNjxByVlme2EalL1eyOjhSAYouclz
         GkQPpFm8M5M8/F7GXcuiOlLQENWC49BGDCDJwaI3/SatZJrp8VeAcrYoJrQnQJNU40xu
         eAltx/IW5ZKvIQNEpkbT/94q+DwicAGcLEDjubPfqBx7Pa3eqhw7wIFAPUB7P3eqTRo+
         WHJcBNSAXk2pODL4gYBbxYuT5/U4ODcPdn03Qg4KYuufbTtttRHuVfytakUtQvUyx2A4
         QG5jm2qPKvPTylnqre46d0gnQ3GuVxs5djM4PQpp2/XbBMozkCjlgwUfWZmHzy9Lltpd
         8F5g==
X-Gm-Message-State: ACrzQf0vNsoPYShnkCce+1ohginFFy6QhFScpuV6efHMTMxtHDP/Q7/J
        gEqc5INc7Uu0Uybz3e9b7yW6F9vzVMw=
X-Google-Smtp-Source: AMsMyM5ZrJaRMHSqFXLL2uGfNYHsqX09Nixdhmy/2suIiuLfcfSdlvh7YKfk63fiLrmrDdFKxhQojcPeU3E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:2985:0:b0:544:77d4:f43b with SMTP id
 p127-20020a622985000000b0054477d4f43bmr2282678pfp.9.1665013949401; Wed, 05
 Oct 2022 16:52:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:12 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 9/9] nVMX: Move #NM test to generic
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

Move the #NM test cases to the generic exception test framework, and
rename the dedicated test to note that it tests the "no #NM" case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 67 ++++++-------------------------------------------
 1 file changed, 8 insertions(+), 59 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 368ad43..2438022 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8359,67 +8359,14 @@ static void vmx_cr4_osxsave_test(void)
 	TEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 }
 
-static void vmx_nm_test_guest(void)
-{
-	write_cr0(read_cr0() | X86_CR0_TS);
-	asm volatile("fnop");
-}
-
-static void check_nm_exit(const char *test)
-{
-	u32 reason = vmcs_read(EXI_REASON);
-	u32 intr_info = vmcs_read(EXI_INTR_INFO);
-	const u32 expected = INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION |
-		NM_VECTOR;
-
-	report(reason == VMX_EXC_NMI && intr_info == expected, "%s", test);
-}
-
 /*
- * This test checks that:
- *
- * (a) If L2 launches with CR0.TS clear, but later sets CR0.TS, then
- *     a subsequent #NM VM-exit is reflected to L1.
- *
- * (b) If L2 launches with CR0.TS clear and CR0.EM set, then a
- *     subsequent #NM VM-exit is reflected to L1.
+ * FNOP with both CR0.TS and CR0.EM clear should not generate #NM, and the L2
+ * guest should exit normally.
  */
-static void vmx_nm_test(void)
+static void vmx_no_nm_test(void)
 {
-	unsigned long cr0 = read_cr0();
-
-	test_set_guest(vmx_nm_test_guest);
-
-	/*
-	 * L1 wants to intercept #NM exceptions encountered in L2.
-	 */
-	vmcs_write(EXC_BITMAP, 1 << NM_VECTOR);
-
-	/*
-	 * Launch L2 with CR0.TS clear, but don't claim host ownership of
-	 * any CR0 bits. L2 will set CR0.TS and then try to execute fnop,
-	 * which will raise #NM. L0 should reflect the #NM VM-exit to L1.
-	 */
-	vmcs_write(CR0_MASK, 0);
-	vmcs_write(GUEST_CR0, cr0 & ~X86_CR0_TS);
-	enter_guest();
-	check_nm_exit("fnop with CR0.TS set in L2 triggers #NM VM-exit to L1");
-
-	/*
-	 * Re-enter L2 at the fnop instruction, with CR0.TS clear but
-	 * CR0.EM set. The fnop will still raise #NM, and L0 should
-	 * reflect the #NM VM-exit to L1.
-	 */
-	vmcs_write(GUEST_CR0, (cr0 & ~X86_CR0_TS) | X86_CR0_EM);
-	enter_guest();
-	check_nm_exit("fnop with CR0.EM set in L2 triggers #NM VM-exit to L1");
-
-	/*
-	 * Re-enter L2 at the fnop instruction, with both CR0.TS and
-	 * CR0.EM clear. There will be no #NM, and the L2 guest should
-	 * exit normally.
-	 */
-	vmcs_write(GUEST_CR0, cr0 & ~(X86_CR0_TS | X86_CR0_EM));
+	test_set_guest(fnop);
+	vmcs_write(GUEST_CR0, read_cr0() & ~(X86_CR0_TS | X86_CR0_EM));
 	enter_guest();
 }
 
@@ -10666,6 +10613,8 @@ struct vmx_exception_test vmx_exception_tests[] = {
 	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, vmx_l2_ac_test },
 	{ OF_VECTOR, generate_of },
+	{ NM_VECTOR, generate_cr0_ts_nm },
+	{ NM_VECTOR, generate_cr0_em_nm },
 };
 
 static u8 vmx_exception_test_vector;
@@ -10804,7 +10753,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_ldtr_test),
 	TEST(vmx_cr_load_test),
 	TEST(vmx_cr4_osxsave_test),
-	TEST(vmx_nm_test),
+	TEST(vmx_no_nm_test),
 	TEST(vmx_db_test),
 	TEST(vmx_nmi_window_test),
 	TEST(vmx_intr_window_test),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

