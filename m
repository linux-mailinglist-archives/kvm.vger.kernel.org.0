Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653095536B5
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353239AbiFUPv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353202AbiFUPvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC882D1C2;
        Tue, 21 Jun 2022 08:51:48 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFOle1020019;
        Tue, 21 Jun 2022 15:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=09fOQ8kL1cG/KzRwoGMG9P2uL8dUUDJ6KE2Ss3sWE9E=;
 b=E/dFASWjuluc/Hy2PE4RI/XC5NcKngtEhaeS6x8pE1kszPCKsLbv23AguLC6LcTCiHHU
 grou/5aGj3J365sxLIVK4gMWYEiiQ1o7hXNOuhQCHSqhXQnezfwbM1b7/CAURLOP5vH2
 HHP2oV9pnlg171zZEbiau0a/uZurYiqCP4SLMG+4kELqc9TVkfiFdZhjy9HDjMup1ITf
 QHft6AuT6xPSmqEgCJthnTY0wDaEkfblzFZYgPJWClQUKgs9AH4bU+O6qxmeTDH8DFl5
 7mzXq3RBMGmUcUWIvLvuj28wcKYgPlotNhz8JkMu2RxTY9hLiEjgKv0YVZEZ3g3D9dpO xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFRLcD033887;
        Tue, 21 Jun 2022 15:51:46 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:46 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFaJ6I013914;
        Tue, 21 Jun 2022 15:51:45 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3gs6b9mu8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:45 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpiBo24445346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:44 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1216613604F;
        Tue, 21 Jun 2022 15:51:44 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E3B4136053;
        Tue, 21 Jun 2022 15:51:43 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 07/20] s390/vfio-ap: rename matrix_dev->lock mutex to matrix_dev->mdevs_lock
Date:   Tue, 21 Jun 2022 11:51:21 -0400
Message-Id: <20220621155134.1932383-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R71d-yPz-77FRs0hTz5Ctdc3NQl5_ezo
X-Proofpoint-GUID: 6ZXRtrRmLWEnuvb-jhKcJl7ex1fYkC_t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix_dev->lock mutex is being renamed to matrix_dev->mdevs_lock to
better reflect its purpose, which is to control access to the state of the
mediated devices under the control of the vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  2 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 76 ++++++++++++++-------------
 drivers/s390/crypto/vfio_ap_private.h |  4 +-
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 1ff6e3dbbffe..ed162732b139 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -98,7 +98,7 @@ static int vfio_ap_matrix_dev_create(void)
 			goto matrix_alloc_err;
 	}
 
-	mutex_init(&matrix_dev->lock);
+	mutex_init(&matrix_dev->mdevs_lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0f3cdd40c23e..f81bf8686464 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -397,10 +397,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		return -EOPNOTSUPP;
 	}
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
+
 	if (!vcpu->kvm->arch.crypto.pqap_hook) {
 		VFIO_AP_DBF_WARN("%s: PQAP(AQIC) hook not registered with the vfio_ap driver: apqn=0x%04x\n",
 				 __func__, apqn);
+
 		goto out_unlock;
 	}
 
@@ -435,7 +437,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 out_unlock:
 	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
 	vcpu->run->s.regs.gprs[1] >>= 32;
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return 0;
 }
 
@@ -531,9 +533,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
@@ -542,9 +544,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	return 0;
 
 err_list:
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
@@ -607,11 +609,11 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
@@ -787,7 +789,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -819,7 +821,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 				   matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -862,7 +864,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -887,7 +889,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -942,7 +944,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of domain */
 	if (matrix_mdev->kvm) {
@@ -973,7 +975,7 @@ static ssize_t assign_domain_store(struct device *dev,
 				   matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -1016,7 +1018,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1042,7 +1044,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	ret = count;
 
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -1069,7 +1071,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1095,7 +1097,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -1123,7 +1125,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If a KVM guest is running, disallow unassignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1146,7 +1148,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
@@ -1162,13 +1164,13 @@ static ssize_t control_domains_show(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid = matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	for_each_set_bit_inv(id, matrix_mdev->matrix.adm, max_domid + 1) {
 		n = sprintf(bufpos, "%04lx\n", id);
 		bufpos += n;
 		nchars += n;
 	}
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -1191,7 +1193,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
 	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
 		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
@@ -1217,7 +1219,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 		}
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -1265,12 +1267,12 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
 		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 			if (m != matrix_mdev && m->kvm == kvm) {
 				mutex_unlock(&kvm->lock);
-				mutex_unlock(&matrix_dev->lock);
+				mutex_unlock(&matrix_dev->mdevs_lock);
 				return -EPERM;
 			}
 		}
@@ -1282,7 +1284,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.adm);
 
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->mdevs_lock);
 	}
 
 	return 0;
@@ -1334,7 +1336,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
 		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
@@ -1342,7 +1344,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		matrix_mdev->kvm = NULL;
 
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->mdevs_lock);
 	}
 }
 
@@ -1497,7 +1499,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 	int ret;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		ret = vfio_ap_mdev_get_device_info(arg);
@@ -1509,7 +1511,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -1538,7 +1540,7 @@ static ssize_t status_show(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
@@ -1554,7 +1556,7 @@ static ssize_t status_show(struct device *dev,
 				   AP_QUEUE_UNASSIGNED);
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -1649,7 +1651,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	if (!q)
 		return -ENOMEM;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
@@ -1659,7 +1661,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 					   q->matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return 0;
 }
@@ -1669,7 +1671,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	unsigned long apid;
 	struct vfio_ap_queue *q;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	q = dev_get_drvdata(&apdev->device);
 
@@ -1684,5 +1686,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index acb3f9d22025..22278d85a801 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -33,7 +33,7 @@
  * @available_instances: number of mediated matrix devices that can be created
  * @info:	the struct containing the output from the PQAP(QCI) instruction
  * @mdev_list:	the list of mediated matrix devices created
- * @lock:	mutex for locking the AP matrix device. This lock will be
+ * @mdevs_lock: mutex for locking the AP matrix device. This lock will be
  *		taken every time we fiddle with state managed by the vfio_ap
  *		driver, be it using @mdev_list or writing the state of a
  *		single ap_matrix_mdev device. It's quite coarse but we don't
@@ -45,7 +45,7 @@ struct ap_matrix_dev {
 	atomic_t available_instances;
 	struct ap_config_info info;
 	struct list_head mdev_list;
-	struct mutex lock;
+	struct mutex mdevs_lock;
 	struct ap_driver  *vfio_ap_drv;
 };
 
-- 
2.35.3

