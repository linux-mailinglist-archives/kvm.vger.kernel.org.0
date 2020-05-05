Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010FD1C555E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgEEM1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:27:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727090AbgEEM1v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:27:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CRKtL098218;
        Tue, 5 May 2020 08:27:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1swv7fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:50 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045CRoHI100467;
        Tue, 5 May 2020 08:27:50 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1swv7ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CQKrh023113;
        Tue, 5 May 2020 12:27:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5pwks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:27:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045CQZ5X57344370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 12:26:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA6CA405F;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D638A405B;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1B1A3E065C; Tue,  5 May 2020 14:27:45 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 2/8] vfio-ccw: Register a chp_event callback for vfio-ccw
Date:   Tue,  5 May 2020 14:27:39 +0200
Message-Id: <20200505122745.53208-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505122745.53208-1-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_06:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

Register the chp_event callback to receive channel path related
events for the subchannels managed by vfio-ccw.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v3->v4:
     - Check schib.lpum before calling cio_cancel_halt_clear [CH]
    
    v2->v3:
     - Add a call to cio_cancel_halt_clear() for CHP_VARY_OFF [CH]
    
    v1->v2:
     - Move s390dbf before cio_update_schib() call [CH]
    
    v0->v1: [EF]
     - Add s390dbf trace

 drivers/s390/cio/vfio_ccw_drv.c | 47 +++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8715c1c2f1e1..fb1275a7d1f5 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -19,6 +19,7 @@
 
 #include <asm/isc.h>
 
+#include "chp.h"
 #include "ioasm.h"
 #include "css.h"
 #include "vfio_ccw_private.h"
@@ -262,6 +263,51 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	return rc;
 }
 
+static int vfio_ccw_chp_event(struct subchannel *sch,
+			      struct chp_link *link, int event)
+{
+	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	int mask = chp_ssd_get_mask(&sch->ssd_info, link);
+	int retry = 255;
+
+	if (!private || !mask)
+		return 0;
+
+	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
+			   mdev_uuid(private->mdev), sch->schid.cssid,
+			   sch->schid.ssid, sch->schid.sch_no,
+			   mask, event);
+
+	if (cio_update_schib(sch))
+		return -ENODEV;
+
+	switch (event) {
+	case CHP_VARY_OFF:
+		/* Path logically turned off */
+		sch->opm &= ~mask;
+		sch->lpm &= ~mask;
+		if (sch->schib.pmcw.lpum & mask)
+			cio_cancel_halt_clear(sch, &retry);
+		break;
+	case CHP_OFFLINE:
+		/* Path is gone */
+		if (sch->schib.pmcw.lpum & mask)
+			cio_cancel_halt_clear(sch, &retry);
+		break;
+	case CHP_VARY_ON:
+		/* Path logically turned on */
+		sch->opm |= mask;
+		sch->lpm |= mask;
+		break;
+	case CHP_ONLINE:
+		/* Path became available */
+		sch->lpm |= mask & sch->opm;
+		break;
+	}
+
+	return 0;
+}
+
 static struct css_device_id vfio_ccw_sch_ids[] = {
 	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
 	{ /* end of list */ },
@@ -279,6 +325,7 @@ static struct css_driver vfio_ccw_sch_driver = {
 	.remove = vfio_ccw_sch_remove,
 	.shutdown = vfio_ccw_sch_shutdown,
 	.sch_event = vfio_ccw_sch_event,
+	.chp_event = vfio_ccw_chp_event,
 };
 
 static int __init vfio_ccw_debug_init(void)
-- 
2.17.1

