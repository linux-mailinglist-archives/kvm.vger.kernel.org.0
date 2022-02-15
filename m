Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8F4B5F7B
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiBOAvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiBOAvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F5C14236F;
        Mon, 14 Feb 2022 16:51:03 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ENwENl007619;
        Tue, 15 Feb 2022 00:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f6HbrQIBMlC1zS1xbKerpT+R5rN5tYIqPrbeJ5ma2Lo=;
 b=UrZUPYjFfKO9Tesz0e7TWAHkJ0Fs/2ThToWVGO4dgLwfZKjX86JvRvbictjJKm/drE3C
 IWBo/XomvMUohN880AhMgUoj9tVzUmOvpippajY8d8ZKYHqRBVcQMnkih5VnuVB8bQXr
 sgM+dUALW7tdFhpy4EKwESUEdhKRuFVKQPm9f+nMTIvo0pHHX2Cs2//O5ytyS93cVG2y
 puMeyWZJFGjzFM1Iy/+eKBhBrJCkvcQ6Pdm4PeJvchAH55O80BbFdnnPTFmKDS8Bv9d1
 FXLcR4AUSSE8I2wKmEU00I7nilGp2YyhTZU0DEUpOLLGAcM6/+UhE/lxaqtQDer8GltG JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej4m8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:51:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0edbU014813;
        Tue, 15 Feb 2022 00:51:00 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej4m8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:51:00 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g70E021518;
        Tue, 15 Feb 2022 00:50:59 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3e64hbfhte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:59 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0ouFo34341334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 679D412405B;
        Tue, 15 Feb 2022 00:50:56 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB0B124055;
        Tue, 15 Feb 2022 00:50:55 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:55 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 15/18] s390/vfio-ap: handle config changed and scan complete notification
Date:   Mon, 14 Feb 2022 19:50:37 -0500
Message-Id: <20220215005040.52697-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 70IKJms0KcaMA2LAgYHW7m_Y3GKItO8i
X-Proofpoint-ORIG-GUID: gtXvgC50c4I4gVid_a_OlZyaFwgTjFT5
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
---
 drivers/s390/crypto/vfio_ap_drv.c     |   4 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 347 ++++++++++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h |  15 +-
 3 files changed, 338 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index c4f0e28b1e91..711d5f2645b8 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -104,6 +104,8 @@ static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
 	.in_use = vfio_ap_mdev_resource_in_use,
+	.on_config_changed = vfio_ap_on_cfg_changed,
+	.on_scan_complete = vfio_ap_on_scan_complete,
 	.ids = ap_queue_ids,
 };
 
@@ -151,7 +153,7 @@ static int vfio_ap_matrix_dev_create(void)
 
 	/* Fill in config info via PQAP(QCI), if available */
 	if (test_facility(12)) {
-		ret = ap_qci(&matrix_dev->info);
+		ret = ap_qci(&matrix_dev->config_info);
 		if (ret)
 			goto matrix_alloc_err;
 	}
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 02f75c4207b0..3304088d1012 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -333,7 +333,7 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
 
 	bitmap_copy(shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
 	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
-		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+		   (unsigned long *)matrix_dev->config_info.adm, AP_DOMAINS);
 
 	return !bitmap_equal(shadow_adm, matrix_mdev->shadow_apcb.adm,
 			     AP_DOMAINS);
@@ -353,19 +353,15 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
 static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 				       struct ap_matrix_mdev *matrix_mdev)
 {
-	int ret;
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(shadow_aqm, AP_DOMAINS);
 	struct vfio_ap_queue *q;
 
-	ret = ap_qci(&matrix_dev->info);
-	if (ret)
-		return false;
-
 	bitmap_copy(shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
 	bitmap_copy(shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
+	vfio_ap_matrix_init(&matrix_dev->config_info,
+			    &matrix_mdev->shadow_apcb);
 
 	/*
 	 * Copy the adapters, domains and control domains to the shadow_apcb
@@ -373,9 +369,9 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 	 * AP configuration.
 	 */
 	bitmap_and(matrix_mdev->shadow_apcb.apm, matrix_mdev->matrix.apm,
-		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
+		   (unsigned long *)matrix_dev->config_info.apm, AP_DEVICES);
 	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
-		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
+		   (unsigned long *)matrix_dev->config_info.aqm, AP_DOMAINS);
 
 	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
 		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
@@ -389,6 +385,7 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 			 */
 			apqn = AP_MKQID(apid, apqi);
 			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
+
 			if (!q || q->reset_rc) {
 				clear_bit_inv(apid,
 					      matrix_mdev->shadow_apcb.apm);
@@ -420,9 +417,10 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 			    &vfio_ap_matrix_dev_ops);
 
 	matrix_mdev->mdev = mdev;
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
+	vfio_ap_matrix_init(&matrix_dev->config_info, &matrix_mdev->matrix);
+	vfio_ap_matrix_init(&matrix_dev->config_info,
+			    &matrix_mdev->shadow_apcb);
 	matrix_mdev->pqap_hook = handle_pqap;
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	mutex_lock(&matrix_dev->guests_lock);
@@ -790,13 +788,17 @@ static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
 
 	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
 	/* If the queue is assigned to the matrix mdev, unlink it. */
-	if (q)
+	if (q) {
 		vfio_ap_unlink_queue_fr_mdev(q);
 
-	/* If the queue is assigned to the APCB, store it in @qtable. */
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
-	    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
-		hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
+		/* If the queue is assigned to the APCB, store it in @qtable. */
+		if (qtable) {
+			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+				hash_add(qtable->queues, &q->mdev_qnode,
+					 q->apqn);
+		}
+	}
 }
 
 /**
@@ -1271,7 +1273,7 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
  * @matrix_mdev: a mediated matrix device
  * @kvm: reference to KVM instance
  *
- * Note: The matrix_dev->lock must be taken prior to calling
+ * Note: The matrix_dev->mdevs_lock must be taken prior to calling
  * this function; however, the lock will be temporarily released while the
  * guest's AP configuration is set to avoid a potential lockdep splat.
  * The kvm->lock is taken to set the guest's AP configuration which, under
@@ -1355,7 +1357,7 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
  * @matrix_mdev: a matrix mediated device
  * @kvm: the pointer to the kvm structure being unset.
  *
- * Note: The matrix_dev->lock must be taken prior to calling
+ * Note: The matrix_dev->mdevs_lock must be taken prior to calling
  * this function; however, the lock will be temporarily released while the
  * guest's AP configuration is cleared to avoid a potential lockdep splat.
  * The kvm->lock is taken to clear the guest's AP configuration which, under
@@ -1708,6 +1710,27 @@ static void vfio_ap_mdev_put_qlocks(struct ap_matrix_mdev *matrix_mdev)
 	mutex_unlock(&matrix_dev->guests_lock);
 }
 
+static bool vfio_ap_mdev_do_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
+					  struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	/*
+	 * If the queue is being probed because its APID or APQI is in the
+	 * process of being added to the host's AP configuration, then we don't
+	 * want to filter the matrix now as the filtering will be done after
+	 * the driver is notified that the AP bus scan operation has completed
+	 * (see the vfio_ap_on_scan_complete callback function).
+	 */
+	if (test_bit_inv(apid, matrix_mdev->apm_add) ||
+	    test_bit_inv(apqi, matrix_mdev->aqm_add))
+		return false;
+
+
+	return true;
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
@@ -1725,10 +1748,15 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
 		memset(apm, 0, sizeof(apm));
 		set_bit_inv(AP_QID_CARD(q->apqn), apm);
-		if (vfio_ap_mdev_filter_matrix(apm, q->matrix_mdev->matrix.aqm,
-					       q->matrix_mdev))
-			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
+
+		if (vfio_ap_mdev_do_filter_matrix(q->matrix_mdev, q)) {
+			if (vfio_ap_mdev_filter_matrix(apm,
+						q->matrix_mdev->matrix.aqm,
+						q->matrix_mdev))
+				vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
+		}
 	}
+
 	dev_set_drvdata(&apdev->device, q);
 	vfio_ap_mdev_put_qlocks(matrix_mdev);
 
@@ -1783,10 +1811,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
 		apid = AP_QID_CARD(q->apqn);
 		apqi = AP_QID_QUEUE(q->apqn);
-		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
-		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
-			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
-			vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+		/*
+		 * If the queue is assigned to the guest's APCB, then remove
+		 * the adapter's APID from the APCB and hot it into the guest.
+		 */
+		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) &&
+		    test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
 		}
 	}
 
@@ -1842,3 +1875,267 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	return ret;
 }
+
+/**
+ * vfio_ap_mdev_hot_unplug_cfg - hot unplug the adapters, domains and control
+ *				 domains that have been removed from the host's
+ *				 AP configuration from a guest.
+ *
+ * @guest: the guest
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
+	bool do_hotplug = false;
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
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
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
+	int do_ap_remove, do_aq_remove, do_cd_remove;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (!matrix_mdev->kvm)
+			continue;
+
+		mutex_lock(&matrix_mdev->kvm->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
+
+		do_ap_remove = bitmap_and(aprem, ap_remove,
+					  matrix_mdev->matrix.apm,
+					  AP_DEVICES);
+		do_aq_remove = bitmap_and(aqrem, aq_remove,
+					  matrix_mdev->matrix.aqm,
+					  AP_DOMAINS);
+		do_cd_remove = bitmap_andnot(cdrem, cd_remove,
+					     matrix_mdev->matrix.adm,
+					     AP_DOMAINS);
+
+		if (do_ap_remove || do_aq_remove || do_cd_remove)
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
+ */
+static void vfio_ap_mdev_on_cfg_remove(void)
+{
+	int ap_remove, aq_remove, cd_remove;
+	DECLARE_BITMAP(aprem, AP_DEVICES);
+	DECLARE_BITMAP(aqrem, AP_DOMAINS);
+	DECLARE_BITMAP(cdrem, AP_DOMAINS);
+	unsigned long *cur_apm, *cur_aqm, *cur_adm;
+	unsigned long *prev_apm, *prev_aqm, *prev_adm;
+
+	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
+	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
+	cur_adm = (unsigned long *)matrix_dev->config_info.adm;
+	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
+	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
+	prev_adm = (unsigned long *)matrix_dev->config_info_prev.adm;
+
+	ap_remove = bitmap_andnot(aprem, prev_apm, cur_apm, AP_DEVICES);
+	aq_remove = bitmap_andnot(aqrem, prev_aqm, cur_aqm, AP_DOMAINS);
+	cd_remove = bitmap_andnot(cdrem, prev_adm, cur_adm, AP_DOMAINS);
+
+	if (ap_remove || aq_remove || cd_remove)
+		vfio_ap_mdev_cfg_remove(aprem, aqrem, cdrem);
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
+ */
+static void vfio_ap_mdev_on_cfg_add(void)
+{
+	bool do_add;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
+	unsigned long *cur_apm, *cur_aqm, *cur_adm;
+	unsigned long *prev_apm, *prev_aqm, *prev_adm;
+
+	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
+	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
+	cur_adm = (unsigned long *)matrix_dev->config_info.adm;
+
+	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
+	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
+	prev_adm = (unsigned long *)matrix_dev->config_info_prev.adm;
+
+	do_add = bitmap_andnot(apm_add, cur_apm, prev_apm, AP_DEVICES);
+	do_add |= bitmap_andnot(aqm_add, cur_aqm, prev_aqm, AP_DOMAINS);
+	do_add |= bitmap_andnot(adm_add, cur_adm, prev_adm, AP_DOMAINS);
+
+	if (do_add)
+		vfio_ap_mdev_cfg_add(apm_add, aqm_add, adm_add);
+}
+
+/**
+ * vfio_ap_on_cfg_changed - handles notification of changes to the host AP
+ *			    configuration.
+ *
+ * @new_config_info: the new host AP configuration
+ * @old_config_info: the previous host AP configuration
+ */
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info)
+{
+	mutex_lock(&matrix_dev->guests_lock);
+
+	memcpy(&matrix_dev->config_info_prev, old_config_info,
+		       sizeof(struct ap_config_info));
+	memcpy(&matrix_dev->config_info, new_config_info,
+	       sizeof(struct ap_config_info));
+	vfio_ap_mdev_on_cfg_remove();
+	vfio_ap_mdev_on_cfg_add();
+
+	mutex_unlock(&matrix_dev->guests_lock);
+}
+
+static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
+{
+//	bool filter_matrix, filter_cdoms, do_hotplug = false;
+	bool do_hotplug = false;
+	bool filter_domains = false;
+	bool filter_adapters = false;
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
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
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
index e30f171f89ec..a7fe4a3cf896 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -31,7 +31,9 @@
  *
  * @device:	generic device structure associated with the AP matrix device
  * @available_instances: number of mediated matrix devices that can be created
- * @info:	the struct containing the output from the PQAP(QCI) instruction
+ * @config_info: the object containing the current AP configuration for the host
+ * @config_info_prev: the object containing the previous AP configuration for
+ *		      Gthe host
  * @mdev_list:	the list of mediated matrix devices created
  * @mdevs_lock:	mutex for locking the ap_matrix_mdev devices under the control
  *		of the vfio_ap device driver. This lock will be taken every time
@@ -47,7 +49,8 @@
 struct ap_matrix_dev {
 	struct device device;
 	atomic_t available_instances;
-	struct ap_config_info info;
+	struct ap_config_info config_info;
+	struct ap_config_info config_info_prev;
 	struct list_head mdev_list;
 	struct mutex mdevs_lock;
 	struct ap_driver  *vfio_ap_drv;
@@ -118,6 +121,9 @@ struct ap_matrix_mdev {
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
 };
 
 /**
@@ -148,4 +154,9 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

