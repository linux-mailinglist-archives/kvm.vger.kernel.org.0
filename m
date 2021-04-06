Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E38A3557F1
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345793AbhDFPcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:32:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1345720AbhDFPcB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:32:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136FG1ke027709;
        Tue, 6 Apr 2021 11:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tfjdiIh3KTrPIPuS8MbmOsmg2ZLYgeWdJWZ7/1y3boU=;
 b=esoDekUYUl3mdLTwaON3a+y1yq15ZWoU9s4xGg+FR9jMJxloE3L2ozndfTfvSRIKA9Ek
 5oGoNAT7+JWj1Bcu2kF2iD6+V6o/BYla47rpfQQMZIb2hey1IV+d7ZW+h+G5+Y8qsBDG
 i8uN2T128DkSp3X+CXZCpy+LkMFU2tt5nvj8DfD7oxURcMG1fCpG9IFwZjWxs3Hn74DY
 DbQEaBDhC7qOUDCNMCwZJjpRc7WEmF2s9GUkkou4ZmmBfpB9BzHoYs74IgJujsixV4eY
 Tvax709AohQTUdwsgXW8ZGeS9HehJXOrKFpgRHkaFcsAmRXOiErhWS2z8d86GIPZErnY fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q605fn9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:51 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136FGKdl030013;
        Tue, 6 Apr 2021 11:31:51 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q605fn9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:50 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FNfNo013593;
        Tue, 6 Apr 2021 15:31:50 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 37q3294t5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVka110682792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B055CBE051;
        Tue,  6 Apr 2021 15:31:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25757BE04F;
        Tue,  6 Apr 2021 15:31:45 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:45 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 08/13] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Tue,  6 Apr 2021 11:31:17 -0400
Message-Id: <20210406153122.22874-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gnrVcy0qguGcdM7b281sKH6NUaj0Ophh
X-Proofpoint-GUID: 7XU33urVcDrgQ8TtQpLSHmupyWmjX6tk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_04:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060104
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
index 69b58b0fac8f..8e7f24f0cd49 100644
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
 
@@ -672,7 +687,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -745,7 +760,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -826,7 +841,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -898,7 +913,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -923,6 +938,16 @@ static ssize_t unassign_domain_store(struct device *dev,
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
@@ -954,7 +979,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -974,7 +999,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -982,6 +1007,15 @@ static ssize_t assign_control_domain_store(struct device *dev,
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
@@ -1014,7 +1048,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -1028,7 +1062,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_unplug_cdom(matrix_mdev, domid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1525,8 +1559,18 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
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
 
@@ -1542,6 +1586,16 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
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

