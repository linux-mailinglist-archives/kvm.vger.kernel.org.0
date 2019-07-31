Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948217D14E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 00:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfGaWle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 18:41:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727348AbfGaWld (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Jul 2019 18:41:33 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VMa7Ap137840;
        Wed, 31 Jul 2019 18:41:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u3gtaq0hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:30 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6VMaLKN137961;
        Wed, 31 Jul 2019 18:41:30 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u3gtaq0h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6VMeqv4025344;
        Wed, 31 Jul 2019 22:41:28 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2u0e85vwry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 22:41:28 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VMfQtB49414426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 22:41:26 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17F5928059;
        Wed, 31 Jul 2019 22:41:26 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AB1A28058;
        Wed, 31 Jul 2019 22:41:25 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.130.145])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 31 Jul 2019 22:41:25 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v5 5/7] s390: vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Wed, 31 Jul 2019 18:41:15 -0400
Message-Id: <1564612877-7598-6-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310225
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's allow AP resources - i.e., adapters, domains and control domains -
to be assigned to or unassigned from an AP matrix mdev while it is in use
by a guest. If an AP resource is assigned while a guest is using the
matrix mdev, the guest's CRYCB will be dynamically updated to grant
access to the adapter, domain or control domain being assigned. If an
AP resource is unassigned while a guest is using the matrix mdev, the
guest's CRYCB will be dynamically updated to take access to the adapter,
domain or control domain away from the guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 68 ++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 360a16d025dd..0e748819abb6 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -466,6 +466,16 @@ static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
 	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm, aqm);
 }
 
+static void vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
+		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+	}
+}
+
 /**
  * assign_adapter_store
  *
@@ -476,7 +486,10 @@ static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
  * @count:	the number of bytes in @buf
  *
  * Parses the APID from @buf and sets the corresponding bit in the mediated
- * matrix device's APM.
+ * matrix device's APM. If a guest is using the mediated matrix device and each
+ * new APQN formed as a result of the assignment identifies an AP queue device
+ * that is bound to the vfio_ap device driver, the guest will be granted access
+ * to the adapter with the specified APID.
  *
  * Returns the number of bytes processed if the APID is valid; otherwise,
  * returns one of the following errors:
@@ -508,10 +521,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -529,7 +538,9 @@ static ssize_t assign_adapter_store(struct device *dev,
 		mutex_unlock(&matrix_dev->lock);
 		return ret;
 	}
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -545,7 +556,9 @@ static DEVICE_ATTR_WO(assign_adapter);
  * @count:	the number of bytes in @buf
  *
  * Parses the APID from @buf and clears the corresponding bit in the mediated
- * matrix device's APM.
+ * matrix device's APM. If a guest is using the mediated matrix device and has
+ * access to the AP adapter with the specified APID, access to the adapter will
+ * be taken from the guest.
  *
  * Returns the number of bytes processed if the APID is valid; otherwise,
  * returns one of the following errors:
@@ -562,10 +575,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -575,6 +584,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -591,7 +601,10 @@ static DEVICE_ATTR_WO(unassign_adapter);
  * @count:	the number of bytes in @buf
  *
  * Parses the APQI from @buf and sets the corresponding bit in the mediated
- * matrix device's AQM.
+ * matrix device's AQM. If a guest is using the mediated matrix device and each
+ * new APQN formed as a result of the assignment identifies an AP queue device
+ * that is bound to the vfio_ap device driver, the guest will be given access
+ * to the AP queue(s) with the specified APQI.
  *
  * Returns the number of bytes processed if the APQI is valid; otherwise returns
  * one of the following errors:
@@ -624,10 +637,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -644,7 +653,9 @@ static ssize_t assign_domain_store(struct device *dev,
 		mutex_unlock(&matrix_dev->lock);
 		return ret;
 	}
+
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -662,7 +673,9 @@ static DEVICE_ATTR_WO(assign_domain);
  * @count:	the number of bytes in @buf
  *
  * Parses the APQI from @buf and clears the corresponding bit in the
- * mediated matrix device's AQM.
+ * mediated matrix device's AQM. If a guest is using the mediated matrix device
+ * and has access to queue(s) with the specified domain APQI, access to
+ * the queue(s) will be taken away from the guest.
  *
  * Returns the number of bytes processed if the APQI is valid; otherwise,
  * returns one of the following errors:
@@ -678,10 +691,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -691,6 +700,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -706,7 +716,9 @@ static DEVICE_ATTR_WO(unassign_domain);
  * @count:	the number of bytes in @buf
  *
  * Parses the domain ID from @buf and sets the corresponding bit in the mediated
- * matrix device's ADM.
+ * matrix device's ADM. If a guest is using the mediated matrix device and the
+ * guest does not have access to the control domain with the specified ID, the
+ * guest will be granted access to it.
  *
  * Returns the number of bytes processed if the domain ID is valid; otherwise,
  * returns one of the following errors:
@@ -722,10 +734,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -735,6 +743,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -750,7 +759,9 @@ static DEVICE_ATTR_WO(assign_control_domain);
  * @count:	the number of bytes in @buf
  *
  * Parses the domain ID from @buf and clears the corresponding bit in the
- * mediated matrix device's ADM.
+ * mediated matrix device's ADM. If a guest is using the mediated matrix device
+ * and has access to control domain with the specified domain ID, access to
+ * the control domain will be taken from the guest.
  *
  * Returns the number of bytes processed if the domain ID is valid; otherwise,
  * returns one of the following errors:
@@ -767,10 +778,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
@@ -779,6 +786,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
-- 
2.7.4

