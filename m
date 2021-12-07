Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CA246C5B8
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhLGVE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33824 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238370AbhLGVDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:53 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JqE8p028732;
        Tue, 7 Dec 2021 21:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eAAE/bwm0nqeXrvGqzDAS8ZWmVWFmpp6PBH3rpnZrXQ=;
 b=KRtu0dMDxrodmIfSNs5C1PO5dkBb5Ewv4IYpz4ZYy7Sekx6DPZjMGzhx6ULZ3gtSsViD
 XNXqH9jOAhxDRgElf4cpVSHnbZTFcZ2oSL7/wzsmyxMw93Z8X9FVt95/hHkcimSRHElt
 9+UwD6/m/9e9Ez+a3lNkRUcaupXjSQzpXl6JIoPSvKbTPAIpUocrY5g33CdMKuljiu6I
 xhFB4GxNmAzcS7zR1tTSHHEfTU46ZX3wC/3EwKbUGuMwfrgVwwJaL6GyLuDUcBoZ7SqP
 JGR7PtQ0Yz0nUczZXlc0LUYrb+PYfNBqEHXVbtNrLQ+I8WSCAl65lgt2cWZHz+hTv0Yh kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cte5ah822-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:21 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KU6PR016088;
        Tue, 7 Dec 2021 21:00:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cte5ah81k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kx9O9004013;
        Tue, 7 Dec 2021 21:00:20 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3cqyyb34md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:20 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L0ImX55181636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57F66AE06A;
        Tue,  7 Dec 2021 21:00:18 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E380AE068;
        Tue,  7 Dec 2021 21:00:13 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:00:13 +0000 (GMT)
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
Subject: [PATCH 27/32] vfio-pci/zdev: wire up zPCI interpretive execution support
Date:   Tue,  7 Dec 2021 15:57:38 -0500
Message-Id: <20211207205743.150299-28-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OW6MNuxIHP1s3xtYKH8d3lrLiSGj2CEY
X-Proofpoint-ORIG-GUID: S5NoAIfSFoZYAewr5SR5d-Tr4IXWSbnD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for VFIO_DEVICE_FEATURE_ZPCI_INTERP, which is a new
VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
s390x vfio-pci device wishes to enable/disable zPCI interpretive
execution, which allows zPCI instructions to be executed directly by
underlying firmware without KVM involvement.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  1 +
 drivers/vfio/pci/vfio_pci_core.c |  2 +
 drivers/vfio/pci/vfio_pci_zdev.c | 76 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 +++++
 include/uapi/linux/vfio.h        |  7 +++
 include/uapi/linux/vfio_zdev.h   | 15 +++++++
 6 files changed, 111 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 6526908ac834..062bac720428 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -35,6 +35,7 @@ struct kvm_zdev {
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 	struct notifier_block nb;
+	bool interp;
 };
 
 extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index fc57d4d0abbe..2b2d64a2190c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1172,6 +1172,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			mutex_unlock(&vdev->vf_token->lock);
 
 			return 0;
+		case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
+			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
 		default:
 			return -ENOTTY;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index cfd7f44b06c1..b205e0ad1fd3 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -54,6 +54,10 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
 		.version = zdev->version
 	};
 
+	/* Some values are different for interpreted devices */
+	if (zdev->kzdev && zdev->kzdev->interp)
+		cap.maxstbl = zdev->maxstbl;
+
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
 }
 
@@ -138,6 +142,70 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
+			      struct vfio_device_feature feature,
+			      unsigned long arg)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	struct vfio_device_zpci_interp *data;
+	struct vfio_device_feature *feat;
+	unsigned long minsz;
+	int size, rc;
+
+	if (!zdev || !zdev->kzdev)
+		return -EINVAL;
+
+	/*
+	 * If PROBE requested and feature not found, leave immediately.
+	 * Otherwise, keep going as GET or SET may also be specified.
+	 */
+	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE) {
+		rc = kvm_s390_pci_interp_probe(zdev);
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
+	data = (struct vfio_device_zpci_interp *)&feat->data;
+	minsz = offsetofend(struct vfio_device_feature, flags);
+
+	/* Get the rest of the payload for GET/SET */
+	rc = copy_from_user(data, (void __user *)(arg + minsz),
+			    sizeof(*data));
+	if (rc)
+		rc = -EINVAL;
+
+	if (feature.flags & VFIO_DEVICE_FEATURE_GET) {
+		if (zdev->gd != 0)
+			data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
+		else
+			data->flags = 0;
+		data->fh = zdev->fh;
+		/* userspace is using host fh, give interpreted clp values */
+		zdev->kzdev->interp = true;
+
+		if (copy_to_user((void __user *)arg, feat, size))
+			rc = -EFAULT;
+	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
+		if (data->flags == VFIO_DEVICE_ZPCI_FLAG_INTERP)
+			rc = kvm_s390_pci_interp_enable(zdev);
+		else if (data->flags == 0)
+			rc = kvm_s390_pci_interp_disable(zdev);
+		else
+			rc = -EINVAL;
+	}
+
+	kfree(feat);
+	return rc;
+}
+
 static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
 					unsigned long action, void *data)
 {
@@ -167,6 +235,7 @@ int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 		return -ENODEV;
 
 	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
+	zdev->kzdev->interp = false;
 
 	ret = vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
 				     &events, &zdev->kzdev->nb);
@@ -186,6 +255,13 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
 	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
 				 &zdev->kzdev->nb);
 
+	/*
+	 * If the device was using interpretation, don't trust that userspace
+	 * did the appropriate cleanup
+	 */
+	if (zdev->gd != 0)
+		kvm_s390_pci_interp_disable(zdev);
+
 	kvm_s390_pci_dev_release(zdev);
 
 	return 0;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 14079da409f1..92dc43c827c9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -198,6 +198,9 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
+			      struct vfio_device_feature feature,
+			      unsigned long arg);
 int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
 #else
@@ -207,6 +210,13 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 	return -ENODEV;
 }
 
+static inline int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
+					    struct vfio_device_feature feature,
+					    unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..b9a75485b8e7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1002,6 +1002,13 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Provide support for enabling interpretation of zPCI instructions.  This
+ * feature is only valid for s390x PCI devices.  Data provided when setting
+ * and getting this feature is futher described in vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b4309397b6b2..575f0410dc66 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -75,4 +75,19 @@ struct vfio_device_info_cap_zpci_pfip {
 	__u8 pfip[];
 };
 
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_INTERP
+ *
+ * This feature is used for enabling zPCI instruction interpretation for a
+ * device.  No data is provided when setting this feature.  When getting
+ * this feature, the following structure is provided which details whether
+ * or not interpretation is active and provides the guest with host device
+ * information necessary to enable interpretation.
+ */
+struct vfio_device_zpci_interp {
+	__u64 flags;
+#define VFIO_DEVICE_ZPCI_FLAG_INTERP 1
+	__u32 fh;		/* Host device function handle */
+};
+
 #endif
-- 
2.27.0

