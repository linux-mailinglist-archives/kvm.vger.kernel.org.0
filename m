Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670E35536D1
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351247AbiFUPwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353226AbiFUPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11962D1EC;
        Tue, 21 Jun 2022 08:51:51 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEpoJC012143;
        Tue, 21 Jun 2022 15:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=03tZz5dW8fkJw0OenpwmCqFBmt9qs0meYxCOyLar3Bw=;
 b=HcNT74SuT0T4Au3cglGkxwPc2xyEtT47YCjXza7Ij4ruaEJNP/O6f/+EcV8rajyeYymb
 hQxGUUyMC1iINB1xBMyoxmdim0QHAA4y6KFbK8sVsDv6kARgSWM1m29N8KC1qjZVKUXS
 11L6qRDb6iD+9zKVEMHxlSN9lieFaZ/RdpjWFG+v+9stPuTXuJv8GB49gqBrDKID3CUj
 4CDBFCkrHv8rovMEAyVLWnQG66mDPF5gIMhfZ2pvjoFx9Qp6z5z1h3BnxYmlzAzLj3+7
 b80TBPKYR5x8FTpJ2ecYmrqekZnlrYwdupUXisoSN9ozXkc1YUjStkXv/mu7ZsNyUnHU qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489uea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:49 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEtS4g026123;
        Tue, 21 Jun 2022 15:51:48 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489udy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:48 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZYnT010326;
        Tue, 21 Jun 2022 15:51:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3gs6b9j1v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:47 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpkn111534672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:46 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ED71136055;
        Tue, 21 Jun 2022 15:51:46 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E29913604F;
        Tue, 21 Jun 2022 15:51:45 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:45 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 09/20] s390/vfio-ap: use proper locking order when setting/clearing KVM pointer
Date:   Tue, 21 Jun 2022 11:51:23 -0400
Message-Id: <20220621155134.1932383-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NLmlNPjsgqtbuMN8CUxJUBorWjNgd9i2
X-Proofpoint-ORIG-GUID: iiOa6RzwMYd412Tp1m2xXOBqtC270pJa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The group notifier that handles the VFIO_GROUP_NOTIFY_SET_KVM event must
use the required locks in proper locking order to dynamically update the
guest's APCB. The proper locking order is:

       1. matrix_dev->guests_lock: required to use the KVM pointer to
          update a KVM guest's APCB.

       2. matrix_mdev->kvm->lock: required to update a KVM guest's APCB.

       3. matrix_dev->mdevs_lock: required to store or access the data
          stored in a struct ap_matrix_mdev instance.

Two macros are introduced to acquire and release the locks in the proper
order. These macros are now used by the group notifier functions.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 56 +++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f81bf8686464..f31db1248740 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -34,6 +34,47 @@ static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
+/**
+ * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
+ *			     KVM guest's APCB in the proper order.
+ *
+ * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
+ *
+ * The proper locking order is:
+ * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
+ *			       guest's APCB.
+ * 2. kvm->lock:	       required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
+ *
+ * Note: If @kvm is NULL, the KVM lock will not be taken.
+ */
+#define get_update_locks_for_kvm(kvm) ({	\
+	mutex_lock(&matrix_dev->guests_lock);	\
+	if (kvm)				\
+		mutex_lock(&kvm->lock);		\
+	mutex_lock(&matrix_dev->mdevs_lock);	\
+})
+
+/**
+ * release_update_locks_for_kvm: Release the locks used to dynamically update a
+ *				 KVM guest's APCB in the proper order.
+ *
+ * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
+ *
+ * The proper unlocking order is:
+ * 1. matrix_dev->mdevs_lock
+ * 2. kvm->lock
+ * 3. matrix_dev->guests_lock
+ *
+ * Note: If @kvm is NULL, the KVM lock will not be released.
+ */
+#define release_update_locks_for_kvm(kvm) ({	\
+	mutex_unlock(&matrix_dev->mdevs_lock);	\
+	if (kvm)				\
+		mutex_unlock(&kvm->lock);		\
+	mutex_unlock(&matrix_dev->guests_lock);	\
+})
+
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
  *			    hash table of queues assigned to a matrix mdev
@@ -1266,13 +1307,11 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
-		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->mdevs_lock);
+		get_update_locks_for_kvm(kvm);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 			if (m != matrix_mdev && m->kvm == kvm) {
-				mutex_unlock(&kvm->lock);
-				mutex_unlock(&matrix_dev->mdevs_lock);
+				release_update_locks_for_kvm(kvm);
 				return -EPERM;
 			}
 		}
@@ -1283,8 +1322,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
 
-		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->mdevs_lock);
+		release_update_locks_for_kvm(kvm);
 	}
 
 	return 0;
@@ -1335,16 +1373,14 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		kvm->arch.crypto.pqap_hook = NULL;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
-		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->mdevs_lock);
+		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
-		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->mdevs_lock);
+		release_update_locks_for_kvm(kvm);
 	}
 }
 
-- 
2.35.3

