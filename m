Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22BC4B5F83
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiBOAvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbiBOAvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5E1409F2;
        Mon, 14 Feb 2022 16:50:57 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ENML3s007572;
        Tue, 15 Feb 2022 00:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zaM7wUZmh+SRL/uKIK8tSAmxcXtAuOpXEZ1ODpfales=;
 b=r5/8H8VUnNBv/i0sa3cmH/M3THLLmy0MzYvhXpwYGxhJX2wTm/ONo3Zs8WJbS6uAtZNq
 gO41RsEgWe24GZ6+xW8Mc3l7Unn534GCjJBwkUY2K3VO1RoOfremE39D1B2UqqnyaWiJ
 UoHwZDxoCAlxErd2zBfxVTREDNarv1iEEPGf9AjKqtcZF7tfl3g7gqPFRC5yu9JLokv5
 qHwKg/H1Vk6f0ZCuVQTeMQvsdEa6ZMhV3PsnunjSfesRK1ydS+NLO0vlp9M00yyNz5Ol
 CszJfh0Ko4lX7TmQV2u8xj8XDLO/It0S291DWxrMRdjA/NqxGV3BrLkSv7gIF4q5DuPu Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6thy0x7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:54 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0osF2001638;
        Tue, 15 Feb 2022 00:50:54 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6thy0x7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:54 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0hkdv015523;
        Tue, 15 Feb 2022 00:50:53 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3e64hb7gy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:53 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0oqmF35520936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:52 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6722B12405A;
        Tue, 15 Feb 2022 00:50:52 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 941F8124055;
        Tue, 15 Feb 2022 00:50:51 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:51 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 10/18] s390/vfio-ap: allow hot plug/unplug of AP devices when assigned/unassigned
Date:   Mon, 14 Feb 2022 19:50:32 -0500
Message-Id: <20220215005040.52697-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WVjJW3ObSFkYbyyk9-ZmiaFVlJY5h_3f
X-Proofpoint-ORIG-GUID: WNCdgOgjB4bzKO2jlnMisPUQeurtqyAq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Let's allow adapters, domains and control domains to be hot plugged
into and hot unplugged from a KVM guest using a matrix mdev when an
adapter, domain or control domain is assigned to or unassigned from
the matrix mdev.

Whenever an assignment or unassignment of an adapter, domain or control
domain is performed, the AP configuration assigned to the matrix
mediated device will be filtered and assigned to the AP control block
(APCB) that supplies the AP configuration to the guest so that no
adapter, domain or control domain that is not in the host's AP
configuration nor any APQN that does not reference a queue device bound
to the vfio_ap device driver is assigned.

After updating the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to dynamically provide access to the adapters,
domains and control domains provided via the newly refreshed APCB.

Keep in mind that the matrix_dev->guests_lock must be taken outside of the
matrix_mdev->kvm->lock which in turn must be taken outside of the
matrix_dev->mdevs_lock in order to avoid circular lock dependencies (i.e.,
a lockdep splat).Consequently, the locking order for hot plugging the
guest's APCB must be:

matrix_dev->guests_lock => matrix_mdev->kvm->lock => matrix_dev->mdevs_lock

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 198 +++++++++++++++++++-----------
 1 file changed, 125 insertions(+), 73 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 623a4b38676d..4c382cd3afc7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -317,10 +317,25 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+static void vfio_ap_mdev_hotplug_apcb(struct ap_matrix_mdev *matrix_mdev)
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
+	DECLARE_BITMAP(shadow_adm, AP_DOMAINS);
+
+	bitmap_copy(shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
 	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
 		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	return !bitmap_equal(shadow_adm, matrix_mdev->shadow_apcb.adm,
+			     AP_DOMAINS);
 }
 
 /*
@@ -330,17 +345,24 @@ static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
  *				queue device bound to the vfio_ap device driver.
  *
  * @matrix_mdev: the mdev whose AP configuration is to be filtered.
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
+	DECLARE_BITMAP(shadow_apm, AP_DEVICES);
+	DECLARE_BITMAP(shadow_aqm, AP_DOMAINS);
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
-		return;
+		return false;
 
+	bitmap_copy(shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
+	bitmap_copy(shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 
 	/*
@@ -372,6 +394,11 @@ static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 			}
 		}
 	}
+
+	return !bitmap_equal(shadow_apm, matrix_mdev->shadow_apcb.apm,
+			     AP_DEVICES) ||
+	       !bitmap_equal(shadow_aqm, matrix_mdev->shadow_apcb.aqm,
+			     AP_DOMAINS);
 }
 
 static int vfio_ap_mdev_probe(struct mdev_device *mdev)
@@ -472,11 +499,13 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
+	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
@@ -612,6 +641,51 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
 				       AP_MKQID(apid, apqi));
 }
 
+/**
+ * vfio_ap_mdev_get_locks - acquire the locks required to assign/unassign AP
+ *			    adapters, domains and control domains for an mdev in
+ *			    the proper locking order.
+ *
+ * @matrix_mdev: the matrix mediated device object
+ */
+static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
+{
+	/* Lock the mutex required to access the KVM guest's state */
+	mutex_lock(&matrix_dev->guests_lock);
+
+	/* If a KVM guest is running, lock the mutex required to plug/unplug the
+	 * AP devices passed through to the guest
+	 */
+	if (matrix_mdev->kvm)
+		mutex_lock(&matrix_mdev->kvm->lock);
+
+	/* The lock required to access the mdev's state */
+	mutex_lock(&matrix_dev->mdevs_lock);
+}
+
+/**
+ * vfio_ap_mdev_put_locks - release the locks used to assign/unassign AP
+ *			    adapters, domains and control domains in the proper
+ *			    unlocking order.
+ *
+ * @matrix_mdev: the matrix mediated device object
+ */
+static void vfio_ap_mdev_put_locks(struct ap_matrix_mdev *matrix_mdev)
+{
+	/* Unlock the mutex taken to access the matrix_mdev's state */
+	mutex_unlock(&matrix_dev->mdevs_lock);
+
+	/*
+	 * If a KVM guest is running, unlock the mutex taken to plug/unplug the
+	 * AP devices passed through to the guest.
+	 */
+	if (matrix_mdev->kvm)
+		mutex_unlock(&matrix_mdev->kvm->lock);
+
+	/* Unlock the mutex taken to allow access to the KVM guest's state */
+	mutex_unlock(&matrix_dev->guests_lock);
+}
+
 /**
  * assign_adapter_store - parses the APID from @buf and sets the
  * corresponding bit in the mediated matrix device's APM
@@ -649,17 +723,9 @@ static ssize_t assign_adapter_store(struct device *dev,
 	int ret;
 	unsigned long apid;
 	DECLARE_BITMAP(apm, AP_DEVICES);
-
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->guests_lock);
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If the KVM guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
@@ -671,8 +737,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
-	memset(apm, 0, sizeof(apm));
-	set_bit_inv(apid, apm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
 	if (ret) {
@@ -680,12 +744,17 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto done;
 	}
 
+	memset(apm, 0, sizeof(apm));
+	set_bit_inv(apid, apm);
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
-	vfio_ap_mdev_filter_matrix(apm, matrix_mdev->matrix.aqm, matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(apm,
+				       matrix_mdev->matrix.aqm, matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
-	mutex_unlock(&matrix_dev->guests_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return ret;
 }
@@ -728,13 +797,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If the KVM guest is running, disallow unassignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
@@ -748,12 +811,15 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
 		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+	}
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -806,28 +872,19 @@ static ssize_t assign_domain_store(struct device *dev,
 	unsigned long apqi;
 	DECLARE_BITMAP(aqm, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
-	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->guests_lock);
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If the KVM guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		goto done;
-	if (apqi > max_apqi) {
+
+	if (apqi > matrix_mdev->matrix.apm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
 
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
-	memset(aqm, 0, sizeof(aqm));
-	set_bit_inv(apqi, aqm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
 	if (ret) {
@@ -835,12 +892,17 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto done;
 	}
 
+	memset(aqm, 0, sizeof(aqm));
+	set_bit_inv(apqi, aqm);
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
-	vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm, matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm,
+				       matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
-	mutex_unlock(&matrix_dev->guests_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return ret;
 }
@@ -883,19 +945,13 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If the KVM guest is running, disallow unassignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		goto done;
 
-	if (apqi > matrix_mdev->matrix.aqm_max) {
+	if (apqi > matrix_mdev->matrix.apm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
@@ -903,13 +959,15 @@ static ssize_t unassign_domain_store(struct device *dev,
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 
-	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
 		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+	}
 
 	ret = count;
-
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -936,19 +994,13 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If the KVM guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		goto done;
 
-	if (id > matrix_mdev->matrix.adm_max) {
+	if (id > matrix_mdev->matrix.apm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
@@ -959,10 +1011,13 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_filter_cdoms(matrix_mdev);
+	if (vfio_ap_mdev_filter_cdoms(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -988,32 +1043,29 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	int ret;
 	unsigned long domid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
-	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
-
-	/* If a KVM guest is running, disallow unassignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		goto done;
-	if (domid > max_domid) {
+
+	if (domid > matrix_mdev->matrix.apm_max) {
 		ret = -ENODEV;
 		goto done;
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
 
-	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm))
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
 		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+	}
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
-- 
2.31.1

