Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C4B1A15CF
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgDGTUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:20:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727192AbgDGTUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J91CS120236;
        Tue, 7 Apr 2020 15:20:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 308ye2g8rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:36 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J9eou123167;
        Tue, 7 Apr 2020 15:20:36 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 308ye2g8rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:36 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKZDF027895;
        Tue, 7 Apr 2020 19:20:35 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 306hv6ae53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKYsv48890254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:34 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A5AD28059;
        Tue,  7 Apr 2020 19:20:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589DE28064;
        Tue,  7 Apr 2020 19:20:33 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:33 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 07/15] s390/vfio-ap: filter CRYCB bits for unavailable queue devices
Date:   Tue,  7 Apr 2020 15:20:07 -0400
Message-Id: <20200407192015.19887-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=3 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even though APQNs for queues that are not in the host's AP configuration
may be assigned to a matrix mdev, we do not want to set bits in the guest's
CRYCB for APQNs that do not reference AP queue devices bound to the vfio_ap
device driver. Ideally, it would be great if such APQNs could be filtered
out before setting the bits in the guest's CRYCB; however, the architecture
precludes filtering individual APQNs. Consequently, either the APID or APQI
must be filtered.

This patch introduces code to filter the APIDs or APQIs assigned to the
matrix mdev's AP configuration before assigning them to the guest's AP
configuration (i.e., CRYCB). We'll start by filtering the APIDs:

   If an APQN assigned to the matrix mdev's AP configuration does not
   reference a queue device bound to the vfio_ap device driver, the APID
   will be filtered out (i.e., not assigned to the guest's CRYCB).

If every APID assigned to the matrix mdev is filtered out, then we'll try
filtering the APQI's:

   If an APQN assigned to the matrix mdev's AP configuration does not
   reference a queue device bound to the vfio_ap device driver, the APQI
   will be filtered out (i.e., not assigned to the guest's CRYCB).

In any case, if after filtering either the APIDs or APQIs there are any
APQNs that can be assigned to the guest's CRYCB, they will be assigned and
the CRYCB will be hot plugged into the guest.

Example
=======

APQNs bound to vfio_ap device driver:
   04.0004
   04.0047
   04.0054

   05.0005
   05.0047
   05.0054

Assignments to matrix mdev:
   APIDs  APQIs  -> APQNs
   04     0004      04.0004
   05     0005      04.0005
          0047      04.0047
          0054      04.0054
                    05.0004
                    05.0005
                    05.0047
                    04.0054

Filter APIDs:
   APID 04 will be filtered because APQN 04.0005 is not bound.
   APID 05 will be filtered because APQN 05.0004 is not bound.
   APQNs remaining: None

Filter APQIs:
   APQI 04 will be filtered because APQN 05.0004 is not bound.
   APQI 05 will be filtered because APQN 04.0005 is not bound.
   APQNs remaining: 04.0047, 04.0054, 05.0047, 05.0054

APQNs 04.0047, 04.0054, 05.0047, 05.0054 will be assigned to the CRYCB and
hot plugged into the KVM guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 150 ++++++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index beb2e68a2b1c..25b7d978e3fd 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -296,14 +296,17 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static bool vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
+static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
 {
-	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
-		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
-					  matrix_mdev->shadow_crycb.apm,
-					  matrix_mdev->shadow_crycb.aqm,
-					  matrix_mdev->shadow_crycb.adm);
-	}
+	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
+}
+
+static void vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+				  matrix_mdev->shadow_crycb.apm,
+				  matrix_mdev->shadow_crycb.aqm,
+				  matrix_mdev->shadow_crycb.adm);
 }
 
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
@@ -550,6 +553,130 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
+				      struct ap_matrix *shadow_crycb,
+				      bool filter_apids)
+{
+	unsigned long apid, apqi, apqn;
+
+	memcpy(shadow_crycb, &matrix_mdev->matrix, sizeof(*shadow_crycb));
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		/*
+		 * If the APID is not assigned to the host AP configuration,
+		 * we can not assign it to the guest's AP configuration
+		 */
+		if (!test_bit_inv(apid,
+				  (unsigned long *)matrix_dev->info.apm)) {
+			clear_bit_inv(apid, shadow_crycb->apm);
+			continue;
+		}
+
+		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+				     AP_DOMAINS) {
+			/*
+			 * If the APQI is not assigned to the host AP
+			 * configuration, then it can not be assigned to the
+			 * guest's AP configuration
+			 */
+			if (!test_bit_inv(apqi, (unsigned long *)
+					  matrix_dev->info.aqm)) {
+				clear_bit_inv(apqi, shadow_crycb->aqm);
+				continue;
+			}
+
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so if we're
+			 * filtering APIDs, then filter the APID; otherwise,
+			 * filter the APQI.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+			if (!vfio_ap_get_queue(apqn)) {
+				if (filter_apids)
+					clear_bit_inv(apid, shadow_crycb->apm);
+				else
+					clear_bit_inv(apqi, shadow_crycb->aqm);
+				break;
+			}
+		}
+
+		/*
+		 * If we're filtering APQIs and all of them have been filtered,
+		 * there's no need to continue filtering.
+		 */
+		if (!filter_apids)
+			if (bitmap_empty(shadow_crycb->aqm, AP_DOMAINS))
+				break;
+	}
+
+	return bitmap_weight(shadow_crycb->apm, AP_DEVICES) *
+	       bitmap_weight(shadow_crycb->aqm, AP_DOMAINS);
+}
+
+static bool vfio_ap_mdev_configure_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	int napm, naqm;
+	struct ap_matrix shadow_crycb;
+
+	vfio_ap_matrix_init(&matrix_dev->info, &shadow_crycb);
+	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
+	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
+
+	/*
+	 * If there are no APIDs or no APQIs assigned to the matrix mdev,
+	 * then no APQNs shall be assigned to the guest CRYCB.
+	 */
+	if ((napm != 0) || (naqm != 0)) {
+		/*
+		 * Filter the APIDs assigned to the matrix mdev for APQNs that
+		 * do not reference an AP queue device bound to the driver.
+		 */
+		napm = vfio_ap_mdev_filter_matrix(matrix_mdev, &shadow_crycb,
+						  true);
+		/*
+		 * If there are no APQNs that can be assigned to the guest's
+		 * CRYCB after filtering, then try filtering the APQIs.
+		 */
+		if (napm == 0) {
+			naqm = vfio_ap_mdev_filter_matrix(matrix_mdev,
+							  &shadow_crycb, false);
+
+			/*
+			 * If there are no APQNs that can be assigned to the
+			 * matrix mdev after filtering the APQIs, then no APQNs
+			 * shall be assigned to the guest's CRYCB.
+			 */
+			if (naqm == 0) {
+				bitmap_clear(shadow_crycb.apm, 0, AP_DEVICES);
+				bitmap_clear(shadow_crycb.aqm, 0, AP_DOMAINS);
+			}
+		}
+	}
+
+	/*
+	 * If the guest's AP configuration has not changed, then return
+	 * indicating such.
+	 */
+	if (bitmap_equal(matrix_mdev->shadow_crycb.apm, shadow_crycb.apm,
+			 AP_DEVICES) &&
+	    bitmap_equal(matrix_mdev->shadow_crycb.aqm, shadow_crycb.aqm,
+			 AP_DOMAINS) &&
+	    bitmap_equal(matrix_mdev->shadow_crycb.adm, shadow_crycb.adm,
+			 AP_DOMAINS))
+		return false;
+
+	/*
+	 * Copy the changes to the guest's CRYCB, then return indicating that
+	 * the guest's AP configuration has changed.
+	 */
+	memcpy(&matrix_mdev->shadow_crycb, &shadow_crycb, sizeof(shadow_crycb));
+
+	return true;
+}
+
 /**
  * vfio_ap_mdev_qlinks_for_apid
  *
@@ -1203,9 +1330,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	if (ret)
 		return NOTIFY_DONE;
 
-	memcpy(&matrix_mdev->shadow_crycb, &matrix_mdev->matrix,
-	       sizeof(matrix_mdev->shadow_crycb));
-	vfio_ap_mdev_commit_crycb(matrix_mdev);
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return NOTIFY_DONE;
+
+	if (vfio_ap_mdev_configure_crycb(matrix_mdev))
+		vfio_ap_mdev_commit_crycb(matrix_mdev);
 
 	return NOTIFY_OK;
 }
@@ -1315,6 +1444,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	if (matrix_mdev->kvm) {
 		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		vfio_ap_matrix_clear(&matrix_mdev->shadow_crycb);
 		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
 		vfio_ap_mdev_reset_queues(mdev);
 		kvm_put_kvm(matrix_mdev->kvm);
-- 
2.21.1

