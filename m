Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42E04F1F94
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiDDWyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F544BB86;
        Mon,  4 Apr 2022 15:12:03 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234LG0gb009985;
        Mon, 4 Apr 2022 22:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MR8KzfXJShZmFotjcu860eW8L/0RMnWWaPuM3aXhhKk=;
 b=Zk5qOSVMa7ZlgyZO0RR5LbtvKFxypQ4cLUJ9CI6d89ny5JSLeJ6/B+CF6BcGTuiZ1FfO
 iLd51rBlBZc94hjXCIYWwzViHVtidDq06vx3noyFjSIbwFRtuTiqtNkwEJjR+eD4DFPq
 v1B7QAIJHTZK3CfYuBvWUdWROojUtVVK0l9wWCn3AmQrOIRk93HXvBGV3SpDUJCCtmio
 wlkMlYVnm6kZfHI+s6SbDPfaz3Z0ClgWhFI7MYs5A39FV57TOLIfqTo9/gJ5eq4/jB6/
 V5OeKypTzPnA0u7W+4/OeQs08BAW6nS5vsp+wcllW89cN54roVRo1tIeHOzidmI73s9e 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f88efs8pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:01 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234M4n4U002969;
        Mon, 4 Apr 2022 22:12:01 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f88efs8pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:00 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234LquCE027682;
        Mon, 4 Apr 2022 22:12:00 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3f6e49aq1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:00 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBxRI32112932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:59 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1755878060;
        Mon,  4 Apr 2022 22:11:59 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16D6978067;
        Mon,  4 Apr 2022 22:11:58 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:57 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 12/20] s390/vfio-ap: allow hot plug/unplug of AP devices when assigned/unassigned
Date:   Mon,  4 Apr 2022 18:10:31 -0400
Message-Id: <20220404221039.1272245-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rgz-BJHfAS5ZgyQFtMtWcRzH48DXb5cy
X-Proofpoint-ORIG-GUID: ckLkvkS7gHTT0z93uXh-syoWkR1V76xF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/s390/crypto/vfio_ap_ops.c | 112 +++++++++++++++---------------
 1 file changed, 57 insertions(+), 55 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 080a733f7cd2..47f808122ed2 100644
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
@@ -936,17 +963,10 @@ static ssize_t assign_adapter_store(struct device *dev,
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
@@ -967,8 +987,11 @@ static ssize_t assign_adapter_store(struct device *dev,
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
@@ -1016,12 +1039,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
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
@@ -1034,8 +1051,10 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
 		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
 
 	ret = count;
 done:
@@ -1092,20 +1111,14 @@ static ssize_t assign_domain_store(struct device *dev,
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
@@ -1121,8 +1134,11 @@ static ssize_t assign_domain_store(struct device *dev,
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
@@ -1170,12 +1186,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 
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
@@ -1188,8 +1198,10 @@ static ssize_t unassign_domain_store(struct device *dev,
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 
-	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
 		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
 
 	ret = count;
 
@@ -1223,12 +1235,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 
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
@@ -1244,7 +1250,9 @@ static ssize_t assign_control_domain_store(struct device *dev,
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
@@ -1273,28 +1281,24 @@ static ssize_t unassign_control_domain_store(struct device *dev,
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
@@ -1427,9 +1431,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
-		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
-					  matrix_mdev->shadow_apcb.aqm,
-					  matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 
 		release_update_locks_for_kvm(kvm);
 	}
-- 
2.31.1

