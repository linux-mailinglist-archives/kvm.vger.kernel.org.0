Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F940D6920
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfJNSJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 14:09:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732736AbfJNSJG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Oct 2019 14:09:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9EHvfBN102719
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 14:09:05 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vmv8pbu55-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 14:09:05 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 14 Oct 2019 19:09:02 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 14 Oct 2019 19:09:00 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9EI8xaJ60686572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 18:08:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F4DF4C058;
        Mon, 14 Oct 2019 18:08:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE9144C04A;
        Mon, 14 Oct 2019 18:08:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Oct 2019 18:08:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A264BE0258; Mon, 14 Oct 2019 20:08:58 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH 3/4] vfio-ccw: Add a trace for asynchronous requests
Date:   Mon, 14 Oct 2019 20:08:54 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191014180855.19400-1-farman@linux.ibm.com>
References: <20191014180855.19400-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19101418-0028-0000-0000-000003A9FDE8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101418-0029-0000-0000-0000246C111C
Message-Id: <20191014180855.19400-4-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-14_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910140149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the asynchronous requests are typically associated with
error recovery, let's add a simple trace when one of those is
issued to a device.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
 drivers/s390/cio/vfio_ccw_trace.c |  1 +
 drivers/s390/cio/vfio_ccw_trace.h | 26 ++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index d4119e4c4a8c..23648a9aa721 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -341,6 +341,10 @@ static void fsm_async_request(struct vfio_ccw_private *private,
 		/* should not happen? */
 		cmd_region->ret_code = -EINVAL;
 	}
+
+	trace_vfio_ccw_fsm_async_request(get_schid(private),
+					 cmd_region->command,
+					 cmd_region->ret_code);
 }
 
 /*
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
index b37bc68e7f18..37ecbf8be805 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -9,5 +9,6 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
 
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
index 24a8152acfdf..4be2e36242e6 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -17,6 +17,32 @@
 
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(vfio_ccw_fsm_async_request,
+	TP_PROTO(struct subchannel_id schid,
+		 int command,
+		 int errno),
+	TP_ARGS(schid, command, errno),
+
+	TP_STRUCT__entry(
+		__field_struct(struct subchannel_id, schid)
+		__field(int, command)
+		__field(int, errno)
+	),
+
+	TP_fast_assign(
+		__entry->schid = schid;
+		__entry->command = command;
+		__entry->errno = errno;
+	),
+
+	TP_printk("schid=%x.%x.%04x command=%d errno=%d",
+		  __entry->schid.cssid,
+		  __entry->schid.ssid,
+		  __entry->schid.sch_no,
+		  __entry->command,
+		  __entry->errno)
+);
+
 TRACE_EVENT(vfio_ccw_fsm_event,
 	TP_PROTO(struct subchannel_id schid, int state, int event),
 	TP_ARGS(schid, state, event),
-- 
2.17.1

