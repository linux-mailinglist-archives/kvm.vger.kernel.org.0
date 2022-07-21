Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD0257D124
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiGUQOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiGUQOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBC489665;
        Thu, 21 Jul 2022 09:14:06 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFRlU020377;
        Thu, 21 Jul 2022 16:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=bqzWn/Gg+fWiZ+n3KkgqcbymlR4LIwjVz+Ummg/9o+k=;
 b=QhJK3NTIyL5zfMegOnqtZNfA0FrLVyRFWmraWUnvsxslKNzCUyeyh5SJRaksGL8zZybe
 m8omyiLgEwlLD8Mp4or3eN35RXjRavxMbmLbDG0uV12DZQcjy0YEeE3BTkfP5JdK7iaU
 c1A3oHyDu36fsk90aRS5uhT6/9zT5ou40VOsbt6V7WTJ1VFSBRNjcT/knacoCggMgTNt
 to/rLqwyVM9Z1R4sYD65o5XLl7YRTCP94AYoAQsjL9LkgqeWjwigInMJlMEldr2DdpyH
 q7KLFvJFaswRbeHfOcSG5OdAV84sDGrsekwIeEF8UO4jEw8PYtHGnbgyYd85A4XEoT5c Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:36 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFFaoe021797;
        Thu, 21 Jul 2022 16:13:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:35 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG8NPv019513;
        Thu, 21 Jul 2022 16:13:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nexs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDEEs11665802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2B6BA405B;
        Thu, 21 Jul 2022 16:13:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24B6FA4054;
        Thu, 21 Jul 2022 16:13:14 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 17/42] vfio-pci/zdev: add open/close device hooks
Date:   Thu, 21 Jul 2022 18:12:37 +0200
Message-Id: <20220721161302.156182-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KL92h4Ux56h6AJEdTOr5DtprbgEHPW2y
X-Proofpoint-GUID: WYGd_zxg-kGJg5sJ-bJOHb3j9xHRKma2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

During vfio-pci open_device, pass the KVM associated with the vfio group
(if one exists).  This is needed in order to pass a special indicator
(GISA) to firmware to allow zPCI interpretation facilities to be used
for only the specific KVM associated with the vfio-pci device.  During
vfio-pci close_device, unregister the notifier.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/20220606203325.110625-18-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 +++++++++-
 drivers/vfio/pci/vfio_pci_zdev.c | 24 ++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..b1e5cfbadf38 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -316,10 +316,14 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		pci_write_config_word(pdev, PCI_COMMAND, cmd);
 	}
 
-	ret = vfio_config_init(vdev);
+	ret = vfio_pci_zdev_open_device(vdev);
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
+	vfio_pci_zdev_close_device(vdev);
 out_free_state:
 	kfree(vdev->pci_saved_state);
 	vdev->pci_saved_state = NULL;
@@ -418,6 +424,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	vdev->needs_reset = true;
 
+	vfio_pci_zdev_close_device(vdev);
+
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
 	 * even better.  Resetting with current state seems better than
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..686f2e75e392 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/vfio_zdev.h>
+#include <linux/kvm_host.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
@@ -136,3 +137,26 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
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
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev || !vdev->vdev.kvm)
+		return;
+
+	kvm_s390_pci_unregister_kvm(zdev);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 63af2897939c..d5d9e17f0156 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -209,12 +209,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV_KVM
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
 }
+
+static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
+
+static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{}
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.36.1

