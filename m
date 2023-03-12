Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623616B6475
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCLJ50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCLJ47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211BB38649
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614990; x=1710150990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IqVwIFvTCNh6jEDJqBZ0Q18zctfqgOM4iSVUpO1A9zY=;
  b=Xl1u29EGX6eahqBR1nO7NdRvTFA/Ml4d/1BtTEE4CONOuzyuFADz8f/G
   /l5GWDPV7tMEeBri7yFGGB2xJlvygQ1uJUF6dc0YLN+aCEvtwzSLf3OdD
   cGa57HD6xc4EO6BsT0OL/N5pbePxv77pAlc8zyMg5jY8K1c9GzYpFTkeC
   6QfxNwivHkD26j1E/3rPFDJ8DqLan6A930CYg3SIyhftFLKGs+n2KgVc8
   NtEK8RJM7ep99DMAEKOOcGFeUxLlgiCq98q237zaJJMPp57WM+7HeN8qH
   /OskEdU1fbQJe85T6NAX7QpYL3MEB9ArBbuieR0byAHfH7vOJb694YnsO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623065"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623065"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660852"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660852"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:28 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 20/22] pkvm: x86: Add pgtable API pkvm_pgtable_lookup
Date:   Mon, 13 Mar 2023 02:01:50 +0800
Message-Id: <20230312180152.1778338-21-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add pkvm_pgtable_lookup API for pgtable. It can be used to walk page
table for a translation lookup, such as looking up if a page mapping is
present in a specific page table.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c     |  6 +++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h  |  2 +
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c     |  6 +++
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c | 74 ++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h |  5 ++
 5 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 5b7b0d84b457..10d226d3ec59 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -102,6 +102,11 @@ static int ept_level_to_entries(int level)
 	return SPTE_ENT_PER_PAGE;
 }
 
+static u64 ept_level_page_mask(int level)
+{
+	return (~((1UL << SPTE_LEVEL_SHIFT(level)) - 1));
+}
+
 static unsigned long ept_level_to_size(int level)
 {
 	return KVM_HPAGE_SIZE(level);
@@ -119,6 +124,7 @@ struct pkvm_pgtable_ops ept_ops = {
 	.pgt_entry_to_phys = ept_entry_to_phys,
 	.pgt_entry_to_prot = ept_entry_to_prot,
 	.pgt_entry_to_index = ept_entry_to_index,
+	.pgt_level_page_mask = ept_level_page_mask,
 	.pgt_entry_is_leaf = ept_entry_is_leaf,
 	.pgt_level_entry_size = ept_level_entry_size,
 	.pgt_level_to_entries = ept_level_to_entries,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
index c2eee487687a..87b53275bc74 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -7,6 +7,8 @@
 
 #include <asm/kvm_pkvm.h>
 
+#define INVALID_ADDR (~0UL)
+
 unsigned long pkvm_virt_to_symbol_phys(void *virt);
 #define __pkvm_pa_symbol(x) pkvm_virt_to_symbol_phys((void *)x)
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index 0902f457d682..7684d16dd2c9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -109,6 +109,11 @@ static void mmu_set_entry(void *ptep, u64 pte)
 	native_set_pte((pte_t *)ptep, native_make_pte(pte));
 }
 
+static u64 mmu_level_page_mask(int level)
+{
+	return (~((1UL << SPTE_LEVEL_SHIFT(level)) - 1));
+}
+
 struct pkvm_pgtable_ops mmu_ops = {
 	.pgt_entry_present = mmu_entry_present,
 	.pgt_entry_huge = mmu_entry_huge,
@@ -116,6 +121,7 @@ struct pkvm_pgtable_ops mmu_ops = {
 	.pgt_entry_to_phys = mmu_entry_to_phys,
 	.pgt_entry_to_prot = mmu_entry_to_prot,
 	.pgt_entry_to_index = mmu_entry_to_index,
+	.pgt_level_page_mask = mmu_level_page_mask,
 	.pgt_entry_is_leaf = mmu_entry_is_leaf,
 	.pgt_level_entry_size = mmu_level_entry_size,
 	.pgt_level_to_entries = mmu_level_to_entries,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
index 29af06547ad1..d55acc84f4e1 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -27,6 +27,13 @@ struct pkvm_pgtable_unmap_data {
 	unsigned long phys;
 };
 
+struct pkvm_pgtable_lookup_data {
+	unsigned long vaddr;
+	unsigned long phys;
+	u64 prot;
+	int level;
+};
+
 static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
 				unsigned long vaddr,
 				unsigned long vaddr_end,
@@ -273,6 +280,41 @@ static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
 	return 0;
 }
 
+static int pgtable_lookup_cb(struct pkvm_pgtable *pgt,
+			    unsigned long aligned_vaddr,
+			    unsigned long aligned_vaddr_end,
+			    int level,
+			    void *ptep,
+			    unsigned long flags,
+			    struct pgt_flush_data *flush_data,
+			    void *const arg)
+{
+	struct pkvm_pgtable_lookup_data *data = arg;
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	u64 pte = atomic64_read((atomic64_t *)ptep);
+
+	data->phys = INVALID_ADDR;
+	data->prot = 0;
+	data->level = level;
+
+	/*
+	 * This cb shall only be called for leaf, if now it is not a leaf
+	 * that means the pte is changed by others, we shall re-walk the pgtable
+	 */
+	if (unlikely(!pgt_ops->pgt_entry_is_leaf(&pte, level)))
+		return -EAGAIN;
+
+	if (pgt_ops->pgt_entry_present(&pte)) {
+		unsigned long offset =
+			data->vaddr & ~pgt_ops->pgt_level_page_mask(level);
+
+		data->phys = pgt_ops->pgt_entry_to_phys(&pte) + offset;
+		data->prot = pgt_ops->pgt_entry_to_prot(&pte);
+	}
+
+	return PGTABLE_WALK_DONE;
+}
+
 static int pgtable_free_cb(struct pkvm_pgtable *pgt,
 			    unsigned long vaddr,
 			    unsigned long vaddr_end,
@@ -367,7 +409,7 @@ static int _pgtable_walk(struct pgt_walk_data *data, void *ptep, int level)
 			break;
 
 		ret = pgtable_visit(data, (ptep + idx * entry_size), level);
-		if (ret < 0)
+		if (ret)
 			return ret;
 	}
 
@@ -469,6 +511,36 @@ int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 	return pgtable_walk(pgt, vaddr_start, size, &walker);
 }
 
+void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
+		     unsigned long *pphys, u64 *pprot, int *plevel)
+{
+	struct pkvm_pgtable_lookup_data data = {
+		.vaddr = vaddr,
+	};
+	struct pkvm_pgtable_walker walker = {
+		.cb = pgtable_lookup_cb,
+		.arg = &data,
+		.flags = PKVM_PGTABLE_WALK_LEAF,
+	};
+	int ret, retry_cnt = 0;
+
+retry:
+	ret = pgtable_walk(pgt, vaddr, PAGE_SIZE, &walker);
+	/*
+	 * we give 5 times chance to re-walk pgtable if others change the
+	 * PTE during above pgtable walk.
+	 */
+	if ((ret == -EAGAIN) && (retry_cnt++ < 5))
+		goto retry;
+
+	if (pphys)
+		*pphys = data.phys;
+	if (pprot)
+		*pprot = data.prot;
+	if (plevel)
+		*plevel = data.level;
+}
+
 void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt)
 {
 	unsigned long size;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
index 5035b21e6aa0..00d3742b7f48 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
@@ -25,6 +25,7 @@ struct pkvm_pgtable_ops {
 	unsigned long (*pgt_entry_to_phys)(void *pte);
 	u64 (*pgt_entry_to_prot)(void *pte);
 	int (*pgt_entry_to_index)(unsigned long vaddr, int level);
+	u64 (*pgt_level_page_mask)(int level);
 	bool (*pgt_entry_is_leaf)(void *ptep, int level);
 	int (*pgt_level_entry_size)(int level);
 	int (*pgt_level_to_entries)(int level);
@@ -51,6 +52,8 @@ typedef int (*pgtable_visit_fn_t)(struct pkvm_pgtable *pgt, unsigned long vaddr,
 				  unsigned long flags, struct pgt_flush_data *flush_data,
 				  void *const arg);
 
+#define PGTABLE_WALK_DONE      1
+
 struct pkvm_pgtable_walker {
 	const pgtable_visit_fn_t cb;
 	void *const arg;
@@ -72,5 +75,7 @@ int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		int pgsz_mask, u64 entry_prot);
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		unsigned long phys_start, unsigned long size);
+void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
+		unsigned long *pphys, u64 *pprot, int *plevel);
 void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt);
 #endif
-- 
2.25.1

