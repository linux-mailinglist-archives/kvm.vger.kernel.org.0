Return-Path: <kvm+bounces-44049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DEBA99F6B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 440A81890863
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3901AB6D4;
	Thu, 24 Apr 2025 03:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KV2p5Dlc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E481ACEDF;
	Thu, 24 Apr 2025 03:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464253; cv=none; b=vGFQYA3tzNXFqxn8q8VF0HlWFw1sdpIhOZLADDItMlUTs0o+7SNEuYdJWHU/4bLh8HFbOkC3ZgJFpYyDn5XsSDqFDfRYP3c6xMwnMxYuG2YX22qKNQScJEP3Oh/+tHmKrOsYguapvJAe/DY0tMiQ9gEPp06ytlg9nDLsBU7G9sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464253; c=relaxed/simple;
	bh=g7/WI0vmaEJBgXQIFX7Fnow6UGFeVwvUw5xdNqXZ2XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7JBak4IpRSjb20tPzwgjyxvbR7nkPekaY2jqAAkwrMn68Ux/Pdp9s8c5X2dMamiOpS2Wh0u0flbgTilD0nc5Edm14+4x757B6Jue6KA4ENtkrBnQUIrl1K477Wo9L4lXGkJBhKHx3VBDQX7++mNaw/Ir8Hc1eioi75725tWXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KV2p5Dlc; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464252; x=1777000252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g7/WI0vmaEJBgXQIFX7Fnow6UGFeVwvUw5xdNqXZ2XM=;
  b=KV2p5DlcNiummXT1ToLRsKAZqINiHNbUaT8iTSeXKtJ62nyDpwlfg5tr
   bsx6NPlYcY1ugQZNraPCVppAsII2Vzxi8qFMcb1OT5q+npfX1/mrLy596
   JHQ38AdKSjdahGPxHjXH3J+lLs3Vmu9FavUea++J8r6iqXMTJSr+fRdC8
   STMH7wpPefiBvr3HCfRI0LbX1JIN5XVXOP2fEWHIzUfSrpaytSyH8Z3ay
   CK3usgJVj/7dbQ/gWV7sZ+oy5zV6/YXSvtcsPhHRBumN5DmGuBgRcoXzb
   Mz8fl17EKrGBMj+DhRGOAlMtC1aeIm8LouD1iVjsQ3mnu/LKWPQ0lVZfm
   Q==;
X-CSE-ConnectionGUID: kaEk1GwTQQOrP5g6tHVc4Q==
X-CSE-MsgGUID: cDmJMrTuQ2SNbz10fTUGkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47256024"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47256024"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:51 -0700
X-CSE-ConnectionGUID: AbOO64miTeqw+v9Y4gGaqQ==
X-CSE-MsgGUID: YlOl5odgTwKGYbHtDbyEYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132222921"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:45 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for punch hole of private memory
Date: Thu, 24 Apr 2025 11:08:58 +0800
Message-ID: <20250424030858.519-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Splitting of huge leafs in the mirror page table for kvm_gmem_punch_hole().

Enhance kvm_gmem_invalidate_begin() to invoke kvm_split_boundary_leafs()
for splitting boundary huge leafs before caling kvm_unmap_gfn_range() to do
the real zapping. As kvm_split_boundary_leafs() may fail due to out of
memory, propagate the error to further fail the kvm_gmem_punch_hole().

Splitting huge boudary leafs in the mirror page table is not required for
kvm_gmem_release() as the entire page table is to be zapped; it's also not
required for kvm_gmem_error_folio() as a SPTE must not map more than one
physical folio.

Note: as the kvm_gmem_punch_hole() may request to zap several GFN ranges,
if an out-of-memory error occurs during the splitting of a GFN range, some
previous GFN ranges may have been successfully split and zapped.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/guest_memfd.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4bb140e7f30d..008061734ac5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -292,13 +292,14 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, int
 	return folio;
 }
 
-static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
-				      pgoff_t end)
+static int kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+				     pgoff_t end, bool need_split)
 {
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
+	int ret = 0;
 
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff = slot->gmem.pgoff;
@@ -319,14 +320,23 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			kvm_mmu_invalidate_begin(kvm);
 		}
 
+		if (need_split) {
+			ret = kvm_split_boundary_leafs(kvm, &gfn_range);
+			if (ret < 0)
+				goto out;
+
+			flush |= ret;
+		}
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
 	}
 
+out:
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
+	return 0;
 }
 
 static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
@@ -347,6 +357,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	loff_t size = i_size_read(inode);
 	pgoff_t start, end;
 	struct kvm_gmem *gmem;
+	int ret = 0;
 
 	if (offset > size)
 		return 0;
@@ -361,18 +372,22 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+	list_for_each_entry(gmem, gmem_list, entry) {
+		ret = kvm_gmem_invalidate_begin(gmem, start, end, true);
+		if (ret < 0)
+			goto out;
+	}
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 	kvm_gmem_mark_range_unprepared(inode, start, end - start);
 
+out:
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
-	return 0;
+	return ret;
 }
 
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
@@ -440,7 +455,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(gmem, 0, -1ul, false);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
@@ -524,8 +539,9 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
+	/* The size of the SEPT will not exceed the size of the folio */
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+		kvm_gmem_invalidate_begin(gmem, start, end, false);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the
-- 
2.43.2


