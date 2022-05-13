Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06F526A3C
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383786AbiEMTSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383722AbiEMTRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:17:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A7F393E8;
        Fri, 13 May 2022 12:16:55 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DHr3Wu020391;
        Fri, 13 May 2022 19:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=apmI2EUE7ufb4eSLsfhNPUD4OApuv679z3W7wE85eM0=;
 b=FdObNS3jXi8hVzE3Bn5bZwLjyJmWnc6tlVQJvWvzbgQZOTw3E2n5wdb2/QqKsioQZqZu
 84GvdM3muvCUkzOMuDLVuEPWJ76NiteWS5Ip9pJxlGZBJekoG23uLTo8NfGk0BgTlKyl
 AswL+Gys/QRQ7sH+ul8hFFZEGLEO+qOc3gSIuo2wnF8W1ji3mgIufw60IFw9szLDy1a5
 5SStXUnm/iC3naJ0TqoDNj6MGpzKGbfnn89AJyFh1EvaDlDr3PlV0bDQvhFP8dFbrk3c
 YoH8n+BlQRflyExVdA518Y7O6O1qG8qTEsd/m/ZgwcpDoDOOFzJ4XdjppldsyFgbGLC/ 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbh3x1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:51 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DIwN7t031530;
        Fri, 13 May 2022 19:16:50 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1mbh3x16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:50 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJDRZf009827;
        Fri, 13 May 2022 19:16:50 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3fwgd9vdpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:50 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJGn0V46793074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:16:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 699C5124054;
        Fri, 13 May 2022 19:16:49 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE677124053;
        Fri, 13 May 2022 19:16:45 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:45 +0000 (GMT)
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
Subject: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Date:   Fri, 13 May 2022 15:15:04 -0400
Message-Id: <20220513191509.272897-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xF2Xh3OU9W_QglPGJVgbaAqPYC3MDo7C
X-Proofpoint-ORIG-GUID: kaxB6fX9gC_1HlAxvPt8jV_QzeSRSfKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/vfio_pci_zdev.c | 54 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++
 4 files changed, 68 insertions(+)

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
index ea4c0d2b0663..130ab298ab98 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/vfio_zdev.h>
+#include <linux/kvm_host.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
@@ -136,3 +137,56 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
+
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
+		if (!zdev)
+			return NOTIFY_DONE;
+
+		if (data) {
+			if (kvm_s390_pci_register_kvm(zdev, (struct kvm *)data))
+				return NOTIFY_BAD;
+		} else {
+			if (kvm_s390_pci_unregister_kvm(zdev))
+				return NOTIFY_BAD;
+		}
+
+	}
+
+	return NOTIFY_OK;
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
+
+	/*
+	 * It's possible that the notifier is unregistered and we still have a
+	 * kvm association registered -- clean it up now.
+	 */
+	kvm_s390_pci_unregister_kvm(zdev);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index cfc9eb1f0b27..68ab01b592d3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -209,12 +209,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV_KVM
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

