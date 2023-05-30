Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A978715401
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 04:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjE3Cpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 22:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjE3CpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 22:45:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C155F1B4
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 19:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685414681; x=1716950681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bt0aVFMYEdT199JVfyo0ABUg08xNX11NopPb93MJjaA=;
  b=OuKV8u1OFcPdWwJPISO0Rdp5GSM4Sn/HRTr/EoEukDNVs/wHTuedOUvf
   DkdklqdXEnr5f+m8nWJnrCFyVHX2dc8l9iBp9/MDR3Uz2TZWYBp/jqd5U
   ktHlrqApzJE69p9thiWQODuZfSaMNfSuqKgg0htskRTXaD1jbpgeQ9s3U
   o3045eZblJ7wVnWiLVPk0/vwab9i3lVKVEve0UdBOuFw3INw5Q38zm7fs
   Hv+3Hxcdk++ULEC6lrO5JQLFTJlj1w0zkrskJavf1pQj5UftKKni9XgTQ
   UvVMBANQPcc2WhyS2VMm/FdC1E10r95m6kHaIoKGtGVGhEukbXBmyk8aj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418287027"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418287027"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="656658839"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="656658839"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:08 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v5 3/4] x86: Add test cases for LAM_{U48,U57}
Date:   Tue, 30 May 2023 10:43:55 +0800
Message-Id: <20230530024356.24870-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530024356.24870-1-binbin.wu@linux.intel.com>
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
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

