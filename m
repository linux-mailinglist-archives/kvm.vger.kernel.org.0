Return-Path: <kvm+bounces-3928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B70E680A8C3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BDEB28169F
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D48A39861;
	Fri,  8 Dec 2023 16:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YiTCR0gd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73EC1998;
	Fri,  8 Dec 2023 08:23:12 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8FuFvH023033;
	Fri, 8 Dec 2023 16:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mFpPMJfnCOgbZgoSRbq1Ejegj71ZF0EY6P3+BMfH/yI=;
 b=YiTCR0gdu45KNQrh5fSW+9Y8nUJ7pPJcXUPQjcFclnyW/nqaJ+WcObXCaDRKtSf298ve
 6HuAAzqNkpQau7UHgPvEJj+xUSt0VVUlMS7z1cadYLJXTCBTMiMzcODtylHaEqNpxFOQ
 LDQyKTkCN+zaimyJvfmLSHHVa5pLpgAEJvEqsEqTBRKoBPv1SYJ1xD5YVxEqjhC0FXPd
 pPrav9KNSkIi0tfqAMAB8/pWd0ab7imrV5/Sb3IrEV8Zqi9xGzWuIhFa65VK3aCj8Kfx
 vqRe/Oq9QOMpUjpBODj7SiXSx8ZfI3NmlBw7E0daRFiI9i7MzqMCvNbejfOJtMY1cw2b aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv61610nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:10 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B8FuC8k022881;
	Fri, 8 Dec 2023 16:23:09 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv61610my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:09 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GLjU3001561;
	Fri, 8 Dec 2023 16:23:08 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utav2tjfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:08 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8GN6gw36897106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 16:23:06 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75BE458054;
	Fri,  8 Dec 2023 16:23:06 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 399F95803F;
	Fri,  8 Dec 2023 16:23:05 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.47.9])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 16:23:05 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH v1 5/6] s390/vfio-ap: reset queues associated with adapter for queue unbound from driver
Date: Fri,  8 Dec 2023 11:22:50 -0500
Message-ID: <20231208162256.10633-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231208162256.10633-1-akrowiak@linux.ibm.com>
References: <20231208162256.10633-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cfbNrAZ8MJ_VAunspm8OnWwJv-XtJDeq
X-Proofpoint-ORIG-GUID: O38ENwsBah_BZQf4s-7WbQC_HcGC9KKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_11,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=731
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080135

When a queue is unbound from the vfio_ap device driver, if that queue is
assigned to a guest's AP configuration, its associated adapter is removed
because queues are defined to a guest via a matrix of adapters and
domains; so, it is not possible to remove a single queue.

If an adapter is removed from the guest's AP configuration, all associated
queues must be reset to prevent leaking crypto data should any of them be
assigned to a different guest or device driver. The one caveat is that if
the queue is being removed because the adapter or domain has been removed
from the host's AP configuration, then an attempt to reset the queue will
fail with response code 01, AP-queue number not valid; so resetting these
queues should be skipped.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Fixes: 09d31ff78793 ("s390/vfio-ap: hot plug/unplug of AP devices when probed/removed")
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 39 ++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f08321385058..5db11d50b4b0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2187,6 +2187,23 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	return ret;
 }
 
+static void reset_queues_for_apid(struct ap_matrix_mdev *matrix_mdev,
+				  unsigned long apid)
+{
+	DECLARE_BITMAP(apm_reset, AP_DEVICES);
+
+	/*
+	 * If the adapter is not in the host's AP configuration, then resetting
+	 * any queue for that adapter will fail with response code 01, (APQN not
+	 * valid).
+	 */
+	if (test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm)) {
+		bitmap_clear(apm_reset, 0, AP_DEVICES);
+		set_bit_inv(apid, apm_reset);
+		reset_queues_for_apids(matrix_mdev, apm_reset);
+	}
+}
+
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
 	unsigned long apid, apqi;
@@ -2199,24 +2216,28 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	matrix_mdev = q->matrix_mdev;
 
 	if (matrix_mdev) {
-		vfio_ap_unlink_queue_fr_mdev(q);
-
-		apid = AP_QID_CARD(q->apqn);
-		apqi = AP_QID_QUEUE(q->apqn);
-
-		/*
-		 * If the queue is assigned to the guest's APCB, then remove
-		 * the adapter's APID from the APCB and hot it into the guest.
-		 */
+		/* If the queue is assigned to the guest's AP configuration */
 		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			/*
+			 * Since the queues are defined via a matrix of adapters
+			 * and domains, it is not possible to hot unplug a
+			 * single queue; so, let's unplug the adapter.
+			 */
 			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
 			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+			reset_queues_for_apid(matrix_mdev, apid);
+			goto done;
 		}
 	}
 
 	vfio_ap_mdev_reset_queue(q);
 	flush_work(&q->reset_work);
+
+done:
+	if (matrix_mdev)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);
-- 
2.43.0


