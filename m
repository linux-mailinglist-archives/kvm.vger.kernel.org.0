Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBEE1FBF69
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 21:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgFPTvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 15:51:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730393AbgFPTvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 15:51:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GJXbnk052800;
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q0rcf1sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GJjgIj112890;
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q0rcf1s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GJo7ZY013895;
        Tue, 16 Jun 2020 19:50:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31mpe85vrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 19:50:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GJotTH64356560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 19:50:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FEF44C040;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 513F54C04E;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id EBD64E027E; Tue, 16 Jun 2020 21:50:54 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v3 2/3] vfio-ccw: Remove the CP_PENDING FSM state
Date:   Tue, 16 Jun 2020 21:50:52 +0200
Message-Id: <20200616195053.99253-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200616195053.99253-1-farman@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_12:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=2
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FSM state is set to CP_PROCESSING when a START operation begins,
is set to CP_PENDING when a START operation is done (the SSCH
instruction gets a cc0), and is set back to IDLE when the final
interrupt is received (or if the START fails somehow). However, it is
categorically impossible to distinguish between interrupts when
other instructions can generate "final" interrupts via the async
region, so using this information for any decision-making at the
completion of an I/O is fraught with peril.

We could replace "CP_PENDING" with a generic "OPERATION_PENDING" state,
but it doesn't appear to buy us anything as far as knowing if we get
one interrupt for a START and another for a CLEAR, or if we just get
one interrupt for the CLEAR and the START never got off the ground.

So let's remove that entirely, and just move the FSM back to IDLE
once the START process completes.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     |  3 ---
 drivers/s390/cio/vfio_ccw_fsm.c     | 16 +++-------------
 drivers/s390/cio/vfio_ccw_ops.c     |  3 +--
 drivers/s390/cio/vfio_ccw_private.h |  1 -
 4 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 7e2a790dc9a1..b76c9008871b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -101,9 +101,6 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && is_final)
-		private->state = VFIO_CCW_STATE_IDLE;
-
 	if (private->io_trigger)
 		eventfd_signal(private->io_trigger, 1);
 }
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index d806f88eba72..f0952192480e 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -49,7 +49,6 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 		 */
 		sch->schib.scsw.cmd.actl |= SCSW_ACTL_START_PEND;
 		ret = 0;
-		private->state = VFIO_CCW_STATE_CP_PENDING;
 		private->cp.started = true;
 		break;
 	case 1:		/* Status pending */
@@ -188,12 +187,6 @@ static void fsm_io_error(struct vfio_ccw_private *private,
 	private->io_region->ret_code = -EIO;
 }
 
-static void fsm_io_busy(struct vfio_ccw_private *private,
-			enum vfio_ccw_event event)
-{
-	private->io_region->ret_code = -EBUSY;
-}
-
 static void fsm_io_retry(struct vfio_ccw_private *private,
 			 enum vfio_ccw_event event)
 {
@@ -309,6 +302,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 			cp_free(&private->cp);
 			goto err_out;
 		}
+		private->state = VFIO_CCW_STATE_IDLE;
 		return;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
@@ -331,6 +325,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 err_out:
 	trace_vfio_ccw_fsm_io_request(scsw->cmd.fctl, schid,
 				      io_region->ret_code, errstr);
+
+	private->state = VFIO_CCW_STATE_IDLE;
 }
 
 /*
@@ -405,10 +401,4 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 	},
-	[VFIO_CCW_STATE_CP_PENDING] = {
-		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
-		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_busy,
-		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
-		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
-	},
 };
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 8b3ed5b45277..0b67c04decee 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -276,8 +276,7 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	}
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_IO_REQ);
-	if (region->ret_code != 0)
-		private->state = VFIO_CCW_STATE_IDLE;
+
 	ret = (region->ret_code != 0) ? region->ret_code : count;
 
 out_unlock:
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 8723156b29ea..f592897f1930 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -125,7 +125,6 @@ enum vfio_ccw_state {
 	VFIO_CCW_STATE_STANDBY,
 	VFIO_CCW_STATE_IDLE,
 	VFIO_CCW_STATE_CP_PROCESSING,
-	VFIO_CCW_STATE_CP_PENDING,
 	/* last element! */
 	NR_VFIO_CCW_STATES
 };
-- 
2.17.1

