Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8F2B949C
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 15:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgKSO1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 09:27:54 -0500
Received: from foss.arm.com ([217.140.110.172]:58922 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgKSO1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 09:27:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7555D1042;
        Thu, 19 Nov 2020 06:27:53 -0800 (PST)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.110])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7E36E3F719;
        Thu, 19 Nov 2020 06:27:51 -0800 (PST)
From:   Jia He <justin.he@arm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia He <justin.he@arm.com>
Subject: [PATCH] vfio iommu type1: Bypass the vma permission check in vfio_pin_pages_remote()
Date:   Thu, 19 Nov 2020 22:27:37 +0800
Message-Id: <20201119142737.17574-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The permission of vfio iommu is different and incompatible with vma
permission. If the iotlb->perm is IOMMU_NONE (e.g. qemu side), qemu will
simply call unmap ioctl() instead of mapping. Hence vfio_dma_map() can't
map a dma region with NONE permission.

This corner case will be exposed in coming virtio_fs cache_size
commit [1]
 - mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
   memory_region_init_ram_ptr()
 - re-mmap the above area with read/write authority.
 - vfio_dma_map() will be invoked when vfio device is hotplug added.

qemu:
vfio_listener_region_add()
	vfio_dma_map(..., readonly=false)
		map.flags is set to VFIO_DMA_MAP_FLAG_READ|VFIO_..._WRITE
		ioctl(VFIO_IOMMU_MAP_DMA)

kernel:
vfio_dma_do_map()
	vfio_pin_map_dma()
		vfio_pin_pages_remote()
			vaddr_get_pfn()
			...
				check_vma_flags() failed! because
				vm_flags hasn't VM_WRITE && gup_flags
				has FOLL_WRITE

It will report error in qemu log when hotplug adding(vfio) a nvme disk
to qemu guest on an Ampere EMAG server:
"VFIO_MAP_DMA failed: Bad address"

[1] https://gitlab.com/virtio-fs/qemu/-/blob/virtio-fs-dev/hw/virtio/vhost-user-fs.c#L502

Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e827638995..33faa6b7dbd4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -453,7 +453,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
+	ret = pin_user_pages_remote(mm, vaddr, 1,
+				    flags | FOLL_LONGTERM | FOLL_FORCE,
 				    page, NULL, NULL);
 	if (ret == 1) {
 		*pfn = page_to_pfn(page[0]);
-- 
2.17.1

