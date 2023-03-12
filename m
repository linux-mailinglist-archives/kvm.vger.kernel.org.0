Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B109F6B646A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCLJ4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCLJ4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC5509BD
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614947; x=1710150947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=++8doH6BIcUCD/avzk117cxA9ka427am8J9ptSqBOm0=;
  b=QBMM+3WSS81TJfjLgOkXrlOeqgztWA0C61LxnHs7lBXV5FYuQKnjhiM4
   F7ktjRxuAlMrv+pYLQ4cs8JXgBCtqKiTcXYL8l2k576UlS0nZb5eYvkwt
   mqx37BEp63jqYULM3JE01mJ9EVk2+YQj0FEEUZCWVCjWb8468mI+w4NAg
   JidSJSXpv3tD317sg74HrGI1tJKo1i82MbBu1kmq5+QdUP6PqvHxFfeyO
   mx86FwyYIEtg/XFPBPfKYVb8Wfkmp3/mEzbJVKSd9P9Akv2fAdz6PEkAL
   79uIlg+Sfj0/9UbZpi5UB8u3exljodxtWlqypWhoX9fn1CiF6GaTzEh17
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623040"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623040"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660811"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660811"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:11 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 09/22] pkvm: x86: Introduce general page table management framework
Date:   Mon, 13 Mar 2023 02:01:39 +0800
Message-Id: <20230312180152.1778338-10-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

pKVM need to setup its own MMU page table and host VM's EPT for the
isolation.

Introduce a general framework to do page table operations (e.g., walk
page table in pKVM), which used to further support creating MMU & host
EPT page table in VMX root mode.

pkvm_pgtable is defined to represent different page tables. Each
pkvm_pgtable have two major ops: the pkvm_pgtable_ops is introduced to
specify the page table operations (like set a specific page table entry
or check if page table entry is present etc.); meantime the pkvm_mm_ops
is introduced to define the page table related memory management (like
page allocation, TLB flush, or phys to virt address translation etc.).

pkvm_pgtable_walker is defined to assist the page table walk, which
provides the callbacks the caller would like to use during walking the
table. Through it, the different page table actions can be archived, in
this patch, map/unmap a range of memory or destroy for a specific page
table is supported.

The map populates or overwrites target range page table entries (PTEs)
for a specific page table, and setup corresponding PTE according to the
desired mapping page size. If overwriting an existing large PTE, while
the mapping range is small than the range represented by this large PTE,
do the split for existing large PTE. Overwriting a present PTE leads to
the TLB flushing at the end of the page walk.

The unmap clears target range PTEs for a specific page table. If it needs
to clear part of a large PTE, do the split as well. Unmap leads to the TLB
flushing at the end of the page walk as well.

The destroy does similar thing as unmap, the difference is it do unmap
for the whole range of a specific page table.

During pgtable unmap or free, a page table page could be freed. From
security consideration, such freed page shall not be used for other
purpose before the TLB flushing happen. Put all the to-be-freed page
table pages into a list and free them one by one after done the TLB
flushing.

TODO: anything can be combined with PKVM on ARM?

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |   2 +-
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c  | 488 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h  |  76 +++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |   6 +
 4 files changed, 571 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 56db60f5682d..39a51230ad3a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
new file mode 100644
index 000000000000..29af06547ad1
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -0,0 +1,488 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+
+#include "pgtable.h"
+#include "memory.h"
+#include "debug.h"
+
+struct pgt_walk_data {
+	struct pkvm_pgtable *pgt;
+	struct pgt_flush_data flush_data;
+	unsigned long vaddr;
+	unsigned long vaddr_end;
+	struct pkvm_pgtable_walker *walker;
+};
+
+struct pkvm_pgtable_map_data {
+	unsigned long phys;
+	u64 prot;
+	int pgsz_mask;
+};
+
+struct pkvm_pgtable_unmap_data {
+	unsigned long phys;
+};
+
+static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
+				unsigned long vaddr,
+				unsigned long vaddr_end,
+				unsigned long phys,
+				int pgsz_mask,
+				int level)
+{
+	unsigned long page_size = pgt_ops->pgt_level_to_size(level);
+
+	if (!((1 << level) & pgsz_mask))
+		return false;
+
+	if (!IS_ALIGNED(vaddr, page_size))
+		return false;
+
+	if (!IS_ALIGNED(phys, page_size))
+		return false;
+
+	if (page_size > (vaddr_end - vaddr))
+		return false;
+
+	return true;
+}
+
+static void pgtable_split(struct pkvm_pgtable_ops *pgt_ops,
+			  struct pkvm_mm_ops *mm_ops,
+			  unsigned long vaddr, unsigned long phys,
+			  unsigned long size, void *ptep,
+			  int level, u64 prot)
+{
+	unsigned long phys_end = phys + size;
+	int level_size = pgt_ops->pgt_level_to_size(level);
+	int entry_size = PAGE_SIZE / pgt_ops->pgt_level_to_entries(level);
+	int i = 0;
+
+	if (level > PG_LEVEL_4K)
+		pgt_ops->pgt_entry_mkhuge(&prot);
+
+	for (i = 0; phys < phys_end; phys += level_size, i++) {
+		pgt_ops->pgt_set_entry((ptep + i * entry_size), phys | prot);
+		mm_ops->get_page(ptep);
+	}
+}
+
+static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
+				unsigned long vaddr_end, int level, void *ptep,
+				struct pgt_flush_data *flush_data,
+				struct pkvm_pgtable_map_data *data)
+{
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	u64 new;
+
+	if (!leaf_mapping_allowed(pgt_ops, vaddr, vaddr_end,
+				 data->phys, data->pgsz_mask, level)) {
+		/* The 4K page shall be able to map, otherwise return err */
+		return (level == PG_LEVEL_4K ? -EINVAL : -E2BIG);
+	}
+
+	new = data->phys | data->prot;
+	if (level != PG_LEVEL_4K)
+		pgt_ops->pgt_entry_mkhuge(&new);
+
+	if (pgt_ops->pgt_entry_present(ptep)) {
+		pgt_ops->pgt_set_entry(ptep, 0);
+		flush_data->flushtlb |= true;
+		mm_ops->put_page(ptep);
+	}
+
+	mm_ops->get_page(ptep);
+	pgt_ops->pgt_set_entry(ptep, new);
+
+	data->phys += page_level_size(level);
+
+	return 0;
+}
+
+static int pgtable_map_walk_leaf(struct pkvm_pgtable *pgt,
+				 unsigned long vaddr, unsigned long vaddr_end,
+				 int level, void *ptep, unsigned long flags,
+				 struct pgt_flush_data *flush_data,
+				 struct pkvm_pgtable_map_data *data)
+{
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	unsigned long size = page_level_size(level);
+	void *page;
+	int ret;
+
+	/* First try to create leaf page mapping on current level */
+	ret = pgtable_map_try_leaf(pgt, vaddr, vaddr_end, level, ptep, flush_data, data);
+	if (ret != -E2BIG)
+		return ret;
+
+	/*
+	 * Be here is because the mapping needs be done on smaller(or level-1)
+	 * page size. We need to allocate a table page for the smaller(level-1)
+	 * page mapping. And for current level, if the huge page mapping already
+	 * present, we need further split it.
+	 */
+	page = mm_ops->zalloc_page();
+	if (!page)
+		return -ENOMEM;
+
+	if (pgt_ops->pgt_entry_huge(ptep)) {
+		/*
+		 * Split the large mapping and reuse the
+		 * large mapping's prot. The translation
+		 * doesn't have a change, so no need to
+		 * flush tlb.
+		 */
+		mm_ops->put_page(ptep);
+		pgtable_split(pgt_ops, mm_ops, ALIGN_DOWN(vaddr, size),
+			      pgt_ops->pgt_entry_to_phys(ptep),
+			      size, page, level - 1,
+			      pgt_ops->pgt_entry_to_prot(ptep));
+	}
+
+	mm_ops->get_page(ptep);
+	pgt_ops->pgt_set_entry(ptep, pgt->table_prot | mm_ops->virt_to_phys(page));
+
+	return 0;
+}
+
+/*
+ *TODO: support merging small entries to a large one.
+ */
+static int pgtable_map_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
+			  unsigned long vaddr_end, int level, void *ptep,
+			  unsigned long flags, struct pgt_flush_data *flush_data,
+			  void *const arg)
+{
+	struct pkvm_pgtable_map_data *data = arg;
+
+	switch (flags) {
+	case PKVM_PGTABLE_WALK_LEAF:
+		return pgtable_map_walk_leaf(pgt, vaddr, vaddr_end, level,
+					     ptep, flags, flush_data, data);
+	case PKVM_PGTABLE_WALK_TABLE_PRE:
+	case PKVM_PGTABLE_WALK_TABLE_POST:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * put_page_to_free_list(): the page added to the freelist should not be used
+ * by any one as this page will be used as a node linked to the freelist.
+ */
+static inline void put_page_to_freelist(void *page, struct list_head *head)
+{
+	struct list_head *node = page;
+
+	list_add_tail(node, head);
+}
+
+/*
+ * get_page_to_free_list(): the page got from the freelist is valid to be used
+ * again.
+ */
+static inline void *get_page_from_freelist(struct list_head *head)
+{
+	struct list_head *node = head->next;
+
+	list_del(node);
+	memset(node, 0, sizeof(struct list_head));
+
+	return (void *)node;
+}
+
+static int pgtable_unmap_cb(struct pkvm_pgtable *pgt, unsigned long vaddr,
+			    unsigned long vaddr_end, int level, void *ptep,
+			    unsigned long flags, struct pgt_flush_data *flush_data,
+			    void *const arg)
+{
+	struct pkvm_pgtable_unmap_data *data = arg;
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	unsigned long size = page_level_size(level);
+	void *child_ptep;
+
+	if (!pgt_ops->pgt_entry_present(ptep))
+		/* Nothing to do if the entry is not present */
+		return 0;
+
+	/*
+	 * Can direct unmap if matches with a large entry or a 4K entry
+	 */
+	if (level == PG_LEVEL_4K || (pgt_ops->pgt_entry_huge(ptep) &&
+			leaf_mapping_allowed(pgt_ops, vaddr, vaddr_end,
+				data->phys, 1 << level, level))) {
+		unsigned long phys = pgt_ops->pgt_entry_to_phys(ptep);
+
+		if (phys != data->phys) {
+			pkvm_err("%s: unmap incorrect phys (0x%lx vs 0x%lx) at vaddr 0x%lx level %d\n",
+				__func__, phys, data->phys, vaddr, level);
+			return 0;
+		}
+
+		pgt_ops->pgt_set_entry(ptep, 0);
+		flush_data->flushtlb |= true;
+		mm_ops->put_page(ptep);
+
+		data->phys = ALIGN_DOWN(data->phys, size);
+		data->phys += size;
+		return 0;
+	}
+
+	if (pgt_ops->pgt_entry_huge(ptep)) {
+		/*
+		 * if it is huge pte, split and goto next level.
+		 */
+		void *page = mm_ops->zalloc_page();
+
+		if (!page)
+			return -ENOMEM;
+		/*
+		 * Split the large mapping and reuse the
+		 * large mapping's prot. The translation
+		 * doesn't have a change, so no need to
+		 * flush tlb.
+		 */
+		pgtable_split(pgt_ops, mm_ops, ALIGN_DOWN(vaddr, size),
+			      pgt_ops->pgt_entry_to_phys(ptep),
+			      size, page, level - 1,
+			      pgt_ops->pgt_entry_to_prot(ptep));
+		pgt_ops->pgt_set_entry(ptep, pgt->table_prot | mm_ops->virt_to_phys(page));
+		return 0;
+	}
+
+	/*
+	 * if not huge entry then means it is table entry, then check
+	 * the child pte page refcount. Put the child pte page if no
+	 * one else is using it.
+	 */
+	child_ptep = mm_ops->phys_to_virt(pgt_ops->pgt_entry_to_phys(ptep));
+	if (mm_ops->page_count(child_ptep) == 1) {
+		pgt_ops->pgt_set_entry(ptep, 0);
+		mm_ops->put_page(ptep);
+		put_page_to_freelist(child_ptep, &flush_data->free_list);
+	}
+
+	return 0;
+}
+
+static int pgtable_free_cb(struct pkvm_pgtable *pgt,
+			    unsigned long vaddr,
+			    unsigned long vaddr_end,
+			    int level,
+			    void *ptep,
+			    unsigned long flags,
+			    struct pgt_flush_data *flush_data,
+			    void *const arg)
+{
+	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	phys_addr_t phys;
+	void *virt;
+
+	if (pgt_ops->pgt_entry_is_leaf(ptep, level)) {
+		if (pgt_ops->pgt_entry_present(ptep)) {
+			flush_data->flushtlb |= true;
+			mm_ops->put_page(ptep);
+		}
+		return 0;
+	}
+
+	/* Free the child page */
+	phys = pgt_ops->pgt_entry_to_phys(ptep);
+	virt = mm_ops->phys_to_virt(phys);
+	if (mm_ops->page_count(virt) == 1) {
+		pgt_ops->pgt_set_entry(ptep, 0);
+		mm_ops->put_page(ptep);
+		put_page_to_freelist(virt, &flush_data->free_list);
+	}
+
+	return 0;
+}
+
+static int _pgtable_walk(struct pgt_walk_data *data, void *ptep, int level);
+static int pgtable_visit(struct pgt_walk_data *data, void *ptep, int level)
+{
+	struct pkvm_pgtable_ops *pgt_ops = data->pgt->pgt_ops;
+	struct pkvm_mm_ops *mm_ops = data->pgt->mm_ops;
+	struct pkvm_pgtable_walker *walker = data->walker;
+	unsigned long flags = walker->flags;
+	bool leaf = pgt_ops->pgt_entry_is_leaf(ptep, level);
+	void *child_ptep;
+	int ret = 0;
+
+	if (!leaf && (flags & PKVM_PGTABLE_WALK_TABLE_PRE))
+		ret = walker->cb(data->pgt, data->vaddr, data->vaddr_end,
+				 level, ptep, PKVM_PGTABLE_WALK_TABLE_PRE,
+				 &data->flush_data, walker->arg);
+
+	if (leaf && (flags & PKVM_PGTABLE_WALK_LEAF)) {
+		ret = walker->cb(data->pgt, data->vaddr, data->vaddr_end,
+				 level, ptep, PKVM_PGTABLE_WALK_LEAF,
+				 &data->flush_data, walker->arg);
+		leaf = pgt_ops->pgt_entry_is_leaf(ptep, level);
+	}
+
+	if (ret)
+		return ret;
+
+	if (leaf) {
+		unsigned long size = pgt_ops->pgt_level_to_size(level);
+
+		data->vaddr = ALIGN_DOWN(data->vaddr, size);
+		data->vaddr += size;
+		return ret;
+	}
+
+	child_ptep = mm_ops->phys_to_virt(pgt_ops->pgt_entry_to_phys(ptep));
+	ret = _pgtable_walk(data, child_ptep, level - 1);
+	if (ret)
+		return ret;
+
+	if (flags & PKVM_PGTABLE_WALK_TABLE_POST)
+		ret = walker->cb(data->pgt, data->vaddr, data->vaddr_end,
+				 level, ptep, PKVM_PGTABLE_WALK_TABLE_POST,
+				 &data->flush_data, walker->arg);
+
+	return ret;
+}
+
+static int _pgtable_walk(struct pgt_walk_data *data, void *ptep, int level)
+{
+	struct pkvm_pgtable_ops *pgt_ops = data->pgt->pgt_ops;
+	int entries = pgt_ops->pgt_level_to_entries(level);
+	int entry_size = pgt_ops->pgt_level_entry_size(level);
+	int idx = pgt_ops->pgt_entry_to_index(data->vaddr, level);
+	int ret;
+
+	for (; idx < entries; idx++) {
+		if (data->vaddr >= data->vaddr_end)
+			break;
+
+		ret = pgtable_visit(data, (ptep + idx * entry_size), level);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int pgtable_walk(struct pkvm_pgtable *pgt, unsigned long vaddr,
+			unsigned long size, struct pkvm_pgtable_walker *walker)
+{
+	unsigned long aligned_vaddr = ALIGN_DOWN(vaddr, PAGE_SIZE);
+	struct pgt_walk_data data = {
+		.pgt = pgt,
+		.flush_data = {
+			.flushtlb = false,
+			.free_list = LIST_HEAD_INIT(data.flush_data.free_list),
+		},
+		.vaddr = aligned_vaddr,
+		.vaddr_end = aligned_vaddr + ALIGN(size, PAGE_SIZE),
+		.walker = walker,
+	};
+	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
+	int ret;
+
+	if (!size || data.vaddr == data.vaddr_end)
+		return 0;
+
+	ret = _pgtable_walk(&data, mm_ops->phys_to_virt(pgt->root_pa), pgt->level);
+
+	if (data.flush_data.flushtlb || !list_empty(&data.flush_data.free_list))
+		pgt->mm_ops->flush_tlb();
+
+	while (!list_empty(&data.flush_data.free_list)) {
+		void *page = get_page_from_freelist(&data.flush_data.free_list);
+
+		pgt->mm_ops->put_page(page);
+	}
+
+	return ret;
+}
+
+int pkvm_pgtable_init(struct pkvm_pgtable *pgt,
+			     struct pkvm_mm_ops *mm_ops,
+			     struct pkvm_pgtable_ops *pgt_ops,
+			     struct pkvm_pgtable_cap *cap,
+			     bool alloc_root)
+{
+	void *root;
+
+	if (!mm_ops || !pgt_ops || !cap)
+		return -EINVAL;
+
+	if (alloc_root && mm_ops->zalloc_page) {
+		root = mm_ops->zalloc_page();
+		if (!root)
+			return -ENOMEM;
+		pgt->root_pa = __pkvm_pa(root);
+	}
+
+	pgt->mm_ops = mm_ops;
+	pgt->pgt_ops = pgt_ops;
+	pgt->level = cap->level;
+	pgt->allowed_pgsz = cap->allowed_pgsz;
+	pgt->table_prot = cap->table_prot;
+
+	return 0;
+}
+
+int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		     unsigned long phys_start, unsigned long size,
+		     int pgsz_mask, u64 prot)
+{
+	struct pkvm_pgtable_map_data data = {
+		.phys = ALIGN_DOWN(phys_start, PAGE_SIZE),
+		.prot = prot,
+		.pgsz_mask = pgsz_mask ? pgt->allowed_pgsz & pgsz_mask :
+					 pgt->allowed_pgsz,
+	};
+	struct pkvm_pgtable_walker walker = {
+		.cb = pgtable_map_cb,
+		.arg = &data,
+		.flags = PKVM_PGTABLE_WALK_LEAF,
+	};
+
+	return pgtable_walk(pgt, vaddr_start, size, &walker);
+}
+
+int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		       unsigned long phys_start, unsigned long size)
+{
+	struct pkvm_pgtable_unmap_data data = {
+		.phys = ALIGN_DOWN(phys_start, PAGE_SIZE),
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
+void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt)
+{
+	unsigned long size;
+	void *virt_root;
+	struct pkvm_pgtable_ops *pgt_ops;
+	struct pkvm_pgtable_walker walker = {
+		.cb 	= pgtable_free_cb,
+		.flags 	= PKVM_PGTABLE_WALK_LEAF | PKVM_PGTABLE_WALK_TABLE_POST,
+	};
+
+	pgt_ops = pgt->pgt_ops;
+	size = pgt_ops->pgt_level_to_size(pgt->level + 1);
+
+	pgtable_walk(pgt, 0, size, &walker);
+	virt_root = pgt->mm_ops->phys_to_virt(pgt->root_pa);
+	pgt->mm_ops->put_page(virt_root);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
new file mode 100644
index 000000000000..5035b21e6aa0
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_PGTABLE_H_
+#define _PKVM_PGTABLE_H_
+
+#include <linux/types.h>
+#include <asm/pgtable_types.h>
+
+struct pkvm_mm_ops {
+	void *(*phys_to_virt)(unsigned long phys);
+	unsigned long (*virt_to_phys)(void *vaddr);
+	void *(*zalloc_page)(void);
+	int (*page_count)(void *vaddr);
+	void (*get_page)(void *vaddr);
+	void (*put_page)(void *vaddr);
+	void (*flush_tlb)(void);
+};
+
+struct pkvm_pgtable_ops {
+	bool (*pgt_entry_present)(void *pte);
+	bool (*pgt_entry_huge)(void *pte);
+	void (*pgt_entry_mkhuge)(void *ptep);
+	unsigned long (*pgt_entry_to_phys)(void *pte);
+	u64 (*pgt_entry_to_prot)(void *pte);
+	int (*pgt_entry_to_index)(unsigned long vaddr, int level);
+	bool (*pgt_entry_is_leaf)(void *ptep, int level);
+	int (*pgt_level_entry_size)(int level);
+	int (*pgt_level_to_entries)(int level);
+	unsigned long (*pgt_level_to_size)(int level);
+	void (*pgt_set_entry)(void *ptep, u64 val);
+};
+
+struct pkvm_pgtable {
+	unsigned long root_pa;
+	int level;
+	int allowed_pgsz;
+	u64 table_prot;
+	struct pkvm_mm_ops *mm_ops;
+	struct pkvm_pgtable_ops *pgt_ops;
+};
+
+struct pgt_flush_data {
+	bool flushtlb;
+	struct list_head free_list;
+};
+
+typedef int (*pgtable_visit_fn_t)(struct pkvm_pgtable *pgt, unsigned long vaddr,
+				  unsigned long vaddr_end, int level, void *ptep,
+				  unsigned long flags, struct pgt_flush_data *flush_data,
+				  void *const arg);
+
+struct pkvm_pgtable_walker {
+	const pgtable_visit_fn_t cb;
+	void *const arg;
+	unsigned long flags;
+#define PKVM_PGTABLE_WALK_TABLE_PRE	BIT(0)
+#define PKVM_PGTABLE_WALK_LEAF		BIT(1)
+#define PKVM_PGTABLE_WALK_TABLE_POST	BIT(2)
+};
+
+int pgtable_walk(struct pkvm_pgtable *pgt, unsigned long vaddr,
+		unsigned long size, struct pkvm_pgtable_walker *walker);
+int pkvm_pgtable_init(struct pkvm_pgtable *pgt,
+		struct pkvm_mm_ops *mm_ops,
+		struct pkvm_pgtable_ops *pgt_ops,
+		struct pkvm_pgtable_cap *cap,
+		bool alloc_root);
+int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		unsigned long phys_start, unsigned long size,
+		int pgsz_mask, u64 entry_prot);
+int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		unsigned long phys_start, unsigned long size);
+void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt);
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 334630efb233..3b75760b37a3 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -11,6 +11,12 @@
 
 #define STACK_SIZE SZ_16K
 
+struct pkvm_pgtable_cap {
+	int level;
+	int allowed_pgsz;
+	u64 table_prot;
+};
+
 struct idt_page {
 	gate_desc idt[IDT_ENTRIES];
 } __aligned(PAGE_SIZE);
-- 
2.25.1

