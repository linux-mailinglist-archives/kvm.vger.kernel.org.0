Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81282644E40
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiLFV4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiLFV4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37AA490B1
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:55:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LIdRR002872;
        Tue, 6 Dec 2022 21:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=4wkbKABEq3eFNvd9EDpU2CmDwyPHQkKzRGpQBm6q6lg=;
 b=PuHDfqExwS5j6ByBT2JzoKH75Oq3lhsp+ucg1ScgOS2jFHbqIKZaP5CP29a7MrGfGMr1
 Mb1y9EmoPLkBWNAh2lIPUxc4+LhuBKxNyP9w1KhpgoAOBaLelLkZd7kc/wvks1bOi50I
 9JNzzeHmFewF/BFLR7R3tWE4NbT6XlcKh5wfmGS4KOs96D2qNOoDRAPKxXI+TsyhP0Cg
 v1/6IZHII2/cmaruSGuSNFggiSaqdpgRerEPfQtvDPj0BWmim613rmyM/EQ/i+Pu85WR
 WCKAKf5m/FBHXMsNS/7YttGzreYlA4qzvHuxEeEp527QCWXgJ4g26dEJS0Jo2h5+LExi 1w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yb3gpu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LCCLx033041;
        Tue, 6 Dec 2022 21:55:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2maa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0p038701;
        Tue, 6 Dec 2022 21:55:56 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-5;
        Tue, 06 Dec 2022 21:55:56 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 4/8] vfio/type1: close dma owner
Date:   Tue,  6 Dec 2022 13:55:49 -0800
Message-Id: <1670363753-249738-5-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-ORIG-GUID: KhlddC72WG727X1Vq3FhhxUnM2CaS0-M
X-Proofpoint-GUID: KhlddC72WG727X1Vq3FhhxUnM2CaS0-M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a task exits or exec, unmap and unpin all dma mappings owned by the
task.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4429794..51bb687 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2932,6 +2932,16 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+static void vfio_iommu_type1_close_dma_owner(void *iommu_data)
+{
+	struct vfio_iommu *iommu = iommu_data;
+
+	mutex_lock(&iommu->lock);
+	if (iommu->task == current->group_leader)
+		vfio_iommu_unmap_unpin_all(iommu);
+	mutex_unlock(&iommu->lock);
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -3114,6 +3124,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
+	.close_dma_owner	= vfio_iommu_type1_close_dma_owner,
 };
 
 static int __init vfio_iommu_type1_init(void)
-- 
1.8.3.1

