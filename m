Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA4743660B
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhJUP01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231984AbhJUP0X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBMEu003778;
        Thu, 21 Oct 2021 11:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h78lrCCArAduV+fJtApwLdWepDVufhFooh00AmPjLc8=;
 b=FwlHsv4wUNYcpQ+oPz8BiM1vlRSOgLjouf4LEkPih91Q1myP/T5RPUF/BgieqfmUhvUu
 FpoYOtwPxe3RdcDD3ckeu17bhXS1cK42ppJcJkRXVdAG64xMfY5eT36S8OI6RT1l2m4+
 b7lovAgHNRsFSBArJY6Di4eE+DVtpG1hGxhs0p2D9zFdlXAVdKTOtWGIMkecn1zhm95z
 EyvB3j5Av3/JqiM5hnOpmW94rZ5D34ENWywEUOHIPwa8j0Rw3RwS6x58ROn3ioVHqWWj
 bVW614ArgDzUxNGVeKdV95Bpfx2Go4h6VG+r4Y6oDEszHKXC0NGWJ1VPJZJ4j+jHTR7M sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu8kkkseh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:05 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LEZKD8005174;
        Thu, 21 Oct 2021 11:24:04 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu8kkkse3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:04 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF427G018888;
        Thu, 21 Oct 2021 15:24:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3bqpccfsg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:03 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFO2TS32899810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50C5CBE05D;
        Thu, 21 Oct 2021 15:24:02 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16CEBBE061;
        Thu, 21 Oct 2021 15:24:00 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:23:59 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 06/15] s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
Date:   Thu, 21 Oct 2021 11:23:23 -0400
Message-Id: <20211021152332.70455-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c-uzxaaaWEvVQox1FYkuY40dNMRKsmsd
X-Proofpoint-GUID: qNHpspt_Y6wgzdzeo2cdYjAjv8pQC3uV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
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

The control domains that are not assigned to the host's AP configuration
will also be filtered before assigning them to the guest's APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 66 ++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4305177029bf..46c179363aca 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -314,6 +314,62 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+{
+	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
+		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+}
+
+/*
+ * vfio_ap_mdev_filter_matrix - copy the mdev's AP configuration to the KVM
+ *				guest's APCB then filter the APIDs that do not
+ *				comprise at least one APQN that references a
+ *				queue device bound to the vfio_ap device driver.
+ *
+ * @matrix_mdev: the mdev whose AP configuration is to be filtered.
+ */
+static void vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
+{
+	int ret;
+	unsigned long apid, apqi, apqn;
+
+	ret = ap_qci(&matrix_dev->info);
+	if (ret)
+		return;
+
+	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
+
+	/*
+	 * Copy the adapters, domains and control domains to the shadow_apcb
+	 * from the matrix mdev, but only those that are assigned to the host's
+	 * AP configuration.
+	 */
+	bitmap_and(matrix_mdev->shadow_apcb.apm, matrix_mdev->matrix.apm,
+		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
+	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
+		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
+
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
+				     AP_DOMAINS) {
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
+				clear_bit_inv(apid,
+					      matrix_mdev->shadow_apcb.apm);
+				break;
+			}
+		}
+	}
+}
+
 static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -703,6 +759,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -771,6 +828,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -874,6 +932,7 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -942,6 +1001,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
 
 done:
@@ -995,6 +1055,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1042,6 +1103,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1179,8 +1241,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
 		kvm->arch.crypto.data = matrix_mdev;
-		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-		       sizeof(struct ap_matrix));
 		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
@@ -1536,6 +1596,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev)
+		vfio_ap_mdev_filter_matrix(q->matrix_mdev);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
-- 
2.31.1

