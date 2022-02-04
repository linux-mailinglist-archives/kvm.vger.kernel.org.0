Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055944AA227
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbiBDVSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:18:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242343AbiBDVQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:45 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214J0Q8S021613;
        Fri, 4 Feb 2022 21:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=O7FjG5eS9FZfC0fhCqpIIfObuAaH9atDc97Q4yFriuk=;
 b=FloYcqdO65lWm12l93p8AdyiELZ9DERNajWzmPuWRoaMnn1bDMtSYlxXqTQzt9LRnTlm
 EUdAfELS5RBb9jgDg9qzKTzxp0yR3DRxRgtjV3jbAP0PgR4Eluj1lne4iXgQvvpXR7Sy
 EdlpBnNCNzE6QkvE/n/GwpxjdgA50bzuSYJ5SPjbkkAoajha32Da0b3KfDOOTQ2lFxsm
 aW9bb/6q3s8YNe8h0U58opvB8Y6ZzV5hQiS3HLmMty5rQB4mX1pRCcOod0b3CRNJJ0UG
 KG4t4jXNrLxpLNTJ7VMnRjapYosimVVdnBFQnH7WJMJ9HqydmNXb6Onf1vEVDZSIzhFP YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0vrs2h43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:44 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGii8008651;
        Fri, 4 Feb 2022 21:16:44 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0vrs2h2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:44 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LD6GO009805;
        Fri, 4 Feb 2022 21:16:43 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3e0r0syf5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:42 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGbTd10682856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:37 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14DDF136067;
        Fri,  4 Feb 2022 21:16:37 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CF12136055;
        Fri,  4 Feb 2022 21:16:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:35 +0000 (GMT)
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
Subject: [PATCH v3 27/30] vfio-pci/zdev: wire up zPCI IOAT assist support
Date:   Fri,  4 Feb 2022 16:15:33 -0500
Message-Id: <20220204211536.321475-28-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: faDg9QKgv1C3ZEcPH9zrlpq8Ka3mWygU
X-Proofpoint-ORIG-GUID: WIYIs5fiYQDnG-WU7KYYh7k1kw72uxIe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=913 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for VFIO_DEVICE_FEATURE_ZPCI_IOAT, which is a new
VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
s390x vfio-pci device wishes to enable/disable zPCI I/O Address
Translation assistance, allowing the host to perform address translation
and shadowing.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  1 +
 drivers/vfio/pci/vfio_pci_core.c |  2 ++
 drivers/vfio/pci/vfio_pci_zdev.c | 58 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++
 include/uapi/linux/vfio.h        |  8 +++++
 include/uapi/linux/vfio_zdev.h   | 13 +++++++
 6 files changed, 92 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 93b61e61dc7f..71d27863ab97 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -31,6 +31,7 @@ struct kvm_zdev {
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
index 74508bdc5f88..f0a6e0f0e4b0 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -292,6 +292,63 @@ int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
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
+	/* If PROBE specified, return probe results immediately */
+	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
+		return kvm_s390_pci_ioat_probe(zdev);
+
+	size = sizeof(*feat) + sizeof(*data);
+	feat = kzalloc(size, GFP_KERNEL);
+	if (!feat)
+		return -ENOMEM;
+
+	data = (struct vfio_device_zpci_ioat *)&feat->data;
+	minsz = offsetofend(struct vfio_device_feature, flags);
+
+	if (feature.argsz < minsz + sizeof(*data))
+		return -EINVAL;
+
+	/* Get the rest of the payload for GET/SET */
+	rc = copy_from_user(data, (void __user *)(arg + minsz),
+			    sizeof(*data));
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
+	} else {
+		/* Neither GET nor SET were specified */
+		rc = -EINVAL;
+	}
+
+	kfree(feat);
+	return rc;
+}
+
 static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
 					unsigned long action, void *data)
 {
@@ -341,6 +398,7 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 */
 	if (zdev->gisa != 0) {
 		kvm_s390_pci_aif_disable(zdev, true);
+		kvm_s390_pci_ioat_disable(zdev);
 		kvm_s390_pci_interp_disable(zdev, true);
 	}
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 7ec5e82e7933..f17d761ae14e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -204,6 +204,9 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
 			   struct vfio_device_feature feature,
 			   unsigned long arg);
+int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
+			    struct vfio_device_feature feature,
+			    unsigned long arg);
 void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
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
 static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 }
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
index 09f413dfb1c3..b77e6ef355cb 100644
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

