Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A147D5346
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbjJXNzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjJXNzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BD2618C
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:51:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCKWs6009283;
        Tue, 24 Oct 2023 13:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=RB0dIId8hdOYB5yYyFGQzVnaAGB2TNgTkKTC9nM+4z0=;
 b=X4mtinjfMTsfHbWWdl5fg3uTznf3zhbAiNV+xavzhBG2w9OX+oYjVkEFbFOmI/4mBwaX
 tNIjBtphhQzNMzo6/wcFy8u4VHdW0ErzQiIa4H9TnbfjeTOHAPRk2zc4fOfEXriQzxHu
 79Ufbi7vzwr1+3Y6ZYyNhfgwCdPpqdNk6l7AwDLNQKimd2Op8Y5M+8cP3wQ5ff3Tw4oK
 hFhsp2AcyWJa+iLxSOdSVYBqnikxZ/B/xLCn0dD4wNIhrXLY1bWVDS2/erzqkSZG8Smb
 rQMQGolMhzQKPm2r3fDtqfLDzhTDQTu3LrOIDIwEhJuJDuyoxNmdmvp9JW8zLgYpS5tu 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581nhed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCZv1C034590;
        Tue, 24 Oct 2023 13:51:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv5359226-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL8u030007;
        Tue, 24 Oct 2023 13:51:33 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-4;
        Tue, 24 Oct 2023 13:51:33 +0000
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
Subject: [PATCH v6 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
Date:   Tue, 24 Oct 2023 14:50:54 +0100
Message-Id: <20231024135109.73787-4-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-GUID: N_PWMtiyymfo_L6P91vI9iUhE-ivPhID
X-Proofpoint-ORIG-GUID: N_PWMtiyymfo_L6P91vI9iUhE-ivPhID
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

