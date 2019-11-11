Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F46EF756A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKKNuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:50:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727143AbfKKNug (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99d0UFG3Eq4ukMfCrtlhxo0m6nnS9bEJgPWjnZPJbI4=;
        b=a9ojpLXugTOY3qpIyYJQs4hvga8MNWOrHkebPjBlqmcz12RsVRkBJEjVNHWCkLwcolSYjT
        /rUQ2rD5rjJMRiF9FCG4gd+TyUhKsxi29i3XuPWxMno5oT0NtW7dLo5i26HhpFuWKU51Dz
        4taoXwkCnIStRaGnzbNr+jrJerPe2+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-4GNSkI-ZO62RlqtB_WeLZQ-1; Mon, 11 Nov 2019 08:50:31 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A37B18B5FA2;
        Mon, 11 Nov 2019 13:50:30 +0000 (UTC)
Received: from localhost (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B3995D72C;
        Mon, 11 Nov 2019 13:50:29 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 3/4] vfio-ccw: Add a trace for asynchronous requests
Date:   Mon, 11 Nov 2019 14:50:18 +0100
Message-Id: <20191111135019.2394-4-cohuck@redhat.com>
In-Reply-To: <20191111135019.2394-1-cohuck@redhat.com>
References: <20191111135019.2394-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 4GNSkI-ZO62RlqtB_WeLZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Since the asynchronous requests are typically associated with
error recovery, let's add a simple trace when one of those is
issued to a device.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20191016142040.14132-4-farman@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
 drivers/s390/cio/vfio_ccw_trace.c |  1 +
 drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fs=
m.c
index d4119e4c4a8c..23648a9aa721 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -341,6 +341,10 @@ static void fsm_async_request(struct vfio_ccw_private =
*private,
 =09=09/* should not happen? */
 =09=09cmd_region->ret_code =3D -EINVAL;
 =09}
+
+=09trace_vfio_ccw_fsm_async_request(get_schid(private),
+=09=09=09=09=09 cmd_region->command,
+=09=09=09=09=09 cmd_region->ret_code);
 }
=20
 /*
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_=
trace.c
index b37bc68e7f18..37ecbf8be805 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -9,5 +9,6 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
=20
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_=
trace.h
index 5005d57901b4..5f57cefa84dd 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -17,6 +17,36 @@
=20
 #include <linux/tracepoint.h>
=20
+TRACE_EVENT(vfio_ccw_fsm_async_request,
+=09TP_PROTO(struct subchannel_id schid,
+=09=09 int command,
+=09=09 int errno),
+=09TP_ARGS(schid, command, errno),
+
+=09TP_STRUCT__entry(
+=09=09__field(u8, cssid)
+=09=09__field(u8, ssid)
+=09=09__field(u16, sch_no)
+=09=09__field(int, command)
+=09=09__field(int, errno)
+=09),
+
+=09TP_fast_assign(
+=09=09__entry->cssid =3D schid.cssid;
+=09=09__entry->ssid =3D schid.ssid;
+=09=09__entry->sch_no =3D schid.sch_no;
+=09=09__entry->command =3D command;
+=09=09__entry->errno =3D errno;
+=09),
+
+=09TP_printk("schid=3D%x.%x.%04x command=3D0x%x errno=3D%d",
+=09=09  __entry->cssid,
+=09=09  __entry->ssid,
+=09=09  __entry->sch_no,
+=09=09  __entry->command,
+=09=09  __entry->errno)
+);
+
 TRACE_EVENT(vfio_ccw_fsm_event,
 =09TP_PROTO(struct subchannel_id schid, int state, int event),
 =09TP_ARGS(schid, state, event),
--=20
2.21.0

