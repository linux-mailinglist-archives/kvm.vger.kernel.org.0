Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2040F3DCE90
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 03:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhHBBhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Aug 2021 21:37:36 -0400
Received: from mx21.baidu.com ([220.181.3.85]:38644 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhHBBhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Aug 2021 21:37:35 -0400
Received: from BJHW-Mail-Ex09.internal.baidu.com (unknown [10.127.64.32])
        by Forcepoint Email with ESMTPS id 199164070AFAC34E39FC;
        Mon,  2 Aug 2021 09:37:24 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 2 Aug 2021 09:37:23 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 2 Aug 2021 09:37:23 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Cai Huoqing" <caihuoqing@baidu.com>
Subject: [PATCH] vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro
Date:   Mon, 2 Aug 2021 09:37:17 +0800
Message-ID: <20210802013717.851-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex15.internal.baidu.com (172.31.51.55) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex09_2021-08-02 09:37:24:152
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

it's a nice refactor to make use of
PFN_PHYS/PFN_UP/PFN_DOWN helper macro

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vhost/vdpa.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 210ab35a7ebf..1f6dd6ad0f8b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -507,15 +507,15 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
-		pinned = map->size >> PAGE_SHIFT;
-		for (pfn = map->addr >> PAGE_SHIFT;
+		pinned = PFN_DOWN(map->size);
+		for (pfn = PFN_DOWN(map->addr);
 		     pinned > 0; pfn++, pinned--) {
 			page = pfn_to_page(pfn);
 			if (map->perm & VHOST_ACCESS_WO)
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
+		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -577,7 +577,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 	if (r)
 		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
 	else
-		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
+		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
 
 	return r;
 }
@@ -630,7 +630,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	if (msg->perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	npages = PFN_UP(msg->size + (iova & ~PAGE_MASK));
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
@@ -638,7 +638,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	mmap_read_lock(dev->mm);
 
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	lock_limit = PFN_DOWN(rlimit(RLIMIT_MEMLOCK));
 	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
 		ret = -ENOMEM;
 		goto unlock;
@@ -672,9 +672,9 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 			if (last_pfn && (this_pfn != last_pfn + 1)) {
 				/* Pin a contiguous chunk of memory */
-				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
+				csize = PFN_PHYS(last_pfn - map_pfn + 1);
 				ret = vhost_vdpa_map(v, iova, csize,
-						     map_pfn << PAGE_SHIFT,
+						     PFN_PHYS(map_pfn),
 						     msg->perm);
 				if (ret) {
 					/*
@@ -698,13 +698,13 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			last_pfn = this_pfn;
 		}
 
-		cur_base += pinned << PAGE_SHIFT;
+		cur_base += PFN_PHYS(pinned);
 		npages -= pinned;
 	}
 
 	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+	ret = vhost_vdpa_map(v, iova, PFN_PHYS(last_pfn - map_pfn + 1),
+			     PFN_PHYS(map_pfn), msg->perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -944,7 +944,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
-			    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
+			    PFN_DOWN(notify.addr), PAGE_SIZE,
 			    vma->vm_page_prot))
 		return VM_FAULT_SIGBUS;
 
-- 
2.25.1

