Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76724644E41
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLFV4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLFV4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8D643849
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:56:00 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LIYh9011108;
        Tue, 6 Dec 2022 21:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=UtZIjrz1R62kU1reCNvunS+SyOnhRA2GTObw189RCF8=;
 b=f5t7oxwjlDbtIUofFY3bKUlmuT3w/gF7Y/zD7ONgWlBftbHqx/2qyP9ju8ooRhuhwGvK
 49k1qRNJBusiroliP7ycXrM/YmENUqS6crBT1yZsBKejeg8rsX3PTtrYbR77OcKqgBxd
 k+Qv5O98Z7MpELCpAoyZe1M/JIvQycHf+OMd0kzPebgzNJ6X4Ke2Y2AKa8yKyoHwI7Vt
 eDnkJIRZSkdkQxkZfq683tONx8zNQ+fi762Q8SCt0m/8wRilBWun1IgoWBopqDxz/EZR
 pRoI6nKX1Xyh3UB5PetG0hu9D5AiBFYnKugOelN7Ypd6eEfN4FIEvkEPMz+bMikbV0PZ 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqrsk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LSbjX033085;
        Tue, 6 Dec 2022 21:55:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2maw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:57 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0t038701;
        Tue, 6 Dec 2022 21:55:57 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-7;
        Tue, 06 Dec 2022 21:55:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 6/8] vfio/type1: update vaddr
Date:   Tue,  6 Dec 2022 13:55:51 -0800
Message-Id: <1670363753-249738-7-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060184
X-Proofpoint-GUID: xh-Mtnn4Fb7ehw2ctYZfHoYqvmXB5al1
X-Proofpoint-ORIG-GUID: xh-Mtnn4Fb7ehw2ctYZfHoYqvmXB5al1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-define VFIO_DMA_MAP_FLAG_VADDR as follows:

  If flags & VFIO_DMA_MAP_FLAG_VADDR, prepare to change the base virtual
  address for iova to vaddr.  The updated vaddr must address the same
  memory object as originally mapped, with the same access permissions,
  and must be shared.  The change takes effect after the next call to
  VFIO_CHANGE_DMA_OWNER.

VFIO_CHANGE_DMA_OWNER is defined in a subsequent patch.
See vfio.h for more details.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 include/uapi/linux/vfio.h       | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3bd89d5..fbea2b5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -90,6 +90,7 @@ struct vfio_dma {
 	struct rb_node		node;
 	dma_addr_t		iova;		/* Device address */
 	unsigned long		vaddr;		/* Process virtual addr */
+	unsigned long		new_vaddr;
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
@@ -1556,7 +1557,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		} else if (dma->iova != iova || dma->size != size) {
 			ret = -EINVAL;
 		} else {
-			dma->vaddr = vaddr;
+			dma->new_vaddr = vaddr;
 		}
 		goto out_unlock;
 	} else if (dma) {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5c5cc7e..8b7c1ed 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1214,6 +1214,13 @@ struct vfio_iommu_type1_info_dma_avail {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, prepare to change the base virtual
+ * address for iova to vaddr.  The updated vaddr must address the same memory
+ * object as originally mapped, with the same access permissions, and must be
+ * shared.  The iova and size must match those in the original MAP_DMA call.
+ * Protection is not changed, and the READ & WRITE flags must be 0.  The change
+ * takes effect after the next call to VFIO_CHANGE_DMA_OWNER.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
-- 
1.8.3.1

