Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9D36769F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343949AbhDVA5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbhDVA5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:57:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3FAC06138D
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:57:00 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o12-20020a17090ac70cb029014e1b69ef6dso40327pjt.0
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Mp2tqK23tc8zMbZfL/Pl7tKa+i2zyXk9APFPF/poLXo=;
        b=c+Gg7CRAm6krPzXd16k1mZ+9rWMJBMTtfUxd6RAIgeFZL0cyAU1OF1zKKIS+UyfwiA
         I1KgpDzwnJmfxJzVo44K5bjTcY/B/bxjtx25mzjsF9Rc5EniiTCE5cVmh0a8spqccgWI
         Z5s1mzSZJ8ApZPwG0BfcJXpLcU+imQTipvSuUZeLeZPJZnqNRaUpzf/Cel9CRkweXhZ7
         mgwuic84MMAHmMKPKjs4n6DKpxq93aRklBgdZcZxnMosiwHectBgOg3pNV0q95BHoCa3
         seLn6kKaPIknLXcVBDhdgjg/mEfuQf9X2rRHLNDt0QNivHE3KD3R0z98ssrCRrcwmIot
         nNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Mp2tqK23tc8zMbZfL/Pl7tKa+i2zyXk9APFPF/poLXo=;
        b=j2IRelU+tRpb3lkH3boybdPWLLBLrQ7zbsg/JSDTaNu/CYfcKFmCLQgFKTWFT51VjG
         vHOYeX3KlsQkljAZ7RdQuLvN2nHOdhGLropjoo2xqqRw0z4eZPeTn2irDN6IrHutN8TX
         SgezF55QHZu/vuCMbwqmbmznSVDOs8vwQKkfW73NrtbFvclEun+bp0LYSPzucs1EqeNl
         gF8s3inVhb+6heK9GWwV2g969Fc61HebfjM+6OmuFGZ6FucBPj0kucBQCDVLvzyR87Iu
         cpb+zJGr7elZPvy1IxxF9ZPVwKDXKRDs7McZD7qyJR/RIB5U4fS+XRAcNMT2rp1WUp5l
         c3IQ==
X-Gm-Message-State: AOAM5305ms2oL/Et4SJSgUs7GZnLX+5YtaubJB9kxoZrusYG9mmM9GK/
        j/s8b4+p/XZRenFwLE5Fyp3lqPOXHUSxJQ==
X-Google-Smtp-Source: ABdhPJyQ1GPqL173PMaF6Z+ADod0FJl1Q1vwwz/WPAFExvOS/EPcFZQ7VCAPAWdsSXKmQMlBNZw/aZjA4yq5ew==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:361:b029:e9:8392:7abd with SMTP
 id 88-20020a1709020361b02900e983927abdmr809384pld.8.1619053019855; Wed, 21
 Apr 2021 17:56:59 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:56:26 -0700
In-Reply-To: <20210422005626.564163-1-ricarkol@google.com>
Message-Id: <20210422005626.564163-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20210422005626.564163-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 5/5] KVM: selftests: Use kernel x86 cpuid features format
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change all tests checking for x86 cpuid features to use the same cpuid
feature definitions as the kernel (from cpufeatures.h). Also change the
tests to use the utilities introduced in cpuid.h.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 16 ------------
 .../selftests/kvm/include/x86_64/svm_util.h   | 11 ++------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  6 ++---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  5 ++--
 tools/testing/selftests/kvm/steal_time.c      |  5 ++--
 .../kvm/x86_64/cr4_cpuid_sync_test.c          | 23 +++++------------
 .../selftests/kvm/x86_64/set_sregs_test.c     | 25 ++++++++-----------
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  |  8 +++---
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  5 ++--
 .../selftests/kvm/x86_64/xss_msr_test.c       | 10 +++-----
 10 files changed, 36 insertions(+), 78 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..022e00b04fff 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -37,22 +37,6 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
-/* CPUID.1.ECX */
-#define CPUID_VMX		(1ul << 5)
-#define CPUID_SMX		(1ul << 6)
-#define CPUID_PCID		(1ul << 17)
-#define CPUID_XSAVE		(1ul << 26)
-
-/* CPUID.7.EBX */
-#define CPUID_FSGSBASE		(1ul << 0)
-#define CPUID_SMEP		(1ul << 7)
-#define CPUID_SMAP		(1ul << 20)
-
-/* CPUID.7.ECX */
-#define CPUID_UMIP		(1ul << 2)
-#define CPUID_PKU		(1ul << 3)
-#define CPUID_LA57		(1ul << 16)
-
 #define UNEXPECTED_VECTOR_PORT 0xfff0u
 
 /* General Registers in 64-Bit Mode */
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index b7531c83b8ae..adba82ff4c9b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -12,9 +12,7 @@
 #include <stdint.h>
 #include "svm.h"
 #include "processor.h"
-
-#define CPUID_SVM_BIT		2
-#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
+#include "cpuid.h"
 
 #define SVM_EXIT_VMMCALL	0x081
 
@@ -38,12 +36,7 @@ void nested_svm_check_supported(void);
 
 static inline bool cpu_has_svm(void)
 {
-	u32 eax = 0x80000001, ecx;
-
-	asm("cpuid" :
-	    "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
-
-	return ecx & CPUID_SVM;
+	return this_cpu_has(X86_FEATURE_SVM);
 }
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 827fe6028dd4..c68245233cf9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -12,6 +12,7 @@
 #include "../kvm_util_internal.h"
 #include "processor.h"
 #include "svm_util.h"
+#include "cpuid.h"
 
 struct gpr64_regs guest_regs;
 u64 rflags;
@@ -150,10 +151,7 @@ void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
 
 bool nested_svm_supported(void)
 {
-	struct kvm_cpuid_entry2 *entry =
-		kvm_get_supported_cpuid_entry(0x80000001);
-
-	return entry->ecx & CPUID_SVM;
+	return kvm_cpuid_has(X86_FEATURE_SVM);
 }
 
 void nested_svm_check_supported(void)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 2448b30e8efa..be26dcd260a4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -10,6 +10,7 @@
 #include "../kvm_util_internal.h"
 #include "processor.h"
 #include "vmx.h"
+#include "cpuid.h"
 
 #define PAGE_SHIFT_4K  12
 
@@ -381,9 +382,7 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 
 bool nested_vmx_supported(void)
 {
-	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
-
-	return entry->ecx & CPUID_VMX;
+	return kvm_cpuid_has(X86_FEATURE_VMX);
 }
 
 void nested_vmx_check_supported(void)
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fcc840088c91..04d86601de92 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -27,6 +27,8 @@ static uint64_t guest_stolen_time[NR_VCPUS];
 
 #if defined(__x86_64__)
 
+#include "cpuid.h"
+
 /* steal_time must have 64-byte alignment */
 #define STEAL_TIME_SIZE		((sizeof(struct kvm_steal_time) + 63) & ~63)
 
@@ -64,8 +66,7 @@ static void steal_time_init(struct kvm_vm *vm)
 {
 	int i;
 
-	if (!(kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES)->eax &
-	      KVM_FEATURE_STEAL_TIME)) {
+	if (!kvm_pv_has(KVM_FEATURE_STEAL_TIME)) {
 		print_skip("steal-time not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index f40fd097cb35..97e97b258983 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -18,26 +18,17 @@
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "cpuid.h"
 
-#define X86_FEATURE_XSAVE	(1<<26)
-#define X86_FEATURE_OSXSAVE	(1<<27)
 #define VCPU_ID			1
 
 static inline bool cr4_cpuid_is_sync(void)
 {
-	int func, subfunc;
-	uint32_t eax, ebx, ecx, edx;
-	uint64_t cr4;
-
-	func = 0x1;
-	subfunc = 0x0;
-	__asm__ __volatile__("cpuid"
-			     : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
-			     : "a"(func), "c"(subfunc));
-
-	cr4 = get_cr4();
+	uint64_t cr4 = get_cr4();
+	bool cpuid_has_osxsave = this_cpu_has(X86_FEATURE_OSXSAVE);
+	bool cr4_has_osxsave = cr4 & X86_CR4_OSXSAVE;
 
-	return (!!(ecx & X86_FEATURE_OSXSAVE)) == (!!(cr4 & X86_CR4_OSXSAVE));
+	return cpuid_has_osxsave == cr4_has_osxsave;
 }
 
 static void guest_code(void)
@@ -66,12 +57,10 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
-	struct kvm_cpuid_entry2 *entry;
 	struct ucall uc;
 	int rc;
 
-	entry = kvm_get_supported_cpuid_entry(1);
-	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
+	if (!kvm_cpuid_has(X86_FEATURE_XSAVE)) {
 		print_skip("XSAVE feature not supported");
 		return 0;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 318be0bf77ab..e3247f33d765 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -21,6 +21,7 @@
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "cpuid.h"
 
 #define VCPU_ID                  5
 
@@ -47,34 +48,30 @@ static void test_cr4_feature_bit(struct kvm_vm *vm, struct kvm_sregs *orig,
 
 static uint64_t calc_cr4_feature_bits(struct kvm_vm *vm)
 {
-	struct kvm_cpuid_entry2 *cpuid_1, *cpuid_7;
 	uint64_t cr4;
 
-	cpuid_1 = kvm_get_supported_cpuid_entry(1);
-	cpuid_7 = kvm_get_supported_cpuid_entry(7);
-
 	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
 	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
 	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
-	if (cpuid_7->ecx & CPUID_UMIP)
+	if (kvm_cpuid_has(X86_FEATURE_UMIP))
 		cr4 |= X86_CR4_UMIP;
-	if (cpuid_7->ecx & CPUID_LA57)
+	if (kvm_cpuid_has(X86_FEATURE_LA57))
 		cr4 |= X86_CR4_LA57;
-	if (cpuid_1->ecx & CPUID_VMX)
+	if (kvm_cpuid_has(X86_FEATURE_VMX))
 		cr4 |= X86_CR4_VMXE;
-	if (cpuid_1->ecx & CPUID_SMX)
+	if (kvm_cpuid_has(X86_FEATURE_SMX))
 		cr4 |= X86_CR4_SMXE;
-	if (cpuid_7->ebx & CPUID_FSGSBASE)
+	if (kvm_cpuid_has(X86_FEATURE_FSGSBASE))
 		cr4 |= X86_CR4_FSGSBASE;
-	if (cpuid_1->ecx & CPUID_PCID)
+	if (kvm_cpuid_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
-	if (cpuid_1->ecx & CPUID_XSAVE)
+	if (kvm_cpuid_has(X86_FEATURE_XSAVE))
 		cr4 |= X86_CR4_OSXSAVE;
-	if (cpuid_7->ebx & CPUID_SMEP)
+	if (kvm_cpuid_has(X86_FEATURE_SMEP))
 		cr4 |= X86_CR4_SMEP;
-	if (cpuid_7->ebx & CPUID_SMAP)
+	if (kvm_cpuid_has(X86_FEATURE_SMAP))
 		cr4 |= X86_CR4_SMAP;
-	if (cpuid_7->ecx & CPUID_PKU)
+	if (kvm_cpuid_has(X86_FEATURE_PKU))
 		cr4 |= X86_CR4_PKE;
 
 	return cr4;
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
index 23051d84b907..3755451f4877 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
@@ -17,10 +17,10 @@
 
 #include "kvm_util.h"
 #include "vmx.h"
+#include "cpuid.h"
 
 #define VCPU_ID	      0
 
-#define X86_FEATURE_PDCM	(1<<15)
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
@@ -76,7 +76,7 @@ int main(int argc, char *argv[])
 	if (kvm_get_cpuid_max_basic() >= 0xa) {
 		entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
 		entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
-		pdcm_supported = entry_1_0 && !!(entry_1_0->ecx & X86_FEATURE_PDCM);
+		pdcm_supported = kvm_cpuid_has(X86_FEATURE_PDCM);
 		eax.full = entry_a_0->eax;
 	}
 	if (!pdcm_supported) {
@@ -111,13 +111,13 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
 	/* testcase 4, set capabilities when we don't have PDCM bit */
-	entry_1_0->ecx &= ~X86_FEATURE_PDCM;
+	entry_1_0->ecx &= ~feature_bit(PDCM);
 	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
 	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
 	/* testcase 5, set capabilities when we don't have PMU version bits */
-	entry_1_0->ecx |= X86_FEATURE_PDCM;
+	entry_1_0->ecx |= feature_bit(PDCM);
 	eax.split.version_id = 0;
 	entry_1_0->ecx = eax.full;
 	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 5827b9bae468..bea74c9ef0f7 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -11,6 +11,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "cpuid.h"
 
 #include <errno.h>
 #include <linux/kvm.h>
@@ -255,9 +256,9 @@ void disable_vmx(struct kvm_vm *vm)
 			break;
 	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
 
-	cpuid->entries[i].ecx &= ~CPUID_VMX;
+	cpuid->entries[i].ecx &= ~feature_bit(VMX);
 	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
-	cpuid->entries[i].ecx |= CPUID_VMX;
+	cpuid->entries[i].ecx |= feature_bit(VMX);
 }
 
 int main(int argc, char *argv[])
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 3529376747c2..962dbb63cffe 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -11,12 +11,11 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "vmx.h"
+#include "cpuid.h"
 
 #define VCPU_ID	      1
 #define MSR_BITS      64
 
-#define X86_FEATURE_XSAVES	(1<<3)
-
 bool is_supported_msr(u32 msr_index)
 {
 	struct kvm_msr_list *list;
@@ -37,7 +36,6 @@ bool is_supported_msr(u32 msr_index)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry;
 	bool xss_supported = false;
 	struct kvm_vm *vm;
 	uint64_t xss_val;
@@ -46,10 +44,8 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, 0);
 
-	if (kvm_get_cpuid_max_basic() >= 0xd) {
-		entry = kvm_get_supported_cpuid_index(0xd, 1);
-		xss_supported = entry && !!(entry->eax & X86_FEATURE_XSAVES);
-	}
+	if (kvm_get_cpuid_max_basic() >= 0xd)
+		xss_supported = kvm_cpuid_has(X86_FEATURE_XSAVES);
 	if (!xss_supported) {
 		print_skip("IA32_XSS is not supported by the vCPU");
 		exit(KSFT_SKIP);
-- 
2.31.1.368.gbe11c130af-goog

