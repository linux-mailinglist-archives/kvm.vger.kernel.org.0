Return-Path: <kvm+bounces-40075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3E4A4EE13
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8FB616F7DD
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B9B25F98D;
	Tue,  4 Mar 2025 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a8fh9Etm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A06B1FA243;
	Tue,  4 Mar 2025 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741118902; cv=none; b=ClHjlCuTlT4kqyqxiMVkROf8N9092MmJe0ACgz1XMfVH7DpvyDhFHjjSqqbdJKjIOWGdswmHJFHyYqPUlCRmNCXnVBhdD/XNU7Kket49rdyGNbI9RwRAl2KAQ0saDDQKuDdcxOKAzLizV9LqrwXFBcUxusKAXGqdrPVfLS+Zipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741118902; c=relaxed/simple;
	bh=N3wtJjVZHu5J62i7FEtx2ll9WoSXpNgDqVUXy1JDSZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rqyOL4NGZabEYr/PQfLgTKRjAh2ZBJQNO7zRkd5Q9EYpWlXMNeqBxRUg3heyLmfkZQm/CKFAGit6cSH/FZFDF/ZOMitgaqMdDS/6XlBy1KnGxJYDKoaNEe4M1tnfik+x7EqPF7XKvdyLS9/LsWTX0rD+5c2vPqoPw5Ur8Puh2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a8fh9Etm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524EBHXB021531;
	Tue, 4 Mar 2025 20:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=3LoAL7M/RzbbQbnOUQ+MAjfHxxiz6tifN6gEL4s8h
	aQ=; b=a8fh9EtmqY3PLnyxd5CJss6XvOtH/vXhAHaXaWVsvKl5TSFDR/J/9DmZB
	bVJMgbYP3yeh8VpnLCqSH19HicXPWcvUt4iZt3dWfGxydSbB4sHEXfMLBk20ABNc
	EouM7kWWQjo+STx00VUBIKNeQf0weNVxoOkAtslaZXNRx9wEr1SUaoLIc8arlcCe
	xm879WKRFcpn5gADtanDWfrZ+hntCYOV+qwBGnrGLJ2vrWoHAjqVxfk3dfNxAbiR
	cqInEEE2iM0d+He7dNb7svHKZIA+w5akbIb2VVjG+L7BO77ocAZywwwY9hXFwS+6
	4B4+0eeRC/NgmiKj1VFg4Ka5rB/sQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455sw7mk26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 20:08:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524J72s0013784;
	Tue, 4 Mar 2025 20:08:14 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 454e2kq4uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 20:08:14 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524K8De130737010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 20:08:13 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23BA558056;
	Tue,  4 Mar 2025 20:08:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 764805805A;
	Tue,  4 Mar 2025 20:08:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.12.79.204])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 20:08:12 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2] s390/vfio-ap: Notify userspace that guest's AP config changed when mdev removed
Date: Tue,  4 Mar 2025 15:08:12 -0500
Message-ID: <20250304200812.54556-1-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gf7uwwKhzr_LAleLkkU9y9wB1MGMrlKr
X-Proofpoint-GUID: Gf7uwwKhzr_LAleLkkU9y9wB1MGMrlKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_08,2025-03-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040160

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

Fixes: 07d89045bffe ("s390/vfio-ap: Signal eventfd when guest AP configuration is changed")
Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
---
This patch is based on the s390/features branch

V1 -> V2:
- replaced get_update_locks_for_kvm() with get_update_locks_for_mdev
- removed else statements that were unnecessary
- Addressed review comments for commit messages/details
---
 drivers/s390/crypto/vfio_ap_ops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 571f5dcb49c5..ae2bc5c1d445 100644
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
@@ -2057,6 +2056,13 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 
 	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
 
+	get_update_locks_for_mdev(matrix_mdev);
+
+	if (matrix_mdev->kvm) {
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		signal_guest_ap_cfg_changed(matrix_mdev);
+	}
+
 	if (matrix_mdev->req_trigger) {
 		if (!(count % 10))
 			dev_notice_ratelimited(dev,
@@ -2068,6 +2074,9 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 		dev_notice(dev,
 			   "No device request registered, blocked until released by user\n");
 	}
+
+	release_update_locks_for_mdev(matrix_mdev);
+
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
-- 
2.48.1


