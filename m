Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5C65F5D54
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJEXwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJEXwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:20 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882CF7C76C
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h186-20020a636cc3000000b0045a1966a975so137889pgc.5
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2h2kMN2E+bBT+oaSBY/BYga5LVNA6QkXWr22mX6Anyg=;
        b=B7TfT1Djb9cDHKVWYgZXXtFeZYQBklPDA8QzTFkb9hRfuuIQsL++aYIUZvujbWStgp
         B9oYNwxwytKJzDfHtrtp1NRZgzPPnIpKtPpoiiIlVqr3pnTp8qNPGQeLQKAZ7Efcb7/b
         be1wl6YmPOMaXOkUYjeUKQSgIULH63WZ7Drf96XYXL65hv9yQ2h4YP2y3AZNxjbdFwo2
         W5wrK0gY4OK3Y1irJDF5fA0yrcIPSwGHQGvVB7zY4E6EVDPwaAOMYnVV1tbWuOtquEFj
         NmJz70HUIAxDOSxo7LYBu+nf/GwmH5dIUUO3wTD0qNpmLh8VP3zloF1W/9y2o0FjBCeQ
         kB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2h2kMN2E+bBT+oaSBY/BYga5LVNA6QkXWr22mX6Anyg=;
        b=HRHVsrMkJeImJVSgx1ssTnJ/IfOcgQ67T3B/hQBkB4g/bXVALfyH9obN7FrzfPXphS
         BeUW0oJ+0lkJahAz4IgLHtMkx/diXeoo7V9E5+yUuZ8QyJTIBtivOaFippzIaTVL6dgE
         hT04PQnxgWrMIJZAU7AvsKc5EMrLx2Wk5w2phmJNWwXRmAOGNN9viiD62tSVrgyXOKZM
         koDNqIiVEZHpm/qp+eoUhEWdC2+eqaf/aOlHRO2yCRFd+K5G5e/ZF7251z8fdNaqsm91
         IKe19qAU4RDTV53Ak8B/Ww8WakojOvAsnB159xwSW2LgB0gBIVTrQMDQY5SavIK7lA59
         fakw==
X-Gm-Message-State: ACrzQf3eJaW6vvQIC69AKXKaDQMGvwKFRerPJ3CNAb4hu6H1hvKsL2XK
        VUeyQeV8XWh9VqVGgfZJuww8kcrI6k4=
X-Google-Smtp-Source: AMsMyM7tSaHCuLyEbRKsMZLz0CEKUXuE1RCsflBGkieXS5PjGNmo47831Wrd3kKGCTEtqnVUQskjsWsxh/0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2395:b0:562:5575:b7be with SMTP id
 f21-20020a056a00239500b005625575b7bemr2225988pfc.17.1665013938135; Wed, 05
 Oct 2022 16:52:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:05 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 2/9] x86: Move helpers to generate misc
 exceptions to processor.h
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

Move nested VMX's helpers to generate miscellaenous exceptions, e.g. #DE,
to processor.h so that they can be used for nearly-identical nested SVM
tests.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 43 +++++++++++++++++++++++++++++++++++
 x86/vmx_tests.c     | 55 +++++----------------------------------------
 2 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0324220..c3d112f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -791,6 +791,49 @@ static inline void flush_tlb(void)
 	write_cr4(cr4);
 }
 
+static inline void generate_non_canonical_gp(void)
+{
+	*(volatile u64 *)NONCANONICAL = 0;
+}
+
+static inline void generate_ud(void)
+{
+	asm volatile ("ud2");
+}
+
+static inline void generate_de(void)
+{
+	asm volatile (
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		::: "eax", "ebx", "edx");
+}
+
+static inline void generate_bp(void)
+{
+	asm volatile ("int3");
+}
+
+static inline void generate_single_step_db(void)
+{
+	write_rflags(read_rflags() | X86_EFLAGS_TF);
+	asm volatile("nop");
+}
+
+static inline uint64_t generate_usermode_ac(void)
+{
+	/*
+	 * Trigger an #AC by writing 8 bytes to a 4-byte aligned address.
+	 * Disclaimer: It is assumed that the stack pointer is aligned
+	 * on a 16-byte boundary as x86_64 stacks should be.
+	 */
+	asm volatile("movq $0, -0x4(%rsp)");
+
+	return 0;
+}
+
 static inline u8 pmu_version(void)
 {
 	return cpuid(10).a & 0xff;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3e3d699..2ed20ec 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10717,49 +10717,6 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
-static void vmx_l2_gp_test(void)
-{
-	*(volatile u64 *)NONCANONICAL = 0;
-}
-
-static void vmx_l2_ud_test(void)
-{
-	asm volatile ("ud2");
-}
-
-static void vmx_l2_de_test(void)
-{
-	asm volatile (
-		"xor %%eax, %%eax\n\t"
-		"xor %%ebx, %%ebx\n\t"
-		"xor %%edx, %%edx\n\t"
-		"idiv %%ebx\n\t"
-		::: "eax", "ebx", "edx");
-}
-
-static void vmx_l2_bp_test(void)
-{
-	asm volatile ("int3");
-}
-
-static void vmx_l2_db_test(void)
-{
-	write_rflags(read_rflags() | X86_EFLAGS_TF);
-	asm volatile("nop");
-}
-
-static uint64_t usermode_callback(void)
-{
-	/*
-	 * Trigger an #AC by writing 8 bytes to a 4-byte aligned address.
-	 * Disclaimer: It is assumed that the stack pointer is aligned
-	 * on a 16-byte boundary as x86_64 stacks should be.
-	 */
-	asm volatile("movq $0, -0x4(%rsp)");
-
-	return 0;
-}
-
 static void vmx_l2_ac_test(void)
 {
 	bool hit_ac = false;
@@ -10767,7 +10724,7 @@ static void vmx_l2_ac_test(void)
 	write_cr0(read_cr0() | X86_CR0_AM);
 	write_rflags(read_rflags() | X86_EFLAGS_AC);
 
-	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
+	run_in_user(generate_usermode_ac, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
 	report(hit_ac, "Usermode #AC handled in L2");
 	vmcall();
 }
@@ -10778,11 +10735,11 @@ struct vmx_exception_test {
 };
 
 struct vmx_exception_test vmx_exception_tests[] = {
-	{ GP_VECTOR, vmx_l2_gp_test },
-	{ UD_VECTOR, vmx_l2_ud_test },
-	{ DE_VECTOR, vmx_l2_de_test },
-	{ DB_VECTOR, vmx_l2_db_test },
-	{ BP_VECTOR, vmx_l2_bp_test },
+	{ GP_VECTOR, generate_non_canonical_gp },
+	{ UD_VECTOR, generate_ud },
+	{ DE_VECTOR, generate_de },
+	{ DB_VECTOR, generate_single_step_db },
+	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, vmx_l2_ac_test },
 };
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

