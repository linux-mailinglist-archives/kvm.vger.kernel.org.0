Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EC94F1F61
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiDDWxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbiDDWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6222A4B429;
        Mon,  4 Apr 2022 15:11:58 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234MAE1C025677;
        Mon, 4 Apr 2022 22:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RWiF/elyuxPyVl6Q8O9uc1NTnTOSrRyjS0ZDFYFuBOc=;
 b=SOsTSFemaJw+dGwO2+MeZ4/p6aV3AsNC6zEXdIqj/1j9thIMCLc00YMxcr4sIHZk0ZUp
 +qkXjKDdUoiKmtGYVPDmZs8P3b17uf2+Kj3T9UZJruM91FqRHzy9AHBI7aZ9gWEjMx3W
 3kGIub6kM0TpR6hmVrEvZ2/ru3XsZ/5rU0c/mAtr4z/+xLxeGNZXmk6ksyAxHOL4ZyI2
 zKxfKBZ5qZx6PEXUKDfXMbttNmH0z1lKU75Eni/fdiKOMjSLmmVMow0bXA1aHIc+p6sY
 jyDjG/wdv8JZYLx8ST884lBoQWMV/sQ3m7hGk5n9BoEZ9K6jLkAhTsJEMcjja5bVi+6k cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7xfecaeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:56 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234MBYEZ002233;
        Mon, 4 Apr 2022 22:11:55 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f7xfecae8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:55 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr7o1022045;
        Mon, 4 Apr 2022 22:11:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3f6e49jn8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:54 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBrrv11338360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:53 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38D6178060;
        Mon,  4 Apr 2022 22:11:53 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D2737805C;
        Mon,  4 Apr 2022 22:11:52 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:52 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 07/20] s390/vfio-ap: rename matrix_dev->lock mutex to matrix_dev->mdevs_lock
Date:   Mon,  4 Apr 2022 18:10:26 -0400
Message-Id: <20220404221039.1272245-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qjDNxL6XdGo5ZYMsJUCAKBCS1O7GZakE
X-Proofpoint-GUID: 0oNaptFlZSVzPNOTpKo9SR55moG0a9J8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 bulkscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix_dev->lock mutex is being renamed to matrix_dev->mdevs_lock to
better reflect its purpose, which is to control access to the state of the
mediated devices under the control of the vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  6 +--
 drivers/s390/crypto/vfio_ap_ops.c     | 72 ++++++++++++++-------------
 drivers/s390/crypto/vfio_ap_private.h |  4 +-
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 9a300dd3b6f7..0a5acd151a9b 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -72,7 +72,7 @@ static ssize_t status_show(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
@@ -88,7 +88,7 @@ static ssize_t status_show(struct device *dev,
 				   AP_QUEUE_UNASSIGNED);
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -159,7 +159,7 @@ static int vfio_ap_matrix_dev_create(void)
 			goto matrix_alloc_err;
 	}
 
-	mutex_init(&matrix_dev->lock);
+	mutex_init(&matrix_dev->mdevs_lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f937f38031f0..077b8c9c831b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -394,10 +394,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
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
 
@@ -432,7 +434,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 out_unlock:
 	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
 	vcpu->run->s.regs.gprs[1] >>= 32;
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return 0;
 }
 
@@ -528,9 +530,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	mdev_set_drvdata(mdev, matrix_mdev);
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
@@ -539,9 +541,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
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
@@ -604,11 +606,11 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
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
@@ -784,7 +786,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -816,7 +818,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 				   matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -859,7 +861,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -884,7 +886,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -939,7 +941,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of domain */
 	if (matrix_mdev->kvm) {
@@ -970,7 +972,7 @@ static ssize_t assign_domain_store(struct device *dev,
 				   matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -1013,7 +1015,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of domain */
 	if (matrix_mdev->kvm) {
@@ -1039,7 +1041,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	ret = count;
 
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -1066,7 +1068,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1092,7 +1094,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -1120,7 +1122,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If a KVM guest is running, disallow unassignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1143,7 +1145,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
@@ -1159,13 +1161,13 @@ static ssize_t control_domains_show(struct device *dev,
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
@@ -1188,7 +1190,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
 	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
 		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
@@ -1214,7 +1216,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 		}
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -1262,12 +1264,12 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
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
@@ -1279,7 +1281,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.adm);
 
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->mdevs_lock);
 	}
 
 	return 0;
@@ -1331,7 +1333,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
 		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
@@ -1339,7 +1341,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		matrix_mdev->kvm = NULL;
 
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->mdevs_lock);
 	}
 }
 
@@ -1516,7 +1518,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 	int ret;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		ret = vfio_ap_mdev_get_device_info(arg);
@@ -1528,7 +1530,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -1612,7 +1614,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
@@ -1624,7 +1626,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 					   q->matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return 0;
 }
@@ -1634,7 +1636,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	unsigned long apid;
 	struct vfio_ap_queue *q;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 
 	if (q->matrix_mdev) {
@@ -1648,5 +1650,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index fa11a7e91e24..5262e02192a4 100644
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
2.31.1

