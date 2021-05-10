Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9137946B
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhEJQqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:46:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231962AbhEJQpu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:50 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGWvZH135067;
        Mon, 10 May 2021 12:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JMl2cbupobo9qe7CMbq1mCjsfsX+YQZ2qjXdJx4kagM=;
 b=q/TSeM4yweB9oTughPjEWZdM5iff5c3vJpI90MjU8vxmWT5ALbvIUR7t+2BZyR7b68B1
 yeiD+XmdpSe40p3DZxdTvfwzSqTiu00lpeuaq7X/+8VRfYM2kHLYY5wIoUx8WyQNN4Eh
 rYju1OaIzZ2m68t9qgxRMCkt+ZeTgEigC4Rp6RgV7Ke1S3SC/h2Kw8b11TGIiXj+70yi
 rLzuBeTQaLyz14yPxY9MtgkNCYBH1BXdRPykAKjNgc1WK9samM6KG49lMX/1BGaSG9rb
 Y6Atv+A3oUpmSvj0hgoxBi8ZskfS/AmmBpk1n/hWHO/ZUuSvAnX60nGpslg0KRbf+QGo pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7qu9n5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:43 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGXCvX135812;
        Mon, 10 May 2021 12:44:42 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7qu9n46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:42 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGgHB3026742;
        Mon, 10 May 2021 16:44:39 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 38dj98yp64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGicqt12125164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E174AE05F;
        Mon, 10 May 2021 16:44:38 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31820AE060;
        Mon, 10 May 2021 16:44:37 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:36 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 06/14] s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
Date:   Mon, 10 May 2021 12:44:15 -0400
Message-Id: <20210510164423.346858-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LFMbhEQA5eKjQdn0WEuCLW23h33_U0lL
X-Proofpoint-ORIG-GUID: E9c3cAMvobLet02RHr9g-Sc8kvgn1dnY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
that do not reference an AP queue device bound to the vfio_ap device
driver. The mdev's APQNs will be filtered according to the following rules:

* The APID of each adapter and the APQI of each domain that is not in the
  host's AP configuration is filtered out.

* The APID of each adapter comprising an APQN that does not reference a
  queue device bound to the vfio_ap device driver is filtered. The APQNs
  are derived from the Cartesian product of the APID of each adapter and
  APQI of each domain assigned to the mdev.

The filtering will take place:

* Whenever an adapter, domain or control domains is assigned or
  unassigned.

* When a queue device is bound to or unbound from the vfio_ap device
  driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 83 +++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8f705b0e12e4..746998126276 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -336,6 +336,75 @@ static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
 		wake_up_all(&matrix_mdev->wait_for_kvm);
 	}
 }
+/*
+ * vfio_ap_mdev_filter_apcb
+ *
+ * @matrix_mdev: the mdev whose AP configuration is to be filtered.
+ * @shadow_apcb: the APCB to use to store the guest's AP configuration after
+ *		 filtering takes place.
+ */
+static void vfio_ap_mdev_filter_apcb(struct ap_matrix_mdev *matrix_mdev,
+				     struct ap_matrix *shadow_apcb)
+{
+	int ret;
+	unsigned long apid, apqi, apqn;
+
+	ret = ap_qci(&matrix_dev->info);
+	if (ret)
+		return;
+
+	/*
+	 * Copy the adapters, domains and control domains to the shadow_apcb
+	 * from the matrix mdev, but only those that are assigned to the host's
+	 * AP configuration.
+	 */
+	bitmap_and(shadow_apcb->apm, matrix_mdev->matrix.apm,
+		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
+	bitmap_and(shadow_apcb->aqm, matrix_mdev->matrix.aqm,
+		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
+	bitmap_and(shadow_apcb->adm, matrix_mdev->matrix.adm,
+		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	for_each_set_bit_inv(apid, shadow_apcb->apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, shadow_apcb->aqm, AP_DOMAINS) {
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so if we're
+			 * filtering APIDs, then filter the APID; otherwise,
+			 * filter the APQI.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+				clear_bit_inv(apid, shadow_apcb->apm);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * vfio_ap_mdev_refresh_apcb
+ *
+ * Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
+ * that do not reference an AP queue device bound to the vfio_ap device driver.
+ *
+ * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
+ */
+static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	struct ap_matrix shadow_apcb;
+
+	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
+	vfio_ap_mdev_filter_apcb(matrix_mdev, &shadow_apcb);
+
+	if (memcmp(&shadow_apcb, &matrix_mdev->shadow_apcb,
+		   sizeof(struct ap_matrix)) != 0) {
+		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
+		       sizeof(struct ap_matrix));
+	}
+}
 
 static int vfio_ap_mdev_create(struct mdev_device *mdev)
 {
@@ -722,6 +791,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -796,6 +866,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -904,6 +975,7 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -978,6 +1050,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 
 done:
@@ -1037,6 +1110,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1090,6 +1164,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1223,8 +1298,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		}
 
 		kvm_get_kvm(kvm);
-		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-		       sizeof(struct ap_matrix));
 		matrix_mdev->kvm_busy = true;
 		mutex_unlock(&matrix_dev->lock);
 		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
@@ -1588,6 +1661,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev)
+		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1601,8 +1676,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
 
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
 		vfio_ap_mdev_unlink_queue_fr_mdev(q);
+		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
+	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
-- 
2.30.2

