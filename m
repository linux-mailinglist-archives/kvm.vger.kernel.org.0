Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A7F308B74
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhA2RXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50748 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhA2RXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH8mPn023540;
        Fri, 29 Jan 2021 17:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ufVPIuj4bDOGlkEAzZmJVUnC4smKNPNO+KtFUv7ulb4=;
 b=pg5qodLe+G7xWXEFYO9pxEZTw4UH0ZuoeHIL4mPQx6Uu0qx70fv98JdhRJoaJFwfBctc
 zTO4ZJyhknPtXPR7zIboRdKMsibYwjox+x8l/dwtXGk9fOZrKMf8uE0LdGitjbW7gPcx
 +Cve8Z7qSAJLRe2DSz/lZ86Udk/53fFMAS/ZREH4AMOI5llcDmT4VK/nmwSqoQGjen4N
 oFsCLpHmIqLl7hNFirSkcjUD7WhFcz068NUQ05sY9o1NyZOcD1mHZBMZERi+w0HcrAWq
 R6yP+RQXOpiiBotJKq6vxw5yhmlShco1RcLIYGIognwUN78bwW/cg93/jC+RTLfo1Rva qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cmf88qrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH4ihI040970;
        Fri, 29 Jan 2021 17:22:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 36ceug5k8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10THML7m023176;
        Fri, 29 Jan 2021 17:22:21 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:20 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 5/9] vfio/type1: massage unmap iteration
Date:   Fri, 29 Jan 2021 08:54:08 -0800
Message-Id: <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the iteration in vfio_dma_do_unmap so it does not depend on deletion
of each dma entry.  Add a variant of vfio_find_dma that returns the entry
with the lowest iova in the search range to initialize the iteration.  No
externally visible change, but this behavior is needed in the subsequent
update-vaddr patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 407f0f7..5823607 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -173,6 +173,31 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 	return NULL;
 }
 
+static struct rb_node *vfio_find_dma_first(struct vfio_iommu *iommu,
+					    dma_addr_t start, size_t size)
+{
+	struct rb_node *res = NULL;
+	struct rb_node *node = iommu->dma_list.rb_node;
+	struct vfio_dma *dma_res = NULL;
+
+	while (node) {
+		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
+
+		if (start < dma->iova + dma->size) {
+			res = node;
+			dma_res = dma;
+			if (start >= dma->iova)
+				break;
+			node = node->rb_left;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	if (res && size && dma_res->iova >= start + size)
+		res = NULL;
+	return res;
+}
+
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
@@ -1078,6 +1103,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	dma_addr_t iova = unmap->iova;
 	unsigned long size = unmap->size;
 	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
+	struct rb_node *n;
 
 	mutex_lock(&iommu->lock);
 
@@ -1148,7 +1174,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 	ret = 0;
-	while ((dma = vfio_find_dma(iommu, iova, size))) {
+	n = vfio_find_dma_first(iommu, iova, size);
+
+	while (n) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		if (dma->iova >= iova + size)
+			break;
+
 		if (!iommu->v2 && iova > dma->iova)
 			break;
 		/*
@@ -1193,6 +1225,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		}
 
 		unmapped += dma->size;
+		n = rb_next(n);
 		vfio_remove_dma(iommu, dma);
 	}
 
-- 
1.8.3.1

