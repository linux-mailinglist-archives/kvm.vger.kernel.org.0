Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C481A15DB
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgDGTUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:20:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbgDGTUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J37UY034644;
        Tue, 7 Apr 2020 15:20:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx33xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:32 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J3LIG036064;
        Tue, 7 Apr 2020 15:20:32 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx33x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:31 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKDlF007745;
        Tue, 7 Apr 2020 19:20:30 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 306hv6jffp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:30 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKTSo31064438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:29 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C76128060;
        Tue,  7 Apr 2020 19:20:29 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7772328071;
        Tue,  7 Apr 2020 19:20:28 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:28 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table for quick access
Date:   Tue,  7 Apr 2020 15:20:01 -0400
Message-Id: <20200407192015.19887-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 suspectscore=3 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004070153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than looping over potentially 65535 objects, let's store the
structures for caching information about queue devices bound to the
vfio_ap device driver in a hash table keyed by APQN.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 28 +++------
 drivers/s390/crypto/vfio_ap_ops.c     | 90 ++++++++++++++-------------
 drivers/s390/crypto/vfio_ap_private.h | 10 ++-
 3 files changed, 60 insertions(+), 68 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..e9c226c0730e 100644
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
@@ -135,6 +120,7 @@ static int vfio_ap_matrix_dev_create(void)
 
 	mutex_init(&matrix_dev->lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
+	hash_init(matrix_dev->qtable);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
 	matrix_dev->device.parent = root_device;
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 5c0f53c6dde7..134860934fe7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,45 +26,16 @@
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 
-static int match_apqn(struct device *dev, const void *data)
-{
-	struct vfio_ap_queue *q = dev_get_drvdata(dev);
-
-	return (q->apqn == *(int *)(data)) ? 1 : 0;
-}
-
-/**
- * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
- * @matrix_mdev: the associated mediated matrix
- * @apqn: The queue APQN
- *
- * Retrieve a queue with a specific APQN from the list of the
- * devices of the vfio_ap_drv.
- * Verify that the APID and the APQI are set in the matrix.
- *
- * Returns the pointer to the associated vfio_ap_queue
- */
-static struct vfio_ap_queue *vfio_ap_get_queue(
-					struct ap_matrix_mdev *matrix_mdev,
-					int apqn)
+struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
 {
 	struct vfio_ap_queue *q;
-	struct device *dev;
-
-	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
-		return NULL;
-	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
-		return NULL;
-
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (!dev)
-		return NULL;
-	q = dev_get_drvdata(dev);
-	q->matrix_mdev = matrix_mdev;
-	put_device(dev);
 
-	return q;
+	hash_for_each_possible(matrix_dev->qtable, q, qnode, apqn) {
+		if (q && (apqn == q->apqn))
+			return q;
+	}
+
+	return NULL;
 }
 
 /**
@@ -293,10 +264,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_get_queue(apqn);
 	if (!q)
 		goto out_unlock;
 
+	q->matrix_mdev = matrix_mdev;
 	status = vcpu->run->s.regs.gprs[1];
 
 	/* If IR bit(16) is set we enable the interrupt */
@@ -1116,16 +1088,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
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
@@ -1302,3 +1269,38 @@ void vfio_ap_mdev_unregister(void)
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
+	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
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
+	hash_del(&q->qnode);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..e1f8c82cc55d 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/hashtable.h>
 
 #include "ap_bus.h"
 
@@ -43,6 +44,7 @@ struct ap_matrix_dev {
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
+	DECLARE_HASHTABLE(qtable, 8);
 };
 
 extern struct ap_matrix_dev *matrix_dev;
@@ -90,8 +92,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -99,6 +99,10 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node qnode;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+
+int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

