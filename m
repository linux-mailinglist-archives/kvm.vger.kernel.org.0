Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351D16DECFE
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDLHwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLHv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:51:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294576592
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 00:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285912; x=1712821912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IywIAfr5npYtgqb/3fxobMj9A+PuAxFXW2BLlrcpFUg=;
  b=K5PMELTsGDOfTjsSD4GsVx59he6t9I0BWupNqHvWi2XxapPq/9VhCWNL
   I0oCRMbt5Aa/f8cjzd8gBLpjNFObH1QRTc0IhwF7fCTgD1BkkgtMapKYZ
   8YsjC59fjMBd9n9uwOcpb/cDtDjPwHQ4wYkWMtatvZkMdEs1bogm+3PE+
   Z06ZL2gPWfehqhER7FKj3W9J5rbkUnGv9vHcxK+xwVu5Qrj7CK1qGjim7
   8F7siC4W/jSR8QemwfnxfRbkBuF/2KyMnbcSFz73wkx41C4GU9uCyFzNZ
   rE0fWWZToutczA4LG3uK0uf9miLwpBnM0bR0tJt071G+IQSknJBPaxNpU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345623270"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345623270"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812893682"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812893682"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:49 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
Subject: [kvm-unit-tests v3 3/4] x86: Add test cases for LAM_{U48,U57}
Date:   Wed, 12 Apr 2023 15:51:33 +0800
Message-Id: <20230412075134.21240-4-binbin.wu@linux.intel.com>
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

This unit test covers:
1. CR3 LAM bits toggles.
2. Memory/MMIO access with user mode address containing LAM metadata.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 lib/x86/processor.h |  2 ++
 x86/lam.c           | 71 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 4bb8cd7..a181e0b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -56,7 +56,9 @@
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
 #define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U57		BIT_ULL(X86_CR3_LAM_U57_BIT)
 #define X86_CR3_LAM_U48_BIT	(62)
+#define X86_CR3_LAM_U48		BIT_ULL(X86_CR3_LAM_U48_BIT)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
diff --git a/x86/lam.c b/x86/lam.c
index 63c3fde..50bcdf5 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -18,9 +18,11 @@
 #include "vm.h"
 #include "asm/io.h"
 #include "ioram.h"
+#include "usermode.h"
 
 #define LAM57_MASK	GENMASK_ULL(62, 57)
 #define LAM48_MASK	GENMASK_ULL(62, 48)
+#define CR3_LAM_BITS_MASK (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)
 
 #define FLAGS_LAM_ACTIVE	BIT_ULL(0)
 #define FLAGS_LA57		BIT_ULL(1)
@@ -41,6 +43,16 @@ static inline bool lam_sup_active(void)
 	return !!(read_cr4() & X86_CR4_LAM_SUP);
 }
 
+static inline bool lam_u48_active(void)
+{
+	return (read_cr3() & CR3_LAM_BITS_MASK) == X86_CR3_LAM_U48;
+}
+
+static inline bool lam_u57_active(void)
+{
+	return !!(read_cr3() & X86_CR3_LAM_U57);
+}
+
 /* According to LAM mode, set metadata in high bits */
 static inline u64 set_metadata(u64 src, u64 metadata_mask)
 {
@@ -92,6 +104,7 @@ static void do_mov(void *mem)
 static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 {
 	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
+	bool la_57 = !!(arg1 & FLAGS_LA57);
 	u64 lam_mask = arg2;
 	u64 *ptr = (u64 *)arg3;
 	bool is_mmio = !!arg4;
@@ -105,6 +118,17 @@ static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 	report(fault != lam_active,"Test tagged addr (%s)",
 	       is_mmio ? "MMIO" : "Memory");
 
+	/*
+	 * This test case is only triggered when LAM_U57 is active and 4-level
+	 * paging is used. For the case, bit[56:47] aren't all 0 triggers #GP.
+	 */
+	if (lam_active && (lam_mask == LAM57_MASK) && !la_57) {
+		ptr = (u64 *)set_metadata((u64)ptr, LAM48_MASK);
+		fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+		report(fault,  "Test non-LAM-canonical addr (%s)",
+		       is_mmio ? "MMIO" : "Memory");
+	}
+
 	return 0;
 }
 
@@ -221,6 +245,52 @@ static void test_lam_sup(bool has_lam, bool fep_available)
 		test_invlpg(lam_mask, vaddr, true);
 }
 
+static void test_lam_user_mode(bool has_lam, u64 lam_mask, u64 mem, u64 mmio)
+{
+	unsigned r;
+	bool raised_vector;
+	unsigned long cr3 = read_cr3() & ~CR3_LAM_BITS_MASK;
+	u64 flags = 0;
+
+	if (is_la57())
+		flags |= FLAGS_LA57;
+
+	if (has_lam) {
+		if (lam_mask == LAM48_MASK) {
+			r = write_cr3_safe(cr3 | X86_CR3_LAM_U48);
+			report((r == 0) && lam_u48_active(), "Set LAM_U48");
+		} else {
+			r = write_cr3_safe(cr3 | X86_CR3_LAM_U57);
+			report((r == 0) && lam_u57_active(), "Set LAM_U57");
+		}
+	}
+	if (lam_u48_active() || lam_u57_active())
+		flags |= FLAGS_LAM_ACTIVE;
+
+	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mem,
+		    false, &raised_vector);
+	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mmio,
+		    true, &raised_vector);
+}
+
+static void test_lam_user(bool has_lam)
+{
+	phys_addr_t paddr;
+	unsigned long cr3 = read_cr3();
+
+	/*
+	 * The physical address width is within 36 bits, so that using identical
+	 * mapping, the linear address will be considered as user mode address
+	 * from the view of LAM.
+	 */
+	paddr = virt_to_phys(alloc_page());
+	install_page((void *)cr3, paddr, (void *)paddr);
+	install_page((void *)cr3, IORAM_BASE_PHYS, (void *)IORAM_BASE_PHYS);
+
+	test_lam_user_mode(has_lam, LAM48_MASK, paddr, IORAM_BASE_PHYS);
+	test_lam_user_mode(has_lam, LAM57_MASK, paddr, IORAM_BASE_PHYS);
+}
+
 int main(int ac, char **av)
 {
 	bool has_lam;
@@ -239,6 +309,7 @@ int main(int ac, char **av)
 			    "use kvm.force_emulation_prefix=1 to enable\n");
 
 	test_lam_sup(has_lam, fep_available);
+	test_lam_user(has_lam);
 
 	return report_summary();
 }
-- 
2.25.1

