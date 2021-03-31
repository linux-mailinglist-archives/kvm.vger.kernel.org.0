Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3484350351
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhCaPYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 11:24:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63518 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236338AbhCaPXd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 11:23:33 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VF3X7Q058773;
        Wed, 31 Mar 2021 11:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=69iQNvi8bHkb+Ev+HEc+gYRwoxzbPFQfTNIXz12r92E=;
 b=Po3h1wVyY9vYr5LaPu3jJDVzOZVifbETL5Rkb7ZyR239riU7rPsjDJ2RqzMnA9siXnVS
 1zQvQ+9WC4y0bocSy3tZloPG1jiS98AveLdtpY4dKaDj+t9TOscmYKjNPPZm31YaxJdu
 0oz/mooowXVwOR0YqL62UQCEMHeTx8DgI8QR2TAMPagZMB8GL7+RQCjSnFAcvXlS9cTE
 zap+Tg0LDk7OtpuUiP3GIUNQ2NQo6XVtbLLcrO4hwR/sabuHdrMbzbdBephJvL+UwMAW
 AJ3UYPjdNiMK+oGWgR5aUTf+fiCGFP6MTjJ3pApIPA3gObKE4dp1oPobL0fxmgRv9BUK dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mpdtjttx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:31 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VF3qXC059909;
        Wed, 31 Mar 2021 11:23:31 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mpdtjttp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:31 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VF2AWW012035;
        Wed, 31 Mar 2021 15:23:30 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 37maawfd8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 15:23:30 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VFNQkm11141498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 15:23:26 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C126E052;
        Wed, 31 Mar 2021 15:23:26 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8EE66E04E;
        Wed, 31 Mar 2021 15:23:24 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.146.149])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 31 Mar 2021 15:23:24 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v14 08/13] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Wed, 31 Mar 2021 11:22:51 -0400
Message-Id: <20210331152256.28129-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210331152256.28129-1-akrowiak@linux.ibm.com>
References: <20210331152256.28129-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e_yi7MHoYDQa-W89n6yAkgNAEZMSpmVC
X-Proofpoint-ORIG-GUID: 5IAAqmmaQT-9m7JysDkYhpDANjr41TcC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_06:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's allow adapters, domains and control domains to be hot plugged into
and hot unplugged from a KVM guest using a matrix mdev when:

* The adapter, domain or control domain is assigned to or unassigned from
  the matrix mdev

* A queue device with an APQN assigned to the matrix mdev is bound to or
  unbound from the vfio_ap device driver.

Whenever an assignment or unassignment of an adapter, domain or control
domain is performed as well as when a bind or unbind of a queue device
is executed, the AP control block (APCB) that supplies the AP configuration
to the guest is first refreshed.

After refreshing the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to provide access to dynamically provide
access to the adapters, domains and control domains provided via the
newly refreshed APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 72 +++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 1f2a3049b283..2578dfe68cda 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -311,6 +311,20 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
+}
+
+static void vfio_ap_mdev_commit_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev))
+		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+					  matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
+}
+
 /*
  * vfio_ap_mdev_filter_apcb
  *
@@ -378,6 +392,7 @@ static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
 		   sizeof(struct ap_matrix)) != 0) {
 		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
 		       sizeof(struct ap_matrix));
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
 	}
 }
 
@@ -655,7 +670,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -728,7 +743,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -809,7 +824,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -881,7 +896,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -906,6 +921,16 @@ static ssize_t unassign_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long domid)
+{
+	if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm) &&
+	    test_bit_inv(domid, (unsigned long *)matrix_dev->info.adm)) {
+		set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
+	}
+}
+
 /**
  * assign_control_domain_store
  *
@@ -937,7 +962,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -957,7 +982,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -965,6 +990,15 @@ static ssize_t assign_control_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static void vfio_ap_mdev_hot_unplug_cdom(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long domid)
+{
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
+	}
+}
+
 /**
  * unassign_control_domain_store
  *
@@ -997,7 +1031,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -1011,7 +1045,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_unplug_cdom(matrix_mdev, domid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1508,8 +1542,18 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
+		/*
+		 * If the KVM pointer is in the process of being set, wait until the
+		 * process has completed.
+		 */
+		wait_event_cmd(q->matrix_mdev->wait_for_kvm,
+			       !q->matrix_mdev->kvm_busy,
+			       mutex_unlock(&matrix_dev->lock),
+			       mutex_lock(&matrix_dev->lock));
+
 		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
+	}
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1525,6 +1569,16 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
 	if (q->matrix_mdev) {
 		vfio_ap_mdev_unlink_queue_fr_mdev(q);
+
+		/*
+		 * If the KVM pointer is in the process of being set, wait until the
+		 * process has completed.
+		 */
+		wait_event_cmd(q->matrix_mdev->wait_for_kvm,
+			       !q->matrix_mdev->kvm_busy,
+			       mutex_unlock(&matrix_dev->lock),
+			       mutex_lock(&matrix_dev->lock));
+
 		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
 	}
 
-- 
2.21.3

