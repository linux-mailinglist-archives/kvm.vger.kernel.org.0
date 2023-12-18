Return-Path: <kvm+bounces-4680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0A7816718
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A4AF284709
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6BE10A29;
	Mon, 18 Dec 2023 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsHODWt8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1924A10A21
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883455; x=1734419455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9VF+V70aimvgVtEWlYwstm6s6sWPKZjnPv2gD3/FVQ0=;
  b=DsHODWt8MshlV+4UnwtcSoLK2X9jeRTzk1tb2zjryLTQlvOxZ7Fjsblo
   DiemJ9OgHPCJxbhgzRobunz9UfYQGeXOtuRfqTNJzYSWGOX5V+/8udiIz
   5OvJQHYYNy7EtOM3CGJY5ynGnpefJ9eUvKaaeYeFXOLvgIDxM3GjoOVcC
   TtooXSsquKQiLEQuTiskTvByiRNU8JpgIHHyJeEazfi7sVHnyV0g7FGU4
   /q6wmHSnfCSSBXHFt/8+tNmlCnsf5WrXFCbIwvhEqukkjllHM07PD8eCI
   BfSEWNB7Y8Zucj+Vu8Wg9otHU3Qx1Yb/hzWrnn0e+6qL2BwA8q8SBpJ8w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667970"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667970"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824780"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824780"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:51 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 14/18] x86 TDX: Add lvl5 page table support to virtual memory
Date: Mon, 18 Dec 2023 15:22:43 +0800
Message-Id: <20231218072247.2573516-15-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Currently in TDX test case init stage, it setup an initial lvl5 boot
page table, but VM code support only lvl4 page table. This mismatch make
the test cases requiring virtual memory crash.

Add below changes to support lvl5 page table for virtual memory:

1. skip finding high memory
2. check X86_CR4_LA57 to decide to initialize lvl5 or lvl4 page table
3. always set X86_CR0_NE for TDX test case

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-14-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/setup.c |  5 +++++
 lib/x86/vm.c    | 15 +++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index de2dee38..311bffad 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -68,6 +68,11 @@ static struct mbi_bootinfo *bootinfo;
 #ifdef __x86_64__
 void find_highmem(void)
 {
+#ifdef CONFIG_EFI
+	/* The largest free memory region is already chosen in setup_efi() */
+	return;
+#endif /* CONFIG_EFI */
+
 	/* Memory above 4 GB is only supported on 64-bit systems.  */
 	if (!(bootinfo->flags & 64))
 	    	return;
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb..a7ad80d1 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,8 +3,10 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "tdx.h"
 
 static pteval_t pte_opt_mask;
+static int page_level;
 
 pteval_t *install_pte(pgd_t *cr3,
 		      int pte_level,
@@ -16,7 +18,7 @@ pteval_t *install_pte(pgd_t *cr3,
     pteval_t *pt = cr3;
     unsigned offset;
 
-    for (level = PAGE_LEVEL; level > pte_level; --level) {
+    for (level = page_level; level > pte_level; --level) {
 	offset = PGDIR_OFFSET((uintptr_t)virt, level);
 	if (!(pt[offset] & PT_PRESENT_MASK)) {
 	    pteval_t *new_pt = pt_page;
@@ -49,9 +51,9 @@ struct pte_search find_pte_level(pgd_t *cr3, void *virt,
 	unsigned shift;
 	struct pte_search r;
 
-	assert(lowest_level >= 1 && lowest_level <= PAGE_LEVEL);
+	assert(lowest_level >= 1 && lowest_level <= page_level);
 
-	for (r.level = PAGE_LEVEL;; --r.level) {
+	for (r.level = page_level;; --r.level) {
 		shift = (r.level - 1) * PGDIR_WIDTH + 12;
 		offset = ((uintptr_t)virt >> shift) & PGDIR_MASK;
 		r.pte = &pt[offset];
@@ -185,6 +187,7 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
 	pte_opt_mask = PT_USER_MASK;
 
     memset(cr3, 0, PAGE_SIZE);
+    page_level = !!(read_cr4() & X86_CR4_LA57) ? 5 : PAGE_LEVEL;
 
 #ifdef __x86_64__
     if (end_of_memory < (1ul << 32))
@@ -201,7 +204,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
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


