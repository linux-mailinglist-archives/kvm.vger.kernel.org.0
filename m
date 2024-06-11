Return-Path: <kvm+bounces-19359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3588904664
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99451C22472
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 21:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA59B155300;
	Tue, 11 Jun 2024 21:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LIH7Ycb9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D415444F;
	Tue, 11 Jun 2024 21:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142470; cv=none; b=LBTLoz/4CBDhVGRwqklusiq5CUzZedfRCOmsbmek9u3vY5lHnBSADdA5HEfS6MU/8B87DGYPxAql3mKMbEI4E5bJhswSqOAB9BlYoYIJoGafUa0KJESkq61wWgNSaM5n/xchZ+1m6qt6L5hcVo7qOFnCXyvZa31IhxU5tzX+3os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142470; c=relaxed/simple;
	bh=Ehq8/IZNDfsi3peqk0Yh7gAgFUTkVobt/ARHwtkD0fs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mYVpmdEl4TzWSUQoEKrWz3bf2SczmpTj7U/61qD0bPfs1s6IqZaHqt27HjYvbjPdu/ujSSgpcgq2SYeCLBvVCwYwK1N4v9ouIkk5pjFTRDpAh0rgjdFoGhb1uHlnuXHmXHzWNKwX8S/QHmbqT5EMdlrt9wynjqGYlmCnLbM9ZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LIH7Ycb9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BLRjWE024941;
	Tue, 11 Jun 2024 21:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=VjP68oGVm6iHuk2iiz3FujUs9s
	fk6Hx1GoeUGywuxao=; b=LIH7Ycb984tmQxdURdA8D6Quo5TTBLhS3JfN/hGNvF
	TgF0kzWsIWV44u9ASFtt37nHUOGmL40WwKdCRNJ5FfBwk2Cx71u/Zy9sACJHyBjr
	eQ9hCtUmen93SNs/9GIVfYgFQFE7s4dak/NEXP6aklbuLZjRjE1ZHvRFM+EBKE7O
	J6vV+mZt34VOkJsgxrd45HURJR8997OtUFpHxnJbuDMGjVQvPEH3++i+ZhDU4f6f
	4UlbKb7AE6tNXFTop01KdXJTKzhcihBsiG23Xo7SuOa8sSPrEdQ2xzz+Uydw3q/9
	E5NN+n4QgWl9HbIa3aIQ1XmGWAbeHUMCaWgPmeKdV2Vw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypx3603tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 21:47:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BLljJc026317;
	Tue, 11 Jun 2024 21:47:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypx3603tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 21:47:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BK3Mbi004368;
	Tue, 11 Jun 2024 21:47:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mpre2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 21:47:44 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BLlcG414745950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 21:47:40 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C5A620043;
	Tue, 11 Jun 2024 21:47:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B16720040;
	Tue, 11 Jun 2024 21:47:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 21:47:37 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Boqiao Fu <bfu@redhat.com>, Sebastian Mitterle <smitterl@redhat.com>
Subject: [PATCH 1/1] s390/virtio_ccw: fix config change notifications
Date: Tue, 11 Jun 2024 23:47:16 +0200
Message-Id: <20240611214716.1002781-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IB-ygfj5wSJhE-ZsTfj4HUom5pI0BZ4g
X-Proofpoint-ORIG-GUID: 2XFA4JZYbJ9ICPrnlQ8fL292oEluDiMp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_10,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110145

Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
broke configuration change notifications for virtio-ccw by putting the
DMA address of *indicatorp directly into ccw->cda disregarding the fact
that if !!(vcdev->is_thinint) then the function
virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
with the address of the virtio_thinint_area so it can actually set up
the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.  Thus we end up
pointing to the wrong object for both CCW_CMD_SET_IND if setting up the
adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
whether it succeeds or fails.

To fix this, let us save away the dma address of *indicatorp in a local
variable, and copy it to ccw->cda after the "vcdev->is_thinint" branch.

Reported-by: Boqiao Fu <bfu@redhat.com>
Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
---
I know that checkpatch.pl complains about a missing 'Closes' tag.
Unfortunately I don't have an appropriate URL at hand. @Sebastian,
@Boqiao: do you have any suggetions?
---
 drivers/s390/virtio/virtio_ccw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d7569f395559..d6491fc84e8c 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -698,6 +698,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	dma64_t *indicatorp = NULL;
 	int ret, i, queue_idx = 0;
 	struct ccw1 *ccw;
+	dma32_t indicatorp_dma = 0;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw), NULL);
 	if (!ccw)
@@ -725,7 +726,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	*/
 	indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
 					   sizeof(*indicatorp),
-					   &ccw->cda);
+					   &indicatorp_dma);
 	if (!indicatorp)
 		goto out;
 	*indicatorp = indicators_dma(vcdev);
@@ -735,6 +736,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			/* no error, just fall back to legacy interrupts */
 			vcdev->is_thinint = false;
 	}
+	ccw->cda = indicatorp_dma;
 	if (!vcdev->is_thinint) {
 		/* Register queue indicators with host. */
 		*indicators(vcdev) = 0;

base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.40.1


