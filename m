Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5019B198237
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgC3RY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:24:26 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1355 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgC3RY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 13:24:26 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e822aea0000>; Mon, 30 Mar 2020 10:22:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 30 Mar 2020 10:24:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 30 Mar 2020 10:24:25 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Mar
 2020 17:24:25 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 30 Mar 2020 17:24:18 +0000
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
Subject: [PATCH v17 Kernel 2/7] vfio iommu: Remove atomicity of ref_count of pinned pages
Date:   Mon, 30 Mar 2020 22:20:39 +0530
Message-ID: <1585587044-2408-3-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585588970; bh=gmeXbRuItwuzRSa4wja8NeNbAoIY5SLtg52zFZ81snk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=PdT3FdBDDzumHBMmfU1POMHCTDTmnm5Vv+fllHthZV4cJl5z7oouqOHw2kEFMIyuQ
         MUsWM2KPA6gmbK2NNcyc5EkxgqybYIEoJSQJ77Sxbo36+OgBmb+y5+LmxWfyuEe4R4
         Cz7pqAaglF43rFbJ+STzkAQEjFqa+UU2EN7Ut3fIjQkzz740OifDRyC10YKNPSzhlF
         xpJPeY481uPF+5esHphuPCqo11zidwjsAtIcFtbGe62uZdVn2PQ8JIuPNpfiyHw2RS
         8ozBbgiZhkANXsINsA8dKDa9CDAZr6hJRhpuuPNg6ubFzTz1OjxjbLPkvjihL9IDj0
         i9lo0RT1/HWmw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pfn.ref_count is always updated while holding iommu->lock, using
atomic variable is overkill.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9fdfae1cb17a..70aeab921d0f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -112,7 +112,7 @@ struct vfio_pfn {
 	struct rb_node		node;
 	dma_addr_t		iova;		/* Device address */
 	unsigned long		pfn;		/* Host pfn */
-	atomic_t		ref_count;
+	unsigned int		ref_count;
 };
 
 struct vfio_regions {
@@ -233,7 +233,7 @@ static int vfio_add_to_pfn_list(struct vfio_dma *dma, dma_addr_t iova,
 
 	vpfn->iova = iova;
 	vpfn->pfn = pfn;
-	atomic_set(&vpfn->ref_count, 1);
+	vpfn->ref_count = 1;
 	vfio_link_pfn(dma, vpfn);
 	return 0;
 }
@@ -251,7 +251,7 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
 	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
 
 	if (vpfn)
-		atomic_inc(&vpfn->ref_count);
+		vpfn->ref_count++;
 	return vpfn;
 }
 
@@ -259,7 +259,8 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 {
 	int ret = 0;
 
-	if (atomic_dec_and_test(&vpfn->ref_count)) {
+	vpfn->ref_count--;
+	if (!vpfn->ref_count) {
 		ret = put_pfn(vpfn->pfn, dma->prot);
 		vfio_remove_from_pfn_list(dma, vpfn);
 	}
-- 
2.7.0

