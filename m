Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B255536BD
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353233AbiFUPwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353234AbiFUPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B38E2CE17;
        Tue, 21 Jun 2022 08:51:54 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFoZBK017009;
        Tue, 21 Jun 2022 15:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Vwf3VoLr+ZdrYcn5TSJwNk3jjbrLdPTV6ks6Cbio/GA=;
 b=NfjMAg6AQtYO+zSstAgh8V5d07L6YgPtoP+K9vP84bG7Rxu7uQpTD6v4TXfvCKMnS8gX
 vhixO5POemRtKnVLrKithw0zHKwowYSHkzg1vPomea6JB6nf5hHkvZICKeG0fP2tG1em
 8yo5wM3h2LdgwaPmBTmEJdeVLBSUk07/cEFhNQrLW9sgSlN9LK3OdNLx7CrZLrlFpn7K
 CxL0/M4ypGNmqHGnOqdKaQdBSziAB35WfJM96fmSWCXnslgu7jbSDcC4+AYC1qAtRrqE
 5r/L1/djgpMR1zUXhW4LVtKMAWja8OLt3i5YzDqjVcCRfkKsQ4qkZOGUR107QpdwcTH6 QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh0281a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFpD16019144;
        Tue, 21 Jun 2022 15:51:52 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guh02819j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:52 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZTsO015151;
        Tue, 21 Jun 2022 15:51:51 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3gs6ba4v21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:50 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpnJd14090878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:50 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7EBB13605E;
        Tue, 21 Jun 2022 15:51:49 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE8E4136059;
        Tue, 21 Jun 2022 15:51:48 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:48 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 12/20] s390/vfio-ap: allow hot plug/unplug of AP devices when assigned/unassigned
Date:   Tue, 21 Jun 2022 11:51:26 -0400
Message-Id: <20220621155134.1932383-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u5ya2WJlwVIa_zC0NtyUS3cOhpBSUrpm
X-Proofpoint-GUID: uOUZaVR68WYxjnNgZrnPGo4cmy2u1HCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's hot plug an adapter, domain or control domain into the guest when it
is assigned to a matrix mdev that is attached to a KVM guest. Likewise,
let's hot unplug an adapter, domain or control domain from the guest when
it is unassigned from a matrix_mdev that is attached to a KVM guest.

Whenever an assignment or unassignment of an adapter, domain or control
domain is performed, the APQNs and control domains assigned to the matrix
mdev will be filtered and assigned to the AP control block
(APCB) that supplies the AP configuration to the guest so that no
adapter, domain or control domain that is not in the host's AP
configuration nor any APQN that does not reference a queue device bound
to the vfio_ap device driver is assigned.

After updating the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to dynamically provide access to the adapters,
domains and control domains provided via the newly refreshed APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 112 +++++++++++++++---------------
 1 file changed, 57 insertions(+), 55 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6d55713c7f7a..93e932458590 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -600,10 +600,25 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev *matrix_mdev)
 {
+	if (matrix_mdev->kvm)
+		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+					  matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
+}
+
+static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+{
+	DECLARE_BITMAP(prev_shadow_adm, AP_DOMAINS);
+
+	bitmap_copy(prev_shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
 	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
 		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	return !bitmap_equal(prev_shadow_adm, matrix_mdev->shadow_apcb.adm,
+			     AP_DOMAINS);
 }
 
 /*
@@ -618,17 +633,24 @@ static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
  *	 driver, its APID will be filtered from the guest's APCB. The matrix
  *	 structure precludes filtering an individual APQN, so its APID will be
  *	 filtered.
+ *
+ * Return: a boolean value indicating whether the KVM guest's APCB was changed
+ *	   by the filtering or not.
  */
-static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
+static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 				       struct ap_matrix_mdev *matrix_mdev)
 {
 	int ret;
 	unsigned long apid, apqi, apqn;
+	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
+	DECLARE_BITMAP(prev_shadow_aqm, AP_DOMAINS);
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
-		return;
+		return false;
 
+	bitmap_copy(prev_shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
+	bitmap_copy(prev_shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 
 	/*
@@ -660,6 +682,11 @@ static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 			}
 		}
 	}
+
+	return !bitmap_equal(prev_shadow_apm, matrix_mdev->shadow_apcb.apm,
+			     AP_DEVICES) ||
+	       !bitmap_equal(prev_shadow_aqm, matrix_mdev->shadow_apcb.aqm,
+			     AP_DOMAINS);
 }
 
 static int vfio_ap_mdev_probe(struct mdev_device *mdev)
@@ -935,17 +962,10 @@ static ssize_t assign_adapter_store(struct device *dev,
 	int ret;
 	unsigned long apid;
 	DECLARE_BITMAP(apm_delta, AP_DEVICES);
-
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If the KVM guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		goto done;
@@ -966,8 +986,11 @@ static ssize_t assign_adapter_store(struct device *dev,
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
 	memset(apm_delta, 0, sizeof(apm_delta));
 	set_bit_inv(apid, apm_delta);
-	vfio_ap_mdev_filter_matrix(apm_delta,
-				   matrix_mdev->matrix.aqm, matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(apm_delta,
+				       matrix_mdev->matrix.aqm, matrix_mdev))
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1015,12 +1038,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If the KVM guest is running, disallow unassignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		goto done;
@@ -1033,8 +1050,10 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
 		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
 
 	ret = count;
 done:
@@ -1091,20 +1110,14 @@ static ssize_t assign_domain_store(struct device *dev,
 	unsigned long apqi;
 	DECLARE_BITMAP(aqm_delta, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
-	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If the KVM guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		goto done;
-	if (apqi > max_apqi) {
+
+	if (apqi > matrix_mdev->matrix.aqm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
@@ -1120,8 +1133,11 @@ static ssize_t assign_domain_store(struct device *dev,
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
 	memset(aqm_delta, 0, sizeof(aqm_delta));
 	set_bit_inv(apqi, aqm_delta);
-	vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm_delta,
-				   matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm_delta,
+				       matrix_mdev))
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1169,12 +1185,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If the KVM guest is running, disallow unassignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		goto done;
@@ -1187,8 +1197,10 @@ static ssize_t unassign_domain_store(struct device *dev,
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 
-	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
 		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
 
 	ret = count;
 
@@ -1222,12 +1234,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If the KVM guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		goto done;
@@ -1243,7 +1249,9 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_filter_cdoms(matrix_mdev);
+	if (vfio_ap_mdev_filter_cdoms(matrix_mdev))
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1272,28 +1280,24 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	int ret;
 	unsigned long domid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
-	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
 	get_update_locks_for_mdev(matrix_mdev);
 
-	/* If a KVM guest is running, disallow unassignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		goto done;
-	if (domid > max_domid) {
+
+	if (domid > matrix_mdev->matrix.adm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
 
-	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm))
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
 		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
 
 	ret = count;
 done:
@@ -1426,9 +1430,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
-		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
-					  matrix_mdev->shadow_apcb.aqm,
-					  matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 
 		release_update_locks_for_kvm(kvm);
 	}
-- 
2.35.3

