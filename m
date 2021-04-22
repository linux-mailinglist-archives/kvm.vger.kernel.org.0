Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A23677B8
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhDVDGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbhDVDGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:11 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B63EC06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h23-20020a05620a0537b02902e08ab174dbso11064231qkh.19
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l0jHoEdZJLgHn87Du0/1kCMx1v3+HbqwGh5r38gtgKI=;
        b=vKqDkJfr9fJvnQbURxzjpUKWEMa1WHDWzNdud3DhQjH8wcjeQCf/mmSHk8J0/YWhBb
         CpBC3P3FXSZAOdo9kwjfgt0NJxDZMcGT++AZiDdmuWhqViZsNMMlGWWnmhQEalVP5ExU
         MGcCEEUkWIs2iUCutvl0d87elR6U4SK8Yd+CYGrKQkjhoIEkG9Ah/wG5Urk/hJzJfPSz
         bQE+PpYUVnDGynhyN5EetjFi/R4EDukqejhnqp8ZNTKAUvaxeMY6944Rkfz7K+VBycs4
         Ob3WXLmFeNHQ51HRWpkqj+fKiM2j/jW+8HSrJEr09UR4mhweVagURSkw22js9itF5EH/
         U8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l0jHoEdZJLgHn87Du0/1kCMx1v3+HbqwGh5r38gtgKI=;
        b=huYn8ANGtaHlvSOu2q7oiYGrDaSBA6OeOeMuBH7ADAaAzv7ey5sbZAaORZApSxuUWO
         WP9pBe3sYqJgmMQ9LFE1vDcHO+xqNRhW3NGgPJdhSRP3VUwvD0JKaSXNs3v2rR/VD/JD
         bQOKVsG06c9PUPn3F4KiXCsdx8T4TSRTnPE9jHY5IrkGH/qfLycLZQiwa0vfvA9EE1oK
         dcWmErWqFYTLxIr44r6pcalVeWkHBHP+tgVq8br5tLA/AEKPWnz9UbHjiBJfL7/VEiwx
         l83hdc/gWr2TkO2ih49P/ygxUNocNRrqntUZn3cc3jonDsowT4pW7Eo2ISK0iGdbPBjF
         UAAg==
X-Gm-Message-State: AOAM530cLHGg3VDtwmvguz9/BLN7TWT1M61fJg0ziTSHOJFTvOcmVCej
        FTl7R3sIvUCPOiE5DGLF3i2UDEvs1/c=
X-Google-Smtp-Source: ABdhPJwIbKZ7KYeTZgnvQIgOzL1PXOQC5C7Xv2APHpHzL53LqCz3hNKNzcWywuNwcXPsRN1IaUOzrRW5xJk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a0c:f54e:: with SMTP id p14mr1353628qvm.61.1619060735699;
 Wed, 21 Apr 2021 20:05:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:05:02 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 12/14] x86: msr: Verify 64-bit only MSRs fault
 on 32-bit hosts
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that 64-bit only MSRs take a #GP when read or written on 32-bit
hosts, as opposed to simply skipping the MSRs on 32-bit builds.  Force
"cpu -host" so that CPUID can be used to check for 64-bit support.

Technically, the unit test could/should be even more aggressive and
require KVM to inject faults if the vCPU model doesn't support 64-bit
mode.  But, there are no plans to go to that level of emulation in KVM,
and practically speaking there isn't much benefit as allowing a 32-bit
vCPU to access the MSRs on a 64-bit host is a benign virtualization hole.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 22 +++++++++++++++++
 x86/msr.c           | 57 ++++++++++++++++++++++++++++++++-------------
 x86/unittests.cfg   |  6 +++--
 3 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index dda57a1..dfe96d0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -2,6 +2,7 @@
 #define LIBCFLAT_PROCESSOR_H
 
 #include "libcflat.h"
+#include "desc.h"
 #include "msr.h"
 #include <stdint.h>
 
@@ -163,6 +164,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
+#define	X86_FEATURE_LM			(CPUID(0x80000001, 0, EDX, 29))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
 /*
@@ -320,6 +322,26 @@ static inline void wrmsr(u32 index, u64 val)
     asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
+static inline int rdmsr_checking(u32 index)
+{
+	asm volatile (ASM_TRY("1f")
+		      "rdmsr\n\t"
+		      "1:"
+		      : : "c"(index) : "memory", "eax", "edx");
+	return exception_vector();
+}
+
+static inline int wrmsr_checking(u32 index, u64 val)
+{
+        u32 a = val, d = val >> 32;
+
+	asm volatile (ASM_TRY("1f")
+		      "wrmsr\n\t"
+		      "1:"
+		      : : "a"(a), "d"(d), "c"(index) : "memory");
+	return exception_vector();
+}
+
 static inline uint64_t rdpmc(uint32_t index)
 {
     uint32_t a, d;
diff --git a/x86/msr.c b/x86/msr.c
index 4642451..e7ebe8b 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -6,6 +6,7 @@
 
 struct msr_info {
 	int index;
+	bool is_64bit_only;
 	const char *name;
 	unsigned long long value;
 };
@@ -14,26 +15,26 @@ struct msr_info {
 #define addr_64 0x0000123456789abcULL
 #define addr_ul (unsigned long)addr_64
 
-#define MSR_TEST(msr, val)	\
-	{ .index = msr, .name = #msr, .value = val }
+#define MSR_TEST(msr, val, only64)	\
+	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
 
 struct msr_info msr_info[] =
 {
-	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234),
-	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul),
-	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul),
+	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, false),
+	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
+	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889),
-	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707),
+	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
+	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
+	MSR_TEST(MSR_FS_BASE, addr_64, true),
+	MSR_TEST(MSR_GS_BASE, addr_64, true),
+	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64, true),
 #ifdef __x86_64__
-	MSR_TEST(MSR_FS_BASE, addr_64),
-	MSR_TEST(MSR_GS_BASE, addr_64),
-	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64),
-	MSR_TEST(MSR_EFER, 0xD00),
-	MSR_TEST(MSR_LSTAR, addr_64),
-	MSR_TEST(MSR_CSTAR, addr_64),
-	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff),
+	MSR_TEST(MSR_EFER, 0xD00, false),
 #endif
+	MSR_TEST(MSR_LSTAR, addr_64, true),
+	MSR_TEST(MSR_CSTAR, addr_64, true),
+	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, true),
 //	MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
 //	MSR_VM_HSAVE_PA only AMD host
 };
@@ -54,12 +55,36 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 	report(val == r, "%s", msr->name);
 }
 
+static void test_wrmsr_fault(struct msr_info *msr, unsigned long long val)
+{
+	unsigned char vector = wrmsr_checking(msr->index, val);
+
+	report(vector == GP_VECTOR,
+	       "Expected #GP on WRSMR(%s, 0x%llx), got vector %d",
+	       msr->name, val, vector);
+}
+
+static void test_rdmsr_fault(struct msr_info *msr)
+{
+	unsigned char vector = rdmsr_checking(msr->index);
+
+	report(vector == GP_VECTOR,
+	       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
+}
+
 int main(int ac, char **av)
 {
+	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
 	int i;
 
-	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
-		test_msr_rw(&msr_info[i], msr_info[i].value);
+	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
+		if (is_64bit_host || !msr_info[i].is_64bit_only) {
+			test_msr_rw(&msr_info[i], msr_info[i].value);
+		} else {
+			test_wrmsr_fault(&msr_info[i], msr_info[i].value);
+			test_rdmsr_fault(&msr_info[i]);
+		}
+	}
 
 	return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index c2608bc..29cfe51 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -168,9 +168,11 @@ arch = x86_64
 
 [msr]
 # Use GenuineIntel to ensure SYSENTER MSRs are fully preserved, and to test
-# SVM emulation of Intel CPU behavior.
+# SVM emulation of Intel CPU behavior.  Use the host CPU model so that 64-bit
+# support follows the host kernel.  Running a 32-bit guest on a 64-bit host
+# will fail due to shortcomings in KVM.
 file = msr.flat
-extra_params = -cpu qemu64,vendor=GenuineIntel
+extra_params = -cpu host,vendor=GenuineIntel
 
 [pmu]
 file = pmu.flat
-- 
2.31.1.498.g6c1eba8ee3d-goog

