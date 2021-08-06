Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA7C3E2425
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbhHFHbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:31:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:38578 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243884AbhHFHa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 03:30:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="275370442"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="275370442"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523367386"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 06 Aug 2021 00:30:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Add Arch LBR unit-test application
Date:   Fri,  6 Aug 2021 15:43:52 +0800
Message-Id: <1628235832-26608-1-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit-test app targets to check whehter Arch LBR is enabled
for guest. XSAVES/XRSTORS are used to accelerate LBR MSR save/restore.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/Makefile.x86_64 |   1 +
 x86/pmu_arch_lbr.c  | 221 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   6 ++
 3 files changed, 228 insertions(+)
 create mode 100644 x86/pmu_arch_lbr.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..0727830 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
 tests += $(TEST_DIR)/pks.flat
 tests += $(TEST_DIR)/pmu_lbr.flat
+tests += $(TEST_DIR)/pmu_arch_lbr.flat
 
 ifneq ($(fcf_protection_full),)
 tests += $(TEST_DIR)/cet.flat
diff --git a/x86/pmu_arch_lbr.c b/x86/pmu_arch_lbr.c
new file mode 100644
index 0000000..9a1e562
--- /dev/null
+++ b/x86/pmu_arch_lbr.c
@@ -0,0 +1,221 @@
+#include "asm-generic/page.h"
+#include "x86/processor.h"
+#include "x86/msr.h"
+#include "x86/desc.h"
+#include "bitops.h"
+
+#define MSR_ARCH_LBR_CTL                0x000014ce
+#define MSR_ARCH_LBR_DEPTH              0x000014cf
+#define MSR_ARCH_LBR_FROM_0             0x00001500
+#define MSR_ARCH_LBR_TO_0               0x00001600
+#define MSR_ARCH_LBR_INFO_0             0x00001200
+
+#define MSR_IA32_XSS                    0x00000da0
+
+#define IA32_XSS_ARCH_LBR               (1UL << 15)
+#define CR4_OSXSAVE_BIT                 (1UL << 18)
+#define CPUID_EDX_ARCH_LBR              (1UL << 19)
+
+#define ARCH_LBR_CTL_BITS               0x3f0003
+#define MAX_LBR_DEPTH                   32
+
+#define XSAVES		".byte 0x48,0x0f,0xc7,0x2f\n\t"
+#define XRSTORS		".byte 0x48,0x0f,0xc7,0x1f\n\t"
+
+struct xstate_header {
+	u64 xfeatures;
+	u64 xcomp_bv;
+	u64 reserved[6];
+} __attribute__((packed));
+
+struct arch_lbr_entry {
+	u64 lbr_from;
+	u64 lbr_to;
+	u64 lbr_info;
+}__attribute__((packed));
+
+struct arch_lbr_struct {
+	u64 lbr_ctl;
+	u64 lbr_depth;
+	u64 ler_from;
+	u64 ler_to;
+	u64 ler_info;
+	struct arch_lbr_entry lbr_records[MAX_LBR_DEPTH];
+}__attribute__((packed));
+
+struct xsave_struct {
+	u8 fpu_sse[512];
+	struct xstate_header xstate_hdr;
+	struct arch_lbr_struct records;
+} __attribute__((packed));
+
+u8 __attribute__((__aligned__(64))) xsave_buffer[PAGE_SIZE];
+
+struct xsave_struct *test_buf = (struct xsave_struct *)xsave_buffer;
+
+u64 lbr_from[MAX_LBR_DEPTH], lbr_to[MAX_LBR_DEPTH], lbr_info[MAX_LBR_DEPTH];
+
+u64 lbr_ctl, lbr_depth;
+
+volatile int count;
+
+static __attribute__((noinline)) int compute_flag(int i)
+{
+	if (i % 10 < 4)
+		return i + 1;
+	return 0;
+}
+
+static __attribute__((noinline)) int lbr_test(void)
+{
+	int i;
+	int flag;
+	volatile double x = 1212121212, y = 121212;
+
+	for (i = 0; i < 200000000; i++) {
+		flag = compute_flag(i);
+		count++;
+		if (flag)
+			x += x / y + y / x;
+	}
+	return 0;
+}
+
+static inline void xrstors(struct xsave_struct *fx, unsigned long  mask)
+{
+        u32 lmask = mask;
+        u32 hmask = mask >> 32;
+
+        asm volatile(XRSTORS
+                     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+                     : "memory");
+}
+
+static inline int xsaves(struct xsave_struct *fx, unsigned long mask)
+{
+        u32 lmask = mask;
+        u32 hmask = mask >> 32;
+	int err = 0;
+
+        asm volatile(XSAVES
+                     : [err] "=r" (err)  : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+                     : "memory");
+	return err;
+}
+
+static void clear_lbr_records(void)
+{
+	int i;
+
+	for (i = 0; i < lbr_depth; ++i) {
+		wrmsr(MSR_ARCH_LBR_FROM_0 + i, 0);
+		wrmsr(MSR_ARCH_LBR_TO_0 + i, 0);
+		wrmsr(MSR_ARCH_LBR_INFO_0 + i, 0);
+	}
+}
+
+static bool check_xsaves_records(void)
+{
+	int i;
+	struct arch_lbr_entry *records = test_buf->records.lbr_records;
+
+	for (i = 0; i < lbr_depth; ++i) {
+		if (lbr_from[i] != (*(records + i)).lbr_from ||
+		    lbr_to[i] != (*(records + i)).lbr_to ||
+		    lbr_info[i] != (*(records + i)).lbr_info)
+			break;
+	}
+
+	return i == lbr_depth;
+}
+
+static bool check_msrs_records(void)
+{
+	int i;
+
+	for (i = 0; i < lbr_depth; ++i) {
+		if (lbr_from[i] != rdmsr(MSR_ARCH_LBR_FROM_0 + i) ||
+		    lbr_to[i] != rdmsr(MSR_ARCH_LBR_TO_0 + i) ||
+		    lbr_info[i] != rdmsr(MSR_ARCH_LBR_INFO_0 + i))
+			break;
+	}
+
+	return i == lbr_depth;
+}
+
+static void test_with_xsaves(void)
+{
+	u32 cr4;
+
+	/* Only test Arch LBR save/restore, ignore other features.*/
+	wrmsr(MSR_IA32_XSS, IA32_XSS_ARCH_LBR);
+
+	cr4 = read_cr4();
+	write_cr4(cr4 | CR4_OSXSAVE_BIT);
+
+	xsaves(test_buf, IA32_XSS_ARCH_LBR | 0x3);
+
+	report(check_xsaves_records(),
+	       "The LBR records in XSAVES area match the MSR values!");
+
+	clear_lbr_records();
+
+	xrstors(test_buf, IA32_XSS_ARCH_LBR | 0x3);
+
+	report(check_msrs_records(),
+	       "The restored LBR MSR values match the original ones!");
+}
+
+int main(int ac, char **av)
+{
+	struct cpuid id;
+	int i;
+
+	id = cpuid(0x7);
+	if (!(id.d & CPUID_EDX_ARCH_LBR)) {
+		printf("No Arch LBR is detected!\n");
+		return report_summary();
+	}
+
+	id = raw_cpuid(0xd, 1);
+	if (!(id.a & 0x8)) {
+		printf("XSAVES is not supported!.\n");
+		return report_summary();
+	}
+
+	setup_vm();
+
+	id = cpuid(0x1c);
+	lbr_depth = (fls(id.a & 0xff) + 1)*8;
+
+	wrmsr(MSR_ARCH_LBR_DEPTH, lbr_depth);
+
+	lbr_ctl = ARCH_LBR_CTL_BITS;
+	wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
+
+	lbr_test();
+
+	/* Disable Arch LBR sampling before run sanity checks. */
+	lbr_ctl &= ~0x1;
+	wrmsr(MSR_ARCH_LBR_CTL, lbr_ctl);
+
+	/*
+	 * LBR records are kept at this point, need to save them
+	 * ASAP, otherwise they could be reset to 0s.
+	 */
+	for (i = 0; i < lbr_depth; ++i) {
+		if (!(lbr_from[i] = rdmsr(MSR_ARCH_LBR_FROM_0 + i)) ||
+		    !(lbr_to[i] = rdmsr(MSR_ARCH_LBR_TO_0 + i)) ||
+		    !(lbr_info[i] = rdmsr(MSR_ARCH_LBR_INFO_0 + i)))
+			break;
+	}
+
+	if (i != lbr_depth) {
+		printf("Invalid Arch LBR records.\n");
+		return report_summary();
+	}
+
+	test_with_xsaves();
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d5efab0..88b2203 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -185,6 +185,12 @@ extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 
+[pmu_arch_lbr]
+file = pmu_arch_lbr.flat
+extra_params = -cpu host,lbr-fmt=0x3f
+check = /sys/module/kvm/parameters/ignore_msrs=N
+check = /proc/sys/kernel/nmi_watchdog=0
+
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.25.1

