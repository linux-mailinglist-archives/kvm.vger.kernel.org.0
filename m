Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141794B5F5E
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiBOAvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiBOAvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5602513C38E;
        Mon, 14 Feb 2022 16:50:51 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F0keZV018310;
        Tue, 15 Feb 2022 00:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MJshAKfgspkwjIyiZFjyHrHvT8FkglwidUVvKmpC3AQ=;
 b=e3GsVrxDSEHvOxUtumCtGqBOltaZuILI/PS/hKmBENm/DS05Y33G6Nb3VOVkczgLD1n3
 e6ZMPNoLHW6mk+fAaV57wV1wSSKzCf4Xsj7O9zKqRylxJzru9xixulOCmdGxArTRM4ld
 RPMWZG32NeVEEqvBqt+OQcPPCQSdSdFLwDUcEjV6JLMaK6hxqkQwuRHNxm5Z9zJDC2i3
 j3lph6syntbhnGrSbeS0SjBNcWdGNNk81D6SA0lkulReJrfvXO34uV3OP0QjCQZci0ta
 M/4JVblkXUfgecQFXv9cwtB57NphUxCSyTt+TOu9scyfNz4q0puXEgg2gDKA6Kh6PtnQ nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785th6ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:49 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0kVWs021800;
        Tue, 15 Feb 2022 00:50:49 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785th6k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:48 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0hlr8015577;
        Tue, 15 Feb 2022 00:50:48 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3e64hb7gx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0ojWv24314140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:45 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACAD1124058;
        Tue, 15 Feb 2022 00:50:45 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D82D4124055;
        Tue, 15 Feb 2022 00:50:44 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: [PATCH v18 02/18] s390/ap: notify drivers on config changed and scan complete callbacks
Date:   Mon, 14 Feb 2022 19:50:24 -0500
Message-Id: <20220215005040.52697-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MrOjKTRlhMxz9KO046K4FJOAIKvxiW4Q
X-Proofpoint-ORIG-GUID: tJEzEFFnTCc1RCg0VnU_jz68I5EzsbFX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces an extension to the ap bus to notify device drivers
when the host AP configuration changes - i.e., adapters, domains or
control domains are added or removed. When an adapter or domain is added to
the host's AP configuration, the AP bus will create the associated queue
devices in the linux sysfs device model. Each new type 10 (i.e., CEX4) or
newer queue device with an APQN that is not reserved for the default device
driver will get bound to the vfio_ap device driver. Likewise, whan an
adapter or domain is removed from the host's AP configuration, the AP bus
will remove the associated queue devices from the sysfs device model. Each
of the queues that is bound to the vfio_ap device driver will get unbound.

With the introduction of hot plug support, binding or unbinding of a
queue device will result in plugging or unplugging one or more queues from
a guest that is using the queue. If there are multiple changes to the
host's AP configuration, it could result in the probe and remove callbacks
getting invoked multiple times. Each time queues are plugged into or
unplugged from a guest, the guest's VCPUs must be taken out of SIE.
If this occurs multiple times due to changes in the host's AP
configuration, that can have an undesirable negative affect on the guest's
performance.

To alleviate this problem, this patch introduces two new callbacks: one to
notify the vfio_ap device driver when the AP bus scan routine detects a
change to the host's AP configuration; and, one to notify the driver when
the AP bus is done scanning. This will allow the vfio_ap driver to do
bulk processing of all affected adapters, domains and control domains for
affected guests rather than plugging or unplugging them one at a time when
the probe or remove callback is invoked. The two new callbacks are:

void (*on_config_changed)(struct ap_config_info *new_config_info,
                          struct ap_config_info *old_config_info);

This callback is invoked at the start of the AP bus scan
function when it determines that the host AP configuration information
has changed since the previous scan. This is done by storing
an old and current QCI info struct and comparing them. If there is any
difference, the callback is invoked.

void (*on_scan_complete)(struct ap_config_info *new_config_info,
                         struct ap_config_info *old_config_info);

The on_scan_complete callback is invoked after the ap bus scan is
completed if the host AP configuration data has changed.

Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
---
 drivers/s390/crypto/ap_bus.c | 81 +++++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/ap_bus.h | 12 ++++++
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index d71d2d2c341f..f5fae8b62bdf 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -92,6 +92,7 @@ static atomic64_t ap_bindings_complete_count = ATOMIC64_INIT(0);
 static DECLARE_COMPLETION(ap_init_apqn_bindings_complete);
 
 static struct ap_config_info *ap_qci_info;
+static struct ap_config_info *ap_qci_info_old;
 
 /*
  * AP bus related debug feature things.
@@ -229,9 +230,14 @@ static void __init ap_init_qci_info(void)
 	ap_qci_info = kzalloc(sizeof(*ap_qci_info), GFP_KERNEL);
 	if (!ap_qci_info)
 		return;
+	ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old), GFP_KERNEL);
+	if (!ap_qci_info_old)
+		return;
 	if (ap_fetch_qci_info(ap_qci_info) != 0) {
 		kfree(ap_qci_info);
+		kfree(ap_qci_info_old);
 		ap_qci_info = NULL;
+		ap_qci_info_old = NULL;
 		return;
 	}
 	AP_DBF_INFO("%s successful fetched initial qci info\n", __func__);
@@ -248,6 +254,8 @@ static void __init ap_init_qci_info(void)
 				    __func__, ap_max_domain_id);
 		}
 	}
+
+	memcpy(ap_qci_info_old, ap_qci_info, sizeof(*ap_qci_info));
 }
 
 /*
@@ -1630,6 +1638,49 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
 		&& AP_QID_QUEUE(to_ap_queue(dev)->qid) == (int)(long) data;
 }
 
+/* Helper function for notify_config_changed */
+static int __drv_notify_config_changed(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_config_changed)
+			ap_drv->on_config_changed(ap_qci_info, ap_qci_info_old);
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
 /*
  * Helper function for ap_scan_bus().
  * Remove card device and associated queue devices.
@@ -1917,6 +1968,25 @@ static inline void ap_scan_adapter(int ap)
 	put_device(&ac->ap_dev.device);
 }
 
+/**
+ * ap_get_configuration - get the host AP configuration
+ *
+ * Stores the host AP configuration information returned from the previous call
+ * to Query Configuration Information (QCI), then retrieves and stores the
+ * current AP configuration returned from QCI.
+ *
+ * Return: true if the host AP configuration changed between calls to QCI;
+ * otherwise, return false.
+ */
+static bool ap_get_configuration(void)
+{
+	memcpy(ap_qci_info_old, ap_qci_info, sizeof(*ap_qci_info));
+	ap_fetch_qci_info(ap_qci_info);
+
+	return memcmp(ap_qci_info, ap_qci_info_old,
+		      sizeof(struct ap_config_info)) != 0;
+}
+
 /**
  * ap_scan_bus(): Scan the AP bus for new devices
  * Runs periodically, workqueue timer (ap_config_time)
@@ -1924,9 +1994,12 @@ static inline void ap_scan_adapter(int ap)
  */
 static void ap_scan_bus(struct work_struct *unused)
 {
-	int ap;
+	int ap, config_changed = 0;
 
-	ap_fetch_qci_info(ap_qci_info);
+	/* config change notify */
+	config_changed = ap_get_configuration();
+	if (config_changed)
+		notify_config_changed();
 	ap_select_domain();
 
 	AP_DBF_DBG("%s running\n", __func__);
@@ -1935,6 +2008,10 @@ static void ap_scan_bus(struct work_struct *unused)
 	for (ap = 0; ap <= ap_max_adapter_id; ap++)
 		ap_scan_adapter(ap);
 
+	/* scan complete notify */
+	if (config_changed)
+		notify_scan_complete();
+
 	/* check if there is at least one queue available with default domain */
 	if (ap_domain_index >= 0) {
 		struct device *dev =
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 67c1bef60ad5..4de062ea6b76 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -143,6 +143,18 @@ struct ap_driver {
 	int (*probe)(struct ap_device *);
 	void (*remove)(struct ap_device *);
 	int (*in_use)(unsigned long *apm, unsigned long *aqm);
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
2.31.1

