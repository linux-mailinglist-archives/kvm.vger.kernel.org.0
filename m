Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6C61FF422
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgFRODj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 10:03:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:40025 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgFRODh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 10:03:37 -0400
IronPort-SDR: 988lPZ4RanmIhGHZ/tFfYy6gdTmGP/rQSUsCKk5UxFtJj45ygFlLRYT62dRFquBKgqZISx+V9w
 zor1+UBcpuUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="144094722"
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="144094722"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 07:03:32 -0700
IronPort-SDR: imGXRQKCZKXB03PP+i/S3Hmk2U4QSsVtM/0i5VZ2hU3Sy4FTF+ubpddOPWNP3pyk/y3mNQonN6
 QsM61x7TCFIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="477248114"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2020 07:03:31 -0700
From:   John Andersen <john.s.andersen@intel.com>
To:     nadav.amit@gmail.com, corbet@lwn.net, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        shuah@kernel.org, sean.j.christopherson@intel.com,
        rick.p.edgecombe@intel.com, kvm@vger.kernel.org
Cc:     john.s.andersen@intel.com, kernel-hardening@lists.openwall.com
Subject: [kvm-unit-tests PATCH v2] x86: Add control register pinning tests
Date:   Thu, 18 Jun 2020 07:06:41 -0700
Message-Id: <20200618140641.9762-1-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paravirutalized control register pinning adds MSRs guests can use to
discover which bits in CR0/4 they may pin, and MSRs for activating
pinning for any of those bits.

We check that the bits allowed to be pinned for CR4 are UMIP, SMEP, and
SMAP. Only WP should be allowed to be pinned in CR0.

We turn on all of the allowed bits, pin them, then attempt to disable
them. We verify that the attempt to disable was unsuccessful, and that
it generated a general protection fault.

For nested, we check that for when pinning enabled in L1, changing
HOST_CR0/4 will not result in the un-setting of pinned bits. The VMX CR
pinning tests is it's own test so that the pinning doesn't potentially
affect other tests within the same .flat testing VM.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 x86/Makefile.common |   3 +-
 lib/x86/desc.h      |   1 +
 lib/x86/msr.h       |   8 ++
 lib/x86/processor.h |   6 ++
 lib/x86/desc.c      |   8 ++
 x86/cr_pin_high.c   | 213 ++++++++++++++++++++++++++++++++++++++++++++
 x86/cr_pin_low.c    |  65 ++++++++++++++
 x86/pcid.c          |   8 --
 x86/vmx_tests.c     | 144 ++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  16 +++-
 10 files changed, 462 insertions(+), 10 deletions(-)
 create mode 100644 x86/cr_pin_high.c
 create mode 100644 x86/cr_pin_low.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index ab67ca0..bab7fe2 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
+               $(TEST_DIR)/cr_pin_low.flat $(TEST_DIR)/cr_pin_high.flat
 
 test_cases: $(tests-common) $(tests)
 
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 0fe5cbf..9fb921c 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -211,6 +211,7 @@ extern tss64_t tss;
 #endif
 
 unsigned exception_vector(void);
+int write_cr0_checking(unsigned long val);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 6ef5502..13152a3 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -431,4 +431,12 @@
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+/* KVM MSRs */
+#define MSR_KVM_CR0_PIN_ALLOWED		0x4b564d08
+#define MSR_KVM_CR4_PIN_ALLOWED		0x4b564d09
+#define MSR_KVM_CR0_PINNED_LOW		0x4b564d0a
+#define MSR_KVM_CR0_PINNED_HIGH		0x4b564d0b
+#define MSR_KVM_CR4_PINNED_LOW		0x4b564d0c
+#define MSR_KVM_CR4_PINNED_HIGH		0x4b564d0d
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6e0811e..5bfd296 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -146,6 +146,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
 #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
+#define	X86_FEATURE_SMEP		(CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
 #define	X86_FEATURE_PCOMMIT		(CPUID(0x7, 0, EBX, 22))
 #define	X86_FEATURE_CLFLUSHOPT		(CPUID(0x7, 0, EBX, 23))
@@ -168,6 +169,11 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 
+/*
+ * KVM CPUID features
+ */
+#define	X86_FEATURE_CR_PIN		(CPUID(0x40000001, 0, EAX, 15))
+
 
 static inline bool this_cpu_has(u64 feature)
 {
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..6cf4fac 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -251,6 +251,14 @@ unsigned exception_vector(void)
     return vector;
 }
 
+int write_cr0_checking(unsigned long val)
+{
+    asm volatile(ASM_TRY("1f")
+		 "mov %0, %%cr0\n\t"
+		 "1:" : : "r" (val));
+    return exception_vector();
+}
+
 int write_cr4_checking(unsigned long val)
 {
     asm volatile(ASM_TRY("1f")
diff --git a/x86/cr_pin_high.c b/x86/cr_pin_high.c
new file mode 100644
index 0000000..10914a5
--- /dev/null
+++ b/x86/cr_pin_high.c
@@ -0,0 +1,213 @@
+/* CR pinning tests. Not including pinning CR0 WP low, that lives in
+ * cr_pin_low.c. This file tests that CR pinning prevents the guest VM from
+ * flipping bit pinned via MSRs in control registers. For CR4 we pin UMIP and
+ * SMEP bits high and SMAP low, and verify we can't toggle them after pinning
+ */
+
+#include "libcflat.h"
+#include "x86/desc.h"
+#include "x86/processor.h"
+#include "x86/vm.h"
+#include "x86/msr.h"
+
+#define USER_BASE	(1 << 24)
+
+#define CR0_PINNED X86_CR0_WP
+#define CR4_SOME_PINNED (X86_CR4_UMIP | X86_CR4_SMEP)
+#define CR4_ALL_PINNED (CR4_SOME_PINNED | X86_CR4_SMAP)
+
+static void test_cr0_pinning(void)
+{
+	unsigned long long r = 0;
+	ulong cr0 = read_cr0();
+	int vector = 0;
+
+	r = rdmsr(MSR_KVM_CR0_PIN_ALLOWED);
+	report(r == CR0_PINNED, "[CR0] MSR_KVM_CR0_PIN_ALLOWED: %llx", r);
+
+	cr0 |= CR0_PINNED;
+
+	vector = write_cr0_checking(cr0);
+	report(vector == 0, "[CR0] enable pinned bits. vector: %d", vector);
+
+	cr0 = read_cr0();
+	report((cr0 & CR0_PINNED) == CR0_PINNED,
+	       "[CR0] after enabling pinned bits: %lx", cr0);
+
+	wrmsr(MSR_KVM_CR0_PINNED_HIGH, CR0_PINNED);
+	r = rdmsr(MSR_KVM_CR0_PINNED_HIGH);
+	report(r == CR0_PINNED,
+	       "[CR0] enable pinning. MSR_KVM_CR0_PINNED_HIGH: %llx", r);
+
+	vector = write_cr0_checking(cr0);
+	report(vector == 0, "[CR0] write same value");
+
+	vector = write_cr0_checking(cr0 & ~CR0_PINNED);
+	report(vector == GP_VECTOR,
+	       "[CR0] disable pinned bits. vector: %d", vector);
+
+	cr0 = read_cr0();
+	report((cr0 & CR0_PINNED) == CR0_PINNED,
+	       "[CR0] pinned bits: %lx", cr0 & CR0_PINNED);
+}
+
+static void test_cr4_pin_allowed(void)
+{
+	unsigned long long r = 0;
+
+	r = rdmsr(MSR_KVM_CR4_PIN_ALLOWED);
+	report(r == CR4_ALL_PINNED, "[CR4] MSR_KVM_CR4_PIN_ALLOWED: %llx", r);
+}
+
+static void test_cr4_pinning_some_umip_smep_pinned(void)
+{
+	unsigned long long r = 0;
+	ulong cr4 = read_cr4();
+	int vector = 0;
+
+	cr4 |= CR4_SOME_PINNED;
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0,
+	       "[CR4 SOME] enable pinned bits. vector: %d", vector);
+
+	wrmsr(MSR_KVM_CR4_PINNED_HIGH, CR4_SOME_PINNED);
+	r = rdmsr(MSR_KVM_CR4_PINNED_HIGH);
+	report(r == CR4_SOME_PINNED,
+	       "[CR4 SOME] enable pinning. MSR_KVM_CR4_PINNED_HIGH: %llx", r);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 SOME] after enabling pinned bits: %lx", cr4);
+	report(1, "[CR4 SOME] cr4: 0x%08lx", cr4);
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 SOME] write same value");
+
+	vector = write_cr4_checking(cr4 & ~CR4_SOME_PINNED);
+	report(vector == GP_VECTOR,
+	       "[CR4 SOME] disable pinned bits. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 SOME] pinned bits: %lx", cr4 & CR4_SOME_PINNED);
+
+	vector = write_cr4_checking(cr4 & ~X86_CR4_SMEP);
+	report(vector == GP_VECTOR,
+	       "[CR4 SOME] disable single pinned bit. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 SOME] pinned bits: %lx", cr4 & CR4_SOME_PINNED);
+}
+
+static void test_cr4_pinning_all_umip_smep_high_smap_low_pinned(void)
+{
+	unsigned long long r = 0;
+	ulong cr4 = read_cr4();
+	int vector = 0;
+
+	cr4 |= CR4_SOME_PINNED;
+	cr4 &= ~X86_CR4_SMAP;
+
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] CHECK: %lx", cr4);
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 ALL] write bits to cr4. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] after enabling pinned bits: %lx", cr4);
+
+	wrmsr(MSR_KVM_CR4_PINNED_LOW, X86_CR4_SMAP);
+	r = rdmsr(MSR_KVM_CR4_PINNED_LOW);
+	report(r == X86_CR4_SMAP,
+	       "[CR4 ALL] enable pinning. MSR_KVM_CR4_PINNED_LOW: %llx", r);
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 ALL] write same value");
+
+	cr4 &= ~CR4_SOME_PINNED;
+	cr4 |= X86_CR4_SMAP;
+
+	vector = write_cr4_checking(cr4);
+	report(vector == GP_VECTOR,
+	       "[CR4 ALL] disable pinned bits. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] pinned bits: %lx", cr4 & CR4_ALL_PINNED);
+
+	vector = write_cr4_checking(cr4 | X86_CR4_SMAP);
+	report(vector == GP_VECTOR,
+	       "[CR4 ALL] enable pinned low bit. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] pinned bits: %lx", cr4 & CR4_ALL_PINNED);
+
+	vector = write_cr4_checking(cr4 & ~X86_CR4_SMEP);
+	report(vector == GP_VECTOR,
+	       "[CR4 ALL] disable pinned high bit. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] pinned bits: %lx", cr4 & CR4_ALL_PINNED);
+
+	vector = write_cr4_checking((cr4 & ~X86_CR4_SMEP) | X86_CR4_SMAP);
+	report(vector == GP_VECTOR,
+	       "[CR4 ALL] disable pinned high bit enable pinned low. vector: %d",
+	       vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_SOME_PINNED,
+	       "[CR4 ALL] pinned bits: %lx", cr4 & CR4_ALL_PINNED);
+}
+
+static void test_cr4_pinning(void)
+{
+	test_cr4_pin_allowed();
+
+	if (!this_cpu_has(X86_FEATURE_UMIP)) {
+		printf("UMIP not available\n");
+		return;
+	}
+
+	if (!this_cpu_has(X86_FEATURE_SMEP)) {
+		printf("SMEP not available\n");
+		return;
+	}
+
+	test_cr4_pinning_some_umip_smep_pinned();
+
+	if (!this_cpu_has(X86_FEATURE_SMAP)) {
+		printf("SMAP not enabled\n");
+		return;
+	}
+
+	test_cr4_pinning_all_umip_smep_high_smap_low_pinned();
+}
+
+int main(int ac, char **av)
+{
+	unsigned long i;
+
+	if (!this_cpu_has(X86_FEATURE_CR_PIN)) {
+		report_skip("CR pining not detected");
+		return report_summary();
+	}
+
+	setup_idt();
+	setup_vm();
+
+	// Map first 16MB as supervisor pages
+	for (i = 0; i < USER_BASE; i += PAGE_SIZE)
+		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
+
+	test_cr0_pinning();
+	test_cr4_pinning();
+
+	return report_summary();
+}
+
diff --git a/x86/cr_pin_low.c b/x86/cr_pin_low.c
new file mode 100644
index 0000000..22a4594
--- /dev/null
+++ b/x86/cr_pin_low.c
@@ -0,0 +1,65 @@
+/* CR pinning tests to check that WP bit in CR0 be pinned low correctly. This
+ * has to be in a separate file than the CR0 high pinning because once pinned we
+ * can't unpin from the guest. So we can't switch from high pinning to low
+ * pinning to test within the same file / VM
+ */
+
+#include "libcflat.h"
+#include "x86/desc.h"
+#include "x86/processor.h"
+#include "x86/vm.h"
+#include "x86/msr.h"
+
+#define USER_BASE	(1 << 24)
+
+#define CR0_PINNED X86_CR0_WP
+
+static void test_cr0_pinning_low(void)
+{
+	unsigned long long r = 0;
+	ulong cr0 = read_cr0();
+	int vector = 0;
+
+	r = rdmsr(MSR_KVM_CR0_PIN_ALLOWED);
+	report(r == CR0_PINNED, "[CR0] MSR_KVM_CR0_PIN_ALLOWED: %llx", r);
+
+	cr0 &= ~CR0_PINNED;
+
+	vector = write_cr0_checking(cr0);
+	report(vector == 0, "[CR0] enable pinned bits. vector: %d", vector);
+
+	cr0 = read_cr0();
+	report((cr0 & CR0_PINNED) != CR0_PINNED,
+	       "[CR0] after enabling pinned bits: %lx", cr0);
+
+	wrmsr(MSR_KVM_CR0_PINNED_LOW, CR0_PINNED);
+	r = rdmsr(MSR_KVM_CR0_PINNED_LOW);
+	report(r == CR0_PINNED,
+	       "[CR0] enable pinning. MSR_KVM_CR0_PINNED_LOW: %llx", r);
+
+	vector = write_cr0_checking(cr0);
+	report(vector == 0, "[CR0] write same value");
+
+	vector = write_cr0_checking(cr0 | CR0_PINNED);
+	report(vector == GP_VECTOR,
+	       "[CR0] disable pinned bits. vector: %d", vector);
+
+	cr0 = read_cr0();
+	report((cr0 & CR0_PINNED) != CR0_PINNED,
+	       "[CR0] pinned bits: %lx", cr0 & CR0_PINNED);
+}
+
+int main(int ac, char **av)
+{
+	if (!this_cpu_has(X86_FEATURE_CR_PIN)) {
+		report_skip("CR pining not detected");
+		return report_summary();
+	}
+
+	setup_idt();
+
+	test_cr0_pinning_low();
+
+	return report_summary();
+}
+
diff --git a/x86/pcid.c b/x86/pcid.c
index a8dc8cb..5688699 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -10,14 +10,6 @@ struct invpcid_desc {
     unsigned long addr : 64;
 };
 
-static int write_cr0_checking(unsigned long val)
-{
-    asm volatile(ASM_TRY("1f")
-                 "mov %0, %%cr0\n\t"
-                 "1:": : "r" (val));
-    return exception_vector();
-}
-
 static int invpcid_checking(unsigned long type, void *desc)
 {
     asm volatile (ASM_TRY("1f")
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 68f93d3..c4a89dd 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7929,6 +7929,148 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
+#define USER_BASE	(1 << 24)
+
+#define CR0_PINNED X86_CR0_WP
+#define CR4_SOME_PINNED (X86_CR4_UMIP | X86_CR4_SMEP)
+#define CR4_ALL_PINNED (CR4_SOME_PINNED | X86_CR4_SMAP)
+
+static void vmx_cr_pin_test_guest(void)
+{
+	unsigned long i, cr0, cr4;
+
+	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
+	/* nop */
+
+	/* Step 2. Setup supervisor pages so that we can enable SMAP */
+	setup_vm();
+	for (i = 0; i < USER_BASE; i += PAGE_SIZE) {
+		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
+	}
+
+	/* Step 3. Enable CR0/4 bits */
+	cr0 = read_cr0() | X86_CR0_WP;
+	TEST_ASSERT(!write_cr0_checking(cr0));
+	cr0 = read_cr0();
+	report(cr0 & X86_CR0_WP, "L2 cr0 has WP bit: cr0(%lx)", cr0);
+
+	cr4 = read_cr4() | CR4_ALL_PINNED;
+	TEST_ASSERT(!write_cr4_checking(cr4));
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_ALL_PINNED,
+		"L2 cr4 has correct bits: cr4(%lx)", cr4);
+
+	/* Step 3. Call to host */
+	vmx_set_test_stage(1);
+	vmcall();
+
+	/* Step 4. Disable bits that the host has pinned to make sure host
+	 * pinning doesn't effect us.
+	 */
+	cr0 = read_cr0() & ~X86_CR0_WP;
+	TEST_ASSERT(!write_cr0_checking(cr0));
+	cr0 = read_cr0();
+	report(!(cr0 & X86_CR0_WP),
+		"L2 cr0 should not have host pinned WP bit: cr0(%lx)", cr0);
+
+	cr4 = read_cr4() & ~CR4_ALL_PINNED;
+	TEST_ASSERT(!write_cr4_checking(cr4));
+	cr4 = read_cr4();
+	report(!(cr4 & CR4_ALL_PINNED),
+		"L2 cr4 should not have host pinned bits: cr4(%lx)", cr4);
+
+	/* Step 5. Call to host */
+	vmx_set_test_stage(2);
+	vmcall();
+
+	/* Step 6. Ensure CR registers still do not contain L1 pinned values */
+	report(!(cr0 & X86_CR0_WP),
+		"L2 cr0 should still not have host pinned WP bit: cr0(%lx)", cr0);
+	report(!(cr4 & CR4_ALL_PINNED),
+		"L2 cr4 should still not have host pinned bits: cr4(%lx)", cr4);
+
+	vmx_set_test_stage(3);
+}
+
+static void vmx_cr_pin_test(void)
+{
+	unsigned long long r = 0;
+	unsigned long i, cr0, cr4;
+
+	/* Step 1. Ensure we have required CR4 bits / KVM support for pinning */
+	if (!this_cpu_has(X86_FEATURE_CR_PIN)) {
+		report_skip("CR pining not detected");
+		return;
+	}
+	if (!this_cpu_has(X86_FEATURE_UMIP)) {
+		report_skip("UMIP not detected");
+		return;
+	}
+	if (!this_cpu_has(X86_FEATURE_SMEP)) {
+		report_skip("SMEP not detected");
+		return;
+	}
+	if (!this_cpu_has(X86_FEATURE_SMAP)) {
+		report_skip("SMAP not detected");
+		return;
+	}
+
+	/* Step 2. Setup supervisor pages so that we can enable SMAP */
+	setup_vm();
+	for (i = 0; i < USER_BASE; i += PAGE_SIZE) {
+		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
+	}
+
+	/* Step 3. Enable CR0/4 bits */
+	cr0 = read_cr0() | X86_CR0_WP;
+	TEST_ASSERT(!write_cr0_checking(cr0));
+	cr0 = read_cr0();
+	report(cr0 & X86_CR0_WP, "L1 cr0 has WP bit: cr0(%lx)", cr0);
+
+	cr4 = read_cr4() | CR4_ALL_PINNED;
+	TEST_ASSERT(!write_cr4_checking(cr4));
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_ALL_PINNED,
+		"L1 cr4 has correct bits: cr4(%lx)", cr4);
+
+	/* Step 3. Pin CR0/4 bits */
+	wrmsr(MSR_KVM_CR0_PINNED_HIGH, CR0_PINNED);
+	r = rdmsr(MSR_KVM_CR0_PINNED_HIGH);
+	report(r == X86_CR0_WP, "MSR_KVM_CR0_PINNED_HIGH: %llx", r);
+
+	wrmsr(MSR_KVM_CR4_PINNED_HIGH, CR4_ALL_PINNED);
+	r = rdmsr(MSR_KVM_CR4_PINNED_HIGH);
+	report(r == CR4_ALL_PINNED, "MSR_KVM_CR4_PINNED_HIGH: %llx", r);
+
+	/* Step 4. Enter guest for first time */
+	test_set_guest(vmx_cr_pin_test_guest);
+	enter_guest();
+	skip_exit_vmcall();
+	TEST_ASSERT_EQ(vmx_get_test_stage(), 1);
+
+	/* Step 5. Modify VMCS so that Host-state contains unpinned cr values */
+	vmcs_write(HOST_CR0, read_cr0() & ~X86_CR0_WP);
+	vmcs_write(HOST_CR4, read_cr4() & ~CR4_ALL_PINNED);
+
+	/* Step 6. Enter guest second time */
+	enter_guest();
+	skip_exit_vmcall();
+	TEST_ASSERT_EQ(vmx_get_test_stage(), 2);
+
+	/* Step 7. Ensure CR registers still contain pinned values */
+	cr0 = read_cr0();
+	cr4 = read_cr4();
+	report(cr0 & X86_CR0_WP,
+		"L1 cr0 WP bit still pinned: cr0(%lx)", cr0);
+	report((cr4 & CR4_ALL_PINNED) == CR4_ALL_PINNED,
+		"L1 cr4 bits still pinned: cr4(%lx)", cr4);
+
+	/* Step 8. Run L2 to completion */
+	enter_guest();
+	skip_exit_vmcall();
+	TEST_ASSERT_EQ(vmx_get_test_stage(), 3);
+}
+
 static void vmx_cr_load_test(void)
 {
 	unsigned long cr3, cr4, orig_cr3, orig_cr4;
@@ -10050,6 +10192,8 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_init_signal_test),
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
+	/* CR pinning tests */
+	TEST(vmx_cr_pin_test),
 	/* Regression tests */
 	TEST(vmx_cr_load_test),
 	TEST(vmx_nm_test),
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 504e04e..708bca4 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -245,9 +245,17 @@ arch = x86_64
 file = umip.flat
 extra_params = -cpu qemu64,+umip
 
+[cr_pin_low]
+file = cr_pin_low.flat
+extra_params = -cpu qemu64,+umip,+smap,+smep
+
+[cr_pin_high]
+file = cr_pin_high.flat
+extra_params = -cpu qemu64,+umip,+smap,+smep
+
 [vmx]
 file = vmx.flat
-extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
+extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -vmx_cr_pin_test"
 arch = x86_64
 groups = vmx
 
@@ -306,6 +314,12 @@ extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
 
+[vmx_cr_pin_test]
+file = vmx.flat
+extra_params = -cpu host,+vmx -append vmx_cr_pin_test
+arch = x86_64
+groups = vmx
+
 [debug]
 file = debug.flat
 arch = x86_64
-- 
2.21.0

