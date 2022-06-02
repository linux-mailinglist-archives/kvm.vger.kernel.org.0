Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE75C53BD2C
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiFBRUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiFBRUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC8B20E6F1;
        Thu,  2 Jun 2022 10:20:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252HFNG6014176;
        Thu, 2 Jun 2022 17:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gWMrz33RTPVfp/bznGSFivqAxkwbZdjVx7DgntPMvCg=;
 b=L4KVpoqhwl0Q+JUdeJnrFO9KOxIKguympxvv+g6bGy9rMD2xhR2p3BLINZ3ZCEnG2FKE
 FoIjo/oyi5q0/t7gny95HtRxMpGufmvNfR7r5FJ9LZo4aJE5qo7Ph+9UbP1IcWskjsPo
 j3FHCpbGxtvEyZ+c4Pnn+Uocn8+6IRKW53gf+kWNTRFJCIhKUX5yvlEefCJpr6UUI3oE
 yufIq6B/FUaoH0taxDcuMzqGRlw2axn75qF4+Q3o+OxAmPmulLmxqNX6hb1/02lhE5T0
 Qy1VJifOQeWckoRa7e0xqr0v9cwGDO+fVpIcyayio8xkkrpIETSn5xAmztj4jXKLxjDP Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9xqmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:58 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252H0Yfh029955;
        Thu, 2 Jun 2022 17:19:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9xqkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H5DZ2016470;
        Thu, 2 Jun 2022 17:19:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3gbc8ynkv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJpTb47645126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87EA94C046;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 707414C044;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id D1C18E12D1; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 15/18] vfio/ccw: Manage private with mdev
Date:   Thu,  2 Jun 2022 19:19:45 +0200
Message-Id: <20220602171948.2790690-16-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qbs0ZbgehiGNjtwViwBVrUHPtJVkQ45v
X-Proofpoint-ORIG-GUID: Rs3TO72TACw_km6dJ9KifJkW-vvLftro
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the lifecycle of a vfio-ccw device by moving the alloc/free
of the vfio-ccw private struct to the mdev probe/remove processing,
rather than the subchannel.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 35 ++++++++---------------------
 drivers/s390/cio/vfio_ccw_ops.c     | 35 +++++++++++++----------------
 drivers/s390/cio/vfio_ccw_private.h |  5 +++++
 3 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 6dca35f3ceba..5928460854ec 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -133,7 +133,8 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
 
-static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
+struct vfio_ccw_private *vfio_ccw_alloc_private(struct mdev_device *mdev,
+						struct subchannel *sch)
 {
 	struct vfio_ccw_private *private;
 
@@ -141,6 +142,8 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 	if (!private)
 		return ERR_PTR(-ENOMEM);
 
+	vfio_init_group_dev(&private->vdev, &mdev->dev, &vfio_ccw_dev_ops);
+
 	private->sch = sch;
 	mutex_init(&private->io_mutex);
 	private->state = VFIO_CCW_STATE_STANDBY;
@@ -186,11 +189,12 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 	kfree(private->cp.guest_cp);
 out_free_private:
 	mutex_destroy(&private->io_mutex);
+	vfio_uninit_group_dev(&private->vdev);
 	kfree(private);
 	return ERR_PTR(-ENOMEM);
 }
 
-static void vfio_ccw_free_private(struct vfio_ccw_private *private)
+void vfio_ccw_free_private(struct vfio_ccw_private *private)
 {
 	struct vfio_ccw_crw *crw, *temp;
 
@@ -205,14 +209,14 @@ static void vfio_ccw_free_private(struct vfio_ccw_private *private)
 	kmem_cache_free(vfio_ccw_io_region, private->io_region);
 	kfree(private->cp.guest_cp);
 	mutex_destroy(&private->io_mutex);
+	vfio_uninit_group_dev(&private->vdev);
 	kfree(private);
 }
 
 static int vfio_ccw_sch_probe(struct subchannel *sch)
 {
 	struct pmcw *pmcw = &sch->schib.pmcw;
-	struct vfio_ccw_private *private;
-	int ret = -ENOMEM;
+	int ret;
 
 	if (pmcw->qf) {
 		dev_warn(&sch->dev, "vfio: ccw: does not support QDIO: %s\n",
@@ -220,41 +224,20 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		return -ENODEV;
 	}
 
-	private = vfio_ccw_alloc_private(sch);
-	if (IS_ERR(private))
-		return PTR_ERR(private);
-
-	dev_set_drvdata(&sch->dev, private);
-
 	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	VFIO_CCW_MSG_EVENT(4, "bound to subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
 	return 0;
-
-out_free:
-	dev_set_drvdata(&sch->dev, NULL);
-	vfio_ccw_free_private(private);
-	return ret;
 }
 
 static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
-
-	if (!private)
-		return;
-
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	mdev_unregister_device(&sch->dev);
 
-	dev_set_drvdata(&sch->dev, NULL);
-
-	vfio_ccw_free_private(private);
-
 	VFIO_CCW_MSG_EVENT(4, "unbound from subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 60a4855e8ecb..1ce7079c9dbb 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -17,8 +17,6 @@
 
 #include "vfio_ccw_private.h"
 
-static const struct vfio_device_ops vfio_ccw_dev_ops;
-
 static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 {
 	/*
@@ -84,29 +82,28 @@ static struct attribute_group *mdev_type_groups[] = {
 
 static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
+	struct subchannel *sch = to_subchannel(mdev->dev.parent);
+	struct vfio_ccw_private *private;
 	int ret;
 
-	if (private->state == VFIO_CCW_STATE_NOT_OPER)
-		return -ENODEV;
-
-	memset(&private->vdev, 0, sizeof(private->vdev));
-	vfio_init_group_dev(&private->vdev, &mdev->dev,
-			    &vfio_ccw_dev_ops);
+	private = vfio_ccw_alloc_private(mdev, sch);
+	if (IS_ERR(private))
+		return PTR_ERR(private);
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
-			   private->sch->schid.cssid,
-			   private->sch->schid.ssid,
-			   private->sch->schid.sch_no);
+			   sch->schid.cssid,
+			   sch->schid.ssid,
+			   sch->schid.sch_no);
 
 	ret = vfio_register_emulated_iommu_dev(&private->vdev);
 	if (ret)
-		goto err_init;
+		goto err_alloc;
 	dev_set_drvdata(&mdev->dev, private);
+	dev_set_drvdata(&sch->dev, private);
 	return 0;
 
-err_init:
-	vfio_uninit_group_dev(&private->vdev);
+err_alloc:
+	vfio_ccw_free_private(private);
 	return ret;
 }
 
@@ -122,12 +119,10 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
+	dev_set_drvdata(&private->sch->dev, NULL);
 	dev_set_drvdata(&mdev->dev, NULL);
 	vfio_unregister_group_dev(&private->vdev);
-
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
-
-	vfio_uninit_group_dev(&private->vdev);
+	vfio_ccw_free_private(private);
 }
 
 static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
@@ -603,7 +598,7 @@ static unsigned int vfio_ccw_get_available(struct mdev_type *mtype)
 	return 1;
 }
 
-static const struct vfio_device_ops vfio_ccw_dev_ops = {
+const struct vfio_device_ops vfio_ccw_dev_ops = {
 	.open_device = vfio_ccw_mdev_open_device,
 	.close_device = vfio_ccw_mdev_close_device,
 	.read = vfio_ccw_mdev_read,
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index e568fd6bcf2a..bf11ebd0d32a 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -117,8 +117,13 @@ struct vfio_ccw_private {
 
 extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
+struct vfio_ccw_private *vfio_ccw_alloc_private(struct mdev_device *mdev,
+						struct subchannel *sch);
+void vfio_ccw_free_private(struct vfio_ccw_private *private);
+
 extern struct mdev_driver vfio_ccw_mdev_driver;
 extern const struct mdev_parent_ops vfio_ccw_mdev_ops;
+extern const struct vfio_device_ops vfio_ccw_dev_ops;
 
 /*
  * States of the device statemachine.
-- 
2.32.0

