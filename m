Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1848F158
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbiANUdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244379AbiANUcq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:46 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQUM3014012;
        Fri, 14 Jan 2022 20:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rT+9e464VvJ6fZSuWdY4/cbl6V8Pei1wOAktnxjQ3jw=;
 b=grIZN730zHc1gKXZGRA+rD50X6bsv63pXf1pKZj/SkMT9YLifSE2qKiKIs4sn+qrjExm
 OndzgrvWapK0J5mq+bQkp5BVCsUeQtTdFtVmY2c0DBNo3eJVurMsmKJcivzoQpvArhlT
 aW1FScWS8nzZItg2z5AavNhAdhQSEPP5XvK82Xc9ifH9oTIUUyWTgaVRDMNuoxDVNqNL
 goXtj2q6DsHDWix2b38zvU21QnLjIa9x7I+Fe9CTG46VcIQCfaBxft1LnTYscXW6cL0d
 hgmH5bxr7pzKeU0HB4cbF+PgS+eq98MPmw786sp949YByAEBzgbtvxhPlMaItZk0Umej eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a978-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EJwX5p006598;
        Fri, 14 Jan 2022 20:32:45 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a96p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:45 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLiEP024016;
        Fri, 14 Jan 2022 20:32:44 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3djknt7pd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:44 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWf3433489204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:41 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A34CDC6069;
        Fri, 14 Jan 2022 20:32:41 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDA90C6062;
        Fri, 14 Jan 2022 20:32:39 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:39 +0000 (GMT)
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
Subject: [PATCH v2 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt forwarding support
Date:   Fri, 14 Jan 2022 15:31:41 -0500
Message-Id: <20220114203145.242984-27-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -Z4nZGBh_K1CfuWenaGiNuqrRCLYqKIY
X-Proofpoint-ORIG-GUID: _RmE4wTISuZnu0mjoEux3YbfvVt2GSWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
 drivers/vfio/pci/vfio_pci_zdev.c | 98 +++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h    | 10 ++++
 include/uapi/linux/vfio.h        |  7 +++
 include/uapi/linux/vfio_zdev.h   | 20 +++++++
 6 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index dc00c3f27a00..dbab349a4a75 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -36,6 +36,8 @@ struct kvm_zdev {
 	struct zpci_fib fib;
 	struct notifier_block nb;
 	bool interp;
+	bool aif;
+	bool fhost;
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
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
index 4339f48b98bc..891cfa016d63 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -13,6 +13,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/pci_insn.h>
 #include <asm/kvm_pci.h>
 
 #include <linux/vfio_pci_core.h>
@@ -208,6 +209,99 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
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
+	/* If PROBE specified, return probe results immediately */
+	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
+		return kvm_s390_pci_aif_probe(zdev);
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
+	data = (struct vfio_device_zpci_aif *)&feat->data;
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
@@ -255,8 +349,10 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 * If the device was using interpretation, don't trust that userspace
 	 * did the appropriate cleanup
 	 */
-	if (zdev->gd != 0)
+	if (zdev->gd != 0) {
+		kvm_s390_pci_aif_disable(zdev);
 		kvm_s390_pci_interp_disable(zdev);
+	}
 
 	kvm_s390_pci_dev_release(zdev);
 }
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 0db2b1051931..7ec5e82e7933 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -201,6 +201,9 @@ extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
 			      struct vfio_device_feature feature,
 			      unsigned long arg);
+int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
+			   struct vfio_device_feature feature,
+			   unsigned long arg);
 void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
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
 static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 }
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

