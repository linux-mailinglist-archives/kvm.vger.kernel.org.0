Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1F6C000F
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCSIhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCSIht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:37:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5E223C54
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215068; x=1710751068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HFxmk2rD1obiF2XNrKsMVvrSeRRxD3JtzbNcGpqCW/M=;
  b=B8ViR/piXkR41OYRQNQYUKC8VXsjWtO0I+MHbZhuxSz1Axg5aQlpW+Tc
   foyO0G+WfH7d3AZND6CvU47pPMy5EIdlVWvE5L6H9TpHeE9n7V5xpbQAy
   jjwMxI4M0QMNxtqDFdIeRoCd5DUyrRgHmETFRyedFtOcK0z8+YU5YlrMY
   MnArIuZW1V0tZoXgyTWIahVgTcoeHESALsSossTTkH93O881+Y28QcOQk
   vAMq3L9zDolDdtetl06eoRKJjkA9FPBleO7a8+bsCW7YD98p0fxiKK5CX
   vqV8bhofwcAVfQg8kFNFNpmNuJg969PbZXJCqEoN+miAaxB/VVEQxrPZR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767139"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767139"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="769853320"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="769853320"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:46 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v2 3/4] x86: Add test cases for LAM_{U48,U57}
Date:   Sun, 19 Mar 2023 16:37:31 +0800
Message-Id: <20230319083732.29458-4-binbin.wu@linux.intel.com>
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

This unit test covers:
1. CR3 LAM bits toggle has expected behavior according to LAM status.
2. Memory access using strcpy() with user mode address containing LAM
   meta data, behave as expected per LAM status.
3. MMIO memory access with user mode address containing LAM meta data,
   behave as expected per LAM status.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 lib/x86/processor.h |  2 ++
 x86/lam.c           | 46 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

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
index a5f4e51..8945440 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -1,5 +1,5 @@
 /*
- * Intel LAM_SUP unit test
+ * Intel LAM unit test
  *
  * Copyright (C) 2023 Intel
  *
@@ -18,11 +18,13 @@
 #include "vm.h"
 #include "asm/io.h"
 #include "ioram.h"
+#include "usermode.h"
 
 #define LAM57_BITS 6
 #define LAM48_BITS 15
 #define LAM57_MASK	GENMASK_ULL(62, 57)
 #define LAM48_MASK	GENMASK_ULL(62, 48)
+#define CR3_LAM_BITS_MASK (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)
 
 struct invpcid_desc {
     u64 pcid : 12;
@@ -273,6 +275,47 @@ static void test_lam_sup(bool lam_enumerated, bool fep_available)
 		test_invlpg(vaddr, true);
 }
 
+static void test_lam_user(bool lam_enumerated)
+{
+	unsigned long cr3;
+	bool is_la57;
+	unsigned r;
+	bool raised_vector = false;
+	phys_addr_t paddr;
+
+	paddr = virt_to_phys(alloc_page());
+	install_page((void *)(read_cr3()& ~CR3_LAM_BITS_MASK), paddr, (void *)paddr);
+	install_page((void *)(read_cr3()& ~CR3_LAM_BITS_MASK), IORAM_BASE_PHYS,
+		     (void *)IORAM_BASE_PHYS);
+
+	cr3 = read_cr3();
+	is_la57 = !!(read_cr4() & X86_CR4_LA57);
+
+	/* Test LAM_U48 */
+	if(lam_enumerated) {
+		r = write_cr3_safe((cr3 & ~X86_CR3_LAM_U57) | X86_CR3_LAM_U48);
+		report(r==0 && ((read_cr3() & CR3_LAM_BITS_MASK) == X86_CR3_LAM_U48),
+		       "Set LAM_U48");
+	}
+
+	run_in_user((usermode_func)test_tagged_ptr, GP_VECTOR, lam_enumerated,
+		    LAM48_BITS, paddr, is_la57, &raised_vector);
+	run_in_user((usermode_func)test_tagged_mmio_ptr, GP_VECTOR, lam_enumerated,
+		    LAM48_BITS, IORAM_BASE_PHYS, is_la57, &raised_vector);
+
+
+	/* Test LAM_U57 */
+	if(lam_enumerated) {
+		r = write_cr3_safe(cr3 | X86_CR3_LAM_U57);
+		report(r==0 && (read_cr3() & X86_CR3_LAM_U57), "Set LAM_U57");
+	}
+
+	run_in_user((usermode_func)test_tagged_ptr, GP_VECTOR, lam_enumerated,
+		    LAM57_BITS, paddr, is_la57, &raised_vector);
+	run_in_user((usermode_func)test_tagged_mmio_ptr, GP_VECTOR, lam_enumerated,
+		    LAM57_BITS, IORAM_BASE_PHYS, is_la57, &raised_vector);
+}
+
 int main(int ac, char **av)
 {
 	bool lam_enumerated;
@@ -291,6 +334,7 @@ int main(int ac, char **av)
 			    "use kvm.force_emulation_prefix=1 to enable\n");
 
 	test_lam_sup(lam_enumerated, fep_available);
+	test_lam_user(lam_enumerated);
 
 	return report_summary();
 }
-- 
2.25.1

