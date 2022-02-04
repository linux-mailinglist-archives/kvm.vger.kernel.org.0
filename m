Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BB4AA1F3
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbiBDVR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243400AbiBDVQf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:35 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214I1G7g032196;
        Fri, 4 Feb 2022 21:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2kW2+VEK6gOx/vl99AVl6Dc7lZkmeAzJHvn2DcPvZKQ=;
 b=Xwnly80bJgqHkeWQsAHeTdMGfsCQ0ggWW+TBAWEju2YU2i0XLpKJ4ielPtvNtk6oIbc7
 Q18m/RMISeEImIyLIwi2qlKYl2yz6L7xbkYOIqpdUCaZsNlbP5OUyW05NCOmorgOjSBG
 v2jETTUv9833UzJiUu6/wsml55UgzEx5czrckiHWNyyK2K6kWCuqVAGdhIJ+oxJZwVex
 +ulgRdsCg0v2mfeQCHP/w1l62mgkpsxSODUBLCKsc5kzx75nBdnhqjTlLKcZJj+/2Xx2
 nE76QQsw7dj2eBSEGwER7hM9adEYKNwjBeWPtDW3LUmkqtbuv/fEdPXR1haFlObL6N5h AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xskm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214L6bYw007736;
        Fri, 4 Feb 2022 21:16:34 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xsjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:34 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCgn0011957;
        Fri, 4 Feb 2022 21:16:32 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3e0r0m2wn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:32 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGVIM30671110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:31 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294A3136067;
        Fri,  4 Feb 2022 21:16:31 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57421136055;
        Fri,  4 Feb 2022 21:16:29 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:29 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Date:   Fri,  4 Feb 2022 16:15:30 -0500
Message-Id: <20220204211536.321475-25-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9M9dsVg6DDpmuvSggcuuNcUJlbiFRzNK
X-Proofpoint-ORIG-GUID: RCcr-FADDJov24cZplzEhFJb9OGT2JMi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM zPCI passthrough device logic will need a reference to the associated
kvm guest that has access to the device.  Let's register a group notifier
for VFIO_GROUP_NOTIFY_SET_KVM to catch this information in order to create
an association between a kvm guest and the host zdev.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  2 ++
 drivers/vfio/pci/vfio_pci_core.c |  2 ++
 drivers/vfio/pci/vfio_pci_zdev.c | 46 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 +++++++
 4 files changed, 60 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index e4696f5592e1..16290b4cf2a6 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -16,6 +16,7 @@
 #include <linux/kvm.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <asm/pci_insn.h>
 #include <asm/pci_dma.h>
 
@@ -32,6 +33,7 @@ struct kvm_zdev {
 	u64 rpcit_count;
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
+	struct notifier_block nb;
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..fc57d4d0abbe 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -452,6 +452,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
+	vfio_pci_zdev_release(vdev);
 	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
@@ -470,6 +471,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
+	vfio_pci_zdev_open(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
 }
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..9f8284499111 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -13,6 +13,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/kvm_pci.h>
 
 #include <linux/vfio_pci_core.h>
 
@@ -136,3 +137,48 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct kvm_zdev *kzdev = container_of(nb, struct kvm_zdev, nb);
+
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
+		if (!data || !kzdev->zdev)
+			return NOTIFY_DONE;
+		kzdev->kvm = data;
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
+	if (kvm_s390_pci_dev_open(zdev))
+		return;
+
+	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
+
+	if (vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+				   &events, &zdev->kzdev->nb))
+		kvm_s390_pci_dev_release(zdev);
+}
+
+void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev || !zdev->kzdev)
+		return;
+
+	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+				 &zdev->kzdev->nb);
+
+	kvm_s390_pci_dev_release(zdev);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5e2bca3b89db..05287f8ac855 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -198,12 +198,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV
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

