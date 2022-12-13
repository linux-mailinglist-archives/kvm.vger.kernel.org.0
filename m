Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D964BD6D
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiLMTlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiLMTlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:41:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A75021266
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:41:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJJRah008194;
        Tue, 13 Dec 2022 19:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=+y6Ylg39vBXwUrwPtWGaBBzYw680t9s886JDqLVR3n4=;
 b=iMQlESF0Z+dJsrKVO+Ef+znjg77zZXeUH4MWTBeKf1r1F87/lpyicRMXG5BNGSrJxiD7
 5WqJQTnIXCSu5Y0/v2ZG1X4CzBEAEMRtqA3zCTcu757RPxsyHXdZE7enaTkLsN25e6ks
 b/sPW/VkpknQFB9Onov/FOdBKzlmDQ5I4M/VYxL1enGQMpTCBq6fbHPb8vgtzIExl7KA
 vaiJcPD269XjhshVwVe8xAViRc3tsYFqCjAOq39gDXfCcNKlVOAA75xuC7ZE5cu7yjmq
 mH6uChxWbkCZInmekdN80YNSrF00aRhdDtjJh2SFTjHtDX28EMwaDjVVikIfa2U+S2Aj Bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewr1yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJJKQC031395;
        Tue, 13 Dec 2022 19:41:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesrs2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:04 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDJf0Gr028128;
        Tue, 13 Dec 2022 19:41:04 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyesrry8-6;
        Tue, 13 Dec 2022 19:41:03 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 5/5] vfio: revert "iommu driver notify callback"
Date:   Tue, 13 Dec 2022 11:40:59 -0800
Message-Id: <1670960459-415264-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130171
X-Proofpoint-GUID: NnaoAAVJgrdQ3lnPyMcxvKiHBFVT3HsL
X-Proofpoint-ORIG-GUID: NnaoAAVJgrdQ3lnPyMcxvKiHBFVT3HsL
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

