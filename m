Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F31D77D236
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbjHOSoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbjHOSnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D17BF1;
        Tue, 15 Aug 2023 11:43:50 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIWj8p009854;
        Tue, 15 Aug 2023 18:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Vtj6EqsqhUzdnlU0FHavUdzOqQEDLlQ/XTaLrKfovIY=;
 b=DtG2Fnyf+ABHmSlDAwxlARF2OFiYFxkoSwnwIdnPrC1zw5mgXfh5n01b37yhpvKs6c72
 0Danr43wmVNPZPmIKWVOgcjE/dqdBLvGQwCEQ8bQvof2ajHoxQisR+o/oCef7y2Ig0DK
 L2J6gfTPTuuTxCflg6LZVZWMH978VptGSMxOZcfXNMxIx8yXwGUt0b6heuki991qCbmn
 aNTXzCJRYt2daxF/alltEhl+bCmAtXfQFAEJ/dc6B1d7HMPBqt0wBrDX5qdbZt5C625v
 Q1iWKUW1edsmMjhhABNCFARJO/jSk7dU60xcMCWq+HukYRHXoan0kT67353Ajl3+aWut ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIXX7x012515;
        Tue, 15 Aug 2023 18:43:46 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:46 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FGj2Y2003459;
        Tue, 15 Aug 2023 18:43:45 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsffpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:45 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhi1U37683814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:44 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C21B5803F;
        Tue, 15 Aug 2023 18:43:44 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0599E5804E;
        Tue, 15 Aug 2023 18:43:43 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 06/12] s390/vfio-ap: store entire AP queue status word with the queue object
Date:   Tue, 15 Aug 2023 14:43:27 -0400
Message-Id: <20230815184333.6554-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PMHvnCaDrUXt7awFXbWTDYeY_3V-Q5xo
X-Proofpoint-ORIG-GUID: oiKEn60BM0mpquRfb5M9k1AwrlewxtCT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store the entire AP queue status word returned from the ZAPQ command with
the struct vfio_ap_queue object instead of just the response code field.
The other information contained in the status word is need by the
apq_reset_check function to display a proper message to indicate that the
vfio_ap driver is waiting for the ZAPQ to complete because the queue is
not empty or IRQs are still enabled.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 27 +++++++++++++++------------
 drivers/s390/crypto/vfio_ap_private.h |  4 ++--
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2517868aad56..43224f7a40ea 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -674,7 +674,7 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 			 */
 			apqn = AP_MKQID(apid, apqi);
 			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
-			if (!q || q->reset_rc) {
+			if (!q || q->reset_status.response_code) {
 				clear_bit_inv(apid,
 					      matrix_mdev->shadow_apcb.apm);
 				break;
@@ -1628,6 +1628,7 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 	int ret = -EBUSY, elapsed = 0;
 	struct ap_queue_status status;
 
+	memcpy(&status, &q->reset_status, sizeof(status));
 	while (true) {
 		msleep(AP_RESET_INTERVAL);
 		elapsed += AP_RESET_INTERVAL;
@@ -1643,20 +1644,20 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 					      status.queue_empty,
 					      status.irq_enabled);
 		} else {
-			if (q->reset_rc == AP_RESPONSE_RESET_IN_PROGRESS ||
-			    q->reset_rc == AP_RESPONSE_BUSY) {
+			if (q->reset_status.response_code == AP_RESPONSE_RESET_IN_PROGRESS ||
+			    q->reset_status.response_code == AP_RESPONSE_BUSY) {
 				status = ap_zapq(q->apqn, 0);
-				q->reset_rc = status.response_code;
+				memcpy(&q->reset_status, &status, sizeof(status));
 				continue;
 			}
 			/*
-			 * When an AP adapter is deconfigured, the associated
-			 * queues are reset, so let's set the status response
-			 * code to 0 so the queue may be passed through (i.e.,
-			 * not filtered).
+			 * When an AP adapter is deconfigured, the
+			 * associated queues are reset, so let's set the
+			 * status response code to 0 so the queue may be
+			 * passed through (i.e., not filtered)
 			 */
-			if (q->reset_rc == AP_RESPONSE_DECONFIGURED)
-				q->reset_rc = 0;
+			if (status.response_code == AP_RESPONSE_DECONFIGURED)
+				q->reset_status.response_code = 0;
 			if (q->saved_isc != VFIO_AP_ISC_INVALID)
 				vfio_ap_free_aqic_resources(q);
 			break;
@@ -1673,7 +1674,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	if (!q)
 		return 0;
 	status = ap_zapq(q->apqn, 0);
-	q->reset_rc = status.response_code;
+	memcpy(&q->reset_status, &status, sizeof(status));
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
@@ -1688,7 +1689,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		 * so the queue may be passed through (i.e., not filtered) and
 		 * return a value indicating the reset completed successfully.
 		 */
-		q->reset_rc = 0;
+		q->reset_status.response_code = 0;
+		ret = 0;
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
@@ -2042,6 +2044,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	memset(&q->reset_status, 0, sizeof(q->reset_status));
 	matrix_mdev = get_update_locks_by_apqn(q->apqn);
 
 	if (matrix_mdev) {
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 4642bbdbd1b2..d6eb3527e056 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -133,7 +133,7 @@ struct ap_matrix_mdev {
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
- * @reset_rc: the status response code from the last reset of the queue
+ * @reset_status: the status from the last reset of the queue
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -142,7 +142,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
-	unsigned int reset_rc;
+	struct ap_queue_status reset_status;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.39.3

