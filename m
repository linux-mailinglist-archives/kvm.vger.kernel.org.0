Return-Path: <kvm+bounces-38350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 318ACA37F77
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:10:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AA50175322
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F026E217663;
	Mon, 17 Feb 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h49L5A7R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570B321764B;
	Mon, 17 Feb 2025 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739786813; cv=none; b=E5o4gRbYDqI16J0hpsFxZcpHb9qdDcRw4R1phEVP/lFbv4aClsatX391FIYnozrQw1+WoyaJAaRT8B7kOTMEjirtVnwqw5pJTi4V8sh/hIBHOZPHgeXMBRi7PyDdqq9EwvFdgx1LtB3tiD95oEo1eaOMOLzuUGwpxT4K3BKb9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739786813; c=relaxed/simple;
	bh=pG5781aQTSkerYI5TlaCG1jO7ekauoLRipYPdd3jZNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbLMUYtAG1BFotq7tTjxeuNXsEkOaMLOMZQc2J15WkYL2iAmX+nmPzynzdQf0+2Zfw7tRYwWGuX8Jgu5qJUHoYiWR/KtdEQf3UZQ1p5A7rI1tu2W1EXfoOc3S0UjaOEBcxCmdhhM03+bul3Esy0UUEAqxUdmqioTFFGE+UNPcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h49L5A7R; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51H7Wreu025599;
	Mon, 17 Feb 2025 10:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hPU62AQqGYqhFnMdH
	CsXHxAM3gzudH37WN3cIYUprUs=; b=h49L5A7R2WedaA/IFU+nLZAetZfFIXlfy
	RshRx/GXjBh3gYsSSvfx8Hn3jLRg+mWpgB78OuinbMZz4IiN65LRYpgyROcjbMJl
	IayEBm125+7Hrz4Sx9plGchCRMw2UMQOEML1ct9dm6FjQNLspq76l/qi/wDaD2G9
	LlvhvO7ryMp1n1GJoW/uD8ygNp0/Z9nqtJLaSt4IKgCs80PIGrSM8GoZM9GZSpGj
	ZZTGQw0PfKvfLMs6wFfXLmoimbBwGd+uNKs8QRtAkBeZ6ixs4ODuFS/r1Vvpum24
	v0mrsVIYG5VuBQiOJ754/4U21BTeEWDvEowtloAGE0y29op0bbsDA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44v0tp0qn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:29 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51H9C0JQ032352;
	Mon, 17 Feb 2025 10:06:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44u6rknfcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51HA6OFt42336658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 10:06:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6083320063;
	Mon, 17 Feb 2025 10:06:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 229742005A;
	Mon, 17 Feb 2025 10:06:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Feb 2025 10:06:24 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/2] s390/vfio-ap: make mdev_types not look like a fake flex array
Date: Mon, 17 Feb 2025 11:06:13 +0100
Message-ID: <20250217100614.3043620-2-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250217100614.3043620-1-pasic@linux.ibm.com>
References: <20250217100614.3043620-1-pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0j2MEt5Bsj9-Q2UhPlI9aVkEw3kmh-Ut
X-Proofpoint-ORIG-GUID: 0j2MEt5Bsj9-Q2UhPlI9aVkEw3kmh-Ut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-17_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 phishscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502170088

The vfio-ap driver and the vfio parent device provided by it
(matrix_dev) support just a single mdev_type, and this is not likely to
change any time soon.  Despite that matrix_dev->mdev_types started out
as a C99 flexible array presumably as a typo, and since the typo messed
up the allocation, commit e2c8cee9f489 ("s390/vfio-ap: Fix memory
allocation for mdev_types array") changed it to an array of size 1. And
to make things worse mdev_types happens to be the last member of struct
ap_matrix_dev.

Now the problem with that is that before C99 the usual way to get
something similar to a flexible array member was to use a trailing array of
size 0 or 1. This is what I called fake flex array. For a while now the
community is trying to get rid of fake flex arrays. And while mdev_types
is not a fake flex array but an array of size one (to match the mdev
interfaces nicer), it can easily be and was mistaken for a fake flex
array.

So, let us make mdev_types a pointer to struct mdev_type and pass in the
address of that pointer as the 4th formal parameter of
mdev_register_parent().

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Tested-by: Anthony Krowiak <akrowiak@linux.ibm.com>

---

I've also considered switching up the order in which the members
mdev_types and mdev_type are defined in  struct ap_matrix_dev but
decided against that because that could look to somebody like
well known mistake that can be made when using fake flex arrays.
---
 drivers/s390/crypto/vfio_ap_ops.c     | 4 ++--
 drivers/s390/crypto/vfio_ap_private.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a52c2690933f..5212b3863aff 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2316,10 +2316,10 @@ int vfio_ap_mdev_register(void)
 
 	matrix_dev->mdev_type.sysfs_name = VFIO_AP_MDEV_TYPE_HWVIRT;
 	matrix_dev->mdev_type.pretty_name = VFIO_AP_MDEV_NAME_HWVIRT;
-	matrix_dev->mdev_types[0] = &matrix_dev->mdev_type;
+	matrix_dev->mdev_types = &matrix_dev->mdev_type;
 	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
 				   &vfio_ap_matrix_driver,
-				   matrix_dev->mdev_types, 1);
+				   &matrix_dev->mdev_types, 1);
 	if (ret)
 		goto err_driver;
 	return 0;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 437a161c8659..9d16321777c8 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -53,7 +53,7 @@ struct ap_matrix_dev {
 	struct mutex guests_lock; /* serializes access to each KVM guest */
 	struct mdev_parent parent;
 	struct mdev_type mdev_type;
-	struct mdev_type *mdev_types[1];
+	struct mdev_type *mdev_types;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
-- 
2.45.2


