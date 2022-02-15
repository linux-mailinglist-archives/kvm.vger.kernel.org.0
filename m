Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1694B5F78
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiBOAvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiBOAvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4683313C9E1;
        Mon, 14 Feb 2022 16:50:56 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ENqktf020349;
        Tue, 15 Feb 2022 00:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tt9xo9FHYYzhVRRfG3lLPS/d8CJsw8dVR87tZa2hIUg=;
 b=syRX2DPcvBlaVftkX62xa3JpUlGylnjxfeC76SxVqeLgSszno3jao7bAvlEQmkNZ4cbA
 wxxmszQ1bEUAxbfRA37N0LPUbL/EosLfOh8ygrF3awfpmjvQVn8NGe9bZTw/Mj05VBBx
 5F+8SoVdsUNfRY6sFxq11QjpTNwhzDfWI+zhIrDaUwzmf/heKYj+fvh9lp3rgtKXmf95
 IbzxJBCIRrbc+o2sIkrPKRrx/LQNr/BImyNIK6wseHa7J4QXFnl64Lax6W6pU9IzxPfI
 KWOKdHTa+2YjPfWr79XFD7Sxg/9U/rYb1QSA/j3YUjwBbIMLoXap9My/psGHECgFEiyM FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7d0k4x76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0gqgV002854;
        Tue, 15 Feb 2022 00:50:53 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7d0k4x6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:53 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0hxaU008393;
        Tue, 15 Feb 2022 00:50:52 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3e64haqhay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:52 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0opR87668498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:51 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76D78124058;
        Tue, 15 Feb 2022 00:50:51 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE319124055;
        Tue, 15 Feb 2022 00:50:50 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:50 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 09/18] s390/vfio-ap: introduce new mutex to control access to the KVM pointer
Date:   Mon, 14 Feb 2022 19:50:31 -0500
Message-Id: <20220215005040.52697-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7pszxJsY1dZYWo4Jr-8tdHqCP8r9RCHB
X-Proofpoint-GUID: gPMhNKBksHxdNwvdtevoBAlEyTDapmz5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The vfio_ap device driver registers for notification when the pointer to
the KVM object for a guest is set. Recall that the KVM lock (kvm->lock)
mutex must be taken outside of the matrix_dev->lock mutex to prevent the
reporting by lockdep of a circular locking dependency (a.k.a., a lockdep
splat):

* see commit 0cc00c8d4050 ("Fix circular lockdep when setting/clearing
  crypto masks")

* see commit 86956e70761b ("replace open coded locks for
  VFIO_GROUP_NOTIFY_SET_KVM notification")

With the introduction of support for hot plugging/unplugging AP devices
passed through to a KVM guest, a new guests_lock mutex is introduced to
ensure the proper locking order is maintained:

struct ap_matrix_dev {
        ...
        struct mutex guests_lock;
       ...
}

The matrix_dev->guests_lock controls access to the matrix_mdev instances
that hold the state for AP devices that have been passed through to a
KVM guest. This lock must be held:

1. To control access to the KVM pointer (matrix_mdev->kvm) while the
   vfio_ap device driver is using it to plug/unplug AP devices passed
   through to the KVM guest.

2. To add matrix_mdev instances to or remove them from
   matrix_dev->mdev_list. This is necessary to ensure the proper locking
   order when the list is iterated to find an ap_matrix_mdev instance for
   the purpose of plugging/unplugging AP devices passed through to a KVM
   guest; for example, when a queue device is bound to (probe callback) or
   removed from (remove callback) the vfio_ap device driver.

   For example, when a queue device is removed from the vfio_ap device
   driver, if the adapter is passed through to a KVM guest, it will have to
   be unplugged. Since the vfio_ap device driver only knows the APQN of the
   queue device when it is removed, in order to figure out whether the
   adapter is passed through, the matrix_mdev object to which the queue is
   assigned will have to be found. Its KVM pointer (matrix_mdev->kvm) can
   then be used to determine if the mediated device is passed through
   (matrix_mdev->kvm != NULL) and if so, to unplug the adapter.

In addition to introducing the matrix_mdev->guests_lock mutex, the
matrix_dev->lock mutex is being renamed to matrix_dev->mdevs_lock to
better reflect its purpose, which is to control access to the state of the
mediated devices under the control of the vfio_ap device driver.

It is not necessary to take the matrix_dev->guests_lock to access the KVM
pointer if the pointer is not used to plug/unplug AP devices; however, in
this case, the matrix_dev->mdevs_lock must be held in order to access the
KVM pointer since it set and cleared under the protection of the
mdevs_lock.
A case in point is the function that handles interception of the PQAP(AQIC)
instruction sub-function by the host. This handler needs to access the KVM
pointer, but only for the purposes of setting or clearing IRQ resources, so
only the matrix_dev->mdevs_lock needs to be held.

The proper locking order must be maintained whenever plugging/unplugging
AP devices passed through to a KVM guest under the control of the vfio_ap
device driver:

    matrix_dev->guests_lock
    matrix_mdev->kvm->lock
    matrix_dev->mdevs_lock

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  7 ++-
 drivers/s390/crypto/vfio_ap_ops.c     | 81 +++++++++++++++------------
 drivers/s390/crypto/vfio_ap_private.h | 17 ++++--
 3 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 5013a5531171..e8f3540ebfda 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -68,7 +68,7 @@ static ssize_t status_show(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
 	q = dev_get_drvdata(&apdev->device);
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
@@ -84,7 +84,7 @@ static ssize_t status_show(struct device *dev,
 				   AP_QUEUE_UNASSIGNED);
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return nchars;
 }
@@ -155,8 +155,9 @@ static int vfio_ap_matrix_dev_create(void)
 			goto matrix_alloc_err;
 	}
 
-	mutex_init(&matrix_dev->lock);
+	mutex_init(&matrix_dev->mdevs_lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
+	mutex_init(&matrix_dev->guests_lock);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
 	matrix_dev->device.parent = root_device;
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f2b98f347f9f..623a4b38676d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -278,7 +278,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		return -EOPNOTSUPP;
 
 	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	if (!vcpu->kvm->arch.crypto.pqap_hook)
 		goto out_unlock;
@@ -305,7 +305,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 out_unlock:
 	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
 	vcpu->run->s.regs.gprs[1] >>= 32;
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return 0;
 }
 
@@ -396,9 +396,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	mdev_set_drvdata(mdev, matrix_mdev);
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
@@ -407,9 +407,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	return 0;
 
 err_list:
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
 	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
@@ -472,11 +472,11 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
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
@@ -652,7 +652,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -683,7 +684,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 	vfio_ap_mdev_filter_matrix(apm, matrix_mdev->matrix.aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return ret;
 }
@@ -726,7 +728,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of adapter */
 	if (matrix_mdev->kvm) {
@@ -751,7 +753,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -806,7 +808,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of domain */
 	if (matrix_mdev->kvm) {
@@ -836,7 +839,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm, matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return ret;
 }
@@ -879,7 +883,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow unassignment of domain */
 	if (matrix_mdev->kvm) {
@@ -905,7 +909,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	ret = count;
 
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -932,7 +936,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If the KVM guest is running, disallow assignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -958,7 +962,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_filter_cdoms(matrix_mdev);
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -986,7 +990,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	/* If a KVM guest is running, disallow unassignment of control domain */
 	if (matrix_mdev->kvm) {
@@ -1009,7 +1013,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
@@ -1025,13 +1029,13 @@ static ssize_t control_domains_show(struct device *dev,
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
@@ -1054,7 +1058,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
 	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 
 	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
 		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
@@ -1080,7 +1084,7 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 		}
 	}
 
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
@@ -1134,13 +1138,15 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
+		mutex_lock(&matrix_dev->guests_lock);
 		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 			if (m != matrix_mdev && m->kvm == kvm) {
+				mutex_unlock(&matrix_dev->mdevs_lock);
 				mutex_unlock(&kvm->lock);
-				mutex_unlock(&matrix_dev->lock);
+				mutex_unlock(&matrix_dev->guests_lock);
 				return -EPERM;
 			}
 		}
@@ -1151,8 +1157,9 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
 
+		mutex_unlock(&matrix_dev->mdevs_lock);
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->guests_lock);
 	}
 
 	return 0;
@@ -1210,16 +1217,18 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm->arch.crypto.pqap_hook = NULL;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
+		mutex_lock(&matrix_dev->guests_lock);
 		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
+		mutex_unlock(&matrix_dev->mdevs_lock);
 		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&matrix_dev->guests_lock);
 	}
 }
 
@@ -1396,7 +1405,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 	int ret;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		ret = vfio_ap_mdev_get_device_info(arg);
@@ -1408,7 +1417,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return ret;
 }
@@ -1493,7 +1502,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	if (!q)
 		return -ENOMEM;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->guests_lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
@@ -1504,7 +1514,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 					   q->matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return 0;
 }
@@ -1514,7 +1525,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	unsigned long apid;
 	struct vfio_ap_queue *q;
 
-	mutex_lock(&matrix_dev->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 
 	if (q->matrix_mdev) {
@@ -1528,5 +1539,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index fa11a7e91e24..7e82a72d2083 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -33,20 +33,25 @@
  * @available_instances: number of mediated matrix devices that can be created
  * @info:	the struct containing the output from the PQAP(QCI) instruction
  * @mdev_list:	the list of mediated matrix devices created
- * @lock:	mutex for locking the AP matrix device. This lock will be
- *		taken every time we fiddle with state managed by the vfio_ap
- *		driver, be it using @mdev_list or writing the state of a
- *		single ap_matrix_mdev device. It's quite coarse but we don't
- *		expect much contention.
+ * @mdevs_lock:	mutex for locking the ap_matrix_mdev devices under the control
+ *		of the vfio_ap device driver. This lock will be taken every time
+ *		we fiddle with state of an ap_matrix_mdev device. It's quite
+ *		coarse but we don't expect much contention.
  * @vfio_ap_drv: the vfio_ap device driver
+ * @guests_lock: mutex for controlling access to a guest that is using AP
+ *		 devices passed through by the vfio_ap device driver. This lock
+ *		 will be taken when the AP devices are plugged into or unplugged
+ *		 from a guest, and when an ap_matrix_mdev device is added to or
+ *		 removed from @mdev_list or the list is iterated.
  */
 struct ap_matrix_dev {
 	struct device device;
 	atomic_t available_instances;
 	struct ap_config_info info;
 	struct list_head mdev_list;
-	struct mutex lock;
+	struct mutex mdevs_lock;
 	struct ap_driver  *vfio_ap_drv;
+	struct mutex guests_lock;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
-- 
2.31.1

