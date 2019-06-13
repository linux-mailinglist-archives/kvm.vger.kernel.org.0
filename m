Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31244C4F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfFMTkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:40:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727510AbfFMTkD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 15:40:03 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DJab4x001597
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 15:40:01 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t3tpfw6xa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 15:40:01 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Thu, 13 Jun 2019 20:40:00 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 20:39:57 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DJdrsM36307454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 19:39:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B93126E050;
        Thu, 13 Jun 2019 19:39:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A09D56E04C;
        Thu, 13 Jun 2019 19:39:51 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.158.129])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 19:39:51 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 1/7] s390: vfio-ap: Refactor vfio_ap driver probe and remove callbacks
Date:   Thu, 13 Jun 2019 15:39:34 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061319-0016-0000-0000-000009C23B95
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011256; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01217510; UDB=6.00640242; IPR=6.00998621;
 MB=3.00027298; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-13 19:40:00
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061319-0017-0000-0000-000043A442E7
Message-Id: <1560454780-20359-2-git-send-email-akrowiak@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to limit the number of private mdev functions called from the
vfio_ap device driver as well as to provide a landing spot for dynamic
configuration code related to binding/unbinding AP queue devices to/from
the vfio_ap driver, the following changes are being introduced:

* Move code from the vfio_ap driver's probe callback into a function
  defined in the mdev private operations file.

* Move code from the vfio_ap driver's remove callback into a function
  defined in the mdev private operations file.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 27 ++++++++++-----------------
 drivers/s390/crypto/vfio_ap_ops.c     | 28 ++++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  6 +++---
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 003662aa8060..3c60df70891b 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -49,15 +49,15 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
  */
 static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
 {
-	struct vfio_ap_queue *q;
-
-	q = kzalloc(sizeof(*q), GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
-	dev_set_drvdata(&apdev->device, q);
-	q->apqn = to_ap_queue(&apdev->device)->qid;
-	q->saved_isc = VFIO_AP_ISC_INVALID;
+	int ret;
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
+
+	ret = vfio_ap_mdev_probe_queue(queue);
+	if (ret)
+		return ret;
+
 	return 0;
+
 }
 
 /**
@@ -68,17 +68,10 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
  */
 static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 {
-	struct vfio_ap_queue *q;
-	int apid, apqi;
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
 
 	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	dev_set_drvdata(&apdev->device, NULL);
-	apid = AP_QID_CARD(q->apqn);
-	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
-	kfree(q);
+	vfio_ap_mdev_remove_queue(queue);
 	mutex_unlock(&matrix_dev->lock);
 }
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 015174ff6f0a..bf2ab02b9a0b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1302,3 +1302,31 @@ void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
+{
+	struct vfio_ap_queue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+	dev_set_drvdata(&queue->ap_dev.device, q);
+	q->apqn = queue->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
+{
+	struct vfio_ap_queue *q;
+	int apid, apqi;
+
+	q = dev_get_drvdata(&queue->ap_dev.device);
+	dev_set_drvdata(&queue->ap_dev.device, NULL);
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	vfio_ap_irq_disable(q);
+	kfree(q);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..5cc3c2ebf151 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -90,8 +90,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -100,5 +98,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.7.4

