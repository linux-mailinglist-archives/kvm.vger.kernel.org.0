Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FFAA06CC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfH1P5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1P5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:57:23 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AFE8882EA;
        Wed, 28 Aug 2019 15:57:22 +0000 (UTC)
Received: from localhost (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 148F05C1D6;
        Wed, 28 Aug 2019 15:57:21 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/1] vfio-ccw: add some logging
Date:   Wed, 28 Aug 2019 17:57:16 +0200
Message-Id: <20190828155716.22809-2-cohuck@redhat.com>
In-Reply-To: <20190828155716.22809-1-cohuck@redhat.com>
References: <20190828155716.22809-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 28 Aug 2019 15:57:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usually, the common I/O layer logs various things into the s390
cio debug feature, which has been very helpful in the past when
looking at crash dumps. As vfio-ccw devices unbind from the
standard I/O subchannel driver, we lose some information there.

Let's introduce some vfio-ccw debug features and log some things
there. (Unfortunately we cannot reuse the cio debug feature from
a module.)

Message-Id: <20190816151505.9853-2-cohuck@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 50 ++++++++++++++++++++++++++--
 drivers/s390/cio/vfio_ccw_fsm.c     | 51 ++++++++++++++++++++++++++++-
 drivers/s390/cio/vfio_ccw_ops.c     | 10 ++++++
 drivers/s390/cio/vfio_ccw_private.h | 17 ++++++++++
 4 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9208c0e56c33..45e792f6afd0 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -27,6 +27,9 @@ struct workqueue_struct *vfio_ccw_work_q;
 static struct kmem_cache *vfio_ccw_io_region;
 static struct kmem_cache *vfio_ccw_cmd_region;
 
+debug_info_t *vfio_ccw_debug_msg_id;
+debug_info_t *vfio_ccw_debug_trace_id;
+
 /*
  * Helpers
  */
@@ -164,6 +167,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (ret)
 		goto out_disable;
 
+	VFIO_CCW_MSG_EVENT(4, "bound to subchannel %x.%x.%04x\n",
+			   sch->schid.cssid, sch->schid.ssid,
+			   sch->schid.sch_no);
 	return 0;
 
 out_disable:
@@ -194,6 +200,9 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 	kfree(private->cp.guest_cp);
 	kfree(private);
 
+	VFIO_CCW_MSG_EVENT(4, "unbound from subchannel %x.%x.%04x\n",
+			   sch->schid.cssid, sch->schid.ssid,
+			   sch->schid.sch_no);
 	return 0;
 }
 
@@ -263,13 +272,46 @@ static struct css_driver vfio_ccw_sch_driver = {
 	.sch_event = vfio_ccw_sch_event,
 };
 
+static int __init vfio_ccw_debug_init(void)
+{
+	vfio_ccw_debug_msg_id = debug_register("vfio_ccw_msg", 16, 1,
+					       11 * sizeof(long));
+	if (!vfio_ccw_debug_msg_id)
+		goto out_unregister;
+	debug_register_view(vfio_ccw_debug_msg_id, &debug_sprintf_view);
+	debug_set_level(vfio_ccw_debug_msg_id, 2);
+	vfio_ccw_debug_trace_id = debug_register("vfio_ccw_trace", 16, 1, 16);
+	if (!vfio_ccw_debug_trace_id)
+		goto out_unregister;
+	debug_register_view(vfio_ccw_debug_trace_id, &debug_hex_ascii_view);
+	debug_set_level(vfio_ccw_debug_trace_id, 2);
+	return 0;
+
+out_unregister:
+	debug_unregister(vfio_ccw_debug_msg_id);
+	debug_unregister(vfio_ccw_debug_trace_id);
+	return -1;
+}
+
+static void vfio_ccw_debug_exit(void)
+{
+	debug_unregister(vfio_ccw_debug_msg_id);
+	debug_unregister(vfio_ccw_debug_trace_id);
+}
+
 static int __init vfio_ccw_sch_init(void)
 {
-	int ret = -ENOMEM;
+	int ret;
+
+	ret = vfio_ccw_debug_init();
+	if (ret)
+		return ret;
 
 	vfio_ccw_work_q = create_singlethread_workqueue("vfio-ccw");
-	if (!vfio_ccw_work_q)
-		return -ENOMEM;
+	if (!vfio_ccw_work_q) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
 
 	vfio_ccw_io_region = kmem_cache_create_usercopy("vfio_ccw_io_region",
 					sizeof(struct ccw_io_region), 0,
@@ -298,6 +340,7 @@ static int __init vfio_ccw_sch_init(void)
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	kmem_cache_destroy(vfio_ccw_io_region);
 	destroy_workqueue(vfio_ccw_work_q);
+	vfio_ccw_debug_exit();
 	return ret;
 }
 
@@ -308,6 +351,7 @@ static void __exit vfio_ccw_sch_exit(void)
 	kmem_cache_destroy(vfio_ccw_io_region);
 	kmem_cache_destroy(vfio_ccw_cmd_region);
 	destroy_workqueue(vfio_ccw_work_q);
+	vfio_ccw_debug_exit();
 }
 module_init(vfio_ccw_sch_init);
 module_exit(vfio_ccw_sch_exit);
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 49d9d3da0282..4a1e727c62d9 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -37,9 +37,14 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 		goto out;
 	}
 
+	VFIO_CCW_TRACE_EVENT(5, "stIO");
+	VFIO_CCW_TRACE_EVENT(5, dev_name(&sch->dev));
+
 	/* Issue "Start Subchannel" */
 	ccode = ssch(sch->schid, orb);
 
+	VFIO_CCW_HEX_EVENT(5, &ccode, sizeof(ccode));
+
 	switch (ccode) {
 	case 0:
 		/*
@@ -86,9 +91,14 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
+	VFIO_CCW_TRACE_EVENT(2, "haltIO");
+	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
+
 	/* Issue "Halt Subchannel" */
 	ccode = hsch(sch->schid);
 
+	VFIO_CCW_HEX_EVENT(2, &ccode, sizeof(ccode));
+
 	switch (ccode) {
 	case 0:
 		/*
@@ -122,9 +132,14 @@ static int fsm_do_clear(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
+	VFIO_CCW_TRACE_EVENT(2, "clearIO");
+	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
+
 	/* Issue "Clear Subchannel" */
 	ccode = csch(sch->schid);
 
+	VFIO_CCW_HEX_EVENT(2, &ccode, sizeof(ccode));
+
 	switch (ccode) {
 	case 0:
 		/*
@@ -149,6 +164,9 @@ static void fsm_notoper(struct vfio_ccw_private *private,
 {
 	struct subchannel *sch = private->sch;
 
+	VFIO_CCW_TRACE_EVENT(2, "notoper");
+	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
+
 	/*
 	 * TODO:
 	 * Probably we should send the machine check to the guest.
@@ -229,6 +247,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	struct ccw_io_region *io_region = private->io_region;
 	struct mdev_device *mdev = private->mdev;
 	char *errstr = "request";
+	struct subchannel_id schid = get_schid(private);
 
 	private->state = VFIO_CCW_STATE_CP_PROCESSING;
 	memcpy(scsw, io_region->scsw_area, sizeof(*scsw));
@@ -239,18 +258,32 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		/* Don't try to build a cp if transport mode is specified. */
 		if (orb->tm.b) {
 			io_region->ret_code = -EOPNOTSUPP;
+			VFIO_CCW_MSG_EVENT(2,
+					   "%pUl (%x.%x.%04x): transport mode\n",
+					   mdev_uuid(mdev), schid.cssid,
+					   schid.ssid, schid.sch_no);
 			errstr = "transport mode";
 			goto err_out;
 		}
 		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
 					      orb);
 		if (io_region->ret_code) {
+			VFIO_CCW_MSG_EVENT(2,
+					   "%pUl (%x.%x.%04x): cp_init=%d\n",
+					   mdev_uuid(mdev), schid.cssid,
+					   schid.ssid, schid.sch_no,
+					   io_region->ret_code);
 			errstr = "cp init";
 			goto err_out;
 		}
 
 		io_region->ret_code = cp_prefetch(&private->cp);
 		if (io_region->ret_code) {
+			VFIO_CCW_MSG_EVENT(2,
+					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
+					   mdev_uuid(mdev), schid.cssid,
+					   schid.ssid, schid.sch_no,
+					   io_region->ret_code);
 			errstr = "cp prefetch";
 			cp_free(&private->cp);
 			goto err_out;
@@ -259,23 +292,36 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		/* Start channel program and wait for I/O interrupt. */
 		io_region->ret_code = fsm_io_helper(private);
 		if (io_region->ret_code) {
+			VFIO_CCW_MSG_EVENT(2,
+					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
+					   mdev_uuid(mdev), schid.cssid,
+					   schid.ssid, schid.sch_no,
+					   io_region->ret_code);
 			errstr = "cp fsm_io_helper";
 			cp_free(&private->cp);
 			goto err_out;
 		}
 		return;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
+		VFIO_CCW_MSG_EVENT(2,
+				   "%pUl (%x.%x.%04x): halt on io_region\n",
+				   mdev_uuid(mdev), schid.cssid,
+				   schid.ssid, schid.sch_no);
 		/* halt is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
 		goto err_out;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
+		VFIO_CCW_MSG_EVENT(2,
+				   "%pUl (%x.%x.%04x): clear on io_region\n",
+				   mdev_uuid(mdev), schid.cssid,
+				   schid.ssid, schid.sch_no);
 		/* clear is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
 		goto err_out;
 	}
 
 err_out:
-	trace_vfio_ccw_io_fctl(scsw->cmd.fctl, get_schid(private),
+	trace_vfio_ccw_io_fctl(scsw->cmd.fctl, schid,
 			       io_region->ret_code, errstr);
 }
 
@@ -308,6 +354,9 @@ static void fsm_irq(struct vfio_ccw_private *private,
 {
 	struct irb *irb = this_cpu_ptr(&cio_irb);
 
+	VFIO_CCW_TRACE_EVENT(6, "IRQ");
+	VFIO_CCW_TRACE_EVENT(6, dev_name(&private->sch->dev));
+
 	memcpy(&private->irb, irb, sizeof(*irb));
 
 	queue_work(vfio_ccw_work_q, &private->io_work);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 5eb61116ca6f..f0d71ab77c50 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -124,6 +124,11 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
+	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
+			   mdev_uuid(mdev), private->sch->schid.cssid,
+			   private->sch->schid.ssid,
+			   private->sch->schid.sch_no);
+
 	return 0;
 }
 
@@ -132,6 +137,11 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
 
+	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
+			   mdev_uuid(mdev), private->sch->schid.cssid,
+			   private->sch->schid.ssid,
+			   private->sch->schid.sch_no);
+
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
 		if (!vfio_ccw_sch_quiesce(private->sch))
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index f1092c3dc1b1..bbe9babf767b 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
+#include <asm/debug.h>
 
 #include "css.h"
 #include "vfio_ccw_cp.h"
@@ -139,4 +140,20 @@ static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 
 extern struct workqueue_struct *vfio_ccw_work_q;
 
+
+/* s390 debug feature, similar to base cio */
+extern debug_info_t *vfio_ccw_debug_msg_id;
+extern debug_info_t *vfio_ccw_debug_trace_id;
+
+#define VFIO_CCW_TRACE_EVENT(imp, txt) \
+		debug_text_event(vfio_ccw_debug_trace_id, imp, txt)
+
+#define VFIO_CCW_MSG_EVENT(imp, args...) \
+		debug_sprintf_event(vfio_ccw_debug_msg_id, imp, ##args)
+
+static inline void VFIO_CCW_HEX_EVENT(int level, void *data, int length)
+{
+	debug_event(vfio_ccw_debug_trace_id, level, data, length);
+}
+
 #endif
-- 
2.20.1

