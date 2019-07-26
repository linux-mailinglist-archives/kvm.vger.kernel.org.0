Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4297631A
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfGZKGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 06:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfGZKGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 06:06:22 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23E8081134;
        Fri, 26 Jul 2019 10:06:22 +0000 (UTC)
Received: from localhost (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1339600C4;
        Fri, 26 Jul 2019 10:06:21 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated cps
Date:   Fri, 26 Jul 2019 12:06:17 +0200
Message-Id: <20190726100617.19718-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 26 Jul 2019 10:06:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're currently keeping a single area for translated channel
programs in our private structure, which is filled out when
we are translating a channel program we have been given by
user space and marked invalid again when we received an final
interrupt for that I/O.

Unfortunately, properly tracking the lifetime of that cp is
not easy: failures may happen during translation or right when
it is sent to the hardware, unsolicited interrupts may trigger
a deferred condition code, a halt/clear request may be issued
while the I/O is supposed to be running, or a reset request may
come in from the side. The _PROCESSING state and the ->initialized
flag help a bit, but not enough.

We want to have a way to figure out whether we actually have a cp
currently in progress, so we can update/free only when applicable.
Points to keep in mind:
- We will get an interrupt after a cp has been submitted iff ssch
  finished with cc 0.
- We will get more interrupts for a cp if the interrupt status is
  not final.
- We can have only one cp in flight at a time.

Let's decouple the actual area in the private structure from the
means to access it: Only after we have successfully submitted a
cp (ssch with cc 0), update the pointer in the private structure
to point to the area used. Therefore, the interrupt handler won't
access the cp if we don't actually expect an interrupt pertaining
to it.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---

Just hacked this up to get some feedback, did not actually try it
out. Not even sure if this is a sensible approach; if not, let's
blame it on the heat and pretend it didn't happen :)

I also thought about having *two* translation areas and switching
the pointer between them; this might be too complicated, though?

---
 drivers/s390/cio/vfio_ccw_drv.c     | 19 +++++++++++--------
 drivers/s390/cio/vfio_ccw_fsm.c     | 25 +++++++++++++++++--------
 drivers/s390/cio/vfio_ccw_ops.c     | 11 +++++++----
 drivers/s390/cio/vfio_ccw_private.h |  6 ++++--
 4 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9208c0e56c33..059b88c94378 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -86,10 +86,13 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 
 	is_final = !(scsw_actl(&irb->scsw) &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
-	if (scsw_is_solicited(&irb->scsw)) {
-		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
-			cp_free(&private->cp);
+	if (scsw_is_solicited(&irb->scsw) && private->cp) {
+		cp_update_scsw(private->cp, &irb->scsw);
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
+			struct channel_program *cp = private->cp;
+			private->cp = NULL;
+			cp_free(cp);
+		}
 	}
 	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
@@ -129,9 +132,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (!private)
 		return -ENOMEM;
 
-	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
+	private->cp_area.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
 				       GFP_KERNEL);
-	if (!private->cp.guest_cp)
+	if (!private->cp_area.guest_cp)
 		goto out_free;
 
 	private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
@@ -174,7 +177,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
 	if (private->io_region)
 		kmem_cache_free(vfio_ccw_io_region, private->io_region);
-	kfree(private->cp.guest_cp);
+	kfree(private->cp_area.guest_cp);
 	kfree(private);
 	return ret;
 }
@@ -191,7 +194,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 
 	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
 	kmem_cache_free(vfio_ccw_io_region, private->io_region);
-	kfree(private->cp.guest_cp);
+	kfree(private->cp_area.guest_cp);
 	kfree(private);
 
 	return 0;
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 49d9d3da0282..543d007ddc46 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -18,7 +18,8 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
 
-static int fsm_io_helper(struct vfio_ccw_private *private)
+static int fsm_io_helper(struct vfio_ccw_private *private,
+			 struct channel_program *cp)
 {
 	struct subchannel *sch;
 	union orb *orb;
@@ -31,7 +32,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
-	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
+	orb = cp_get_orb(cp, (u32)(addr_t)sch, sch->lpm);
 	if (!orb) {
 		ret = -EIO;
 		goto out;
@@ -47,6 +48,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 		 */
 		sch->schib.scsw.cmd.actl |= SCSW_ACTL_START_PEND;
 		ret = 0;
+		private->cp = cp;
 		private->state = VFIO_CCW_STATE_CP_PENDING;
 		break;
 	case 1:		/* Status pending */
@@ -236,31 +238,38 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	if (scsw->cmd.fctl & SCSW_FCTL_START_FUNC) {
 		orb = (union orb *)io_region->orb_area;
 
+		/* I/O already in progress? Should not happen (bug in FSM?). */
+		if (private->cp) {
+			io_region->ret_code = -EBUSY;
+			errstr = "cp in progress";
+			goto err_out;
+		}
 		/* Don't try to build a cp if transport mode is specified. */
 		if (orb->tm.b) {
 			io_region->ret_code = -EOPNOTSUPP;
 			errstr = "transport mode";
 			goto err_out;
 		}
-		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
-					      orb);
+		io_region->ret_code = cp_init(&private->cp_area,
+					      mdev_dev(mdev), orb);
 		if (io_region->ret_code) {
 			errstr = "cp init";
 			goto err_out;
 		}
 
-		io_region->ret_code = cp_prefetch(&private->cp);
+		io_region->ret_code = cp_prefetch(&private->cp_area);
 		if (io_region->ret_code) {
 			errstr = "cp prefetch";
-			cp_free(&private->cp);
+			cp_free(&private->cp_area);
 			goto err_out;
 		}
 
 		/* Start channel program and wait for I/O interrupt. */
-		io_region->ret_code = fsm_io_helper(private);
+		io_region->ret_code = fsm_io_helper(private,
+						    &private->cp_area);
 		if (io_region->ret_code) {
 			errstr = "cp fsm_io_helper";
-			cp_free(&private->cp);
+			cp_free(&private->cp_area);
 			goto err_out;
 		}
 		return;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 5eb61116ca6f..5ad6a7b672bd 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -58,13 +58,14 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
 	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
 		struct vfio_iommu_type1_dma_unmap *unmap = data;
 
-		if (!cp_iova_pinned(&private->cp, unmap->iova))
+		if (!cp_iova_pinned(&private->cp_area, unmap->iova))
 			return NOTIFY_OK;
 
 		if (vfio_ccw_mdev_reset(private->mdev))
 			return NOTIFY_BAD;
 
-		cp_free(&private->cp);
+		private->cp = NULL;
+		cp_free(&private->cp_area);
 		return NOTIFY_OK;
 	}
 
@@ -139,7 +140,8 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 		/* The state will be NOT_OPER on error. */
 	}
 
-	cp_free(&private->cp);
+	private->cp = NULL;
+	cp_free(&private->cp_area);
 	private->mdev = NULL;
 	atomic_inc(&private->avail);
 
@@ -180,7 +182,8 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 		/* The state will be NOT_OPER on error. */
 	}
 
-	cp_free(&private->cp);
+	private->cp = NULL;
+	cp_free(&private->cp_area);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index f1092c3dc1b1..e792a20202c3 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -68,7 +68,8 @@ int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
  * @region: additional regions for other subchannel operations
  * @cmd_region: MMIO region for asynchronous I/O commands other than START
  * @num_regions: number of additional regions
- * @cp: channel program for the current I/O operation
+ * @cp_area: channel program memory area
+ * @cp: pointer to channel program for the current I/O operation
  * @irb: irb info received from interrupt
  * @scsw: scsw info
  * @io_trigger: eventfd ctx for signaling userspace I/O results
@@ -87,7 +88,8 @@ struct vfio_ccw_private {
 	struct ccw_cmd_region	*cmd_region;
 	int num_regions;
 
-	struct channel_program	cp;
+	struct channel_program cp_area;
+	struct channel_program	*cp;
 	struct irb		irb;
 	union scsw		scsw;
 
-- 
2.20.1

