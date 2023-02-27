Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A016A3D58
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjB0Ig1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjB0Ifv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:35:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0522B212BF
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486678; x=1709022678;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D4m94Ys9nnxpXljCqvikZjpfa2GzPnyw3v/1gupN41c=;
  b=kXhSIYdxT6dNR8XHYnlwSexkOvkAM142J23nY0CJnCYCEs5DGpyJpTSh
   f4/13lrt5NU+8xR1UHG9cShpGOLOiI1Fi9sl6gAMXzPP0Qib8hHEPy6+V
   LfKyx6K2gBAG0bJDGmLxD/YKMKKbJv6ZQa/OsIr63iZgY1jYM5iVI3KMS
   sfBE56ZtI6kYA8gYsIdTTEa3/al5xy/QNIFmIxDyoomDgo34DKaWTLMoW
   SHn+0qrz4zJ/rrl630e/eFDjjewnaaYmUEqzP9k3Xw15TIm6RUFISfdT3
   4R47F05i3HZONcyuJcNvV83LdB5aQ4/kwnkHkAhwnYl/MszjXQtLDz89q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="313480571"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="313480571"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:26:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="797519826"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="797519826"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 27 Feb 2023 00:26:04 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [kvm-unit-tests PATCH v1] x86: Add test case for LAM_SUP
Date:   Mon, 27 Feb 2023 16:25:57 +0800
Message-Id: <20230227082557.403584-1-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit test covers:
1. CR4.LAM_SUP toggle has expected behavior according to LAM status.
2. Memory access (here is strcpy() for test example) with supervisor mode
address containing LAM meta data, behave as expected per LAM status.
3. MMIO memory access with supervisor mode address containing LAM meta
data, behave as expected per LAM status.

In x86/unittests.cfg, add 2 test cases/guest conf, with and without LAM.

Note:
LAM_U57 is covered by running kselftests/x86/lam in guest; and
exepecting LAM_U48 test will be complemented there when Kernel supports it.

LAM feature spec: https://cdrdv2.intel.com/v1/dl/getContent/671368, Chap 10
LINEAR ADDRESS MASKING (LAM)

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 lib/x86/processor.h |   3 +
 x86/Makefile.x86_64 |   1 +
 x86/lam_sup.c       | 170 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +++
 4 files changed, 184 insertions(+)
 create mode 100644 x86/lam_sup.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3d58ef7..c6b1db6 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -105,6 +105,8 @@
 #define X86_CR4_CET		BIT(X86_CR4_CET_BIT)
 #define X86_CR4_PKS_BIT		(24)
 #define X86_CR4_PKS		BIT(X86_CR4_PKS_BIT)
+#define X86_CR4_LAM_SUP_BIT	(28)
+#define X86_CR4_LAM_SUP	BIT(X86_CR4_LAM_SUP_BIT)
 
 #define X86_EFLAGS_CF_BIT	(0)
 #define X86_EFLAGS_CF		BIT(X86_EFLAGS_CF_BIT)
@@ -248,6 +250,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dea..af626cc 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/lam_sup.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/lam_sup.c b/x86/lam_sup.c
new file mode 100644
index 0000000..67d5b5e
--- /dev/null
+++ b/x86/lam_sup.c
@@ -0,0 +1,170 @@
+/*
+ * Intel LAM_SUP unit test
+ *
+ * Copyright (C) 2023 Intel
+ *
+ * Author: Robert Hoo <robert.hu@linux.intel.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2 or
+ * later.
+ */
+
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+#include "vmalloc.h"
+#include "alloc_page.h"
+#include "vm.h"
+#include "asm/io.h"
+#include "ioram.h"
+
+#define LAM57_BITS 6
+#define LAM48_BITS 15
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+static int gp_count;
+static jmp_buf jbuf;
+
+static int get_lam_bits(void)
+{
+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
+		return LAM57_BITS;
+	else
+		return LAM48_BITS;
+}
+
+/* According to LAM mode, set metadata in high bits */
+static u64 set_metadata(u64 src, unsigned long lam)
+{
+	u64 metadata;
+
+	switch (lam) {
+	case LAM57_BITS: /* Set metadata in bits 62:57 */
+		metadata = (rdtsc() & ((1UL << LAM57_BITS) - 1)) << 57;
+		metadata |= (src & ~(LAM57_MASK));
+		break;
+	case LAM48_BITS: /* Set metadata in bits 62:48 */
+		metadata = (rdtsc() & ((1UL << LAM48_BITS) - 1)) << 48;
+		metadata |= (src & ~(LAM48_MASK));
+		break;
+	default:
+		metadata = src;
+		break;
+	}
+
+	return metadata;
+}
+
+static void handle_gp(struct ex_regs *regs)
+{
+	report_info("#GP caught, error_code = %ld\n", regs->error_code);
+	gp_count++;
+	longjmp(jbuf, 1);
+}
+
+/* Refer to emulator.c */
+static void test_mov(void *mem)
+{
+	unsigned long t1, t2;
+
+	// test mov reg, r/m and mov r/m, reg
+	t1 = 0x123456789abcdefull & -1ul;
+	asm volatile("mov %[t1], (%[mem])\n\t"
+		     "mov (%[mem]), %[t2]"
+		     : [t2]"=r"(t2)
+		     : [t1]"r"(t1), [mem]"r"(mem)
+		     : "memory");
+}
+
+
+int main(int ac, char **av)
+{
+	unsigned long cr4;
+	volatile bool lam_enumerated;
+	int vector, expect_vector;
+	u64 *ptr;
+	int lam_bits;
+	void *vaddr, *mem;
+	phys_addr_t paddr;
+	handler old;
+
+	lam_enumerated = this_cpu_has(X86_FEATURE_LAM);
+	if (!lam_enumerated)
+		report_info("This CPU doesn't support LAM feature\n");
+	else
+		report_info("This CPU supports LAM feature\n");
+
+	expect_vector = lam_enumerated ? 0 : GP_VECTOR;
+
+	/* Set CR4.LAM_SUP */
+	cr4 = read_cr4();
+	vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
+
+	if (lam_enumerated)
+		report(vector == expect_vector && (cr4 | X86_CR4_LAM_SUP) == read_cr4(),
+		       "Set CR4.LAM_SUP");
+	else
+		report(vector == expect_vector, "Set CR4.LAM_SUP");
+
+	/* Clear CR4.LAM_SUP */
+	cr4 = read_cr4();
+	vector = write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
+	expect_vector = 0;
+	report(vector == expect_vector && (cr4 & ~X86_CR4_LAM_SUP) == read_cr4(),
+	       "Clear CR4.LAM_SUP");
+
+	/* Re-set CR4.LAM_SUP for next tests */
+	cr4 = read_cr4();
+	vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
+	expect_vector = lam_enumerated ? 0 : GP_VECTOR;
+	if (lam_enumerated)
+		report(vector == expect_vector && (cr4 | X86_CR4_LAM_SUP) == read_cr4(),
+			"Re-enable CR4.LAM_SUP");
+	else
+		report(vector == expect_vector, "Re-enable CR4.LAM_SUP");
+
+	/* Try access Supervisor mode address with meta data */
+	setup_vm();
+	vaddr = alloc_vpage();
+	paddr = virt_to_phys(alloc_page());
+
+	install_page(current_page_table(), paddr, vaddr);
+	old = handle_exception(GP_VECTOR, handle_gp);
+
+	strcpy((char *)vaddr, "LAM SUP Test origin string.");
+
+	lam_bits = get_lam_bits();
+	ptr = (u64 *)set_metadata((u64)vaddr, lam_bits);
+
+	if (setjmp(jbuf) == 0)
+		strcpy((char *)ptr, "LAM SUP Test NEW string.");
+
+	if (lam_enumerated && (read_cr4() & X86_CR4_LAM_SUP))
+		report(gp_count == 0, "strcpy with tagged addr succeed");
+	else
+		report(gp_count > 0, "strcpy with tagged addr cause #GP");
+
+	/* emulator coverage. referred to emulator.c */
+	gp_count = 0;
+	mem = alloc_vpage();
+	install_page((void *)read_cr3(), IORAM_BASE_PHYS, mem);
+
+	ptr = (u64 *)set_metadata((u64)mem, lam_bits);
+	if (setjmp(jbuf) == 0)
+		test_mov(ptr);
+
+	if (lam_enumerated && (read_cr4() & X86_CR4_LAM_SUP))
+		report(gp_count == 0, "MMIO cpy test for emulator succeed");
+	else
+		report(gp_count > 0, "MMIO cpy test for emulator cause #GP");
+
+	/*
+	 * Restore old #GP handler, though mostly likely effectively
+	 * unnecessary, for symmetry and conservativeness.
+	 */
+	handle_exception(GP_VECTOR, old);
+
+	return report_summary();
+}
+
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32..08a9b20 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -478,3 +478,13 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[intel-lam]
+file = lam_sup.flat
+arch = x86_64
+extra_params = -enable-kvm -cpu host
+
+[intel-no-lam]
+file = lam_sup.flat
+arch = x86_64
+extra_params = -enable-kvm -cpu host,-lam

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.31.1

