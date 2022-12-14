Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B464D00C
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiLNTXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbiLNTXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:23:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6635ADFFF
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:23:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHDt71006732;
        Wed, 14 Dec 2022 19:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=+y6Ylg39vBXwUrwPtWGaBBzYw680t9s886JDqLVR3n4=;
 b=nwOpd3BuiI9Sy3yZBJjqe7ofgT7ScUX184XBZlFvBB5cxFSPiSKVGOk0id6QqVxl2WRO
 8VTx++hBVfT+P39bRVmZTGq1REb5RAhrZ91BJbNv9mr+yZJKIpdljTx6EVNRmbKBQVLb
 A6sLgSQ/KdFYZ28UletuffORbzUNzfNg2LsSm64f7UcNQnAqZYcGDtRCt9emWSG+yCwa
 K/P9zxcMm/1kaHJbRX/Kjdvc+k8F5kwWYgo5tYtvLIJcAczG4kVRBpwp4HdKJGtaiW+O
 w9YX7Weoz5b8gspPpNCdEJoPtHtrNu+ppqSuj01sR5280oUN34emCsVY0r/5vxJSnBUm zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewu3w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:23:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEIu4Xq007085;
        Wed, 14 Dec 2022 19:23:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqa86u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:23:02 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEJMv3H040903;
        Wed, 14 Dec 2022 19:23:01 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyeqa7y1-6;
        Wed, 14 Dec 2022 19:23:01 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 5/5] vfio: revert "iommu driver notify callback"
Date:   Wed, 14 Dec 2022 11:22:51 -0800
Message-Id: <1671045771-59788-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_10,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140157
X-Proofpoint-GUID: H4aUZes4d07AXUEIlKaRmxG4TBBk0Jlp
X-Proofpoint-ORIG-GUID: H4aUZes4d07AXUEIlKaRmxG4TBBk0Jlp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert this dead code:
  commit ec5e32940cc9 ("vfio: iommu driver notify callback")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/container.c | 5 -----
 drivers/vfio/vfio.h      | 7 -------
 2 files changed, 12 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d74164a..5bfd10d 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -382,11 +382,6 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 static int vfio_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
-
-	if (driver && driver->ops->notify)
-		driver->ops->notify(container->iommu_data,
-				    VFIO_IOMMU_CONTAINER_CLOSE);
 
 	filep->private_data = NULL;
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index bcad54b..8a439c6 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -62,11 +62,6 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 };
 
-/* events for the backend driver notify callback */
-enum vfio_iommu_notify_type {
-	VFIO_IOMMU_CONTAINER_CLOSE = 0,
-};
-
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
@@ -97,8 +92,6 @@ struct vfio_iommu_driver_ops {
 				  void *data, size_t count, bool write);
 	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
 						   struct iommu_group *group);
-	void		(*notify)(void *iommu_data,
-				  enum vfio_iommu_notify_type event);
 };
 
 struct vfio_iommu_driver {
-- 
1.8.3.1

