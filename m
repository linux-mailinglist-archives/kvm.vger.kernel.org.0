Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDBD5536C9
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352583AbiFUPwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352448AbiFUPwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:52:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7DF2CE10;
        Tue, 21 Jun 2022 08:51:59 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LF4Vid017768;
        Tue, 21 Jun 2022 15:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=his8u4BK2OwOmVrZJeoc522EumidVbda4fynKo5RN0k=;
 b=SECyRDcPqcDIVp0IR1xJF+4kBAzt/bpRowMP5JawpXjaVtmLXN+JE0LgjGYco7g9UnHb
 /cKv9J9AUMBkq/AmrDTqBMn3Eioo/JDgvZUoORXZdhzFDXxu1gLSxFEIuph4lpOdB3/z
 PC9nxTKaFnsKOGI77CQ9ISX7XWvpUz2SVtJ0doBnzrTe5gSiys+Kt+CZBN4MR16krWbt
 a8E6hLJ9uBbyDI2Agc8MhghtTm1LBFvXUH9j2q+6LbcZcXOeRty57MxH1pVC5xfAbOPN
 s7eeDGxbmEgTxSmRotsD876FH8SmQQPLqnSd7SOSo99x0jVJY10JTVmO4fWYxFjlhFbM mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaesetd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LF5Q7t021298;
        Tue, 21 Jun 2022 15:51:55 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaeset2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:55 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZvoV031799;
        Tue, 21 Jun 2022 15:51:54 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 3gt0091y8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:54 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpr0Z29229566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:53 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61D2B136053;
        Tue, 21 Jun 2022 15:51:53 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 553A913604F;
        Tue, 21 Jun 2022 15:51:52 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:52 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 15/20] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Tue, 21 Jun 2022 11:51:29 -0400
Message-Id: <20220621155134.1932383-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ysc6AOZ3vnpy_m2VszxD_HN5pTbNg8w9
X-Proofpoint-GUID: r0qCuiHQFxR9sNKu7iYvGpnBg1deQ1-2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the callback to indicate when an APQN
is in use by the vfio_ap device driver. The callback is
invoked whenever a change to the apmask or aqmask would
result in one or more queue devices being removed from the driver. The
vfio_ap device driver will indicate a resource is in use
if the APQN of any of the queue devices to be removed are assigned to
any of the matrix mdevs under the driver's control.

There is potential for a deadlock condition between the
matrix_dev->guests_lock used to lock the guest during assignment of
adapters and domains and the ap_perms_mutex locked by the AP bus when
changes are made to the sysfs apmask/aqmask attributes.

The AP Perms lock controls access to the objects that store the adapter
numbers (ap_perms) and domain numbers (aq_perms) for the sysfs
/sys/bus/ap/apmask and /sys/bus/ap/aqmask attributes. These attributes
identify which queues are reserved for the zcrypt default device drivers.
Before allowing a bit to be removed from either mask, the AP bus must check
with the vfio_ap device driver to verify that none of the queues are
assigned to any of its mediated devices.

The apmask/aqmask attributes can be written or read at any time from
userspace, so care must be taken to prevent a deadlock with asynchronous
operations that might be taking place in the vfio_ap device driver. For
example, consider the following:

1. A system administrator assigns an adapter to a mediated device under the
   control of the vfio_ap device driver. The driver will need to first take
   the matrix_dev->guests_lock to potentially hot plug the adapter into
   the KVM guest.
2. At the same time, a system administrator sets a bit in the sysfs
   /sys/bus/ap/ap_mask attribute. To complete the operation, the AP bus
   must:
   a. Take the ap_perms_mutex lock to update the object storing the values
      for the /sys/bus/ap/ap_mask attribute.
   b. Call the vfio_ap device driver's in-use callback to verify that the
      queues now being reserved for the default zcrypt drivers are not
      assigned to a mediated device owned by the vfio_ap device driver. To
      do the verification, the in-use callback function takes the
      matrix_dev->guests_lock, but has to wait because it is already held
      by the operation in 1 above.
3. The vfio_ap device driver calls an AP bus function to verify that the
   new queues resulting from the assignment of the adapter in step 1 are
   not reserved for the default zcrypt device driver. This AP bus function
   tries to take the ap_perms_mutex lock but gets stuck waiting for the
   waiting for the lock due to step 2a above.

Consequently, we have the following deadlock situation:

matrix_dev->guests_lock locked (1)
ap_perms_mutex lock locked (2a)
Waiting for matrix_dev->gusts_lock (2b) which is currently held (1)
Waiting for ap_perms_mutex lock (3) which is currently held (2a)

To prevent this deadlock scenario, the function called in step 3 will no
longer take the ap_perms_mutex lock and require the caller to take the
lock. The lock will be the first taken by the adapter/domain assignment
functions in the vfio_ap device driver to maintain the proper locking
order.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c          | 35 ++++++++++++-----
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 54 +++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 4 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 5c13d2079d96..63a484e0cb87 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -835,6 +835,17 @@ static void ap_bus_revise_bindings(void)
 	bus_for_each_dev(&ap_bus_type, NULL, NULL, __ap_revise_reserved);
 }
 
+/**
+ * ap_owned_by_def_drv: indicates whether an AP adapter is reserved for the
+ *			default host driver or not.
+ * @card: the APID of the adapter card to check
+ * @queue: the APQI of the queue to check
+ *
+ * Note: the ap_perms_mutex must be locked by the caller of this function.
+ *
+ * Return: an int specifying whether the AP adapter is reserved for the host (1)
+ *	   or not (0).
+ */
 int ap_owned_by_def_drv(int card, int queue)
 {
 	int rc = 0;
@@ -842,25 +853,31 @@ int ap_owned_by_def_drv(int card, int queue)
 	if (card < 0 || card >= AP_DEVICES || queue < 0 || queue >= AP_DOMAINS)
 		return -EINVAL;
 
-	mutex_lock(&ap_perms_mutex);
-
-	if (test_bit_inv(card, ap_perms.apm) &&
-	    test_bit_inv(queue, ap_perms.aqm))
+	if (test_bit_inv(card, ap_perms.apm)
+	    && test_bit_inv(queue, ap_perms.aqm))
 		rc = 1;
 
-	mutex_unlock(&ap_perms_mutex);
-
 	return rc;
 }
 EXPORT_SYMBOL(ap_owned_by_def_drv);
 
+/**
+ * ap_apqn_in_matrix_owned_by_def_drv: indicates whether every APQN contained in
+ *				       a set is reserved for the host drivers
+ *				       or not.
+ * @apm: a bitmap specifying a set of APIDs comprising the APQNs to check
+ * @aqm: a bitmap specifying a set of APQIs comprising the APQNs to check
+ *
+ * Note: the ap_perms_mutex must be locked by the caller of this function.
+ *
+ * Return: an int specifying whether each APQN is reserved for the host (1) or
+ *	   not (0)
+ */
 int ap_apqn_in_matrix_owned_by_def_drv(unsigned long *apm,
 				       unsigned long *aqm)
 {
 	int card, queue, rc = 0;
 
-	mutex_lock(&ap_perms_mutex);
-
 	for (card = 0; !rc && card < AP_DEVICES; card++)
 		if (test_bit_inv(card, apm) &&
 		    test_bit_inv(card, ap_perms.apm))
@@ -869,8 +886,6 @@ int ap_apqn_in_matrix_owned_by_def_drv(unsigned long *apm,
 				    test_bit_inv(queue, ap_perms.aqm))
 					rc = 1;
 
-	mutex_unlock(&ap_perms_mutex);
-
 	return rc;
 }
 EXPORT_SYMBOL(ap_apqn_in_matrix_owned_by_def_drv);
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index db8ca7bb3696..2572fb0f0f54 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -46,6 +46,7 @@ static struct ap_device_id ap_queue_ids[] = {
 static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
+	.in_use = vfio_ap_mdev_resource_in_use,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 479e83e54cce..d6f60072c63f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -901,6 +901,21 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
 	return 0;
 }
 
+/**
+ * vfio_ap_mdev_validate_masks - verify that the APQNs assigned to the mdev are
+ *				 not reserved for the default zcrypt driver and
+ *				 are not assigned to another mdev.
+ *
+ * @matrix_mdev: the mdev to which the APQNs being validated are assigned.
+ *
+ * Return: One of the following values:
+ * o the error returned from the ap_apqn_in_matrix_owned_by_def_drv() function,
+ *   most likely -EBUSY indicating the ap_perms_mutex lock is already held.
+ * o EADDRNOTAVAIL if an APQN assigned to @matrix_mdev is reserved for the
+ *		   zcrypt default driver.
+ * o EADDRINUSE if an APQN assigned to @matrix_mdev is assigned to another mdev
+ * o A zero indicating validation succeeded.
+ */
 static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
 {
 	if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
@@ -950,6 +965,10 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
  *	   An APQN derived from the cross product of the APID being assigned
  *	   and the APQIs previously assigned is being used by another mediated
  *	   matrix device
+ *
+ *	5. -EAGAIN
+ *	   A lock required to validate the mdev's AP configuration could not
+ *	   be obtained.
  */
 static ssize_t assign_adapter_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -960,6 +979,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	DECLARE_BITMAP(apm_delta, AP_DEVICES);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
+	mutex_lock(&ap_perms_mutex);
 	get_update_locks_for_mdev(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apid);
@@ -990,6 +1010,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
+	mutex_unlock(&ap_perms_mutex);
 
 	return ret;
 }
@@ -1143,6 +1164,10 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
  *	   An APQN derived from the cross product of the APQI being assigned
  *	   and the APIDs previously assigned is being used by another mediated
  *	   matrix device
+ *
+ *	5. -EAGAIN
+ *	   The lock required to validate the mdev's AP configuration could not
+ *	   be obtained.
  */
 static ssize_t assign_domain_store(struct device *dev,
 				   struct device_attribute *attr,
@@ -1153,6 +1178,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	DECLARE_BITMAP(aqm_delta, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
+	mutex_lock(&ap_perms_mutex);
 	get_update_locks_for_mdev(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apqi);
@@ -1183,6 +1209,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
+	mutex_unlock(&ap_perms_mutex);
 
 	return ret;
 }
@@ -1899,3 +1926,30 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);
 }
+
+/**
+ * vfio_ap_mdev_resource_in_use: check whether any of a set of APQNs is
+ *				 assigned to a mediated device under the control
+ *				 of the vfio_ap device driver.
+ *
+ * @apm: a bitmap specifying a set of APIDs comprising the APQNs to check.
+ * @aqm: a bitmap specifying a set of APQIs comprising the APQNs to check.
+ *
+ * Return:
+ *	* -EADDRINUSE if one or more of the APQNs specified via @apm/@aqm are
+ *	  assigned to a mediated device under the control of the vfio_ap
+ *	  device driver.
+ *	* Otherwise, return 0.
+ */
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	int ret;
+
+	mutex_lock(&matrix_dev->guests_lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
+	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 7110288fab68..e19a3e38fb32 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -144,4 +144,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.35.3

