Return-Path: <kvm+bounces-303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C837DE09A
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83D361C20D39
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C10011CB1;
	Wed,  1 Nov 2023 11:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p/GiaxH+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2479D11720
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:58:39 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09463DC;
	Wed,  1 Nov 2023 04:58:36 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A1BjcSY022540;
	Wed, 1 Nov 2023 11:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=MOQUNLD7KAjS9Sa3U0hbx/1PkZDAETFjTu5/XW7eJMg=;
 b=p/GiaxH+iqf9gbHXugpjUZDa/ADbHM3ptSpG3Szd5O5p1Yi5kKXSoIvUSzzdQwmyEbI9
 QsH83MFyTWMwIovPftRuCUScCUDhiNS1YANW+Bv2wN0ND54EZUj8wdw3wi4r3oRjxqFV
 BoLi8SLRAjZUKTIRW6144PgPfr2FmdKw6a15e/o3BHD8GvKpf5GkC+TywEEL0fmFcTw+
 G0SmOjYYROB2xC1XCTek1gOm7YYm4m/5neVpyL/qIJzizu5yiww8JIi4uYNsUHTwfHMT
 1Jbw1EVMOL1OIctLtlN6a4l/YsYPdS8UAlvq3fmPJLcHEuFo2tbKFNWqBXIrOEwgPPq0 3Q== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u3p30g99k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Nov 2023 11:58:35 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A19WrFD020321;
	Wed, 1 Nov 2023 11:58:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d0yqk3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Nov 2023 11:58:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A1Bw6687471686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Nov 2023 11:58:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6371820043;
	Wed,  1 Nov 2023 11:58:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0413E20040;
	Wed,  1 Nov 2023 11:58:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Nov 2023 11:58:05 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/1] s390/cio: make sch->lock a spinlock (is a pointer)
Date: Wed,  1 Nov 2023 12:57:51 +0100
Message-Id: <20231101115751.2308307-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AcZcTF983ahr4-_ZFYALxIXSgMiCrrMb
X-Proofpoint-GUID: AcZcTF983ahr4-_ZFYALxIXSgMiCrrMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-01_09,2023-11-01_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311010100

The lock member of struct subchannel used to be a spinlock, but became
a pointer to a spinlock with commit 2ec2298412e1 ("[S390] subchannel
lock conversion."). This might have been justified back then, but with
the current state of affairs, there is no reason to manage a separate
spinlock object.

Let's simplify things and pull the spinlock back into struct subchannel.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
---
I know it is a lot of churn, but I do believe in the end it does make
the code more maintainable.
---
 drivers/s390/cio/chsc.c         | 18 ++++-----
 drivers/s390/cio/chsc_sch.c     |  6 +--
 drivers/s390/cio/cio.c          |  6 +--
 drivers/s390/cio/cio.h          |  2 +-
 drivers/s390/cio/css.c          | 36 +++++-------------
 drivers/s390/cio/device.c       | 66 ++++++++++++++++-----------------
 drivers/s390/cio/device_pgid.c  | 12 +++---
 drivers/s390/cio/eadm_sch.c     | 36 +++++++++---------
 drivers/s390/cio/vfio_ccw_drv.c |  8 ++--
 drivers/s390/cio/vfio_ccw_fsm.c | 24 ++++++------
 10 files changed, 99 insertions(+), 115 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 0abd77f4b664..2988a699e3ef 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -219,16 +219,16 @@ EXPORT_SYMBOL_GPL(chsc_sadc);
 
 static int s390_subchannel_remove_chpid(struct subchannel *sch, void *data)
 {
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	if (sch->driver && sch->driver->chp_event)
 		if (sch->driver->chp_event(sch, data, CHP_OFFLINE) != 0)
 			goto out_unreg;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	return 0;
 
 out_unreg:
 	sch->lpm = 0;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	css_schedule_eval(sch->schid);
 	return 0;
 }
@@ -258,10 +258,10 @@ void chsc_chp_offline(struct chp_id chpid)
 
 static int __s390_process_res_acc(struct subchannel *sch, void *data)
 {
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	if (sch->driver && sch->driver->chp_event)
 		sch->driver->chp_event(sch, data, CHP_ONLINE);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 
 	return 0;
 }
@@ -292,10 +292,10 @@ static void s390_process_res_acc(struct chp_link *link)
 
 static int process_fces_event(struct subchannel *sch, void *data)
 {
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	if (sch->driver && sch->driver->chp_event)
 		sch->driver->chp_event(sch, data, CHP_FCES_EVENT);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	return 0;
 }
 
@@ -769,11 +769,11 @@ static void __s390_subchannel_vary_chpid(struct subchannel *sch,
 
 	memset(&link, 0, sizeof(struct chp_link));
 	link.chpid = chpid;
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 	if (sch->driver && sch->driver->chp_event)
 		sch->driver->chp_event(sch, &link,
 				       on ? CHP_VARY_ON : CHP_VARY_OFF);
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static int s390_subchannel_vary_chpid_off(struct subchannel *sch, void *data)
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 180ab899289c..902237d0baef 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -211,10 +211,10 @@ static int chsc_async(struct chsc_async_area *chsc_area,
 
 	chsc_area->header.key = PAGE_DEFAULT_KEY >> 4;
 	while ((sch = chsc_get_next_subchannel(sch))) {
-		spin_lock(sch->lock);
+		spin_lock(&sch->lock);
 		private = dev_get_drvdata(&sch->dev);
 		if (private->request) {
-			spin_unlock(sch->lock);
+			spin_unlock(&sch->lock);
 			ret = -EBUSY;
 			continue;
 		}
@@ -239,7 +239,7 @@ static int chsc_async(struct chsc_async_area *chsc_area,
 		default:
 			ret = -ENODEV;
 		}
-		spin_unlock(sch->lock);
+		spin_unlock(&sch->lock);
 		CHSC_MSG(2, "chsc on 0.%x.%04x returned cc=%d\n",
 			 sch->schid.ssid, sch->schid.sch_no, cc);
 		if (ret == -EINPROGRESS)
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 6127add746d1..a5736b7357b2 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -546,7 +546,7 @@ static irqreturn_t do_cio_interrupt(int irq, void *dummy)
 		return IRQ_HANDLED;
 	}
 	sch = phys_to_virt(tpi_info->intparm);
-	spin_lock(sch->lock);
+	spin_lock(&sch->lock);
 	/* Store interrupt response block to lowcore. */
 	if (tsch(tpi_info->schid, irb) == 0) {
 		/* Keep subchannel information word up to date. */
@@ -558,7 +558,7 @@ static irqreturn_t do_cio_interrupt(int irq, void *dummy)
 			inc_irq_stat(IRQIO_CIO);
 	} else
 		inc_irq_stat(IRQIO_CIO);
-	spin_unlock(sch->lock);
+	spin_unlock(&sch->lock);
 
 	return IRQ_HANDLED;
 }
@@ -663,7 +663,7 @@ struct subchannel *cio_probe_console(void)
 	if (IS_ERR(sch))
 		return sch;
 
-	lockdep_set_class(sch->lock, &console_sch_key);
+	lockdep_set_class(&sch->lock, &console_sch_key);
 	isc_register(CONSOLE_ISC);
 	sch->config.isc = CONSOLE_ISC;
 	sch->config.intparm = (u32)virt_to_phys(sch);
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index fa8df50bb49e..a9057a5b670a 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -83,7 +83,7 @@ enum sch_todo {
 /* subchannel data structure used by I/O subroutines */
 struct subchannel {
 	struct subchannel_id schid;
-	spinlock_t *lock;	/* subchannel lock */
+	spinlock_t lock;	/* subchannel lock */
 	struct mutex reg_mutex;
 	enum {
 		SUBCHANNEL_TYPE_IO = 0,
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 3ff46fc694f8..28a88ed2c3aa 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -148,16 +148,10 @@ int for_each_subchannel_staged(int (*fn_known)(struct subchannel *, void *),
 
 static void css_sch_todo(struct work_struct *work);
 
-static int css_sch_create_locks(struct subchannel *sch)
+static void css_sch_create_locks(struct subchannel *sch)
 {
-	sch->lock = kmalloc(sizeof(*sch->lock), GFP_KERNEL);
-	if (!sch->lock)
-		return -ENOMEM;
-
-	spin_lock_init(sch->lock);
+	spin_lock_init(&sch->lock);
 	mutex_init(&sch->reg_mutex);
-
-	return 0;
 }
 
 static void css_subchannel_release(struct device *dev)
@@ -167,7 +161,6 @@ static void css_subchannel_release(struct device *dev)
 	sch->config.intparm = 0;
 	cio_commit_config(sch);
 	kfree(sch->driver_override);
-	kfree(sch->lock);
 	kfree(sch);
 }
 
@@ -219,9 +212,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	sch->schib = *schib;
 	sch->st = schib->pmcw.st;
 
-	ret = css_sch_create_locks(sch);
-	if (ret)
-		goto err;
+	css_sch_create_locks(sch);
 
 	INIT_WORK(&sch->todo_work, css_sch_todo);
 	sch->dev.release = &css_subchannel_release;
@@ -233,19 +224,17 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	 */
 	ret = dma_set_coherent_mask(&sch->dev, DMA_BIT_MASK(31));
 	if (ret)
-		goto err_lock;
+		goto err;
 	/*
 	 * But we don't have such restrictions imposed on the stuff that
 	 * is handled by the streaming API.
 	 */
 	ret = dma_set_mask(&sch->dev, DMA_BIT_MASK(64));
 	if (ret)
-		goto err_lock;
+		goto err;
 
 	return sch;
 
-err_lock:
-	kfree(sch->lock);
 err:
 	kfree(sch);
 	return ERR_PTR(ret);
@@ -604,12 +593,12 @@ static void css_sch_todo(struct work_struct *work)
 
 	sch = container_of(work, struct subchannel, todo_work);
 	/* Find out todo. */
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	todo = sch->todo;
 	CIO_MSG_EVENT(4, "sch_todo: sch=0.%x.%04x, todo=%d\n", sch->schid.ssid,
 		      sch->schid.sch_no, todo);
 	sch->todo = SCH_TODO_NOTHING;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	/* Perform todo. */
 	switch (todo) {
 	case SCH_TODO_NOTHING:
@@ -617,9 +606,9 @@ static void css_sch_todo(struct work_struct *work)
 	case SCH_TODO_EVAL:
 		ret = css_evaluate_known_subchannel(sch, 1);
 		if (ret == -EAGAIN) {
-			spin_lock_irq(sch->lock);
+			spin_lock_irq(&sch->lock);
 			css_sched_sch_todo(sch, todo);
-			spin_unlock_irq(sch->lock);
+			spin_unlock_irq(&sch->lock);
 		}
 		break;
 	case SCH_TODO_UNREG:
@@ -1028,12 +1017,7 @@ static int __init setup_css(int nr)
 	css->pseudo_subchannel->dev.parent = &css->device;
 	css->pseudo_subchannel->dev.release = css_subchannel_release;
 	mutex_init(&css->pseudo_subchannel->reg_mutex);
-	ret = css_sch_create_locks(css->pseudo_subchannel);
-	if (ret) {
-		kfree(css->pseudo_subchannel);
-		device_unregister(&css->device);
-		goto out_err;
-	}
+	css_sch_create_locks(css->pseudo_subchannel);
 
 	dev_set_name(&css->pseudo_subchannel->dev, "defunct");
 	ret = device_register(&css->pseudo_subchannel->dev);
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 4ca5adce9107..0cfb179e1bcb 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -748,7 +748,7 @@ static int io_subchannel_initialize_dev(struct subchannel *sch,
 	mutex_init(&cdev->reg_mutex);
 
 	atomic_set(&priv->onoff, 0);
-	cdev->ccwlock = sch->lock;
+	cdev->ccwlock = &sch->lock;
 	cdev->dev.parent = &sch->dev;
 	cdev->dev.release = ccw_device_release;
 	cdev->dev.bus = &ccw_bus_type;
@@ -764,9 +764,9 @@ static int io_subchannel_initialize_dev(struct subchannel *sch,
 		goto out_put;
 	}
 	priv->flags.initialized = 1;
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	sch_set_cdev(sch, cdev);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	return 0;
 
 out_put:
@@ -851,9 +851,9 @@ static void io_subchannel_register(struct ccw_device *cdev)
 		CIO_MSG_EVENT(0, "Could not register ccw dev 0.%x.%04x: %d\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno, ret);
-		spin_lock_irqsave(sch->lock, flags);
+		spin_lock_irqsave(&sch->lock, flags);
 		sch_set_cdev(sch, NULL);
-		spin_unlock_irqrestore(sch->lock, flags);
+		spin_unlock_irqrestore(&sch->lock, flags);
 		mutex_unlock(&cdev->reg_mutex);
 		/* Release initial device reference. */
 		put_device(&cdev->dev);
@@ -904,9 +904,9 @@ static void io_subchannel_recog(struct ccw_device *cdev, struct subchannel *sch)
 	atomic_inc(&ccw_device_init_count);
 
 	/* Start async. device sensing. */
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	ccw_device_recognition(cdev);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 }
 
 static int ccw_device_move_to_sch(struct ccw_device *cdev,
@@ -921,12 +921,12 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 		return -ENODEV;
 
 	if (!sch_is_pseudo_sch(old_sch)) {
-		spin_lock_irq(old_sch->lock);
+		spin_lock_irq(&old_sch->lock);
 		old_enabled = old_sch->schib.pmcw.ena;
 		rc = 0;
 		if (old_enabled)
 			rc = cio_disable_subchannel(old_sch);
-		spin_unlock_irq(old_sch->lock);
+		spin_unlock_irq(&old_sch->lock);
 		if (rc == -EBUSY) {
 			/* Release child reference for new parent. */
 			put_device(&sch->dev);
@@ -944,9 +944,9 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 			      sch->schib.pmcw.dev, rc);
 		if (old_enabled) {
 			/* Try to re-enable the old subchannel. */
-			spin_lock_irq(old_sch->lock);
+			spin_lock_irq(&old_sch->lock);
 			cio_enable_subchannel(old_sch, (u32)virt_to_phys(old_sch));
-			spin_unlock_irq(old_sch->lock);
+			spin_unlock_irq(&old_sch->lock);
 		}
 		/* Release child reference for new parent. */
 		put_device(&sch->dev);
@@ -954,19 +954,19 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 	}
 	/* Clean up old subchannel. */
 	if (!sch_is_pseudo_sch(old_sch)) {
-		spin_lock_irq(old_sch->lock);
+		spin_lock_irq(&old_sch->lock);
 		sch_set_cdev(old_sch, NULL);
-		spin_unlock_irq(old_sch->lock);
+		spin_unlock_irq(&old_sch->lock);
 		css_schedule_eval(old_sch->schid);
 	}
 	/* Release child reference for old parent. */
 	put_device(&old_sch->dev);
 	/* Initialize new subchannel. */
-	spin_lock_irq(sch->lock);
-	cdev->ccwlock = sch->lock;
+	spin_lock_irq(&sch->lock);
+	cdev->ccwlock = &sch->lock;
 	if (!sch_is_pseudo_sch(sch))
 		sch_set_cdev(sch, cdev);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	if (!sch_is_pseudo_sch(sch))
 		css_update_ssd_info(sch);
 	return 0;
@@ -1077,9 +1077,9 @@ static int io_subchannel_probe(struct subchannel *sch)
 	return 0;
 
 out_schedule:
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	return 0;
 }
 
@@ -1093,10 +1093,10 @@ static void io_subchannel_remove(struct subchannel *sch)
 		goto out_free;
 
 	ccw_device_unregister(cdev);
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	sch_set_cdev(sch, NULL);
 	set_io_private(sch, NULL);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 out_free:
 	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
 			  io_priv->dma_area, io_priv->dma_area_dma);
@@ -1203,7 +1203,7 @@ static void io_subchannel_quiesce(struct subchannel *sch)
 	struct ccw_device *cdev;
 	int ret;
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	cdev = sch_get_cdev(sch);
 	if (cio_is_console(sch->schid))
 		goto out_unlock;
@@ -1220,15 +1220,15 @@ static void io_subchannel_quiesce(struct subchannel *sch)
 		ret = ccw_device_cancel_halt_clear(cdev);
 		if (ret == -EBUSY) {
 			ccw_device_set_timeout(cdev, HZ/10);
-			spin_unlock_irq(sch->lock);
+			spin_unlock_irq(&sch->lock);
 			wait_event(cdev->private->wait_q,
 				   cdev->private->state != DEV_STATE_QUIESCE);
-			spin_lock_irq(sch->lock);
+			spin_lock_irq(&sch->lock);
 		}
 		ret = cio_disable_subchannel(sch);
 	}
 out_unlock:
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 }
 
 static void io_subchannel_shutdown(struct subchannel *sch)
@@ -1439,7 +1439,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	enum io_sch_action action;
 	int rc = -EAGAIN;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 	if (!device_is_registered(&sch->dev))
 		goto out_unlock;
 	if (work_pending(&sch->todo_work))
@@ -1492,7 +1492,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	default:
 		break;
 	}
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 	/* All other actions require process context. */
 	if (!process)
 		goto out;
@@ -1507,9 +1507,9 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		break;
 	case IO_SCH_UNREG_CDEV:
 	case IO_SCH_UNREG_ATTACH:
-		spin_lock_irqsave(sch->lock, flags);
+		spin_lock_irqsave(&sch->lock, flags);
 		sch_set_cdev(sch, NULL);
-		spin_unlock_irqrestore(sch->lock, flags);
+		spin_unlock_irqrestore(&sch->lock, flags);
 		/* Unregister ccw device. */
 		ccw_device_unregister(cdev);
 		break;
@@ -1538,9 +1538,9 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 			put_device(&cdev->dev);
 			goto out;
 		}
-		spin_lock_irqsave(sch->lock, flags);
+		spin_lock_irqsave(&sch->lock, flags);
 		ccw_device_trigger_reprobe(cdev);
-		spin_unlock_irqrestore(sch->lock, flags);
+		spin_unlock_irqrestore(&sch->lock, flags);
 		/* Release reference from get_ccwdev_by_dev_id() */
 		put_device(&cdev->dev);
 		break;
@@ -1550,7 +1550,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	return 0;
 
 out_unlock:
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 out:
 	return rc;
 }
@@ -1846,9 +1846,9 @@ static void ccw_device_todo(struct work_struct *work)
 			css_schedule_eval(sch->schid);
 		fallthrough;
 	case CDEV_TODO_UNREG:
-		spin_lock_irq(sch->lock);
+		spin_lock_irq(&sch->lock);
 		sch_set_cdev(sch, NULL);
-		spin_unlock_irq(sch->lock);
+		spin_unlock_irq(&sch->lock);
 		ccw_device_unregister(cdev);
 		break;
 	default:
diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index 3862961697eb..ad90045873e2 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -698,29 +698,29 @@ int ccw_device_stlck(struct ccw_device *cdev)
 		return -ENOMEM;
 	init_completion(&data.done);
 	data.rc = -EIO;
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	rc = cio_enable_subchannel(sch, (u32)virt_to_phys(sch));
 	if (rc)
 		goto out_unlock;
 	/* Perform operation. */
 	cdev->private->state = DEV_STATE_STEAL_LOCK;
 	ccw_device_stlck_start(cdev, &data, &buffer[0], &buffer[32]);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	/* Wait for operation to finish. */
 	if (wait_for_completion_interruptible(&data.done)) {
 		/* Got a signal. */
-		spin_lock_irq(sch->lock);
+		spin_lock_irq(&sch->lock);
 		ccw_request_cancel(cdev);
-		spin_unlock_irq(sch->lock);
+		spin_unlock_irq(&sch->lock);
 		wait_for_completion(&data.done);
 	}
 	rc = data.rc;
 	/* Check results. */
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	cio_disable_subchannel(sch);
 	cdev->private->state = DEV_STATE_BOXED;
 out_unlock:
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	kfree(buffer);
 
 	return rc;
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index 826364d2facd..1caedf931a5f 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -101,12 +101,12 @@ static void eadm_subchannel_timeout(struct timer_list *t)
 	struct eadm_private *private = from_timer(private, t, timer);
 	struct subchannel *sch = private->sch;
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	EADM_LOG(1, "timeout");
 	EADM_LOG_HEX(1, &sch->schid, sizeof(sch->schid));
 	if (eadm_subchannel_clear(sch))
 		EADM_LOG(0, "clear failed");
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 }
 
 static void eadm_subchannel_set_timeout(struct subchannel *sch, int expires)
@@ -163,16 +163,16 @@ static struct subchannel *eadm_get_idle_sch(void)
 	spin_lock_irqsave(&list_lock, flags);
 	list_for_each_entry(private, &eadm_list, head) {
 		sch = private->sch;
-		spin_lock(sch->lock);
+		spin_lock(&sch->lock);
 		if (private->state == EADM_IDLE) {
 			private->state = EADM_BUSY;
 			list_move_tail(&private->head, &eadm_list);
-			spin_unlock(sch->lock);
+			spin_unlock(&sch->lock);
 			spin_unlock_irqrestore(&list_lock, flags);
 
 			return sch;
 		}
-		spin_unlock(sch->lock);
+		spin_unlock(&sch->lock);
 	}
 	spin_unlock_irqrestore(&list_lock, flags);
 
@@ -190,7 +190,7 @@ int eadm_start_aob(struct aob *aob)
 	if (!sch)
 		return -EBUSY;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 	eadm_subchannel_set_timeout(sch, EADM_TIMEOUT);
 	ret = eadm_subchannel_start(sch, aob);
 	if (!ret)
@@ -203,7 +203,7 @@ int eadm_start_aob(struct aob *aob)
 	css_sched_sch_todo(sch, SCH_TODO_EVAL);
 
 out_unlock:
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 
 	return ret;
 }
@@ -221,7 +221,7 @@ static int eadm_subchannel_probe(struct subchannel *sch)
 	INIT_LIST_HEAD(&private->head);
 	timer_setup(&private->timer, eadm_subchannel_timeout, 0);
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	set_eadm_private(sch, private);
 	private->state = EADM_IDLE;
 	private->sch = sch;
@@ -229,11 +229,11 @@ static int eadm_subchannel_probe(struct subchannel *sch)
 	ret = cio_enable_subchannel(sch, (u32)virt_to_phys(sch));
 	if (ret) {
 		set_eadm_private(sch, NULL);
-		spin_unlock_irq(sch->lock);
+		spin_unlock_irq(&sch->lock);
 		kfree(private);
 		goto out;
 	}
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 
 	spin_lock_irq(&list_lock);
 	list_add(&private->head, &eadm_list);
@@ -248,7 +248,7 @@ static void eadm_quiesce(struct subchannel *sch)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	int ret;
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	if (private->state != EADM_BUSY)
 		goto disable;
 
@@ -256,11 +256,11 @@ static void eadm_quiesce(struct subchannel *sch)
 		goto disable;
 
 	private->completion = &completion;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 
 	wait_for_completion_io(&completion);
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	private->completion = NULL;
 
 disable:
@@ -269,7 +269,7 @@ static void eadm_quiesce(struct subchannel *sch)
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
 
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 }
 
 static void eadm_subchannel_remove(struct subchannel *sch)
@@ -282,9 +282,9 @@ static void eadm_subchannel_remove(struct subchannel *sch)
 
 	eadm_quiesce(sch);
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	set_eadm_private(sch, NULL);
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 
 	kfree(private);
 }
@@ -309,7 +309,7 @@ static int eadm_subchannel_sch_event(struct subchannel *sch, int process)
 	struct eadm_private *private;
 	unsigned long flags;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 	if (!device_is_registered(&sch->dev))
 		goto out_unlock;
 
@@ -325,7 +325,7 @@ static int eadm_subchannel_sch_event(struct subchannel *sch, int process)
 		private->state = EADM_IDLE;
 
 out_unlock:
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 
 	return 0;
 }
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 43601816ea4e..a3e25bdd6a76 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -65,14 +65,14 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 		 * cancel/halt/clear completion.
 		 */
 		private->completion = &completion;
-		spin_unlock_irq(sch->lock);
+		spin_unlock_irq(&sch->lock);
 
 		if (ret == -EBUSY)
 			wait_for_completion_timeout(&completion, 3*HZ);
 
 		private->completion = NULL;
 		flush_workqueue(vfio_ccw_work_q);
-		spin_lock_irq(sch->lock);
+		spin_lock_irq(&sch->lock);
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
 
@@ -249,7 +249,7 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	unsigned long flags;
 	int rc = -EAGAIN;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 	if (!device_is_registered(&sch->dev))
 		goto out_unlock;
 
@@ -264,7 +264,7 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 
 	return rc;
 }
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 757b73141246..09877b46181d 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -25,7 +25,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 
 	orb = cp_get_orb(&private->cp, sch);
 	if (!orb) {
@@ -72,7 +72,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 		ret = ccode;
 	}
 out:
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 	return ret;
 }
 
@@ -83,7 +83,7 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 	int ccode;
 	int ret;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 
 	VFIO_CCW_TRACE_EVENT(2, "haltIO");
 	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
@@ -111,7 +111,7 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 	default:
 		ret = ccode;
 	}
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 	return ret;
 }
 
@@ -122,7 +122,7 @@ static int fsm_do_clear(struct vfio_ccw_private *private)
 	int ccode;
 	int ret;
 
-	spin_lock_irqsave(sch->lock, flags);
+	spin_lock_irqsave(&sch->lock, flags);
 
 	VFIO_CCW_TRACE_EVENT(2, "clearIO");
 	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
@@ -147,7 +147,7 @@ static int fsm_do_clear(struct vfio_ccw_private *private)
 	default:
 		ret = ccode;
 	}
-	spin_unlock_irqrestore(sch->lock, flags);
+	spin_unlock_irqrestore(&sch->lock, flags);
 	return ret;
 }
 
@@ -376,18 +376,18 @@ static void fsm_open(struct vfio_ccw_private *private,
 	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	int ret;
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 	sch->isc = VFIO_CCW_ISC;
 	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
 	if (ret)
 		goto err_unlock;
 
 	private->state = VFIO_CCW_STATE_IDLE;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	return;
 
 err_unlock:
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
@@ -397,7 +397,7 @@ static void fsm_close(struct vfio_ccw_private *private,
 	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	int ret;
 
-	spin_lock_irq(sch->lock);
+	spin_lock_irq(&sch->lock);
 
 	if (!sch->schib.pmcw.ena)
 		goto err_unlock;
@@ -409,12 +409,12 @@ static void fsm_close(struct vfio_ccw_private *private,
 		goto err_unlock;
 
 	private->state = VFIO_CCW_STATE_STANDBY;
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	cp_free(&private->cp);
 	return;
 
 err_unlock:
-	spin_unlock_irq(sch->lock);
+	spin_unlock_irq(&sch->lock);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 

base-commit: 5a6a09e97199d6600d31383055f9d43fbbcbe86f
-- 
2.39.2


