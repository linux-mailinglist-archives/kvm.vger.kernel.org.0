Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B453F616588
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKBPCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 11:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKBPCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 11:02:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA79248DC;
        Wed,  2 Nov 2022 08:02:08 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2DsqRj010533;
        Wed, 2 Nov 2022 15:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h///DDsGvsnakcF3FuDBPn7OVTkesMT6C6UGEl9fn7Q=;
 b=Xs4HubRzSpTCWXHgMaOsN1gk6qV5y/UBhAs260tHUqowCpLre5SmkXRzop9BQiqFSFI3
 vAX8/vQ4gAykNNrSQIW8oqFjmfYKl2/hr2GmHNiq0pt3cRQiWi4kh45bTr1Lro81HcB0
 Xg8yqdSBQHsSrMYEq6N0keJ1SB1hEe4fY3ma0YeMvFz8pcWl89kG4l0VAzvdV8sdjvAI
 vGT9zNZu8RL5jiuJ14IqJ9kZRlZIPVatWxa+0Mz5Zhd4/0tSX6I2b2fWedtgudpuvad9
 EZYzvh409Pp9NdOQD81KJM8bSccHk+Hn3v+bX5NPMsshEqxor6SekzHT8lwlW9eZaGXU KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkqxwqmwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:02:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A2ECoKY040448;
        Wed, 2 Nov 2022 15:02:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkqxwqmu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:02:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2EpZuc012599;
        Wed, 2 Nov 2022 15:01:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3kjepeb1t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:01:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2F1s2825690724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Nov 2022 15:01:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6221411C052;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A28811C050;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  2 Nov 2022 15:01:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id E1AC8E210A; Wed,  2 Nov 2022 16:01:53 +0100 (CET)
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
Subject: [PATCH v2 3/7] vfio/ccw: move private initialization to callback
Date:   Wed,  2 Nov 2022 16:01:48 +0100
Message-Id: <20221102150152.2521475-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102150152.2521475-1-farman@linux.ibm.com>
References: <20221102150152.2521475-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AlgTWkZ9ZnRlQwx18Z49jgrQiGhBz1tQ
X-Proofpoint-GUID: qEYxRlcONGMsQK3M03fOLNdhSA2oHnbY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_12,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's already a device initialization callback that is used to
initialize the release completion workaround that was introduced
by commit ebb72b765fb49 ("vfio/ccw: Use the new device life cycle
helpers").

Move the other elements of the vfio_ccw_private struct that
require distinct initialization over to that routine.

With that done, the vfio_ccw_alloc_private routine only does a
kzalloc, so fold it inline.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 70 +++--------------------------
 drivers/s390/cio/vfio_ccw_ops.c     | 43 ++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  7 ++-
 3 files changed, 56 insertions(+), 64 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 1ba2a9971f86..fd5720cbf005 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -23,10 +23,10 @@
 #include "vfio_ccw_private.h"
 
 struct workqueue_struct *vfio_ccw_work_q;
-static struct kmem_cache *vfio_ccw_io_region;
-static struct kmem_cache *vfio_ccw_cmd_region;
-static struct kmem_cache *vfio_ccw_schib_region;
-static struct kmem_cache *vfio_ccw_crw_region;
+struct kmem_cache *vfio_ccw_io_region;
+struct kmem_cache *vfio_ccw_cmd_region;
+struct kmem_cache *vfio_ccw_schib_region;
+struct kmem_cache *vfio_ccw_crw_region;
 
 debug_info_t *vfio_ccw_debug_msg_id;
 debug_info_t *vfio_ccw_debug_trace_id;
@@ -79,7 +79,7 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 	return ret;
 }
 
-static void vfio_ccw_sch_io_todo(struct work_struct *work)
+void vfio_ccw_sch_io_todo(struct work_struct *work)
 {
 	struct vfio_ccw_private *private;
 	struct irb *irb;
@@ -115,7 +115,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		eventfd_signal(private->io_trigger, 1);
 }
 
-static void vfio_ccw_crw_todo(struct work_struct *work)
+void vfio_ccw_crw_todo(struct work_struct *work)
 {
 	struct vfio_ccw_private *private;
 
@@ -151,62 +151,6 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
 
-static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
-{
-	struct vfio_ccw_private *private;
-
-	private = kzalloc(sizeof(*private), GFP_KERNEL);
-	if (!private)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_init(&private->io_mutex);
-	private->state = VFIO_CCW_STATE_STANDBY;
-	INIT_LIST_HEAD(&private->crw);
-	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
-	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
-
-	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
-				       GFP_KERNEL);
-	if (!private->cp.guest_cp)
-		goto out_free_private;
-
-	private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
-					       GFP_KERNEL | GFP_DMA);
-	if (!private->io_region)
-		goto out_free_cp;
-
-	private->cmd_region = kmem_cache_zalloc(vfio_ccw_cmd_region,
-						GFP_KERNEL | GFP_DMA);
-	if (!private->cmd_region)
-		goto out_free_io;
-
-	private->schib_region = kmem_cache_zalloc(vfio_ccw_schib_region,
-						  GFP_KERNEL | GFP_DMA);
-
-	if (!private->schib_region)
-		goto out_free_cmd;
-
-	private->crw_region = kmem_cache_zalloc(vfio_ccw_crw_region,
-						GFP_KERNEL | GFP_DMA);
-
-	if (!private->crw_region)
-		goto out_free_schib;
-	return private;
-
-out_free_schib:
-	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
-out_free_cmd:
-	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-out_free_io:
-	kmem_cache_free(vfio_ccw_io_region, private->io_region);
-out_free_cp:
-	kfree(private->cp.guest_cp);
-out_free_private:
-	mutex_destroy(&private->io_mutex);
-	kfree(private);
-	return ERR_PTR(-ENOMEM);
-}
-
 static void vfio_ccw_free_private(struct vfio_ccw_private *private)
 {
 	struct vfio_ccw_crw *crw, *temp;
@@ -256,7 +200,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (ret)
 		goto out_free;
 
-	private = vfio_ccw_alloc_private(sch);
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
 	if (IS_ERR(private)) {
 		put_device(&parent->dev);
 		return PTR_ERR(private);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 79c50cb7dcb8..eb0b8cc210bb 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -49,8 +49,51 @@ static int vfio_ccw_mdev_init_dev(struct vfio_device *vdev)
 	struct vfio_ccw_private *private =
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
+	mutex_init(&private->io_mutex);
+	private->state = VFIO_CCW_STATE_STANDBY;
+	INIT_LIST_HEAD(&private->crw);
+	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
+	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
 	init_completion(&private->release_comp);
+
+	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
+				       GFP_KERNEL);
+	if (!private->cp.guest_cp)
+		goto out_free_private;
+
+	private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
+					       GFP_KERNEL | GFP_DMA);
+	if (!private->io_region)
+		goto out_free_cp;
+
+	private->cmd_region = kmem_cache_zalloc(vfio_ccw_cmd_region,
+						GFP_KERNEL | GFP_DMA);
+	if (!private->cmd_region)
+		goto out_free_io;
+
+	private->schib_region = kmem_cache_zalloc(vfio_ccw_schib_region,
+						  GFP_KERNEL | GFP_DMA);
+	if (!private->schib_region)
+		goto out_free_cmd;
+
+	private->crw_region = kmem_cache_zalloc(vfio_ccw_crw_region,
+						GFP_KERNEL | GFP_DMA);
+	if (!private->crw_region)
+		goto out_free_schib;
+
 	return 0;
+
+out_free_schib:
+	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
+out_free_cmd:
+	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
+out_free_io:
+	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+out_free_cp:
+	kfree(private->cp.guest_cp);
+out_free_private:
+	mutex_destroy(&private->io_mutex);
+	return -ENOMEM;
 }
 
 static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b28af2f63963..55d636225cff 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -131,6 +131,8 @@ struct vfio_ccw_private {
 } __aligned(8);
 
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
+void vfio_ccw_sch_io_todo(struct work_struct *work);
+void vfio_ccw_crw_todo(struct work_struct *work);
 
 extern struct mdev_driver vfio_ccw_mdev_driver;
 
@@ -178,7 +180,10 @@ static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 }
 
 extern struct workqueue_struct *vfio_ccw_work_q;
-
+extern struct kmem_cache *vfio_ccw_io_region;
+extern struct kmem_cache *vfio_ccw_cmd_region;
+extern struct kmem_cache *vfio_ccw_schib_region;
+extern struct kmem_cache *vfio_ccw_crw_region;
 
 /* s390 debug feature, similar to base cio */
 extern debug_info_t *vfio_ccw_debug_msg_id;
-- 
2.34.1

