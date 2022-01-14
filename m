Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF22748F14B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244784AbiANUdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244613AbiANUcl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:41 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EKPqRt026279;
        Fri, 14 Jan 2022 20:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KwQPL5cXH+90BxK3tZQYTC0Q7IBMkSkdqs1IcI+LVwk=;
 b=ocktUyFEog86jZey8Aak6e/xWcjdb23qoS5qDsWHr1obYRDk56wnd0Y4Ezm0etsPa/O+
 fG+Y5A+312hMR19JQrj9dhE6TpOVpZ2corgpI3RSra8VlQPqeOkUVW18TOIy2QC7bdSI
 9cnJf7ZIeHfda+HRBgEBN5nOmfdEO1f6AC29TFArHHEq8g8pbHtPdlQgWWjRqbsFEnyD
 ET8HnS7pvrpUG/xc4Q/pj0ABSInzEPXY/ZgGqq74vG2NUZYmSkemvbZnTECwndp6RzYZ
 BD8UNfgT9P7QGqPxa97TANezREzFtfpbNXSg9xYgT3vHg4Gqdck9Cnsd8SV/F8Ok08QY Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r47f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:40 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKRwUS000309;
        Fri, 14 Jan 2022 20:32:40 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r475-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:40 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMVPZ006491;
        Fri, 14 Jan 2022 20:32:39 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3df28de8d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:39 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWb4L26214796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA9F0C6070;
        Fri, 14 Jan 2022 20:32:37 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6CFBC606D;
        Fri, 14 Jan 2022 20:32:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:35 +0000 (GMT)
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
Subject: [PATCH v2 24/30] vfio-pci/zdev: wire up group notifier
Date:   Fri, 14 Jan 2022 15:31:39 -0500
Message-Id: <20220114203145.242984-25-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GsipiWxgxGzDaz6qxX0RwD8BgNKqY824
X-Proofpoint-GUID: cnYa4PQlApH65kROoDWwLdLGCJuSMZsF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
index fa90729a35cf..97a90b37c87d 100644
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
index ea4c0d2b0663..5c2bddc57b39 100644
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
+		kvm_s390_pci_attach_kvm(kzdev->zdev, data);
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

