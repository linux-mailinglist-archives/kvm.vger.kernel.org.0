Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93B4B5F79
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiBOAvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiBOAvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011C1409F9;
        Mon, 14 Feb 2022 16:50:58 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F0TAuN000459;
        Tue, 15 Feb 2022 00:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HUe1D+C16sFyDqLIChLfITsn1dYmPFTCGmYgybryGWM=;
 b=drrQFixg6DKKdhJfJWe1RIxFN+UIPi/eBlH5/+3t1tQ1aUe6Dkn4U4t97XeOASkK2Xcu
 +N4+coLhaJw+m26MTE1+E3aaANTFxf+NHAu+8Y0d4WFp6ex1VR0LQpv+i4IX8mSLCKT/
 BcHXQ80pVfs/2bCfnsJsg2dpvMLGwJcSd0Ih2FtPSuMg2G8BuDO38h5GjmnlcUhfdxgI
 yTlN7WPg76cvpirwVM+7LaQm1F4S1uCXuUVjBxHfs2ZU7RR1ovhVmfBI2kh5zCMJG4QH
 S6s9GLadUgnJrW3gRri+HByMaZtGEDHPN5JtoQF/fYnOq/vUUMjH7vBot6uYkMvwlkXJ Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m10kde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:56 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0giwE007027;
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m10kd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:55 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0hwaM008379;
        Tue, 15 Feb 2022 00:50:55 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3e64haqhbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:55 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0onuX29557018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CA7124058;
        Tue, 15 Feb 2022 00:50:49 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04B73124054;
        Tue, 15 Feb 2022 00:50:49 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:48 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 07/18] s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
Date:   Mon, 14 Feb 2022 19:50:29 -0500
Message-Id: <20220215005040.52697-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6FAOcSutIURoUU2VdCtr7pUU12Y0-yMW
X-Proofpoint-ORIG-GUID: t2Jg9V9xKyIYZPhXjB0z9Q2Ej78oQm1-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/s390/crypto/vfio_ap_ops.c | 96 ++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4b676a55f203..b67b2f0faeea 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -317,6 +317,63 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
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
@@ -672,6 +729,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm, AP_DEVICES);
+
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
@@ -701,12 +760,15 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto done;
 
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
+	memset(apm, 0, sizeof(apm));
+	set_bit_inv(apid, apm);
 
 	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
 	if (ret)
 		goto share_err;
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_filter_matrix(apm, matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -775,6 +837,10 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -848,6 +914,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
@@ -872,12 +939,15 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto done;
 
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
+	memset(aqm, 0, sizeof(aqm));
+	set_bit_inv(apqi, aqm);
 
 	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
 	if (ret)
 		goto share_err;
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm, matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -946,6 +1016,10 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
 	ret = count;
 
 done:
@@ -999,6 +1073,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1046,6 +1121,10 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm))
+		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1186,8 +1265,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
-		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-		       sizeof(struct ap_matrix));
 		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
@@ -1528,6 +1605,7 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
+	DECLARE_BITMAP(apm, AP_DEVICES);
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
@@ -1537,6 +1615,12 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev) {
+		memset(apm, 0, sizeof(apm));
+		set_bit_inv(AP_QID_CARD(q->apqn), apm);
+		vfio_ap_mdev_filter_matrix(apm, q->matrix_mdev->matrix.aqm,
+					   q->matrix_mdev);
+	}
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1545,14 +1629,20 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
+	unsigned long apid;
 	struct vfio_ap_queue *q;
 
 	mutex_lock(&matrix_dev->lock);
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
2.31.1

