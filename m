Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204F06F67B8
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 10:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjEDIsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 04:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjEDIsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 04:48:02 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A16E7
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 01:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683190081; x=1714726081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bt0aVFMYEdT199JVfyo0ABUg08xNX11NopPb93MJjaA=;
  b=YSUFUhEuyd1vHe8s0Jny/YTAboyDrmrJye3eQsbX71pnxjvyJmtWM3Jc
   c+FqZSF6HjSFJdTbW13XyBQTF3f6/RyIv3lWVJT6FKUhwguefQiD9oAm9
   hJqHDiV3z4sGr48Fy8+9hjTcbUvKavcnkgwEdGEWD6F96j3btiJATYJ+h
   CtxEJ95uAoBlJTAJzEC85kKOG9QCHlKpwL+P0PXNnXPN/KN1+M/P4td6y
   DR+zKG3ued3/SrTNrusxwQ7mnY8T+w4PTVo6ePq+drzmPzTWxVZqUxR7U
   Q8AXVqNBpQock4mFUcUmdZurzpkIU6CQTOKJA8IkSST6hCJ41d9gcRO3E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="435178188"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="435178188"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:48:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="766480486"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766480486"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.1.46])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:47:59 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [kvm-unit-tests v4 3/4] x86: Add test cases for LAM_{U48,U57}
Date:   Thu,  4 May 2023 16:47:50 +0800
Message-Id: <20230504084751.968-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230504084751.968-1-binbin.wu@linux.intel.com>
References: <20230504084751.968-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit test covers:
1. CR3 LAM bits toggles.
2. Memory/MMIO access with user mode address containing LAM metadata.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 lib/x86/processor.h |  2 ++
 x86/lam.c           | 76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6803c9c..d45566a 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -64,7 +64,9 @@ static inline u64 set_la_non_canonical(u64 src, u64 mask)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
 #define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U57		BIT_ULL(X86_CR3_LAM_U57_BIT)
 #define X86_CR3_LAM_U48_BIT	(62)
+#define X86_CR3_LAM_U48		BIT_ULL(X86_CR3_LAM_U48_BIT)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
diff --git a/x86/lam.c b/x86/lam.c
index 4e631c5..2920747 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -18,6 +18,9 @@
 #include "vm.h"
 #include "asm/io.h"
 #include "ioram.h"
+#include "usermode.h"
+
+#define CR3_LAM_BITS_MASK (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)
 
 #define FLAGS_LAM_ACTIVE	BIT_ULL(0)
 #define FLAGS_LA57		BIT_ULL(1)
@@ -38,6 +41,16 @@ static inline bool lam_sup_active(void)
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
 static void cr4_set_lam_sup(void *data)
 {
 	unsigned long cr4;
@@ -83,6 +96,7 @@ static void do_mov(void *mem)
 static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 {
 	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
+	bool la_57 = !!(arg1 & FLAGS_LA57);
 	u64 lam_mask = arg2;
 	u64 *ptr = (u64 *)arg3;
 	bool is_mmio = !!arg4;
@@ -96,6 +110,17 @@ static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 	report(fault != lam_active,"Test tagged addr (%s)",
 	       is_mmio ? "MMIO" : "Memory");
 
+	/*
+	 * This test case is only triggered when LAM_U57 is active and 4-level
+	 * paging is used. For the case, bit[56:47] aren't all 0 triggers #GP.
+	 */
+	if (lam_active && (lam_mask == LAM57_MASK) && !la_57) {
+		ptr = (u64 *)set_la_non_canonical((u64)ptr, LAM48_MASK);
+		fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+		report(fault,  "Test non-LAM-canonical addr (%s)",
+		       is_mmio ? "MMIO" : "Memory");
+	}
+
 	return 0;
 }
 
@@ -220,6 +245,56 @@ static void test_lam_sup(bool has_lam, bool fep_available)
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
+
+	/*
+	 * The physical address of AREA_NORMAL is within 36 bits, so that using
+	 * identical mapping, the linear address will be considered as user mode
+	 * address from the view of LAM, and the metadata bits are not used as
+	 * address for both LAM48 and LAM57.
+	 */
+	paddr = virt_to_phys(alloc_pages_flags(0, AREA_NORMAL));
+	_Static_assert((AREA_NORMAL_PFN & GENMASK(63, 47)) == 0UL,
+			"Identical mapping range check");
+
+	/*
+	 * Physical memory & MMIO have already been identical mapped in
+	 * setup_mmu().
+	 */
+	test_lam_user_mode(has_lam, LAM48_MASK, paddr, IORAM_BASE_PHYS);
+	test_lam_user_mode(has_lam, LAM57_MASK, paddr, IORAM_BASE_PHYS);
+}
+
 int main(int ac, char **av)
 {
 	bool has_lam;
@@ -238,6 +313,7 @@ int main(int ac, char **av)
 			    "use kvm.force_emulation_prefix=1 to enable\n");
 
 	test_lam_sup(has_lam, fep_available);
+	test_lam_user(has_lam);
 
 	return report_summary();
 }
-- 
2.25.1

