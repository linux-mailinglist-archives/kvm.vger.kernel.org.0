Return-Path: <kvm+bounces-38857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C416FA3F8F8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EB7B17F54F
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 15:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35AB1EF0BC;
	Fri, 21 Feb 2025 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Z5GR0250"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545111EE00C;
	Fri, 21 Feb 2025 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740151966; cv=none; b=eFZTf6Vqc3MHogVtedFYmcLQWUCX+sOm65Nns4VnKY3102lgua8qJXxRhyh8TJpjOKIX7eFOzyFcICbf2jfRNiNp0pTIW5EcVc/gFbO3AqrBx4UKdzRogQDTDMOnDi8bDZjG/tG9xAqxvVpeax4cr8OfQGxP1nZh7APFRm70U8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740151966; c=relaxed/simple;
	bh=QnNPF+V3Qq1JcwWCUFb0Btormq/bXlkCozBL/9qRMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EaZcQ0XDK9WyaYh5bJIqCU7i3QSEDliT5Qt9UunKUdm5nlClWkdr260wEd2E9wKDHh3wv2CTx6hm51klJcuRzMV3rW+SJnuK9syQJ0FOt0Fo/unU8slTkHbsGBiC3eeru3tEAqvUNla0ZkKyn2kuNBtyTFSX3T8AQmGSL+lXe9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Z5GR0250; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51L6PQeS008508;
	Fri, 21 Feb 2025 15:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=49EzYnj+PAMNHLkVhGGjoywyDj+dupnj8lFhMEtPm
	ew=; b=Z5GR0250USTo2/Lgu7MKkSTnbCwxydV2bE5PLgP78chl+sA9K7/0hTxxb
	gtR2WMz+7JlCnRSW9gz+ZGK3DHna+bcg1ohtR6Y1Eh5+qXwY8QfQ/3zjax+pNWvH
	NIm+EJ4Kzbk79BrioI9GDPtvcQ02YXOisiWmvmkElEO054gogEl6p/z8PDhiTIIx
	8bSwOcFyZY52OOo1GR8y71dA0CO1quH5UysdOLG0yM15hWEUWToHOM05O423/CjW
	2q8NDTEMB8xxr/j7hGCFiJXXCb+m2XYEJ0kb992fMgB5aKjkc0woREV5J5TWLrEu
	gTWkIyYe5lO2zv47N/xjYHorPzoGw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xm752km8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:32:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51LF4b81029794;
	Fri, 21 Feb 2025 15:32:42 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w024rr96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:32:41 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51LFWeHU8979096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 15:32:40 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70D8E5805D;
	Fri, 21 Feb 2025 15:32:40 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2766F5805E;
	Fri, 21 Feb 2025 15:32:39 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.107.75])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Feb 2025 15:32:39 +0000 (GMT)
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com,
        alex.williamson@redhat.com, clg@redhat.com, mjrosato@linux.ibm.com,
        stable@vger.kernel.org
Subject: [PATCH] s390/vfio-ap: lock mdev object when handling mdev remove request
Date: Fri, 21 Feb 2025 10:32:33 -0500
Message-ID: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6LFmOGDFRmi3zTEfNuhJLQTyhPUmG2xy
X-Proofpoint-GUID: 6LFmOGDFRmi3zTEfNuhJLQTyhPUmG2xy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210111

The vfio_ap_mdev_request function in drivers/s390/crypto/vfio_ap_ops.c
accesses fields of an ap_matrix_mdev object without ensuring that the
object is accessed by only one thread at a time. This patch adds the lock
necessary to secure access to the ap_matrix_mdev object.

Fixes: 2e3d8d71e285 ("s390/vfio-ap: wire in the vfio_device_ops request callback")
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..a2784d3357d9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2045,6 +2045,7 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 	struct ap_matrix_mdev *matrix_mdev;
 
 	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	if (matrix_mdev->req_trigger) {
 		if (!(count % 10))
@@ -2057,6 +2058,8 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
 		dev_notice(dev,
 			   "No device request registered, blocked until released by user\n");
 	}
+
+	mutex_unlock(&matrix_dev->mdevs_lock);
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
-- 
2.47.1


