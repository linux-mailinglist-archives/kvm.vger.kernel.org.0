Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEFA4F1F92
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiDDWyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA74BB95;
        Mon,  4 Apr 2022 15:12:07 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234JGU3o017760;
        Mon, 4 Apr 2022 22:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=raVG2r7T0cMdjIWZGL8h/0Ne9ekBNeGe5DW14mRv8Ug=;
 b=PiOxxFuGZ95RD6L0LId3ycZyooh6BjdMytq0n/yliunNecxOylZdtUul3Vl98QE50k8u
 mphqWXyQ4cxK2z7S4B7AldxluJYLo0lBG9ObY3LXsiycIMMH5MYbxU1wydaL/xOKnJNc
 Edo0tb0YHWPwwnW2tvHkKgURfWQGH0kF7Stmqk+dTw1+2rWSg6DwAfM0tAeF8DyUwOn1
 f4sVAm63BVU/V23zdqKb5t4WskK6xIEmu06Cx52Rgovd6kMbUbCjI6+seEHQ0XLTUz+b
 hKoiX7f4k6yNhqYdhTNLJmg9pJkWyzUwQccC42MAEYTfbvYCOYH3e9kccMbalTFfzi3U Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjm3sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:05 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234M0HqF023800;
        Mon, 4 Apr 2022 22:12:05 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjm3s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:04 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr5eW014676;
        Mon, 4 Apr 2022 22:12:04 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3f6e49q9db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:04 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MC21b27722080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:12:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9642B78063;
        Mon,  4 Apr 2022 22:12:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86E537805C;
        Mon,  4 Apr 2022 22:12:01 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:12:01 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 15/20] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Mon,  4 Apr 2022 18:10:34 -0400
Message-Id: <20220404221039.1272245-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y1BvGB1XQ2YDquUJxWHxI4zehTvTWUjv
X-Proofpoint-ORIG-GUID: 83XMRtxjcRNAglbgBGd05YrlTjjnCPv2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/s390/crypto/ap_bus.c          | 31 ++++++++----
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 68 +++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 4 files changed, 94 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index fdf16cb70881..f48552e900a2 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -817,6 +817,17 @@ static void ap_bus_revise_bindings(void)
 	bus_for_each_dev(&ap_bus_type, NULL, NULL, __ap_revise_reserved);
 }
 
+/**
+ * ap_apqn_in_matrix_owned_by_def_drv: indicates whether an APQN c is reserved
+ *				       for the host drivers or not.
+ * @card: the APID of the adapter card to check
+ * @queue: the APQI of the queue to check
+ *
+ * Note: the ap_perms_mutex must be locked by the caller of this function.
+ *
+ * Return: an int specifying whether the APQN is reserved for the host (1) or
+ *	   not (0)
+ */
 int ap_owned_by_def_drv(int card, int queue)
 {
 	int rc = 0;
@@ -824,25 +835,31 @@ int ap_owned_by_def_drv(int card, int queue)
 	if (card < 0 || card >= AP_DEVICES || queue < 0 || queue >= AP_DOMAINS)
 		return -EINVAL;
 
-	mutex_lock(&ap_perms_mutex);
-
 	if (test_bit_inv(card, ap_perms.apm)
 	    && test_bit_inv(queue, ap_perms.aqm))
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
@@ -851,8 +868,6 @@ int ap_apqn_in_matrix_owned_by_def_drv(unsigned long *apm,
 				    test_bit_inv(queue, ap_perms.aqm))
 					rc = 1;
 
-	mutex_unlock(&ap_perms_mutex);
-
 	return rc;
 }
 EXPORT_SYMBOL(ap_apqn_in_matrix_owned_by_def_drv);
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index c258e5f7fdfc..2c3084589347 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -107,6 +107,7 @@ static const struct attribute_group vfio_queue_attr_group = {
 static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
+	.in_use = vfio_ap_mdev_resource_in_use,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 49ed54dc9e05..3ece2cd9f1e7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -902,6 +902,21 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
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
@@ -951,6 +966,10 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
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
@@ -961,6 +980,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	DECLARE_BITMAP(apm_delta, AP_DEVICES);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
+	mutex_lock(&ap_perms_mutex);
 	get_update_locks_for_mdev(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apid);
@@ -991,6 +1011,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
+	mutex_unlock(&ap_perms_mutex);
 
 	return ret;
 }
@@ -1144,6 +1165,10 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
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
@@ -1154,6 +1179,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	DECLARE_BITMAP(aqm_delta, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
+	mutex_lock(&ap_perms_mutex);
 	get_update_locks_for_mdev(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apqi);
@@ -1184,6 +1210,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
+	mutex_unlock(&ap_perms_mutex);
 
 	return ret;
 }
@@ -1868,3 +1895,44 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
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
+ * This function is invoked by the AP bus when changes to the apmask/aqmask
+ * attributes will result in giving control of the queue devices specified via
+ * @apm and @aqm to the default zcrypt device driver. Prior to calling this
+ * function, the AP bus locks the ap_perms_mutex. If this function is called
+ * while an adapter or domain is being assigned to a mediated device, the
+ * assignment operations will take the matrix_dev->guests_lock and
+ * matrix_dev->mdevs_lock then call the ap_apqn_in_matrix_owned_by_def_drv
+ * function, which also locks the ap_perms_mutex. This could result in a
+ * deadlock.
+ *
+ * To avoid a deadlock, this function will verify that the
+ * matrix_dev->guests_lock and matrix_dev->mdevs_lock are not currently held and
+ * will return -EBUSY if the locks can not be obtained.
+ *
+ * Return:
+ *	* -EBUSY if the locks required by this function are already locked.
+ *	* -EADDRINUSE if one or more of the APQNs specified via @apm/@aqm are
+ *	  assigned to a mediated device under the control of the vfio_ap
+ *	  device driver.
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
index 6d4ca39f783b..cbffa0bd01da 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -147,4 +147,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

