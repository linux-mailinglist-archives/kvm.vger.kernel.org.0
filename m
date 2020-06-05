Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A71F0241
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgFEVkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:40:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728805AbgFEVkO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LXK8K028866;
        Fri, 5 Jun 2020 17:40:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fm40yw54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:13 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LXMJm028982;
        Fri, 5 Jun 2020 17:40:13 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fm40yw4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:12 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LZBfc027082;
        Fri, 5 Jun 2020 21:40:11 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 31bf495gw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:11 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeAch36765982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:10 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52A7FAC059;
        Fri,  5 Jun 2020 21:40:10 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9CC9AC060;
        Fri,  5 Jun 2020 21:40:09 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 02/16] s390/vfio-ap: use new AP bus interface to search for queue devices
Date:   Fri,  5 Jun 2020 17:39:50 -0400
Message-Id: <20200605214004.14270-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 cotscore=-2147483648 phishscore=0 mlxscore=0 suspectscore=3
 impostorscore=0 adultscore=0 mlxlogscore=944 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactor's the vfio_ap device driver to use the AP bus's
ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
information about a queue that is bound to the vfio_ap device driver.
The bus's ap_get_qdev() function retrieves the queue device from a
hashtable keyed by APQN. This is much more efficient than looping over
the list of devices attached to the AP bus by several orders of
magnitude.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 27 ++-------
 drivers/s390/crypto/vfio_ap_ops.c     | 82 +++++++++++++++------------
 drivers/s390/crypto/vfio_ap_private.h |  8 ++-
 3 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..59233cf7419d 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -51,15 +51,9 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
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
-	return 0;
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
+
+	return vfio_ap_mdev_probe_queue(queue);
 }
 
 /**
@@ -70,18 +64,9 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
  */
 static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 {
-	struct vfio_ap_queue *q;
-	int apid, apqi;
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	dev_set_drvdata(&apdev->device, NULL);
-	apid = AP_QID_CARD(q->apqn);
-	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
+
+	vfio_ap_mdev_remove_queue(queue);
 }
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..7c96b6fd9f70 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,43 +26,26 @@
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 
-static int match_apqn(struct device *dev, const void *data)
-{
-	struct vfio_ap_queue *q = dev_get_drvdata(dev);
-
-	return (q->apqn == *(int *)(data)) ? 1 : 0;
-}
-
 /**
- * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
- * @matrix_mdev: the associated mediated matrix
+ * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
  * @apqn: The queue APQN
  *
- * Retrieve a queue with a specific APQN from the list of the
- * devices of the vfio_ap_drv.
- * Verify that the APID and the APQI are set in the matrix.
+ * Retrieve a queue with a specific APQN from the AP queue devices attached to
+ * the AP bus.
  *
- * Returns the pointer to the associated vfio_ap_queue
+ * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
  */
-static struct vfio_ap_queue *vfio_ap_get_queue(
-					struct ap_matrix_mdev *matrix_mdev,
-					int apqn)
+static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
 {
+	struct ap_queue *queue;
 	struct vfio_ap_queue *q;
-	struct device *dev;
 
-	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
-		return NULL;
-	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
+	queue = ap_get_qdev(apqn);
+	if (!queue)
 		return NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (!dev)
-		return NULL;
-	q = dev_get_drvdata(dev);
-	q->matrix_mdev = matrix_mdev;
-	put_device(dev);
+	q = dev_get_drvdata(&queue->ap_dev.device);
+	put_device(&queue->ap_dev.device);
 
 	return q;
 }
@@ -293,10 +276,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_get_queue(apqn);
 	if (!q)
 		goto out_unlock;
 
+	q->matrix_mdev = matrix_mdev;
 	status = vcpu->run->s.regs.gprs[1];
 
 	/* If IR bit(16) is set we enable the interrupt */
@@ -1116,16 +1100,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
 static void vfio_ap_irq_disable_apqn(int apqn)
 {
-	struct device *dev;
 	struct vfio_ap_queue *q;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (dev) {
-		q = dev_get_drvdata(dev);
+	q = vfio_ap_get_queue(apqn);
+	if (q)
 		vfio_ap_irq_disable(q);
-		put_device(dev);
-	}
 }
 
 int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
@@ -1302,3 +1281,36 @@ void vfio_ap_mdev_unregister(void)
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
+
+	mutex_lock(&matrix_dev->lock);
+	dev_set_drvdata(&queue->ap_dev.device, q);
+	q->apqn = queue->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+	mutex_unlock(&matrix_dev->lock);
+
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
+{
+	struct vfio_ap_queue *q;
+	int apid, apqi;
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&queue->ap_dev.device);
+	dev_set_drvdata(&queue->ap_dev.device, NULL);
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	vfio_ap_irq_disable(q);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..a2aa05bec718 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/hashtable.h>
 
 #include "ap_bus.h"
 
@@ -90,8 +91,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -100,5 +99,8 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+
+int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

