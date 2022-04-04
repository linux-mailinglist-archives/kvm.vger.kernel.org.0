Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C374F1F64
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiDDWyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbiDDWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412324B85C;
        Mon,  4 Apr 2022 15:11:52 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234M6fPC025528;
        Mon, 4 Apr 2022 22:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tAv2W4TTYQ74/UoFL7tje9Eav9uycoEiQyhFs5OznCc=;
 b=GQjR/5vLAST53mJfWzr5GiQpTq2IUjocFhWCl9zZ+qHK96vLJapNEKWe1yHQCv2c00TT
 resLoYiD3okjebDKi56jRuvwco1D1iFI0minUJPh2kpw4QnqurHh3kMqQvwNsl96epIy
 ZtMax5+96S8K7laOhz5KcLCMoCSo+5HF2zuGS9ilV084EwAhgUL+1edPdFC7V0iJQp4V
 zUOQQR19qr6rI1wln1Fo3vJyttgf4rXlcEdVxtpV447vXEM5nobDAvkZzOM5Ho59Nhp8
 4ME09zQgGjZcaOBQ16NmUlqJn4dyqeWdGQhCjgjFK9+RRYElTNQXIMg7L8HqeBpqxnTa Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:49 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234Lr2OS007865;
        Mon, 4 Apr 2022 22:11:49 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy19v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:49 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234LqurB027694;
        Mon, 4 Apr 2022 22:11:48 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3f6e49aq0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBlUW35520800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 451487805F;
        Mon,  4 Apr 2022 22:11:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DF097806B;
        Mon,  4 Apr 2022 22:11:46 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:46 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 02/20] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Mon,  4 Apr 2022 18:10:21 -0400
Message-Id: <20220404221039.1272245-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SJGKmlLYk6ykX0rqA9vJ8dDLsCOpPQEa
X-Proofpoint-ORIG-GUID: vTjzIUmtna_foWBoH0MMeyNSDabK4Eys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/s390/crypto/vfio_ap_drv.c     | 59 +--------------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 31 +++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  5 ++-
 3 files changed, 34 insertions(+), 61 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 29ebd54f8919..9a300dd3b6f7 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -104,64 +104,9 @@ static const struct attribute_group vfio_queue_attr_group = {
 	.attrs = vfio_queue_attrs,
 };
 
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
index 2227919fde13..16220157dbe3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1314,8 +1314,7 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry)
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 {
 	struct ap_queue_status status;
 	int ret;
@@ -1524,3 +1523,31 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
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
+	q = dev_get_drvdata(&apdev->device);
+	vfio_ap_mdev_reset_queue(q, 1);
+	dev_set_drvdata(&apdev->device, NULL);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 648fcaf8104a..3cade25a1620 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -119,7 +119,8 @@ struct vfio_ap_queue {
 
 int vfio_ap_mdev_register(void);
 void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

