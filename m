Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2248F151
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244827AbiANUdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244638AbiANUcn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:43 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQXIZ014111;
        Fri, 14 Jan 2022 20:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6p3MUkrnKnwluTBt7Q0nrMYCJH1aftp0ehjBVXOdxDc=;
 b=ht9PFqH7dCkEx1JWLBqpYOvLLM7gDFiXzm+mF8GgIua3gn363sQbgrD6Y+3lKw+8NmJp
 8u0ab4mLFSS10urGS0cRE5sINbyEB5bQhBHIDQ6tV6jBwyhDynhKxJcyfmVB7oh3g8Ul
 RP3r6ueYRB5rZD1GFXk+ICpNp1kgP7QtRrSf/grbvWwO6d7tJJBscwhIj4rgJm+xZh9o
 dkuk4YsvHeMfjHOOq0lcmFwHAiVNKYMBrOckhw5r4GYHg5NTcWQoy4CEOD6qHEKXxN/V
 0X58Snmvap1mGmMHpCWyFnIGcsAobezF/cf9ckfb+TdUP8DmSlHVqoA1ssADIctaOMOS Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a968-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:42 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKPD5R001325;
        Fri, 14 Jan 2022 20:32:42 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:42 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMZBo000318;
        Fri, 14 Jan 2022 20:32:41 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3df28de00p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:41 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWdeD13894084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:39 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC3B2C6066;
        Fri, 14 Jan 2022 20:32:39 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7857C6062;
        Fri, 14 Jan 2022 20:32:37 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:37 +0000 (GMT)
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
Subject: [PATCH v2 25/30] vfio-pci/zdev: wire up zPCI interpretive execution support
Date:   Fri, 14 Jan 2022 15:31:40 -0500
Message-Id: <20220114203145.242984-26-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2N4a2HAypvjXlIV_636wRuPPyBJyRi7-
X-Proofpoint-ORIG-GUID: yPutDLMmqJI8WJNnBkdLsy39TS_gUr68
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

Introduce support for VFIO_DEVICE_FEATURE_ZPCI_INTERP, which is a new
VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
s390x vfio-pci device wishes to enable/disable zPCI interpretive
execution, which allows zPCI instructions to be executed directly by
underlying firmware without KVM involvement.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h  |  1 +
 drivers/vfio/pci/vfio_pci_core.c |  2 +
 drivers/vfio/pci/vfio_pci_zdev.c | 78 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++
 include/uapi/linux/vfio.h        |  7 +++
 include/uapi/linux/vfio_zdev.h   | 15 ++++++
 6 files changed, 113 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 97a90b37c87d..dc00c3f27a00 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -35,6 +35,7 @@ struct kvm_zdev {
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 	struct notifier_block nb;
+	bool interp;
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
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
index 5c2bddc57b39..4339f48b98bc 100644
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
 
@@ -138,6 +142,72 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
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
+	/* If PROBE specified, return probe results immediately */
+	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
+		return kvm_s390_pci_interp_probe(zdev);
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
+	data = (struct vfio_device_zpci_interp *)&feat->data;
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
@@ -164,6 +234,7 @@ void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 		return;
 
 	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
+	zdev->kzdev->interp = false;
 
 	if (vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
 				   &events, &zdev->kzdev->nb))
@@ -180,5 +251,12 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
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
 }
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 05287f8ac855..0db2b1051931 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -198,6 +198,9 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
+			      struct vfio_device_feature feature,
+			      unsigned long arg);
 void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
 void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
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
 static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
 {
 }
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

