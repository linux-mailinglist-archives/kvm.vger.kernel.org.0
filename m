Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F074B5536DE
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353343AbiFUPwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353158AbiFUPv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5042C677;
        Tue, 21 Jun 2022 08:51:55 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LF4Sec017618;
        Tue, 21 Jun 2022 15:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iB6pQpXXp5oitQrruuVuvU6eR7LE2YacAO7Tb+4LW84=;
 b=CrOFpUXZ7I3Mixgnc1v3fb9JH/MYr5QurD/i62iY14qSC7M9cKmfkN1wOGn+4cz6Vo7L
 UB5TvBwbj/XIkw30/cSK6JleFT+ER6Lh46TOhxkTrvI2GLQMbT83X1sOkcjTIFetrH5f
 +SXBOOA7Y//fHpLc25lmjLhgifalG9EKaMtKcIGKuStcnJ3tm2BV5oJw6ksqmX5XO7f+
 0CPTEUCy97snhZdyT8L+frkMcDnf63ODU5xGQXqBMbmpTxWcJHzWAlUyTqxh3Wx6tnlc
 uGBvDDhW8oY38lUmm6Q3gyM4FkoNcfrAOD03EWzV6LHaWrDPppCjRTXbY+iQWkfkYx2G IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaeses5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:53 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFgNRp010961;
        Tue, 21 Jun 2022 15:51:52 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaeserv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:52 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZDfl021700;
        Tue, 21 Jun 2022 15:51:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3gs6b9cvrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFppWk15860116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:51 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 026A913604F;
        Tue, 21 Jun 2022 15:51:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0030D136059;
        Tue, 21 Jun 2022 15:51:50 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:49 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 13/20] s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
Date:   Tue, 21 Jun 2022 11:51:27 -0400
Message-Id: <20220621155134.1932383-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2Ox72RIEfU0zora3xrvP11r_8hm4KpAX
X-Proofpoint-GUID: qwjTSO7FdwnOWGMJpY-M53zfq0SIelSy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an AP queue device is probed or removed, if the mediated device is
attached to a KVM guest, the mediated device's adapter, domain and
control domain bitmaps must be filtered to update the guest's APCB and if
any changes are detected, the guest's APCB must then be hot plugged into
the guest to reflect those changes to the guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 93e932458590..090e033cff69 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1782,9 +1782,11 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
-		vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm,
-					   matrix_mdev->matrix.aqm,
-					   matrix_mdev);
+
+		if (vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm,
+					       matrix_mdev->matrix.aqm,
+					       matrix_mdev))
+			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1794,7 +1796,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
-	unsigned long apid;
+	unsigned long apid, apqi;
 	struct vfio_ap_queue *q;
 	struct ap_matrix_mdev *matrix_mdev;
 
@@ -1807,8 +1809,17 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 		vfio_ap_unlink_queue_fr_mdev(q);
 
 		apid = AP_QID_CARD(q->apqn);
-		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
-			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+		apqi = AP_QID_QUEUE(q->apqn);
+
+		/*
+		 * If the queue is assigned to the guest's APCB, then remove
+		 * the adapter's APID from the APCB and hot it into the guest.
+		 */
+		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+		}
 	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
-- 
2.35.3

