Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376371D179A
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbgEMO3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:29:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388740AbgEMO3m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:29:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DEANjK047553;
        Wed, 13 May 2020 10:29:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3101m966xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:41 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DEAXuX048599;
        Wed, 13 May 2020 10:29:40 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3101m966wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:40 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DEL5fc015403;
        Wed, 13 May 2020 14:29:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ub9rgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 14:29:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DESPhm35062088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 14:28:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 157C7A4067;
        Wed, 13 May 2020 14:29:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA52A4062;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A9320E02BB; Wed, 13 May 2020 16:29:35 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 2/4] vfio-ccw: Utilize scsw actl to serialize start operations
Date:   Wed, 13 May 2020 16:29:32 +0200
Message-Id: <20200513142934.28788-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513142934.28788-1-farman@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 cotscore=-2147483648 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need a convenient way to manage the fact that a START SUBCHANNEL
command is synchronous, the HALT SUBCHANNEL and CLEAR SUBCHANNEL
commands are asynchronous, and the interrupts for all three are
also asynchronous and unstacked from a workqueue.

Fortunately, the POPS does provide a mechanism to serialize the
operations, in the form of the activity control flags of the SCSW.
Since we initialize the private->scsw from the guest io_region for
each new START (done under the protection of the io_mutex), and
then never touch it again, we can use that as a space to indicate
which commands are active at the device.

For a START SUBCHANNEL command, the POPS states:

> Condition code 2 is set, and no other action is
> taken, when a start, halt, or clear function is currently
> in progress at the subchannel

So, mark START PENDING in this copy of the SCSW Activity
Controls, and use it to track when a command has started
versus when its interrupt has been unstacked from the workqueue
and processed. It's a bit unnatural, in that this doesn't
transition the flags to Subchannel/Device Active once the
command has been accepted. Since this is only in our local
copy of the SCSW, and not the actual contents of the SCHIB,
this is fine enough.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c |  4 +++-
 drivers/s390/cio/vfio_ccw_fsm.c | 12 ++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c |  4 +++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 7dd3efa1ccb8..ee153fa72a0f 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -98,8 +98,10 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && scsw_is_solicited(&irb->scsw) && is_final)
+	if (private->mdev && scsw_is_solicited(&irb->scsw) && is_final) {
 		private->state = VFIO_CCW_STATE_IDLE;
+		private->scsw.cmd.actl &= ~SCSW_ACTL_START_PEND;
+	}
 
 	if (private->io_trigger)
 		eventfd_signal(private->io_trigger, 1);
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23e61aa638e4..258ce32549f3 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -246,8 +246,20 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	char *errstr = "request";
 	struct subchannel_id schid = get_schid(private);
 
+	if (scsw_actl(scsw) & SCSW_ACTL_START_PEND) {
+		io_region->ret_code = -EBUSY;
+		VFIO_CCW_MSG_EVENT(2,
+				   "%pUl (%x.%x.%04x): actl %x pending\n",
+				   mdev_uuid(mdev), schid.cssid,
+				   schid.ssid, schid.sch_no,
+				   scsw_actl(scsw));
+		errstr = "pending";
+		goto err_out;
+	}
+
 	private->state = VFIO_CCW_STATE_CP_PROCESSING;
 	memcpy(scsw, io_region->scsw_area, sizeof(*scsw));
+	scsw->cmd.actl |= SCSW_ACTL_START_PEND;
 
 	if (scsw->cmd.fctl & SCSW_FCTL_START_FUNC) {
 		orb = (union orb *)io_region->orb_area;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f0d71ab77c50..d2f9babb751c 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -269,8 +269,10 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	}
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_IO_REQ);
-	if (region->ret_code != 0)
+	if (region->ret_code != 0) {
 		private->state = VFIO_CCW_STATE_IDLE;
+		private->scsw.cmd.actl &= ~SCSW_ACTL_START_PEND;
+	}
 	ret = (region->ret_code != 0) ? region->ret_code : count;
 
 out_unlock:
-- 
2.17.1

