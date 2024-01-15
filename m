Return-Path: <kvm+bounces-6277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C0B82E056
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 19:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B303B21DCA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 18:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6A1199C7;
	Mon, 15 Jan 2024 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X5ItclKI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA8519455;
	Mon, 15 Jan 2024 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40FISthM016670;
	Mon, 15 Jan 2024 18:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9glprldnvKen03f9RgQnxU92EqPtX6fzMlc1KWpzOtE=;
 b=X5ItclKI4B+CVG7cjWFDAhTgkZbaNBLJYte9nZJDyep+xccnkqClYUNoYTabGEIkFWO9
 aUhbbiH1nNmK1BqCJ/J3vVNxs1dAKsiUfxHyQZmDMyaSl7D0psKqIls513XMDqIdTmrC
 sXPhIDDGQGofSkyhfXHmcZrVwP3lXvafxusBauhtdkwrT6UO7ea+N6T7cSvjehhKQjgb
 3yz6G6iiF3dtXUKWMFM8MoBcT2BKee8P0scXrQz7ERigkvvooKMxxPhIi52hIiEfbG7E
 +P9VH6uwhKI4yWHVp+AypEllFpf7eKZCGYIvci9YwZ1g18csKfhx/BHz9ai1ShTfUGu6 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vna12gd29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jan 2024 18:54:51 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40FIqejn007966;
	Mon, 15 Jan 2024 18:54:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vna12gd1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jan 2024 18:54:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40FHoTEh018768;
	Mon, 15 Jan 2024 18:54:50 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm5una047-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jan 2024 18:54:49 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40FIsmOK16909004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jan 2024 18:54:48 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DE705805E;
	Mon, 15 Jan 2024 18:54:48 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5977058052;
	Mon, 15 Jan 2024 18:54:47 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.164.202])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Jan 2024 18:54:47 +0000 (GMT)
From: Tony  Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v4 5/6] s390/vfio-ap: reset queues associated with adapter for queue unbound from driver
Date: Mon, 15 Jan 2024 13:54:35 -0500
Message-ID: <20240115185441.31526-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115185441.31526-1-akrowiak@linux.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: euRUpawGHTPo3E2EaCWfC-qBjWzqgvrx
X-Proofpoint-ORIG-GUID: INkAJv9bjqlbbiFMXfosKaWzCEHA9dSQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-15_13,2024-01-15_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=930
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401150139

From: Tony Krowiak <akrowiak@linux.ibm.com>

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

Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Fixes: 09d31ff78793 ("s390/vfio-ap: hot plug/unplug of AP devices when probed/removed")
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 76 +++++++++++++++++--------------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 44cd29aace8e..550c936c413d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -939,45 +939,45 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
 				       AP_MKQID(apid, apqi));
 }
 
+static void collect_queues_to_reset(struct ap_matrix_mdev *matrix_mdev,
+				    unsigned long apid,
+				    struct list_head *qlist)
+{
+	struct vfio_ap_queue *q;
+	unsigned long  apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS) {
+		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+		if (q)
+			list_add_tail(&q->reset_qnode, qlist);
+	}
+}
+
+static void reset_queues_for_apid(struct ap_matrix_mdev *matrix_mdev,
+				  unsigned long apid)
+{
+	struct list_head qlist;
+
+	INIT_LIST_HEAD(&qlist);
+	collect_queues_to_reset(matrix_mdev, apid, &qlist);
+	vfio_ap_mdev_reset_qlist(&qlist);
+}
+
 static int reset_queues_for_apids(struct ap_matrix_mdev *matrix_mdev,
 				  unsigned long *apm_reset)
 {
-	struct vfio_ap_queue *q, *tmpq;
 	struct list_head qlist;
-	unsigned long apid, apqi;
-	int apqn, ret = 0;
+	unsigned long apid;
 
 	if (bitmap_empty(apm_reset, AP_DEVICES))
 		return 0;
 
 	INIT_LIST_HEAD(&qlist);
 
-	for_each_set_bit_inv(apid, apm_reset, AP_DEVICES) {
-		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
-				     AP_DOMAINS) {
-			/*
-			 * If the domain is not in the host's AP configuration,
-			 * then resetting it will fail with response code 01
-			 * (APQN not valid).
-			 */
-			if (!test_bit_inv(apqi,
-					  (unsigned long *)matrix_dev->info.aqm))
-				continue;
-
-			apqn = AP_MKQID(apid, apqi);
-			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
-
-			if (q)
-				list_add_tail(&q->reset_qnode, &qlist);
-		}
-	}
+	for_each_set_bit_inv(apid, apm_reset, AP_DEVICES)
+		collect_queues_to_reset(matrix_mdev, apid, &qlist);
 
-	ret = vfio_ap_mdev_reset_qlist(&qlist);
-
-	list_for_each_entry_safe(q, tmpq, &qlist, reset_qnode)
-		list_del(&q->reset_qnode);
-
-	return ret;
+	return vfio_ap_mdev_reset_qlist(&qlist);
 }
 
 /**
@@ -2217,24 +2217,30 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	matrix_mdev = q->matrix_mdev;
 
 	if (matrix_mdev) {
-		vfio_ap_unlink_queue_fr_mdev(q);
-
 		apid = AP_QID_CARD(q->apqn);
 		apqi = AP_QID_QUEUE(q->apqn);
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


