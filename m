Return-Path: <kvm+bounces-28082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64C89937FB
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 22:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F84F283BF5
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 20:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6813C1DE4E0;
	Mon,  7 Oct 2024 20:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HGt0c+eE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED4E1DE4C8;
	Mon,  7 Oct 2024 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728331873; cv=none; b=KlKCAJbTmCxRvaZ2dEeTn7joND72DYM02sO1b34w9JNAZOWZTPl7QDE3tS9KD/aHHsRHODRtUVODT55isVv9G0v5cP+IKTtI1ExU0KZiGPH9fWHx5dbmeePS6EHCj4ul5ff6Uli+9onJSZkVk8QTxIICPVfwUzX/ryTkQyri+Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728331873; c=relaxed/simple;
	bh=QJO05AK52bflF8/V1g5BH0IykS494yd3QvteXY7yw9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D4icUpNq6Epb7WORnMyZg/1LWqQ2IeYkeguzd1TNIdoHP/5nOwLBOeiTfLaKZXtJyFcbQgRm1xi4SNVjjiXh+vsKNCFPr2iRoRBknbwCERNy7kFuDkuiDcNRUZhLGcG29awz2lJkY/YSozzT6veJv8AYx4qegNri0RQYhRf/3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HGt0c+eE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497HpHro031826;
	Mon, 7 Oct 2024 20:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=oxqfT3NuqEu2jpdJC8oFJ+DpIWF2KlKWnjOO3Px
	L9H0=; b=HGt0c+eEL2LbTjOMECVTfLu0LOTHSE86Xi8sacO2uITyoVJXhd4wcat
	8MwfzV853yfbZnkMF6+hziZspilMWogfe3qtlKm0XOw0CsmlAC1oEpNcPmSSvaLx
	Uo5tBy3tDotlBep9Mr7itoKsRkhimUVAmBUTeBb28FzCX0GcSoMeJY3iGiUMWA/s
	0JSIKS0vTq5G9SRLFOPYIUc/LpP9r0Hq/NQWONAvnQSVFCJ3k/XO/V9rU789uoh9
	7OxC73+gY3zQxtxH3os1Jo2gEeYt7COY0v5HQy3lo7jrKP3C/5Y5EQBLlDoiU7Sz
	8MENt7TVpOiDfHjL/MoaJKLbAdtRGmQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 424mcxgj6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 20:11:04 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 497KB4NQ004144;
	Mon, 7 Oct 2024 20:11:04 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 424mcxgj6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 20:11:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 497Idti0022861;
	Mon, 7 Oct 2024 20:11:03 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 423jg0r8ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 20:11:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 497KAxVp52167000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Oct 2024 20:11:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C82C52004B;
	Mon,  7 Oct 2024 20:10:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62F1F20040;
	Mon,  7 Oct 2024 20:10:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Oct 2024 20:10:59 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Marc Hartmayer" <mhartmay@linux.ibm.com>
Subject: [PATCH 1/1] s390/virtio_ccw: fix dma_parm pointer not set up
Date: Mon,  7 Oct 2024 22:10:30 +0200
Message-ID: <20241007201030.204028-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qv7T0kh2xhGfvtXQ8TvVTdZI5RNEPcHS
X-Proofpoint-GUID: -QWAYHiU3V6nlYydhEqMnNyXDTqvrqQz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-07_13,2024-10-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410070137

At least since commit 334304ac2bac ("dma-mapping: don't return errors
from dma_set_max_seg_size") setting up device.dma_parms is basically
mandated by the DMA API. As of now Channel (CCW) I/O in general does not
utilize the DMA API, except for virtio. For virtio-ccw however the
common virtio DMA infrastructure is such that most of the DMA stuff
hinges on the virtio parent device, which is a CCW device.

So lets set up the dma_parms pointer for the CCW parent device and hope
for the best!

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 334304ac2bac ("dma-mapping: don't return errors from dma_set_max_seg_size")
Reported-by: "Marc Hartmayer" <mhartmay@linux.ibm.com>
Closes: https://bugzilla.linux.ibm.com/show_bug.cgi?id=209131
Reviewed-by: Eric Farman <farman@linux.ibm.com>
---

In the long run it may make sense to move dma_parms into struct
ccw_device, since layering-wise it is much cleaner. I decided
to put it in virtio_ccw_device because currently it is only used for
virtio.

---
 drivers/s390/virtio/virtio_ccw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 62eca9419ad7..21fa7ac849e5 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -58,6 +58,8 @@ struct virtio_ccw_device {
 	struct virtio_device vdev;
 	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
 	struct ccw_device *cdev;
+	/* we make cdev->dev.dma_parms point to this */
+	struct device_dma_parameters dma_parms;
 	__u32 curr_io;
 	int err;
 	unsigned int revision; /* Transport revision */
@@ -1303,6 +1305,7 @@ static int virtio_ccw_offline(struct ccw_device *cdev)
 	unregister_virtio_device(&vcdev->vdev);
 	spin_lock_irqsave(get_ccwdev_lock(cdev), flags);
 	dev_set_drvdata(&cdev->dev, NULL);
+	cdev->dev.dma_parms = NULL;
 	spin_unlock_irqrestore(get_ccwdev_lock(cdev), flags);
 	return 0;
 }
@@ -1366,6 +1369,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 	}
 	vcdev->vdev.dev.parent = &cdev->dev;
 	vcdev->cdev = cdev;
+	cdev->dev.dma_parms = &vcdev->dma_parms;
 	vcdev->dma_area = ccw_device_dma_zalloc(vcdev->cdev,
 						sizeof(*vcdev->dma_area),
 						&vcdev->dma_area_addr);

base-commit: 87d6aab2389e5ce0197d8257d5f8ee965a67c4cd
-- 
2.43.0


