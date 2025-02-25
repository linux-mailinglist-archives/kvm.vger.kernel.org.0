Return-Path: <kvm+bounces-39173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1D9A44C1F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AB9C7A53BE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4CA20E713;
	Tue, 25 Feb 2025 20:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cHK31Bb8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C38D20E32B;
	Tue, 25 Feb 2025 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514338; cv=none; b=pG89Q6rmvNNVtd/gGBaYwrOwiNHmBpyWKSYz9A1VGM9jBWT7RE5l9Yl/+pTGaVkCBxOJosDuTP5OmXrQR663QN86cWthE67QRMAWDMIjivFL6GLeJA9GK7lq1ffbfoX9Ldh0CLW9vmIqKfIpfNG+7nLhUJU9Qc2axMkZVoDdalE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514338; c=relaxed/simple;
	bh=Ult+jCe8V+RK2OSVBLS7kPBk2d9BSot4j1pHvtVAPX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXGHMrdsY2Wk7jV+y/djL6kjYgBKcZa8se9f/hfjmbcaWx928LTh9YS/LxbSr+NFdxev8vImpswtLnMuUjPwn2r5j7e5EIdOkQ8DRQwe2TKReDHW5Z2OZlFu4DQoBeEL9rPq+GbISz1Ek5dYNmz3I+oqmcoo0zfb6PBrnkfHDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cHK31Bb8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PDjY62026891;
	Tue, 25 Feb 2025 20:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BagUnjM7IFd8MM1CI
	k7jDa6LhSJ/+lrqaAtDxWexNw8=; b=cHK31Bb8dyRx/dVi1Z64gQdlZXE5SyWLg
	zuc/hueIFIlBHYb861LJi9+TG6gXep1phVrnk/GpHQ7k59EBzrcbU+lPMiN/cxNb
	8A+5fcp8Lu9LZsEM2lATO1Z0avFLNRVghXj+CEiOukuC8IjMchoZLqqrlmFOv7gd
	hzzBsCd63t3WC8kGDFjGIPGu7xtc1vUsUAKe2aj1bDBRCA3+n9VHd1aGhxxes9rz
	VZTcgetGQx7zgTk5L9bWXgPoy1JGlYjNMjoQfJxhT6cR12DSEt3L7jmr9CrOQf7B
	xEpWS6PBDLZL0DLVM2pHON82XZmuSLbchNcnwv9pAQnCDbqc6B/EA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4513x9w8xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51PJeOVX012597;
	Tue, 25 Feb 2025 20:12:13 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yf33y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 20:12:13 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51PKCBBZ23134876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 20:12:11 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B9F558052;
	Tue, 25 Feb 2025 20:12:11 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C275A58056;
	Tue, 25 Feb 2025 20:12:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.252.67])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 20:12:10 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2 2/2] s390/vfio-ap: Fixing mdev remove notification
Date: Tue, 25 Feb 2025 15:12:08 -0500
Message-ID: <20250225201208.45998-3-rreyes@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: bD9oICB7dc-ZRKhfL9AR1Yx2UjYm_HG2
X-Proofpoint-GUID: bD9oICB7dc-ZRKhfL9AR1Yx2UjYm_HG2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=937 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502100000 definitions=main-2502250120

Removed eventfd from vfio_ap_mdev_unset_kvm
Update and release locks along with the eventfd added
to vfio_ap_mdev_request

Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c6ff4ab13f16..e0237ea27d7e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
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
2.39.5 (Apple Git-154)


