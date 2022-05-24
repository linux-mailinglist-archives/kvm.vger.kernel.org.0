Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F242E533108
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiEXTAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbiEXTAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:00:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7880B7CB4B;
        Tue, 24 May 2022 12:00:06 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIohsV024514;
        Tue, 24 May 2022 18:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JOVua26885iGgHBmX6uPehZiXkwEpC6hn5Pwchvfhw8=;
 b=drBpjYMZna3PtMItsr4hfUgq1W1EOFeVNkAerrfqRwDQHhSCSiG6R10MQS/Ap7utwYVm
 EYxmpHIaByhYPE8rxSjf/T28iFC5IZTbutgJcZIAeekYRxrjGATPpfjjFFnbgKpR9/Xy
 ZD9EbZq49dXLiP/zkAON5nob0Rl6l/a4qja47vywTwQ+oB3J2XHgEWwtBJtTQimwejAN
 rZqkyEyR5O57+iEM/54lcAYbqV6Wi0PCq7tYezpaHMcznJ4Ep2M77MpjZX+qFJXxjCF6
 9FWiWhw0qovS7GtGiC98qXtqGOg1Qwn9S4K+jDzuDP+7WgyF/3lOb32fE9M7shCazCtW cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g04yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:56 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIrGPG031566;
        Tue, 24 May 2022 18:59:55 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g04yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:55 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIr2Hv032504;
        Tue, 24 May 2022 18:59:54 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3g93v8gnsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:54 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxrwg23200236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:53 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24509BE05D;
        Tue, 24 May 2022 18:59:53 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E870BE05A;
        Tue, 24 May 2022 18:59:51 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:50 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v8 17/22] vfio-pci/zdev: add open/close device hooks
Date:   Tue, 24 May 2022 14:59:02 -0400
Message-Id: <20220524185907.140285-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 59vhhUFTNgJbYdc8pIY8TFPjnbEQtgQK
X-Proofpoint-GUID: rx2jja-Qth91Gbn9yYrLthT8a5jAFuUd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During vfio-pci open_device, pass the KVM associated with the vfio group
(if one exists).  This is needed in order to pass a special indicator
(GISA) to firmware to allow zPCI interpretation facilities to be used
for only the specific KVM associated with the vfio-pci device.  During
vfio-pci close_device, unregister the notifier.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      |  2 ++
 drivers/vfio/pci/vfio_pci_core.c | 11 ++++++++++-
 drivers/vfio/pci/vfio_pci_zdev.c | 27 +++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 12 ++++++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 85eb0ef9d4c3..67fbce1ea0c9 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/mutex.h>
 #include <linux/iommu.h>
+#include <linux/notifier.h>
 #include <linux/pci_hotplug.h>
 #include <asm-generic/pci.h>
 #include <asm/pci_clp.h>
@@ -195,6 +196,7 @@ struct zpci_dev {
 	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
 	struct kvm_zdev *kzdev;
 	struct mutex kzdev_lock;
+	struct notifier_block nb; /* vfio notifications */
 };
 
 static inline bool zdev_enabled(struct zpci_dev *zdev)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..650494410682 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -316,10 +316,14 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		pci_write_config_word(pdev, PCI_COMMAND, cmd);
 	}
 
-	ret = vfio_config_init(vdev);
+	ret = vfio_pci_zdev_open(vdev);
 	if (ret)
 		goto out_free_state;
 
+	ret = vfio_config_init(vdev);
+	if (ret)
+		goto out_free_zdev;
+
 	msix_pos = pdev->msix_cap;
 	if (msix_pos) {
 		u16 flags;
@@ -340,6 +344,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 
+out_free_zdev:
+	vfio_pci_zdev_release(vdev);
 out_free_state:
 	kfree(vdev->pci_saved_state);
 	vdev->pci_saved_state = NULL;
@@ -418,6 +424,9 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	vdev->needs_reset = true;
 
+	if (vfio_pci_zdev_release(vdev))
+		pci_info(pdev, "%s: Couldn't restore zPCI state\n", __func__);
+
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
 	 * even better.  Resetting with current state seems better than
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..d0df85c8b204 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/vfio_zdev.h>
+#include <linux/kvm_host.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
@@ -136,3 +137,29 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev)
+		return -ENODEV;
+
+	if (!vdev->vdev.kvm)
+		return 0;
+
+	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
+}
+
+int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev)
+		return -ENODEV;
+
+	if (!vdev->vdev.kvm)
+		return 0;
+
+	return kvm_s390_pci_unregister_kvm(zdev);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 63af2897939c..50ffab782435 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -209,12 +209,24 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV_KVM
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
+int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
 }
+
+static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
+
+static inline int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.27.0

