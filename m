Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7F62EAF97
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhAEQEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40584 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbhAEQEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Fsji3094294;
        Tue, 5 Jan 2021 16:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wlo2cVcl+/Th1nEAYhe73iPgHz0zOc5IAxfyoIhiGCE=;
 b=sdbrlKnvw3bc6Dyoey9JObZRK5QvDk9F1OehWrGc+Ytnv9+AZ9JqXbKeG5ai7nfwAWmW
 4HlImScCQPK8iKtsduCzrh2S8EVdHr5QfLtCO+0BFqLqRZH46V2XHCACXkdeKLzqI208
 dCdttiuzJpZZDwz8Dd0LLXOPyaNB0P5YvkdocOY1QKt3nor5se13gHcDIv62mvVe5U5f
 xyzTedyoXTMJUfhjjIdsOcGNI8DjBM1D0WEs4exJZcU0H+xowB0Yuv5Zzrm9J/Z5CfYm
 vFttUF7NmwBBvOtWn7MjzNHWvF2j/7GQUMHY2paF1/AXD3XgxOFpwP1VlmUWJOUdQIgm nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35tebasj32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FtL0a175884;
        Tue, 5 Jan 2021 16:03:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35vct61n8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105G3wQc015343;
        Tue, 5 Jan 2021 16:03:58 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:58 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 1/5] vfio: maintain dma_list order
Date:   Tue,  5 Jan 2021 07:36:49 -0800
Message-Id: <1609861013-129801-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep entries properly sorted in the dma_list rb_tree so that iterating
over multiple entries across a range with gaps works, without requiring
one to delete each visited entry as in vfio_dma_do_unmap.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5fbf0c1..02228d0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -157,20 +157,24 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 				      dma_addr_t start, size_t size)
 {
+	struct vfio_dma *res = 0;
 	struct rb_node *node = iommu->dma_list.rb_node;
 
 	while (node) {
 		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
 
-		if (start + size <= dma->iova)
+		if (start < dma->iova + dma->size) {
+			res = dma;
+			if (start >= dma->iova)
+				break;
 			node = node->rb_left;
-		else if (start >= dma->iova + dma->size)
+		} else {
 			node = node->rb_right;
-		else
-			return dma;
+		}
 	}
-
-	return NULL;
+	if (res && size && res->iova >= start + size)
+		res = 0;
+	return res;
 }
 
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
@@ -182,7 +186,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 		parent = *link;
 		dma = rb_entry(parent, struct vfio_dma, node);
 
-		if (new->iova + new->size <= dma->iova)
+		if (new->iova < dma->iova)
 			link = &(*link)->rb_left;
 		else
 			link = &(*link)->rb_right;
-- 
1.8.3.1

