Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E256DECFD
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDLHv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjDLHvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:51:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B78E6596
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 00:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285909; x=1712821909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UXHz3z2056/flVBE5ZxsMz0X0oVXSC9RttYzuy6z9g8=;
  b=joFsbCD+9KFYRNovCuL3CY2W79rE5fu+CKggiKGB3m7o0JGX/t4oymZU
   32JzbPPi/JFR/7u5GZM4KBer5SOy+pNqVi7QuIPBOqeylulKknS3MaNbn
   3/VTRxLgz2MlstdRuixG2LNUIqfIls9sgxnrhAqtop3+hZqEXy8oNHOhg
   nlVlAmQfWo/JyV5XgehFwq5ZV1aZLYrUnlj0uG58zRGNMquXedaMQNuXA
   Od3UHofA2zDt025WlH8iD7QwEdgMZlbo2uNP6zxmWQZ4GP8aXBMGXyZ+J
   15Qrlw4VHkocIY4hXcIm+2SIIq85xNdBHVClT9A2C7ZsLknDzo52lqMeR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345623263"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345623263"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812893667"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812893667"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:47 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
Subject: [kvm-unit-tests v3 2/4] x86: Add test case for LAM_SUP
Date:   Wed, 12 Apr 2023 15:51:32 +0800
Message-Id: <20230412075134.21240-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230412075134.21240-1-binbin.wu@linux.intel.com>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

This unit test covers:
1. CR4.LAM_SUP toggles.
2. Memory & MMIO access with supervisor mode address with LAM metadata.
3. INVLPG memory operand doesn't contain LAM meta data, if the address
   is non-canonical form then the INVLPG is the same as a NOP (no #GP).
4. INVPCID memory operand (descriptor pointer) could contain LAM meta data,
   however, the address in the descriptor should be canonical.

In x86/unittests.cfg, add 2 test cases/guest conf, with and without LAM.

LAM feature spec: https://cdrdv2.intel.com/v1/dl/getContent/671368, Chap 7
LINEAR ADDRESS MASKING (LAM)

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 lib/x86/processor.h |   2 +
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 244 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 4 files changed, 257 insertions(+)
 create mode 100644 x86/lam.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e00a32b..4bb8cd7 100644
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
index 0000000..63c3fde
--- /dev/null
+++ b/x86/lam.c
@@ -0,0 +1,244 @@
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
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+#define FLAGS_LAM_ACTIVE	BIT_ULL(0)
+#define FLAGS_LA57		BIT_ULL(1)
+
+struct invpcid_desc {
+    u64 pcid : 12;
+    u64 rsv  : 52;
+    u64 addr;
+};
+
+static inline bool is_la57(void)
+{
+	return !!(read_cr4() & X86_CR4_LA57);
+}
+
+static inline bool lam_sup_active(void)
+{
+	return !!(read_cr4() & X86_CR4_LAM_SUP);
+}
+
+/* According to LAM mode, set metadata in high bits */
+static inline u64 set_metadata(u64 src, u64 metadata_mask)
+{
+	return (src & ~metadata_mask) | (NONCANONICAL & metadata_mask);
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
+static void test_cr4_lam_set_clear(bool has_lam)
+{
+	bool fault;
+
+	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
+	report((fault != has_lam) && (lam_sup_active() == has_lam),
+	       "Set CR4.LAM_SUP");
+
+	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
+	report(!fault, "Clear CR4.LAM_SUP");
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
+static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
+{
+	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
+	u64 lam_mask = arg2;
+	u64 *ptr = (u64 *)arg3;
+	bool is_mmio = !!arg4;
+	bool fault;
+
+	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+	report(!fault, "Test untagged addr (%s)", is_mmio ? "MMIO" : "Memory");
+
+	ptr = (u64 *)set_metadata((u64)ptr, lam_mask);
+	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+	report(fault != lam_active,"Test tagged addr (%s)",
+	       is_mmio ? "MMIO" : "Memory");
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
+/* invlpg with tagged address is same as NOP, no #GP expected. */
+static void test_invlpg(u64 lam_mask, void *va, bool fep)
+{
+	bool fault;
+	u64 *ptr;
+
+	ptr = (u64 *)set_metadata((u64)va, lam_mask);
+	if (fep)
+		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
+	else
+		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
+
+	report(!fault, "%sINVLPG with tagged addr", fep ? "fep: " : "");
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
+/* LAM doesn't apply to the target address in the descriptor of invpcid */
+static void test_invpcid(u64 flags, u64 lam_mask, void *data)
+{
+	/*
+	 * Reuse the memory address for the descriptor since stack memory
+	 * address in KUT doesn't follow the kernel address space partitions.
+	 */
+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)data;
+	bool lam_active = !!(flags & FLAGS_LAM_ACTIVE);
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_PCID) ||
+	    !this_cpu_has(X86_FEATURE_INVPCID)) {
+		report_skip("INVPCID not supported");
+		return;
+	}
+
+	memset(desc_ptr, 0, sizeof(struct invpcid_desc));
+	desc_ptr->addr = (u64)data;
+
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(!fault, "INVPCID: untagged pointer + untagged addr");
+
+	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_mask);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(fault, "INVPCID: untagged pointer + tagged addr");
+
+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_mask);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(fault, "INVPCID: tagged pointer + tagged addr");
+
+	desc_ptr = (struct invpcid_desc *)data;
+	desc_ptr->addr = (u64)data;
+	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_mask);
+	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
+	report(fault != lam_active, "INVPCID: tagged pointer + untagged addr");
+}
+
+static void test_lam_sup(bool has_lam, bool fep_available)
+{
+	void *vaddr, *vaddr_mmio;
+	phys_addr_t paddr;
+	u64 lam_mask = LAM48_MASK;
+	u64 flags = 0;
+	bool fault;
+
+	vaddr = alloc_vpage();
+	vaddr_mmio = alloc_vpage();
+	paddr = virt_to_phys(alloc_page());
+	install_page(current_page_table(), paddr, vaddr);
+	install_page(current_page_table(), IORAM_BASE_PHYS, vaddr_mmio);
+
+	test_cr4_lam_set_clear(has_lam);
+
+	/* Set for the following LAM_SUP tests */
+	if (has_lam) {
+		fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
+		report(!fault && lam_sup_active(), "Set CR4.LAM_SUP");
+	}
+
+	if (lam_sup_active())
+		flags |= FLAGS_LAM_ACTIVE;
+
+	if (is_la57()) {
+		flags |= FLAGS_LA57;
+		lam_mask = LAM57_MASK;
+	}
+
+	/* Test for normal memory */
+	test_ptr(flags, lam_mask, (u64)vaddr, false);
+	/* Test for MMIO to trigger instruction emulation */
+	test_ptr(flags, lam_mask, (u64)vaddr_mmio, true);
+	test_invpcid(flags, lam_mask, vaddr);
+	test_invlpg(lam_mask, vaddr, false);
+	if (fep_available)
+		test_invlpg(lam_mask, vaddr, true);
+}
+
+int main(int ac, char **av)
+{
+	bool has_lam;
+	bool fep_available = is_fep_available();
+
+	setup_vm();
+
+	has_lam = this_cpu_has(X86_FEATURE_LAM);
+	if (!has_lam)
+		report_info("This CPU doesn't support LAM feature\n");
+	else
+		report_info("This CPU supports LAM feature\n");
+
+	if (!fep_available)
+		report_skip("Skipping tests the forced emulation, "
+			    "use kvm.force_emulation_prefix=1 to enable\n");
+
+	test_lam_sup(has_lam, fep_available);
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

