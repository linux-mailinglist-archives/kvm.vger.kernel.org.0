Return-Path: <kvm+bounces-39174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A8CA44C2F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8151E3ABDDF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADFA20E6F0;
	Tue, 25 Feb 2025 20:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="to3Tt1Mi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BEB20E6FC;
	Tue, 25 Feb 2025 20:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514339; cv=none; b=Am8ZUGwXOq/su+SvCkz7LwYgbxiEo5+5QBQkkegEJT/HvqOrijrbYDIQ1cauKeSxzLHBiGK4tdATYPmxm/9KK10BL8FeHr4vaqH11J7jy+bcrZaLRSrevXcBBGLmeFn6SQsJHXqgGAZ5vDSH4Jp/XqA97jl7nlZ9AOioYhsBQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514339; c=relaxed/simple;
	bh=jyfgZ7hdGQ+7vkMlHbZAbEyF8hHA3oXzDRcU6/jBrqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpP2dlkNijqjFyjLU84zN9TMOC4Ev46ucjxNWbyqH6+GLXPfV1j+yS5Gd8fasroRH0J48VaQI73EtX7sKQU746HdXx/oqQCLZ9O8Jg7r0Zc7iFG53e4fSfPwEJr4kAwmnHO0hQ244HeqVQuEFcDVR3xyQ2aCj3KaYYhlBac1YlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=to3Tt1Mi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PDjZZJ022687;
	Tue, 25 Feb 2025 20:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qucujcqLhUwdL3YtH
	IiokciTxPKndQxWgwwJYybcvak=; b=to3Tt1Mirf0GMzvm3DSixxZm/4IeUJcxe
	+ttQU6Yfm8jGNtjYz/D0Bo6i6VwTq1RSKKIsvX9+auOTbR9jSwCmscpxVKWkOkaW
	0NJGTwxH3fMFLcvJdOKzAMBDuzEVE4dgq3rzXT48x9lW21gDSkCtR3kfXWVaZ8zZ
	D/7P8SvJmUg2jmcD0JEciFIdry3RB2VfWoGvFz5lqjgLTEd4QZd60TCaP12Ehq6X
	1FETEALRnEzQevcfYnp8ilVltq4XbJAvq2APJfpTdkGuXI76+Ft+4elwiQj0D5ZU
	fXn2QCpIhPHoe0ABYrxxsCnluOE1/WbmHjzaKjdL5dXbAFKn77bOA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4511wadnuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51PImcGV027327;
	Tue, 25 Feb 2025 20:12:12 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum1xf2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:12 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51PKCA8f26083900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 20:12:11 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8DB35805D;
	Tue, 25 Feb 2025 20:12:10 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD23A58056;
	Tue, 25 Feb 2025 20:12:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.252.67])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 20:12:09 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2 1/2] s390/vfio-ap: Signal eventfd when guest AP configuration is changed
Date: Tue, 25 Feb 2025 15:12:07 -0500
Message-ID: <20250225201208.45998-2-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250225201208.45998-1-rreyes@linux.ibm.com>
References: <20250225201208.45998-1-rreyes@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o1_vwFadUed6wrEB6htETVmQiFZBw5xI
X-Proofpoint-ORIG-GUID: o1_vwFadUed6wrEB6htETVmQiFZBw5xI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502250120

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
 drivers/s390/crypto/vfio_ap_ops.c     | 52 ++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 include/uapi/linux/vfio.h             |  1 +
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..c6ff4ab13f16 100644
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
@@ -1860,6 +1870,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
+		signal_guest_ap_cfg_changed(matrix_mdev);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
@@ -2097,6 +2108,10 @@ static ssize_t vfio_ap_get_irq_info(unsigned long arg)
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
@@ -2160,6 +2175,39 @@ static int vfio_ap_set_request_irq(struct ap_matrix_mdev *matrix_mdev,
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
@@ -2175,6 +2223,8 @@ static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
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
2.39.5 (Apple Git-154)


