Return-Path: <kvm+bounces-20762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CFD91D8EB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC9AB280ED9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB93E7E58D;
	Mon,  1 Jul 2024 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CN/ShCnc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690106EB5B
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818941; cv=none; b=VCTQcvNRJnZ6jKA623spk/UR//fup8+nn3eeg2Dabh55Dsq2dYV1cVWXs9Nq56YaMZdthd0wijILhiiV/inZ9Pgb5g8pmBEnR5YzKSs+T7op77fdq0s742GZElZfjlScJ2skMfd29A1WT7si8UqL+jU7Pu0qywBariBiO3YjaqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818941; c=relaxed/simple;
	bh=/GYMLo462TQO2m2jxgFKvSjjHSn0vItDPc/nCPHQFpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6a/eTIGNrEflxc6imYy2TlU975EiUWxD3DO+wi7XV1X3sTidcxjV3/H8Py3JLGGrhBUvml0UdqrIK01g+nTJhyYokWi34acNnzUvK0pByInqCO4kYaUUDeua0lDzmdOIRBwETWl0tor/6ee1HjiuHPJj1eBf21K7IM9x+wUK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CN/ShCnc; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818940; x=1751354940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/GYMLo462TQO2m2jxgFKvSjjHSn0vItDPc/nCPHQFpc=;
  b=CN/ShCncGWkpMk2rJY55gxB4G7/WWU0GMzDurS+7yq9QCOz+RloQfBa5
   7KW8vC9ojs22TwgVD3xRiHJYe4KRHhLit8K1CJr3vSjyOpc9jD5j/qf0w
   JwG04tbCDww2WGbjidpCXaBNSIg18fgINtL7426cWzAqhWYsuPJ74rPd1
   /G5cATH7b6qgPW8SYV9udP6zsFQNZdPFWg2Q4cTZwJfTxKCryUAbIFGY5
   eT/69Pzlf6DmOgiReNbq/SjMCmMkYXs4n9XIceCe7tMTHFsWigIz5mFdL
   R2DCwTXgkSmhWTcWX37DV+tIa5Yu3S1nk65L2hEAXetASTuf3QEpwEoMz
   A==;
X-CSE-ConnectionGUID: AZeHStTRSnChtwEJSGuhkQ==
X-CSE-MsgGUID: o7Per+jtS360ZQ2EMu8vHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466071"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466071"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:59 -0700
X-CSE-ConnectionGUID: wEfRGhJlQPyzq9zgkW2Dfg==
X-CSE-MsgGUID: ihpXgy1bSbWhJU1xL1auHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520765"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:55 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 3/5] x86: Add test case for LAM_SUP
Date: Mon,  1 Jul 2024 15:30:08 +0800
Message-ID: <20240701073010.91417-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Hoo <robert.hu@linux.intel.com>

This unit test covers:
1. CR4.LAM_SUP toggles.
2. Memory & MMIO access with supervisor mode address with LAM metadata.
3. INVLPG memory operand doesn't contain LAM meta data, if the address
   is non-canonical form then the INVLPG is the same as a NOP (no #GP).
4. INVPCID memory operand (descriptor pointer) could contain LAM meta data,
   however, the address in the descriptor should be canonical.

In x86/unittests.cfg, add 2 test cases/guest conf, with and without LAM.

LAM feature spec: https://cdrdv2.intel.com/v1/dl/getContent/671368,
Chapter LINEAR ADDRESS MASKING (LAM)

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
v7：
- Rename is_la57()/lam_sup_active() to is_la57_enabled()/is_lam_sup_enabled(),
  and move them to processor.h (Sean)
- Drop cr4_set_lam_sup()/cr4_clear_lam_sup() and use write_cr4_safe() instead. (Sean)
- Add get_lam_mask() to get lam status based on the address and vCPU state. (Sean)
- Drop the wrappers for INVLPG since INVLPG never faults. (Sean)
- Drop the wrapper for INVPCID and use invpcid_safe() instead. (Sean)
- Drop the check for X86_FEATURE_PCID. (Sean)
---
 lib/x86/processor.h |  20 +++++
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 214 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +++
 4 files changed, 245 insertions(+)
 create mode 100644 x86/lam.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f7f2df50..a38f87ed 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -8,6 +8,14 @@
 #include <stdint.h>
 
 #define NONCANONICAL	0xaaaaaaaaaaaaaaaaull
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+/* Set metadata with non-canonical pattern in mask bits of a linear address */
+static inline u64 set_la_non_canonical(u64 src, u64 mask)
+{
+	return (src & ~mask) | (NONCANONICAL & mask);
+}
 
 #ifdef __x86_64__
 #  define R "r"
@@ -120,6 +128,8 @@
 #define X86_CR4_CET		BIT(X86_CR4_CET_BIT)
 #define X86_CR4_PKS_BIT		(24)
 #define X86_CR4_PKS		BIT(X86_CR4_PKS_BIT)
+#define X86_CR4_LAM_SUP_BIT	(28)
+#define X86_CR4_LAM_SUP		BIT(X86_CR4_LAM_SUP_BIT)
 
 #define X86_EFLAGS_CF_BIT	(0)
 #define X86_EFLAGS_CF		BIT(X86_EFLAGS_CF_BIT)
@@ -968,4 +978,14 @@ struct invpcid_desc {
 	u64 addr : 64;
 } __attribute__((packed));
 
+static inline bool is_la57_enabled(void)
+{
+	return !!(read_cr4() & X86_CR4_LA57);
+}
+
+static inline bool is_lam_sup_enabled(void)
+{
+	return !!(read_cr4() & X86_CR4_LAM_SUP);
+}
+
 #endif
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 2771a6fa..e5db2365 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -38,6 +38,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/lam.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/lam.c b/x86/lam.c
new file mode 100644
index 00000000..2f95b6c9
--- /dev/null
+++ b/x86/lam.c
@@ -0,0 +1,214 @@
+/*
+ * Intel LAM unit test
+ *
+ * Copyright (C) 2023 Intel
+ *
+ * Author: Robert Hoo <robert.hu@linux.intel.com>
+ *         Binbin Wu <binbin.wu@linux.intel.com>
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
+static void test_cr4_lam_set_clear(void)
+{
+	int vector;
+	bool has_lam = this_cpu_has(X86_FEATURE_LAM);
+
+	vector = write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
+	report(has_lam ? !vector : vector == GP_VECTOR,
+	       "Expected CR4.LAM_SUP=1 to %s", has_lam ? "succeed" : "#GP");
+
+	vector = write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
+	report(!vector, "Expected CR4.LAM_SUP=0 to succeed");
+}
+
+/* Refer to emulator.c */
+static void do_mov(void *mem)
+{
+	unsigned long t1, t2;
+
+	t1 = 0x123456789abcdefull & -1ul;
+	asm volatile("mov %[t1], (%[mem])\n\t"
+		     "mov (%[mem]), %[t2]"
+		     : [t2]"=r"(t2)
+		     : [t1]"r"(t1), [mem]"r"(mem)
+		     : "memory");
+	report(t1 == t2, "Mov result check");
+}
+
+static bool get_lam_mask(u64 address, u64* lam_mask)
+{
+	/*
+	 * Use LAM57_MASK as mask to construct non-canonical address if LAM is
+	 * not supported or enabled.
+	 */
+	*lam_mask = LAM57_MASK;
+
+	/*
+	 * Bit 63 determines if the address should be treated as a user address
+	 * or a supervisor address.
+	 */
+	if (address & BIT_ULL(63)) {
+		if (!(is_lam_sup_enabled()))
+			return false;
+
+		if (!is_la57_enabled())
+			*lam_mask = LAM48_MASK;
+		return true;
+	}
+
+	/* TODO: Get LAM mask for userspace address. */
+	return false;
+}
+
+
+static void test_ptr(u64* ptr, bool is_mmio)
+{
+	u64 lam_mask;
+	bool lam_active, fault;
+
+	lam_active = get_lam_mask((u64)ptr, &lam_mask);
+
+	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+	report(!fault, "Expected access to untagged address for %s to succeed",
+	       is_mmio ? "MMIO" : "memory");
+
+	ptr = (u64 *)set_la_non_canonical((u64)ptr, lam_mask);
+	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+	report(fault != lam_active, "Expected access to tagged address for %s %s LAM to %s",
+	       is_mmio ? "MMIO" : "memory", lam_active ? "with" : "without",
+	       lam_active ? "succeed" : "#GP");
+}
+
+/* invlpg with tagged address is same as NOP, no #GP expected. */
+static void test_invlpg(void *va, bool fep)
+{
+	u64 lam_mask;
+	u64 *ptr;
+
+	/*
+	 * The return value is not checked, invlpg should never faults no matter
+	 * LAM is supported or not.
+	 */
+	get_lam_mask((u64)va, &lam_mask);
+	ptr = (u64 *)set_la_non_canonical((u64)va, lam_mask);
+	if (fep)
+		asm volatile(KVM_FEP "invlpg (%0)" ::"r" (ptr) : "memory");
+	else
+		invlpg(ptr);
+
+	report(true, "Expected %sINVLPG with tagged addr to succeed", fep ? "fep: " : "");
+}
+
+/* LAM doesn't apply to the linear address in the descriptor of invpcid */
+static void test_invpcid(void *data)
+{
+	/*
+	 * Reuse the memory address for the descriptor since stack memory
+	 * address in KUT doesn't follow the kernel address space partitions.
+	 */
+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)data;
+	int vector;
+	u64 lam_mask;
+	bool lam_active;
+
+	if (!this_cpu_has(X86_FEATURE_INVPCID)) {
+		report_skip("INVPCID not supported");
+		return;
+	}
+
+	lam_active = get_lam_mask((u64)data, &lam_mask);
+
+	memset(desc_ptr, 0, sizeof(struct invpcid_desc));
+	desc_ptr->addr = (u64)data;
+
+	vector = invpcid_safe(0, desc_ptr);
+	report(!vector,
+	       "Expected INVPCID with untagged pointer + untagged addr to succeed");
+
+	desc_ptr->addr = set_la_non_canonical(desc_ptr->addr, lam_mask);
+	vector = invpcid_safe(0, desc_ptr);
+	report(vector==GP_VECTOR,
+	       "Expected INVPCID with untagged pointer + tagged addr to #GP");
+
+	desc_ptr = (struct invpcid_desc *)set_la_non_canonical((u64)desc_ptr,
+							       lam_mask);
+	vector = invpcid_safe(0, desc_ptr);
+	report(vector==GP_VECTOR,
+	       "Expected INVPCID with tagged pointer + tagged addr to #GP");
+
+	desc_ptr = (struct invpcid_desc *)data;
+	desc_ptr->addr = (u64)data;
+	desc_ptr = (struct invpcid_desc *)set_la_non_canonical((u64)desc_ptr,
+							       lam_mask);
+	vector = invpcid_safe(0, desc_ptr);
+	report(lam_active ? !vector : vector==GP_VECTOR,
+	       "Expected INVPCID with tagged pointer + untagged addr to %s",
+	       lam_active? "succeed" : "#GP");
+}
+
+static void test_lam_sup(void)
+{
+	void *vaddr, *vaddr_mmio;
+	phys_addr_t paddr;
+	unsigned long cr4 = read_cr4();
+	int vector;
+
+	/*
+	 * KUT initializes vfree_top to 0 for X86_64, and each virtual address
+	 * allocation decreases the size from vfree_top. It's guaranteed that
+	 * the return value of alloc_vpage() is considered as kernel mode
+	 * address and canonical since only a small mount virtual address range
+	 * is allocated in this test.
+	 */
+	vaddr = alloc_vpage();
+	vaddr_mmio = alloc_vpage();
+	paddr = virt_to_phys(alloc_page());
+	install_page(current_page_table(), paddr, vaddr);
+	install_page(current_page_table(), IORAM_BASE_PHYS, vaddr_mmio);
+
+	test_cr4_lam_set_clear();
+
+	/* Set for the following LAM_SUP tests. */
+	if (this_cpu_has(X86_FEATURE_LAM)) {
+		vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
+		report(!vector && is_lam_sup_enabled(),
+		       "Expected CR4.LAM_SUP=1 to succeed");
+	}
+
+	/* Test for normal memory. */
+	test_ptr(vaddr, false);
+	/* Test for MMIO to trigger instruction emulation. */
+	test_ptr(vaddr_mmio, true);
+	test_invpcid(vaddr);
+	test_invlpg(vaddr, false);
+	if (is_fep_available())
+		test_invlpg(vaddr, true);
+	else
+		report_skip("Skipping tests the forced emulation, "
+			    "use kvm.force_emulation_prefix=1 to enable\n");
+}
+
+int main(int ac, char **av)
+{
+	setup_vm();
+
+	if (!this_cpu_has(X86_FEATURE_LAM))
+		report_info("This CPU doesn't support LAM feature\n");
+	else
+		report_info("This CPU supports LAM feature\n");
+
+	test_lam_sup();
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 7c1691a9..f1178edd 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -490,3 +490,13 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[intel-lam]
+file = lam.flat
+arch = x86_64
+extra_params = -enable-kvm -cpu host
+
+[intel-no-lam]
+file = lam.flat
+arch = x86_64
+extra_params = -enable-kvm -cpu host,-lam
-- 
2.43.2


