Return-Path: <kvm+bounces-39311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A7FA468D9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B463A1888E68
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8195233D7C;
	Wed, 26 Feb 2025 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LP2cM6Cg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2B4A1A;
	Wed, 26 Feb 2025 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593041; cv=none; b=CyXDAqj5nAMU03rQNDRr67xxrHzUaXYoj7Zj/IZfYu1f+XgVOnyPgadh1WX7l0JzCVVLzJWeQn36c5nKM1EHFVNpBA4hJQfjRiJsEPr6+n+eXlzOwGACMRuPVYYpmzgxDbi8Hp1YV44cKSsmz0mixBt7MtXxjpzm/PWvZVT3SSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593041; c=relaxed/simple;
	bh=Ult+jCe8V+RK2OSVBLS7kPBk2d9BSot4j1pHvtVAPX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZeDzwxmDw29DN8mgZ8p4hCRPAGrAGY6rFRhiWAAU+G7Z+xpnOwMExnErfOYtLeHpf7y8DUHFgr92QfUit2H4Vu9J4NnjzdmsMHRpEcO0SOlyM0fGkhBS837MTn+vLNuIDghpfyKylIoe21R2dX/HWhuYkI4ErMAsiULQZ8MTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LP2cM6Cg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QDHIsi027833;
	Wed, 26 Feb 2025 18:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BagUnjM7IFd8MM1CI
	k7jDa6LhSJ/+lrqaAtDxWexNw8=; b=LP2cM6CgFUyC8Sfm+oWnLADLmY/rwMAnH
	+OPGTFT+ZBc8kgGe+6hqEZrrzYsN2e82TmpYN3Qsce1NFVrNd6CoQVBrSDjYNfeq
	EoYGGozeY9+HtdDVlSI0ASfzEDn+caxCN3kh6jhOAYKH2M/oLRkNyxCyo8gxQcsq
	PqRB6Ri5G2xcXwe9fPuZIqp8x6n8K6sqSnvYf0kgO+uxGzAhfDi68ZU03tpKTok3
	p3NdU5wrvsIV2yDT9dQpQH5Ff5hj5pTBQJHlAS0Ncn7/DdoSOc424cKXiQ2jekkr
	sKid2mKVBixBwAYrtdkFWiAnYMLXh1RWPIx0UY24UHtobnDrOZH3A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451q5jcw4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:03:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QHU97f012918;
	Wed, 26 Feb 2025 18:03:56 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwsvcsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:03:56 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI3ubR7930442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:03:56 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19A1058063;
	Wed, 26 Feb 2025 18:03:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D7C258060;
	Wed, 26 Feb 2025 18:03:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:03:55 +0000 (GMT)
From: Rorie Reyes <rreyes@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com,
        rreyes@linux.ibm.com
Subject: [RFC PATCH v2 2/2] s390/vfio-ap: Fixing mdev remove notification
Date: Wed, 26 Feb 2025 13:03:53 -0500
Message-ID: <20250226180353.15511-3-rreyes@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250226180353.15511-1-rreyes@linux.ibm.com>
References: <20250226180353.15511-1-rreyes@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UErNMyfhWTLj5eLi4IgK0yfw8vafgZZw
X-Proofpoint-ORIG-GUID: UErNMyfhWTLj5eLi4IgK0yfw8vafgZZw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=937 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142

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


