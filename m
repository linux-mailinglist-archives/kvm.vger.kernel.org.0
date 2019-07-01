Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5901A25417
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfEUPfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:35:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728923AbfEUPer (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 11:34:47 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LFSK9m093033
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 11:34:46 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2smjn3cbwf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 11:34:46 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 21 May 2019 16:34:43 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 May 2019 16:34:41 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4LFYehH40108208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 15:34:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E68AAE04D;
        Tue, 21 May 2019 15:34:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F24DAE051;
        Tue, 21 May 2019 15:34:39 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.152.222.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 May 2019 15:34:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
Subject: [PATCH v9 3/4] s390: ap: implement PAPQ AQIC interception in kernel
Date:   Tue, 21 May 2019 17:34:36 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19052115-0012-0000-0000-0000031E026F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052115-0013-0000-0000-00002156B412
Message-Id: <1558452877-27822-4-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We register a AP PQAP instruction hook during the open
of the mediated device. And unregister it on release.

During the probe of the AP device, we allocate a vfio_ap_queue
structure to keep track of the information we need for the
PQAP/AQIC instruction interception.

In the AP PQAP instruction hook, if we receive a demand to
enable IRQs,
- we retrieve the vfio_ap_queue based on the APQN we receive
  in REG1,
- we retrieve the page of the guest address, (NIB), from
  register REG2
- we retrieve the mediated device to use the VFIO pinning
  infrastructure to pin the page of the guest address,
- we retrieve the pointer to KVM to register the guest ISC
  and retrieve the host ISC
- finaly we activate GISA

If we receive a demand to disable IRQs,
- we deactivate GISA
- unregister from the GIB
- unpin the NIB

When removing the AP device from the driver the device is
reseted and this process unregisters the GISA from the GIB,
and unpins the NIB address then we free the vfio_ap_queue
structure.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  34 +++-
 drivers/s390/crypto/vfio_ap_ops.c     | 336 +++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  11 ++
 3 files changed, 374 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index e9824c3..003662a 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -5,6 +5,7 @@
  * Copyright IBM Corp. 2018
  *
  * Author(s): Tony Krowiak <akrowiak@linux.ibm.com>
+ *	      Pierre Morel <pmorel@linux.ibm.com>
  */
 
 #include <linux/module.h>
@@ -40,14 +41,45 @@ static struct ap_device_id ap_queue_ids[] = {
 
 MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 
+/**
+ * vfio_ap_queue_dev_probe:
+ *
+ * Allocate a vfio_ap_queue structure and associate it
+ * with the device as driver_data.
+ */
 static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
 {
+	struct vfio_ap_queue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+	dev_set_drvdata(&apdev->device, q);
+	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
 	return 0;
 }
 
+/**
+ * vfio_ap_queue_dev_remove:
+ *
+ * Takes the matrix lock to avoid actions on this device while removing
+ * Free the associated vfio_ap_queue structure
+ */
 static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 {
-	/* Nothing to do yet */
+	struct vfio_ap_queue *q;
+	int apid, apqi;
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&apdev->device);
+	dev_set_drvdata(&apdev->device, NULL);
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	vfio_ap_irq_disable(q);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
 }
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e8e87bf..015174f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,6 +24,295 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
+static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+
+static int match_apqn(struct device *dev, void *data)
+{
+	struct vfio_ap_queue *q = dev_get_drvdata(dev);
+
+	return (q->apqn == *(int *)(data)) ? 1 : 0;
+}
+
+/**
+ * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
+ * @matrix_mdev: the associated mediated matrix
+ * @apqn: The queue APQN
+ *
+ * Retrieve a queue with a specific APQN from the list of the
+ * devices of the vfio_ap_drv.
+ * Verify that the APID and the APQI are set in the matrix.
+ *
+ * Returns the pointer to the associated vfio_ap_queue
+ */
+struct vfio_ap_queue *vfio_ap_get_queue(struct ap_matrix_mdev *matrix_mdev,
+					int apqn)
+{
+	struct vfio_ap_queue *q;
+	struct device *dev;
+
+	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
+		return NULL;
+	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
+		return NULL;
+
+	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
+				 &apqn, match_apqn);
+	if (!dev)
+		return NULL;
+	q = dev_get_drvdata(dev);
+	q->matrix_mdev = matrix_mdev;
+	put_device(dev);
+
+	return q;
+}
+
+/**
+ * vfio_ap_wait_for_irqclear
+ * @apqn: The AP Queue number
+ *
+ * Checks the IRQ bit for the status of this APQN using ap_tapq.
+ * Returns if the ap_tapq function succedded and the bit is clear.
+ * Returns if ap_tapq function failed with invalid, deconfigured or
+ * checkstopped AP.
+ * Otherwise retries up to 5 times after waiting 20ms.
+ *
+ */
+static void vfio_ap_wait_for_irqclear(int apqn)
+{
+	struct ap_queue_status status;
+	int retry = 5;
+
+	do {
+		status = ap_tapq(apqn, NULL);
+		switch (status.response_code) {
+		case AP_RESPONSE_NORMAL:
+		case AP_RESPONSE_RESET_IN_PROGRESS:
+			if (!status.irq_enabled)
+				return;
+			/* Fall through */
+		case AP_RESPONSE_BUSY:
+			msleep(20);
+			break;
+		case AP_RESPONSE_Q_NOT_AVAIL:
+		case AP_RESPONSE_DECONFIGURED:
+		case AP_RESPONSE_CHECKSTOPPED:
+		default:
+			WARN_ONCE(1, "%s: tapq rc %02x: %04x\n", __func__,
+				  status.response_code, apqn);
+			return;
+		}
+	} while (--retry);
+
+	WARN_ONCE(1, "%s: tapq rc %02x: %04x could not clear IR bit\n",
+		  __func__, status.response_code, apqn);
+}
+
+/**
+ * vfio_ap_free_aqic_resources
+ * @q: The vfio_ap_queue
+ *
+ * Unregisters the ISC in the GIB when the saved ISC not invalid.
+ * Unpin the guest's page holding the NIB when it exist.
+ * Reset the saved_pfn and saved_isc to invalid values.
+ * Clear the pointer to the matrix mediated device.
+ *
+ */
+static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
+{
+	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
+		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
+	if (q->saved_pfn && q->matrix_mdev)
+		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
+				 &q->saved_pfn, 1);
+	q->saved_pfn = 0;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+	q->matrix_mdev = NULL;
+}
+
+/**
+ * vfio_ap_irq_disable
+ * @q: The vfio_ap_queue
+ *
+ * Uses ap_aqic to disable the interruption and in case of success, reset
+ * in progress or IRQ disable command already proceeded: calls
+ * vfio_ap_wait_for_irqclear() to check for the IRQ bit to be clear
+ * and calls vfio_ap_free_aqic_resources() to free the resources associated
+ * with the AP interrupt handling.
+ *
+ * In the case the AP is busy, or a reset is in progress,
+ * retries after 20ms, up to 5 times.
+ *
+ * Returns if ap_aqic function failed with invalid, deconfigured or
+ * checkstopped AP.
+ */
+struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+{
+	struct ap_qirq_ctrl aqic_gisa = {};
+	struct ap_queue_status status;
+	int retries = 5;
+
+	do {
+		status = ap_aqic(q->apqn, aqic_gisa, NULL);
+		switch (status.response_code) {
+		case AP_RESPONSE_OTHERWISE_CHANGED:
+		case AP_RESPONSE_NORMAL:
+			vfio_ap_wait_for_irqclear(q->apqn);
+			goto end_free;
+		case AP_RESPONSE_RESET_IN_PROGRESS:
+		case AP_RESPONSE_BUSY:
+			msleep(20);
+			break;
+		case AP_RESPONSE_Q_NOT_AVAIL:
+		case AP_RESPONSE_DECONFIGURED:
+		case AP_RESPONSE_CHECKSTOPPED:
+		case AP_RESPONSE_INVALID_ADDRESS:
+		default:
+			/* All cases in default means AP not operational */
+			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
+				  status.response_code);
+			goto end_free;
+		}
+	} while (retries--);
+
+	WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
+		  status.response_code);
+end_free:
+	vfio_ap_free_aqic_resources(q);
+	return status;
+}
+
+/**
+ * vfio_ap_setirq: Enable Interruption for a APQN
+ *
+ * @dev: the device associated with the ap_queue
+ * @q:   the vfio_ap_queue holding AQIC parameters
+ *
+ * Pin the NIB saved in *q
+ * Register the guest ISC to GIB interface and retrieve the
+ * host ISC to issue the host side PQAP/AQIC
+ *
+ * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
+ * vfio_pin_pages failed.
+ *
+ * Otherwise return the ap_queue_status returned by the ap_aqic(),
+ * all retry handling will be done by the guest.
+ */
+static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
+						 int isc,
+						 unsigned long nib)
+{
+	struct ap_qirq_ctrl aqic_gisa = {};
+	struct ap_queue_status status = {};
+	struct kvm_s390_gisa *gisa;
+	struct kvm *kvm;
+	unsigned long h_nib, g_pfn, h_pfn;
+	int ret;
+
+	g_pfn = nib >> PAGE_SHIFT;
+	ret = vfio_pin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1,
+			     IOMMU_READ | IOMMU_WRITE, &h_pfn);
+	switch (ret) {
+	case 1:
+		break;
+	default:
+		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
+		return status;
+	}
+
+	kvm = q->matrix_mdev->kvm;
+	gisa = kvm->arch.gisa_int.origin;
+
+	h_nib = (h_pfn << PAGE_SHIFT) | (nib & ~PAGE_MASK);
+	aqic_gisa.gisc = isc;
+	aqic_gisa.isc = kvm_s390_gisc_register(kvm, isc);
+	aqic_gisa.ir = 1;
+	aqic_gisa.gisa = (uint64_t)gisa >> 4;
+
+	status = ap_aqic(q->apqn, aqic_gisa, (void *)h_nib);
+	switch (status.response_code) {
+	case AP_RESPONSE_NORMAL:
+		/* See if we did clear older IRQ configuration */
+		vfio_ap_free_aqic_resources(q);
+		q->saved_pfn = g_pfn;
+		q->saved_isc = isc;
+		break;
+	case AP_RESPONSE_OTHERWISE_CHANGED:
+		/* We could not modify IRQ setings: clear new configuration */
+		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1);
+		kvm_s390_gisc_unregister(kvm, isc);
+		break;
+	default:
+		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
+			status.response_code);
+		vfio_ap_irq_disable(q);
+		break;
+	}
+
+	return status;
+}
+
+/**
+ * handle_pqap: PQAP instruction callback
+ *
+ * @vcpu: The vcpu on which we received the PQAP instruction
+ *
+ * Get the general register contents to initialize internal variables.
+ * REG[0]: APQN
+ * REG[1]: IR and ISC
+ * REG[2]: NIB
+ *
+ * Response.status may be set to following Response Code:
+ * - AP_RESPONSE_Q_NOT_AVAIL: if the queue is not available
+ * - AP_RESPONSE_DECONFIGURED: if the queue is not configured
+ * - AP_RESPONSE_NORMAL (0) : in case of successs
+ *   Check vfio_ap_setirq() and vfio_ap_clrirq() for other possible RC.
+ * We take the matrix_dev lock to ensure serialization on queues and
+ * mediated device access.
+ *
+ * Return 0 if we could handle the request inside KVM.
+ * otherwise, returns -EOPNOTSUPP to let QEMU handle the fault.
+ */
+static int handle_pqap(struct kvm_vcpu *vcpu)
+{
+	uint64_t status;
+	uint16_t apqn;
+	struct vfio_ap_queue *q;
+	struct ap_queue_status qstatus = {
+			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
+	struct ap_matrix_mdev *matrix_mdev;
+
+	/* If we do not use the AIV facility just go to userland */
+	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
+		return -EOPNOTSUPP;
+
+	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
+	mutex_lock(&matrix_dev->lock);
+
+	if (!vcpu->kvm->arch.crypto.pqap_hook)
+		goto out_unlock;
+	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
+				   struct ap_matrix_mdev, pqap_hook);
+
+	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	if (!q)
+		goto out_unlock;
+
+	status = vcpu->run->s.regs.gprs[1];
+
+	/* If IR bit(16) is set we enable the interrupt */
+	if ((status >> (63 - 16)) & 0x01)
+		qstatus = vfio_ap_irq_enable(q, status & 0x07,
+					     vcpu->run->s.regs.gprs[2]);
+	else
+		qstatus = vfio_ap_irq_disable(q);
+
+out_unlock:
+	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
+	vcpu->run->s.regs.gprs[1] >>= 32;
+	mutex_unlock(&matrix_dev->lock);
+	return 0;
+}
+
 static void vfio_ap_matrix_init(struct ap_config_info *info,
 				struct ap_matrix *matrix)
 {
@@ -45,8 +334,11 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 		return -ENOMEM;
 	}
 
+	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	mdev_set_drvdata(mdev, matrix_mdev);
+	matrix_mdev->pqap_hook.hook = handle_pqap;
+	matrix_mdev->pqap_hook.owner = THIS_MODULE;
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
@@ -62,6 +354,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 		return -EBUSY;
 
 	mutex_lock(&matrix_dev->lock);
+	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -754,6 +1047,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	}
 
 	matrix_mdev->kvm = kvm;
+	kvm_get_kvm(kvm);
+	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
@@ -819,15 +1114,36 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-				    unsigned int retry)
+static void vfio_ap_irq_disable_apqn(int apqn)
+{
+	struct device *dev;
+	struct vfio_ap_queue *q;
+
+	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
+				 &apqn, match_apqn);
+	if (dev) {
+		q = dev_get_drvdata(dev);
+		vfio_ap_irq_disable(q);
+		put_device(dev);
+	}
+}
+
+int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
+			     unsigned int retry)
 {
 	struct ap_queue_status status;
+	int retry2 = 2;
+	int apqn = AP_MKQID(apid, apqi);
 
 	do {
-		status = ap_zapq(AP_MKQID(apid, apqi));
+		status = ap_zapq(apqn);
 		switch (status.response_code) {
 		case AP_RESPONSE_NORMAL:
+			while (!status.queue_empty && retry2--) {
+				msleep(20);
+				status = ap_tapq(apqn, NULL);
+			}
+			WARN_ON_ONCE(retry <= 0);
 			return 0;
 		case AP_RESPONSE_RESET_IN_PROGRESS:
 		case AP_RESPONSE_BUSY:
@@ -861,6 +1177,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			 */
 			if (ret)
 				rc = ret;
+			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
 	}
 
@@ -904,15 +1221,20 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	if (matrix_mdev->kvm)
+	mutex_lock(&matrix_dev->lock);
+	if (matrix_mdev->kvm) {
 		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+		vfio_ap_mdev_reset_queues(mdev);
+		kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+	}
+	mutex_unlock(&matrix_dev->lock);
 
-	vfio_ap_mdev_reset_queues(mdev);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
-	matrix_mdev->kvm = NULL;
 	module_put(THIS_MODULE);
 }
 
@@ -941,6 +1263,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 {
 	int ret;
 
+	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		ret = vfio_ap_mdev_get_device_info(arg);
@@ -952,6 +1275,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
+	mutex_unlock(&matrix_dev->lock);
 
 	return ret;
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 18dcc4d..f46dde5 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -4,6 +4,7 @@
  *
  * Author(s): Tony Krowiak <akrowiak@linux.ibm.com>
  *	      Halil Pasic <pasic@linux.ibm.com>
+ *	      Pierre Morel <pmorel@linux.ibm.com>
  *
  * Copyright IBM Corp. 2018
  */
@@ -89,5 +90,15 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
+int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
+			     unsigned int retry);
 
+struct vfio_ap_queue {
+	struct ap_matrix_mdev *matrix_mdev;
+	unsigned long saved_pfn;
+	int	apqn;
+#define VFIO_AP_ISC_INVALID 0xff
+	unsigned char saved_isc;
+};
+struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.7.4

