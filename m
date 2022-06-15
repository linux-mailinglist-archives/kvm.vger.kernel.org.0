Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7CE54D2AB
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348532AbiFOUeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346898AbiFOUda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:33:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E056C31931;
        Wed, 15 Jun 2022 13:33:28 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FImMgD028666;
        Wed, 15 Jun 2022 20:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oDQWPVjwEgh/gLyQfvRiwKh9Sjxe+FR5cAI+2Gb2y3Y=;
 b=W5ad+h2RP7xCyUc3xevoEEQaAHtAscOnSf5BVvqoi5ZO6wwE3ASgva3cdRIWG8Qnbsjy
 Lp1MB64f7uVSzFMkPGeBO7dotBUiuMtelcIZS0QpR+kuFjCn5Zimrrm28eV5IeT3YHp7
 z3sloRhN0QptC4GN5ISKkdTaU0OmvHaXrRpIOeTYhWbVppofvjG6DpcMkaFeKHvdjILN
 EDIV9GPu7YUxMioqlCsmIatxtlzYUJm+qZl+hPGrKCj/zzIcXY9MIlcp0+Lluqcee9Lf
 jino+47bgUipL47B/RgZeuhAVwOVBQxDkhELD43lZ/LguUm8Sr3hbUtjrxRmfJdXJxSf Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqj4h78md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:26 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25FImNA8028835;
        Wed, 15 Jun 2022 20:33:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqj4h78k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FKLCvX000426;
        Wed, 15 Jun 2022 20:33:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gmjp9697k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FKXOrF21037332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 20:33:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC925204F;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2605F5204E;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 07853E0031; Wed, 15 Jun 2022 22:33:20 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 01/10] vfio/ccw: Remove UUID from s390 debug log
Date:   Wed, 15 Jun 2022 22:33:09 +0200
Message-Id: <20220615203318.3830778-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615203318.3830778-1-farman@linux.ibm.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IwDISKGY06W--tgfEfqEnPMMtPgNcKaL
X-Proofpoint-ORIG-GUID: aALs5yjtP3KqJBTHeNql2mpYLtYvFn3c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_16,2022-06-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Kawano <mkawano@linux.ibm.com>

As vfio-ccw devices are created/destroyed, the uuid of the associated
mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost.
This is because a pointer to the UUID is stored instead of the UUID
itself, and that memory may have been repurposed if/when the logs are
examined. The result is usually garbage UUID data in the logs, though
there is an outside chance of an oops happening here.

Simply remove the UUID from the traces, as the subchannel number will
provide useful configuration information for problem determination,
and is stored directly into the log instead of a pointer.

As we were the only consumer of mdev_uuid(), remove that too.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for vfio-ccw")
[farman: reworded commit message, added Fixes: tags]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c |  5 ++---
 drivers/s390/cio/vfio_ccw_fsm.c | 26 ++++++++++++--------------
 drivers/s390/cio/vfio_ccw_ops.c |  8 ++++----
 include/linux/mdev.h            |  5 -----
 4 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee182cfb467d..35055eb94115 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/mdev.h>
 
 #include <asm/isc.h>
@@ -358,8 +357,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 		return 0;
 
 	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
-	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
-			   mdev_uuid(private->mdev), sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
+			   sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
 			   mask, event);
 
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 8483a266051c..bbcc5b486749 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/vfio.h>
-#include <linux/mdev.h>
 
 #include "ioasm.h"
 #include "vfio_ccw_private.h"
@@ -242,7 +241,6 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	union orb *orb;
 	union scsw *scsw = &private->scsw;
 	struct ccw_io_region *io_region = private->io_region;
-	struct mdev_device *mdev = private->mdev;
 	char *errstr = "request";
 	struct subchannel_id schid = get_schid(private);
 
@@ -256,8 +254,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		if (orb->tm.b) {
 			io_region->ret_code = -EOPNOTSUPP;
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): transport mode\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: transport mode\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no);
 			errstr = "transport mode";
 			goto err_out;
@@ -265,8 +263,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = cp_init(&private->cp, orb);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_init=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_init=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp init";
@@ -276,8 +274,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = cp_prefetch(&private->cp);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_prefetch=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp prefetch";
@@ -289,8 +287,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = fsm_io_helper(private);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: fsm_io_helper=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp fsm_io_helper";
@@ -300,16 +298,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		return;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): halt on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: halt on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* halt is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
 		goto err_out;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): clear on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: clear on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* clear is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index b49e2e9db2dc..0e05bff78b8e 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -131,8 +131,8 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
@@ -154,8 +154,8 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index bb539794f54a..47ad3b104d9e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -65,11 +65,6 @@ struct mdev_driver {
 	struct device_driver driver;
 };
 
-static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
-
 extern struct bus_type mdev_bus_type;
 
 int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver);
-- 
2.32.0

