Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDA84AA220
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiBDVRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242261AbiBDVQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JISBS014077;
        Fri, 4 Feb 2022 21:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FWjFSaRPht29NMO90t+5jrhFSHKPxQTtRHppwgqjTJk=;
 b=pm3sXTdlvdJEIzp/h8x6WsAamwrkoCSn/vhOpEXLFUo/og9scxOo64eIfSXJaFegjxnM
 aPMs/yJtfy3e+AjT/v1qqhA1HeyeLh6c9uP1pUHSN39IZSO9/jLdCNJfySs3TODenlQy
 smY9bnLNbFFcYazK5NVeS9gKxqU7LDJ7DQFWslnNY7KQPbcAVXnc6/9bA/iJkkWizyjh
 S4vha/0VPT7ktO4zWGc3zkXFARF6v+dQqmAGdsjc/IECg9hjrw8xbhWBHHozFBJ0Mwoa
 lw14qlN4UQGfc+8ynnl77yJ6ww1XC3GxO/HuPEGmpnQTDt+J7tOw8H80dQ4QqS3lbxFu Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx2xbx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:39 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214L59Yt017923;
        Fri, 4 Feb 2022 21:16:38 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx2xbvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:38 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCfF4011934;
        Fri, 4 Feb 2022 21:16:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3e0r0m2wps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:36 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGZ6K31588750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F210136051;
        Fri,  4 Feb 2022 21:16:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46FC813604F;
        Fri,  4 Feb 2022 21:16:33 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:33 +0000 (GMT)
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
Subject: [PATCH v3 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt forwarding support
Date:   Fri,  4 Feb 2022 16:15:32 -0500
Message-Id: <20220204211536.321475-27-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h-teyLXKmtKY9AidnMW7LiRhLkdw8x7U
X-Proofpoint-GUID: YRNINeFJgNaul2_ZnHlh3doTX8eQZvyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
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
 drivers/vfio/pci/vfio_pci_zdev.c | 93 +++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h    | 10 ++++
 include/uapi/linux/vfio.h        |  7 +++
 include/uapi/linux/vfio_zdev.h   | 20 +++++++
 6 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 8f7d371e3e59..93b61e61dc7f 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -35,6 +35,8 @@ struct kvm_zdev {
 	struct zpci_fib fib;
 	struct notifier_block nb;
 	bool interpretation;
+	bool aif_float; /* Enabled for floating interrupt assist */
+	bool aif_host; /* Require host delivery */
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
index 71cc1eb8085f..74508bdc5f88 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -13,6 +13,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/pci_insn.h>
 #include <asm/kvm_pci.h>
 
 #include <linux/vfio_pci_core.h>
@@ -203,6 +204,94 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
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
+		if (zdev->kzdev->aif_float)
+			data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
+		if (zdev->kzdev->aif_host)
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
+					zdev->kzdev->aif_float = true;
+					zdev->kzdev->aif_host = true;
+				}
+			} else {
+				rc = kvm_s390_pci_aif_enable(zdev, &fib, true);
+				if (!rc)
+					zdev->kzdev->aif_float = true;
+			}
+		} else if (data->flags == 0) {
+			rc = kvm_s390_pci_aif_disable(zdev, false);
+			if (!rc) {
+				zdev->kzdev->aif_float = false;
+				zdev->kzdev->aif_host = false;
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
@@ -250,8 +339,10 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	 * If the device was using interpretation, don't trust that userspace
 	 * did the appropriate cleanup
 	 */
-	if (zdev->gisa != 0)
+	if (zdev->gisa != 0) {
+		kvm_s390_pci_aif_disable(zdev, true);
 		kvm_s390_pci_interp_disable(zdev, true);
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
index 575f0410dc66..09f413dfb1c3 100644
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
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1	/* Enable floating interrupts */
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2	/* Force host delivery */
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

