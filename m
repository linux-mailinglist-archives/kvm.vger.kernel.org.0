Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9044E48F155
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbiANUdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244523AbiANUcr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:47 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQYdp014116;
        Fri, 14 Jan 2022 20:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EfHBBjEFrPcmFKlYc3PQdVOL7gpLg6eJb/PlnVvKf8o=;
 b=nTr57IETCkvT+EH85hH6X1mCtLOLWHghE5bUUK4agdb3ZYdcbsoW8RscS4mUMg8KOftS
 aWAteZn9f+7EgKo3LZRt6jOmVuZ/AI1t2FUtawR9m85W/eNkICpO5JFelIYru85nev+8
 /zKfa9M5LSurMHmGI/rUJTJMyg77mt8EsSaTXqcM62lAHIitzaE6c+DfOZs0mHFPX2Cb
 OgAz1gCmoOfLci56wmcB/WeVuMlpILFi8fQCzHyV0D/XtZmlEQRtBkQiFeGD85oedmUu
 ZVOpaxyKNqJ+onroLE4xTqT3cC8lyfRpU9HEXfKNGzfO69gQQnYtd3aQnY5tliABU6Ts VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a97g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKGoS0001790;
        Fri, 14 Jan 2022 20:32:46 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a973-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:46 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMVnI006483;
        Fri, 14 Jan 2022 20:32:45 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3df28de8ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:45 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWhEn18874652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:43 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96013C606C;
        Fri, 14 Jan 2022 20:32:43 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF4F4C6066;
        Fri, 14 Jan 2022 20:32:41 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:41 +0000 (GMT)
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
Subject: [PATCH v2 27/30] vfio-pci/zdev: wire up zPCI IOAT assist support
Date:   Fri, 14 Jan 2022 15:31:42 -0500
Message-Id: <20220114203145.242984-28-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yiN27S2wqbTr1IAOukC0X3zVJ5L5K5gn
X-Proofpoint-ORIG-GUID: 8JwFSY6oOROGJv_N73T2uMn4OArkzX5Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=993 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
 drivers/vfio/pci/vfio_pci_core.c |  2 +
 drivers/vfio/pci/vfio_pci_zdev.c | 63 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 +++++
 include/uapi/linux/vfio.h        |  8 ++++
 include/uapi/linux/vfio_zdev.h   | 13 +++++++
 6 files changed, 97 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index dbab349a4a75..7b6b6d771026 100644
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
index 891cfa016d63..2b169d688937 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -302,6 +302,68 @@ int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
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
+	/* GET and SET are mutually exclusive */
+	if ((feature.flags & VFIO_DEVICE_FEATURE_GET) &&
+	    (feature.flags & VFIO_DEVICE_FEATURE_SET))
+		return -EINVAL;
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
@@ -351,6 +413,7 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 */
 	if (zdev->gd != 0) {
 		kvm_s390_pci_aif_disable(zdev);
+		kvm_s390_pci_ioat_disable(zdev);
 		kvm_s390_pci_interp_disable(zdev);
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

