Return-Path: <kvm+bounces-39315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BD4A468F2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E533AFA62
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB5523BCE8;
	Wed, 26 Feb 2025 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tAE7qPR7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B3B234971;
	Wed, 26 Feb 2025 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593173; cv=none; b=TQB7IQUfb0mV8+L9GKer7pIfAxvrhple9nuo/XPx/FIw4TW2fZkboWilDb+ZuPcU0NAeovFmPylKWS/0Cv+V1hz79z1J1HujPZGD0ULflqGa8f3wusJwKyNl6o7gkauhIQIa9UJrcwV4C3oDbz7Qpa6Wqm8L7Z0SZRjFWQq2ncA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593173; c=relaxed/simple;
	bh=jYuDrVCIwnejG9OxLwwvZLHi34Cm0+HSAQnLAN2FIDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMZ0eDIzXVtkVDl7DqOnHSsyQ/FoGTZBY5alBoTk48ri304xDDybHSTah9chk8xsljzybTWzsiR3TVxbpNqp6SYPqJlGpFHRmS6u2FiSdL01/ErEqnzP49xVvbHR2lNVPJ2Oz4/SzEIJinxm1tjMqjQcsb08cjEj42S1yzNxt8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tAE7qPR7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QDrmCU008286;
	Wed, 26 Feb 2025 18:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Jv6Ju6jvCYWZDpsxF
	w375G6K0LM0i8G+SMZRC0/WaCI=; b=tAE7qPR7M4RP5Km1I84KoO+qm3CAUPcjc
	8i6O8IiSlVR3sVrrHYOIQZO3tLsPH8SoOTvRV7/euo6yoJvUkoXD4c4FNcKqpI6y
	k2FixeHU9i1RXtMp6V/JFsmsVt10OMxJ37ZYLNwE3W7f3GOeDG4FRyBRlCGjh+IT
	er4rOESPxO1mXhLuCh8e4nEGth8jpnZoKDDxYCxY4UBa1QiJwMDm/ZQ0PMJLFKVc
	C0V5PNRe3BUvqU5W/j4QR4OxwGYnXO8stniedJL4P1CvgEZAG9LK0IINQCvIHa39
	LORU6KpoJcwLsNNgDryGO18mt5jV3uZ4ySiVX/Zn28Zyx/ahd3/Og==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451ssym83w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QHU99F012918;
	Wed, 26 Feb 2025 18:06:08 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwsvdhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:06:08 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI676m31261216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:06:07 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0D705805A;
	Wed, 26 Feb 2025 18:06:07 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0327A58056;
	Wed, 26 Feb 2025 18:06:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:06:06 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v3 1/2] s390/vfio-ap: Signal eventfd when guest AP configuration is changed
Date: Wed, 26 Feb 2025 13:06:04 -0500
Message-ID: <20250226180605.15810-2-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250226180605.15810-1-rreyes@linux.ibm.com>
References: <20250226180605.15810-1-rreyes@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RQKWeTwH61Mfbx3G-ioRoLPvub_n7fiR
X-Proofpoint-GUID: RQKWeTwH61Mfbx3G-ioRoLPvub_n7fiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142

In this patch, an eventfd object is created by the vfio_ap device driver
and used to notify userspace when a guests's AP configuration is
dynamically changed. Such changes may occur whenever:

* An adapter, domain or control domain is assigned to or unassigned from a
  mediated device that is attached to the guest.
* A queue assigned to the mediated device that is attached to a guest is
  bound to or unbound from the vfio_ap device driver. This can occur
  either by manually binding/unbinding the queue via the vfio_ap driver's
  sysfs bind/unbind attribute interfaces, or because an adapter, domain or
  control domain assigned to the mediated device is added to or removed
  from the host's AP configuration via an SE/HMC

Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Anthony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 51 ++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 include/uapi/linux/vfio.h             |  1 +
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..9a6845064ff3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -650,13 +650,22 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->nd : 15;
 }
 
+static void signal_guest_ap_cfg_changed(struct ap_matrix_mdev *matrix_mdev)
+{
+		if (matrix_mdev->cfg_chg_trigger)
+			eventfd_signal(matrix_mdev->cfg_chg_trigger);
+}
+
 static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev *matrix_mdev)
 {
-	if (matrix_mdev->kvm)
+	if (matrix_mdev->kvm) {
 		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
 					  matrix_mdev->shadow_apcb.apm,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
+
+		signal_guest_ap_cfg_changed(matrix_mdev);
+	}
 }
 
 static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
@@ -792,6 +801,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	if (ret)
 		goto err_put_vdev;
 	matrix_mdev->req_trigger = NULL;
+	matrix_mdev->cfg_chg_trigger = NULL;
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
@@ -2097,6 +2107,10 @@ static ssize_t vfio_ap_get_irq_info(unsigned long arg)
 		info.count = 1;
 		info.flags = VFIO_IRQ_INFO_EVENTFD;
 		break;
+	case VFIO_AP_CFG_CHG_IRQ_INDEX:
+		info.count = 1;
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2160,6 +2174,39 @@ static int vfio_ap_set_request_irq(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
+{
+	s32 fd;
+	void __user *data;
+	unsigned long minsz;
+	struct eventfd_ctx *cfg_chg_trigger;
+
+	minsz = offsetofend(struct vfio_irq_set, count);
+	data = (void __user *)(arg + minsz);
+
+	if (get_user(fd, (s32 __user *)data))
+		return -EFAULT;
+
+	if (fd == -1) {
+		if (matrix_mdev->cfg_chg_trigger)
+			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
+		matrix_mdev->cfg_chg_trigger = NULL;
+	} else if (fd >= 0) {
+		cfg_chg_trigger = eventfd_ctx_fdget(fd);
+		if (IS_ERR(cfg_chg_trigger))
+			return PTR_ERR(cfg_chg_trigger);
+
+		if (matrix_mdev->cfg_chg_trigger)
+			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
+
+		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
 			    unsigned long arg)
 {
@@ -2175,6 +2222,8 @@ static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
 		switch (irq_set.index) {
 		case VFIO_AP_REQ_IRQ_INDEX:
 			return vfio_ap_set_request_irq(matrix_mdev, arg);
+		case VFIO_AP_CFG_CHG_IRQ_INDEX:
+			return vfio_ap_set_cfg_change_irq(matrix_mdev, arg);
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 437a161c8659..37de9c69b6eb 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -105,6 +105,7 @@ struct ap_queue_table {
  * @mdev:	the mediated device
  * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
  * @req_trigger eventfd ctx for signaling userspace to return a device
+ * @cfg_chg_trigger eventfd ctx to signal AP config changed to userspace
  * @apm_add:	bitmap of APIDs added to the host's AP configuration
  * @aqm_add:	bitmap of APQIs added to the host's AP configuration
  * @adm_add:	bitmap of control domain numbers added to the host's AP
@@ -120,6 +121,7 @@ struct ap_matrix_mdev {
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
 	struct eventfd_ctx *req_trigger;
+	struct eventfd_ctx *cfg_chg_trigger;
 	DECLARE_BITMAP(apm_add, AP_DEVICES);
 	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
 	DECLARE_BITMAP(adm_add, AP_DOMAINS);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c8dbf8219c4f..a2d3e1ac6239 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -671,6 +671,7 @@ enum {
  */
 enum {
 	VFIO_AP_REQ_IRQ_INDEX,
+	VFIO_AP_CFG_CHG_IRQ_INDEX,
 	VFIO_AP_NUM_IRQS
 };
 
-- 
2.48.1


