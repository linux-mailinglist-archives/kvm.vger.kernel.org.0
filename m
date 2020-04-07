Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9E1A15C8
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgDGTVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:21:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727435AbgDGTUn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J50C3000740;
        Tue, 7 Apr 2020 15:20:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082pes0ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J5A4R002062;
        Tue, 7 Apr 2020 15:20:41 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082pes0kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:41 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKaWc027396;
        Tue, 7 Apr 2020 19:20:40 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 306hv71392-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:40 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKcfU53936562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:38 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3A972805A;
        Tue,  7 Apr 2020 19:20:38 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28FE628058;
        Tue,  7 Apr 2020 19:20:38 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 13/15] s390/vfio-ap: handle host AP config change notification
Date:   Tue,  7 Apr 2020 15:20:13 -0400
Message-Id: <20200407192015.19887-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=999 suspectscore=3 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implements the driver callback invoked by the AP bus when the host
AP configuration has changed. Since this callback is invoked prior to
unbinding a device from its device driver, the vfio_ap driver will
respond by unplugging the AP adapters, domains and control domains
removed from the host's AP configuration from the guests using them.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |   5 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 136 ++++++++++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h |   7 +-
 3 files changed, 140 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 5197a1fe14d4..9f6c5d82dfb5 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -113,9 +113,11 @@ static int vfio_ap_matrix_dev_create(void)
 
 	/* Fill in config info via PQAP(QCI), if available */
 	if (test_facility(12)) {
-		ret = ap_qci(&matrix_dev->info);
+		ret = ap_qci(&matrix_dev->config_info);
 		if (ret)
 			goto matrix_alloc_err;
+		memcpy(&matrix_dev->config_info_prev, &matrix_dev->config_info,
+		       sizeof(struct ap_config_info));
 	}
 
 	mutex_init(&matrix_dev->lock);
@@ -176,6 +178,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
+	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 88a4aef5193f..f1dd77729dd9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -336,8 +336,9 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	}
 
 	matrix_mdev->mdev = mdev;
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_crycb);
+	vfio_ap_matrix_init(&matrix_dev->config_info, &matrix_mdev->matrix);
+	vfio_ap_matrix_init(&matrix_dev->config_info,
+			    &matrix_mdev->shadow_crycb);
 	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
@@ -485,8 +486,8 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 		 * If the APID is not assigned to the host AP configuration,
 		 * we can not assign it to the guest's AP configuration
 		 */
-		if (!test_bit_inv(apid,
-				  (unsigned long *)matrix_dev->info.apm)) {
+		if (!test_bit_inv(apid, (unsigned long *)
+				  matrix_dev->config_info.apm)) {
 			clear_bit_inv(apid, shadow_crycb->apm);
 			continue;
 		}
@@ -499,7 +500,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 * guest's AP configuration
 			 */
 			if (!test_bit_inv(apqi, (unsigned long *)
-					  matrix_dev->info.aqm)) {
+					  matrix_dev->config_info.aqm)) {
 				clear_bit_inv(apqi, shadow_crycb->aqm);
 				continue;
 			}
@@ -1617,7 +1618,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
-	int apid, apqi;
+	unsigned long apid, apqi;
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&queue->ap_dev.device);
@@ -1643,3 +1644,126 @@ bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	return in_use;
 }
+
+/**
+ * vfio_ap_mdev_unassign_apids
+ *
+ * @matrix_mdev: The matrix mediated device
+ *
+ * @aqm: A bitmap with 256 bits. Each bit in the map represents an APID from 0
+ *	 to 255 (with the leftmost bit corresponding to APID 0).
+ *
+ * Unassigns each APID specified in @aqm that is assigned to the shadow CRYCB
+ * of @matrix_mdev. Returns true if at least one APID is unassigned; otherwise,
+ * returns false.
+ */
+bool vfio_ap_mdev_unassign_apids(struct ap_matrix_mdev *matrix_mdev,
+				 unsigned long *apm_unassign)
+{
+	unsigned long apid;
+	bool unassigned = false;
+
+	/*
+	 * If the matrix mdev is not in use by a KVM guest, return indicating
+	 * that no APIDs have been unassigned.
+	 */
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return false;
+
+	for_each_set_bit_inv(apid, apm_unassign, AP_DEVICES) {
+		unassigned |= vfio_ap_mdev_unassign_guest_apid(matrix_mdev,
+							       apid);
+	}
+
+	return unassigned;
+}
+
+/**
+ * vfio_ap_mdev_unassign_apqis
+ *
+ * @matrix_mdev: The matrix mediated device
+ *
+ * @aqm: A bitmap with 256 bits. Each bit in the map represents an APQI from 0
+ *	 to 255 (with the leftmost bit corresponding to APQI 0).
+ *
+ * Unassigns each APQI specified in @aqm that is assigned to the shadow CRYCB
+ * of @matrix_mdev. Returns true if at least one APQI is unassigned; otherwise,
+ * returns false.
+ */
+bool vfio_ap_mdev_unassign_apqis(struct ap_matrix_mdev *matrix_mdev,
+				 unsigned long *aqm_unassign)
+{
+	unsigned long apqi;
+	bool unassigned = false;
+
+	/*
+	 * If the matrix mdev is not in use by a KVM guest, return indicating
+	 * that no APQIs have been unassigned.
+	 */
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return false;
+
+	for_each_set_bit_inv(apqi, aqm_unassign, AP_DOMAINS) {
+		unassigned |= vfio_ap_mdev_unassign_guest_apqi(matrix_mdev,
+							       apqi);
+	}
+
+	return unassigned;
+}
+
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info)
+{
+	bool unassigned;
+	int ap_remove, aq_remove;
+	struct ap_matrix_mdev *matrix_mdev;
+	DECLARE_BITMAP(apm_unassign, AP_DEVICES);
+	DECLARE_BITMAP(aqm_unassign, AP_DOMAINS);
+
+	unsigned long *cur_apm, *cur_aqm, *prev_apm, *prev_aqm;
+
+	if (matrix_dev->flags & AP_MATRIX_CFG_CHG) {
+		WARN_ONCE(1, "AP host configuration change already reported");
+		return;
+	}
+
+	memcpy(&matrix_dev->config_info, new_config_info,
+	       sizeof(struct ap_config_info));
+	memcpy(&matrix_dev->config_info_prev, old_config_info,
+	       sizeof(struct ap_config_info));
+
+	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
+	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
+	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
+	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
+
+	ap_remove = bitmap_andnot(apm_unassign, prev_apm, cur_apm, AP_DEVICES);
+	aq_remove = bitmap_andnot(aqm_unassign, prev_aqm, cur_aqm, AP_DOMAINS);
+
+	mutex_lock(&matrix_dev->lock);
+	matrix_dev->flags |= AP_MATRIX_CFG_CHG;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+			continue;
+
+		unassigned = false;
+
+		if (ap_remove)
+			if (bitmap_intersects(matrix_mdev->shadow_crycb.apm,
+					      apm_unassign, AP_DEVICES))
+				if (vfio_ap_mdev_unassign_apids(matrix_mdev,
+								apm_unassign))
+					unassigned = true;
+		if (aq_remove)
+			if (bitmap_intersects(matrix_mdev->shadow_crycb.aqm,
+					      aqm_unassign, AP_DOMAINS))
+				if (vfio_ap_mdev_unassign_apqis(matrix_mdev,
+								aqm_unassign))
+					unassigned = true;
+
+		if (unassigned)
+			vfio_ap_mdev_commit_crycb(matrix_mdev);
+	}
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 794c60a767d2..82abbf03781f 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -40,11 +40,14 @@
 struct ap_matrix_dev {
 	struct device device;
 	atomic_t available_instances;
-	struct ap_config_info info;
+	struct ap_config_info config_info;
+	struct ap_config_info config_info_prev;
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
 	DECLARE_HASHTABLE(qtable, 8);
+	#define AP_MATRIX_CFG_CHG (1UL << 0)
+	unsigned long flags;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
@@ -109,5 +112,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 
 bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

