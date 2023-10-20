Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B69A7D191E
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjJTW26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjJTW25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:28:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4787510D8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:28:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLePAA013036;
        Fri, 20 Oct 2023 22:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=RB0dIId8hdOYB5yYyFGQzVnaAGB2TNgTkKTC9nM+4z0=;
 b=DkIP3Y3AMXLedpfZAXX0uRgxTxkkzN38dGvIO9nAE882kox/qvf+zp+0vYKuMtyPaEBU
 oN8849mAqepAzsehxn9U8UXlcpRLvOXVuj6P9PPMBJtGhJqjRF3X1VX/4Co5k6hw4EXG
 42tIau7Sn2SYptnWU8gXc2uqkJlesLy4yNialu2Z/43jo2PTF+JHrzPerQCTp9gg0fVT
 Jqc1kwqTBS+PDEFu8F3Q+/EFRLJmfZgffQCJctSxC8s/ISgCasX3RPRTmVCFF6DcJ2+P
 Mw9U4YguyOCLoJ5PtU/S+o/D1ZAG/FL3qipOPKz2iiZeRSXPuTtIsXdQiYCMQ9UCEFPv rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwbasxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KKtiWu025682;
        Fri, 20 Oct 2023 22:28:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwducp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:22 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSAs0018735;
        Fri, 20 Oct 2023 22:28:21 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-4;
        Fri, 20 Oct 2023 22:28:21 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [PATCH v5 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
Date:   Fri, 20 Oct 2023 23:27:49 +0100
Message-Id: <20231020222804.21850-4-joao.m.martins@oracle.com>
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200191
X-Proofpoint-GUID: Tc3HtWv3-f1j8p_zh8woO8aYD8hs8rk0
X-Proofpoint-ORIG-GUID: Tc3HtWv3-f1j8p_zh8woO8aYD8hs8rk0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Have the IOVA bitmap exported symbols adhere to the IOMMUFD symbol
export convention i.e. using the IOMMUFD namespace. In doing so,
import the namespace in the current users. This means VFIO and the
vfio-pci drivers that use iova_bitmap_set().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
 drivers/vfio/pci/mlx5/main.c        | 1 +
 drivers/vfio/pci/pds/pci_drv.c      | 1 +
 drivers/vfio/vfio_main.c            | 1 +
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index f54b56388e00..0a92c9eeaf7f 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -268,7 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 	iova_bitmap_free(bitmap);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_alloc, IOMMUFD);
 
 /**
  * iova_bitmap_free() - Frees an IOVA bitmap object
@@ -290,7 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
 
 	kfree(bitmap);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_free);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_free, IOMMUFD);
 
 /*
  * Returns the remaining bitmap indexes from mapped_total_index to process for
@@ -389,7 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, IOMMUFD);
 
 /**
  * iova_bitmap_set() - Records an IOVA range in bitmap
@@ -423,4 +423,4 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 		cur_bit += nbits;
 	} while (cur_bit <= last_bit);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_set);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_set, IOMMUFD);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 42ec574a8622..5cf2b491d15a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1376,6 +1376,7 @@ static struct pci_driver mlx5vf_pci_driver = {
 
 module_pci_driver(mlx5vf_pci_driver);
 
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
 MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ab4b5958e413..dd8c00c895a2 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -204,6 +204,7 @@ static struct pci_driver pds_vfio_pci_driver = {
 
 module_pci_driver(pds_vfio_pci_driver);
 
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
 MODULE_AUTHOR("Brett Creeley <brett.creeley@amd.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..a96d97da367d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1693,6 +1693,7 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);
 
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.17.2

