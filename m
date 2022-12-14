Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B49064D1BE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLNVZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLNVZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:25:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E602336D61
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:25:07 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BELOPwS002469;
        Wed, 14 Dec 2022 21:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=3CzRNp6vdT1oylf34LUlPHhPvKxx8kpbbdWNj88WJwQ=;
 b=oRGfadhRS+djSjp3zmsAz3lIr2cn1HhGG96/xAV6Fb+qOgsYbuXAsfIIMzJMh99kcJOr
 7LzGGrwsuDS1OSvgSvOG9Wg0msBm7gk1B7p+Z3qx5uKkOebmC6/z+BqoA1H3dSCxILDr
 3sxF5G5xGiPd8bP0F6rtHJ7CbELkjiUfx1shXjfKXJqDUYZM2CZkaOS4zk0AjsV251H0
 A7yhMPJvw59qS2/xl9Vb99rzARK8UGhlCAWfp/dZg9zl0kMQF5ZRR4esaB84Agd1e/DZ
 HqmuLQ29qJEl4u0f/b8YTiWislih9LIDF/tet3lvv+3uij6v9tqOIMcKHLM1nRxrheCs tA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewbe18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 21:25:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEKoCTU003938;
        Wed, 14 Dec 2022 21:25:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewpxnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 21:25:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BELOwGI024340;
        Wed, 14 Dec 2022 21:25:02 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyewpxhh-5;
        Wed, 14 Dec 2022 21:25:02 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V4 4/5] vfio/type1: revert "implement notify callback"
Date:   Wed, 14 Dec 2022 13:24:56 -0800
Message-Id: <1671053097-138498-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140175
X-Proofpoint-GUID: 4wBNGZO75A9ooo4vxgy29Mf6jNBoxAEh
X-Proofpoint-ORIG-GUID: 4wBNGZO75A9ooo4vxgy29Mf6jNBoxAEh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is dead code.  Revert it.
  commit 487ace134053 ("vfio/type1: implement notify callback")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ed78a6..41fbdf6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -75,7 +75,6 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			container_open;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -2576,7 +2575,6 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
-	iommu->container_open = true;
 	mutex_init(&iommu->lock);
 	mutex_init(&iommu->device_list_lock);
 	INIT_LIST_HEAD(&iommu->device_list);
@@ -3181,18 +3179,6 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return domain;
 }
 
-static void vfio_iommu_type1_notify(void *iommu_data,
-				    enum vfio_iommu_notify_type event)
-{
-	struct vfio_iommu *iommu = iommu_data;
-
-	if (event != VFIO_IOMMU_CONTAINER_CLOSE)
-		return;
-	mutex_lock(&iommu->lock);
-	iommu->container_open = false;
-	mutex_unlock(&iommu->lock);
-}
-
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -3207,7 +3193,6 @@ static void vfio_iommu_type1_notify(void *iommu_data,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
-	.notify			= vfio_iommu_type1_notify,
 };
 
 static int __init vfio_iommu_type1_init(void)
-- 
1.8.3.1

