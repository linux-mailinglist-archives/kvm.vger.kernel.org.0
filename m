Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9895FD34F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOD1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 22:27:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbfKOD1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 22:27:49 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF3PdNJ076970
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:27:47 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9jwqq5tm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:27:47 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 15 Nov 2019 02:56:24 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 02:56:22 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF2uK8p40763672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 02:56:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB1A6AE057;
        Fri, 15 Nov 2019 02:56:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8B05AE053;
        Fri, 15 Nov 2019 02:56:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 15 Nov 2019 02:56:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 50D1AE01E7; Fri, 15 Nov 2019 03:56:20 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 02/10] vfio-ccw: Register a chp_event callback for vfio-ccw
Date:   Fri, 15 Nov 2019 03:56:12 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115025620.19593-1-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111502-0012-0000-0000-00000363C160
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111502-0013-0000-0000-0000219F3D04
Message-Id: <20191115025620.19593-3-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150028
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
    v0->v1: [EF]
     - Add s390dbf trace

 drivers/s390/cio/vfio_ccw_drv.c | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 91989269faf1..05da1facee60 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -19,6 +19,7 @@
 
 #include <asm/isc.h>
 
+#include "chp.h"
 #include "ioasm.h"
 #include "css.h"
 #include "vfio_ccw_private.h"
@@ -257,6 +258,48 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
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
+	if (cio_update_schib(sch))
+		return -ENODEV;
+
+	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
+			   mdev_uuid(private->mdev), sch->schid.cssid,
+			   sch->schid.ssid, sch->schid.sch_no,
+			   mask, event);
+
+	switch (event) {
+	case CHP_VARY_OFF:
+		/* Path logically turned off */
+		sch->opm &= ~mask;
+		sch->lpm &= ~mask;
+		break;
+	case CHP_OFFLINE:
+		/* Path is gone */
+		cio_cancel_halt_clear(sch, &retry);
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
@@ -274,6 +317,7 @@ static struct css_driver vfio_ccw_sch_driver = {
 	.remove = vfio_ccw_sch_remove,
 	.shutdown = vfio_ccw_sch_shutdown,
 	.sch_event = vfio_ccw_sch_event,
+	.chp_event = vfio_ccw_chp_event,
 };
 
 static int __init vfio_ccw_debug_init(void)
-- 
2.17.1

