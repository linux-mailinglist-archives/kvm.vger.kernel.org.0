Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0231A15BE
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgDGTUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:20:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbgDGTUo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:44 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J38KU034732;
        Tue, 7 Apr 2020 15:20:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx343s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:42 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J3M3E036151;
        Tue, 7 Apr 2020 15:20:42 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx343e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:42 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKV8l011500;
        Tue, 7 Apr 2020 19:20:41 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 306hv6s2dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:41 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKdAd39256362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:39 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A520428059;
        Tue,  7 Apr 2020 19:20:39 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B3B28058;
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
Subject: [PATCH v7 14/15] s390/vfio-ap: handle AP bus scan completed notification
Date:   Tue,  7 Apr 2020 15:20:14 -0400
Message-Id: <20200407192015.19887-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 suspectscore=3 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004070153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implements the driver callback invoked by the AP bus when the AP bus
scan has completed. Since this callback is invoked after binding the newly
added devices to their respective device drivers, the vfio_ap driver will
attempt to plug the adapters, domains and control domains into each guest
using a matrix mdev to which they are assigned. Keep in mind that an
adapter or domain can be plugged in only if each APQN with the APID of the
adapter or the APQI of the domain references a queue device bound to the
vfio_ap device driver. Consequently, not all newly added adapters and
domains will necessarily get hot plugged.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |   1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 132 +++++++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 3 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 9f6c5d82dfb5..0ed557634302 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -179,6 +179,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
+	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f1dd77729dd9..ccc58daf82f6 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -489,6 +489,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 		if (!test_bit_inv(apid, (unsigned long *)
 				  matrix_dev->config_info.apm)) {
 			clear_bit_inv(apid, shadow_crycb->apm);
+
 			continue;
 		}
 
@@ -502,6 +503,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			if (!test_bit_inv(apqi, (unsigned long *)
 					  matrix_dev->config_info.aqm)) {
 				clear_bit_inv(apqi, shadow_crycb->aqm);
+
 				continue;
 			}
 
@@ -515,11 +517,12 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 */
 			apqn = AP_MKQID(apid, apqi);
 			if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn)) {
-				if (filter_apids)
+				if (filter_apids) {
 					clear_bit_inv(apid, shadow_crycb->apm);
-				else
-					clear_bit_inv(apqi, shadow_crycb->aqm);
-				break;
+					break;
+				}
+
+				clear_bit_inv(apqi, shadow_crycb->aqm);
 			}
 		}
 
@@ -541,7 +544,7 @@ static bool vfio_ap_mdev_configure_crycb(struct ap_matrix_mdev *matrix_mdev)
 	int napm, naqm;
 	struct ap_matrix shadow_crycb;
 
-	vfio_ap_matrix_init(&matrix_dev->info, &shadow_crycb);
+	vfio_ap_matrix_init(&matrix_dev->config_info, &shadow_crycb);
 	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
 	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
 	/*
@@ -569,6 +572,8 @@ static bool vfio_ap_mdev_configure_crycb(struct ap_matrix_mdev *matrix_mdev)
 			 * matrix mdev after filtering the APQIs, then no APQNs
 			 * shall be assigned to the guest's CRYCB.
 			 */
+			naqm = vfio_ap_mdev_filter_matrix(matrix_mdev,
+							  &shadow_crycb, false);
 			if (naqm == 0) {
 				bitmap_clear(shadow_crycb.apm, 0, AP_DEVICES);
 				bitmap_clear(shadow_crycb.aqm, 0, AP_DOMAINS);
@@ -633,8 +638,8 @@ static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
 	bitmap_copy(aqm, matrix_mdev->matrix.aqm, AP_DOMAINS);
 
 	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
-		if (!test_bit_inv(apqi,
-				  (unsigned long *) matrix_dev->info.aqm))
+		if (!test_bit_inv(apqi, (unsigned long *)
+				  matrix_dev->config_info.aqm))
 			clear_bit_inv(apqi, aqm);
 
 		apqn = AP_MKQID(apid, apqi);
@@ -657,7 +662,7 @@ static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
 	unsigned long apqi, apqn;
 
 	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
-	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
+	    !test_bit_inv(apid, (unsigned long *)matrix_dev->config_info.apm))
 		return false;
 
 	if (bitmap_empty(matrix_mdev->shadow_crycb.aqm, AP_DOMAINS))
@@ -853,8 +858,8 @@ static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
 	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		if (!test_bit_inv(apid,
-				  (unsigned long *) matrix_dev->info.apm))
+		if (!test_bit_inv(apid, (unsigned long *)
+				  matrix_dev->config_info.apm))
 			clear_bit_inv(apqi, apm);
 
 		apqn = AP_MKQID(apid, apqi);
@@ -877,7 +882,7 @@ static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
 	unsigned long apid, apqn;
 
 	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
-	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
+	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->config_info.aqm))
 		return false;
 
 	if (bitmap_empty(matrix_mdev->shadow_crycb.apm, AP_DEVICES))
@@ -1673,6 +1678,16 @@ bool vfio_ap_mdev_unassign_apids(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apid, apm_unassign, AP_DEVICES) {
 		unassigned |= vfio_ap_mdev_unassign_guest_apid(matrix_mdev,
 							       apid);
+		/*
+		 * If the APID is not assigned to the matrix mdev's shadow
+		 * CRYCB, continue with the next APID.
+		 */
+		if (!test_bit_inv(apid, matrix_mdev->shadow_crycb.apm))
+			continue;
+
+		/* Unassign the APID from the matrix mdev's shadow CRYCB */
+		clear_bit_inv(apid, matrix_mdev->shadow_crycb.apm);
+		unassigned = true;
 	}
 
 	return unassigned;
@@ -1706,6 +1721,17 @@ bool vfio_ap_mdev_unassign_apqis(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apqi, aqm_unassign, AP_DOMAINS) {
 		unassigned |= vfio_ap_mdev_unassign_guest_apqi(matrix_mdev,
 							       apqi);
+
+		/*
+		 * If the APQI is not assigned to the matrix mdev's shadow
+		 * CRYCB, continue with the next APQI
+		 */
+		if (!test_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm))
+			continue;
+
+		/* Unassign the APQI from the matrix mdev's shadow CRYCB */
+		clear_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm);
+		unassigned = true;
 	}
 
 	return unassigned;
@@ -1767,3 +1793,87 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 	}
 	mutex_unlock(&matrix_dev->lock);
 }
+
+bool vfio_ap_mdev_assign_apids(struct ap_matrix_mdev *matrix_mdev,
+			       unsigned long *apm_assign)
+{
+	unsigned long apid;
+	bool assigned = false;
+
+	for_each_set_bit_inv(apid, apm_assign, AP_DEVICES)
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm))
+			if (vfio_ap_mdev_assign_guest_apid(matrix_mdev, apid))
+				assigned = true;
+
+	return assigned;
+}
+
+bool vfio_ap_mdev_assign_apqis(struct ap_matrix_mdev *matrix_mdev,
+			       unsigned long *aqm_assign)
+{
+	unsigned long apqi;
+	bool assigned = false;
+
+	for_each_set_bit_inv(apqi, aqm_assign, AP_DOMAINS)
+		if (test_bit_inv(apqi, matrix_mdev->matrix.aqm))
+			if (vfio_ap_mdev_assign_guest_apqi(matrix_mdev, apqi))
+				assigned = true;
+
+	return assigned;
+}
+
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	DECLARE_BITMAP(apm_assign, AP_DEVICES);
+	DECLARE_BITMAP(aqm_assign, AP_DOMAINS);
+	int ap_add, aq_add;
+	bool assign;
+	unsigned long *cur_apm, *cur_aqm, *prev_apm, *prev_aqm;
+
+	/*
+	 * If we are not in the middle of a host configuration change scan it is
+	 * likely that the vfio_ap driver was loaded mid-scan, so let's handle
+	 * this scenario by calling the vfio_ap_on_cfg_changed function which
+	 * gets called at the start of an AP bus scan when the host AP
+	 * configuration has changed.
+	 */
+	if (!(matrix_dev->flags & AP_MATRIX_CFG_CHG))
+		vfio_ap_on_cfg_changed(new_config_info, old_config_info);
+
+	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
+	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
+
+	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
+	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
+
+	ap_add = bitmap_andnot(apm_assign, cur_apm, prev_apm, AP_DEVICES);
+	aq_add = bitmap_andnot(aqm_assign, cur_aqm, prev_aqm, AP_DOMAINS);
+
+	mutex_lock(&matrix_dev->lock);
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+			continue;
+
+		assign = false;
+
+		if (ap_add)
+			if (bitmap_intersects(matrix_mdev->matrix.apm,
+					      apm_assign, AP_DEVICES))
+				assign |= vfio_ap_mdev_assign_apids(matrix_mdev,
+								    apm_assign);
+
+		if (aq_add)
+			if (bitmap_intersects(matrix_mdev->matrix.aqm,
+					      aqm_assign, AP_DOMAINS))
+				assign |= vfio_ap_mdev_assign_apqis(matrix_mdev,
+								    aqm_assign);
+
+		if (assign)
+			vfio_ap_mdev_commit_crycb(matrix_mdev);
+	}
+
+	matrix_dev->flags &= ~AP_MATRIX_CFG_CHG;
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 82abbf03781f..38974c37591a 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -114,5 +114,7 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

