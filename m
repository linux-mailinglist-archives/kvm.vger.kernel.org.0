Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69AC5536C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353117AbiFUPw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352526AbiFUPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376E2D1F5;
        Tue, 21 Jun 2022 08:51:53 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFpooA007090;
        Tue, 21 Jun 2022 15:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+c9Ym2/jEO2EvKj7OIFvoGbeONLFVFh4FdZOieugtCg=;
 b=OejOwU/Doc4bsD/HhA8S3Fhh09TvpYEuawGngobXNxloesHsqOUO/E2IT7iQM08brdiz
 YNQpqcJ8MelYkQ4PNfxb+MlI9fAKzIoX7DhhkUSyjzvZtJPO4AzvkMZpWXSirhjx1tdp
 j2V67oleRzBTo2azaq+JUaWx5n76Z9fh4Sfha5slbLjCfPsosGNgp1fg1J3ixYKCPDte
 E38FXvVoSD0KJ6HYSu5hfXvh1niZdrYy+rwKVjKiIXUnJQQB7G8w8edN5vCmeVfVaNyb
 S39ghmBfMTeUsdm/6HL4q6W/VoUaczlVmBdn4jvuTu02EOWm8WvdqOE5YM8f3OQYxIu3 oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh0bg012-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:50 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFpnj5006943;
        Tue, 21 Jun 2022 15:51:50 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh0bg00u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:49 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZvoT031799;
        Tue, 21 Jun 2022 15:51:49 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3gt0091y7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpl2B35586454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:47 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B19213605D;
        Tue, 21 Jun 2022 15:51:47 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8990B13604F;
        Tue, 21 Jun 2022 15:51:46 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:46 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 10/20] s390/vfio-ap: prepare for dynamic update of guest's APCB on assign/unassign
Date:   Tue, 21 Jun 2022 11:51:24 -0400
Message-Id: <20220621155134.1932383-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mg8OlZoU3r3CUrw1CscYLcpVQjcRS7wK
X-Proofpoint-ORIG-GUID: CdXYa4pnvdI6G9x2DSuKccxl22c6bSJG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions backing the matrix mdev's sysfs attribute interfaces to
assign/unassign adapters, domains and control domains must take and
release the locks required to perform a dynamic update of a guest's APCB
in the proper order.

The proper order for taking the locks is:

matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock

The proper order for releasing the locks is:

matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock

Two new macros are introduced for this purpose: One to take the locks and
the other to release the locks. These macros will be used by the
assignment/unassignment functions to prepare for dynamic update of
the KVM guest's APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 69 +++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f31db1248740..b8f901e6b580 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -75,6 +75,51 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 	mutex_unlock(&matrix_dev->guests_lock);	\
 })
 
+/**
+ * get_update_locks_for_mdev: Acquire the locks required to dynamically update a
+ *			      KVM guest's APCB in the proper order.
+ *
+ * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
+ *		 configuration data to use to update a KVM guest's APCB.
+ *
+ * The proper locking order is:
+ * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
+ *			       guest's APCB.
+ * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
+ *
+ * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
+ *	 lock will not be taken.
+ */
+#define get_update_locks_for_mdev(matrix_mdev) ({	\
+	mutex_lock(&matrix_dev->guests_lock);		\
+	if (matrix_mdev && matrix_mdev->kvm)		\
+		mutex_lock(&matrix_mdev->kvm->lock);	\
+	mutex_lock(&matrix_dev->mdevs_lock);		\
+})
+
+/**
+ * release_update_locks_for_mdev: Release the locks used to dynamically update a
+ *				  KVM guest's APCB in the proper order.
+ *
+ * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
+ *		 configuration data to use to update a KVM guest's APCB.
+ *
+ * The proper unlocking order is:
+ * 1. matrix_dev->mdevs_lock
+ * 2. matrix_mdev->kvm->lock
+ * 3. matrix_dev->guests_lock
+ *
+ * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
+ *	 lock will not be released.
+ */
+#define release_update_locks_for_mdev(matrix_mdev) ({	\
+	mutex_unlock(&matrix_dev->mdevs_lock);		\
+	if (matrix_mdev && matrix_mdev->kvm)		\
+		mutex_unlock(&matrix_mdev->kvm->lock);		\
+	mutex_unlock(&matrix_dev->guests_lock);		\
+})
+
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
  *			    hash table of queues assigned to a matrix mdev
@@ -830,7 +875,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -862,7 +907,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 				   matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return ret;
 }
@@ -905,7 +950,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow unassignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -930,7 +975,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -985,7 +1030,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1016,7 +1061,7 @@ static ssize_t assign_domain_store(struct device *dev,
 				   matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return ret;
 }
@@ -1059,7 +1104,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow unassignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1085,7 +1130,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	ret = count;
 
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -1112,7 +1157,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1138,7 +1183,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -1166,7 +1211,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If a KVM guest is running, disallow unassignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1189,7 +1234,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
-- 
2.35.3

