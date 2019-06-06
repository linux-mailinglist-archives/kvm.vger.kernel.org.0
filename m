Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA8637364
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfFFLvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:51:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727110AbfFFLvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 07:51:48 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56BmX9n136379
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 07:51:45 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy20ugxqk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 07:51:44 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 6 Jun 2019 12:51:43 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 12:51:39 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56Bpc2Y25493566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 11:51:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA5D5AE053;
        Thu,  6 Jun 2019 11:51:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3533DAE056;
        Thu,  6 Jun 2019 11:51:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 11:51:37 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: [PATCH v4 3/8] s390/cio: add basic protected virtualization support
Date:   Thu,  6 Jun 2019 13:51:22 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606115127.55519-1-pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060611-0028-0000-0000-000003777ECC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060611-0029-0000-0000-000024375E80
Message-Id: <20190606115127.55519-4-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As virtio-ccw devices are channel devices, we need to use the
dma area within the common I/O layer for any communication with
the hypervisor.

Note that we do not need to use that area for control blocks
directly referenced by instructions, e.g. the orb.

It handles neither QDIO in the common code, nor any device type specific
stuff (like channel programs constructed by the DASD driver).

An interesting side effect is that virtio structures are now going to
get allocated in 31 bit addressable storage.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/include/asm/ccwdev.h   |  4 ++
 drivers/s390/cio/ccwreq.c        |  9 +++--
 drivers/s390/cio/device.c        | 68 ++++++++++++++++++++++++++------
 drivers/s390/cio/device_fsm.c    | 49 +++++++++++++----------
 drivers/s390/cio/device_id.c     | 20 +++++-----
 drivers/s390/cio/device_ops.c    | 21 +++++++++-
 drivers/s390/cio/device_pgid.c   | 22 ++++++-----
 drivers/s390/cio/device_status.c | 24 +++++------
 drivers/s390/cio/io_sch.h        | 20 +++++++---
 drivers/s390/virtio/virtio_ccw.c | 10 -----
 10 files changed, 164 insertions(+), 83 deletions(-)

diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
index a29dd430fb40..865ce1cb86d5 100644
--- a/arch/s390/include/asm/ccwdev.h
+++ b/arch/s390/include/asm/ccwdev.h
@@ -226,6 +226,10 @@ extern int ccw_device_enable_console(struct ccw_device *);
 extern void ccw_device_wait_idle(struct ccw_device *);
 extern int ccw_device_force_console(struct ccw_device *);
 
+extern void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size);
+extern void ccw_device_dma_free(struct ccw_device *cdev,
+				void *cpu_addr, size_t size);
+
 int ccw_device_siosl(struct ccw_device *);
 
 extern void ccw_device_get_schid(struct ccw_device *, struct subchannel_id *);
diff --git a/drivers/s390/cio/ccwreq.c b/drivers/s390/cio/ccwreq.c
index 603268a33ea1..73582a0a2622 100644
--- a/drivers/s390/cio/ccwreq.c
+++ b/drivers/s390/cio/ccwreq.c
@@ -63,7 +63,7 @@ static void ccwreq_stop(struct ccw_device *cdev, int rc)
 		return;
 	req->done = 1;
 	ccw_device_set_timeout(cdev, 0);
-	memset(&cdev->private->irb, 0, sizeof(struct irb));
+	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 	if (rc && rc != -ENODEV && req->drc)
 		rc = req->drc;
 	req->callback(cdev, req->data, rc);
@@ -86,7 +86,7 @@ static void ccwreq_do(struct ccw_device *cdev)
 			continue;
 		}
 		/* Perform start function. */
-		memset(&cdev->private->irb, 0, sizeof(struct irb));
+		memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 		rc = cio_start(sch, cp, (u8) req->mask);
 		if (rc == 0) {
 			/* I/O started successfully. */
@@ -169,7 +169,7 @@ int ccw_request_cancel(struct ccw_device *cdev)
  */
 static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
 {
-	struct irb *irb = &cdev->private->irb;
+	struct irb *irb = &cdev->private->dma_area->irb;
 	struct cmd_scsw *scsw = &irb->scsw.cmd;
 	enum uc_todo todo;
 
@@ -187,7 +187,8 @@ static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
 		CIO_TRACE_EVENT(2, "sensedata");
 		CIO_HEX_EVENT(2, &cdev->private->dev_id,
 			      sizeof(struct ccw_dev_id));
-		CIO_HEX_EVENT(2, &cdev->private->irb.ecw, SENSE_MAX_COUNT);
+		CIO_HEX_EVENT(2, &cdev->private->dma_area->irb.ecw,
+			      SENSE_MAX_COUNT);
 		/* Check for command reject. */
 		if (irb->ecw[0] & SNS0_CMD_REJECT)
 			return IO_REJECTED;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 1540229a37bb..6a3a14097ab9 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -24,6 +24,7 @@
 #include <linux/timer.h>
 #include <linux/kernel_stat.h>
 #include <linux/sched/signal.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
@@ -687,6 +688,9 @@ ccw_device_release(struct device *dev)
 	struct ccw_device *cdev;
 
 	cdev = to_ccwdev(dev);
+	cio_gp_dma_free(cdev->private->dma_pool, cdev->private->dma_area,
+			sizeof(*cdev->private->dma_area));
+	cio_gp_dma_destroy(cdev->private->dma_pool, &cdev->dev);
 	/* Release reference of parent subchannel. */
 	put_device(cdev->dev.parent);
 	kfree(cdev->private);
@@ -696,15 +700,33 @@ ccw_device_release(struct device *dev)
 static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
 {
 	struct ccw_device *cdev;
+	struct gen_pool *dma_pool;
 
 	cdev  = kzalloc(sizeof(*cdev), GFP_KERNEL);
-	if (cdev) {
-		cdev->private = kzalloc(sizeof(struct ccw_device_private),
-					GFP_KERNEL | GFP_DMA);
-		if (cdev->private)
-			return cdev;
-	}
+	if (!cdev)
+		goto err_cdev;
+	cdev->private = kzalloc(sizeof(struct ccw_device_private),
+				GFP_KERNEL | GFP_DMA);
+	if (!cdev->private)
+		goto err_priv;
+	cdev->dev.coherent_dma_mask = sch->dev.coherent_dma_mask;
+	cdev->dev.dma_mask = &cdev->dev.coherent_dma_mask;
+	dma_pool = cio_gp_dma_create(&cdev->dev, 1);
+	if (!dma_pool)
+		goto err_dma_pool;
+	cdev->private->dma_pool = dma_pool;
+	cdev->private->dma_area = cio_gp_dma_zalloc(dma_pool, &cdev->dev,
+					sizeof(*cdev->private->dma_area));
+	if (!cdev->private->dma_area)
+		goto err_dma_area;
+	return cdev;
+err_dma_area:
+	cio_gp_dma_destroy(dma_pool, &cdev->dev);
+err_dma_pool:
+	kfree(cdev->private);
+err_priv:
 	kfree(cdev);
+err_cdev:
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -884,7 +906,7 @@ io_subchannel_recog_done(struct ccw_device *cdev)
 			wake_up(&ccw_device_init_wq);
 		break;
 	case DEV_STATE_OFFLINE:
-		/* 
+		/*
 		 * We can't register the device in interrupt context so
 		 * we schedule a work item.
 		 */
@@ -1062,6 +1084,14 @@ static int io_subchannel_probe(struct subchannel *sch)
 	if (!io_priv)
 		goto out_schedule;
 
+	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
+				sizeof(*io_priv->dma_area),
+				&io_priv->dma_area_dma, GFP_KERNEL);
+	if (!io_priv->dma_area) {
+		kfree(io_priv);
+		goto out_schedule;
+	}
+
 	set_io_private(sch, io_priv);
 	css_schedule_eval(sch->schid);
 	return 0;
@@ -1088,6 +1118,8 @@ static int io_subchannel_remove(struct subchannel *sch)
 	set_io_private(sch, NULL);
 	spin_unlock_irq(sch->lock);
 out_free:
+	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
+			  io_priv->dma_area, io_priv->dma_area_dma);
 	kfree(io_priv);
 	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
 	return 0;
@@ -1593,20 +1625,32 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
 		return ERR_CAST(sch);
 
 	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
-	if (!io_priv) {
-		put_device(&sch->dev);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!io_priv)
+		goto err_priv;
+	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
+				sizeof(*io_priv->dma_area),
+				&io_priv->dma_area_dma, GFP_KERNEL);
+	if (!io_priv->dma_area)
+		goto err_dma_area;
 	set_io_private(sch, io_priv);
 	cdev = io_subchannel_create_ccwdev(sch);
 	if (IS_ERR(cdev)) {
 		put_device(&sch->dev);
+		dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
+				  io_priv->dma_area, io_priv->dma_area_dma);
+		set_io_private(sch, NULL);
 		kfree(io_priv);
 		return cdev;
 	}
 	cdev->drv = drv;
 	ccw_device_set_int_class(cdev);
 	return cdev;
+
+err_dma_area:
+	kfree(io_priv);
+err_priv:
+	put_device(&sch->dev);
+	return ERR_PTR(-ENOMEM);
 }
 
 void __init ccw_device_destroy_console(struct ccw_device *cdev)
@@ -1617,6 +1661,8 @@ void __init ccw_device_destroy_console(struct ccw_device *cdev)
 	set_io_private(sch, NULL);
 	put_device(&sch->dev);
 	put_device(&cdev->dev);
+	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
+			  io_priv->dma_area, io_priv->dma_area_dma);
 	kfree(io_priv);
 }
 
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index 9169af7dbb43..8fc267324ebb 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -67,8 +67,10 @@ static void ccw_timeout_log(struct ccw_device *cdev)
 			       sizeof(struct tcw), 0);
 	} else {
 		printk(KERN_WARNING "cio: orb indicates command mode\n");
-		if ((void *)(addr_t)orb->cmd.cpa == &private->sense_ccw ||
-		    (void *)(addr_t)orb->cmd.cpa == cdev->private->iccws)
+		if ((void *)(addr_t)orb->cmd.cpa ==
+		    &private->dma_area->sense_ccw ||
+		    (void *)(addr_t)orb->cmd.cpa ==
+		    cdev->private->dma_area->iccws)
 			printk(KERN_WARNING "cio: last channel program "
 			       "(intern):\n");
 		else
@@ -143,18 +145,22 @@ ccw_device_cancel_halt_clear(struct ccw_device *cdev)
 void ccw_device_update_sense_data(struct ccw_device *cdev)
 {
 	memset(&cdev->id, 0, sizeof(cdev->id));
-	cdev->id.cu_type   = cdev->private->senseid.cu_type;
-	cdev->id.cu_model  = cdev->private->senseid.cu_model;
-	cdev->id.dev_type  = cdev->private->senseid.dev_type;
-	cdev->id.dev_model = cdev->private->senseid.dev_model;
+	cdev->id.cu_type = cdev->private->dma_area->senseid.cu_type;
+	cdev->id.cu_model = cdev->private->dma_area->senseid.cu_model;
+	cdev->id.dev_type = cdev->private->dma_area->senseid.dev_type;
+	cdev->id.dev_model = cdev->private->dma_area->senseid.dev_model;
 }
 
 int ccw_device_test_sense_data(struct ccw_device *cdev)
 {
-	return cdev->id.cu_type == cdev->private->senseid.cu_type &&
-		cdev->id.cu_model == cdev->private->senseid.cu_model &&
-		cdev->id.dev_type == cdev->private->senseid.dev_type &&
-		cdev->id.dev_model == cdev->private->senseid.dev_model;
+	return cdev->id.cu_type ==
+		cdev->private->dma_area->senseid.cu_type &&
+		cdev->id.cu_model ==
+		cdev->private->dma_area->senseid.cu_model &&
+		cdev->id.dev_type ==
+		cdev->private->dma_area->senseid.dev_type &&
+		cdev->id.dev_model ==
+		cdev->private->dma_area->senseid.dev_model;
 }
 
 /*
@@ -342,7 +348,7 @@ ccw_device_done(struct ccw_device *cdev, int state)
 		cio_disable_subchannel(sch);
 
 	/* Reset device status. */
-	memset(&cdev->private->irb, 0, sizeof(struct irb));
+	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 
 	cdev->private->state = state;
 
@@ -509,13 +515,14 @@ void ccw_device_verify_done(struct ccw_device *cdev, int err)
 		ccw_device_done(cdev, DEV_STATE_ONLINE);
 		/* Deliver fake irb to device driver, if needed. */
 		if (cdev->private->flags.fake_irb) {
-			create_fake_irb(&cdev->private->irb,
+			create_fake_irb(&cdev->private->dma_area->irb,
 					cdev->private->flags.fake_irb);
 			cdev->private->flags.fake_irb = 0;
 			if (cdev->handler)
 				cdev->handler(cdev, cdev->private->intparm,
-					      &cdev->private->irb);
-			memset(&cdev->private->irb, 0, sizeof(struct irb));
+					      &cdev->private->dma_area->irb);
+			memset(&cdev->private->dma_area->irb, 0,
+			       sizeof(struct irb));
 		}
 		ccw_device_report_path_events(cdev);
 		ccw_device_handle_broken_paths(cdev);
@@ -672,7 +679,8 @@ ccw_device_online_verify(struct ccw_device *cdev, enum dev_event dev_event)
 
 	if (scsw_actl(&sch->schib.scsw) != 0 ||
 	    (scsw_stctl(&sch->schib.scsw) & SCSW_STCTL_STATUS_PEND) ||
-	    (scsw_stctl(&cdev->private->irb.scsw) & SCSW_STCTL_STATUS_PEND)) {
+	    (scsw_stctl(&cdev->private->dma_area->irb.scsw) &
+	     SCSW_STCTL_STATUS_PEND)) {
 		/*
 		 * No final status yet or final status not yet delivered
 		 * to the device driver. Can't do path verification now,
@@ -719,7 +727,7 @@ static int ccw_device_call_handler(struct ccw_device *cdev)
 	 *  - fast notification was requested (primary status)
 	 *  - unsolicited interrupts
 	 */
-	stctl = scsw_stctl(&cdev->private->irb.scsw);
+	stctl = scsw_stctl(&cdev->private->dma_area->irb.scsw);
 	ending_status = (stctl & SCSW_STCTL_SEC_STATUS) ||
 		(stctl == (SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)) ||
 		(stctl == SCSW_STCTL_STATUS_PEND);
@@ -735,9 +743,9 @@ static int ccw_device_call_handler(struct ccw_device *cdev)
 
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
-			      &cdev->private->irb);
+			      &cdev->private->dma_area->irb);
 
-	memset(&cdev->private->irb, 0, sizeof(struct irb));
+	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 	return 1;
 }
 
@@ -759,7 +767,8 @@ ccw_device_irq(struct ccw_device *cdev, enum dev_event dev_event)
 			/* Unit check but no sense data. Need basic sense. */
 			if (ccw_device_do_sense(cdev, irb) != 0)
 				goto call_handler_unsol;
-			memcpy(&cdev->private->irb, irb, sizeof(struct irb));
+			memcpy(&cdev->private->dma_area->irb, irb,
+			       sizeof(struct irb));
 			cdev->private->state = DEV_STATE_W4SENSE;
 			cdev->private->intparm = 0;
 			return;
@@ -842,7 +851,7 @@ ccw_device_w4sense(struct ccw_device *cdev, enum dev_event dev_event)
 	if (scsw_fctl(&irb->scsw) &
 	    (SCSW_FCTL_CLEAR_FUNC | SCSW_FCTL_HALT_FUNC)) {
 		cdev->private->flags.dosense = 0;
-		memset(&cdev->private->irb, 0, sizeof(struct irb));
+		memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 		ccw_device_accumulate_irb(cdev, irb);
 		goto call_handler;
 	}
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index f6df83a9dfbb..740996d0dc8c 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -99,7 +99,7 @@ static int diag210_to_senseid(struct senseid *senseid, struct diag210 *diag)
 static int diag210_get_dev_info(struct ccw_device *cdev)
 {
 	struct ccw_dev_id *dev_id = &cdev->private->dev_id;
-	struct senseid *senseid = &cdev->private->senseid;
+	struct senseid *senseid = &cdev->private->dma_area->senseid;
 	struct diag210 diag_data;
 	int rc;
 
@@ -134,8 +134,10 @@ static int diag210_get_dev_info(struct ccw_device *cdev)
 static void snsid_init(struct ccw_device *cdev)
 {
 	cdev->private->flags.esid = 0;
-	memset(&cdev->private->senseid, 0, sizeof(cdev->private->senseid));
-	cdev->private->senseid.cu_type = 0xffff;
+
+	memset(&cdev->private->dma_area->senseid, 0,
+	       sizeof(cdev->private->dma_area->senseid));
+	cdev->private->dma_area->senseid.cu_type = 0xffff;
 }
 
 /*
@@ -143,16 +145,16 @@ static void snsid_init(struct ccw_device *cdev)
  */
 static int snsid_check(struct ccw_device *cdev, void *data)
 {
-	struct cmd_scsw *scsw = &cdev->private->irb.scsw.cmd;
+	struct cmd_scsw *scsw = &cdev->private->dma_area->irb.scsw.cmd;
 	int len = sizeof(struct senseid) - scsw->count;
 
 	/* Check for incomplete SENSE ID data. */
 	if (len < SENSE_ID_MIN_LEN)
 		goto out_restart;
-	if (cdev->private->senseid.cu_type == 0xffff)
+	if (cdev->private->dma_area->senseid.cu_type == 0xffff)
 		goto out_restart;
 	/* Check for incompatible SENSE ID data. */
-	if (cdev->private->senseid.reserved != 0xff)
+	if (cdev->private->dma_area->senseid.reserved != 0xff)
 		return -EOPNOTSUPP;
 	/* Check for extended-identification information. */
 	if (len > SENSE_ID_BASIC_LEN)
@@ -170,7 +172,7 @@ static int snsid_check(struct ccw_device *cdev, void *data)
 static void snsid_callback(struct ccw_device *cdev, void *data, int rc)
 {
 	struct ccw_dev_id *id = &cdev->private->dev_id;
-	struct senseid *senseid = &cdev->private->senseid;
+	struct senseid *senseid = &cdev->private->dma_area->senseid;
 	int vm = 0;
 
 	if (rc && MACHINE_IS_VM) {
@@ -200,7 +202,7 @@ void ccw_device_sense_id_start(struct ccw_device *cdev)
 {
 	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 	struct ccw_request *req = &cdev->private->req;
-	struct ccw1 *cp = cdev->private->iccws;
+	struct ccw1 *cp = cdev->private->dma_area->iccws;
 
 	CIO_TRACE_EVENT(4, "snsid");
 	CIO_HEX_EVENT(4, &cdev->private->dev_id, sizeof(cdev->private->dev_id));
@@ -208,7 +210,7 @@ void ccw_device_sense_id_start(struct ccw_device *cdev)
 	snsid_init(cdev);
 	/* Channel program setup. */
 	cp->cmd_code	= CCW_CMD_SENSE_ID;
-	cp->cda		= (u32) (addr_t) &cdev->private->senseid;
+	cp->cda		= (u32) (addr_t) &cdev->private->dma_area->senseid;
 	cp->count	= sizeof(struct senseid);
 	cp->flags	= CCW_FLAG_SLI;
 	/* Request setup. */
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 4435ae0b3027..d722458c5928 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -429,8 +429,8 @@ struct ciw *ccw_device_get_ciw(struct ccw_device *cdev, __u32 ct)
 	if (cdev->private->flags.esid == 0)
 		return NULL;
 	for (ciw_cnt = 0; ciw_cnt < MAX_CIWS; ciw_cnt++)
-		if (cdev->private->senseid.ciw[ciw_cnt].ct == ct)
-			return cdev->private->senseid.ciw + ciw_cnt;
+		if (cdev->private->dma_area->senseid.ciw[ciw_cnt].ct == ct)
+			return cdev->private->dma_area->senseid.ciw + ciw_cnt;
 	return NULL;
 }
 
@@ -699,6 +699,23 @@ void ccw_device_get_schid(struct ccw_device *cdev, struct subchannel_id *schid)
 }
 EXPORT_SYMBOL_GPL(ccw_device_get_schid);
 
+/*
+ * Allocate zeroed dma coherent 31 bit addressable memory using
+ * the subchannels dma pool. Maximal size of allocation supported
+ * is PAGE_SIZE.
+ */
+void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
+{
+	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
+}
+EXPORT_SYMBOL(ccw_device_dma_zalloc);
+
+void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
+{
+	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
+}
+EXPORT_SYMBOL(ccw_device_dma_free);
+
 EXPORT_SYMBOL(ccw_device_set_options_mask);
 EXPORT_SYMBOL(ccw_device_set_options);
 EXPORT_SYMBOL(ccw_device_clear_options);
diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index d30a3babf176..767a85635a0f 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -57,7 +57,7 @@ static void verify_done(struct ccw_device *cdev, int rc)
 static void nop_build_cp(struct ccw_device *cdev)
 {
 	struct ccw_request *req = &cdev->private->req;
-	struct ccw1 *cp = cdev->private->iccws;
+	struct ccw1 *cp = cdev->private->dma_area->iccws;
 
 	cp->cmd_code	= CCW_CMD_NOOP;
 	cp->cda		= 0;
@@ -134,9 +134,9 @@ static void nop_callback(struct ccw_device *cdev, void *data, int rc)
 static void spid_build_cp(struct ccw_device *cdev, u8 fn)
 {
 	struct ccw_request *req = &cdev->private->req;
-	struct ccw1 *cp = cdev->private->iccws;
+	struct ccw1 *cp = cdev->private->dma_area->iccws;
 	int i = pathmask_to_pos(req->lpm);
-	struct pgid *pgid = &cdev->private->pgid[i];
+	struct pgid *pgid = &cdev->private->dma_area->pgid[i];
 
 	pgid->inf.fc	= fn;
 	cp->cmd_code	= CCW_CMD_SET_PGID;
@@ -300,7 +300,7 @@ static int pgid_cmp(struct pgid *p1, struct pgid *p2)
 static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
 			 int *mismatch, u8 *reserved, u8 *reset)
 {
-	struct pgid *pgid = &cdev->private->pgid[0];
+	struct pgid *pgid = &cdev->private->dma_area->pgid[0];
 	struct pgid *first = NULL;
 	int lpm;
 	int i;
@@ -342,7 +342,7 @@ static u8 pgid_to_donepm(struct ccw_device *cdev)
 		lpm = 0x80 >> i;
 		if ((cdev->private->pgid_valid_mask & lpm) == 0)
 			continue;
-		pgid = &cdev->private->pgid[i];
+		pgid = &cdev->private->dma_area->pgid[i];
 		if (sch->opm & lpm) {
 			if (pgid->inf.ps.state1 != SNID_STATE1_GROUPED)
 				continue;
@@ -368,7 +368,8 @@ static void pgid_fill(struct ccw_device *cdev, struct pgid *pgid)
 	int i;
 
 	for (i = 0; i < 8; i++)
-		memcpy(&cdev->private->pgid[i], pgid, sizeof(struct pgid));
+		memcpy(&cdev->private->dma_area->pgid[i], pgid,
+		       sizeof(struct pgid));
 }
 
 /*
@@ -435,12 +436,12 @@ static void snid_done(struct ccw_device *cdev, int rc)
 static void snid_build_cp(struct ccw_device *cdev)
 {
 	struct ccw_request *req = &cdev->private->req;
-	struct ccw1 *cp = cdev->private->iccws;
+	struct ccw1 *cp = cdev->private->dma_area->iccws;
 	int i = pathmask_to_pos(req->lpm);
 
 	/* Channel program setup. */
 	cp->cmd_code	= CCW_CMD_SENSE_PGID;
-	cp->cda		= (u32) (addr_t) &cdev->private->pgid[i];
+	cp->cda		= (u32) (addr_t) &cdev->private->dma_area->pgid[i];
 	cp->count	= sizeof(struct pgid);
 	cp->flags	= CCW_FLAG_SLI;
 	req->cp		= cp;
@@ -516,7 +517,8 @@ static void verify_start(struct ccw_device *cdev)
 	sch->lpm = sch->schib.pmcw.pam;
 
 	/* Initialize PGID data. */
-	memset(cdev->private->pgid, 0, sizeof(cdev->private->pgid));
+	memset(cdev->private->dma_area->pgid, 0,
+	       sizeof(cdev->private->dma_area->pgid));
 	cdev->private->pgid_valid_mask = 0;
 	cdev->private->pgid_todo_mask = sch->schib.pmcw.pam;
 	cdev->private->path_notoper_mask = 0;
@@ -626,7 +628,7 @@ struct stlck_data {
 static void stlck_build_cp(struct ccw_device *cdev, void *buf1, void *buf2)
 {
 	struct ccw_request *req = &cdev->private->req;
-	struct ccw1 *cp = cdev->private->iccws;
+	struct ccw1 *cp = cdev->private->dma_area->iccws;
 
 	cp[0].cmd_code = CCW_CMD_STLCK;
 	cp[0].cda = (u32) (addr_t) buf1;
diff --git a/drivers/s390/cio/device_status.c b/drivers/s390/cio/device_status.c
index 7d5c7892b2c4..0bd8f2642732 100644
--- a/drivers/s390/cio/device_status.c
+++ b/drivers/s390/cio/device_status.c
@@ -79,15 +79,15 @@ ccw_device_accumulate_ecw(struct ccw_device *cdev, struct irb *irb)
 	 * are condition that have to be met for the extended control
 	 * bit to have meaning. Sick.
 	 */
-	cdev->private->irb.scsw.cmd.ectl = 0;
+	cdev->private->dma_area->irb.scsw.cmd.ectl = 0;
 	if ((irb->scsw.cmd.stctl & SCSW_STCTL_ALERT_STATUS) &&
 	    !(irb->scsw.cmd.stctl & SCSW_STCTL_INTER_STATUS))
-		cdev->private->irb.scsw.cmd.ectl = irb->scsw.cmd.ectl;
+		cdev->private->dma_area->irb.scsw.cmd.ectl = irb->scsw.cmd.ectl;
 	/* Check if extended control word is valid. */
-	if (!cdev->private->irb.scsw.cmd.ectl)
+	if (!cdev->private->dma_area->irb.scsw.cmd.ectl)
 		return;
 	/* Copy concurrent sense / model dependent information. */
-	memcpy (&cdev->private->irb.ecw, irb->ecw, sizeof (irb->ecw));
+	memcpy(&cdev->private->dma_area->irb.ecw, irb->ecw, sizeof(irb->ecw));
 }
 
 /*
@@ -118,7 +118,7 @@ ccw_device_accumulate_esw(struct ccw_device *cdev, struct irb *irb)
 	if (!ccw_device_accumulate_esw_valid(irb))
 		return;
 
-	cdev_irb = &cdev->private->irb;
+	cdev_irb = &cdev->private->dma_area->irb;
 
 	/* Copy last path used mask. */
 	cdev_irb->esw.esw1.lpum = irb->esw.esw1.lpum;
@@ -210,7 +210,7 @@ ccw_device_accumulate_irb(struct ccw_device *cdev, struct irb *irb)
 		ccw_device_path_notoper(cdev);
 	/* No irb accumulation for transport mode irbs. */
 	if (scsw_is_tm(&irb->scsw)) {
-		memcpy(&cdev->private->irb, irb, sizeof(struct irb));
+		memcpy(&cdev->private->dma_area->irb, irb, sizeof(struct irb));
 		return;
 	}
 	/*
@@ -219,7 +219,7 @@ ccw_device_accumulate_irb(struct ccw_device *cdev, struct irb *irb)
 	if (!scsw_is_solicited(&irb->scsw))
 		return;
 
-	cdev_irb = &cdev->private->irb;
+	cdev_irb = &cdev->private->dma_area->irb;
 
 	/*
 	 * If the clear function had been performed, all formerly pending
@@ -227,7 +227,7 @@ ccw_device_accumulate_irb(struct ccw_device *cdev, struct irb *irb)
 	 * intermediate accumulated status to the device driver.
 	 */
 	if (irb->scsw.cmd.fctl & SCSW_FCTL_CLEAR_FUNC)
-		memset(&cdev->private->irb, 0, sizeof(struct irb));
+		memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
 
 	/* Copy bits which are valid only for the start function. */
 	if (irb->scsw.cmd.fctl & SCSW_FCTL_START_FUNC) {
@@ -329,9 +329,9 @@ ccw_device_do_sense(struct ccw_device *cdev, struct irb *irb)
 	/*
 	 * We have ending status but no sense information. Do a basic sense.
 	 */
-	sense_ccw = &to_io_private(sch)->sense_ccw;
+	sense_ccw = &to_io_private(sch)->dma_area->sense_ccw;
 	sense_ccw->cmd_code = CCW_CMD_BASIC_SENSE;
-	sense_ccw->cda = (__u32) __pa(cdev->private->irb.ecw);
+	sense_ccw->cda = (__u32) __pa(cdev->private->dma_area->irb.ecw);
 	sense_ccw->count = SENSE_MAX_COUNT;
 	sense_ccw->flags = CCW_FLAG_SLI;
 
@@ -364,7 +364,7 @@ ccw_device_accumulate_basic_sense(struct ccw_device *cdev, struct irb *irb)
 
 	if (!(irb->scsw.cmd.dstat & DEV_STAT_UNIT_CHECK) &&
 	    (irb->scsw.cmd.dstat & DEV_STAT_CHN_END)) {
-		cdev->private->irb.esw.esw0.erw.cons = 1;
+		cdev->private->dma_area->irb.esw.esw0.erw.cons = 1;
 		cdev->private->flags.dosense = 0;
 	}
 	/* Check if path verification is required. */
@@ -386,7 +386,7 @@ ccw_device_accumulate_and_sense(struct ccw_device *cdev, struct irb *irb)
 	/* Check for basic sense. */
 	if (cdev->private->flags.dosense &&
 	    !(irb->scsw.cmd.dstat & DEV_STAT_UNIT_CHECK)) {
-		cdev->private->irb.esw.esw0.erw.cons = 1;
+		cdev->private->dma_area->irb.esw.esw0.erw.cons = 1;
 		cdev->private->flags.dosense = 0;
 		return 0;
 	}
diff --git a/drivers/s390/cio/io_sch.h b/drivers/s390/cio/io_sch.h
index 90e4e3a7841b..c03b4a19974e 100644
--- a/drivers/s390/cio/io_sch.h
+++ b/drivers/s390/cio/io_sch.h
@@ -9,15 +9,20 @@
 #include "css.h"
 #include "orb.h"
 
+struct io_subchannel_dma_area {
+	struct ccw1 sense_ccw;	/* static ccw for sense command */
+};
+
 struct io_subchannel_private {
 	union orb orb;		/* operation request block */
-	struct ccw1 sense_ccw;	/* static ccw for sense command */
 	struct ccw_device *cdev;/* pointer to the child ccw device */
 	struct {
 		unsigned int suspend:1;	/* allow suspend */
 		unsigned int prefetch:1;/* deny prefetch */
 		unsigned int inter:1;	/* suppress intermediate interrupts */
 	} __packed options;
+	struct io_subchannel_dma_area *dma_area;
+	dma_addr_t dma_area_dma;
 } __aligned(8);
 
 #define to_io_private(n) ((struct io_subchannel_private *) \
@@ -115,6 +120,13 @@ enum cdev_todo {
 #define FAKE_CMD_IRB	1
 #define FAKE_TM_IRB	2
 
+struct ccw_device_dma_area {
+	struct senseid senseid;	/* SenseID info */
+	struct ccw1 iccws[2];	/* ccws for SNID/SID/SPGID commands */
+	struct irb irb;		/* device status */
+	struct pgid pgid[8];	/* path group IDs per chpid*/
+};
+
 struct ccw_device_private {
 	struct ccw_device *cdev;
 	struct subchannel *sch;
@@ -156,11 +168,7 @@ struct ccw_device_private {
 	} __attribute__((packed)) flags;
 	unsigned long intparm;	/* user interruption parameter */
 	struct qdio_irq *qdio_data;
-	struct irb irb;		/* device status */
 	int async_kill_io_rc;
-	struct senseid senseid;	/* SenseID info */
-	struct pgid pgid[8];	/* path group IDs per chpid*/
-	struct ccw1 iccws[2];	/* ccws for SNID/SID/SPGID commands */
 	struct work_struct todo_work;
 	enum cdev_todo todo;
 	wait_queue_head_t wait_q;
@@ -169,6 +177,8 @@ struct ccw_device_private {
 	struct list_head cmb_list;	/* list of measured devices */
 	u64 cmb_start_time;		/* clock value of cmb reset */
 	void *cmb_wait;			/* deferred cmb enable/disable */
+	struct gen_pool *dma_pool;
+	struct ccw_device_dma_area *dma_area;
 	enum interruption_class int_class;
 };
 
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 6a3076881321..f995798bb025 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -66,7 +66,6 @@ struct virtio_ccw_device {
 	bool device_lost;
 	unsigned int config_ready;
 	void *airq_info;
-	u64 dma_mask;
 };
 
 struct vq_info_block_legacy {
@@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 		ret = -ENOMEM;
 		goto out_free;
 	}
-
 	vcdev->vdev.dev.parent = &cdev->dev;
-	cdev->dev.dma_mask = &vcdev->dma_mask;
-	/* we are fine with common virtio infrastructure using 64 bit DMA */
-	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
-	if (ret) {
-		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
-		goto out_free;
-	}
-
 	vcdev->config_block = kzalloc(sizeof(*vcdev->config_block),
 				   GFP_DMA | GFP_KERNEL);
 	if (!vcdev->config_block) {
-- 
2.17.1

