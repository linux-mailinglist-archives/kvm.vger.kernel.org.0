Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA91E0AE4
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbgEYJmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:42:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389664AbgEYJmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 05:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590399720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/lyKkxVC6Y8WKZnx/wmKwHiUDzCCUkkiJjqsKAZmq8=;
        b=e8p4E5CItUZ7imgc6MfworsBXRktGiR+XORJ0rQaQ3E9yY2tkgqfEs1qwilWxuzgY7xxQe
        7XqZRxtV1eS30uaaBOfqgM125BLb1flV27YZbcZfy9X2TDmxwX7AVVqnTHUDyCaAvme7Oc
        YZx+5chthXjCxya6vEXajt+ccOnU4Ls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-GTizL74YOTKXlLP8YREjQA-1; Mon, 25 May 2020 05:41:58 -0400
X-MC-Unique: GTizL74YOTKXlLP8YREjQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2362664A74;
        Mon, 25 May 2020 09:41:57 +0000 (UTC)
Received: from localhost (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3080D2E16A;
        Mon, 25 May 2020 09:41:56 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 10/10] vfio-ccw: Add trace for CRW event
Date:   Mon, 25 May 2020 11:41:15 +0200
Message-Id: <20200525094115.222299-11-cohuck@redhat.com>
In-Reply-To: <20200525094115.222299-1-cohuck@redhat.com>
References: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Since CRW events are (should be) rare, let's put a trace
in that routine too.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200505122745.53208-9-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_drv.c   |  1 +
 drivers/s390/cio/vfio_ccw_trace.c |  1 +
 drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9144360851ed..8c625b530035 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -336,6 +336,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	if (!private || !mask)
 		return 0;
 
+	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
 	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
 			   mdev_uuid(private->mdev), sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
index 8c671d2519f6..4a0205905afc 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -9,6 +9,7 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
 
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_chp_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_io_request);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
index f5d31887d413..62fb30598d47 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -17,6 +17,36 @@
 
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(vfio_ccw_chp_event,
+	TP_PROTO(struct subchannel_id schid,
+		 int mask,
+		 int event),
+	TP_ARGS(schid, mask, event),
+
+	TP_STRUCT__entry(
+		__field(u8, cssid)
+		__field(u8, ssid)
+		__field(u16, sch_no)
+		__field(int, mask)
+		__field(int, event)
+	),
+
+	TP_fast_assign(
+		__entry->cssid = schid.cssid;
+		__entry->ssid = schid.ssid;
+		__entry->sch_no = schid.sch_no;
+		__entry->mask = mask;
+		__entry->event = event;
+	),
+
+	TP_printk("schid=%x.%x.%04x mask=0x%x event=%d",
+		  __entry->cssid,
+		  __entry->ssid,
+		  __entry->sch_no,
+		  __entry->mask,
+		  __entry->event)
+);
+
 TRACE_EVENT(vfio_ccw_fsm_async_request,
 	TP_PROTO(struct subchannel_id schid,
 		 int command,
-- 
2.25.4

