Return-Path: <kvm+bounces-38892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D418A40021
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA1E1424CD3
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D281FF1BB;
	Fri, 21 Feb 2025 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X5UAYwRD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429E254AF5;
	Fri, 21 Feb 2025 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167785; cv=none; b=aQnPnr/xKrwL9mllkk+XoyDRjHavamiu6snMKinWuenBE99MWmAm2UPdng0hRnmJROwE9H/BOzbmyf/m6YIgrdUBDITZ3ZEUwofNBcwBG5KBPF1p8OL6CTJZSXjlJ4J737LyUs89bY+73sQRtibMGOVlK/dbyza1tVaRqNd/CFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167785; c=relaxed/simple;
	bh=B85ecng4+WBDaQn0BDJdTdtlV91NQm0ESB9mugDHRwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S8PUnZWl+6ofRytqAHR1cnykZ4aGJb85TID/FZcxXX/bGYTjGdFEdx6tRZCE87qcc30JieHgnOtXvQxe8TgU2oROsdhrdGK3t/YxRqsOZwqhhfr7KvZhd3ZB/PNWACdHuOizax63yw7z+IUkidZv0kb9lkvMOoDJdFl1TD0TXRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X5UAYwRD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51LIMeHH024272;
	Fri, 21 Feb 2025 19:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=f5EO5rEvUaey+44nLpKjKoylaR3zqElhHJULhDgoO
	OQ=; b=X5UAYwRDj9L1CmbOf3eSZWQ8sZ+nCxplUSXwdB+6YeqBEKePxpEBdsHNN
	HMaTg0qshqrUrsgA5dqFGsXuFhlIpBGRD9Vear/VsR3Poup2Al3U0bQff9Abualn
	g3C/uvq1YBg64yuL8p/9TRULaX22FRnpRyP43oYJlF5an2waM4A9s9yxf+67DYt5
	ZVRVa96o+G3Hgmr+ydS/8ci+XP6vBsq+ewjfF2BOcfsdSryDf9EIeIrxw3/twVA4
	rG+QPOq2AFyZKUM1ws59UWo3G3hF7CgX6YUwQuKWXsLIqPY6WMqN8l77uQPgj9KM
	nbQDov56Y7ZdNUpBS8p09PWLbF8Jg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xm753x5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 19:56:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51LJCats002330;
	Fri, 21 Feb 2025 19:56:20 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w03xhv88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 19:56:20 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51LJuIjk20054280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 19:56:18 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60E635806C;
	Fri, 21 Feb 2025 19:56:18 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CD2F5805D;
	Fri, 21 Feb 2025 19:56:17 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.107.75])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Feb 2025 19:56:17 +0000 (GMT)
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: pasic@linux.ibm.com, jjherne@linux.ibm.com, freude@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        alex.williamson@redhat.com, clg@redhat.com, mjrosato@linux.ibm.com
Subject: [PATCH v2] s390/vio-ap: Fix no AP queue sharing allowed message written to kernel log
Date: Fri, 21 Feb 2025 14:56:09 -0500
Message-ID: <20250221195616.3281531-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Tw-0jtkpEDZUAP0j0TR16xLbRAEGrNOA
X-Proofpoint-GUID: Tw-0jtkpEDZUAP0j0TR16xLbRAEGrNOA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_07,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210134

An erroneous message is written to the kernel log when either of the
following actions are taken by a user:

1. Assign an adapter or domain to a vfio_ap mediated device via its sysfs
   assign_adapter or assign_domain attributes that would result in one or
   more AP queues being assigned that are already assigned to a different
   mediated device. Sharing of queues between mdevs is not allowed.

2. Reserve an adapter or domain for the host device driver via the AP bus
   driver's sysfs apmask or aqmask attribute that would result in providing
   host access to an AP queue that is in use by a vfio_ap mediated device.
   Reserving a queue for a host driver that is in use by an mdev is not
   allowed.

In both cases, the assignment will return an error; however, a message like
the following is written to the kernel log:

vfio_ap_mdev e1839397-51a0-4e3c-91e0-c3b9c3d3047d: Userspace may not
re-assign queue 00.0028 already assigned to \
e1839397-51a0-4e3c-91e0-c3b9c3d3047d

Notice the mdev reporting the error is the same as the mdev identified
in the message as the one to which the queue is being assigned.
It is perfectly okay to assign a queue to an mdev to which it is
already assigned; the assignment is simply ignored by the vfio_ap device
driver.

This patch logs more descriptive and accurate messages for both 1 and 2
above to the kernel log:

Example for 1:
vfio_ap_mdev 0fe903a0-a323-44db-9daf-134c68627d61: Userspace may not assign
queue 00.0033 to mdev: already assigned to \
62177883-f1bb-47f0-914d-32a22e3a8804

Example for 2:
vfio_ap_mdev 62177883-f1bb-47f0-914d-32a22e3a8804: Can not reserve queue
00.0033 for host driver: in use by mdev

Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 82 +++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..3193786c83e2 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -863,48 +863,68 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	vfio_put_device(&matrix_mdev->vdev);
 }
 
-#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
-			 "already assigned to %s"
+#define MDEV_SHARING_ERR "Userspace may not assign queue %02lx.%04lx to mdev: already assigned to %s"
 
-static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *matrix_mdev,
-					 unsigned long *apm,
-					 unsigned long *aqm)
+#define MDEV_IN_USE_ERR "Can not reserve queue %02lx.%04lx for host driver: in use by mdev"
+
+static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *assignee,
+					 struct ap_matrix_mdev *assigned_to,
+					 unsigned long *apm, unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
+				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev)));
+		}
+	}
+}
+
+static void vfio_ap_mdev_log_in_use_err(struct ap_matrix_mdev *assignee,
+					unsigned long *apm, unsigned long *aqm)
 {
 	unsigned long apid, apqi;
-	const struct device *dev = mdev_dev(matrix_mdev->mdev);
-	const char *mdev_name = dev_name(dev);
 
-	for_each_set_bit_inv(apid, apm, AP_DEVICES)
-		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
-			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			dev_warn(mdev_dev(assignee->mdev), MDEV_IN_USE_ERR,
+				 apid, apqi);
+		}
+	}
 }
 
 /**
  * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
  *
+ * @assignee: the matrix mdev to which @mdev_apm and @mdev_aqm are being
+ *            assigned; or, NULL if this function was called by the AP bus
+ *            driver in_use callback to verify none of the APQNs being reserved
+ *            for the host device driver are in use by a vfio_ap mediated device
  * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
  * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
  *
- * Verifies that each APQN derived from the Cartesian product of a bitmap of
- * AP adapter IDs and AP queue indexes is not configured for any matrix
- * mediated device. AP queue sharing is not allowed.
+ * Verifies that each APQN derived from the Cartesian product of APIDs
+ * represented by the bits set in @mdev_apm and the APQIs of the bits set in
+ * @mdev_aqm is not assigned to a mediated device other than the mdev to which
+ * the APQN is being assigned (@assignee). AP queue sharing is not allowed.
  *
  * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
  */
-static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
+static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *assignee,
+					  unsigned long *mdev_apm,
 					  unsigned long *mdev_aqm)
 {
-	struct ap_matrix_mdev *matrix_mdev;
+	struct ap_matrix_mdev *assigned_to;
 	DECLARE_BITMAP(apm, AP_DEVICES);
 	DECLARE_BITMAP(aqm, AP_DOMAINS);
 
-	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+	list_for_each_entry(assigned_to, &matrix_dev->mdev_list, node) {
 		/*
-		 * If the input apm and aqm are fields of the matrix_mdev
-		 * object, then move on to the next matrix_mdev.
+		 * If the mdev to which the mdev_apm and mdev_aqm is being
+		 * assigned is the same as the mdev being verified
 		 */
-		if (mdev_apm == matrix_mdev->matrix.apm &&
-		    mdev_aqm == matrix_mdev->matrix.aqm)
+		if (assignee == assigned_to)
 			continue;
 
 		memset(apm, 0, sizeof(apm));
@@ -914,15 +934,22 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, mdev_apm, matrix_mdev->matrix.apm,
-				AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, assigned_to->matrix.apm,
+				AP_DEVICES)) {
 			continue;
+		}
 
-		if (!bitmap_and(aqm, mdev_aqm, matrix_mdev->matrix.aqm,
-				AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, assigned_to->matrix.aqm,
+				AP_DOMAINS)) {
 			continue;
+		}
 
-		vfio_ap_mdev_log_sharing_err(matrix_mdev, apm, aqm);
+		if (assignee) {
+			vfio_ap_mdev_log_sharing_err(assignee, assigned_to,
+						     apm, aqm);
+		} else {
+			vfio_ap_mdev_log_in_use_err(assigned_to, apm, aqm);
+		}
 
 		return -EADDRINUSE;
 	}
@@ -951,7 +978,8 @@ static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
 					       matrix_mdev->matrix.aqm))
 		return -EADDRNOTAVAIL;
 
-	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
+	return vfio_ap_mdev_verify_no_sharing(matrix_mdev,
+					      matrix_mdev->matrix.apm,
 					      matrix_mdev->matrix.aqm);
 }
 
@@ -2458,7 +2486,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
-	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
 	mutex_unlock(&matrix_dev->mdevs_lock);
 	mutex_unlock(&matrix_dev->guests_lock);
 
-- 
2.47.1


