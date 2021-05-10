Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1E379475
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhEJQqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:46:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232091AbhEJQpz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:55 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGXiIi192398;
        Mon, 10 May 2021 12:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=340KIGt2R1DmbQMVVNaA17sNQes/7TDk0BTtBZkxRBI=;
 b=Yj77eMzrSlfcmjhYlxO+v07+4c4JduQDZrkMwtuWEzzv6lALmSxrk9P16cF2HgWkVvBm
 2ItS36wwSFB5a8gymfqRsHQSAsWUP0v19z8St6ETzaphMHa0G7V+TGkf8zDBvHCYiUzM
 c0d8jcmDUofrggkWLCVIHbWi7yt1X6JxmdKO2Jhg+TNanNzqG7icR8EdPANFGqRHKHRX
 fltZWvj1V6nsAFXTT/gXitcCVItoq4v2aQLXZzElgopWYSdtwUkD5SjwUcfZPaN2oojF
 W8q/l4SbtqvCutxe47c3BNH0f23BhHTHGAftBMyFsf8y8OrUAM1OqQ4UKXeyT0T8cJ+7 Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f7r2hky6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGZC67008697;
        Mon, 10 May 2021 12:44:47 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f7r2hkxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:47 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGgpnN003007;
        Mon, 10 May 2021 16:44:46 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 38dj99bj79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGii2928508510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:44 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B67C5AE05F;
        Mon, 10 May 2021 16:44:44 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1BACAE063;
        Mon, 10 May 2021 16:44:43 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 11/14] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Mon, 10 May 2021 12:44:20 -0400
Message-Id: <20210510164423.346858-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VAcK4kbJG3mYDcEsrkzXZOq9pMzJpjyU
X-Proofpoint-ORIG-GUID: SIXWOEwF5AxQ4EZ0WLrvZJEVtO3eHwAa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
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

Consider following scenario (courtesy of Halil Pasic):
1) apmask_store() takes ap_perms_mutex
2) assign_adapter_store() takes matrix_dev->lock
3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
   to take matrix_dev->lock
4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
   which tries to take ap_perms_mutex

BANG!

To resolve this issue, instead of using the mutex_lock(&matrix_dev->lock)
function to lock the matrix device during assignment of an adapter or
domain to a matrix_mdev as well as during the in_use callback, the
mutex_trylock(&matrix_dev->lock) function will be used. If the lock is not
obtained, then the assignment and in_use functions will terminate with
-EAGAIN.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 38 ++++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 73bd073fd5d3..8934471b7944 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -147,6 +147,7 @@ static int __init vfio_ap_init(void)
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
 	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
 	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
+	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 48e3db2f1c28..3d6c6c2b3b4f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -684,10 +684,14 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APQIs have yet been assigned, the APID is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -EBUSY
+ *	4. -EADDRINUSE
  *	   An APQN derived from the cross product of the APID being assigned
  *	   and the APQIs previously assigned is being used by another mediated
- *	   matrix device or the mdev lock could not be acquired.
+ *	   matrix device.
+ *
+ *	5. -EAGAIN
+ *	   The mdev lock could not be acquired which is required in order to
+ *	   change the AP configuration for the mdev
  */
 static ssize_t assign_adapter_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -698,7 +702,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -921,10 +926,14 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APIDs have yet been assigned, the APQI is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -BUSY
+ *	4. -EADDRINUSE
  *	   An APQN derived from the cross product of the APQI being assigned
  *	   and the APIDs previously assigned is being used by another mediated
- *	   matrix device or the mdev lock could not be acquired.
+ *	   matrix device.
+ *
+ *	5. -EAGAIN
+ *	   The mdev lock could not be acquired which is required in order to
+ *	   change the AP configuration for the mdev
  */
 static ssize_t assign_domain_store(struct device *dev,
 				   struct device_attribute *attr,
@@ -936,7 +945,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -1113,6 +1123,7 @@ static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
  * returns one of the following errors:
  *	-EINVAL if the ID is not a number
  *	-ENODEV if the ID exceeds the maximum value configured for the system
+ *	-EAGAIN if the mdev lock could not be acquired
  */
 static ssize_t assign_control_domain_store(struct device *dev,
 					   struct device_attribute *attr,
@@ -1123,7 +1134,8 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -1740,3 +1752,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
+
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	int ret;
+
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
+	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 1b95486fccf0..43c422896f31 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -110,4 +110,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.30.2

