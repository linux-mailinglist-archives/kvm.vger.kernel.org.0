Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F324B5F70
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiBOAv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiBOAvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3818214147C;
        Mon, 14 Feb 2022 16:50:59 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F0ejAS023788;
        Tue, 15 Feb 2022 00:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PL6IMQ7QEvPRTkOTSTeKVqTTACLhw9vEvvhFR7680oo=;
 b=qIR1e9sQX4ycL0veyKqIREt7pI5KXHYYDFI64/tPBEHdNnGktO5dYseOfzz7HovWaqaB
 okAb8XsaGWY17bS/ok0EnguFtCFbksr+QC0t1JAM320RIj+Ye2p2yCIu91FCbtI+gP6v
 Td9iHN01KP3rXbscGimtINqUU/ZqBx8g2XLN6ot4kE3UKNL7/Igka5Uqt0dxxn0FGwc8
 IzDJxUHwYjSssWQ5vZOjMvyFzMnbuyoKDZ36bQSpgWlb50aF9G6qzYHrI3k212x0Su2v
 O/RSnnTwRcpQ8j6ajxDFaRyNhXCvTdwWhKyFW9jKu1Ovv0JeA+bZvA+Xg+6bX/sdkswP pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej4m7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:57 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0isfI027275;
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej4m7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:56 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0hkNW018729;
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3e64hayhgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:56 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0osh220185368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:55 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB425124058;
        Tue, 15 Feb 2022 00:50:54 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A7E6124054;
        Tue, 15 Feb 2022 00:50:54 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:54 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 13/18] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Mon, 14 Feb 2022 19:50:35 -0500
Message-Id: <20220215005040.52697-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xbLSN3VBQ7bkOJkLHIzIG_eHSBUFIcD-
X-Proofpoint-ORIG-GUID: _I3PcnUPZcCSvixtvxwN65fUaWxn4RFU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202150001
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

There is potential for a deadlock condition between the matrix_dev->lock
used to lock the matrix device during assignment of adapters and domains
and the ap_perms_mutex locked by the AP bus when changes are made to the
sysfs apmask/aqmask attributes.

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

matrix_dev->lock locked (1)
ap_perms_mutex lock locked (2a)
Waiting for matrix_dev->lock (2b) which is currently held (1)
Waiting for ap_perms_mutex lock (3) which is currently held (2a)

To prevent this deadlock scenario, the in-use callback will use
mutex_trylock to take the matrix_dev->guests_lock and if the lock can not
be obtained, will return -EBUSY from the function.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 81 ++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index e8f3540ebfda..c4f0e28b1e91 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -103,6 +103,7 @@ static const struct attribute_group vfio_queue_attr_group = {
 static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
+	.in_use = vfio_ap_mdev_resource_in_use,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e9f7ec6fc6a5..63dfb9b89581 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -617,10 +617,32 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
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
-	if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
-					       matrix_mdev->matrix.aqm))
+	int ret;
+
+	ret = ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
+						 matrix_mdev->matrix.aqm);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret == 1)
 		return -EADDRNOTAVAIL;
 
 	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
@@ -711,6 +733,10 @@ static void vfio_ap_mdev_put_locks(struct ap_matrix_mdev *matrix_mdev)
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
@@ -897,6 +923,10 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
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
@@ -1741,3 +1771,50 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	kfree(q);
 	vfio_ap_mdev_put_qlocks(matrix_mdev);
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
+	if (!mutex_trylock(&matrix_dev->guests_lock))
+		return -EBUSY;
+
+	if (!mutex_trylock(&matrix_dev->mdevs_lock)) {
+		mutex_unlock(&matrix_dev->guests_lock);
+		return -EBUSY;
+	}
+
+	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index a3811cd9852d..e30f171f89ec 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -146,4 +146,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

