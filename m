Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622EE1D1797
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388986AbgEMO3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:29:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388837AbgEMO3n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:29:43 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DEAJNC047398;
        Wed, 13 May 2020 10:29:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31016kx9ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:41 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DELHDJ106866;
        Wed, 13 May 2020 10:29:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31016kx9w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DEL0Mo015360;
        Wed, 13 May 2020 14:29:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ub9rgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 14:29:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DETaX533685728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 14:29:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06CE1A4053;
        Wed, 13 May 2020 14:29:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E583EA404D;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id ABD29E030A; Wed, 13 May 2020 16:29:35 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 3/4] vfio-ccw: Expand SCSW usage to HALT and CLEAR
Date:   Wed, 13 May 2020 16:29:33 +0200
Message-Id: <20200513142934.28788-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513142934.28788-1-farman@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0
 cotscore=-2147483648 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand the Activity Control flags to include HALT/CLEAR PENDING,
in the same way as is done for the START PENDING flag.

The POPS states that for HALT SUBCHANNEL:

> Condition code 2 is set, and no other action is
> taken, ... when a halt function or clear function is
> already in progress at the subchannel.

So take that into account in fsm_do_halt().

CLEAR SUBCHANNEL is the biggest hammer, and always gets to happen,
so no corresponding check is added to fsm_do_clear(). But it does
reset both START and HALT functions that may be active, which is
why it incorporates the resetting of the HALT bit on the interrupt
path.

FIXME: What happens if a guest hammers a bunch of CSCH in a row?
We clear this for the first interrupt; is that fine?

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c |  6 ++++++
 drivers/s390/cio/vfio_ccw_fsm.c | 12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee153fa72a0f..55051972325f 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -101,6 +101,12 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	if (private->mdev && scsw_is_solicited(&irb->scsw) && is_final) {
 		private->state = VFIO_CCW_STATE_IDLE;
 		private->scsw.cmd.actl &= ~SCSW_ACTL_START_PEND;
+		if (scsw_fctl(&irb->scsw) & SCSW_FCTL_HALT_FUNC)
+			private->scsw.cmd.actl &= ~SCSW_ACTL_HALT_PEND;
+		if (scsw_fctl(&irb->scsw) & SCSW_FCTL_CLEAR_FUNC) {
+			private->scsw.cmd.actl &= ~SCSW_ACTL_HALT_PEND;
+			private->scsw.cmd.actl &= ~SCSW_ACTL_CLEAR_PEND;
+		}
 	}
 
 	if (private->io_trigger)
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 258ce32549f3..d8075a56eb9b 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -86,6 +86,14 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 
 	sch = private->sch;
 
+	if (scsw_actl(&private->scsw) & (SCSW_ACTL_HALT_PEND | SCSW_ACTL_CLEAR_PEND)) {
+		VFIO_CCW_MSG_EVENT(2,
+				   "%pUl: actl %x pending\n",
+				   mdev_uuid(private->mdev),
+				   scsw_actl(&private->scsw));
+		return -EBUSY;
+	}
+
 	spin_lock_irqsave(sch->lock, flags);
 
 	VFIO_CCW_TRACE_EVENT(2, "haltIO");
@@ -102,6 +110,7 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 		 * Initialize device status information
 		 */
 		sch->schib.scsw.cmd.actl |= SCSW_ACTL_HALT_PEND;
+		private->scsw.cmd.actl |= SCSW_ACTL_HALT_PEND;
 		ret = 0;
 		break;
 	case 1:		/* Status pending */
@@ -143,6 +152,7 @@ static int fsm_do_clear(struct vfio_ccw_private *private)
 		 * Initialize device status information
 		 */
 		sch->schib.scsw.cmd.actl = SCSW_ACTL_CLEAR_PEND;
+		private->scsw.cmd.actl |= SCSW_ACTL_CLEAR_PEND;
 		/* TODO: check what else we might need to clear */
 		ret = 0;
 		break;
@@ -246,7 +256,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	char *errstr = "request";
 	struct subchannel_id schid = get_schid(private);
 
-	if (scsw_actl(scsw) & SCSW_ACTL_START_PEND) {
+	if (scsw_actl(scsw) & (SCSW_ACTL_START_PEND | SCSW_ACTL_HALT_PEND | SCSW_ACTL_CLEAR_PEND)) {
 		io_region->ret_code = -EBUSY;
 		VFIO_CCW_MSG_EVENT(2,
 				   "%pUl (%x.%x.%04x): actl %x pending\n",
-- 
2.17.1

