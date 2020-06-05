Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB8A1F0220
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgFEVkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:40:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728882AbgFEVkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LWlHR155386;
        Fri, 5 Jun 2020 17:40:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rtdku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:19 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055Le0Yg181235;
        Fri, 5 Jun 2020 17:40:19 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rtdkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:19 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LYcg5001945;
        Fri, 5 Jun 2020 21:40:18 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 31bf49njm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:18 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeGk245482456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:16 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BFFAAC05B;
        Fri,  5 Jun 2020 21:40:16 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29FA5AC05F;
        Fri,  5 Jun 2020 21:40:16 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:16 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 14/16] s390/vfio-ap: handle host AP config change notification
Date:   Fri,  5 Jun 2020 17:40:02 -0400
Message-Id: <20200605214004.14270-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 bulkscore=0 cotscore=-2147483648 suspectscore=3
 spamscore=0 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050157
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
 drivers/s390/crypto/vfio_ap_ops.c     | 148 +++++++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |   7 +-
 3 files changed, 146 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 86fc83701e05..f0f83c1b8983 100644
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
@@ -175,6 +177,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
+	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3df050eae112..e3c4b2d73072 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -347,8 +347,9 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	}
 
 	matrix_mdev->mdev = mdev;
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
-	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
+	vfio_ap_matrix_init(&matrix_dev->config_info, &matrix_mdev->matrix);
+	vfio_ap_matrix_init(&matrix_dev->config_info,
+			    &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
@@ -527,8 +528,8 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 		 * If the APID is not assigned to the host AP configuration,
 		 * we can not assign it to the guest's AP configuration
 		 */
-		if (!test_bit_inv(apid,
-				  (unsigned long *)matrix_dev->info.apm)) {
+		if (!test_bit_inv(apid, (unsigned long *)
+				  matrix_dev->config_info.apm)) {
 			clear_bit_inv(apid, shadow_apcb->apm);
 			continue;
 		}
@@ -541,7 +542,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 * guest's AP configuration
 			 */
 			if (!test_bit_inv(apqi, (unsigned long *)
-					  matrix_dev->info.aqm)) {
+					  matrix_dev->config_info.aqm)) {
 				clear_bit_inv(apqi, shadow_apcb->aqm);
 				continue;
 			}
@@ -595,7 +596,7 @@ static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 	int napm, naqm;
 	struct ap_matrix shadow_apcb;
 
-	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
+	vfio_ap_matrix_init(&matrix_dev->config_info, &shadow_apcb);
 	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
 	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
 	/*
@@ -741,7 +742,7 @@ static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
 
 	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
 		if (!test_bit_inv(apqi,
-				  (unsigned long *) matrix_dev->info.aqm))
+				  (unsigned long *)matrix_dev->config_info.aqm))
 			clear_bit_inv(apqi, aqm);
 
 		apqn = AP_MKQID(apid, apqi);
@@ -764,7 +765,7 @@ static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
 	unsigned long apqi, apqn;
 
 	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
-	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
+	    !test_bit_inv(apid, (unsigned long *)matrix_dev->config_info.apm))
 		return false;
 
 	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
@@ -931,8 +932,8 @@ static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
 	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		if (!test_bit_inv(apid,
-				  (unsigned long *) matrix_dev->info.apm))
+		if (!test_bit_inv(apid, (unsigned long *)
+				  matrix_dev->config_info.apm))
 			clear_bit_inv(apqi, apm);
 
 		apqn = AP_MKQID(apid, apqi);
@@ -955,7 +956,7 @@ static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
 	unsigned long apid, apqn;
 
 	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
-	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
+	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->config_info.aqm))
 		return false;
 
 	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
@@ -1702,7 +1703,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
-	int apid, apqi;
+	unsigned long apid, apqi;
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&queue->ap_dev.device);
@@ -1729,3 +1730,126 @@ bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
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
+			if (bitmap_intersects(matrix_mdev->shadow_apcb.apm,
+					      apm_unassign, AP_DEVICES))
+				if (vfio_ap_mdev_unassign_apids(matrix_mdev,
+								apm_unassign))
+					unassigned = true;
+		if (aq_remove)
+			if (bitmap_intersects(matrix_mdev->shadow_apcb.aqm,
+					      aqm_unassign, AP_DOMAINS))
+				if (vfio_ap_mdev_unassign_apqis(matrix_mdev,
+								aqm_unassign))
+					unassigned = true;
+
+		if (unassigned)
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 055bce6d45db..fc8629e28ad3 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -40,10 +40,13 @@
 struct ap_matrix_dev {
 	struct device device;
 	atomic_t available_instances;
-	struct ap_config_info info;
+	struct ap_config_info config_info;
+	struct ap_config_info config_info_prev;
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
+	#define AP_MATRIX_CFG_CHG (1UL << 0)
+	unsigned long flags;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
@@ -108,5 +111,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 
 bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

