Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED6D46C5B2
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241676AbhLGVET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237615AbhLGVDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jm320014902;
        Tue, 7 Dec 2021 21:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XE4aOpQk/3vdUM+ycDBtYWJ6Vv1wblvA+etdiRNwOzw=;
 b=D9H9c7dJr6Fyh4XDy3RWU8iEyEMANSo60OqMH5J+2FcURK7NxKvd5mB26ei9oYsACCFG
 YZjWPlX8Z5tNPkaGMNlSsdFRsTYnaPUiFxuEVGSWDEPP4fyOrdflVh4yC1+cYXuGW+ib
 sKotxYzM/jcA5cXWdrgXwM1eLp418PUSjT3uomuHQFySZxkoK/qLZ40/TG3TdE09SaId
 9J84zCwGrb0uLp60ibxB9vS3DlVP4o8gWA73e358KvHE/nkrIZ3MDdii3GziDiDs4ckT
 j3rymMWL07rczHnUPZF3wgPEwUylJ3x7t/lXnRuZwQn46NGxalAtRVVl1Y7IlIxrUlCz IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdqf9pf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:16 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KouSh025124;
        Tue, 7 Dec 2021 21:00:16 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdqf9peh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:16 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvnJS006788;
        Tue, 7 Dec 2021 21:00:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 3cqyyamkvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:14 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L0D9S45875458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:13 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBDABAE063;
        Tue,  7 Dec 2021 21:00:12 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 133AEAE07E;
        Tue,  7 Dec 2021 21:00:08 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:00:07 +0000 (GMT)
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
Subject: [PATCH 26/32] vfio-pci/zdev: wire up group notifier
Date:   Tue,  7 Dec 2021 15:57:37 -0500
Message-Id: <20211207205743.150299-27-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v3c4kvo6gXuCYKA1FhlZWUAiHoDHiXGp
X-Proofpoint-ORIG-GUID: rUuKsoT4P--tyaWZuFzdKrFw-RwK9Azt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
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
 drivers/vfio/pci/vfio_pci_zdev.c | 54 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 12 +++++++
 4 files changed, 70 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 97e3a369135d..6526908ac834 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -17,6 +17,7 @@
 #include <linux/kvm.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <asm/pci_insn.h>
 #include <asm/pci_dma.h>
 
@@ -33,6 +34,7 @@ struct kvm_zdev {
 	u64 rpcit_count;
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
+	struct notifier_block nb;
 };
 
 extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
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
index ea4c0d2b0663..cfd7f44b06c1 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -13,6 +13,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/kvm_pci.h>
 
 #include <linux/vfio_pci_core.h>
 
@@ -136,3 +137,56 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
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
+		if (kvm_s390_pci_attach_kvm(kzdev->zdev, data))
+			return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
+{
+	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	int ret;
+
+	if (!zdev)
+		return -ENODEV;
+
+	ret = kvm_s390_pci_dev_open(zdev);
+	if (ret)
+		return -ENODEV;
+
+	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
+
+	ret = vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+				     &events, &zdev->kzdev->nb);
+	if (ret)
+		kvm_s390_pci_dev_release(zdev);
+
+	return ret;
+}
+
+int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev || !zdev->kzdev)
+		return -ENODEV;
+
+	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
+				 &zdev->kzdev->nb);
+
+	kvm_s390_pci_dev_release(zdev);
+
+	return 0;
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5e2bca3b89db..14079da409f1 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -198,12 +198,24 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV
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
+	return -ENODEV;
+}
+
+static inline int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
+{
+	return -ENODEV;
+}
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.27.0

