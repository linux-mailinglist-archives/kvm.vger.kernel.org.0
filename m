Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE23244C65
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbfFMTki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:40:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729444AbfFMTkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 15:40:24 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DJbSso071043;
        Thu, 13 Jun 2019 15:40:04 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3s629k6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 15:40:04 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5DJEReH014448;
        Thu, 13 Jun 2019 19:16:55 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2t1x6t0c7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 19:16:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DJdweu28770604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 19:39:58 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36CCF6E04E;
        Thu, 13 Jun 2019 19:39:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B196E050;
        Thu, 13 Jun 2019 19:39:56 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.158.129])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 19:39:56 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 3/7] s390: zcrypt: driver callback to indicate resource in use
Date:   Thu, 13 Jun 2019 15:39:36 -0400
Message-Id: <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
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

Introduces a new driver callback to prevent a root user from unbinding
an AP queue from its device driver if the queue is in use. This prevents
a root user from inadvertently taking a queue away from a guest and
giving it to the host, or vice versa. The callback will be invoked
whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
result in one or more AP queues being removed from its driver. If the
callback responds in the affirmative for any driver queried, the change
to the apmask or aqmask will be rejected with a device in use error.

For this patch, only non-default drivers will be queried. Currently,
there is only one non-default driver, the vfio_ap device driver. The
vfio_ap device driver manages AP queues passed through to one or more
guests and we don't want to unexpectedly take AP resources away from
guests which are most likely independently administered.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c | 138 +++++++++++++++++++++++++++++++++++++++++--
 drivers/s390/crypto/ap_bus.h |   3 +
 2 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index b9fc502c58c2..1b06f47d0d1c 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -35,6 +35,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
+#include <linux/module.h>
 
 #include "ap_bus.h"
 #include "ap_debug.h"
@@ -998,9 +999,11 @@ int ap_parse_mask_str(const char *str,
 	newmap = kmalloc(size, GFP_KERNEL);
 	if (!newmap)
 		return -ENOMEM;
-	if (mutex_lock_interruptible(lock)) {
-		kfree(newmap);
-		return -ERESTARTSYS;
+	if (lock) {
+		if (mutex_lock_interruptible(lock)) {
+			kfree(newmap);
+			return -ERESTARTSYS;
+		}
 	}
 
 	if (*str == '+' || *str == '-') {
@@ -1012,7 +1015,10 @@ int ap_parse_mask_str(const char *str,
 	}
 	if (rc == 0)
 		memcpy(bitmap, newmap, size);
-	mutex_unlock(lock);
+
+	if (lock)
+		mutex_unlock(lock);
+
 	kfree(newmap);
 	return rc;
 }
@@ -1199,12 +1205,72 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
 	return rc;
 }
 
+int __verify_card_reservations(struct device_driver *drv, void *data)
+{
+	int rc = 0;
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+	unsigned long *newapm = (unsigned long *)data;
+
+	/*
+	 * If the reserved bits do not identify cards reserved for use by the
+	 * non-default driver, there is no need to verify the driver is using
+	 * the queues.
+	 */
+	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
+		return 0;
+
+	/* The non-default driver's module must be loaded */
+	if (!try_module_get(drv->owner))
+		return 0;
+
+	if (ap_drv->in_use)
+		if (ap_drv->in_use(newapm, ap_perms.aqm))
+			rc = -EADDRINUSE;
+
+	module_put(drv->owner);
+
+	return rc;
+}
+
+static int apmask_commit(unsigned long *newapm)
+{
+	int rc;
+	unsigned long reserved[BITS_TO_LONGS(AP_DEVICES)];
+
+	/*
+	 * Check if any bits in the apmask have been set which will
+	 * result in queues being removed from non-default drivers
+	 */
+	if (bitmap_andnot(reserved, newapm, ap_perms.apm, AP_DEVICES)) {
+		rc = (bus_for_each_drv(&ap_bus_type, NULL, reserved,
+				       __verify_card_reservations));
+		if (rc)
+			return rc;
+	}
+
+	memcpy(ap_perms.apm, newapm, APMASKSIZE);
+
+	return 0;
+}
+
 static ssize_t apmask_store(struct bus_type *bus, const char *buf,
 			    size_t count)
 {
 	int rc;
+	unsigned long newapm[BITS_TO_LONGS(AP_DEVICES)];
+
+	memcpy(newapm, ap_perms.apm, APMASKSIZE);
+
+	rc = ap_parse_mask_str(buf, newapm, AP_DEVICES, NULL);
+	if (rc)
+		return rc;
+
+	if (mutex_lock_interruptible(&ap_perms_mutex))
+		return -ERESTARTSYS;
+
+	rc = apmask_commit(newapm);
+	mutex_unlock(&ap_perms_mutex);
 
-	rc = ap_parse_mask_str(buf, ap_perms.apm, AP_DEVICES, &ap_perms_mutex);
 	if (rc)
 		return rc;
 
@@ -1230,12 +1296,72 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
 	return rc;
 }
 
+int __verify_queue_reservations(struct device_driver *drv, void *data)
+{
+	int rc = 0;
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+	unsigned long *newaqm = (unsigned long *)data;
+
+	/*
+	 * If the reserved bits do not identify queues reserved for use by the
+	 * non-default driver, there is no need to verify the driver is using
+	 * the queues.
+	 */
+	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
+		return 0;
+
+	/* The non-default driver's module must be loaded */
+	if (!try_module_get(drv->owner))
+		return 0;
+
+	if (ap_drv->in_use)
+		if (ap_drv->in_use(ap_perms.apm, newaqm))
+			rc = -EADDRINUSE;
+
+	module_put(drv->owner);
+
+	return rc;
+}
+
+static int aqmask_commit(unsigned long *newaqm)
+{
+	int rc;
+	unsigned long reserved[BITS_TO_LONGS(AP_DOMAINS)];
+
+	/*
+	 * Check if any bits in the aqmask have been set which will
+	 * result in queues being removed from non-default drivers
+	 */
+	if (bitmap_andnot(reserved, newaqm, ap_perms.aqm, AP_DOMAINS)) {
+		rc = (bus_for_each_drv(&ap_bus_type, NULL, reserved,
+				       __verify_queue_reservations));
+		if (rc)
+			return rc;
+	}
+
+	memcpy(ap_perms.aqm, newaqm, APMASKSIZE);
+
+	return 0;
+}
+
 static ssize_t aqmask_store(struct bus_type *bus, const char *buf,
 			    size_t count)
 {
 	int rc;
+	unsigned long newaqm[BITS_TO_LONGS(AP_DEVICES)];
+
+	memcpy(newaqm, ap_perms.aqm, AQMASKSIZE);
+
+	rc = ap_parse_mask_str(buf, newaqm, AP_DOMAINS, NULL);
+	if (rc)
+		return rc;
+
+	if (mutex_lock_interruptible(&ap_perms_mutex))
+		return -ERESTARTSYS;
+
+	rc = aqmask_commit(newaqm);
+	mutex_unlock(&ap_perms_mutex);
 
-	rc = ap_parse_mask_str(buf, ap_perms.aqm, AP_DOMAINS, &ap_perms_mutex);
 	if (rc)
 		return rc;
 
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 6f3cf37776ca..0f865c5545f2 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -137,6 +137,7 @@ struct ap_driver {
 	void (*remove)(struct ap_device *);
 	void (*suspend)(struct ap_device *);
 	void (*resume)(struct ap_device *);
+	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
 };
 
 #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
@@ -265,6 +266,8 @@ void ap_queue_reinit_state(struct ap_queue *aq);
 struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
 			       int comp_device_type, unsigned int functions);
 
+#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
+#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
 struct ap_perms {
 	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
 	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
-- 
2.7.4

