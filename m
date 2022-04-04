Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634364F1F96
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiDDWyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023584BB84;
        Mon,  4 Apr 2022 15:12:01 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234LwONc007191;
        Mon, 4 Apr 2022 22:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gb3KSBZv5ilmfGwrsT/tqtMY744PdnTTtSgD/vhFVdE=;
 b=eE//23vg3w/RYsHHEDAfxChmR1azxTv+vPXC96R9rne4OHGEbCqEtXp3KsH+Ri8883NI
 Iu+038CEDtUxEovIDZrePEggctuL4yz8Y5AJVKC1RQP69jC312n3X4+v3IESOwg+ZBPY
 iHJ/VAlbWeuZWq5h7rUngp9o1FjNL5ZMozJtjfOEwsTUe5XbxQjyuiIyoMx9Kj/yD63K
 snWwmoV3BTK4HedPayEflkjLPw0ivX7eXLWegcj2iUqVojtoEnusJtgOLYimpFvKS5r7
 5nx2RZA9jknIaO1SqirDmeAniQs9cfTJzJJhdslVkgWj9yxVEhWL7MbptjO6uctiLYFb Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tc534p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LwCHr027815;
        Mon, 4 Apr 2022 22:11:59 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tc534b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:59 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr3M4014664;
        Mon, 4 Apr 2022 22:11:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3f6e49q9ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:58 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBu7a34537896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:56 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C08477805C;
        Mon,  4 Apr 2022 22:11:56 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B471B7805F;
        Mon,  4 Apr 2022 22:11:55 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:55 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 10/20] s390/vfio-ap: prepare for dynamic update of guest's APCB on assign/unassign
Date:   Mon,  4 Apr 2022 18:10:29 -0400
Message-Id: <20220404221039.1272245-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _e2SbkxQhNp-gwWFuvk9J_xdQYzPt0tm
X-Proofpoint-ORIG-GUID: m5RLrnZBmnpnFG5krYZpvV7vKLCgtnT0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 757bbf449b04..2219b1069ceb 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -71,6 +71,51 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
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
@@ -827,7 +872,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -859,7 +904,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 				   matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return ret;
 }
@@ -902,7 +947,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow unassignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -927,7 +972,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -982,7 +1027,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1013,7 +1058,7 @@ static ssize_t assign_domain_store(struct device *dev,
 				   matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return ret;
 }
@@ -1056,7 +1101,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow unassignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1082,7 +1127,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	ret = count;
 
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -1109,7 +1154,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If the KVM guest is running, disallow assignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1135,7 +1180,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -1163,7 +1208,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	get_update_locks_for_mdev(matrix_mdev);
 
 	/* If a KVM guest is running, disallow unassignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1186,7 +1231,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
-- 
2.31.1

