Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A859252A1B
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 11:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgHZJeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 05:34:06 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42192 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728052AbgHZJd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 05:33:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0A571A08B7;
        Wed, 26 Aug 2020 11:33:54 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B3FDC1A08F4;
        Wed, 26 Aug 2020 11:33:54 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6842C2030A;
        Wed, 26 Aug 2020 11:33:54 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v4 08/10] vfio/fsl-mc: trigger an interrupt via eventfd
Date:   Wed, 26 Aug 2020 12:33:13 +0300
Message-Id: <20200826093315.5279-9-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows to set an eventfd for fsl-mc device interrupts
and also to trigger the interrupt eventfd from userspace for testing.

All fsl-mc device interrupts are MSIs. The MSIs are allocated from
the MSI domain only once per DPRC and used by all the DPAA2 objects.
The interrupts are managed by the DPRC in a pool of interrupts. Each
device requests interrupts from this pool. The pool is allocated
when the first virtual device is setting the interrupts.
The pool of interrupts is protected by a lock.

The DPRC has an interrupt of its own which indicates if the DPRC
contents have changed. However, currently, the contents of a DPRC
assigned to the guest cannot be changed at runtime, so this interrupt
is not configured.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         |  18 ++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 160 +++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  10 ++
 3 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 42014297b484..73834f488a94 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -147,12 +147,28 @@ static int vfio_fsl_mc_open(void *device_data)
 static void vfio_fsl_mc_release(void *device_data)
 {
 	struct vfio_fsl_mc_device *vdev = device_data;
+	int ret;
 
 	mutex_lock(&vdev->reflck->lock);
 
-	if (!(--vdev->refcnt))
+	if (!(--vdev->refcnt)) {
+		struct fsl_mc_device *mc_dev = vdev->mc_dev;
+		struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
+		struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
+
 		vfio_fsl_mc_regions_cleanup(vdev);
 
+		/* reset the device before cleaning up the interrupts */
+		ret = dprc_reset_container(mc_cont->mc_io, 0,
+		      mc_cont->mc_handle,
+			  mc_cont->obj_desc.id,
+			  DPRC_RESET_OPTION_NON_RECURSIVE);
+
+		vfio_fsl_mc_irqs_cleanup(vdev);
+
+		fsl_mc_cleanup_irq_pool(mc_cont);
+	}
+
 	mutex_unlock(&vdev->reflck->lock);
 
 	module_put(THIS_MODULE);
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index 058aa97aa54a..409f3507fcf3 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -29,12 +29,149 @@ static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
 	return -EINVAL;
 }
 
+int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	struct vfio_fsl_mc_irq *mc_irq;
+	int irq_count;
+	int ret, i;
+
+    /* Device does not support any interrupt */
+	if (mc_dev->obj_desc.irq_count == 0)
+		return 0;
+
+	/* interrupts were already allocated for this device */
+	if (vdev->mc_irqs)
+		return 0;
+
+	irq_count = mc_dev->obj_desc.irq_count;
+
+	mc_irq = kcalloc(irq_count, sizeof(*mc_irq), GFP_KERNEL);
+	if (!mc_irq)
+		return -ENOMEM;
+
+	/* Allocate IRQs */
+	ret = fsl_mc_allocate_irqs(mc_dev);
+	if (ret) {
+		kfree(mc_irq);
+		return ret;
+	}
+
+	for (i = 0; i < irq_count; i++) {
+		mc_irq[i].count = 1;
+		mc_irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
+	}
+
+	vdev->mc_irqs = mc_irq;
+
+	return 0;
+}
+
+static irqreturn_t vfio_fsl_mc_irq_handler(int irq_num, void *arg)
+{
+	struct vfio_fsl_mc_irq *mc_irq = (struct vfio_fsl_mc_irq *)arg;
+
+	eventfd_signal(mc_irq->trigger, 1);
+	return IRQ_HANDLED;
+}
+
+static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
+						   int index, int fd)
+{
+	struct vfio_fsl_mc_irq *irq = &vdev->mc_irqs[index];
+	struct eventfd_ctx *trigger;
+	int hwirq;
+	int ret;
+
+	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
+	if (irq->trigger) {
+		free_irq(hwirq, irq);
+		kfree(irq->name);
+		eventfd_ctx_put(irq->trigger);
+		irq->trigger = NULL;
+	}
+
+	if (fd < 0) /* Disable only */
+		return 0;
+
+	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
+			    hwirq, dev_name(&vdev->mc_dev->dev));
+	if (!irq->name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(irq->name);
+		return PTR_ERR(trigger);
+	}
+
+	irq->trigger = trigger;
+
+	ret = request_irq(hwirq, vfio_fsl_mc_irq_handler, 0,
+		  irq->name, irq);
+	if (ret) {
+		kfree(irq->name);
+		eventfd_ctx_put(trigger);
+		irq->trigger = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
 static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 				       unsigned int index, unsigned int start,
 				       unsigned int count, u32 flags,
 				       void *data)
 {
-	return -EINVAL;
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int ret, hwirq;
+	struct vfio_fsl_mc_irq *irq;
+	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
+	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	mutex_lock(&vdev->reflck->lock);
+	ret = fsl_mc_populate_irq_pool(mc_cont,
+			FSL_MC_IRQ_POOL_MAX_TOTAL_IRQS);
+	if (ret)
+		goto unlock;
+
+	ret = vfio_fsl_mc_irqs_allocate(vdev);
+	if (ret)
+		goto unlock;
+	mutex_unlock(&vdev->reflck->lock);
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
+		return vfio_set_trigger(vdev, index, -1);
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		s32 fd = *(s32 *)data;
+
+		return vfio_set_trigger(vdev, index, fd);
+	}
+
+	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
+
+	irq = &vdev->mc_irqs[index];
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_fsl_mc_irq_handler(hwirq, irq);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		u8 trigger = *(u8 *)data;
+
+		if (trigger)
+			vfio_fsl_mc_irq_handler(hwirq, irq);
+	}
+
+	return 0;
+
+unlock:
+	mutex_unlock(&vdev->reflck->lock);
+	return ret;
 }
 
 int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
@@ -61,3 +198,24 @@ int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
 
 	return ret;
 }
+
+/* Free All IRQs for the given MC object */
+void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int irq_count = mc_dev->obj_desc.irq_count;
+	int i;
+
+	/* Device does not support any interrupt or the interrupts
+	 * were not configured
+	 */
+	if (mc_dev->obj_desc.irq_count == 0 || !vdev->mc_irqs)
+		return;
+
+	for (i = 0; i < irq_count; i++)
+		vfio_set_trigger(vdev, i, -1);
+
+	fsl_mc_free_irqs(mc_dev);
+	kfree(vdev->mc_irqs);
+	vdev->mc_irqs = NULL;
+}
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index d5b6fe891a48..bbfca8b55f8a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -15,6 +15,13 @@
 #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
 	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
 
+struct vfio_fsl_mc_irq {
+	u32         flags;
+	u32         count;
+	struct eventfd_ctx  *trigger;
+	char            *name;
+};
+
 struct vfio_fsl_mc_reflck {
 	struct kref		kref;
 	struct mutex		lock;
@@ -35,6 +42,7 @@ struct vfio_fsl_mc_device {
 	struct vfio_fsl_mc_region	*regions;
 	struct vfio_fsl_mc_reflck   *reflck;
 	struct mutex         igate;
+	struct vfio_fsl_mc_irq      *mc_irqs;
 };
 
 extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
@@ -42,4 +50,6 @@ extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
 			       unsigned int start, unsigned int count,
 			       void *data);
 
+void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev);
+
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

