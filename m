Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC694F7566
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKKNuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:50:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727010AbfKKNuc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBoYNeqQu5HS/xdy5p2+OuAcyMbJQL7eZ0IgOSn4QhU=;
        b=UC0eIHxYTb5SWtEVVt2oMYDQXuHqZOjojU8v8C5oB3eQTvD0ZpVe707WngFq813VdBXFBN
        vjrMe1NeWEaXLt0sDTg4p6E1gTuL33tCNQPxdCzedvQQFR+MXkaV0vXMH7eR5g9QPY/fjt
        Un1ArYdaUqdUsWuVutv4DzEcPPoEFVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-yw2YDCzDPjqjslYdyad1Mw-1; Mon, 11 Nov 2019 08:50:29 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B588DB63;
        Mon, 11 Nov 2019 13:50:28 +0000 (UTC)
Received: from localhost (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE977600CC;
        Mon, 11 Nov 2019 13:50:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 2/4] vfio-ccw: Trace the FSM jumptable
Date:   Mon, 11 Nov 2019 14:50:17 +0100
Message-Id: <20191111135019.2394-3-cohuck@redhat.com>
In-Reply-To: <20191111135019.2394-1-cohuck@redhat.com>
References: <20191111135019.2394-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: yw2YDCzDPjqjslYdyad1Mw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

It would be nice if we could track the sequence of events within
vfio-ccw, based on the state of the device/FSM and our calling
sequence within it.  So let's add a simple trace here so we can
watch the states change as things go, and allow it to be folded
into the rest of the other cio traces.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20191016142040.14132-3-farman@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 drivers/s390/cio/vfio_ccw_trace.c   |  1 +
 drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_cc=
w_private.h
index bbe9babf767b..9b9bb4982972 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -135,6 +135,7 @@ extern fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATE=
S][NR_VFIO_CCW_EVENTS];
 static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
 =09=09=09=09     int event)
 {
+=09trace_vfio_ccw_fsm_event(private->sch->schid, private->state, event);
 =09vfio_ccw_jumptable[private->state][event](private, event);
 }
=20
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_=
trace.c
index d5cc943c6864..b37bc68e7f18 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -9,4 +9,5 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
=20
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_=
trace.h
index 2a2937a40124..5005d57901b4 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -17,6 +17,32 @@
=20
 #include <linux/tracepoint.h>
=20
+TRACE_EVENT(vfio_ccw_fsm_event,
+=09TP_PROTO(struct subchannel_id schid, int state, int event),
+=09TP_ARGS(schid, state, event),
+
+=09TP_STRUCT__entry(
+=09=09__field(u8, cssid)
+=09=09__field(u8, ssid)
+=09=09__field(u16, schno)
+=09=09__field(int, state)
+=09=09__field(int, event)
+=09),
+
+=09TP_fast_assign(
+=09=09__entry->cssid =3D schid.cssid;
+=09=09__entry->ssid =3D schid.ssid;
+=09=09__entry->schno =3D schid.sch_no;
+=09=09__entry->state =3D state;
+=09=09__entry->event =3D event;
+=09),
+
+=09TP_printk("schid=3D%x.%x.%04x state=3D%d event=3D%d",
+=09=09__entry->cssid, __entry->ssid, __entry->schno,
+=09=09__entry->state,
+=09=09__entry->event)
+);
+
 TRACE_EVENT(vfio_ccw_io_fctl,
 =09TP_PROTO(int fctl, struct subchannel_id schid, int errno, char *errstr)=
,
 =09TP_ARGS(fctl, schid, errno, errstr),
--=20
2.21.0

