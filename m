Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84DE786F77
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbjHXMrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbjHXMqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1FAE59;
        Thu, 24 Aug 2023 05:46:28 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgqkw029025;
        Thu, 24 Aug 2023 12:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=9QYc+jaJVOqc12+ma4ZDSnSpaRe4z2Onj8RhPZp/dNg=;
 b=RxrpvBkDXebuSFQEJUICUntwBtQn1NPLM82r9mVeBUlYeNw5fw/srdFl9ZK4pFRR2vFD
 VsvTXBezwvnvKByA8ZZtFwPvzhO2bzffYeXAa6KU+PmUjv7VcCgHdjKTnNybBgpi4LBo
 qAGqDRMN4o6Z6gtbc4E1v5RU+l0TVU1dwl6qBviDWoQi+gcj1TBXMak5n6z2msl6e9mD
 xur0BpJBS5T+PMeewIhnZQhyjUiLW5vkqAwuCA0r/cqyres8lbph2ZUgrPjm4LcZEtia
 YRJYLDfHrXPUbQlqP5mCFVI0Jj60qhJKs+McQ+kylbHPHwyKq7OpAZLyzcigc5m+TeC7 qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:26 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh2bS029637;
        Thu, 24 Aug 2023 12:46:23 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:23 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCHVe7027375;
        Thu, 24 Aug 2023 12:46:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sq13y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkHR841878016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F422004D;
        Thu, 24 Aug 2023 12:46:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E41B020040;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 12/22] s390/vfio-ap: store entire AP queue status word with the queue object
Date:   Thu, 24 Aug 2023 14:43:21 +0200
Message-ID: <20230824124522.75408-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wgmJ0LS0UKGiStrJ_E2G8AvFD7hA38Kr
X-Proofpoint-GUID: 4Xz058-x-XpbKcBIpYJ1J-BazfNCj_Ob
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

Store the entire AP queue status word returned from the ZAPQ command with
the struct vfio_ap_queue object instead of just the response code field.
The other information contained in the status word is need by the
apq_reset_check function to display a proper message to indicate that the
vfio_ap driver is waiting for the ZAPQ to complete because the queue is
not empty or IRQs are still enabled.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-7-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
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
2.41.0

