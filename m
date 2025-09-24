Return-Path: <kvm+bounces-58683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A4781B9B05C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3FE024E17CB
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E0C31E0E5;
	Wed, 24 Sep 2025 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f26qYk6I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4680031B108;
	Wed, 24 Sep 2025 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734209; cv=none; b=jnVkH+FXdwLt9l/1dxa4j4Hjq5OZhRHce/oOPrJXJe91St2m5RT7kFm13CYsKVaLzoTgsrM9dvVS+13wH42XDwCOHZAZSIMSMojRXXmjKzcRgvarNRSnFzGK/KhUv+ooqfkQir5CX3VlzDjTvB5rg3VbHfWBrOzeZl3rPBT5/ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734209; c=relaxed/simple;
	bh=DCL2uNhkT2T1GieYn26W3SH3cIX9duxF8ftiep2wZr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAkhmnJ379MHbF2xJXKveqqj/JCBrUdVVbsewCUHsDbUg1GewnywQE141rlgvWscUL+oziP9QtNOCwwnBmJ8qc8sHN5NFEkWr+nFrc82Ylw2TNpTyPLKI+KR5pjazcbfQEDjJ6E57ikjtUIyJm3xRt/tFHMnX5lepjam1xCniU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f26qYk6I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OAOM0J006365;
	Wed, 24 Sep 2025 17:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VnzLReFLvODQ7n9Cj
	a1s1rdfqgjqZkjn+xZ4yhNDWBQ=; b=f26qYk6Iu+Q2rurDiS7dzGjsU6O2O1Ehg
	yrh8KPcfS9NrkueG1jR81bj+LbrN9hR10hmkpyEdIjDqxAqoRl1XzlYFOW0yjGTB
	LDt0VAAy+j61oDJyZ9p+0L7s6h1nd5f+y7RXebObZK1mBHUSFHblHlEuwRFXekUL
	fPpsxcv/ipyyV6Vb7WnnkYSS2cXArVTgivPlk6blXzXcmRj7P8SCoGtOQqli7fJZ
	R5ljwqoGBDrtJ0qXy7uF/mQbFs7LJFbH7nOYP9UN809BnuIbUa7LWQ9QNzrgr1BJ
	UvRtODy68ydKSfGtE7UkY8PDCsebnkUBnEFZ+vcbp3qCuYORJBbeA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyr5v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGpF7H031139;
	Wed, 24 Sep 2025 17:16:41 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vdar40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:41 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGdv320972232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:40 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5DC258064;
	Wed, 24 Sep 2025 17:16:39 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 287A55803F;
	Wed, 24 Sep 2025 17:16:39 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:39 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 08/10] vfio-pci/zdev: Add a device feature for error information
Date: Wed, 24 Sep 2025 10:16:26 -0700
Message-ID: <20250924171628.826-9-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924171628.826-1-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d4277a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=QIy8Zix3hhx26zbqT_4A:9
X-Proofpoint-GUID: Gw8VJVT5LJMgmQpsRZW-MrUmQxZXrjnj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfXw2xYmnTmIkpE
 RKVlqkxxd6vSyS+uNtOtqoh3BcwZQHQuK3U4XRBZX49MVktJk9lWoTStLDJPKhUVcaq1XkqRWE6
 Zej9XGv/jjAtFRCCnP+Aet3DDHvFAvl8r9fAcofAmZf+VeEXikbbPvK1bnM8zPC/8cZckUNRhIk
 SB+wnbVUhJ2rLcCv3eVl2Zu1VDz/bk6/hJXX5VbTPJFdc6j4Dpfpvg9vtADdRvf0E0J14rz+D0n
 miIuZBjmxDQYiR6i1FcSDyTabS1HwFk/HWFQC+xQ+6a2WZFRRwIKVUDDd2WTJogi6TT+CDG27Kn
 Uu4XQQGlTqyF50m3vPpnGPwE68EVuFyaPIF5/SBWupv0EW298KBXNc9I/1oWT+yQILu9+Vnyliw
 /OGDIBeU
X-Proofpoint-ORIG-GUID: Gw8VJVT5LJMgmQpsRZW-MrUmQxZXrjnj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015

For zPCI devices, we have platform specific error information. The platform
firmware provides this error information to the operating system in an
architecture specific mechanism. To enable recovery from userspace for
these devices, we want to expose this error information to userspace. Add a
new device feature to expose this information.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  2 ++
 drivers/vfio/pci/vfio_pci_priv.h |  8 ++++++++
 drivers/vfio/pci/vfio_pci_zdev.c | 34 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        | 15 ++++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..378adb3226db 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1514,6 +1514,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_ZPCI_ERROR:
+		return vfio_pci_zdev_feature_err(device, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index a9972eacb293..808d92aab76b 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -86,6 +86,8 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				struct vfio_info_cap *caps);
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
+int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
+			      void __user *arg, size_t argsz);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
@@ -100,6 +102,12 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 
 static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 {}
+
+static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
+				     void __user *arg, size_t argsz)
+{
+	return -ENODEV;
+}
 #endif
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2be37eab9279..261954039aa9 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -141,6 +141,40 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
+			      void __user *arg, size_t argsz)
+{
+	struct vfio_device_feature_zpci_err err;
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	int ret;
+	int head = 0;
+
+	if (!zdev)
+		return -ENODEV;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(err));
+	if (ret != 1)
+		return ret;
+
+	mutex_lock(&zdev->pending_errs_lock);
+	if (zdev->pending_errs.count) {
+		head = zdev->pending_errs.head % ZPCI_ERR_PENDING_MAX;
+		err.pec = zdev->pending_errs.err[head].pec;
+		zdev->pending_errs.head++;
+		zdev->pending_errs.count--;
+		err.pending_errors = zdev->pending_errs.count;
+	}
+	mutex_unlock(&zdev->pending_errs_lock);
+
+	if (copy_to_user(arg, &err, sizeof(err)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009ba..d72177bc3961 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1478,6 +1478,21 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_ERROR feature provides PCI error information to
+ * userspace for vfio-pci devices on s390x. On s390x PCI error recovery involves
+ * platform firmware and notification to operating system is done by
+ * architecture specific mechanism.  Exposing this information to userspace
+ * allows userspace to take appropriate actions to handle an error on the
+ * device.
+ */
+struct vfio_device_feature_zpci_err {
+	__u16 pec;
+	__u8 pending_errors;
+	__u8 pad;
+};
+#define VFIO_DEVICE_FEATURE_ZPCI_ERROR 11
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.43.0


