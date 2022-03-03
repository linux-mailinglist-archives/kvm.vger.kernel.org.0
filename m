Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDEB4CB7C2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiCCH2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiCCH2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:46 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2251854BC4
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292475; x=1677828475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLIdi+0MXlVUApHZB/znGcCoPilvf3SXkpe6+A3cUbI=;
  b=Pd5goDtKJ+gcxma/F+q39fjW5W5K+xgxKr3mWzDfCmx6WUUx9RTNnkzh
   YbCOJsI4FxbciHHKmhl/maHaJzMCNacYxMnpO319IiwdZJKrk7nd4lvuE
   tHqHiXXiX55bpEAqH87Lgtd5q7BOcz9v0tDlcfS3ZVbmsGrC2PSLADtEF
   y1aY+jacC7hmZr4fTvUWxAYfC5b4+LZTYdj/9gN4MwKdo7srBGTYvdmVf
   CPHrKhUTR8xXI7AgC3W08M8AislKG1s/CKBR70li9jlVy5K4hkolZShmZ
   gA9jnpjP+B+BcyDtTpwgKeNWI5O6PeZCH8x9vc9DdeBI8yJNwi9xCA5on
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177026"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177026"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:53 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631775"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:50 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 13/17] x86 TDX: Add lvl5 page table support to virtual memory
Date:   Thu,  3 Mar 2022 15:19:03 +0800
Message-Id: <20220303071907.650203-14-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently in TDX test case init stage, it setup an initial lvl5
boot page table, but VM code support only lvl4 page table. This
mismatch make the test cases requiring virtual memory crash.

Add below changes to support lvl5 page table for virtual memory:

1. skip finding high memory
2. check X86_CR4_LA57 to decide to initialize lvl5 or lvl4 page table
3. always set X86_CR0_NE for TDX test case

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/processor.h |  1 +
 lib/x86/setup.c     |  5 +++++
 lib/x86/vm.c        | 14 ++++++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 865269fd3857..4deff9ebe044 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -35,6 +35,7 @@
 #define X86_CR0_MP	0x00000002
 #define X86_CR0_EM	0x00000004
 #define X86_CR0_TS	0x00000008
+#define X86_CR0_NE	0x00000020
 #define X86_CR0_WP	0x00010000
 #define X86_CR0_AM	0x00040000
 #define X86_CR0_NW	0x20000000
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 3a60762494d6..0c299d3dd9bc 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -64,6 +64,11 @@ static struct mbi_bootinfo *bootinfo;
 #ifdef __x86_64__
 void find_highmem(void)
 {
+#ifdef TARGET_EFI
+	/* The largest free memory region is already chosen in setup_efi() */
+	return;
+#endif /* TARGET_EFI */
+
 	/* Memory above 4 GB is only supported on 64-bit systems.  */
 	if (!(bootinfo->flags & 64))
 	    	return;
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 56be57be673a..4ead6ed358ae 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,6 +3,7 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "tdx.h"
 
 static pteval_t pte_opt_mask;
 
@@ -16,7 +17,12 @@ pteval_t *install_pte(pgd_t *cr3,
     pteval_t *pt = cr3;
     unsigned offset;
 
-    for (level = PAGE_LEVEL; level > pte_level; --level) {
+    if (read_cr4() & X86_CR4_LA57)
+        level = 5;
+    else
+        level = PAGE_LEVEL;
+
+    for (; level > pte_level; --level) {
 	offset = PGDIR_OFFSET((uintptr_t)virt, level);
 	if (!(pt[offset] & PT_PRESENT_MASK)) {
 	    pteval_t *new_pt = pt_page;
@@ -187,7 +193,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
 #ifndef __x86_64__
     write_cr4(X86_CR4_PSE);
 #endif
-    write_cr0(X86_CR0_PG |X86_CR0_PE | X86_CR0_WP);
+    /* According to TDX module spec 10.6.1 CR0.NE should be 1 */
+    if (is_tdx_guest())
+        write_cr0(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE);
+    else
+        write_cr0(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP);
 
     printf("paging enabled\n");
     printf("cr0 = %lx\n", read_cr0());
-- 
2.25.1

