Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859D81D3FB8
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 23:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgENVLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 17:11:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11318 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgENVLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 17:11:16 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebdb3a80000>; Thu, 14 May 2020 14:10:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 14 May 2020 14:11:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 14 May 2020 14:11:16 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 May
 2020 21:11:15 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 14 May 2020 21:11:09 +0000
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
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH Kernel v20 2/8] vfio iommu: Remove atomicity of ref_count of pinned pages
Date:   Fri, 15 May 2020 02:07:41 +0530
Message-ID: <1589488667-9683-3-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589490600; bh=uUgKJVCFdD4Zp7du3o0u/sQDLu1K2BjFd3xLP7hSugs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=bq6NXs/abB/KJs/+KBqao9cgajn+SQEpaHKhwfEPJA1BB/F32gDfS7AeDPv0A6aZA
         DaUWBysBR0ADVX0WFRKFeLmWzp1TlRMF+lfm1YwViYbo5+NjGtC/oweFLlCNNb1BQt
         +IFAS/01/4djyX5g+5hTL61eqYCFf4FaGE6yQo3gZ7+pif17ZlP73/fDicQZaBVYp9
         L88g+ec3cZ4l9kfD8jc1YHtDkNv05LeONRPf+4waDij/CnvxMEJE4AjYgIzz01GN3A
         OlVA9dFOoMP+FV4XR1VGI2FSPCOU03DhH9Ya8Sh26aeY6zYywkzqXiCMZ39zJfQNKT
         m6UB0dFmH2mIQ==
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
index a0c60f895b24..fa735047b04d 100644
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

