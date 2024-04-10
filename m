Return-Path: <kvm+bounces-14138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6B789FC36
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D48D128E3D6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 15:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0BA17798B;
	Wed, 10 Apr 2024 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MqeNvWmh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7706E177999
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712764565; cv=none; b=pbmTDEK57FRncpzVrsLGW5GgSrsM5Px2D6cxUoXkRXaDg1Rnxfk0wnGxoVoupzJ5DX4DHo9CP6Q5TcnQOrS20ai2sDSxBRACTzwyRx+TroLIFIIIU8YfbgNYQcFcTaqvs7xWGwN5p8OuIbTk6Z8B1xjyR3bXMrSHn9n7WY73AYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712764565; c=relaxed/simple;
	bh=iEy3Y/wQo4siK0uRbJbPEGBhTif0nXoV2Vtkal8J/KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdfv8caJmX1ac6ZMuQoQt9WMpR5afq/6/hBDy33w6z1r/EmRCqt+k5cdU9GNobSB1qsmfZHhhHvw1mQo7cnehN8Fp9mwmb1b8qxY/RLXD34kEZxpg7dnhkDIDByR1AzHFlJF5CzNrFoQKFAXYxL5zmyiBv2fWtTCbGbU7dGEVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MqeNvWmh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712764562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdXXvnzyQGyp+LpfjwfWgygVrfKZBZQWfHJtEeA5yjk=;
	b=MqeNvWmhFXbWYAIa8X2TOFDfg7BpqjsDg/2D2953jiYUCxmm3pvYQpR6JYIgJVodKbu68s
	R3BKyy/CAHECOzU+PErrQv0LRMC+HkrN4dssl+Yl9RoC/Zt5k2zKHQuaHL/OyXIASauOS8
	fkWyT+o98RRn4tlFA0lVnxROXhYEA2I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-QFt8f6HZNKShSzTznoalRA-1; Wed, 10 Apr 2024 11:55:57 -0400
X-MC-Unique: QFt8f6HZNKShSzTznoalRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38C151805BE0;
	Wed, 10 Apr 2024 15:55:56 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.162])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8CE72DD51;
	Wed, 10 Apr 2024 15:55:52 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yonghua Huang <yonghua.huang@intel.com>,
	Fei Li <fei1.li@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v1 1/3] drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()
Date: Wed, 10 Apr 2024 17:55:25 +0200
Message-ID: <20240410155527.474777-2-david@redhat.com>
In-Reply-To: <20240410155527.474777-1-david@redhat.com>
References: <20240410155527.474777-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

We currently miss to handle various cases, resulting in a dangerous
follow_pte() (previously follow_pfn()) usage.

(1) We're not checking PTE write permissions.

Maybe we should simply always require pte_write() like we do for
pin_user_pages_fast(FOLL_WRITE)? Hard to tell, so let's check for
ACRN_MEM_ACCESS_WRITE for now.

(2) We're not rejecting refcounted pages.

As we are not using MMU notifiers, messing with refcounted pages is
dangerous and can result in use-after-free. Let's make sure to reject them.

(3) We are only looking at the first PTE of a bigger range.

We only lookup a single PTE, but memmap->len may span a larger area.
Let's loop over all involved PTEs and make sure the PFN range is
actually contiguous. Reject everything else: it couldn't have worked
either way, and rather made use access PFNs we shouldn't be accessing.

Fixes: 8a6e85f75a83 ("virt: acrn: obtain pa from VMA with PFNMAP flag")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virt/acrn/mm.c | 63 +++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index b30077baf352..2d98e1e185c4 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -156,23 +156,29 @@ int acrn_vm_memseg_unmap(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 {
 	struct vm_memory_region_batch *regions_info;
-	int nr_pages, i = 0, order, nr_regions = 0;
+	int nr_pages, i, order, nr_regions = 0;
 	struct vm_memory_mapping *region_mapping;
 	struct vm_memory_region_op *vm_region;
 	struct page **pages = NULL, *page;
 	void *remap_vaddr;
 	int ret, pinned;
 	u64 user_vm_pa;
-	unsigned long pfn;
 	struct vm_area_struct *vma;
 
 	if (!vm || !memmap)
 		return -EINVAL;
 
+	/* Get the page number of the map region */
+	nr_pages = memmap->len >> PAGE_SHIFT;
+	if (!nr_pages)
+		return -EINVAL;
+
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		unsigned long start_pfn, cur_pfn;
 		spinlock_t *ptl;
+		bool writable;
 		pte_t *ptep;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
@@ -180,25 +186,53 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			return -EINVAL;
 		}
 
-		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
-		if (ret < 0) {
-			mmap_read_unlock(current->mm);
+		for (i = 0; i < nr_pages; i++) {
+			ret = follow_pte(vma->vm_mm,
+					 memmap->vma_base + i * PAGE_SIZE,
+					 &ptep, &ptl);
+			if (ret)
+				break;
+
+			cur_pfn = pte_pfn(ptep_get(ptep));
+			if (i == 0)
+				start_pfn = cur_pfn;
+			writable = !!pte_write(ptep_get(ptep));
+			pte_unmap_unlock(ptep, ptl);
+
+			/* Disallow write access if the PTE is not writable. */
+			if (!writable &&
+			    (memmap->attr & ACRN_MEM_ACCESS_WRITE)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow refcounted pages. */
+			if (pfn_valid(cur_pfn) &&
+			    !PageReserved(pfn_to_page(cur_pfn))) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow non-contiguous ranges. */
+			if (cur_pfn != start_pfn + i) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+		mmap_read_unlock(current->mm);
+
+		if (ret) {
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
-		pfn = pte_pfn(ptep_get(ptep));
-		pte_unmap_unlock(ptep, ptl);
-		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
-			 PFN_PHYS(pfn), memmap->len,
+			 PFN_PHYS(start_pfn), memmap->len,
 			 ACRN_MEM_TYPE_WB, memmap->attr);
 	}
 	mmap_read_unlock(current->mm);
 
-	/* Get the page number of the map region */
-	nr_pages = memmap->len >> PAGE_SHIFT;
 	pages = vzalloc(array_size(nr_pages, sizeof(*pages)));
 	if (!pages)
 		return -ENOMEM;
@@ -242,12 +276,11 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	mutex_unlock(&vm->regions_mapping_lock);
 
 	/* Calculate count of vm_memory_region_op */
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		page = pages[i];
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		order = compound_order(page);
 		nr_regions++;
-		i += 1 << order;
 	}
 
 	/* Prepare the vm_memory_region_batch */
@@ -264,8 +297,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	regions_info->vmid = vm->vmid;
 	regions_info->regions_gpa = virt_to_phys(vm_region);
 	user_vm_pa = memmap->user_vm_pa;
-	i = 0;
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		u32 region_size;
 
 		page = pages[i];
@@ -281,7 +313,6 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 
 		vm_region++;
 		user_vm_pa += region_size;
-		i += 1 << order;
 	}
 
 	/* Inform the ACRN Hypervisor to set up EPT mappings */
-- 
2.44.0


