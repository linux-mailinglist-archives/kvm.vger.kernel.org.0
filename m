Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A154C64E392
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiLOV5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiLOV5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA72CE30
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:14 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3gkO028002;
        Thu, 15 Dec 2022 21:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=+y6Ylg39vBXwUrwPtWGaBBzYw680t9s886JDqLVR3n4=;
 b=pL4Q0dX9dCr++qCSqgOigHbuNnP2x+GKxh3rRWW8RTEIJuqeC7h7WZsoTwBUcjFPbXnF
 jRPTJ7Jn31hxxU0sBHOmx06wNdqASPxAKFo4R4dHSqp/SICY5UceWze5R1goDotQZr9s
 mNFKXglKQr4/h5dcyr4/24lZmk4kF1IpMljo/w98XL+pv1bYFQQQUDFwwANa/6zFniNm
 jX5G8pypbcfOXNY+g7C906v1C07I/1eZUvIWy2nf9eOCCIeU5A5BiMjV0VyZRVW2A16h
 LwFzhRchR+dXQmECk4XDo6THEuo4bejHAvYyw84sb8cu+1IsrlYjDi6q1Ev6IsWOOYym Ig== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu6cc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKfBnn033038;
        Thu, 15 Dec 2022 21:57:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XU007209;
        Thu, 15 Dec 2022 21:57:09 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-8;
        Thu, 15 Dec 2022 21:57:08 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 7/7] vfio: revert "iommu driver notify callback"
Date:   Thu, 15 Dec 2022 13:57:04 -0800
Message-Id: <1671141424-81853-8-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: tsu5KTmYsUfE90o3wZjk5RFS0Z-DJ5dQ
X-Proofpoint-GUID: tsu5KTmYsUfE90o3wZjk5RFS0Z-DJ5dQ
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

