Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25053D440
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349936AbiFDBVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349916AbiFDBVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9FD562F2
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p2-20020a170902e74200b00164081f682cso5019448plf.16
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ef9NGJEN3v8+dZtpOXtIrU7XxEz/BHhv08MiJDUgRvk=;
        b=NqTkm9aiu/jY2yArYk7P8rLKZzgX000yDMy3OYEoD/ChfzJ2I5EZEZl0Aeaju3IMGU
         hk+TnJUK2bvOooDQBPh8+OKX5a9eV2qWC5rgXWzgJpMmODHgLp5OuowY0PVv3tyal/r3
         emfoeaSFEIfy+Jl+dAcbr4LDWEIsiUOy5vruy70ZMRWGTOkWaKxUnsqchPkKfAyRsNmW
         BqPq3DsbTiop8d4QgHcjxy8nK7hAxeM+j2rb1Ref7S19OupbYpM8eKV4aHtdXHwLe6+E
         /VcdGi0wzTibxPlOMZ0EtI47W2PzcskJ+ym9Wg1cUqz9TggtTmpko26zLAzklSzZzbQe
         8VPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ef9NGJEN3v8+dZtpOXtIrU7XxEz/BHhv08MiJDUgRvk=;
        b=uxS+hIhRAJWi4aBAXInvtCK+c19gpIOXDSeECVhWTZntH24XNveJJOvtsM1uJTBssb
         aijc4e71IEhrXwhvBro1mC1T6ihpf78tcgS0xh3r24ByLM9ExspWyOvzMte3XDvac1CN
         MsG4Zt2361R2QM+oaPf/9PWs6cm3RbtP9ZbRkEJkXIfmsjGI5ErqNxj/wpOojInlWM/C
         2x/9UwopoJ416uRAmA+sjNv7UXmqV/CvlBZm6m5t8zCRl16EeRcyWQvqJi5ZV+h5Udn4
         Z9ePVr/Ei4lEZdB0HS/CMjppNxVh6AjQPESabIuDdeZOwfHDoW3aGa97/Himbo1u/HaY
         XyYw==
X-Gm-Message-State: AOAM5307lmMMo/C3bdQOtn138mZY2WHlFIe27GPBKobp+oxkbZS3UzLJ
        N7xsAGkw6vyJoe8NTjKgP6VRh9imwP8=
X-Google-Smtp-Source: ABdhPJwTUT06O1kcyD2PlmvyTpYrwbs5Kg1SWAbFWikJZN+i+bpk2KOi2XjVhWUHtpD92hInXU/OtUbkBgM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:8101:0:b0:51b:b859:7043 with SMTP id
 t1-20020a628101000000b0051bb8597043mr12784875pfd.25.1654305664077; Fri, 03
 Jun 2022 18:21:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:18 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 02/42] KVM: sefltests: Use CPUID_XSAVE and CPUID_OSXAVE
 instead of X86_FEATURE_*
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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
index 974d08746b39..e47eba48744e 100644
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
2.36.1.255.ge46751e96f-goog

