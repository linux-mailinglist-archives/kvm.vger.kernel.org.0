Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285117AF268
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 20:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjIZSEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 14:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbjIZSEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 14:04:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ABD10A;
        Tue, 26 Sep 2023 11:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695751472; x=1727287472;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BPSD5WhvXpBO3lsIdE4c7syBr8J6jYNl4IAaRzob9YA=;
  b=D1OgvBNMHp1u53zOf1OONKlkZPkSEWYBGODnyQ/MKWso71k3HYY+KHMM
   0AZKHUYau1kTDKXkyZFNk2g/Wv5IfBLKulqnArmJWpggLQHLyL83pOfAr
   BxBLbT9ghi9I3vi9zSfDs/IpH2ChXa69saEiAIj0eDMmOslR0p1ka83dp
   qg4K0ekduysrG4Hjp+j+4OCOyITmjAcKavn4Ig4N4XoXhm44X60lmKi6V
   kqsgdN7VaC4EbzN0pzSQGhZO+7YOyEFCsWeUuj8/VYiDHnMcvZXvDck6A
   piLYEy0RE7nCV0RAQULhOJ9BTtQknat67Z8Rl40NshMo1dWUhtbNlmu/O
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="371967682"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="371967682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:04:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="725514679"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="725514679"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:04:28 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH] KVM: guest_memfd: Refactor kvm_gmem into inode->i_private
Date:   Tue, 26 Sep 2023 11:03:46 -0700
Message-Id: <8e57c347d6c461431e84ef4354dc076f363f3c01.1695751312.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Refactor guest_memfd to use inode->i_private to store info about kvm_gmem.
Currently it is stored in the following way.
- flags in inode->i_private
- struct kvm_gmem in file->private_data
- struct kvm_gmem in linked linst in inode->i_mapping->private_list
  And this list has single entry.

The relationship between struct file, struct inode and struct kvm_gmem is
1:1, not 1:many. Consolidate related info in one place.
- Move flags into struct kvm_gmem
- Store struct kvm_gmem in inode->i_private
- Don't use file->private_data
- Don't use inode->i_mapping_private_list
- Introduce a helper conversion function from inode to kvm_gmem

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/guest_memfd.c | 53 ++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4f3a313f5532..66dd9b55e85c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -14,14 +14,19 @@ static struct vfsmount *kvm_gmem_mnt;
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
-	struct list_head entry;
+	unsigned long flags;
 };
 
+static struct kvm_gmem *to_gmem(struct inode *inode)
+{
+	return inode->i_private;
+}
+
 static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	unsigned long huge_index = round_down(index, HPAGE_PMD_NR);
-	unsigned long flags = (unsigned long)inode->i_private;
+	unsigned long flags = to_gmem(inode)->flags;
 	struct address_space *mapping  = inode->i_mapping;
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	struct folio *folio;
@@ -134,26 +139,22 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
-	struct list_head *gmem_list = &inode->i_mapping->private_list;
+	struct address_space *mapping = inode->i_mapping;
+	struct kvm_gmem *gmem = to_gmem(inode);
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
-	struct kvm_gmem *gmem;
 
 	/*
 	 * Bindings must stable across invalidation to ensure the start+end
 	 * are balanced.
 	 */
-	filemap_invalidate_lock(inode->i_mapping);
-
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+	filemap_invalidate_lock(mapping);
+	kvm_gmem_invalidate_begin(gmem, start, end);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
-
-	filemap_invalidate_unlock(inode->i_mapping);
+	kvm_gmem_invalidate_end(gmem, start, end);
+	filemap_invalidate_unlock(mapping);
 
 	return 0;
 }
@@ -231,7 +232,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
-	struct kvm_gmem *gmem = file->private_data;
+	struct kvm_gmem *gmem = to_gmem(inode);
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
@@ -260,8 +261,6 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
-	list_del(&gmem->entry);
-
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	mutex_unlock(&kvm->slots_lock);
@@ -305,8 +304,7 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 
 static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 {
-	struct list_head *gmem_list = &mapping->private_list;
-	struct kvm_gmem *gmem;
+	struct kvm_gmem *gmem = to_gmem(mapping->host);
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -314,8 +312,7 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 	start = page->index;
 	end = start + thp_nr_pages(page);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+	kvm_gmem_invalidate_begin(gmem, start, end);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the
@@ -326,8 +323,7 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 	 * error to userspace.
 	 */
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
+	kvm_gmem_invalidate_end(gmem, start, end);
 
 	filemap_invalidate_unlock_shared(mapping);
 
@@ -382,7 +378,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
 	if (err)
 		goto err_inode;
 
-	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
@@ -417,10 +412,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
+	gmem->flags = flags;
 
-	file->private_data = gmem;
-
-	list_add(&gmem->entry, &inode->i_mapping->private_list);
+	inode->i_private = gmem;
 
 	fd_install(fd, file);
 	return fd;
@@ -476,12 +470,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (file->f_op != &kvm_gmem_fops)
 		goto err;
 
-	gmem = file->private_data;
+	inode = file_inode(file);
+	gmem = to_gmem(inode);
 	if (gmem->kvm != kvm)
 		goto err;
 
-	inode = file_inode(file);
-
 	if (offset < 0 || !PAGE_ALIGNED(offset))
 		return -EINVAL;
 
@@ -538,7 +531,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	if (!file)
 		return;
 
-	gmem = file->private_data;
+	gmem = to_gmem(file_inode(file));
 
 	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
@@ -563,7 +556,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	gmem = file->private_data;
+	gmem = to_gmem(file_inode(file));
 
 	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
 		r = -EIO;
-- 
2.25.1

