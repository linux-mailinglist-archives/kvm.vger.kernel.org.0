Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8764E387
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiLOVyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLOVyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:54:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170BA4D5C1
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:54:04 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3klh010961;
        Thu, 15 Dec 2022 21:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=3CzRNp6vdT1oylf34LUlPHhPvKxx8kpbbdWNj88WJwQ=;
 b=MzQ7hJGqewdD3FzgoLo4z9uu+4NZuS5OC01+nT4lBoT+ozQVw3J2ebEpAWo2j1hi1e7B
 ePcgimO6yUpOfgChoWT2GxcLcUTw1Nhpoh3AziitE3OBEIPIgjb8KzsJ45SYxRop5RiV
 OkuuZ7hwA2Wt1vezjTA8222nqcmQBIbz6wNtN49i9XrYBxBzxATxnr4HJhZnUoD2h8oX
 D15+D7J1pfufywxYR2X7D1G+9DIzNZ+mFe8DTkED8wetZlAwxMAuFkYaHUeFH2BnAE4y
 20xsEpY8AMOMXnd+5dUlvLSQax1qjwWIY5zU/UBw6cWE6nexHe1oFqektXakh9AzZTM3 eg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewx8r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:53:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKuQMt010026;
        Thu, 15 Dec 2022 21:53:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyepnw35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:53:55 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLrrDw005013;
        Thu, 15 Dec 2022 21:53:55 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyepnw0y-5;
        Thu, 15 Dec 2022 21:53:55 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V4 4/5] vfio/type1: revert "implement notify callback"
Date:   Thu, 15 Dec 2022 13:53:51 -0800
Message-Id: <1671141232-81814-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
References: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-GUID: mvu7TIWpQjSHGPSVei18Y9oV3DAl-Xr7
X-Proofpoint-ORIG-GUID: mvu7TIWpQjSHGPSVei18Y9oV3DAl-Xr7
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

