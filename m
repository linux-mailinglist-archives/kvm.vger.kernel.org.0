Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC066B64A8
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCLKBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjCLKAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A05423679
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615182; x=1710151182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RuV4Owul7H7qcvOSvbW7a7U80AWCg8YPx+xC4p5Qy34=;
  b=jZ8xCVaRqE9iJsYoW2z0Y/HxZb4A4TZ0KUSDGf240QUhVzdTSkMH/CeH
   jtBVwBNF1VZPU/7fQpWUmH9OOjvF/V1ibQvq0N0tzCeD9+dBok8jzrMqD
   uvMGPc0vmdxV//2tftuoaWjtv23g+rrbsi4Gsudh8R4fuBU7QlN4KyReY
   e1ydgJ0nhsKdxSw2iR5pjEh9YTAQaXpr844faC7BAeaokWTD7mEBIQTPV
   A4TJiritqASAHFvkklzaIsOkpRjq2I+cENM1LQBO3W7fX+YqEn4vlyvmc
   M3sq4UixsroWx/wlf7HFY6+X5sMoooM8LEHPWDhoK1gDLpjXi7shy/Sh9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344754"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344754"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627506"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627506"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:24 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-7 04/12] pkvm: x86: Add the record of the page state into page table entry
Date:   Mon, 13 Mar 2023 02:04:07 +0800
Message-Id: <20230312180415.1778669-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
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

From: Shaoqin Huang <shaoqin.huang@intel.com>

Add init page state of PKVM_PAGE_OWNED into PTE of host EPT page table
when first creating host EPT mapping and handling EPT violation for MMIO
ranges.

Besides, unmapping pages in host EPT (eg. pkvm code and data memory
regions) has an implicit effect. After unmapping, the PTE of these pages
are cleared to 0, that means they are under page state of PKVM_NOPAGE and
owned by pKVM hypervisor (owner_id = 0).

Also refine pgtable map API for page state only changes and ensure page
state will not be lost during pgtable split.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           |  3 ++-
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c |  6 +++---
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c       | 19 +++++++++++++++----
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index de68f8c9eeb0..2a4d6cc7fa81 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -19,6 +19,7 @@
 #include "ept.h"
 #include "memory.h"
 #include "vmx.h"
+#include "mem_protect.h"
 #include "debug.h"
 
 static struct hyp_pool host_ept_pool;
@@ -217,7 +218,7 @@ int handle_host_ept_violation(unsigned long gpa)
 	unsigned long hpa;
 	struct mem_range range, cur;
 	bool is_memory = find_mem_range(gpa, &range);
-	u64 prot = HOST_EPT_DEF_MMIO_PROT;
+	u64 prot = pkvm_mkstate(HOST_EPT_DEF_MMIO_PROT, PKVM_PAGE_OWNED);
 	int level;
 	int ret;
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index 8d52a20f6497..305b201a787e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -19,6 +19,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "debug.h"
+#include "mem_protect.h"
 
 void *pkvm_mmu_pgt_base;
 void *pkvm_vmemmap_base;
@@ -182,8 +183,7 @@ static int create_host_ept_mapping(void)
 	/*
 	 * Create EPT mapping for memory with WB + RWX property
 	 */
-	entry_prot = HOST_EPT_DEF_MEM_PROT;
-
+	entry_prot = pkvm_mkstate(HOST_EPT_DEF_MEM_PROT, PKVM_PAGE_OWNED);
 	for (i = 0; i < hyp_memblock_nr; i++) {
 		reg = &hyp_memory[i];
 		ret = pkvm_host_ept_map((unsigned long)reg->base,
@@ -198,7 +198,7 @@ static int create_host_ept_mapping(void)
 	 * The holes in memblocks are treated as MMIO with the
 	 * mapping UC + RWX.
 	 */
-	entry_prot = HOST_EPT_DEF_MMIO_PROT;
+	entry_prot = pkvm_mkstate(HOST_EPT_DEF_MMIO_PROT, PKVM_PAGE_OWNED);
 	for (i = 0; i < hyp_memblock_nr; i++, phys = reg->base + reg->size) {
 		reg = &hyp_memory[i];
 		ret = pkvm_host_ept_map(phys, phys, (unsigned long)reg->base - phys,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
index 95aef57d8ed7..5854a30dbf8b 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -7,6 +7,7 @@
 
 #include "pgtable.h"
 #include "memory.h"
+#include "mem_protect.h"
 #include "debug.h"
 #include "bug.h"
 
@@ -130,6 +131,10 @@ static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	}
 
 	if (pgtable_pte_is_counted(old)) {
+		/* if just modify the page state, do set_pte directly */
+		if (!((old ^ new) & ~PKVM_PAGE_STATE_PROT_MASK))
+			goto set_pte;
+
 		if (pgt_ops->pgt_entry_present(ptep)) {
 			pgt_ops->pgt_set_entry(ptep, 0);
 			flush_data->flushtlb |= true;
@@ -140,6 +145,7 @@ static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	if (pgtable_pte_is_counted(new))
 		mm_ops->get_page(ptep);
 
+set_pte:
 	pgt_ops->pgt_set_entry(ptep, new);
 	if (pkvm_phys_is_valid(data->phys))
 		data->phys += page_level_size(level);
@@ -175,6 +181,10 @@ static int pgtable_map_walk_leaf(struct pkvm_pgtable *pgt,
 		return -ENOMEM;
 
 	if (pgt_ops->pgt_entry_huge(ptep)) {
+		u64 prot = pgt_ops->pgt_entry_to_prot(ptep);
+
+		prot = pkvm_mkstate(prot, pkvm_getstate(*(u64 *)ptep));
+
 		/*
 		 * Split the large mapping and reuse the
 		 * large mapping's prot. The translation
@@ -184,8 +194,7 @@ static int pgtable_map_walk_leaf(struct pkvm_pgtable *pgt,
 		mm_ops->put_page(ptep);
 		pgtable_split(pgt_ops, mm_ops, ALIGN_DOWN(vaddr, size),
 			      pgt_ops->pgt_entry_to_phys(ptep),
-			      size, page, level - 1,
-			      pgt_ops->pgt_entry_to_prot(ptep));
+			      size, page, level - 1, prot);
 	}
 
 	mm_ops->get_page(ptep);
@@ -283,10 +292,13 @@ static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		/*
 		 * if it is huge pte, split and goto next level.
 		 */
+		u64 prot = pgt_ops->pgt_entry_to_prot(ptep);
 		void *page = mm_ops->zalloc_page();
 
 		if (!page)
 			return -ENOMEM;
+
+		prot = pkvm_mkstate(prot, pkvm_getstate(*(u64 *)ptep));
 		/*
 		 * Split the large mapping and reuse the
 		 * large mapping's prot. The translation
@@ -295,8 +307,7 @@ static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		 */
 		pgtable_split(pgt_ops, mm_ops, ALIGN_DOWN(vaddr, size),
 			      pgt_ops->pgt_entry_to_phys(ptep),
-			      size, page, level - 1,
-			      pgt_ops->pgt_entry_to_prot(ptep));
+			      size, page, level - 1, prot);
 		pgt_ops->pgt_set_entry(ptep, pgt->table_prot | mm_ops->virt_to_phys(page));
 		return 0;
 	}
-- 
2.25.1

