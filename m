Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0381A15CC
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgDGTVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:21:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727387AbgDGTUm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J7gFD062995;
        Tue, 7 Apr 2020 15:20:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 308eu8m7by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:40 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J8Smv064685;
        Tue, 7 Apr 2020 15:20:39 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 308eu8m7bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:39 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKF9r027670;
        Tue, 7 Apr 2020 19:20:39 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 306hv6ae5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:39 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKb0U52953408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:37 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E4E128060;
        Tue,  7 Apr 2020 19:20:37 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 912182805A;
        Tue,  7 Apr 2020 19:20:36 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:36 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 11/15] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Tue,  7 Apr 2020 15:20:11 -0400
Message-Id: <20200407192015.19887-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 suspectscore=3 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's hot plug/unplug adapters, domains and control domains assigned to or
unassigned from an AP matrix mdev device while it is in use by a guest per
the following:

* When the APID of an adapter is assigned to a matrix mdev in use by a KVM
  guest, the adapter will be hot plugged into the KVM guest as long as each
  APQN derived from the Cartesian product of the APID being assigned and
  the APQIs already assigned to the guest's CRYCB references a queue device
  bound to the vfio_ap device driver.

* When the APID of an adapter is unassigned from a matrix mdev in use by a
  KVM guest, the adapter will be hot unplugged from the KVM guest.

* When the APQI of a domain is assigned to a matrix mdev in use by a KVM
  guest, the domain will be hot plugged into the KVM guest as long as each
  APQN derived from the Cartesian product of the APQI being assigned and
  the APIDs already assigned to the guest's CRYCB references a queue device
  bound to the vfio_ap device driver.

* When the APQI of a domain is unassigned from a matrix mdev in use by a
  KVM guest, the domain will be hot unplugged from the KVM guest

* When the domain number of a control domain is assigned to a matrix mdev
  in use by a KVM guest, the control domain will be hot plugged into the
  KVM guest.

* When the domain number of a control domain is unassigned from a matrix
  mdev in use by a KVM guest, the control domain will be hot unplugged
  from the KVM guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 198 ++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4b16d45b702b..88a4aef5193f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -623,6 +623,56 @@ static void vfio_ap_mdev_qlinks_for_apid(struct ap_matrix_mdev *matrix_mdev,
 	}
 }
 
+static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apid)
+{
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
+	unsigned long apqi, apqn;
+
+	bitmap_copy(aqm, matrix_mdev->matrix.aqm, AP_DOMAINS);
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
+		if (!test_bit_inv(apqi,
+				  (unsigned long *) matrix_dev->info.aqm))
+			clear_bit_inv(apqi, aqm);
+
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			clear_bit_inv(apqi, aqm);
+	}
+
+	if (bitmap_empty(aqm, AP_DOMAINS))
+		return false;
+
+	set_bit_inv(apid, matrix_mdev->shadow_crycb.apm);
+	bitmap_copy(matrix_mdev->shadow_crycb.aqm, aqm, AP_DOMAINS);
+
+	return true;
+}
+
+static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apid)
+{
+	unsigned long apqi, apqn;
+
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
+	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
+		return false;
+
+	if (bitmap_empty(matrix_mdev->shadow_crycb.aqm, AP_DOMAINS))
+		return vfio_ap_mdev_assign_apqis_4_apid(matrix_mdev, apid);
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm, AP_DOMAINS) {
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			return false;
+	}
+
+	set_bit_inv(apid, matrix_mdev->shadow_crycb.apm);
+
+	return true;
+}
+
 /**
  * assign_adapter_store
  *
@@ -684,12 +734,44 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_qlinks_for_apid(matrix_mdev, apid);
+
+	if (vfio_ap_mdev_assign_guest_apid(matrix_mdev, apid))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
+
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apid, matrix_mdev->shadow_crycb.apm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_crycb.apm);
+
+			/*
+			 * If there are no APIDs assigned to the guest, then
+			 * the guest will not have access to any queues, so
+			 * let's also go ahead and unassign the APQIs. Keeping
+			 * them around may yield unpredictable results during
+			 * a probe that is not related to a host AP
+			 * configuration change (i.e., an AP adapter is
+			 * configured online).
+			 */
+			if (bitmap_empty(matrix_mdev->shadow_crycb.apm,
+					 AP_DEVICES))
+				bitmap_clear(matrix_mdev->shadow_crycb.aqm, 0,
+					     AP_DOMAINS);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * unassign_adapter_store
  *
@@ -726,6 +808,8 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_qlinks_for_apid(NULL, apid);
+	if (vfio_ap_mdev_unassign_guest_apid(matrix_mdev, apid))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -759,6 +843,56 @@ static void vfio_ap_mdev_qlinks_for_apqi(struct ap_matrix_mdev *matrix_mdev,
 	}
 }
 
+static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqi)
+{
+	DECLARE_BITMAP(apm, AP_DEVICES);
+	unsigned long apid, apqn;
+
+	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		if (!test_bit_inv(apid,
+				  (unsigned long *) matrix_dev->info.apm))
+			clear_bit_inv(apqi, apm);
+
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			clear_bit_inv(apid, apm);
+	}
+
+	if (bitmap_empty(apm, AP_DEVICES))
+		return false;
+
+	set_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm);
+	bitmap_copy(matrix_mdev->shadow_crycb.apm, apm, AP_DEVICES);
+
+	return true;
+}
+
+static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apqi)
+{
+	unsigned long apid, apqn;
+
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
+	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
+		return false;
+
+	if (bitmap_empty(matrix_mdev->shadow_crycb.apm, AP_DEVICES))
+		return vfio_ap_mdev_assign_apids_4_apqi(matrix_mdev, apqi);
+
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb.apm, AP_DEVICES) {
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			return false;
+	}
+
+	set_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm);
+
+	return true;
+}
+
 /**
  * assign_domain_store
  *
@@ -820,12 +954,41 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_qlinks_for_apqi(matrix_mdev, apqi);
+	if (vfio_ap_mdev_assign_guest_apqi(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static bool vfio_ap_mdev_unassign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqi)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm)) {
+			clear_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm);
+
+			/*
+			 * If there are no APQIs assigned to the guest, then
+			 * the guest will not have access to any queues, so
+			 * let's also go ahead and unassign the APIDs. Keeping
+			 * them around may yield unpredictable results during
+			 * a probe that is not related to a host AP
+			 * configuration change (i.e., an AP adapter is
+			 * configured online).
+			 */
+			if (bitmap_empty(matrix_mdev->shadow_crycb.aqm,
+					 AP_DOMAINS))
+				bitmap_clear(matrix_mdev->shadow_crycb.apm, 0,
+					     AP_DEVICES);
+
+			return true;
+		}
+	}
+
+	return false;
+}
 
 /**
  * unassign_domain_store
@@ -863,12 +1026,28 @@ static ssize_t unassign_domain_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_qlinks_for_apqi(NULL, apqi);
+	if (vfio_ap_mdev_unassign_guest_apqi(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static bool vfio_ap_mdev_assign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (!test_bit_inv(domid, matrix_mdev->shadow_crycb.adm)) {
+			set_bit_inv(domid, matrix_mdev->shadow_crycb.adm);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * assign_control_domain_store
  *
@@ -903,12 +1082,29 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_assign_guest_cdom(matrix_mdev, id))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static bool
+vfio_ap_mdev_unassign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+				 unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(domid, matrix_mdev->shadow_crycb.adm)) {
+			clear_bit_inv(domid, matrix_mdev->shadow_crycb.adm);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * unassign_control_domain_store
  *
@@ -943,6 +1139,8 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_unassign_guest_cdom(matrix_mdev, domid))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
-- 
2.21.1

