Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FAD1EC285
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 21:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBTP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 15:15:59 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7494 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBTP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 15:15:59 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed6a5170000>; Tue, 02 Jun 2020 12:14:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 02 Jun 2020 12:15:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 02 Jun 2020 12:15:58 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Jun
 2020 19:15:48 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Jun 2020 19:15:42 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH 1/2] vfio iommu: Use shift operation for 64-bit integer division
Date:   Wed, 3 Jun 2020 00:12:36 +0530
Message-ID: <1591123357-18297-1-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591125272; bh=INqjvK9GUaUbxLFgl48meRA1JF55U/PN28DUQip5ODw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=nf74jj68gnc1+aFA7sAwgGRbx3LNaY4TeBPQ1iQ1fiuq9oVC/sks0FPkmP+OyAIDg
         mDBylHAUaDeLLJWJaT+T/w1mlGOAYUcUVbLyyZONgunbPm5OxHOQFN8hsbxq3VVZl8
         kejWb3rY4ofxOVluebAJ6mIUrmj3/Yw45riyYNfTztWXhaW+lY/zqfzuOiT480sMMR
         JLqCRdeTwg+SlA5lNU4T3HZdzjVyTqnSmWFysk3AZJvrxccXJL8G4dE7NmPckvKQ2h
         G9hfHMsBEYBNmbnC6llVX/h8/nyWDtBMIMPXE3KCCTpWa2O4U2KxiowhZGGAGlgo66
         IhQaq+EFYFKmw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes compilation error with ARCH=i386.

Error fixed by this commit:
ld: drivers/vfio/vfio_iommu_type1.o: in function `vfio_dma_populate_bitmap':
>> vfio_iommu_type1.c:(.text+0x666): undefined reference to `__udivdi3'

Fixes: d6a4c185660c (vfio iommu: Implementation of ioctl for dirty pages tracking)

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 97a29bc04d5d..9d9c8709a24c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -227,11 +227,12 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
 {
 	struct rb_node *p;
+	unsigned long pgshift = __ffs(pgsize);
 
 	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
 		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
 
-		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
+		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) >> pgshift, 1);
 	}
 }
 
-- 
2.7.0

