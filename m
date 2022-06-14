Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BD54BB2F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351337AbiFNUH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350580AbiFNUHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEB34D6AA
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q200-20020a252ad1000000b006632baa38deso8489649ybq.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gFBrtRlDF3lH8d+M3xs/KaCiXtONEeFHhxQZdekcdbU=;
        b=RwZiSISLRP5Jmddd28lockJNVdfvQZA4w4rWdZGYLt+asA4X5x0/OSzjaVS9RnPgvf
         dca+zd0t6wam9yqO0UYy4r6C+8s7Kcf8xwI8cQ1GozrxgKQXOxetyEHs672fkneibNEP
         f0Iv/g1S6G3lM7op5OIPNu4VJjbG2uhJIq1D2qlvr1aycbaoyDYucSibs8GwI8aw0t7B
         9xCxpUkiRrZbjk9NHi2uHIl4JYr+F2YsLMo/lpqFuDOIz7dm/3++yARmGD5FGSFgsj87
         Om2fiUMw+PmCFjQwlXCIBBpaFlPHz1fXQDH08G+kz008LC9rR+TPDrJEuYNEgkMe6GiX
         MzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gFBrtRlDF3lH8d+M3xs/KaCiXtONEeFHhxQZdekcdbU=;
        b=JlhkJSOHvJ3KkQG+kSecrEsWoRgSueqXja5VpqOhUfrfqmQDXJ/UiPTpl5XWTBzgJy
         T9Yqyj/YvoSMpJ/WlxRGWgu0ltXlafBQ8rS4xvnePZnhDDwM6+GTjEd0JxxP0E5VoC8h
         ODlszaJmRnV26JQqjpJCjDBDMJZPny3wrZ6dIqdtZgHnmYKA+2d9c8UnVF9M/jzhwkAD
         boxGSSN2xOexFztFQCzt8xIrwAR7waxODdL8J92u7UYuzJ5aBLgljGe8K+bcikskhGm5
         LC2z/KKCyUI+SOw2gHmtymtbPiQYWyRjb+kqzUUCdmR6RFNl3vDkoqfSasvTGZrSZ5HP
         DSrA==
X-Gm-Message-State: AJIora9bLcgurFlHKsAFvdsoi3ZQprJIZqAU/Z/YQNsbxakrU6pDILXK
        1dwceqFbGAp9coK8RfxMR1q2apYesSU=
X-Google-Smtp-Source: AGRyM1vdSturGtI2PTOIo343GwMnfY2JF4QJfIJXDZQQzFSc21V8131+XS87dx52wrjxAWs9EX7RTdjXPig=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:11d3:0:b0:314:67c9:1654 with SMTP id
 202-20020a8111d3000000b0031467c91654mr4202824ywr.481.1655237236710; Tue, 14
 Jun 2022 13:07:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:27 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 02/42] KVM: sefltests: Use CPUID_XSAVE and CPUID_OSXAVE
 instead of X86_FEATURE_*
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

Rename X86_FEATURE_* macros to CPUID_* in the AMX and CR4/CPUID sync
tests to free up the X86_FEATURE_* names for KVM-Unit-Tests style CPUID
automagic where the function, leaf, register, and bit for the feature is
embedded in its macro value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h   | 4 ++++
 tools/testing/selftests/kvm/x86_64/amx_test.c            | 9 +++------
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 7 ++-----
 .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c   | 3 +--
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 32964d7b2218..2b13ea74362a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -48,6 +48,7 @@
 #define CPUID_SMX		(1ul << 6)
 #define CPUID_PCID		(1ul << 17)
 #define CPUID_XSAVE		(1ul << 26)
+#define CPUID_OSXSAVE		(1ul << 27)
 
 /* CPUID.7.EBX */
 #define CPUID_FSGSBASE		(1ul << 0)
@@ -62,6 +63,9 @@
 /* CPUID.0x8000_0001.EDX */
 #define CPUID_GBPAGES		(1ul << 26)
 
+/* CPUID.0x8000_000A.EDX */
+#define CPUID_NRIPS		BIT(3)
+
 /* Page table bitfield declarations */
 #define PTE_PRESENT_MASK        BIT_ULL(0)
 #define PTE_WRITABLE_MASK       BIT_ULL(1)
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 95f59653dbce..7127873bb0cb 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -25,9 +25,6 @@
 # error This test is 64-bit only
 #endif
 
-#define X86_FEATURE_XSAVE		(1 << 26)
-#define X86_FEATURE_OSXSAVE		(1 << 27)
-
 #define NUM_TILES			8
 #define TILE_SIZE			1024
 #define XSAVE_SIZE			((NUM_TILES * TILE_SIZE) + PAGE_SIZE)
@@ -128,9 +125,9 @@ static inline void check_cpuid_xsave(void)
 	eax = 1;
 	ecx = 0;
 	cpuid(&eax, &ebx, &ecx, &edx);
-	if (!(ecx & X86_FEATURE_XSAVE))
+	if (!(ecx & CPUID_XSAVE))
 		GUEST_ASSERT(!"cpuid: no CPU xsave support!");
-	if (!(ecx & X86_FEATURE_OSXSAVE))
+	if (!(ecx & CPUID_OSXSAVE))
 		GUEST_ASSERT(!"cpuid: no OS xsave support!");
 }
 
@@ -333,7 +330,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	entry = kvm_get_supported_cpuid_entry(1);
-	TEST_REQUIRE(entry->ecx & X86_FEATURE_XSAVE);
+	TEST_REQUIRE(entry->ecx & CPUID_XSAVE);
 
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
 
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index a80940ac420f..8b0bb36205d9 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -19,9 +19,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define X86_FEATURE_XSAVE	(1<<26)
-#define X86_FEATURE_OSXSAVE	(1<<27)
-
 static inline bool cr4_cpuid_is_sync(void)
 {
 	int func, subfunc;
@@ -36,7 +33,7 @@ static inline bool cr4_cpuid_is_sync(void)
 
 	cr4 = get_cr4();
 
-	return (!!(ecx & X86_FEATURE_OSXSAVE)) == (!!(cr4 & X86_CR4_OSXSAVE));
+	return (!!(ecx & CPUID_OSXSAVE)) == (!!(cr4 & X86_CR4_OSXSAVE));
 }
 
 static void guest_code(void)
@@ -70,7 +67,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 
 	entry = kvm_get_supported_cpuid_entry(1);
-	TEST_REQUIRE(entry->ecx & X86_FEATURE_XSAVE);
+	TEST_REQUIRE(entry->ecx & CPUID_XSAVE);
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 1c3f457aa3aa..051f70167074 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -19,7 +19,6 @@
 #include "test_util.h"
 
 #define INT_NR			0x20
-#define X86_FEATURE_NRIPS	BIT(3)
 
 static_assert(ATOMIC_INT_LOCK_FREE == 2, "atomic int is not lockless");
 
@@ -204,7 +203,7 @@ int main(int argc, char *argv[])
 	nested_svm_check_supported();
 
 	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
-	TEST_ASSERT(cpuid->edx & X86_FEATURE_NRIPS,
+	TEST_ASSERT(cpuid->edx & CPUID_NRIPS,
 		    "KVM with nSVM is supposed to unconditionally advertise nRIP Save\n");
 
 	atomic_init(&nmi_stage, 0);
-- 
2.36.1.476.g0c4daa206d-goog

