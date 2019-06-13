Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6FF44C54
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbfFMTkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:40:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729224AbfFMTkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 15:40:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DJbSsu071043
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 15:40:14 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3s629kef-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 15:40:13 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Thu, 13 Jun 2019 20:40:13 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 20:40:10 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DJe6jE24052060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 19:40:06 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7841A6E056;
        Thu, 13 Jun 2019 19:40:06 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D16D16E058;
        Thu, 13 Jun 2019 19:40:03 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.158.129])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 19:40:03 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 6/7] s390: vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Thu, 13 Jun 2019 15:39:39 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061319-0012-0000-0000-00001744096D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011256; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01217510; UDB=6.00640241; IPR=6.00998621;
 MB=3.00027298; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-13 19:40:13
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061319-0013-0000-0000-000057AF4A11
Message-Id: <1560454780-20359-7-git-send-email-akrowiak@linux.ibm.com>
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
index 9db86c0db52e..57325eb47278 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -465,6 +465,16 @@ static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
 	return vfio_ap_mdev_verify_no_sharing(apm, aqm);
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
@@ -475,7 +485,10 @@ static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
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
@@ -507,10 +520,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -527,7 +536,9 @@ static ssize_t assign_adapter_store(struct device *dev,
 		mutex_unlock(&matrix_dev->lock);
 		return ret;
 	}
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -543,7 +554,9 @@ static DEVICE_ATTR_WO(assign_adapter);
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
@@ -560,10 +573,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -573,6 +582,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -589,7 +599,10 @@ static DEVICE_ATTR_WO(unassign_adapter);
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
@@ -622,10 +635,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -641,7 +650,9 @@ static ssize_t assign_domain_store(struct device *dev,
 		mutex_unlock(&matrix_dev->lock);
 		return ret;
 	}
+
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -659,7 +670,9 @@ static DEVICE_ATTR_WO(assign_domain);
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
@@ -675,10 +688,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -688,6 +697,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -703,7 +713,9 @@ static DEVICE_ATTR_WO(unassign_domain);
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
@@ -719,10 +731,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -732,6 +740,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -747,7 +756,9 @@ static DEVICE_ATTR_WO(assign_control_domain);
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
@@ -764,10 +775,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
@@ -776,6 +783,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
-- 
2.7.4

