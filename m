Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858452262F1
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgGTPFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:05:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2030 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728326AbgGTPEK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 11:04:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KF2w1K067627;
        Mon, 20 Jul 2020 11:04:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5jyymc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:04 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KF3FP6069431;
        Mon, 20 Jul 2020 11:04:03 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5jyymbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:03 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEiKoo024519;
        Mon, 20 Jul 2020 15:04:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 32brq8xhpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 15:04:03 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KF3x8939256426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:03:59 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDFF86E052;
        Mon, 20 Jul 2020 15:03:59 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 996FC6E04E;
        Mon, 20 Jul 2020 15:03:58 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.188.6])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 15:03:58 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v9 06/15] s390/vfio-ap: introduce shadow APCB
Date:   Mon, 20 Jul 2020 11:03:35 -0400
Message-Id: <20200720150344.24488-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200720150344.24488-1-akrowiak@linux.ibm.com>
References: <20200720150344.24488-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=3 priorityscore=1501 mlxscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The APCB is a field within the CRYCB that provides the AP configuration
to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
maintain it for the lifespan of the guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index fc1aa6f947eb..efb229033f9e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -305,14 +305,35 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void vfio_ap_matrix_clear_masks(struct ap_matrix *matrix)
+{
+	bitmap_clear(matrix->apm, 0, AP_DEVICES);
+	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
+	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
+}
+
 static void vfio_ap_matrix_init(struct ap_config_info *info,
 				struct ap_matrix *matrix)
 {
+	vfio_ap_matrix_clear_masks(matrix);
 	matrix->apm_max = info->apxa ? info->Na : 63;
 	matrix->aqm_max = info->apxa ? info->Nd : 15;
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
+}
+
+static void vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+				  matrix_mdev->shadow_apcb.apm,
+				  matrix_mdev->shadow_apcb.aqm,
+				  matrix_mdev->shadow_apcb.adm);
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -1202,13 +1223,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	if (ret)
 		return NOTIFY_DONE;
 
-	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd)
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
 		return NOTIFY_DONE;
 
-	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
-				  matrix_mdev->matrix.aqm,
-				  matrix_mdev->matrix.adm);
+	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
+	       sizeof(matrix_mdev->shadow_apcb));
+	vfio_ap_mdev_commit_crycb(matrix_mdev);
 
 	return NOTIFY_OK;
 }
@@ -1323,6 +1343,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 		kvm_put_kvm(matrix_mdev->kvm);
 		matrix_mdev->kvm = NULL;
 	}
+
+	vfio_ap_matrix_clear_masks(&matrix_mdev->shadow_apcb);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 0c796ef11426..055bce6d45db 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -75,6 +75,7 @@ struct ap_matrix {
  * @list:	allows the ap_matrix_mdev struct to be added to a list
  * @matrix:	the adapters, usage domains and control domains assigned to the
  *		mediated matrix device.
+ * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
  * @group_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @kvm:	the struct holding guest's state
@@ -82,6 +83,7 @@ struct ap_matrix {
 struct ap_matrix_mdev {
 	struct list_head node;
 	struct ap_matrix matrix;
+	struct ap_matrix shadow_apcb;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
-- 
2.21.1

