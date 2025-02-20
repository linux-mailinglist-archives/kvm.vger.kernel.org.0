Return-Path: <kvm+bounces-38618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F20EA3CE02
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF1CA17A836
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6033C3C;
	Thu, 20 Feb 2025 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="owhjfjY2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740EA29;
	Thu, 20 Feb 2025 00:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740010072; cv=none; b=d78XunpGgXJ2RsQM+4FaiT3TmBrrKrsxMooyv+FrmoDArO6GPsyNCECSpqh8XHCcruG1TplK96IkYY1WIgCdsTiC0GwgN/Vr01pSPAWOwkzKQGHxiUzkcpE0UfFZUqUbfMCPniNUyD6Xa7vifjebc3lBfD4MiaHFNmJ7RRmN7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740010072; c=relaxed/simple;
	bh=8c7q78y2Q6JBC3cq+n401peleGxD5+GJLp0EA7qwljg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AjdkgU6+zge2U8M7iPWT0r4IIZ6TYE8ryC7Z275jhUuprMrNqt5LsuSAGnXCSHN+GCFYY6MGJjzuv8JVif1E24Yl6gk6RhdgVT+f8QTNhIacJywro7Y1pdhBBvnZa7IimD+ZL/xDLtAvUHn2y8tJS9z5k3U307C0lj5N7mEMmag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=owhjfjY2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JMu0mS005307;
	Thu, 20 Feb 2025 00:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Aw0XHYH+vTNlvHbeC3K7LAX5ktVM0MmPSi3gK3/j5
	iA=; b=owhjfjY2u8Nhxlv95C7h06Fc4KPPzIqTAqVt7SAiJLJDJWyu6wm9+wIlx
	RKIAno+kKS/hyXq8S1lPuQb9SVF1uPzMwpKRS+pe4KG1L8m7VaoBkfxG+HmQMk6g
	bkdD0dFu3X6KpitjT9RafVU8EKqgh9uhMgqVwDFkbeuHQ9XGhMcM3nBnE0e7O8aH
	UAVzQYZjf1uqTwNmYg+cbjinvRoXIVk78cj/378utiEUrIqtbQWyyKj3dVTgIruQ
	4aA0wtgEY9txMEfyqnbbcblji8oDaaotR+1R968g1yo7ncYtpi/rk/SmC1lCTnMm
	kisv9ytvLQYxNu592MYXpoxeD4geg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44w650dpj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 00:07:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51JKc5dl009646;
	Thu, 20 Feb 2025 00:07:46 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w03y70gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 00:07:46 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51K07iUg23265844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 00:07:44 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B15C5805A;
	Thu, 20 Feb 2025 00:07:44 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8072658051;
	Thu, 20 Feb 2025 00:07:43 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.107.75])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Feb 2025 00:07:43 +0000 (GMT)
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH] s390/vio-ap: Fix no AP queue sharing allowed message written to kernel log
Date: Wed, 19 Feb 2025 19:07:38 -0500
Message-ID: <20250220000742.2930832-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0jZdKi9I3Hwht56kNFrHQEnn3bawwo68
X-Proofpoint-GUID: 0jZdKi9I3Hwht56kNFrHQEnn3bawwo68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_10,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502190175

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
 drivers/s390/crypto/vfio_ap_ops.c | 73 ++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..2ce52b491f8a 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -863,48 +863,66 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	vfio_put_device(&matrix_mdev->vdev);
 }
 
-#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
-			 "already assigned to %s"
+#define MDEV_SHARING_ERR "Userspace may not assign queue %02lx.%04lx " \
+			 "to mdev: already assigned to %s"
 
-static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *matrix_mdev,
-					 unsigned long *apm,
-					 unsigned long *aqm)
+#define MDEV_IN_USE_ERR "Can not reserve queue %02lx.%04lx for host driver: " \
+			"in use by mdev"
+
+static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *assignee,
+					 struct ap_matrix_mdev *assigned_to,
+					 unsigned long *apm, unsigned long *aqm)
 {
 	unsigned long apid, apqi;
-	const struct device *dev = mdev_dev(matrix_mdev->mdev);
-	const char *mdev_name = dev_name(dev);
 
 	for_each_set_bit_inv(apid, apm, AP_DEVICES)
 		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
-			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
+			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
+				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev)));
 }
 
-/**
+static void vfio_ap_mdev_log_in_use_err(struct ap_matrix_mdev *assignee,
+					unsigned long *apm, unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES)
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
+			dev_warn(mdev_dev(assignee->mdev), MDEV_IN_USE_ERR,
+				 apid, apqi);
+}
+
+/**assigned
  * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
  *
+ * @assignee the matrix mdev to which @mdev_apm and @mdev_aqm are being
+ *           assigned; or, NULL if this function was called by the AP bus driver
+ *           in_use callback to verify none of the APQNs being reserved for the
+ *           host device driver are in use by a vfio_ap mediated device
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
@@ -912,17 +930,21 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
 
 		/*
 		 * We work on full longs, as we can only exclude the leftover
-		 * bits in non-inverse order. The leftover is all zeros.
+		 * bits in non-inverse order. The leftover is all zeros.assigned
 		 */
-		if (!bitmap_and(apm, mdev_apm, matrix_mdev->matrix.apm,
+		if (!bitmap_and(apm, mdev_apm, assigned_to->matrix.apm,
 				AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, mdev_aqm, matrix_mdev->matrix.aqm,
+		if (!bitmap_and(aqm, mdev_aqm, assigned_to->matrix.aqm,
 				AP_DOMAINS))
 			continue;
 
-		vfio_ap_mdev_log_sharing_err(matrix_mdev, apm, aqm);
+		if (assignee)
+			vfio_ap_mdev_log_sharing_err(assignee, assigned_to,
+						     apm, aqm);
+		else
+			vfio_ap_mdev_log_in_use_err(assigned_to, apm, aqm);
 
 		return -EADDRINUSE;
 	}
@@ -951,7 +973,8 @@ static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
 					       matrix_mdev->matrix.aqm))
 		return -EADDRNOTAVAIL;
 
-	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
+	return vfio_ap_mdev_verify_no_sharing(matrix_mdev,
+					      matrix_mdev->matrix.apm,
 					      matrix_mdev->matrix.aqm);
 }
 
@@ -2458,7 +2481,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
-	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
 	mutex_unlock(&matrix_dev->mdevs_lock);
 	mutex_unlock(&matrix_dev->guests_lock);
 
-- 
2.47.1


