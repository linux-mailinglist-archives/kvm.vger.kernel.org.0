Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F411724E167
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgHUT45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 15:56:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726799AbgHUT4t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 15:56:49 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LJVstG184128;
        Fri, 21 Aug 2020 15:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7CalM92CIWFdGJt7DiCsFWIv1m0UY/uexaDEyJqq9oc=;
 b=SVg2PvQjkKyHoVdslKQqUrigEt9mYLN3YXeDk8P4kAt8FvRQuDxVpOt9sf2PPbZwaKou
 Sk2snGom0HIxwjzxOzHDxAtQBPbPerE+cl8Cm6VZndOGJnmNOkX7l9RObNeLlCXV0JjM
 pL11b0UrRDYAqTw8auUXVAD+g39apjp27ygc57TYJLvoaazJNryHI9mnmLNId/Td4wl6
 8IZDbDgKerTk8ICBoq/8mQ6SiDHGkJgkm0Fh9Qbd6Egn5Ddw2K0kjWp73mfP5aV7QLuS
 99+xyA2K7qJxV/Z2yfp623uFqnHFzz06ZqeMzTmG++ylSoJ7uAcugKYWRG5uQBgEdWEs ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 332jf9kn0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:46 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LJWVQh185744;
        Fri, 21 Aug 2020 15:56:46 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 332jf9kn03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:46 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LJscFM010511;
        Fri, 21 Aug 2020 19:56:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3304themh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 19:56:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LJugIx29491502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 19:56:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 863EE7805C;
        Fri, 21 Aug 2020 19:56:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C3EE78069;
        Fri, 21 Aug 2020 19:56:41 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.191.76])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 19:56:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v10 11/16] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Fri, 21 Aug 2020 15:56:11 -0400
Message-Id: <20200821195616.13554-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200821195616.13554-1-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0
 suspectscore=3 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210178
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
 drivers/s390/crypto/vfio_ap_ops.c | 196 ++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cf3321eb239b..2b01a8eb6ee7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -731,6 +731,56 @@ static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
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
+	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+	bitmap_copy(matrix_mdev->shadow_apcb.aqm, aqm, AP_DOMAINS);
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
+	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
+		return vfio_ap_mdev_assign_apqis_4_apid(matrix_mdev, apid);
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS) {
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			return false;
+	}
+
+	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
+	return true;
+}
+
 /**
  * assign_adapter_store
  *
@@ -792,12 +842,42 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
+	if (vfio_ap_mdev_assign_guest_apid(matrix_mdev, apid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
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
+			if (bitmap_empty(matrix_mdev->shadow_apcb.apm,
+					 AP_DEVICES))
+				bitmap_clear(matrix_mdev->shadow_apcb.aqm, 0,
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
@@ -834,12 +914,64 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
+	if (vfio_ap_mdev_unassign_guest_apid(matrix_mdev, apid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
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
+	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+	bitmap_copy(matrix_mdev->shadow_apcb.apm, apm, AP_DEVICES);
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
+	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
+		return vfio_ap_mdev_assign_apids_4_apqi(matrix_mdev, apqi);
+
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
+		apqn = AP_MKQID(apid, apqi);
+		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
+			return false;
+	}
+
+	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
+	return true;
+}
+
 /**
  * assign_domain_store
  *
@@ -901,12 +1033,41 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
+	if (vfio_ap_mdev_assign_guest_apqi(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static bool vfio_ap_mdev_unassign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqi)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
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
+			if (bitmap_empty(matrix_mdev->shadow_apcb.aqm,
+					 AP_DOMAINS))
+				bitmap_clear(matrix_mdev->shadow_apcb.apm, 0,
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
@@ -944,12 +1105,28 @@ static ssize_t unassign_domain_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
+	if (vfio_ap_mdev_unassign_guest_apqi(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static bool vfio_ap_mdev_assign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+			set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
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
@@ -984,12 +1161,29 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_assign_guest_cdom(matrix_mdev, id))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static bool
+vfio_ap_mdev_unassign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+				 unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+			clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
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
@@ -1024,6 +1218,8 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_unassign_guest_cdom(matrix_mdev, domid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
-- 
2.21.1

