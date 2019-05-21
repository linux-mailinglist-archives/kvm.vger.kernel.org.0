Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8252541C
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfEUPfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:35:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728857AbfEUPeq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 11:34:46 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LFU0bC097705
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 11:34:45 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2smhxhenfd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 11:34:45 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 21 May 2019 16:34:43 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 May 2019 16:34:41 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4LFYdD719202276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 15:34:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E19EAE045;
        Tue, 21 May 2019 15:34:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B76FAE051;
        Tue, 21 May 2019 15:34:39 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.152.222.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 May 2019 15:34:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
Subject: [PATCH v9 2/4] vfio: ap: register IOMMU VFIO notifier
Date:   Tue, 21 May 2019 17:34:35 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19052115-4275-0000-0000-00000337205D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052115-4276-0000-0000-00003846B5B2
Message-Id: <1558452877-27822-3-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To be able to use the VFIO interface to facilitate the
mediated device memory pinning/unpinning we need to register
a notifier for IOMMU.

While we will start to pin one guest page for the interrupt indicator
byte, this is still ok with ballooning as this page will never be
used by the guest virtio-balloon driver.
So the pinned page will never be freed. And even a broken guest does
so, that would not impact the host as the original page is still
in control by vfio.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 43 ++++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 900b9cf..e8e87bf 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -759,6 +759,35 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+/*
+ * vfio_ap_mdev_iommu_notifier: IOMMU notifier callback
+ *
+ * @nb: The notifier block
+ * @action: Action to be taken
+ * @data: data associated with the request
+ *
+ * For an UNMAP request, unpin the guest IOVA (the NIB guest address we
+ * pinned before). Other requests are ignored.
+ *
+ */
+static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
+				       unsigned long action, void *data)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	matrix_mdev = container_of(nb, struct ap_matrix_mdev, iommu_notifier);
+
+	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
+		struct vfio_iommu_type1_dma_unmap *unmap = data;
+		unsigned long g_pfn = unmap->iova >> PAGE_SHIFT;
+
+		vfio_unpin_pages(mdev_dev(matrix_mdev->mdev), &g_pfn, 1);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
@@ -858,7 +887,17 @@ static int vfio_ap_mdev_open(struct mdev_device *mdev)
 		return ret;
 	}
 
-	return 0;
+	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
+	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
+	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+				     &events, &matrix_mdev->iommu_notifier);
+	if (!ret)
+		return ret;
+
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+				 &matrix_mdev->group_notifier);
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static void vfio_ap_mdev_release(struct mdev_device *mdev)
@@ -869,6 +908,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
 
 	vfio_ap_mdev_reset_queues(mdev);
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+				 &matrix_mdev->iommu_notifier);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	matrix_mdev->kvm = NULL;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index a910be1..18dcc4d 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -81,8 +81,10 @@ struct ap_matrix_mdev {
 	struct list_head node;
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;
+	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
+	struct mdev_device *mdev;
 };
 
 extern int vfio_ap_mdev_register(void);
-- 
2.7.4

