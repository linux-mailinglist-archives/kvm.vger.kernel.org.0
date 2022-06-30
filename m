Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910D4562430
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbiF3UhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiF3Ug7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFB83ED1F;
        Thu, 30 Jun 2022 13:36:57 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UK2w9B003272;
        Thu, 30 Jun 2022 20:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9iJ4vJPu8+UO7PPaciOaslqFYuQb5uO4RDB9OKseOH0=;
 b=L4/UrH6gviWFp0KBmhvQM+tZQdDIRfKAqsku4H9VLoG+zulk5yk6hVm7Q7QW7a7HDZJ8
 Vlm2xnNbPNVFRKoU48e5ohaa0l0xiMfDi9l0TSlF34AdQlMxS/XbPNDXVuVZHMyL/B2c
 sF3FrGGwHFE/FEVHputt2akKqw9q3dU2SxsEbaHMfp9dNkYa6K4fcGvUJZFVMtQ6DP9j
 wl0sGuYxpDAHtZSGG6ImJ0AgMt5JJQFGtssQ9mPHyWjpNevALg8qLs2fWseGxgtibeg7
 AoHrsNDsfSfwTlxYpJy0PjyD3VpnHw+btux0uFX9wDqz65V095SjpSZOtawhreTiXbej YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jhbs1w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UKasOY002014;
        Thu, 30 Jun 2022 20:36:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jhbs1vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UKLSCZ027020;
        Thu, 30 Jun 2022 20:36:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt096gbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKangX17695132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:36:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59876A404D;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 465DAA4040;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 09830E02A4; Thu, 30 Jun 2022 22:36:49 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 08/11] vfio/ccw: Create an OPEN FSM Event
Date:   Thu, 30 Jun 2022 22:36:44 +0200
Message-Id: <20220630203647.2529815-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220630203647.2529815-1-farman@linux.ibm.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Oc0vKQ3DIcsnYxmPHX_sEvBVhcEi4Xne
X-Proofpoint-GUID: mbqWzfJvtmg7FktnWqQ3fV_A1CYXOuTT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the process of enabling a subchannel for use by vfio-ccw
into the FSM, such that it can manage the sequence of lifecycle
events for the device.

That is, if the FSM state is NOT_OPER(erational), then do the work
that would enable the subchannel and move the FSM to STANDBY state.
An attempt to perform this event again from any of the other operating
states (IDLE, CP_PROCESSING, CP_PENDING) will convert the device back
to NOT_OPER so the configuration process can be started again.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     |  9 ++-------
 drivers/s390/cio/vfio_ccw_fsm.c     | 21 +++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index fe87a2652a22..7d9189640da3 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -231,15 +231,10 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, private);
 
-	spin_lock_irq(sch->lock);
-	sch->isc = VFIO_CCW_ISC;
-	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
-	spin_unlock_irq(sch->lock);
-	if (ret)
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
+	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		goto out_free;
 
-	private->state = VFIO_CCW_STATE_STANDBY;
-
 	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
 	if (ret)
 		goto out_disable;
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 88e529a2e184..2811b2040490 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -11,6 +11,8 @@
 
 #include <linux/vfio.h>
 
+#include <asm/isc.h>
+
 #include "ioasm.h"
 #include "vfio_ccw_private.h"
 
@@ -368,6 +370,20 @@ static void fsm_irq(struct vfio_ccw_private *private,
 		complete(private->completion);
 }
 
+static void fsm_open(struct vfio_ccw_private *private,
+		     enum vfio_ccw_event event)
+{
+	struct subchannel *sch = private->sch;
+	int ret;
+
+	spin_lock_irq(sch->lock);
+	sch->isc = VFIO_CCW_ISC;
+	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
+	if (!ret)
+		private->state = VFIO_CCW_STATE_STANDBY;
+	spin_unlock_irq(sch->lock);
+}
+
 /*
  * Device statemachine
  */
@@ -377,29 +393,34 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
 	},
 	[VFIO_CCW_STATE_STANDBY] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_IDLE] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_request,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_CP_PROCESSING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_retry,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_CP_PENDING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_busy,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
 	},
 };
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 4cfdd5fc0961..8dff1699a7d9 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -142,6 +142,7 @@ enum vfio_ccw_event {
 	VFIO_CCW_EVENT_IO_REQ,
 	VFIO_CCW_EVENT_INTERRUPT,
 	VFIO_CCW_EVENT_ASYNC_REQ,
+	VFIO_CCW_EVENT_OPEN,
 	/* last element! */
 	NR_VFIO_CCW_EVENTS
 };
-- 
2.32.0

