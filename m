Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064B56B649F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCLKAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjCLJ77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434A752920
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615140; x=1710151140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d9O9JVN6vqAaWC8frkCh+HFMRjI0bUspau2UR0En1JM=;
  b=Ih65UlTg9iwUEuE3f7XFOCAYUX//ddoJexouuiqkJOm4GncEyzor1RQF
   /MyUHeqT/kbKVBUgzgIbME0CIFNCj39cHxguM+lctO8cpLrzSD2KN/QIX
   Qm8fdw30OsclBEiJDaQXM+QjYICP/E3CKUHrG0JdDi/Vo/2moRQ+YTiNs
   aY40s7B4GnwzyNH8bR6cqS6T4CN6siAsm92R96M4ilGntp6tjnp3CS4eP
   zGtaSUHKBnYbz3zGhC0MEXpm42LyxUlYMcf4l7KDTZqr8J5LRA4n8Xnho
   BChK394UNg6LcVcUpYHOnmtDIn+kff+JgUUMQq9TgXiaRafAPBhgUF+gl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344714"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344714"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627361"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627361"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:01 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 10/13] pkvm: x86: add pkvm_pgtable_unmap_safe for a safe unmap
Date:   Mon, 13 Mar 2023 02:03:42 +0800
Message-Id: <20230312180345.1778588-11-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

The current pkvm_pgtable_unmap API takes a phys parameter which will
check if the unmap entry really maps this phys memory. This is not
necessary for all the unmap cases, and actually phys is unknown to some
cases.

However, for some cases, still prefer to perform such check to avoid
unmapping an incorrect entry because such failure is not easy to be
detected but cause a serial security issue. The unmap from page state
API and from the host EPT are the cases better to have such check. So
introduce a safe version unmap API.

The safe version unmap API will be used by page state machine and host
EPT to do unmap. For the MMU page table, it can still use the normal
version of the unmap.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c     |  4 +-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c     |  4 +-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h     |  3 +-
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c | 67 ++++++++++++++++++++---------
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h |  4 +-
 5 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 65f3a39210db..a0793e4d02ef 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -147,9 +147,9 @@ int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
 }
 
 int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
-		unsigned long size)
+			unsigned long size)
 {
-	return pkvm_pgtable_unmap(&host_ept, vaddr_start, phys_start, size);
+	return pkvm_pgtable_unmap_safe(&host_ept, vaddr_start, phys_start, size);
 }
 
 static void reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index b32ca706fa4b..f2fe8aa45b46 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -192,11 +192,11 @@ int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
 	return ret;
 }
 
-int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long phys_start, unsigned long size)
+int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long size)
 {
 	int ret;
 
-	ret = pkvm_pgtable_unmap(&hyp_mmu, vaddr_start, phys_start, size);
+	ret = pkvm_pgtable_unmap(&hyp_mmu, vaddr_start, size);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
index 218e3d4ef92c..776e6ceebd4c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
@@ -8,8 +8,7 @@
 int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot);
 
-int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long phys_start,
-		unsigned long size);
+int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long size);
 
 int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
 		void *mmu_pool_base, unsigned long mmu_pool_pages);
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
index d55acc84f4e1..54107d4685ed 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -8,6 +8,7 @@
 #include "pgtable.h"
 #include "memory.h"
 #include "debug.h"
+#include "bug.h"
 
 struct pgt_walk_data {
 	struct pkvm_pgtable *pgt;
@@ -34,12 +35,11 @@ struct pkvm_pgtable_lookup_data {
 	int level;
 };
 
-static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
-				unsigned long vaddr,
-				unsigned long vaddr_end,
-				unsigned long phys,
-				int pgsz_mask,
-				int level)
+static bool leaf_mapping_valid(struct pkvm_pgtable_ops *pgt_ops,
+			       unsigned long vaddr,
+			       unsigned long vaddr_end,
+			       int pgsz_mask,
+			       int level)
 {
 	unsigned long page_size = pgt_ops->pgt_level_to_size(level);
 
@@ -49,15 +49,27 @@ static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
 	if (!IS_ALIGNED(vaddr, page_size))
 		return false;
 
-	if (!IS_ALIGNED(phys, page_size))
-		return false;
-
 	if (page_size > (vaddr_end - vaddr))
 		return false;
 
 	return true;
 }
 
+static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
+				 unsigned long vaddr,
+				 unsigned long vaddr_end,
+				 unsigned long phys,
+				 int pgsz_mask,
+				 int level)
+{
+	unsigned long page_size = pgt_ops->pgt_level_to_size(level);
+
+	if (!IS_ALIGNED(phys, page_size))
+		return false;
+
+	return leaf_mapping_valid(pgt_ops, vaddr, vaddr_end, pgsz_mask, level);
+}
+
 static void pgtable_split(struct pkvm_pgtable_ops *pgt_ops,
 			  struct pkvm_mm_ops *mm_ops,
 			  unsigned long vaddr, unsigned long phys,
@@ -224,22 +236,22 @@ static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	 * Can direct unmap if matches with a large entry or a 4K entry
 	 */
 	if (level == PG_LEVEL_4K || (pgt_ops->pgt_entry_huge(ptep) &&
-			leaf_mapping_allowed(pgt_ops, vaddr, vaddr_end,
-				data->phys, 1 << level, level))) {
-		unsigned long phys = pgt_ops->pgt_entry_to_phys(ptep);
-
-		if (phys != data->phys) {
-			pkvm_err("%s: unmap incorrect phys (0x%lx vs 0x%lx) at vaddr 0x%lx level %d\n",
-				__func__, phys, data->phys, vaddr, level);
-			return 0;
+				     leaf_mapping_valid(pgt_ops, vaddr, vaddr_end,
+							1 << level, level))) {
+		if (data->phys != INVALID_ADDR) {
+			unsigned long phys = pgt_ops->pgt_entry_to_phys(ptep);
+
+			PKVM_ASSERT(phys == data->phys);
 		}
 
 		pgt_ops->pgt_set_entry(ptep, 0);
 		flush_data->flushtlb |= true;
 		mm_ops->put_page(ptep);
 
-		data->phys = ALIGN_DOWN(data->phys, size);
-		data->phys += size;
+		if (data->phys != INVALID_ADDR) {
+			data->phys = ALIGN_DOWN(data->phys, size);
+			data->phys += size;
+		}
 		return 0;
 	}
 
@@ -497,7 +509,22 @@ int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 }
 
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-		       unsigned long phys_start, unsigned long size)
+		       unsigned long size)
+{
+	struct pkvm_pgtable_unmap_data data = {
+		.phys = INVALID_ADDR,
+	};
+	struct pkvm_pgtable_walker walker = {
+		.cb = pgtable_unmap_cb,
+		.arg = &data,
+		.flags = PKVM_PGTABLE_WALK_LEAF | PKVM_PGTABLE_WALK_TABLE_POST,
+	};
+
+	return pgtable_walk(pgt, vaddr_start, size, &walker);
+}
+
+int pkvm_pgtable_unmap_safe(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+			    unsigned long phys_start, unsigned long size)
 {
 	struct pkvm_pgtable_unmap_data data = {
 		.phys = ALIGN_DOWN(phys_start, PAGE_SIZE),
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
index 00d3742b7f48..61ee00ee07af 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
@@ -74,7 +74,9 @@ int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		unsigned long phys_start, unsigned long size,
 		int pgsz_mask, u64 entry_prot);
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-		unsigned long phys_start, unsigned long size);
+		       unsigned long size);
+int pkvm_pgtable_unmap_safe(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+			    unsigned long phys_start, unsigned long size);
 void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		unsigned long *pphys, u64 *pprot, int *plevel);
 void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt);
-- 
2.25.1

