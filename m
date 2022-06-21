Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B59B5536D0
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353357AbiFUPwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353246AbiFUPwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:52:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB172CE34;
        Tue, 21 Jun 2022 08:52:00 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEo14R036297;
        Tue, 21 Jun 2022 15:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mf3XLyJHHooa9JkSfkLl6ZMtkjDQJzJqrox8hfmKEb8=;
 b=XZK6RAJj0gEe4Cg6EuH+RCHyTtHP45ZHD8a1bf6y3rWUtMq7w82LWFKo+VY+DBGK9FXJ
 AD/XvO/5ZGmakTcawI5knDZoo0WgnHkCc4oxjFJoeHHSiZnasm04hnMcSLn+JYyi2h90
 XtEBzzU24zkVSo7hTwwlHPRoCcCGKR/MKdlGPTv8nKe5H4atq2j+YKdRTmd4jeeuPd6o
 K4LgeOk8a9TQEPBudH9s6pCn9rGqJSyt44PUiGMd/92i/IG5Fs/DtMgdpBkJnaCWbOgV
 yDcKSflN025usw4z0l0mqdi4Uy1C4GVoGYHgEckJhwWD8DqIGe3UvZxY0pCA04lIlp6h 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug3mhw54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEpQx4040129;
        Tue, 21 Jun 2022 15:51:57 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug3mhw4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:57 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZOdZ014747;
        Tue, 21 Jun 2022 15:51:57 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3gs6bacw35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:57 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpuDj14746234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:56 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1EB1136051;
        Tue, 21 Jun 2022 15:51:55 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF50113605E;
        Tue, 21 Jun 2022 15:51:54 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:54 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 17/20] s390/vfio-ap: handle config changed and scan complete notification
Date:   Tue, 21 Jun 2022 11:51:31 -0400
Message-Id: <20220621155134.1932383-18-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K8bU91TG8uMcgPkxnt_v3JcCYLmvTudL
X-Proofpoint-GUID: 8DZGnGYZvHtQjEu5qLqL5GYCpirYSx9l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
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

This patch implements two new AP driver callbacks:

void (*on_config_changed)(struct ap_config_info *new_config_info,
                  struct ap_config_info *old_config_info);

void (*on_scan_complete)(struct ap_config_info *new_config_info,
                 struct ap_config_info *old_config_info);

The on_config_changed callback is invoked at the start of the AP bus scan
function when it determines that the host AP configuration information
has changed since the previous scan.

The vfio_ap device driver registers a callback function for this callback
that performs the following operations:

1. Unplugs the adapters, domains and control domains removed from the
host's AP configuration from the guests to which they are
assigned in a single operation.

2. Stores bitmaps identifying the adapters, domains and control domains
added to the host's AP configuration with the structure representing
the mediated device. When the vfio_ap device driver's probe callback is
subsequently invoked, the probe function will recognize that the
queue is being probed due to a change in the host's AP configuration
and the plugging of the queue into the guest will be bypassed.

The on_scan_complete callback is invoked after the ap bus scan is
completed if the host AP configuration data has changed. The vfio_ap
device driver registers a callback function for this callback that hot
plugs each queue and control domain added to the AP configuration for each
guest using them in a single hot plug operation.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |   2 +
 drivers/s390/crypto/vfio_ap_ops.c     | 341 +++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  12 +
 3 files changed, 350 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 2572fb0f0f54..f43cfeabd2cc 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -47,6 +47,8 @@ static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
 	.in_use = vfio_ap_mdev_resource_in_use,
+	.on_config_changed = vfio_ap_on_cfg_changed,
+	.on_scan_complete = vfio_ap_on_scan_complete,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 41fc2072a77b..f6ad61f324a6 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -641,16 +641,11 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
 static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 				       struct ap_matrix_mdev *matrix_mdev)
 {
-	int ret;
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(prev_shadow_aqm, AP_DOMAINS);
 	struct vfio_ap_queue *q;
 
-	ret = ap_qci(&matrix_dev->info);
-	if (ret)
-		return false;
-
 	bitmap_copy(prev_shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
 	bitmap_copy(prev_shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
@@ -1975,3 +1970,339 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	return ret;
 }
+
+/**
+ * vfio_ap_mdev_hot_unplug_cfg - hot unplug the adapters, domains and control
+ *				 domains that have been removed from the host's
+ *				 AP configuration from a guest.
+ *
+ * @matrix_mdev: an ap_matrix_mdev object attached to a KVM guest.
+ * @aprem: the adapters that have been removed from the host's AP configuration
+ * @aqrem: the domains that have been removed from the host's AP configuration
+ * @cdrem: the control domains that have been removed from the host's AP
+ *	   configuration.
+ */
+static void vfio_ap_mdev_hot_unplug_cfg(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long *aprem,
+					unsigned long *aqrem,
+					unsigned long *cdrem)
+{
+	int do_hotplug = 0;
+
+	if (!bitmap_empty(aprem, AP_DEVICES)) {
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.apm,
+					    matrix_mdev->shadow_apcb.apm,
+					    aprem, AP_DEVICES);
+	}
+
+	if (!bitmap_empty(aqrem, AP_DOMAINS)) {
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.aqm,
+					    matrix_mdev->shadow_apcb.aqm,
+					    aqrem, AP_DEVICES);
+	}
+
+	if (!bitmap_empty(cdrem, AP_DOMAINS))
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.adm,
+					    matrix_mdev->shadow_apcb.adm,
+					    cdrem, AP_DOMAINS);
+
+	if (do_hotplug)
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+}
+
+/**
+ * vfio_ap_mdev_cfg_remove - determines which guests are using the adapters,
+ *			     domains and control domains that have been removed
+ *			     from the host AP configuration and unplugs them
+ *			     from those guests.
+ *
+ * @ap_remove:	bitmap specifying which adapters have been removed from the host
+ *		config.
+ * @aq_remove:	bitmap specifying which domains have been removed from the host
+ *		config.
+ * @cd_remove:	bitmap specifying which control domains have been removed from
+ *		the host config.
+ */
+static void vfio_ap_mdev_cfg_remove(unsigned long *ap_remove,
+				    unsigned long *aq_remove,
+				    unsigned long *cd_remove)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	DECLARE_BITMAP(aprem, AP_DEVICES);
+	DECLARE_BITMAP(aqrem, AP_DOMAINS);
+	DECLARE_BITMAP(cdrem, AP_DOMAINS);
+	int do_remove = 0;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		mutex_lock(&matrix_mdev->kvm->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
+
+		do_remove |= bitmap_and(aprem, ap_remove,
+					  matrix_mdev->matrix.apm,
+					  AP_DEVICES);
+		do_remove |= bitmap_and(aqrem, aq_remove,
+					  matrix_mdev->matrix.aqm,
+					  AP_DOMAINS);
+		do_remove |= bitmap_andnot(cdrem, cd_remove,
+					     matrix_mdev->matrix.adm,
+					     AP_DOMAINS);
+
+		if (do_remove)
+			vfio_ap_mdev_hot_unplug_cfg(matrix_mdev, aprem, aqrem,
+						    cdrem);
+
+		mutex_unlock(&matrix_dev->mdevs_lock);
+		mutex_unlock(&matrix_mdev->kvm->lock);
+	}
+}
+
+/**
+ * vfio_ap_mdev_on_cfg_remove - responds to the removal of adapters, domains and
+ *				control domains from the host AP configuration
+ *				by unplugging them from the guests that are
+ *				using them.
+ * @cur_config_info: the current host AP configuration information
+ * @prev_config_info: the previous host AP configuration information
+ */
+static void vfio_ap_mdev_on_cfg_remove(struct ap_config_info *cur_config_info,
+				       struct ap_config_info *prev_config_info)
+{
+	int do_remove;
+	DECLARE_BITMAP(aprem, AP_DEVICES);
+	DECLARE_BITMAP(aqrem, AP_DOMAINS);
+	DECLARE_BITMAP(cdrem, AP_DOMAINS);
+
+	do_remove = bitmap_andnot(aprem,
+				  (unsigned long *)prev_config_info->apm,
+				  (unsigned long *)cur_config_info->apm,
+				  AP_DEVICES);
+	do_remove |= bitmap_andnot(aqrem,
+				   (unsigned long *)prev_config_info->aqm,
+				   (unsigned long *)cur_config_info->aqm,
+				   AP_DEVICES);
+	do_remove |= bitmap_andnot(cdrem,
+				   (unsigned long *)prev_config_info->adm,
+				   (unsigned long *)cur_config_info->adm,
+				   AP_DEVICES);
+
+	if (do_remove)
+		vfio_ap_mdev_cfg_remove(aprem, aqrem, cdrem);
+}
+
+/**
+ * vfio_ap_filter_apid_by_qtype: filter APIDs from an AP mask for adapters that
+ *				 are older than AP type 10 (CEX4).
+ * @apm: a bitmap of the APIDs to examine
+ * @aqm: a bitmap of the APQIs of the queues to query for the AP type.
+ */
+static void vfio_ap_filter_apid_by_qtype(unsigned long *apm, unsigned long *aqm)
+{
+	bool apid_cleared;
+	struct ap_queue_status status;
+	unsigned long apid, apqi, info;
+	int qtype, qtype_mask = 0xff000000;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		apid_cleared = false;
+
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			status = ap_test_queue(AP_MKQID(apid, apqi), 1, &info);
+			switch (status.response_code) {
+			/*
+			 * According to the architecture in each case
+			 * below, the queue's info should be filled.
+			 */
+			case AP_RESPONSE_NORMAL:
+			case AP_RESPONSE_RESET_IN_PROGRESS:
+			case AP_RESPONSE_DECONFIGURED:
+			case AP_RESPONSE_CHECKSTOPPED:
+			case AP_RESPONSE_BUSY:
+				qtype = info & qtype_mask;
+
+				/*
+				 * The vfio_ap device driver only
+				 * supports CEX4 and newer adapters, so
+				 * remove the APID if the adapter is
+				 * older than a CEX4.
+				 */
+				if (qtype < AP_DEVICE_TYPE_CEX4) {
+					clear_bit_inv(apid, apm);
+					apid_cleared = true;
+				}
+
+				break;
+
+			default:
+				/*
+				 * If we don't know the adapter type,
+				 * clear its APID since it can't be
+				 * determined whether the vfio_ap
+				 * device driver supports it.
+				 */
+				clear_bit_inv(apid, apm);
+				apid_cleared = true;
+				break;
+			}
+
+			/*
+			 * If we've already cleared the APID from the apm, there
+			 * is no need to continue examining the remainin AP
+			 * queues to determine the type of the adapter.
+			 */
+			if (apid_cleared)
+				continue;
+		}
+	}
+}
+
+/**
+ * vfio_ap_mdev_cfg_add - store bitmaps specifying the adapters, domains and
+ *			  control domains that have been added to the host's
+ *			  AP configuration for each matrix mdev to which they
+ *			  are assigned.
+ *
+ * @apm_add: a bitmap specifying the adapters that have been added to the AP
+ *	     configuration.
+ * @aqm_add: a bitmap specifying the domains that have been added to the AP
+ *	     configuration.
+ * @adm_add: a bitmap specifying the control domains that have been added to the
+ *	     AP configuration.
+ */
+static void vfio_ap_mdev_cfg_add(unsigned long *apm_add, unsigned long *aqm_add,
+				 unsigned long *adm_add)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	if (list_empty(&matrix_dev->mdev_list))
+		return;
+
+	vfio_ap_filter_apid_by_qtype(apm_add, aqm_add);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		bitmap_and(matrix_mdev->apm_add,
+			   matrix_mdev->matrix.apm, apm_add, AP_DEVICES);
+		bitmap_and(matrix_mdev->aqm_add,
+			   matrix_mdev->matrix.aqm, aqm_add, AP_DOMAINS);
+		bitmap_and(matrix_mdev->adm_add,
+			   matrix_mdev->matrix.adm, adm_add, AP_DEVICES);
+	}
+}
+
+/**
+ * vfio_ap_mdev_on_cfg_add - responds to the addition of adapters, domains and
+ *			     control domains to the host AP configuration
+ *			     by updating the bitmaps that specify what adapters,
+ *			     domains and control domains have been added so they
+ *			     can be hot plugged into the guest when the AP bus
+ *			     scan completes (see vfio_ap_on_scan_complete
+ *			     function).
+ * @cur_config_info: the current AP configuration information
+ * @prev_config_info: the previous AP configuration information
+ */
+static void vfio_ap_mdev_on_cfg_add(struct ap_config_info *cur_config_info,
+				    struct ap_config_info *prev_config_info)
+{
+	bool do_add;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
+
+	do_add = bitmap_andnot(apm_add,
+			       (unsigned long *)cur_config_info->apm,
+			       (unsigned long *)prev_config_info->apm,
+			       AP_DEVICES);
+	do_add |= bitmap_andnot(aqm_add,
+				(unsigned long *)cur_config_info->aqm,
+				(unsigned long *)prev_config_info->aqm,
+				AP_DOMAINS);
+	do_add |= bitmap_andnot(adm_add,
+				(unsigned long *)cur_config_info->adm,
+				(unsigned long *)prev_config_info->adm,
+				AP_DOMAINS);
+
+	if (do_add)
+		vfio_ap_mdev_cfg_add(apm_add, aqm_add, adm_add);
+}
+
+/**
+ * vfio_ap_on_cfg_changed - handles notification of changes to the host AP
+ *			    configuration.
+ *
+ * @cur_cfg_info: the current host AP configuration
+ * @prev_cfg_info: the previous host AP configuration
+ */
+void vfio_ap_on_cfg_changed(struct ap_config_info *cur_cfg_info,
+			    struct ap_config_info *prev_cfg_info)
+{
+	if (!cur_cfg_info || !prev_cfg_info)
+		return;
+
+	mutex_lock(&matrix_dev->guests_lock);
+
+	vfio_ap_mdev_on_cfg_remove(cur_cfg_info, prev_cfg_info);
+	vfio_ap_mdev_on_cfg_add(cur_cfg_info, prev_cfg_info);
+	memcpy(&matrix_dev->info, cur_cfg_info, sizeof(*cur_cfg_info));
+
+	mutex_unlock(&matrix_dev->guests_lock);
+}
+
+static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
+{
+	bool do_hotplug = false;
+	int filter_domains = 0;
+	int filter_adapters = 0;
+	DECLARE_BITMAP(apm, AP_DEVICES);
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
+
+	mutex_lock(&matrix_mdev->kvm->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
+
+	filter_adapters = bitmap_and(apm, matrix_mdev->matrix.apm,
+				     matrix_mdev->apm_add, AP_DEVICES);
+	filter_domains = bitmap_and(aqm, matrix_mdev->matrix.aqm,
+				    matrix_mdev->aqm_add, AP_DOMAINS);
+
+	if (filter_adapters && filter_domains)
+		do_hotplug |= vfio_ap_mdev_filter_matrix(apm, aqm, matrix_mdev);
+	else if (filter_adapters)
+		do_hotplug |=
+			vfio_ap_mdev_filter_matrix(apm,
+						   matrix_mdev->shadow_apcb.aqm,
+						   matrix_mdev);
+	else
+		do_hotplug |=
+			vfio_ap_mdev_filter_matrix(matrix_mdev->shadow_apcb.apm,
+						   aqm, matrix_mdev);
+
+	if (bitmap_intersects(matrix_mdev->matrix.adm, matrix_mdev->adm_add,
+			      AP_DOMAINS))
+		do_hotplug |= vfio_ap_mdev_filter_cdoms(matrix_mdev);
+
+	if (do_hotplug)
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_mdev->kvm->lock);
+}
+
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	mutex_lock(&matrix_dev->guests_lock);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (bitmap_empty(matrix_mdev->apm_add, AP_DEVICES) &&
+		    bitmap_empty(matrix_mdev->aqm_add, AP_DOMAINS) &&
+		    bitmap_empty(matrix_mdev->adm_add, AP_DOMAINS))
+			continue;
+
+		vfio_ap_mdev_hot_plug_cfg(matrix_mdev);
+		bitmap_clear(matrix_mdev->apm_add, 0, AP_DEVICES);
+		bitmap_clear(matrix_mdev->aqm_add, 0, AP_DOMAINS);
+		bitmap_clear(matrix_mdev->adm_add, 0, AP_DOMAINS);
+	}
+
+	mutex_unlock(&matrix_dev->guests_lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index e19a3e38fb32..7a3525c861e8 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -105,6 +105,10 @@ struct ap_queue_table {
  *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
  * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
+ * @apm_add:	bitmap of APIDs added to the host's AP configuration
+ * @aqm_add:	bitmap of APQIs added to the host's AP configuration
+ * @adm_add:	bitmap of control domain numbers added to the host's AP
+ *		configuration
  */
 struct ap_matrix_mdev {
 	struct vfio_device vdev;
@@ -116,6 +120,9 @@ struct ap_matrix_mdev {
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
 };
 
 /**
@@ -146,4 +153,9 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.35.3

