Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2940F7565
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKKNud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:50:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43643 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726991AbfKKNuc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Brq/3pphcVVk4h6b8P5vZKQckG6x+T1r/FKIQE1VPN0=;
        b=hQ/JKrWv8dMzjBKr/T876NmfqSovC7Amo0EzXQTrdJvtbJOqHJCS3ocpsJlsqHhG8VLkYf
        WSw8L1S8qz7Hz0vKiI7+nZC2E4WoUB17v6KXSF/BHpheUU1dXLuKtjyPjoEQLx/ESp2onK
        c/uyF2ATMJemhkd9uLV4cxJG2dLayB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-DFrBsO1zMlG_HXcW86rFlw-1; Mon, 11 Nov 2019 08:50:27 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C32B1800D48;
        Mon, 11 Nov 2019 13:50:26 +0000 (UTC)
Received: from localhost (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFED45C651;
        Mon, 11 Nov 2019 13:50:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/4] vfio-ccw: Refactor how the traces are built
Date:   Mon, 11 Nov 2019 14:50:16 +0100
Message-Id: <20191111135019.2394-2-cohuck@redhat.com>
In-Reply-To: <20191111135019.2394-1-cohuck@redhat.com>
References: <20191111135019.2394-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: DFrBsO1zMlG_HXcW86rFlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Commit 3cd90214b70f ("vfio: ccw: add tracepoints for interesting error
paths") added a quick trace point to determine where a channel program
failed while being processed.  It's a great addition, but adding more
traces to vfio-ccw is more cumbersome than it needs to be.

Let's refactor how this is done, so that additional traces are easier
to add and can exist outside of the FSM if we ever desire.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20191016142040.14132-2-farman@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/Makefile         |  4 ++--
 drivers/s390/cio/vfio_ccw_cp.h    |  1 +
 drivers/s390/cio/vfio_ccw_fsm.c   |  3 ---
 drivers/s390/cio/vfio_ccw_trace.c | 12 ++++++++++++
 drivers/s390/cio/vfio_ccw_trace.h |  2 ++
 5 files changed, 17 insertions(+), 5 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_trace.c

diff --git a/drivers/s390/cio/Makefile b/drivers/s390/cio/Makefile
index f6a8db04177c..23eae4188876 100644
--- a/drivers/s390/cio/Makefile
+++ b/drivers/s390/cio/Makefile
@@ -5,7 +5,7 @@
=20
 # The following is required for define_trace.h to find ./trace.h
 CFLAGS_trace.o :=3D -I$(src)
-CFLAGS_vfio_ccw_fsm.o :=3D -I$(src)
+CFLAGS_vfio_ccw_trace.o :=3D -I$(src)
=20
 obj-y +=3D airq.o blacklist.o chsc.o cio.o css.o chp.o idset.o isc.o \
 =09fcx.o itcw.o crw.o ccwreq.o trace.o ioasm.o
@@ -21,5 +21,5 @@ qdio-objs :=3D qdio_main.o qdio_thinint.o qdio_debug.o qd=
io_setup.o
 obj-$(CONFIG_QDIO) +=3D qdio.o
=20
 vfio_ccw-objs +=3D vfio_ccw_drv.o vfio_ccw_cp.o vfio_ccw_ops.o vfio_ccw_fs=
m.o \
-=09vfio_ccw_async.o
+=09vfio_ccw_async.o vfio_ccw_trace.o
 obj-$(CONFIG_VFIO_CCW) +=3D vfio_ccw.o
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.=
h
index 7cdc38049033..ba31240ce965 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -15,6 +15,7 @@
 #include <asm/scsw.h>
=20
 #include "orb.h"
+#include "vfio_ccw_trace.h"
=20
 /*
  * Max length for ccw chain.
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fs=
m.c
index 4a1e727c62d9..d4119e4c4a8c 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -15,9 +15,6 @@
 #include "ioasm.h"
 #include "vfio_ccw_private.h"
=20
-#define CREATE_TRACE_POINTS
-#include "vfio_ccw_trace.h"
-
 static int fsm_io_helper(struct vfio_ccw_private *private)
 {
 =09struct subchannel *sch;
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_=
trace.c
new file mode 100644
index 000000000000..d5cc943c6864
--- /dev/null
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tracepoint definitions for vfio_ccw
+ *
+ * Copyright IBM Corp. 2019
+ * Author(s): Eric Farman <farman@linux.ibm.com>
+ */
+
+#define CREATE_TRACE_POINTS
+#include "vfio_ccw_trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_=
trace.h
index b1da53ddec1f..2a2937a40124 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -7,6 +7,8 @@
  *            Halil Pasic <pasic@linux.vnet.ibm.com>
  */
=20
+#include "cio.h"
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM vfio_ccw
=20
--=20
2.21.0

