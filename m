Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D38644E44
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLFV4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiLFV4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05044490AC
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:56:00 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LIeGb029952;
        Tue, 6 Dec 2022 21:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=K8i6+qp5xMtbwLaSbH3BVzW4ml2Nd/cWyXl0Gxxc32U=;
 b=lfvX2FVOcaVK0GAo51y/JtdmQ6hYGqFhMKZwMO8GlfYIvDiEBl9uNrVHjBBmpZyEUSRM
 ihgWLmH6aJyhJuHILugXmlMMQlL+oRgUI3QpCIAruMXj5NDsoxAcl10tdd3AI4gv7uiO
 gyGowhPQz9ysy0P5L6qzR+ujBbYkY+RbWX03qNEm4fedCAzFBgDlvIqN3rzCzXkY+VZe
 IYa6j9yIATYOr4nS8bT7S+3AWOyDX3MfVTMrpD4sBVN2I4OOaVvh89qwU1ywtBc97lLq
 2Nx6nUJWWoyVkYDdb9e9kWbq/OdHVLL/CqhWp5DAgnmTSmCwn+F/La8XA3nMNtrsQc9o Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ybgrwpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LOA2G032794;
        Tue, 6 Dec 2022 21:55:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2mb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:58 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0v038701;
        Tue, 6 Dec 2022 21:55:57 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-8;
        Tue, 06 Dec 2022 21:55:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 7/8] vfio: change dma owner
Date:   Tue,  6 Dec 2022 13:55:52 -0800
Message-Id: <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-ORIG-GUID: 0cEqQmKXbZOpKiFD0eoxuXCGRrD4tib3
X-Proofpoint-GUID: 0cEqQmKXbZOpKiFD0eoxuXCGRrD4tib3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the VFIO_DMA_OWNER extension.  It indicates support for the
redefined VFIO_DMA_MAP_FLAG_VADDR, and the new VFIO_CHANGE_DMA_OWNER
ioctl, defined as:

 Change ownership of all dma mappings to the calling task, including
 count of locked pages subject to RLIMIT_MEMLOCK.  The new task's address
 space is used to translate virtual to physical addresses for all future
 requests, including as those issued by mediated devices. For all mappings,
 the vaddr must be the same in the old and new address space, or can be
 changed in the new address space by using VFIO_DMA_MAP_FLAG_VADDR.

See vfio.h for more details.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/container.c  | 18 ++++++++++++++++++
 drivers/vfio/vfio.h       |  1 +
 include/uapi/linux/vfio.h | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index b660adc..7e78593 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -468,6 +468,21 @@ static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	return 0;
 }
 
+static int vfio_change_dma_owner(struct vfio_container *container,
+				 struct file *filep)
+{
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+	int ret;
+
+	if (!driver || !driver->ops->change_dma_owner)
+		return -ENOTTY;
+
+	ret = vfio_register_dma_task(container, filep);
+	if (!ret)
+		ret = driver->ops->change_dma_owner(container->iommu_data);
+	return ret;
+}
+
 static long vfio_fops_unl_ioctl(struct file *filep,
 				unsigned int cmd, unsigned long arg)
 {
@@ -489,6 +504,9 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
 		break;
+	case VFIO_CHANGE_DMA_OWNER:
+		ret = vfio_change_dma_owner(container, filep);
+		break;
 	case VFIO_IOMMU_MAP_DMA:
 		ret = vfio_register_dma_task(container, filep);
 		if (ret)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 0cf3cfe..999a7b0 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -92,6 +92,7 @@ struct vfio_iommu_driver_ops {
 				  void *data, size_t count, bool write);
 	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
 						   struct iommu_group *group);
+	int		(*change_dma_owner)(void *iommu_data);
 	void		(*close_dma_owner)(void *iommu_data);
 };
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8b7c1ed..8074d80 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -53,6 +53,11 @@
 #define VFIO_UPDATE_VADDR		10
 
 /*
+ * Supports VFIO_CHANGE_DMA_OWNER and VFIO_DMA_MAP_FLAG_VADDR.
+ */
+#define VFIO_DMA_OWNER			11
+
+/*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
  * kernel and userspace.  We therefore use the _IO() macro for these
@@ -128,6 +133,33 @@ struct vfio_info_cap_header {
  */
 #define VFIO_SET_IOMMU			_IO(VFIO_TYPE, VFIO_BASE + 2)
 
+/**
+ * VFIO_CHANGE_DMA_OWNER		_IO(VFIO_TYPE, VFIO_BASE + 22)
+ *
+ * Change ownership of all dma mappings to the calling task, including
+ * count of locked pages subject to RLIMIT_MEMLOCK.  The new task's address
+ * space is used to translate virtual to physical addresses for all future
+ * requests, including as those issued by mediated devices.  For all mappings,
+ * the vaddr must be the same in the old and new address space, or can be
+ * changed in the new address space by using VFIO_DMA_MAP_FLAG_VADDR, but in
+ * both cases the old vaddr and address space must map to the same memory
+ * object as the new vaddr and address space.  Length and access permissions
+ * cannot be changed, and the object must be mapped shared.  Tasks must not
+ * modify the old or new address space over the affected ranges during this
+ * ioctl, else differences might not be detected, and dma may target the wrong
+ * user pages.
+ *
+ * Return:
+ *	      0: success
+ *       -ESRCH: owning task is dead.
+ *	-ENOMEM: Out of memory, or RLIMIT_MEMLOCK is too low.
+ *	 -ENXIO: Memory object does not match or is not shared.
+ *	-EINVAL: a new vaddr was provided for some but not all mappings.
+ *
+ * Availability: with VFIO_DMA_OWNER extension.
+ */
+#define VFIO_CHANGE_DMA_OWNER		_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- IOCTLs for GROUP file descriptors (/dev/vfio/$GROUP) -------- */
 
 /**
-- 
1.8.3.1

