Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89524E174
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHUT47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 15:56:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbgHUT4t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 15:56:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LJX7if154616;
        Fri, 21 Aug 2020 15:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=swpEaVYxiwQ1DDluF6gAxR7mvE6r5gDPnjm29zDFU7U=;
 b=sYA0symBOnCCD53ZAbzjfUmLiu9QX42c7XIqqXfjkEDbR+A9vBfUrzgued6lNL3O9JrH
 vFGp/UvzFvAQXNXvMmFGd0DziyOUOsd5R0HWMPZQdf+Px5aIFfI7V5OMY0EC8CGzMxZs
 xoWRIL2rmOFXRBOKD7usAJPvwzOMhc97FKALfXY/M/KSmnSZDk+qqDzm3+qIMR49SLe7
 ouECgSrU4y1bEZrkEKOq3GgADgD+FI+a+Oj48wGp6ubkNJoRkCywLELmincFhouqtz4B
 BP/c0G4yvaJCpH0WX5YO0JJ4zc7hNq87NWbantFrDOFGinyGszDhkDGmCiX5lWut+RmH Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3328e9n49d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:48 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LJsjwj010652;
        Fri, 21 Aug 2020 15:56:48 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3328e9n48v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:48 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LJscD8010508;
        Fri, 21 Aug 2020 19:56:47 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3304themha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 19:56:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LJufvS14745966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 19:56:41 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31A8278068;
        Fri, 21 Aug 2020 19:56:44 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B560678066;
        Fri, 21 Aug 2020 19:56:42 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.191.76])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 19:56:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v10 12/16] s390/zcrypt: Notify driver on config changed and scan complete callbacks
Date:   Fri, 21 Aug 2020 15:56:12 -0400
Message-Id: <20200821195616.13554-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200821195616.13554-1-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_09:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=3 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch intruduces an extension to the ap bus to notify drivers
on crypto config changed and bus scan complete events.
Two new callbacks are introduced for ap_drivers:

  void (*on_config_changed)(struct ap_config_info *new_config_info,
                             struct ap_config_info *old_config_info);
  void (*on_scan_complete)(struct ap_config_info *new_config_info,
                             struct ap_config_info *old_config_info);

Both callbacks are optional. Both callbacks are only triggered
when QCI information is available (facility bit 12):

* The on_config_changed callback is invoked at the start of the AP bus scan
  function when it determines that the host AP configuration information
  has changed since the previous scan. This is done by storing
  an old and current QCI info struct and comparing them. If there is any
  difference, the callback is invoked.

  Note that when the AP bus scan detects that AP adapters or domains have
  been removed from the host's AP configuration, it will remove the
  associated devices from the AP bus subsystem's device model. This
  callback gives the device driver a chance to respond to the removal
  of the AP devices in bulk rather than one at a time as its remove
  callback is invoked. It will also allow the device driver to do any
  any cleanup prior to giving control back to the bus piecemeal. This is
  particularly important for the vfio_ap driver because there may be
  guests using the queues at the time.

* The on_scan_complete callback is invoked after the ap bus scan is
  complete if the host AP configuration data has changed.

  Note that when the AP bus scan detects that adapters or domains have
  been added to the host's configuration, it will create new devices in
  the AP bus subsystem's device model. This callback also allows the driver
  to process all of the new devices in bulk.

Please note that changes to the apmask and aqmask do not trigger
these two callbacks since the bus scan function is not invoked by changes
to those masks.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c | 85 +++++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/ap_bus.h | 12 +++++
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index db27bd931308..cbf4c4d2e573 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -73,8 +73,10 @@ struct ap_perms ap_perms;
 EXPORT_SYMBOL(ap_perms);
 DEFINE_MUTEX(ap_perms_mutex);
 EXPORT_SYMBOL(ap_perms_mutex);
+DEFINE_MUTEX(ap_config_lock);
 
 static struct ap_config_info *ap_qci_info;
+static struct ap_config_info *ap_qci_info_old;
 
 /*
  * AP bus related debug feature things.
@@ -1412,6 +1414,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
 		&& AP_QID_QUEUE(to_ap_queue(dev)->qid) == (int)(long) data;
 }
 
+/* Helper function for notify_config_changed */
+static int __drv_notify_config_changed(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_config_changed)
+			ap_drv->on_config_changed(ap_qci_info,
+						  ap_qci_info_old);
+		module_put(drv->owner);
+	}
+
+	return 0;
+}
+
+/* Notify all drivers about an qci config change */
+static inline void notify_config_changed(void)
+{
+	bus_for_each_drv(&ap_bus_type, NULL, NULL,
+			 __drv_notify_config_changed);
+}
+
+/* Helper function for notify_scan_complete */
+static int __drv_notify_scan_complete(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_scan_complete)
+			ap_drv->on_scan_complete(ap_qci_info,
+						 ap_qci_info_old);
+		module_put(drv->owner);
+	}
+
+	return 0;
+}
+
+/* Notify all drivers about bus scan complete */
+static inline void notify_scan_complete(void)
+{
+	bus_for_each_drv(&ap_bus_type, NULL, NULL,
+			 __drv_notify_scan_complete);
+}
+
+
+
 /*
  * Helper function for ap_scan_bus().
  * Does the scan bus job for the given adapter id.
@@ -1565,15 +1613,44 @@ static void _ap_scan_bus_adapter(int id)
 		put_device(&ac->ap_dev.device);
 }
 
+static int ap_config_changed(void)
+{
+	int cfg_chg = 0;
+
+	if (ap_qci_info) {
+		if (!ap_qci_info_old) {
+			ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old),
+						  GFP_KERNEL);
+			if (!ap_qci_info_old)
+				return 0;
+		} else {
+			memcpy(ap_qci_info_old, ap_qci_info,
+			       sizeof(struct ap_config_info));
+		}
+		ap_fetch_qci_info(ap_qci_info);
+		cfg_chg = memcmp(ap_qci_info,
+				 ap_qci_info_old,
+				 sizeof(struct ap_config_info)) != 0;
+	}
+
+	return cfg_chg;
+}
+
 /**
  * ap_scan_bus(): Scan the AP bus for new devices
  * Runs periodically, workqueue timer (ap_config_time)
  */
 static void ap_scan_bus(struct work_struct *unused)
 {
-	int id;
+	int id, config_changed = 0;
 
 	ap_fetch_qci_info(ap_qci_info);
+	mutex_lock(&ap_config_lock);
+
+	/* config change notify */
+	config_changed = ap_config_changed();
+	if (config_changed)
+		notify_config_changed();
 	ap_select_domain();
 
 	AP_DBF(DBF_DEBUG, "%s running\n", __func__);
@@ -1582,6 +1659,12 @@ static void ap_scan_bus(struct work_struct *unused)
 	for (id = 0; id < AP_DEVICES; id++)
 		_ap_scan_bus_adapter(id);
 
+	/* scan complete notify */
+	if (config_changed)
+		notify_scan_complete();
+
+	mutex_unlock(&ap_config_lock);
+
 	/* check if there is at least one queue available with default domain */
 	if (ap_domain_index >= 0) {
 		struct device *dev =
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 48c57b3d53a0..3fc743ac549c 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -137,6 +137,18 @@ struct ap_driver {
 	int (*probe)(struct ap_device *);
 	void (*remove)(struct ap_device *);
 	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
+	/*
+	 * Called at the start of the ap bus scan function when
+	 * the crypto config information (qci) has changed.
+	 */
+	void (*on_config_changed)(struct ap_config_info *new_config_info,
+				  struct ap_config_info *old_config_info);
+	/*
+	 * Called at the end of the ap bus scan function when
+	 * the crypto config information (qci) has changed.
+	 */
+	void (*on_scan_complete)(struct ap_config_info *new_config_info,
+				 struct ap_config_info *old_config_info);
 };
 
 #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
-- 
2.21.1

