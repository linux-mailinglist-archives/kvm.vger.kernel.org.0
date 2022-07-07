Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB4F56A4B5
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiGGN7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiGGN5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A260923BFE;
        Thu,  7 Jul 2022 06:57:48 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Da0Ti014547;
        Thu, 7 Jul 2022 13:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dkz9ggeVSU+7ySGkcbyschmNWfD6lZxd+OmI0K1muXU=;
 b=EayQCtnX7ymA9Ic0vvzW+DK5f/pZzdtIDsfic4oKsD4P8kTpT1ypCyDQdC9/QIfksv9k
 cMpvJDTAn78tA6/p3tC3WLmMnGh8XXwKyxEv5/cc8dMo1oz9nfirRBXZyCUTPUNDqOn0
 l/7F4FamEGlTCikkeSTeWpqinPD0FPU6+BTmWxCU+HDRbtb/IiizspK4wrNs1KhiePDM
 lVvsYdnDuCA8uq+j0cVa2sp/gS1RH+n94/RU4et5KKqVVYxeL8fC+oWfk7O7LkZagrlP
 xut5Ava+yRFcxCj/9QPt2oqTAnikyUviAGsms/CbtCP43+rpGWOKfrBYbjYBvwYO0ZCv jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h609t936x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DbIHQ020209;
        Thu, 7 Jul 2022 13:57:45 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h609t9362-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267Dt7lV013684;
        Thu, 7 Jul 2022 13:57:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3h4v659xsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267Dvdjt21823858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:57:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E6DB52052;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 485CF52051;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 153D5E023B; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 01/11] vfio/ccw: Remove UUID from s390 debug log
Date:   Thu,  7 Jul 2022 15:57:27 +0200
Message-Id: <20220707135737.720765-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w7grhQrctdGO5o015i_UhH0t3_kdHx6e
X-Proofpoint-GUID: dtHQ4_Ipbd4UFX7M0s5UAA_6lepLSx4p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070053
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
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
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
2.34.1

