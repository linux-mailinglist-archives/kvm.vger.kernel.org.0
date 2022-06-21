Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87E85536AE
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350531AbiFUPvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353155AbiFUPvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7596F2CE18;
        Tue, 21 Jun 2022 08:51:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFOnqY020079;
        Tue, 21 Jun 2022 15:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JfshRDesBRutj1RMxiMUBXVOkA4yJ4jJe/70MOpjrzQ=;
 b=CXWtZf1OEwZwLudPMkGncx06AQto/MmuAIgTef5owfqgdbMSBDWZQDyxCo4vG5/t6FRg
 MEWjSPuPOYm8pldV7StIXq6sjiSy1R9rtCrpY02YuPlymYPpwnLZdZYXR3cIARsCmRIe
 EYR4YWVOMblVvDc39QnYtBxJK5PeOsNRQaS8S6d8P0nU/XoihTJPAkF4A4rRDf+iTY3q
 RaN3D99kIhALuyGsYHACiAKHQxs+jz3Sio72bNt7NFfVQilnA/RVr0RTop5h/Gp3Ol8/
 e2Oup5T90KwzF/b/EEc2KqjUU0bvmcXG0r+ZZis7V3fj23Ts7JZT1KZ4TmSnZms1eJSB Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFRghS034752;
        Tue, 21 Jun 2022 15:51:40 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:40 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZdCW010359;
        Tue, 21 Jun 2022 15:51:39 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3gs6b9j1uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpclr22151612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41930136051;
        Tue, 21 Jun 2022 15:51:38 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43CA0136055;
        Tue, 21 Jun 2022 15:51:37 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:37 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 02/20] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Tue, 21 Jun 2022 11:51:16 -0400
Message-Id: <20220621155134.1932383-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f7v8-jg7BSlkr9z8Wvz5r9JFzJmiAgbN
X-Proofpoint-GUID: 7uXjg9HcOjA2n2sDMc7wrY-VcMf0SqbD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's move the probe and remove callbacks into the vfio_ap_ops.c
file to keep all code related to managing queues in a single file. This
way, all functions related to queue management can be removed from the
vfio_ap_private.h header file defining the public interfaces for the
vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 118 +-------------------------
 drivers/s390/crypto/vfio_ap_ops.c     |  99 ++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |   5 +-
 3 files changed, 102 insertions(+), 120 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 4ac9c6521ec1..1ff6e3dbbffe 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -18,9 +18,6 @@
 
 #define VFIO_AP_ROOT_NAME "vfio_ap"
 #define VFIO_AP_DEV_NAME "matrix"
-#define AP_QUEUE_ASSIGNED "assigned"
-#define AP_QUEUE_UNASSIGNED "unassigned"
-#define AP_QUEUE_IN_USE "in use"
 
 MODULE_AUTHOR("IBM Corporation");
 MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
@@ -46,120 +43,9 @@ static struct ap_device_id ap_queue_ids[] = {
 	{ /* end of sibling */ },
 };
 
-static struct ap_matrix_mdev *vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
-{
-	struct ap_matrix_mdev *matrix_mdev;
-	unsigned long apid = AP_QID_CARD(q->apqn);
-	unsigned long apqi = AP_QID_QUEUE(q->apqn);
-
-	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
-		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
-		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
-			return matrix_mdev;
-	}
-
-	return NULL;
-}
-
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr,
-			   char *buf)
-{
-	ssize_t nchars = 0;
-	struct vfio_ap_queue *q;
-	struct ap_matrix_mdev *matrix_mdev;
-	struct ap_device *apdev = to_ap_dev(dev);
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	matrix_mdev = vfio_ap_mdev_for_queue(q);
-
-	if (matrix_mdev) {
-		if (matrix_mdev->kvm)
-			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
-					   AP_QUEUE_IN_USE);
-		else
-			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
-					   AP_QUEUE_ASSIGNED);
-	} else {
-		nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
-				   AP_QUEUE_UNASSIGNED);
-	}
-
-	mutex_unlock(&matrix_dev->lock);
-
-	return nchars;
-}
-
-static DEVICE_ATTR_RO(status);
-
-static struct attribute *vfio_queue_attrs[] = {
-	&dev_attr_status.attr,
-	NULL,
-};
-
-static const struct attribute_group vfio_queue_attr_group = {
-	.attrs = vfio_queue_attrs,
-};
-
-/**
- * vfio_ap_queue_dev_probe: Allocate a vfio_ap_queue structure and associate it
- *			    with the device as driver_data.
- *
- * @apdev: the AP device being probed
- *
- * Return: returns 0 if the probe succeeded; otherwise, returns an error if
- *	   storage could not be allocated for a vfio_ap_queue object or the
- *	   sysfs 'status' attribute could not be created for the queue device.
- */
-static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
-{
-	int ret;
-	struct vfio_ap_queue *q;
-
-	q = kzalloc(sizeof(*q), GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
-
-	mutex_lock(&matrix_dev->lock);
-	dev_set_drvdata(&apdev->device, q);
-	q->apqn = to_ap_queue(&apdev->device)->qid;
-	q->saved_isc = VFIO_AP_ISC_INVALID;
-
-	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
-	if (ret) {
-		dev_set_drvdata(&apdev->device, NULL);
-		kfree(q);
-	}
-
-	mutex_unlock(&matrix_dev->lock);
-
-	return ret;
-}
-
-/**
- * vfio_ap_queue_dev_remove: Free the associated vfio_ap_queue structure.
- *
- * @apdev: the AP device being removed
- *
- * Takes the matrix lock to avoid actions on this device while doing the remove.
- */
-static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-
-	mutex_lock(&matrix_dev->lock);
-	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
-	q = dev_get_drvdata(&apdev->device);
-	vfio_ap_mdev_reset_queue(q, 1);
-	dev_set_drvdata(&apdev->device, NULL);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static struct ap_driver vfio_ap_drv = {
-	.probe = vfio_ap_queue_dev_probe,
-	.remove = vfio_ap_queue_dev_remove,
+	.probe = vfio_ap_mdev_probe_queue,
+	.remove = vfio_ap_mdev_remove_queue,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 634e23ae8912..32d276c85079 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,6 +26,10 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
+#define AP_QUEUE_ASSIGNED "assigned"
+#define AP_QUEUE_UNASSIGNED "unassigned"
+#define AP_QUEUE_IN_USE "in use"
+
 static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
@@ -1294,8 +1298,8 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry)
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
+				    unsigned int retry)
 {
 	struct ap_queue_status status;
 	int ret;
@@ -1452,6 +1456,62 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 	return ret;
 }
 
+static struct ap_matrix_mdev *vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
+			return matrix_mdev;
+	}
+
+	return NULL;
+}
+
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	ssize_t nchars = 0;
+	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
+	struct ap_device *apdev = to_ap_dev(dev);
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&apdev->device);
+	matrix_mdev = vfio_ap_mdev_for_queue(q);
+
+	if (matrix_mdev) {
+		if (matrix_mdev->kvm)
+			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
+					   AP_QUEUE_IN_USE);
+		else
+			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
+					   AP_QUEUE_ASSIGNED);
+	} else {
+		nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
+				   AP_QUEUE_UNASSIGNED);
+	}
+
+	mutex_unlock(&matrix_dev->lock);
+
+	return nchars;
+}
+
+static DEVICE_ATTR_RO(status);
+
+static struct attribute *vfio_queue_attrs[] = {
+	&dev_attr_status.attr,
+	NULL,
+};
+
+static const struct attribute_group vfio_queue_attr_group = {
+	.attrs = vfio_queue_attrs,
+};
+
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.open_device = vfio_ap_mdev_open_device,
 	.close_device = vfio_ap_mdev_close_device,
@@ -1495,3 +1555,38 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
+{
+	int ret;
+	struct vfio_ap_queue *q;
+
+	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
+	if (ret)
+		return ret;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+
+	mutex_lock(&matrix_dev->lock);
+	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+	dev_set_drvdata(&apdev->device, q);
+	mutex_unlock(&matrix_dev->lock);
+
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+
+	mutex_lock(&matrix_dev->lock);
+	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
+	q = dev_get_drvdata(&apdev->device);
+	vfio_ap_mdev_reset_queue(q, 1);
+	dev_set_drvdata(&apdev->device, NULL);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index a26efd804d0d..96655f2eb732 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -116,7 +116,8 @@ struct vfio_ap_queue {
 
 int vfio_ap_mdev_register(void);
 void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.35.3

