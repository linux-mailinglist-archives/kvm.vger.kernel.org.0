Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13F5109D7
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354671AbiDZUNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354669AbiDZUNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:13:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9B1101C5;
        Tue, 26 Apr 2022 13:10:09 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4DXJ001275;
        Tue, 26 Apr 2022 20:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7r6yZaT15Qn9/0FGLR9gkG4pKQrmo7a8cfCBmFvaavc=;
 b=TB6P9dshXRpbpyL30dM6Py7QjPvWj60YJOQp5LjrWJZFnAL8kDgF/DoTpV7kfZ+w/f/F
 vvVLhHhoE3WZtHgr6BAdroKjABfx28con3XbaByV4H1A6c0molebuMv6UNfVaH5I1IIf
 TQcr9onU1fTM+e6dvWTqXsch8s999cGH0AMRO7fiPITtqCMAfXpbm+xDVdtLSfCO7h86
 H48U7FmY1Nnt8xDu/VadufOKaVqweWPR1zZdI9OwH8x55MXU/swKzENlCs1Y06duDpaV
 4s+4A5I5rDaUW8fq+c5M5k9z2vkZBFFnszV8TFHCgUACDHZcxMuWevyTFHYAGIizybc6 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpmwyk4q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK4YPu007070;
        Tue, 26 Apr 2022 20:10:06 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpmwyk4pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8Oep001213;
        Tue, 26 Apr 2022 20:10:04 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93anaee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:04 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QKA3bd18612570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:10:03 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5659B206A;
        Tue, 26 Apr 2022 20:10:03 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65D8CB205F;
        Tue, 26 Apr 2022 20:10:00 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:10:00 +0000 (GMT)
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
Subject: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Date:   Tue, 26 Apr 2022 16:08:37 -0400
Message-Id: <20220426200842.98655-17-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DSI_AmDYzt7P490Rv4Ylu4iRcQ-OcvIm
X-Proofpoint-ORIG-GUID: HfgajjVXsnRvzILMcgmKU1cw85Mt3-Qy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During vfio-pci open_device, register a notifier for the zPCI device to
catch KVM registration.  This is needed in order to pass a special
indicator (GISA) to firmware to allow zPCI interpretation facilities to be
used for only the specific KVM associated with the vfio-pci device.
During vfio-pci close_device, unregister the notifier.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      |  2 ++
 drivers/vfio/pci/vfio_pci_core.c |  2 ++
 drivers/vfio/pci/vfio_pci_zdev.c | 50 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 +++++++
 4 files changed, 64 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 322060a75d9f..fdcc95b36edb 100644
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
@@ -194,6 +195,7 @@ struct zpci_dev {
 	/* IOMMU and passthrough */
 	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
 	struct kvm_zdev *kzdev;
+	struct notifier_block nb; /* vfio notifications */
 };
 
 static inline bool zdev_enabled(struct zpci_dev *zdev)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a13..d53125b308f0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -449,6 +449,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->sriov_pf_core_dev->vf_token->users--;
 		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
 	}
+	vfio_pci_zdev_release(vdev);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
 	vfio_pci_core_disable(vdev);
 
@@ -469,6 +470,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
+	vfio_pci_zdev_open(vdev);
 
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..112c1f820f8e 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/vfio_zdev.h>
+#include <linux/kvm_host.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
@@ -136,3 +137,52 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
+	int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
+	int rc = NOTIFY_OK;
+
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
+		if (!zdev)
+			return NOTIFY_DONE;
+
+		fn = symbol_get(kvm_s390_pci_register_kvm);
+		if (!fn)
+			return NOTIFY_DONE;
+
+		if (fn(zdev, (struct kvm *)data))
+			rc = NOTIFY_BAD;
+
+		symbol_put(kvm_s390_pci_register_kvm);
+	}
+
+	return rc;
+}
+
+void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
+{
+	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev)
+		return;
+
+	zdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
+
+	vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+			       &events, &zdev->nb);
+}
+
+void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev)
+		return;
+
+	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+				 &zdev->nb);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 48f2dd3c568c..b1b285421c18 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -209,12 +209,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_S390
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
+void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
 }
+
+static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
+{
+}
+
+static inline void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+}
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.27.0

