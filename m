Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E66E683323
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAaQ6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjAaQ6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:58:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375563C12
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:58:18 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEE3vK000924;
        Tue, 31 Jan 2023 16:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=9gXkoxbUTLi7u9XG7qSt5aY4ptTjF+ntOm7D2cLXhDc=;
 b=qWXzz23BT/Wtwq4yj/ojGinPkLa/7kJA/IvJPI9fo9PMUvgNdFh/TKr4kAYR/wKldlQ3
 EIa5G4ZOhoJhBRwfkYf2iE4EdTzRpnl91xMlqL2h8biPWISfnGMFBr496CJA/MPRLrWM
 T+3WehDargFfgg8K8NNKPsW6db0pgg0e9sOqiyhZlyj/+EzejGgpW1UZgSIJSC2jHsn5
 Id4R0JwpIdkHyXFtgzcnxfu29//DnB8ULd9EBhaLIqMg2XiZOh9Aa3EK5KLvJkoV5Qni
 lJAbsnOR6RDxKCe+2Wt3Mo0YUjdq6eVGoy5sTDDU+rnI14b16DHMMadZZh0WOtslRjoZ yA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvp165ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VGXJlZ025502;
        Tue, 31 Jan 2023 16:58:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct566vcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:13 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VGw98t002013;
        Tue, 31 Jan 2023 16:58:12 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3nct566v9x-7;
        Tue, 31 Jan 2023 16:58:12 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V8 6/7] vfio/type1: revert "implement notify callback"
Date:   Tue, 31 Jan 2023 08:58:08 -0800
Message-Id: <1675184289-267876-7-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310150
X-Proofpoint-GUID: bR5gvmd8RPi2T-kcp22tiOjsLMiDklr8
X-Proofpoint-ORIG-GUID: bR5gvmd8RPi2T-kcp22tiOjsLMiDklr8
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index be1dcad..c845ee5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -75,7 +75,6 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			container_open;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -2571,7 +2570,6 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
-	iommu->container_open = true;
 	mutex_init(&iommu->lock);
 	mutex_init(&iommu->device_list_lock);
 	INIT_LIST_HEAD(&iommu->device_list);
@@ -3175,18 +3173,6 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
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
@@ -3201,7 +3187,6 @@ static void vfio_iommu_type1_notify(void *iommu_data,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
-	.notify			= vfio_iommu_type1_notify,
 };
 
 static int __init vfio_iommu_type1_init(void)
-- 
1.8.3.1

