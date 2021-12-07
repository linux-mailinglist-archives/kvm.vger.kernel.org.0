Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433B46C5BE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241604AbhLGVEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241644AbhLGVEF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:04:05 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfXE022869;
        Tue, 7 Dec 2021 21:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mVptbdHqYRDeHVse2gEEAH7wVFXMt6qxi9uceONyvn4=;
 b=ruGS+O6eiXzuZrRun+nFdEUqJWqKU9Z+OZpNkO1o/ZrPAv2AxqigeA521GYlvEfvQMy5
 VZPmOQ14J3HydRZDOsZucavAobJYpIFZCVArk7yyntO/G52pWOrH94ruS0QH6YlCACo6
 ik/k/5FzQ0Sem69Z4noJSVi8AJqMeR7QYQnz9epsBkiUZQ5mlT0WJNamI+flS282zMqp
 UN+Kpa0/hD2hKGXWPJVXatEgPzrmH8GHqqZAfNoZp5L2FOrjMqKJ/5NrPDFGWJtqNSw6
 IlN/4G14tMk//5mYXanPe1SrFk2vBGE7ktwLiQmFfEqbzn9Y055nr241w1UmOiHXMFoP 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpe2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KqG1D002474;
        Tue, 7 Dec 2021 21:00:32 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpe1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:32 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvuWm010261;
        Tue, 7 Dec 2021 21:00:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 3cqyyamkve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L0TmG12321242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E757AE06A;
        Tue,  7 Dec 2021 21:00:29 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B09E6AE06B;
        Tue,  7 Dec 2021 21:00:24 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:00:24 +0000 (GMT)
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
Subject: [PATCH 29/32] vfio-pci/zdev: wire up zPCI IOAT assist support
Date:   Tue,  7 Dec 2021 15:57:40 -0500
Message-Id: <20211207205743.150299-30-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: spA0gYATMRr5xl1lVj7FYKT4a8PRl8NE
X-Proofpoint-GUID: 1apxp643odLGB9m_ZllnuB_rJc5DIPTe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for VFIO_DEVICE_FEATURE_ZPCI_IOAT, which is a new
VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
s390x vfio-pci device wishes to enable/disable zPCI I/O Address
Translation assistance, allowing the host to perform address translation
and shadowing.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  1 +
 drivers/vfio/pci/vfio_pci_core.c |  2 ++
 drivers/vfio/pci/vfio_pci_zdev.c | 61 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++
 include/uapi/linux/vfio.h        |  8 +++++
 include/uapi/linux/vfio_zdev.h   | 13 +++++++
 6 files changed, 95 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 0a0e42e1db1c..0b362d55c7b2 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -32,6 +32,7 @@ struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
 	u64 rpcit_count;
+	u64 iota;
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 	struct notifier_block nb;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 01658de660bd..709d9ba22a60 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1176,6 +1176,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
 		case VFIO_DEVICE_FEATURE_ZPCI_AIF:
 			return vfio_pci_zdev_feat_aif(vdev, feature, arg);
+		case VFIO_DEVICE_FEATURE_ZPCI_IOAT:
+			return vfio_pci_zdev_feat_ioat(vdev, feature, arg);
 		default:
 			return -ENOTTY;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index dd98808b9139..85be77492a6d 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -298,6 +298,66 @@ int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
 	return rc;
 }
 
+int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
+			    struct vfio_device_feature feature,
+			    unsigned long arg)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	struct vfio_device_zpci_ioat *data;
+	struct vfio_device_feature *feat;
+	unsigned long minsz;
+	int size, rc = 0;
+
+	if (!zdev || !zdev->kzdev)
+		return -EINVAL;
+
+	/*
+	 * If PROBE requested and feature not found, leave immediately.
+	 * Otherwise, keep going as GET or SET may also be specified.
+	 */
+	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE) {
+		rc = kvm_s390_pci_ioat_probe(zdev);
+		if (rc)
+			return rc;
+	}
+	if (!(feature.flags & (VFIO_DEVICE_FEATURE_GET +
+			       VFIO_DEVICE_FEATURE_SET)))
+		return 0;
+
+	size = sizeof(*feat) + sizeof(*data);
+	feat = kzalloc(size, GFP_KERNEL);
+	if (!feat)
+		return -ENOMEM;
+
+	data = (struct vfio_device_zpci_ioat *)&feat->data;
+	minsz = offsetofend(struct vfio_device_feature, flags);
+
+	/* Get the rest of the payload for GET/SET */
+	rc = copy_from_user(data, (void __user *)(arg + minsz),
+			sizeof(*data));
+	if (rc)
+		rc = -EINVAL;
+
+	if (feature.flags & VFIO_DEVICE_FEATURE_GET) {
+		data->iota = (u64)zdev->kzdev->iota;
+		if (copy_to_user((void __user *)arg, feat, size))
+			rc = -EFAULT;
+	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
+		if (data->iota != 0) {
+			rc = kvm_s390_pci_ioat_enable(zdev, data->iota);
+			if (!rc)
+				zdev->kzdev->iota = data->iota;
+		} else if (zdev->kzdev->iota != 0) {
+			rc = kvm_s390_pci_ioat_disable(zdev);
+			if (!rc)
+				zdev->kzdev->iota = 0;
+		}
+	}
+
+	kfree(feat);
+	return rc;
+}
+
 static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
 					unsigned long action, void *data)
 {
@@ -353,6 +413,7 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 */
 	if (zdev->gd != 0) {
 		kvm_s390_pci_aif_disable(zdev);
+		kvm_s390_pci_ioat_disable(zdev);
 		kvm_s390_pci_interp_disable(zdev);
 	}
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5442d3fa1662..7c45a425e7f8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -204,6 +204,9 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
 			   struct vfio_device_feature feature,
 			   unsigned long arg);
+int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
+			    struct vfio_device_feature feature,
+			    unsigned long arg);
 int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
 #else
@@ -227,6 +230,13 @@ static inline int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
 	return -ENOTTY;
 }
 
+static inline int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
+					  struct vfio_device_feature feature,
+					  unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index fe3bfd99bf50..32c687388f48 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1016,6 +1016,14 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_ZPCI_AIF		(2)
 
+/*
+ * Provide support for enabling guest I/O address translation assistance for
+ * zPCI devices.  This feature is only valid for s390x PCI devices.  Data
+ * provided when setting and getting this feature is further described in
+ * vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_IOAT		(3)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index c574e23f9385..1a5229b7bb18 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -110,4 +110,17 @@ struct vfio_device_zpci_aif {
 	__u8 sbo;		/* Offset of guest summary bit vector */
 };
 
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_IOAT
+ *
+ * This feature is used for enabling guest I/O translation assistance for
+ * passthrough zPCI devices using instruction interpretation.  When setting
+ * this feature, the iota specifies a KVM guest I/O translation anchor.  When
+ * getting this feature, the most recently set anchor (or 0) is returned in
+ * iota.
+ */
+struct vfio_device_zpci_ioat {
+	__u64 iota;
+};
+
 #endif
-- 
2.27.0

