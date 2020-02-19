Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E50164D46
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgBSSDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 13:03:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:17830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgBSSDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 13:03:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 10:03:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="436312513"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 19 Feb 2020 10:03:50 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     John Andersen <john.s.andersen@intel.com>
Subject: [PATCH 1/1] x86: Add control register pinning test
Date:   Wed, 19 Feb 2020 10:04:36 -0800
Message-Id: <20200219180436.6580-2-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200219180436.6580-1-john.s.andersen@intel.com>
References: <20200219180436.6580-1-john.s.andersen@intel.com>
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

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 x86/Makefile.common |   3 +-
 lib/x86/desc.h      |   1 +
 lib/x86/processor.h |   1 +
 lib/x86/desc.c      |   8 +++
 x86/cr_pin.c        | 163 ++++++++++++++++++++++++++++++++++++++++++++
 x86/pcid.c          |   8 ---
 x86/unittests.cfg   |   4 ++
 7 files changed, 179 insertions(+), 9 deletions(-)
 create mode 100644 x86/cr_pin.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index ab67ca0..bb5e786 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
+               $(TEST_DIR)/cr_pin.flat
 
 test_cases: $(tests-common) $(tests)
 
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 00b9328..89df883 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -216,6 +216,7 @@ extern tss64_t tss;
 #endif
 
 unsigned exception_vector(void);
+int write_cr0_checking(unsigned long val);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 03fdf64..dedbac0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -141,6 +141,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
 #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
+#define	X86_FEATURE_SMEP		(CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
 #define	X86_FEATURE_PCOMMIT		(CPUID(0x7, 0, EBX, 22))
 #define	X86_FEATURE_CLFLUSHOPT		(CPUID(0x7, 0, EBX, 23))
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..c9363d0 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -251,6 +251,14 @@ unsigned exception_vector(void)
     return vector;
 }
 
+int write_cr0_checking(unsigned long val)
+{
+    asm volatile(ASM_TRY("1f")
+                 "mov %0, %%cr0\n\t"
+                 "1:": : "r" (val));
+    return exception_vector();
+}
+
 int write_cr4_checking(unsigned long val)
 {
     asm volatile(ASM_TRY("1f")
diff --git a/x86/cr_pin.c b/x86/cr_pin.c
new file mode 100644
index 0000000..fd25043
--- /dev/null
+++ b/x86/cr_pin.c
@@ -0,0 +1,163 @@
+/* cr pinning tests */
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
+#define MSR_KVM_CR0_PIN_ALLOWED	0x4b564d06
+#define MSR_KVM_CR4_PIN_ALLOWED	0x4b564d07
+#define MSR_KVM_CR0_PINNED	0x4b564d08
+#define MSR_KVM_CR4_PINNED	0x4b564d09
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
+	report((cr0 & CR0_PINNED) == CR0_PINNED, "[CR0] after enabling pinned bits: %lx", cr0);
+
+	wrmsr(MSR_KVM_CR0_PINNED, CR0_PINNED);
+	r = rdmsr(MSR_KVM_CR0_PINNED);
+	report(r == CR0_PINNED, "[CR0] enable pinning. MSR_KVM_CR0_PINNED: %llx", r);
+
+	vector = write_cr0_checking(cr0);
+	report(vector == 0, "[CR0] write same value");
+
+	vector = write_cr0_checking(cr0 & ~CR0_PINNED);
+	report(vector == GP_VECTOR, "[CR0] disable pinned bits. vector: %d", vector);
+
+	cr0 = read_cr0();
+	report((cr0 & CR0_PINNED) == CR0_PINNED, "[CR0] pinned bits: %lx", cr0 & CR0_PINNED);
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
+static void test_cr4_pinning_some_pinned(void)
+{
+	unsigned long long r = 0;
+	ulong cr4 = read_cr4();
+	int vector = 0;
+
+	cr4 |= CR4_SOME_PINNED;
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 SOME] enable pinned bits. vector: %d", vector);
+
+	wrmsr(MSR_KVM_CR4_PINNED, CR4_SOME_PINNED);
+	r = rdmsr(MSR_KVM_CR4_PINNED);
+	report(r == CR4_SOME_PINNED, "[CR4 SOME] enable pinning. MSR_KVM_CR4_PINNED: %llx", r);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED, "[CR4 SOME] after enabling pinned bits: %lx", cr4);
+	report(1, "[CR4 SOME] cr4: 0x%08lx", cr4);
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 SOME] write same value");
+
+	vector = write_cr4_checking(cr4 & ~CR4_SOME_PINNED);
+	report(vector == GP_VECTOR, "[CR4 SOME] disable pinned bits. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED, "[CR4 SOME] pinned bits: %lx", cr4 & CR4_SOME_PINNED);
+
+	vector = write_cr4_checking(cr4 & ~X86_CR4_SMEP);
+	report(vector == GP_VECTOR, "[CR4 SOME] disable single pinned bit. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_SOME_PINNED) == CR4_SOME_PINNED, "[CR4 SOME] pinned bits: %lx", cr4 & CR4_SOME_PINNED);
+}
+
+static void test_cr4_pinning_all_pinned(void)
+{
+	unsigned long long r = 0;
+	ulong cr4 = read_cr4();
+	int vector = 0;
+
+	wrmsr(MSR_KVM_CR4_PINNED, CR4_ALL_PINNED);
+	r = rdmsr(MSR_KVM_CR4_PINNED);
+	report(r == CR4_ALL_PINNED, "[CR4 ALL] enable pinning. MSR_KVM_CR4_PINNED: %llx", r);
+
+	cr4 |= CR4_ALL_PINNED;
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 ALL] enable pinned bits. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_ALL_PINNED, "[CR4 ALL] after enabling pinned bits: %lx", cr4);
+
+	vector = write_cr4_checking(cr4);
+	report(vector == 0, "[CR4 ALL] write same value");
+
+	vector = write_cr4_checking(cr4 & ~CR4_ALL_PINNED);
+	report(vector == GP_VECTOR, "[CR4 ALL] disable pinned bits. vector: %d", vector);
+
+	cr4 = read_cr4();
+	report((cr4 & CR4_ALL_PINNED) == CR4_ALL_PINNED, "[CR4 ALL] pinned bits: %lx", cr4 & CR4_ALL_PINNED);
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
+	test_cr4_pinning_some_pinned();
+
+	if (!this_cpu_has(X86_FEATURE_SMAP)) {
+		printf("SMAP not enabled\n");
+		return;
+	}
+
+	test_cr4_pinning_all_pinned();
+}
+
+int main(int ac, char **av)
+{
+	unsigned long i;
+
+	setup_idt();
+	setup_vm();
+
+	// Map first 16MB as supervisor pages
+	for (i = 0; i < USER_BASE; i += PAGE_SIZE) {
+		*get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
+	}
+
+	test_cr0_pinning();
+	test_cr4_pinning();
+
+	return report_summary();
+}
+
diff --git a/x86/pcid.c b/x86/pcid.c
index ad9d30c..1f36f7d 100644
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
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f2401eb..5630bb6 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -245,6 +245,10 @@ arch = x86_64
 file = umip.flat
 extra_params = -cpu qemu64,+umip
 
+[cr_pin]
+file = cr_pin.flat
+extra_params = -cpu qemu64,+umip,+smap,+smep
+
 [vmx]
 file = vmx.flat
 extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
-- 
2.21.0

