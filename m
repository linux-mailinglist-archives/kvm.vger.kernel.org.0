Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7AE1F0219
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgFEVko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:40:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728893AbgFEVkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LVwvh101855;
        Fri, 5 Jun 2020 17:40:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31f9dfm16n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:18 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LbxoM131856;
        Fri, 5 Jun 2020 17:40:18 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31f9dfm16c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:18 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LZBff027082;
        Fri, 5 Jun 2020 21:40:17 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 31bf495gwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:17 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeG6I32375106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:16 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A9A4AC05B;
        Fri,  5 Jun 2020 21:40:16 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98A0CAC05E;
        Fri,  5 Jun 2020 21:40:15 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:15 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 13/16] s390/zcrypt: Notify driver on config changed and scan complete callbacks
Date:   Fri,  5 Jun 2020 17:40:01 -0400
Message-Id: <20200605214004.14270-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=3 cotscore=-2147483648 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

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
 drivers/s390/crypto/ap_bus.c | 175 ++++++++++++++++++++++++++---------
 drivers/s390/crypto/ap_bus.h |  12 +++
 2 files changed, 142 insertions(+), 45 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 40cb5861dad3..0b4a67051138 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -73,8 +73,12 @@ struct ap_perms ap_perms;
 EXPORT_SYMBOL(ap_perms);
 DEFINE_MUTEX(ap_perms_mutex);
 EXPORT_SYMBOL(ap_perms_mutex);
+DEFINE_MUTEX(ap_config_lock);
+
+/* current and old qci info structs */
+static struct ap_config_info *ap_config_info;
+static struct ap_config_info *ap_old_config_info;
 
-static struct ap_config_info *ap_configuration;
 static bool initialised;
 
 /*
@@ -183,8 +187,8 @@ static int ap_apft_available(void)
  */
 static inline int ap_qact_available(void)
 {
-	if (ap_configuration)
-		return ap_configuration->qact;
+	if (ap_config_info)
+		return ap_config_info->qact;
 	return 0;
 }
 
@@ -213,13 +217,15 @@ static void ap_init_configuration(void)
 	if (!ap_configuration_available())
 		return;
 
-	ap_configuration = kzalloc(sizeof(*ap_configuration), GFP_KERNEL);
-	if (!ap_configuration)
-		return;
-	if (ap_query_configuration(ap_configuration) != 0) {
-		kfree(ap_configuration);
-		ap_configuration = NULL;
+	/* allocate current qci info struct */
+	ap_config_info = kzalloc(sizeof(*ap_config_info), GFP_KERNEL);
+	if (!ap_config_info)
 		return;
+
+	/* fetch qci info into the current qci info struct */
+	if (ap_query_configuration(ap_config_info)) {
+		kfree(ap_config_info);
+		ap_config_info = NULL;
 	}
 }
 
@@ -242,10 +248,10 @@ static inline int ap_test_config(unsigned int *field, unsigned int nr)
  */
 static inline int ap_test_config_card_id(unsigned int id)
 {
-	if (!ap_configuration)	/* QCI not supported */
-		/* only ids 0...3F may be probed */
+	if (!ap_config_info)
+		/* QCI not available, only ids 0...3F may be probed */
 		return id < 0x40 ? 1 : 0;
-	return ap_test_config(ap_configuration->apm, id);
+	return ap_test_config(ap_config_info->apm, id);
 }
 
 /*
@@ -259,9 +265,9 @@ static inline int ap_test_config_card_id(unsigned int id)
  */
 int ap_test_config_usage_domain(unsigned int domain)
 {
-	if (!ap_configuration)	/* QCI not supported */
+	if (!ap_config_info)  /* QCI not supported */
 		return domain < 16;
-	return ap_test_config(ap_configuration->aqm, domain);
+	return ap_test_config(ap_config_info->aqm, domain);
 }
 EXPORT_SYMBOL(ap_test_config_usage_domain);
 
@@ -275,9 +281,9 @@ EXPORT_SYMBOL(ap_test_config_usage_domain);
  */
 int ap_test_config_ctrl_domain(unsigned int domain)
 {
-	if (!ap_configuration)	/* QCI not supported */
+	if (!ap_config_info)  /* QCI not supported */
 		return 0;
-	return ap_test_config(ap_configuration->adm, domain);
+	return ap_test_config(ap_config_info->adm, domain);
 }
 EXPORT_SYMBOL(ap_test_config_ctrl_domain);
 
@@ -953,45 +959,45 @@ static BUS_ATTR_RW(ap_domain);
 
 static ssize_t ap_control_domain_mask_show(struct bus_type *bus, char *buf)
 {
-	if (!ap_configuration)	/* QCI not supported */
-		return scnprintf(buf, PAGE_SIZE, "not supported\n");
+	if (!ap_config_info)  /* QCI not supported */
+		return snprintf(buf, PAGE_SIZE, "not supported\n");
 
-	return scnprintf(buf, PAGE_SIZE,
-			 "0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
-			 ap_configuration->adm[0], ap_configuration->adm[1],
-			 ap_configuration->adm[2], ap_configuration->adm[3],
-			 ap_configuration->adm[4], ap_configuration->adm[5],
-			 ap_configuration->adm[6], ap_configuration->adm[7]);
+	return snprintf(buf, PAGE_SIZE,
+			"0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
+			ap_config_info->adm[0], ap_config_info->adm[1],
+			ap_config_info->adm[2], ap_config_info->adm[3],
+			ap_config_info->adm[4], ap_config_info->adm[5],
+			ap_config_info->adm[6], ap_config_info->adm[7]);
 }
 
 static BUS_ATTR_RO(ap_control_domain_mask);
 
 static ssize_t ap_usage_domain_mask_show(struct bus_type *bus, char *buf)
 {
-	if (!ap_configuration)	/* QCI not supported */
-		return scnprintf(buf, PAGE_SIZE, "not supported\n");
+	if (!ap_config_info)  /* QCI not supported */
+		return snprintf(buf, PAGE_SIZE, "not supported\n");
 
-	return scnprintf(buf, PAGE_SIZE,
-			 "0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
-			 ap_configuration->aqm[0], ap_configuration->aqm[1],
-			 ap_configuration->aqm[2], ap_configuration->aqm[3],
-			 ap_configuration->aqm[4], ap_configuration->aqm[5],
-			 ap_configuration->aqm[6], ap_configuration->aqm[7]);
+	return snprintf(buf, PAGE_SIZE,
+			"0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
+			ap_config_info->aqm[0], ap_config_info->aqm[1],
+			ap_config_info->aqm[2], ap_config_info->aqm[3],
+			ap_config_info->aqm[4], ap_config_info->aqm[5],
+			ap_config_info->aqm[6], ap_config_info->aqm[7]);
 }
 
 static BUS_ATTR_RO(ap_usage_domain_mask);
 
 static ssize_t ap_adapter_mask_show(struct bus_type *bus, char *buf)
 {
-	if (!ap_configuration)	/* QCI not supported */
-		return scnprintf(buf, PAGE_SIZE, "not supported\n");
+	if (!ap_config_info)  /* QCI not supported */
+		return snprintf(buf, PAGE_SIZE, "not supported\n");
 
-	return scnprintf(buf, PAGE_SIZE,
-			 "0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
-			 ap_configuration->apm[0], ap_configuration->apm[1],
-			 ap_configuration->apm[2], ap_configuration->apm[3],
-			 ap_configuration->apm[4], ap_configuration->apm[5],
-			 ap_configuration->apm[6], ap_configuration->apm[7]);
+	return snprintf(buf, PAGE_SIZE,
+			"0x%08x%08x%08x%08x%08x%08x%08x%08x\n",
+			ap_config_info->apm[0], ap_config_info->apm[1],
+			ap_config_info->apm[2], ap_config_info->apm[3],
+			ap_config_info->apm[4], ap_config_info->apm[5],
+			ap_config_info->apm[6], ap_config_info->apm[7]);
 }
 
 static BUS_ATTR_RO(ap_adapter_mask);
@@ -1079,7 +1085,7 @@ static ssize_t ap_max_domain_id_show(struct bus_type *bus, char *buf)
 {
 	int max_domain_id;
 
-	if (ap_configuration)
+	if (ap_config_info)
 		max_domain_id = ap_max_domain_id ? : -1;
 	else
 		max_domain_id = 15;
@@ -1373,6 +1379,50 @@ static int ap_get_compatible_type(ap_qid_t qid, int rawtype, unsigned int func)
 	return comp_type;
 }
 
+/* Helper function for notify_config_changed */
+static int __drv_notify_config_changed(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_config_changed)
+			ap_drv->on_config_changed(ap_config_info,
+						  ap_old_config_info);
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
+			ap_drv->on_scan_complete(ap_config_info,
+						 ap_old_config_info);
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
 /*
  * Helper function to be used with bus_find_dev
  * matches for the card device with the given id
@@ -1555,23 +1605,57 @@ static void _ap_scan_bus_adapter(int id)
 		put_device(&ac->ap_dev.device);
 }
 
+static int ap_config_changed(void)
+{
+	int cfg_chg = 0;
+
+	if (ap_config_info) {
+		if (!ap_old_config_info) {
+			ap_old_config_info = kzalloc(
+				sizeof(*ap_old_config_info), GFP_KERNEL);
+			if (!ap_old_config_info)
+				return 0;
+		} else {
+			memcpy(ap_old_config_info, ap_config_info,
+			       sizeof(struct ap_config_info));
+		}
+		ap_query_configuration(ap_config_info);
+		cfg_chg = memcmp(ap_config_info,
+				 ap_old_config_info,
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
 
 	AP_DBF(DBF_DEBUG, "%s running\n", __func__);
 
-	ap_query_configuration(ap_configuration);
+	mutex_lock(&ap_config_lock);
+
+	/* config change notify */
+	config_changed = ap_config_changed();
+	if (config_changed)
+		notify_config_changed();
 	ap_select_domain();
 
 	/* loop over all possible adapters */
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
@@ -1654,7 +1738,7 @@ static int __init ap_module_init(void)
 	/* Get AP configuration data if available */
 	ap_init_configuration();
 
-	if (ap_configuration)
+	if (ap_config_info)
 		max_domain_id =
 			ap_max_domain_id ? ap_max_domain_id : AP_DOMAINS - 1;
 	else
@@ -1723,7 +1807,8 @@ static int __init ap_module_init(void)
 out:
 	if (ap_using_interrupts())
 		unregister_adapter_interrupt(&ap_airq);
-	kfree(ap_configuration);
+	kfree(ap_config_info);
+	kfree(ap_old_config_info);
 	return rc;
 }
 device_initcall(ap_module_init);
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 7d9646251bfd..491ca8543398 100644
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

