Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72E36C000E
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCSIhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCSIhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:37:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328D123C6B
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215065; x=1710751065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tSJFwXefhT7C1mfo+0Zad2ESiY3x2waCLfng0ARiCQs=;
  b=RA0pm2Xa2oUL6B5p/+dpqKSkpI74guhaSbGsQf1J6vpGcepIq8nL3V0z
   hQME6um9rkUJrWObD+hX53ktjJ+msG/aeaVPaObpe85owGwGaMkZrUoRL
   UDWfuDN90/833K0/Byvh0ZXW1u5cFc1pFGoApUKPpTb9Cx+8vmUN8TbmQ
   mY/isV4HcNezrjGffnRTw8q7QkP+DkkaJ9yd3k5KbtzK93NI29A8QQfum
   eH/pCW90sFRNVuhhUN9U9wzIiIB6xlHS+hAXt8UnEP2cc4X21LFxYb+vv
   5jfVXU1k/RFQ1JlO5xPs24ce82ZP3TzrVOQ/VgHZZ1GM0J4NkggQ2wHYO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767131"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767131"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="769853316"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="769853316"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:43 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v2 2/4] x86: Add test case for LAM_SUP
Date:   Sun, 19 Mar 2023 16:37:30 +0800
Message-Id: <20230319083732.29458-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319083732.29458-1-binbin.wu@linux.intel.com>
References: <20230319083732.29458-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

This unit test covers:
1. CR4.LAM_SUP toggle has expected behavior according to LAM status.
2. Memory access (here is strcpy() for test example) with supervisor mode
   address containing LAM meta data, behave as expected per LAM status.
3. MMIO memory access with supervisor mode address containing LAM meta
   data, behave as expected per LAM status.
4. INVLPG memory operand doens't contain LAM meta data, if the address
   is non-canonical form then the INVLPG is the same as a NOP (no #GP).
5. INVPCID memory operand (descriptor pointer) could contain LAM meta data,
   however, the address in the descriptor should be canonical.

In x86/unittests.cfg, add 2 test cases/guest conf, with and without LAM.

LAM feature spec: https://cdrdv2.intel.com/v1/dl/getContent/671368, Chap 7
LINEAR ADDRESS MASKING (LAM)

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 lib/x86/processor.h |   3 +
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 296 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 4 files changed, 310 insertions(+)
 create mode 100644 x86/lam.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 8373bbe..4bb8cd7 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -107,6 +107,8 @@
 #define X86_CR4_CET		BIT(X86_CR4_CET_BIT)
 #define X86_CR4_PKS_BIT		(24)
 #define X86_CR4_PKS		BIT(X86_CR4_PKS_BIT)
+#define X86_CR4_LAM_SUP_BIT	(28)
+#define X86_CR4_LAM_SUP	BIT(X86_CR4_LAM_SUP_BIT)
 
 #define X86_EFLAGS_CF_BIT	(0)
 #define X86_EFLAGS_CF		BIT(X86_EFLAGS_CF_BIT)
@@ -250,6 +252,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dea..fa11eb3 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/lam.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/lam.c b/x86/lam.c
new file mode 100644
index 0000000..a5f4e51
--- /dev/null
+++ b/x86/lam.c
@@ -0,0 +1,296 @@
+/*
+ * Intel LAM_SUP unit test
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
+#define LAM57_BITS 6
+#define LAM48_BITS 15
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+struct invpcid_desc {
+    u64 pcid : 12;
+    u64 rsv  : 52;
+    u64 addr : 64;
+};
+
+static int get_sup_lam_bits(void)
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
+		metadata = (NONCANONICAL & ((1UL << LAM57_BITS) - 1)) << 57;
+		metadata |= (src & ~(LAM57_MASK));
+		break;
+	case LAM48_BITS: /* Set metadata in bits 62:48 */
+		metadata = (NONCANONICAL & ((1UL << LAM48_BITS) - 1)) << 48;
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
+static void cr4_set_lam_sup(void *data)
+{
+	unsigned long cr4;
+
+	cr4 = read_cr4();
+	write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
+}
+
+static void cr4_clear_lam_sup(void *data)
+{
+	unsigned long cr4;
+
+	cr4 = read_cr4();
+	write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
+}
+
+static void test_cr4_lam_set_clear(bool lam_enumerated)
+{
+	bool fault;
+
+	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
+	if (lam_enumerated)
+		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
+		       "Set CR4.LAM_SUP");
+	else
+		report(fault, "Set CR4.LAM_SUP causes #GP");
+
+	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
+	report(!fault, "Clear CR4.LAM_SUP");
+}
+
+static void do_strcpy(void *mem)
+{
+	strcpy((char *)mem, "LAM SUP Test string.");
+}
+
+static inline uint64_t test_tagged_ptr(uint64_t arg1, uint64_t arg2,
+	uint64_t arg3, uint64_t arg4)
+{
+	bool lam_enumerated = !!arg1;
+	int lam_bits = (int)arg2;
+	u64 *ptr = (u64 *)arg3;
+	bool la_57 = !!arg4;
+	bool fault;
+
+	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
+	report(!fault, "strcpy to untagged addr");
+
+	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
+	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
+	if (lam_enumerated)
+		report(!fault, "strcpy to tagged addr");
+	else
+		report(fault, "strcpy to tagged addr causes #GP");
+
+	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
+		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
+		fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
+		report(fault, "strcpy to non-LAM-canonical addr causes #GP");
+	}
+
+	return 0;
+}
+
+/* Refer to emulator.c */
+static void do_mov_mmio(void *mem)
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
+static inline uint64_t test_tagged_mmio_ptr(uint64_t arg1, uint64_t arg2,
+	uint64_t arg3, uint64_t arg4)
+{
+	bool lam_enumerated = !!arg1;
+	int lam_bits = (int)arg2;
+	u64 *ptr = (u64 *)arg3;
+	bool la_57 = !!arg4;
+	bool fault;
+
+	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
+	report(!fault, "Access MMIO with untagged addr");
+
+	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
+	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
+	if (lam_enumerated)
+		report(!fault,  "Access MMIO with tagged addr");
+	else
+		report(fault,  "Access MMIO with tagged addr causes #GP");
+
+	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
+		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
+		fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
+		report(fault,  "Access MMIO with non-LAM-canonical addr"
+		               " causes #GP");
+	}
+
+	return 0;
+}
+
+static void do_invlpg(void *mem)
+{
+	invlpg(mem);
+}
+
+static void do_invlpg_fep(void *mem)
+{
+	asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
+}
+
+/* invlpg with tagged address is same as NOP, no #GP */
+static void test_invlpg(void *va, bool fep)
+{
+	bool fault;
+	u64 *ptr;
+
+	ptr = (u64 *)set_metadata((u64)va, get_sup_lam_bits());
+	if (fep)
+		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
+	else
+		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
+
+	report(!fault, "%sINVLPG with tagged addr", fep?"fep: ":"");
+}
+
+static void do_invpcid(void *desc)
+{
+	unsigned long type = 0;
+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
+
+	asm volatile("invpcid %0, %1" :
+	                              : "m" (*desc_ptr), "r" (type)
+	                              : "memory");
+}
+
+static void test_invpcid(bool lam_enumerated, void *data)
+{
+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *) data;
+	int lam_bits = get_sup_lam_bits();
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_PCID) ||
+	    !this_cpu_has(X86_FEATURE_INVPCID)) {
+		report_skip("INVPCID not supported");
+		return;
+	}
+
+	memset(desc_ptr, 0, sizeof(struct invpcid_desc));
+	desc_ptr->addr = (u64)data + 16;
+
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(!fault, "INVPCID: untagged pointer + untagged addr");
+
+	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(fault, "INVPCID: untagged pointer + tagged addr causes #GP");
+
+	desc_ptr->addr = (u64)data + 16;
+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	if (lam_enumerated && (read_cr4() & X86_CR4_LAM_SUP))
+		report(!fault, "INVPCID: tagged pointer + untagged addr");
+	else
+		report(fault, "INVPCID: tagged pointer + untagged addr"
+		              " causes #GP");
+
+	desc_ptr = (struct invpcid_desc *)data;
+	desc_ptr->addr = (u64)data + 16;
+	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(fault, "INVPCID: tagged pointer + tagged addr causes #GP");
+}
+
+static void test_lam_sup(bool lam_enumerated, bool fep_available)
+{
+	void *vaddr, *vaddr_mmio;
+	phys_addr_t paddr;
+	bool fault;
+	bool la_57 = read_cr4() & X86_CR4_LA57;
+	int lam_bits = get_sup_lam_bits();
+
+	vaddr = alloc_vpage();
+	vaddr_mmio = alloc_vpage();
+	paddr = virt_to_phys(alloc_page());
+	install_page(current_page_table(), paddr, vaddr);
+	install_page(current_page_table(), IORAM_BASE_PHYS, vaddr_mmio);
+
+	test_cr4_lam_set_clear(lam_enumerated);
+
+	/* Set for the following LAM_SUP tests */
+	if (lam_enumerated) {
+		fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
+		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
+		       "Set CR4.LAM_SUP");
+	}
+
+	test_tagged_ptr(lam_enumerated, lam_bits, (u64)vaddr, la_57);
+	test_tagged_mmio_ptr(lam_enumerated, lam_bits, (u64)vaddr_mmio, la_57);
+	test_invlpg(vaddr, false);
+	test_invpcid(lam_enumerated, vaddr);
+
+	if (fep_available)
+		test_invlpg(vaddr, true);
+}
+
+int main(int ac, char **av)
+{
+	bool lam_enumerated;
+	bool fep_available = is_fep_available();
+
+	setup_vm();
+
+	lam_enumerated = this_cpu_has(X86_FEATURE_LAM);
+	if (!lam_enumerated)
+		report_info("This CPU doesn't support LAM feature\n");
+	else
+		report_info("This CPU supports LAM feature\n");
+
+	if (!fep_available)
+		report_skip("Skipping tests the forced emulation, "
+			    "use kvm.force_emulation_prefix=1 to enable\n");
+
+	test_lam_sup(lam_enumerated, fep_available);
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32..34b09eb 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -478,3 +478,13 @@ file = cet.flat
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
2.25.1

