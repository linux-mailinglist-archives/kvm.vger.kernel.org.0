Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8820735D2AE
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241243AbhDLVte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 17:49:34 -0400
Received: from pmg.in-ulm.de ([217.10.8.27]:43798 "EHLO pmg.in-ulm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240316AbhDLVte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 17:49:34 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2021 17:49:34 EDT
Received: from pmg.in-ulm.de (localhost.localdomain [127.0.0.1])
        by pmg.in-ulm.de (Proxmox) with ESMTP id CFE1720C62
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 23:41:24 +0200 (CEST)
Received: from mail.in-ulm.de (unknown [217.10.8.10])
        by pmg.in-ulm.de (Proxmox) with SMTP
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 23:41:24 +0200 (CEST)
Received: (qmail 343850 invoked by uid 10524); 12 Apr 2021 21:41:24 -0000
Date:   Mon, 12 Apr 2021 23:41:24 +0200
From:   "Christian A. Ehrhardt" <lk@c--e.de>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio/pci: Add missing range check in vfio_pci_mmap
Message-ID: <20210412214124.GA241759@lisa.in-ulm.de>
References: <20210410230013.GC416417@lisa.in-ulm.de>
 <20210412140238.184e141f@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412140238.184e141f@omen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


When mmaping an extra device region verify that the region index
derived from the mmap offset is valid.

Fixes: a15b1883fee1 ("vfio_pci: Allow mapping extra regions")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
---
 drivers/vfio/pci/vfio_pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578..5023e23db3bc 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1656,6 +1656,8 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
+	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return -EINVAL;
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
 	if ((vma->vm_flags & VM_SHARED) == 0)
@@ -1664,7 +1666,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
 		struct vfio_pci_region *region = vdev->region + regnum;
 
-		if (region && region->ops && region->ops->mmap &&
+		if (region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
 			return region->ops->mmap(vdev, region, vma);
 		return -EINVAL;
-- 
2.25.1


