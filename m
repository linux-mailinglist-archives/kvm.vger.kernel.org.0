Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C66B2262CC
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgGTPET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:04:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728894AbgGTPER (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 11:04:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KF3HFi165406;
        Mon, 20 Jul 2020 11:04:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dcyq9byv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:14 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KF42Vm171638;
        Mon, 20 Jul 2020 11:04:14 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dcyq9by5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:14 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEjYUe007097;
        Mon, 20 Jul 2020 15:04:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 32brq8j0k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 15:04:13 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KF48gQ60817798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:04:08 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67B3B6E04C;
        Mon, 20 Jul 2020 15:04:10 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41D326E058;
        Mon, 20 Jul 2020 15:04:09 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.188.6])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 15:04:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v9 14/15] s390/vfio-ap: handle AP bus scan completed notification
Date:   Mon, 20 Jul 2020 11:03:43 -0400
Message-Id: <20200720150344.24488-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200720150344.24488-1-akrowiak@linux.ibm.com>
References: <20200720150344.24488-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200102
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
index ea0a7603e886..21bfae928be5 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -180,6 +180,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
+	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e002d556abab..e6480f31a42b 100644
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
@@ -1758,6 +1757,16 @@ static bool vfio_ap_mdev_unassign_apids(struct ap_matrix_mdev *matrix_mdev,
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
@@ -1791,6 +1800,17 @@ static bool vfio_ap_mdev_unassign_apqis(struct ap_matrix_mdev *matrix_mdev,
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
@@ -1852,3 +1872,87 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
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

