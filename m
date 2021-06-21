Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58953AEBA6
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUOro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:47:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhFUOrn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:47:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LEXQAt030558;
        Mon, 21 Jun 2021 10:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fnZzeYsKASeQCGYqw7rmR59vCDup5BmrYRhCXK1NvNA=;
 b=IgyiVPp/fb1/GCUFsZiri0OPmeHvvsMgFmPAl3PfMXpoppdzzxL1EiQ/Xd+iDeKKSif8
 RbPN0+eY2D81jR2WiNp5B/DN4FjvNTvNA0Eb9rmRdgRN+602zXrM4zWJ6283IM0rAlEp
 H2xrn0pDwNgddj2+bFPgOmTNyWqoLLevht77Vv/R72AWu+NXSsNMLDwEMcMfPvci6inS
 INLr2ddg45iGr6tLQOFdGnNnrIdmMitkIZgRGlkC3+r7i7aNagSlJPG4t5RoInlBn9OE
 Tn8/MezP/y1oS9/TBk2afyMItxKlkL//TrT6RF2kU6YMYGBvR6USV0djQT4hQYolXpcS oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39at5a654c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:45:29 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LEXiDK031637;
        Mon, 21 Jun 2021 10:45:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39at5a6522-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:45:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LEht1w016357;
        Mon, 21 Jun 2021 14:45:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3998788y6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 14:45:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LEjNUs19988822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:45:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8B74204D;
        Mon, 21 Jun 2021 14:45:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9024203F;
        Mon, 21 Jun 2021 14:45:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Jun 2021 14:45:22 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] virtio/s390: get rid of open-coded kvm hypercall
Date:   Mon, 21 Jun 2021 16:45:22 +0200
Message-Id: <20210621144522.1304273-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lOGhuFFEco4ZgQo-ZJnv_dECe_UlE7x_
X-Proofpoint-ORIG-GUID: q6X9YjPL5H6ujDyxESc1WQX9RcN5WVbs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do_kvm_notify() and __do_kvm_notify() are an (exact) open-coded variant
of kvm_hypercall3(). Therefore simply make use of kvm_hypercall3(),
and get rid of duplicated code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/virtio/virtio_ccw.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 54e686dca6de..d35e7a3f7067 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -388,31 +388,6 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 }
 
-static inline long __do_kvm_notify(struct subchannel_id schid,
-				   unsigned long queue_index,
-				   long cookie)
-{
-	register unsigned long __nr asm("1") = KVM_S390_VIRTIO_CCW_NOTIFY;
-	register struct subchannel_id __schid asm("2") = schid;
-	register unsigned long __index asm("3") = queue_index;
-	register long __rc asm("2");
-	register long __cookie asm("4") = cookie;
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "d" (__schid), "d" (__index),
-		      "d"(__cookie)
-		      : "memory", "cc");
-	return __rc;
-}
-
-static inline long do_kvm_notify(struct subchannel_id schid,
-				 unsigned long queue_index,
-				 long cookie)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __do_kvm_notify(schid, queue_index, cookie);
-}
-
 static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 {
 	struct virtio_ccw_vq_info *info = vq->priv;
@@ -421,7 +396,10 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 
 	vcdev = to_vc_device(info->vq->vdev);
 	ccw_device_get_schid(vcdev->cdev, &schid);
-	info->cookie = do_kvm_notify(schid, vq->index, info->cookie);
+	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
+	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
+				      *((unsigned int *)&schid),
+				      vq->index, info->cookie);
 	if (info->cookie < 0)
 		return false;
 	return true;
-- 
2.25.1

