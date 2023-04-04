Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312106D6989
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbjDDQy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbjDDQyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE3A5251
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:53 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u11-20020a170902e80b00b001a043e84bdfso19889314plg.23
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3eW695/UomnciRUhquyBSqNnWcYWnT55Iqip+HkMkMQ=;
        b=RTTp/dTlA7VPm0SrtuXT1NFLu9SMWVb/pB4w8m39D08JCO9SZcuieF1cRmitvbMCrl
         xgbBV62SaSqpKkVY4BUDiqQ9/jyg+LitZPdiXbbiBMZH9SQZ52eDApvcfo2rCeRCiwig
         gP1QA2QcB8rcTD7PKyHnttwi1wdkII/kSeOwYLlcOV4CSz6ssqX6wp6tDp2uwyYaozJP
         RWv4OcajBDfz+plefSR7p4yCKHLQ8d2qoJ0/vyNYb8+D5YrtPjCmy0V9fFWLZGHyICt4
         SuTAPJNsr4jpz55eQFPzt/ZKMmICLNKqKTNdUoKQXR2CN6+KJKMLBoi1Nqzm65yfMNA3
         srmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3eW695/UomnciRUhquyBSqNnWcYWnT55Iqip+HkMkMQ=;
        b=gHGNuoYzsIG29eLwt+eu9aaPpJNhrWo94Hr+euu6nT5fIsU1ARVpXBmXrlGPZX4JnO
         yTaOystZ06ryK+VwFId/l2vHCSz9+2dlUOzLIQLsMM84dGx9hFZjrNqQs/6uAkYRus+e
         ZbiHQwc224CdGmENFsIgi7hsR369uziWmMTSagK7Vut5YdpXoBW4NhNrcY6/JLdJBzqi
         nE1H0ttvr/FFCj036MnUZWyFrGYTwgxUoTblAlK7uLmoM5WPfrbq/+vzcUVqLM/pk+40
         EAM9UZD24v+N0PXJxfbGjFaCUz2TrjVB+k4zCKcQSWzNSyLBDB4FME3mqVKpSUFa+gmK
         5BWQ==
X-Gm-Message-State: AAQBX9e3Enq07RA5XvNtWjXAZ2xBlWv7aM48zFpm1FaEPgCh05HAoxDG
        9kcHhh5aSr9PJoiqefCPuWWdAcMlSNA=
X-Google-Smtp-Source: AKy350bwxjYpX9Nu2CXtwuV87O05wL8jzGCDgzOW1ORsUcLLrdlWh3wvEVtqohTe9KpkRmtYFgvWzWrfjto=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6248:0:b0:4fc:d6df:85a0 with SMTP id
 q8-20020a656248000000b004fcd6df85a0mr937393pgv.1.1680627233453; Tue, 04 Apr
 2023 09:53:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:36 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 5/9] x86/access: Add forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
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

From: Mathias Krause <minipli@grsecurity.net>

Add support to force access tests to be handled by the emulator, if
supported by KVM.  Due to emulation being rather slow, make the forced
emulation nodefault, i.e. a manual-only testcase.  Note, "manual" just
means the test runner needs to specify a specific group(s), i.e. the
test is still easy to enable in CI for compatible setups.

Manually check for FEP support in the test instead of using the "check"
option to query the module param, as any non-zero force_emulation_prefix
value enables FEP (see KVM commit d500e1ed3dc8 ("KVM: x86: Allow clearing
RFLAGS.RF on forced emulation to test code #DBs") and scripts/runtime.bash
only supports checking for a single value.

Defer enabling FEP for the nested VMX variants to a future patch.  KVM has
a bug related to emulating NOP (yes, NOP) for L2, and the nVMX varaints
will require additional massaging to propagate the "allow emulation" flag.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
[sean: make generic fep testcase nodefault instead of impossible]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c      | 38 +++++++++++++++++++++++++++++++-------
 x86/access.h      |  2 +-
 x86/access_test.c |  8 +++++---
 x86/unittests.cfg |  6 ++++++
 x86/vmx_tests.c   |  2 +-
 5 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 1677d52e..4a3ca265 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -82,7 +82,9 @@ enum {
 	AC_CPU_CR4_SMEP_BIT,
 	AC_CPU_CR4_PKE_BIT,
 
-	NR_AC_FLAGS
+	AC_FEP_BIT,
+
+	NR_AC_FLAGS,
 };
 
 #define AC_PTE_PRESENT_MASK   (1 << AC_PTE_PRESENT_BIT)
@@ -121,6 +123,8 @@ enum {
 #define AC_CPU_CR4_SMEP_MASK  (1 << AC_CPU_CR4_SMEP_BIT)
 #define AC_CPU_CR4_PKE_MASK   (1 << AC_CPU_CR4_PKE_BIT)
 
+#define AC_FEP_MASK           (1 << AC_FEP_BIT)
+
 const char *ac_names[] = {
 	[AC_PTE_PRESENT_BIT] = "pte.p",
 	[AC_PTE_ACCESSED_BIT] = "pte.a",
@@ -152,6 +156,7 @@ const char *ac_names[] = {
 	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
 	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
 	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
+	[AC_FEP_BIT] = "fep",
 };
 
 static inline void *va(pt_element_t phys)
@@ -799,10 +804,13 @@ static int ac_test_do_access(ac_test_t *at)
 
 	if (F(AC_ACCESS_TWICE)) {
 		asm volatile ("mov $fixed2, %%rsi \n\t"
-			      "mov (%[addr]), %[reg] \n\t"
+			      "cmp $0, %[fep] \n\t"
+			      "jz 1f \n\t"
+			      KVM_FEP
+			      "1: mov (%[addr]), %[reg] \n\t"
 			      "fixed2:"
 			      : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
-			      : [addr]"r"(at->virt)
+			      : [addr]"r"(at->virt), [fep]"r"(F(AC_FEP))
 			      : "rsi");
 		fault = 0;
 	}
@@ -823,9 +831,15 @@ static int ac_test_do_access(ac_test_t *at)
 		      "jnz 2f \n\t"
 		      "cmp $0, %[write] \n\t"
 		      "jnz 1f \n\t"
-		      "mov (%[addr]), %[reg] \n\t"
+		      "cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov (%[addr]), %[reg] \n\t"
 		      "jmp done \n\t"
-		      "1: mov %[reg], (%[addr]) \n\t"
+		      "1: cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov %[reg], (%[addr]) \n\t"
 		      "jmp done \n\t"
 		      "2: call *%[addr] \n\t"
 		      "done: \n"
@@ -843,6 +857,7 @@ static int ac_test_do_access(ac_test_t *at)
 			[write]"r"(F(AC_ACCESS_WRITE)),
 			[user]"r"(F(AC_ACCESS_USER)),
 			[fetch]"r"(F(AC_ACCESS_FETCH)),
+			[fep]"r"(F(AC_FEP)),
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack + sizeof user_stack),
@@ -1209,12 +1224,17 @@ const ac_test_fn ac_test_cases[] =
 	check_effective_sp_permissions,
 };
 
-void ac_test_run(int pt_levels)
+void ac_test_run(int pt_levels, bool force_emulation)
 {
 	ac_test_t at;
 	ac_pt_env_t pt_env;
 	int i, tests, successes;
 
+	if (force_emulation && !is_fep_available()) {
+		report_skip("Forced emulation prefix (FEP) not available\n");
+		return;
+	}
+
 	printf("run\n");
 	tests = successes = 0;
 
@@ -1232,6 +1252,9 @@ void ac_test_run(int pt_levels)
 		invalid_mask |= AC_PTE_BIT36_MASK;
 	}
 
+	if (!force_emulation)
+		invalid_mask |= AC_FEP_MASK;
+
 	ac_env_int(&pt_env, pt_levels);
 	ac_test_init(&at, 0xffff923400000000ul, &pt_env);
 
@@ -1292,5 +1315,6 @@ void ac_test_run(int pt_levels)
 
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
 
-	report(successes == tests, "%d-level paging tests", pt_levels);
+	report(successes == tests, "%d-level paging tests%s", pt_levels,
+	       force_emulation ? " (with forced emulation)" : "");
 }
diff --git a/x86/access.h b/x86/access.h
index 9a6c5628..206a1c86 100644
--- a/x86/access.h
+++ b/x86/access.h
@@ -4,6 +4,6 @@
 #define PT_LEVEL_PML4 4
 #define PT_LEVEL_PML5 5
 
-void ac_test_run(int page_table_levels);
+void ac_test_run(int page_table_levels, bool force_emulation);
 
 #endif // X86_ACCESS_H
\ No newline at end of file
diff --git a/x86/access_test.c b/x86/access_test.c
index 2ac649d2..025294da 100644
--- a/x86/access_test.c
+++ b/x86/access_test.c
@@ -3,10 +3,12 @@
 #include "x86/vm.h"
 #include "access.h"
 
-int main(void)
+int main(int argc, const char *argv[])
 {
+	bool force_emulation = argc >= 2 && !strcmp(argv[1], "force_emulation");
+
 	printf("starting test\n\n");
-	ac_test_run(PT_LEVEL_PML4);
+	ac_test_run(PT_LEVEL_PML4, force_emulation);
 
 #ifndef CONFIG_EFI
 	/*
@@ -16,7 +18,7 @@ int main(void)
 	if (this_cpu_has(X86_FEATURE_LA57)) {
 		printf("starting 5-level paging test.\n\n");
 		setup_5level_page_table();
-		ac_test_run(PT_LEVEL_PML5);
+		ac_test_run(PT_LEVEL_PML5, force_emulation);
 	}
 #endif
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32d..6194e0ea 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -143,6 +143,12 @@ file = access_test.flat
 arch = x86_64
 extra_params = -cpu max
 
+[access_fep]
+file = access_test.flat
+arch = x86_64
+extra_params = -cpu max -append force_emulation
+groups = nodefault
+
 [access-reduced-maxphyaddr]
 file = access_test.flat
 arch = x86_64
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7bba8165..617b97b3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10460,7 +10460,7 @@ static void atomic_switch_overflow_msrs_test(void)
 
 static void vmx_pf_exception_test_guest(void)
 {
-	ac_test_run(PT_LEVEL_PML4);
+	ac_test_run(PT_LEVEL_PML4, false);
 }
 
 typedef void (*invalidate_tlb_t)(void *data);
-- 
2.40.0.348.gf938b09366-goog

