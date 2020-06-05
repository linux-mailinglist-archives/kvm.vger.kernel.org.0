Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E994B1F0229
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgFEVlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:41:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728887AbgFEVkV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:21 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LWcoV079379;
        Fri, 5 Jun 2020 17:40:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dtmg75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LWpSB080178;
        Fri, 5 Jun 2020 17:40:20 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dtmg6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LaUpd001322;
        Fri, 5 Jun 2020 21:40:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 31f5mey6mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:18 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeHfx29163880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:17 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 241EFAC064;
        Fri,  5 Jun 2020 21:40:17 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAA8BAC062;
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
Subject: [PATCH v8 15/16] s390/vfio-ap: handle AP bus scan completed notification
Date:   Fri,  5 Jun 2020 17:40:03 -0400
Message-Id: <20200605214004.14270-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 bulkscore=0 priorityscore=1501 suspectscore=3 malwarescore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 impostorscore=0
 phishscore=0 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050159
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
 drivers/s390/crypto/vfio_ap_ops.c     | 110 +++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index f0f83c1b8983..badc99ee863d 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -178,6 +178,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
+	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e3c4b2d73072..cfe93ff9cc8c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -616,14 +616,13 @@ static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 		 * CRYCB after filtering, then try filtering the APQIs.
 		 */
 		if (napm == 0) {
-			naqm = vfio_ap_mdev_filter_matrix(matrix_mdev,
-							  &shadow_apcb, false);
-
 			/*
 			 * If there are no APQNs that can be assigned to the
 			 * matrix mdev after filtering the APQIs, then no APQNs
 			 * shall be assigned to the guest's CRYCB.
 			 */
+			naqm = vfio_ap_mdev_filter_matrix(matrix_mdev,
+							  &shadow_apcb, false);
 			if (naqm == 0) {
 				bitmap_clear(shadow_apcb.apm, 0, AP_DEVICES);
 				bitmap_clear(shadow_apcb.aqm, 0, AP_DOMAINS);
@@ -1759,6 +1758,16 @@ bool vfio_ap_mdev_unassign_apids(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apid, apm_unassign, AP_DEVICES) {
 		unassigned |= vfio_ap_mdev_unassign_guest_apid(matrix_mdev,
 							       apid);
+		/*
+		 * If the APID is not assigned to the matrix mdev's shadow
+		 * CRYCB, continue with the next APID.
+		 */
+		if (!test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+			continue;
+
+		/* Unassign the APID from the matrix mdev's shadow CRYCB */
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		unassigned = true;
 	}
 
 	return unassigned;
@@ -1792,6 +1801,17 @@ bool vfio_ap_mdev_unassign_apqis(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apqi, aqm_unassign, AP_DOMAINS) {
 		unassigned |= vfio_ap_mdev_unassign_guest_apqi(matrix_mdev,
 							       apqi);
+
+		/*
+		 * If the APQI is not assigned to the matrix mdev's shadow
+		 * CRYCB, continue with the next APQI
+		 */
+		if (!test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+			continue;
+
+		/* Unassign the APQI from the matrix mdev's shadow CRYCB */
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		unassigned = true;
 	}
 
 	return unassigned;
@@ -1853,3 +1873,87 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
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
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+
+	matrix_dev->flags &= ~AP_MATRIX_CFG_CHG;
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index fc8629e28ad3..da1754fd4f66 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -113,5 +113,7 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
 bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

