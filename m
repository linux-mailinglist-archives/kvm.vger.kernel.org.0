Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD29C61658C
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 16:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiKBPCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 11:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKBPCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 11:02:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE2921E1E;
        Wed,  2 Nov 2022 08:02:07 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2EE6eW008977;
        Wed, 2 Nov 2022 15:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oj2JygmyepS52iuUiMacr4B57S6ID5vSZuY26RToibw=;
 b=k2iRU7lxNuySXrQT1Nb63wIDsQhgMAU18jEmnTqx6RV5FCqeQ6Y/MdAjy4p6QM9F4wOy
 KYRDdfB4Cb9Gf2QACs48xg5MaLYjaaxAKpmLD2ZgkdhISkjW7km286T3MRxgazwll+Ed
 5S1pg9dQOs7/IppN4bw3wFGeRHpeFEsombkwNuUOoYmf8smsmUSwyuNLpL7vJgIAaiXW
 gd0eAKrW+0GOlctB7bjuTr8nqHgrj1NbV64U6RukBtEg2oAosd7ADvgg4iFfuab6g3Iw
 NWSlNVhBcatL8f+F+qfw2VNdDuey+X70izY/vpta0AgHdSfXt0G7OnwDt3n1zM6jPXiQ nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkqxwqmwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:02:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A2EbT61023553;
        Wed, 2 Nov 2022 15:02:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkqxwqmu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:02:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2EpbjJ003166;
        Wed, 2 Nov 2022 15:01:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3kgut8y1m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:01:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2F1smH1573458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Nov 2022 15:01:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D68942049;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2612D42045;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id DB421E20D9; Wed,  2 Nov 2022 16:01:53 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 2/7] vfio/ccw: remove private->sch
Date:   Wed,  2 Nov 2022 16:01:47 +0100
Message-Id: <20221102150152.2521475-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102150152.2521475-1-farman@linux.ibm.com>
References: <20221102150152.2521475-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WvL0RhTjLrhEwe6CxR_7bKMuaDpQY1vU
X-Proofpoint-GUID: _f4ZACuMs5XeytP6qoRK4gXiWoBehcdE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_12,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These places all rely on the ability to jump from a private
struct back to the subchannel struct. Rather than keeping a
copy in our back pocket, let's use the relationship provided
by the vfio_device embedded within the private.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_chp.c     |  5 +++--
 drivers/s390/cio/vfio_ccw_drv.c     |  3 +--
 drivers/s390/cio/vfio_ccw_fsm.c     | 27 ++++++++++++---------------
 drivers/s390/cio/vfio_ccw_ops.c     | 12 ++++++------
 drivers/s390/cio/vfio_ccw_private.h |  7 ++++---
 5 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index 13b26a1c7988..d3f3a611f95b 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -16,6 +16,7 @@ static ssize_t vfio_ccw_schib_region_read(struct vfio_ccw_private *private,
 					  char __user *buf, size_t count,
 					  loff_t *ppos)
 {
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
 	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
 	struct ccw_schib_region *region;
@@ -27,12 +28,12 @@ static ssize_t vfio_ccw_schib_region_read(struct vfio_ccw_private *private,
 	mutex_lock(&private->io_mutex);
 	region = private->region[i].data;
 
-	if (cio_update_schib(private->sch)) {
+	if (cio_update_schib(sch)) {
 		ret = -ENODEV;
 		goto out;
 	}
 
-	memcpy(region, &private->sch->schib, sizeof(*region));
+	memcpy(region, &sch->schib, sizeof(*region));
 
 	if (copy_to_user(buf, (void *)region + pos, count)) {
 		ret = -EFAULT;
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 06022fb37b9d..1ba2a9971f86 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -159,7 +159,6 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 	if (!private)
 		return ERR_PTR(-ENOMEM);
 
-	private->sch = sch;
 	mutex_init(&private->io_mutex);
 	private->state = VFIO_CCW_STATE_STANDBY;
 	INIT_LIST_HEAD(&private->crw);
@@ -395,7 +394,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	if (!private || !mask)
 		return 0;
 
-	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
+	trace_vfio_ccw_chp_event(sch->schid, mask, event);
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
 			   sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index a59c758869f8..e67fad897af3 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -18,15 +18,13 @@
 
 static int fsm_io_helper(struct vfio_ccw_private *private)
 {
-	struct subchannel *sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	union orb *orb;
 	int ccode;
 	__u8 lpm;
 	unsigned long flags;
 	int ret;
 
-	sch = private->sch;
-
 	spin_lock_irqsave(sch->lock, flags);
 
 	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
@@ -80,13 +78,11 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 
 static int fsm_do_halt(struct vfio_ccw_private *private)
 {
-	struct subchannel *sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	unsigned long flags;
 	int ccode;
 	int ret;
 
-	sch = private->sch;
-
 	spin_lock_irqsave(sch->lock, flags);
 
 	VFIO_CCW_TRACE_EVENT(2, "haltIO");
@@ -121,13 +117,11 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 
 static int fsm_do_clear(struct vfio_ccw_private *private)
 {
-	struct subchannel *sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	unsigned long flags;
 	int ccode;
 	int ret;
 
-	sch = private->sch;
-
 	spin_lock_irqsave(sch->lock, flags);
 
 	VFIO_CCW_TRACE_EVENT(2, "clearIO");
@@ -160,7 +154,7 @@ static int fsm_do_clear(struct vfio_ccw_private *private)
 static void fsm_notoper(struct vfio_ccw_private *private,
 			enum vfio_ccw_event event)
 {
-	struct subchannel *sch = private->sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: notoper event %x state %x\n",
 			   sch->schid.cssid,
@@ -228,7 +222,7 @@ static void fsm_async_retry(struct vfio_ccw_private *private,
 static void fsm_disabled_irq(struct vfio_ccw_private *private,
 			     enum vfio_ccw_event event)
 {
-	struct subchannel *sch = private->sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 
 	/*
 	 * An interrupt in a disabled state means a previous disable was not
@@ -238,7 +232,9 @@ static void fsm_disabled_irq(struct vfio_ccw_private *private,
 }
 inline struct subchannel_id get_schid(struct vfio_ccw_private *p)
 {
-	return p->sch->schid;
+	struct subchannel *sch = to_subchannel(p->vdev.dev->parent);
+
+	return sch->schid;
 }
 
 /*
@@ -360,10 +356,11 @@ static void fsm_async_request(struct vfio_ccw_private *private,
 static void fsm_irq(struct vfio_ccw_private *private,
 		    enum vfio_ccw_event event)
 {
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	struct irb *irb = this_cpu_ptr(&cio_irb);
 
 	VFIO_CCW_TRACE_EVENT(6, "IRQ");
-	VFIO_CCW_TRACE_EVENT(6, dev_name(&private->sch->dev));
+	VFIO_CCW_TRACE_EVENT(6, dev_name(&sch->dev));
 
 	memcpy(&private->irb, irb, sizeof(*irb));
 
@@ -376,7 +373,7 @@ static void fsm_irq(struct vfio_ccw_private *private,
 static void fsm_open(struct vfio_ccw_private *private,
 		     enum vfio_ccw_event event)
 {
-	struct subchannel *sch = private->sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	int ret;
 
 	spin_lock_irq(sch->lock);
@@ -397,7 +394,7 @@ static void fsm_open(struct vfio_ccw_private *private,
 static void fsm_close(struct vfio_ccw_private *private,
 		      enum vfio_ccw_event event)
 {
-	struct subchannel *sch = private->sch;
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
 	int ret;
 
 	spin_lock_irq(sch->lock);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index dc084883d872..79c50cb7dcb8 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -68,9 +68,9 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 		return ret;
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
-			   private->sch->schid.cssid,
-			   private->sch->schid.ssid,
-			   private->sch->schid.sch_no);
+			   sch->schid.cssid,
+			   sch->schid.ssid,
+			   sch->schid.sch_no);
 
 	ret = vfio_register_emulated_iommu_dev(&private->vdev);
 	if (ret)
@@ -107,9 +107,9 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	struct vfio_ccw_private *private = dev_get_drvdata(&parent->dev);
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
-			   private->sch->schid.cssid,
-			   private->sch->schid.ssid,
-			   private->sch->schid.sch_no);
+			   sch->schid.cssid,
+			   sch->schid.ssid,
+			   sch->schid.sch_no);
 
 	vfio_unregister_group_dev(&private->vdev);
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 1f598d58d969..b28af2f63963 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -85,7 +85,6 @@ struct vfio_ccw_parent {
 /**
  * struct vfio_ccw_private
  * @vdev: Embedded VFIO device
- * @sch: pointer to the subchannel
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
  * @io_region: MMIO region to input/output I/O arguments/results
@@ -107,7 +106,6 @@ struct vfio_ccw_parent {
  */
 struct vfio_ccw_private {
 	struct vfio_device vdev;
-	struct subchannel	*sch;
 	int			state;
 	struct completion	*completion;
 	struct ccw_io_region	*io_region;
@@ -172,7 +170,10 @@ extern fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
 static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 				      enum vfio_ccw_event event)
 {
-	trace_vfio_ccw_fsm_event(private->sch->schid, private->state, event);
+	struct subchannel *sch = to_subchannel(private->vdev.dev->parent);
+
+	if (sch)
+		trace_vfio_ccw_fsm_event(sch->schid, private->state, event);
 	vfio_ccw_jumptable[private->state][event](private, event);
 }
 
-- 
2.34.1

