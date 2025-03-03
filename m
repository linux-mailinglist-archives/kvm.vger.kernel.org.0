Return-Path: <kvm+bounces-39919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F5EA4CBAC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 20:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 504D33A6E24
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BB7230BFB;
	Mon,  3 Mar 2025 19:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BCFVJpif"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467D33F6;
	Mon,  3 Mar 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741029125; cv=none; b=LNjqQ3yRczVQSPL5Tt6Y69jfeCJZijeR9VILJErPkeSmgJKg+aOixR5H7X7wjq/oELTNLbCfoxib9wNrvYqVYKRQggq+VDGxJ7tr78pOalIxGWG3o15Xo4viEDBGJ/qEIhHoXKHVjtodZyhIc0EYojTifw+HF11OTwSeBLiXQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741029125; c=relaxed/simple;
	bh=HRBDb/01Aoz/Xbn/HWrMNCNs4hJQ+oaS+r2C1Bxu8ag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gzACzu4bttGroADCgUlrS+B/F1xBxNvkqzR9jZ6muhTTnXmfFs95Aiy/J7l1xPjqlnZZRXWJlEvZreGEnPH1KnJZNmjhGNwAOWD/FAx2mE2Q6ZR46vrA1ue/cS5GQPZrh/qU4ATGA8kL901JSYZ5GwDfr2Z8T8HOoz0sLwE6DiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BCFVJpif; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523F53EF002272;
	Mon, 3 Mar 2025 19:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=KkerPnmZLypqnbkqHWCG8ODSVofP4Dm6qZuF15VXw
	wM=; b=BCFVJpif0WlvB3nW+oj9FIMUJYaC9bRP1TSJsrlGw8VqnZ1P2FAQEeEgs
	+Nu+NRXs4pheNsTyQ9fVIr37FRtJvpHejtncuS5XDNY91XHSAZ2tcy7m9Bp9AupJ
	X8DTd/RQGklxA3KaG1NPaE/PKjiybsmEkXHU1CbouP8uW+W+wU9RcQaimvJHTETJ
	nLVMo5L9jtuwv6e+Bre7C+Goi8aXiLadJjSECbsLDTkPTa2Kq2I+btYUlDY60BKS
	awWWaw6xFFsIZJ3qk3gV4aD9RvgmDii5Rupp1bbtUdBDpAr/S4wn8Qd2fiFkHEuX
	OXb46BSJt9EYRqaCVZsQ/bOiLw06w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 454xr4x6eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Mar 2025 19:12:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 523G8lsD020845;
	Mon, 3 Mar 2025 19:12:00 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 454djn9k6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Mar 2025 19:12:00 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 523JBxi931326774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Mar 2025 19:11:59 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95B3758052;
	Mon,  3 Mar 2025 19:11:59 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9B195805D;
	Mon,  3 Mar 2025 19:11:58 +0000 (GMT)
Received: from MacBookPro.ibm.com (unknown [9.61.240.87])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Mar 2025 19:11:58 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v1] fixup! s390/vfio-ap: Notify userspace that guest's AP config changed when mdev removed
Date: Mon,  3 Mar 2025 14:11:58 -0500
Message-ID: <20250303191158.49317-1-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mtees-123PRKTcihCHVDAVpovJQdXesc
X-Proofpoint-ORIG-GUID: mtees-123PRKTcihCHVDAVpovJQdXesc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_09,2025-03-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503030144

This patch is based on the s390/features branch

The guest's AP configuration is cleared when the mdev is removed, so
userspace must be notified that the AP configuration has changed. To this
end, this patch:

* Removes call to 'signal_guest_ap_cfg_changed()' function from the
  'vfio_ap_mdev_unset_kvm()' function because it has no affect given it is
  called after the mdev fd is closed.

* Adds call to 'signal_guest_ap_cfg_changed()' function to the
  'vfio_ap_mdev_request()' function to notify userspace that the guest's
  AP configuration has changed before signaling the request to remove the
  mdev.

Minor change - Fixed an indentation issue in function
'signal_guest_ap_cfg_changed()'

Fixes: 2ba4410dd477 ("s390/vfio-ap: Signal eventfd when guest AP configuration is changed")
Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 571f5dcb49c5..c1afac5ac555 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -652,8 +652,8 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 
 static void signal_guest_ap_cfg_changed(struct ap_matrix_mdev *matrix_mdev)
 {
-		if (matrix_mdev->cfg_chg_trigger)
-			eventfd_signal(matrix_mdev->cfg_chg_trigger);
+	if (matrix_mdev->cfg_chg_trigger)
+		eventfd_signal(matrix_mdev->cfg_chg_trigger);
 }
 
 static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev *matrix_mdev)
@@ -1870,7 +1870,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
-		signal_guest_ap_cfg_changed(matrix_mdev);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
@@ -2057,6 +2056,14 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 
 	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
 
+	if (matrix_mdev->kvm) {
+		get_update_locks_for_kvm(matrix_mdev->kvm);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		signal_guest_ap_cfg_changed(matrix_mdev);
+	} else {
+		mutex_lock(&matrix_dev->mdevs_lock);
+	}
+
 	if (matrix_mdev->req_trigger) {
 		if (!(count % 10))
 			dev_notice_ratelimited(dev,
@@ -2068,6 +2075,12 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 		dev_notice(dev,
 			   "No device request registered, blocked until released by user\n");
 	}
+
+	if (matrix_mdev->kvm)
+		release_update_locks_for_kvm(matrix_mdev->kvm);
+	else
+		mutex_unlock(&matrix_dev->mdevs_lock);
+
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
-- 
2.48.1


