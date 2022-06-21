Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6255536B4
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353201AbiFUPv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353178AbiFUPvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C02CE2F;
        Tue, 21 Jun 2022 08:51:46 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LF4VF7017781;
        Tue, 21 Jun 2022 15:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DiVNHJNZoGJgDZ/D5qGCvLrLBiYxIw+RtJZ8oqvvQxA=;
 b=Qqa1mnPoiq+1MVozszUvUU3WcOZUlvnRCvwFBrTuPHO09cUuyf92zmfDmL/r+gzE//mD
 5riEGhKeO2E0Z0dsiLLBYoGketbLZZd8IzrNUlSDMYHaWeJbOIBUPF5HSC3H/VWKPGiO
 rdXT2/pVuuecZr3KQcRwih0XTrq6aSTAGWBiL8wf9/CbHrpppX2AB8+itRab6cXIa22K
 kqvcGHnyOs7u3ZQKLRa4uSHcYSlQM4+HbgXc9TFH9rCZk40K9BzmtYGItQzyZH5ncmy5
 j3z93Adh9w5QMDpCA1TULDgkQ2ebtgmaNNGtDy7jt84EpXhfzTlWR5RPbJ+7IGPicvPE 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaesen0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFgNiO010929;
        Tue, 21 Jun 2022 15:51:44 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugaesemk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:44 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZxpF031850;
        Tue, 21 Jun 2022 15:51:43 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3gt0091y72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:43 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpfU423658964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE07413605E;
        Tue, 21 Jun 2022 15:51:41 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB82D136051;
        Tue, 21 Jun 2022 15:51:40 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 05/20] s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned to mdev
Date:   Tue, 21 Jun 2022 11:51:19 -0400
Message-Id: <20220621155134.1932383-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MiZFyaRBESfoUgB5wkBtmBPHax2ndttp
X-Proofpoint-GUID: HdqrI_yfDHni3i4tSKbcQU9Dt8S-Bj5h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh the guest's APCB by filtering the APQNs and control domain numbers
assigned to the matrix mdev.

Filtering of APQNs:
-----------------
APQNs that do not reference an AP queue device bound to the vfio_ap device
driver must be filtered from the APQNs assigned to the matrix mdev before
they can be assigned to the guest's APCB. Given that the APQNs are
configured in the guest's APCB as a matrix of APIDs (adapters) and APQIs
(domains), it is not possible to filter an individual APQN. For example,
suppose the matrix of APQNs is structured as follows:

                   APIDs
             3      4      5
        0  (3,0)  (4,0)  (5,0)
APQIs   1  (3,1)  (4,1)  (5,1)
        2  (3,2)  (4,2)  (5,2)

Now suppose APQN (4,1) does not reference a queue device bound to the
vfio_ap device driver. If we filter APID 4, the APQNs (4,0), (4,1) and
(4,2) will be removed. Similarly, if we filter domain 1, APQNs (3,1),
(4,1) and (5,1) will be removed.

To resolve this dilemma, the choice was made to filter the APID - in this
case 4 - from the guest's APCB. The reason for this design decision is
because the APID references an AP adapter which is a real hardware device
that can be physically installed, removed, enabled or disabled; whereas, a
domain is a partition within the adapter. It therefore better reflects
reality to remove the APID from the guest's APCB.

Filtering of control domains:
----------------------------
Any control domains that are not assigned to the host's AP configuration
will be filtered from those assigned to the matrix mdev before assigning
them to the guest's APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 101 +++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b50fc35d4395..892a982f8bc1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -447,6 +447,68 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+{
+	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
+		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+}
+
+/*
+ * vfio_ap_mdev_filter_matrix - filter the APQNs assigned to the matrix mdev
+ *				to ensure no queue devices are passed through to
+ *				the guest that are not bound to the vfio_ap
+ *				device driver.
+ *
+ * @matrix_mdev: the matrix mdev whose matrix is to be filtered.
+ *
+ * Note: If an APQN referencing a queue device that is not bound to the vfio_ap
+ *	 driver, its APID will be filtered from the guest's APCB. The matrix
+ *	 structure precludes filtering an individual APQN, so its APID will be
+ *	 filtered.
+ */
+static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
+				       struct ap_matrix_mdev *matrix_mdev)
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
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so let's filter
+			 * the APID since an adapter represents a physical
+			 * hardware device.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+
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
@@ -802,6 +864,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm_delta, AP_DEVICES);
+
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
@@ -837,6 +901,10 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	memset(apm_delta, 0, sizeof(apm_delta));
+	set_bit_inv(apid, apm_delta);
+	vfio_ap_mdev_filter_matrix(apm_delta,
+				   matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -905,6 +973,10 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -978,6 +1050,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm_delta, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
@@ -1008,6 +1081,10 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	memset(aqm_delta, 0, sizeof(aqm_delta));
+	set_bit_inv(apqi, aqm_delta);
+	vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm_delta,
+				   matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -1076,6 +1153,10 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
 	ret = count;
 
 done:
@@ -1129,6 +1210,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1176,6 +1258,10 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm))
+		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1309,8 +1395,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
-		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-		       sizeof(struct ap_matrix));
 		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
@@ -1687,6 +1771,11 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev) {
+		vfio_ap_mdev_filter_matrix(q->matrix_mdev->matrix.apm,
+					   q->matrix_mdev->matrix.aqm,
+					   q->matrix_mdev);
+	}
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1695,15 +1784,21 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
+	unsigned long apid;
 	struct vfio_ap_queue *q;
 
 	mutex_lock(&matrix_dev->lock);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	q = dev_get_drvdata(&apdev->device);
 
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
 		vfio_ap_unlink_queue_fr_mdev(q);
 
+		apid = AP_QID_CARD(q->apqn);
+		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
+			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+	}
+
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-- 
2.35.3

