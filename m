Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1924AD93A4
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 16:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393989AbfJPOUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 10:20:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393933AbfJPOUu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 10:20:50 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9GE46RL091738
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:20:49 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vng3ucwbu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:20:49 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 16 Oct 2019 15:20:46 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 16 Oct 2019 15:20:44 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9GEKg7E63176758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 14:20:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D54A74C046;
        Wed, 16 Oct 2019 14:20:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C15164C040;
        Wed, 16 Oct 2019 14:20:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 16 Oct 2019 14:20:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 6327BE02CA; Wed, 16 Oct 2019 16:20:42 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 4/4] vfio-ccw: Rework the io_fctl trace
Date:   Wed, 16 Oct 2019 16:20:40 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016142040.14132-1-farman@linux.ibm.com>
References: <20191016142040.14132-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19101614-0016-0000-0000-000002B899AF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101614-0017-0000-0000-00003319BD25
Message-Id: <20191016142040.14132-5-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using __field_struct for the schib is convenient, but it doesn't
appear to let us filter based on any of the schib elements.
Specifying the full schid or any element within it results
in various errors by the parser.  So, expand that out to its
component elements, so we can limit the trace to a single device.

While we are at it, rename this trace to the function name, so we
remember what is being traced instead of an abstract reference to the
function control bit of the SCSW.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++--
 drivers/s390/cio/vfio_ccw_trace.c |  2 +-
 drivers/s390/cio/vfio_ccw_trace.h | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23648a9aa721..23e61aa638e4 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -318,8 +318,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	}
 
 err_out:
-	trace_vfio_ccw_io_fctl(scsw->cmd.fctl, schid,
-			       io_region->ret_code, errstr);
+	trace_vfio_ccw_fsm_io_request(scsw->cmd.fctl, schid,
+				      io_region->ret_code, errstr);
 }
 
 /*
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
index 37ecbf8be805..8c671d2519f6 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -11,4 +11,4 @@
 
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
-EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_io_request);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
index 5f57cefa84dd..30162a318a8a 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -73,28 +73,32 @@ TRACE_EVENT(vfio_ccw_fsm_event,
 		__entry->event)
 );
 
-TRACE_EVENT(vfio_ccw_io_fctl,
+TRACE_EVENT(vfio_ccw_fsm_io_request,
 	TP_PROTO(int fctl, struct subchannel_id schid, int errno, char *errstr),
 	TP_ARGS(fctl, schid, errno, errstr),
 
 	TP_STRUCT__entry(
+		__field(u8, cssid)
+		__field(u8, ssid)
+		__field(u16, sch_no)
 		__field(int, fctl)
-		__field_struct(struct subchannel_id, schid)
 		__field(int, errno)
 		__field(char*, errstr)
 	),
 
 	TP_fast_assign(
+		__entry->cssid = schid.cssid;
+		__entry->ssid = schid.ssid;
+		__entry->sch_no = schid.sch_no;
 		__entry->fctl = fctl;
-		__entry->schid = schid;
 		__entry->errno = errno;
 		__entry->errstr = errstr;
 	),
 
-	TP_printk("schid=%x.%x.%04x fctl=%x errno=%d info=%s",
-		  __entry->schid.cssid,
-		  __entry->schid.ssid,
-		  __entry->schid.sch_no,
+	TP_printk("schid=%x.%x.%04x fctl=0x%x errno=%d info=%s",
+		  __entry->cssid,
+		  __entry->ssid,
+		  __entry->sch_no,
 		  __entry->fctl,
 		  __entry->errno,
 		  __entry->errstr)
-- 
2.17.1

