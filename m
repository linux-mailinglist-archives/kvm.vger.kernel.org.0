Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFDD46C5BB
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhLGVE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234179AbhLGVD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:59 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfNg022818;
        Tue, 7 Dec 2021 21:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zCOXOiU9XhXaSbENffiMYLSQGVJezGcAvp2HEJxEZG0=;
 b=k5d9D2BnqU97cRUUaJmppxBkYcEoOJUnkMrbFvQMdFUdPn8IlPEOlY1jsCrlFUDwX/YC
 N1MPVIUN15JwjJ16+QmjTEPTcizs5FPCaLF0qJwaKkuT7YOosFzYLiaTtdO9Sq91ndgV
 y15rEX6EzGr4F5odeB40z42JZE1+15mlY8gKfGCbqnB399H44Z1FU9dmbYPUC1/1HyYT
 3EPuO5c7wvfvp07Dqf8ZHxR+HMAwbS9rXzKe4ssv1BAd0a6PseT4SUzWc5tL+NidzOAV
 xLJj3q+w2x7zD0jsFYAoCr/yABYCmL1iik5zE9HofHGFUUR4aoefGSn4OWRwZVlSvwkL Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpdxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KlOVi003111;
        Tue, 7 Dec 2021 21:00:27 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxpdx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:27 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvuWb010261;
        Tue, 7 Dec 2021 21:00:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3cqyyamksm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:26 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L0OJr19137216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:24 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E350AE062;
        Tue,  7 Dec 2021 21:00:24 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECE58AE06A;
        Tue,  7 Dec 2021 21:00:18 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:00:18 +0000 (GMT)
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
Subject: [PATCH 28/32] vfio-pci/zdev: wire up zPCI adapter interrupt forwarding support
Date:   Tue,  7 Dec 2021 15:57:39 -0500
Message-Id: <20211207205743.150299-29-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TYKRkfZRWExElVdH_oPIP8dbxYPz7iTg
X-Proofpoint-GUID: Ar1PRKZ7XxW7GxzLsbc7WUUMHSEO7R2d
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

Introduce support for VFIO_DEVICE_FEATURE_ZPCI_AIF, which is a new
VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
s390x vfio-pci device wishes to enable/disable zPCI adapter interrupt
forwarding, which allows underlying firmware to deliver interrupts
directly to the associated kvm guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  2 +
 drivers/vfio/pci/vfio_pci_core.c |  2 +
 drivers/vfio/pci/vfio_pci_zdev.c | 96 +++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h    | 10 ++++
 include/uapi/linux/vfio.h        |  7 +++
 include/uapi/linux/vfio_zdev.h   | 20 +++++++
 6 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 062bac720428..0a0e42e1db1c 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -36,6 +36,8 @@ struct kvm_zdev {
 	struct zpci_fib fib;
 	struct notifier_block nb;
 	bool interp;
+	bool aif;
+	bool fhost;
 };
 
 extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2b2d64a2190c..01658de660bd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1174,6 +1174,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return 0;
 		case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
 			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
+		case VFIO_DEVICE_FEATURE_ZPCI_AIF:
+			return vfio_pci_zdev_feat_aif(vdev, feature, arg);
 		default:
 			return -ENOTTY;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index b205e0ad1fd3..dd98808b9139 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -13,6 +13,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/pci_insn.h>
 #include <asm/kvm_pci.h>
 
 #include <linux/vfio_pci_core.h>
@@ -206,6 +207,97 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 	return rc;
 }
 
+int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
+			   struct vfio_device_feature feature,
+			   unsigned long arg)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	struct vfio_device_zpci_aif *data;
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
+		rc = kvm_s390_pci_aif_probe(zdev);
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
+	data = (struct vfio_device_zpci_aif *)&feat->data;
+	minsz = offsetofend(struct vfio_device_feature, flags);
+
+	/* Get the rest of the payload for GET/SET */
+	rc = copy_from_user(data, (void __user *)(arg + minsz),
+			    sizeof(*data));
+	if (rc)
+		rc = -EINVAL;
+
+	if (feature.flags & VFIO_DEVICE_FEATURE_GET) {
+		if (zdev->kzdev->aif)
+			data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
+		if (zdev->kzdev->fhost)
+			data->flags |= VFIO_DEVICE_ZPCI_FLAG_AIF_HOST;
+
+		if (copy_to_user((void __user *)arg, feat, size))
+			rc = -EFAULT;
+	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
+		if (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT) {
+			/* create a guest fib */
+			struct zpci_fib fib;
+
+			fib.fmt0.aibv = data->ibv;
+			fib.fmt0.isc = data->isc;
+			fib.fmt0.noi = data->noi;
+			if (data->sb != 0) {
+				fib.fmt0.aisb = data->sb;
+				fib.fmt0.aisbo = data->sbo;
+				fib.fmt0.sum = 1;
+			} else {
+				fib.fmt0.aisb = 0;
+				fib.fmt0.aisbo = 0;
+				fib.fmt0.sum = 0;
+			}
+			if (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST) {
+				rc = kvm_s390_pci_aif_enable(zdev, &fib, false);
+				if (!rc) {
+					zdev->kzdev->aif = true;
+					zdev->kzdev->fhost = true;
+				}
+			} else {
+				rc = kvm_s390_pci_aif_enable(zdev, &fib, true);
+				if (!rc)
+					zdev->kzdev->aif = true;
+			}
+		} else if (data->flags == 0) {
+			rc = kvm_s390_pci_aif_disable(zdev);
+			if (!rc) {
+				zdev->kzdev->aif = false;
+				zdev->kzdev->fhost = false;
+			}
+		} else {
+			rc = -EINVAL;
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
@@ -259,8 +351,10 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 * If the device was using interpretation, don't trust that userspace
 	 * did the appropriate cleanup
 	 */
-	if (zdev->gd != 0)
+	if (zdev->gd != 0) {
+		kvm_s390_pci_aif_disable(zdev);
 		kvm_s390_pci_interp_disable(zdev);
+	}
 
 	kvm_s390_pci_dev_release(zdev);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 92dc43c827c9..5442d3fa1662 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -201,6 +201,9 @@ extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 			      struct vfio_device_feature feature,
 			      unsigned long arg);
+int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
+			   struct vfio_device_feature feature,
+			   unsigned long arg);
 int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
 #else
@@ -217,6 +220,13 @@ static inline int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 	return -ENOTTY;
 }
 
+static inline int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
+					 struct vfio_device_feature feature,
+					 unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b9a75485b8e7..fe3bfd99bf50 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1009,6 +1009,13 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
 
+/*
+ * Provide support for enbaling adapter interruption forwarding for zPCI
+ * devices.  This feature is only valid for s390x PCI devices.  Data provided
+ * when setting and getting this feature is further described in vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_AIF		(2)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index 575f0410dc66..c574e23f9385 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -90,4 +90,24 @@ struct vfio_device_zpci_interp {
 	__u32 fh;		/* Host device function handle */
 };
 
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_AIF
+ *
+ * This feature is used for enabling forwarding of adapter interrupts directly
+ * from firmware to the guest.  When setting this feature, the flags indicate
+ * whether to enable/disable the feature and the structure defined below is
+ * used to setup the forwarding structures.  When getting this feature, only
+ * the flags are used to indicate the current state.
+ */
+struct vfio_device_zpci_aif {
+	__u64 flags;
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2
+	__u64 ibv;		/* Address of guest interrupt bit vector */
+	__u64 sb;		/* Address of guest summary bit */
+	__u32 noi;		/* Number of interrupts */
+	__u8 isc;		/* Guest interrupt subclass */
+	__u8 sbo;		/* Offset of guest summary bit vector */
+};
+
 #endif
-- 
2.27.0

