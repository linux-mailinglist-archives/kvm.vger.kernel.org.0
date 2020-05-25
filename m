Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BF81E0AD3
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389627AbgEYJlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:41:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44818 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389623AbgEYJlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 05:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590399688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=22uv9msgebjtsAwkM95GhvpaRamwNmglM2omeg33d04=;
        b=d4P1rfRxIPsMevMcu4rwlLIwCAv6wBywtS6S4uGPSAKCI7Y/imrS8J4hZuF+1aGA3YJisB
        wOy1HNYnD+HwJahMaayF3wluIfj38h5mU2k65l9n9yhiZFUH8HiHCeCiFf/xQbHf/HLPez
        mMLihtyrxoHjg1FJ3CInYnmQKTvksd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-j4sEfD5ZNpKPy9uAk_5HUg-1; Mon, 25 May 2020 05:41:24 -0400
X-MC-Unique: j4sEfD5ZNpKPy9uAk_5HUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 213A78015D2;
        Mon, 25 May 2020 09:41:23 +0000 (UTC)
Received: from localhost (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B3DB768A0;
        Mon, 25 May 2020 09:41:21 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Jared Rossi <jrossi@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 01/10] vfio-ccw: Enable transparent CCW IPL from DASD
Date:   Mon, 25 May 2020 11:41:06 +0200
Message-Id: <20200525094115.222299-2-cohuck@redhat.com>
In-Reply-To: <20200525094115.222299-1-cohuck@redhat.com>
References: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jared Rossi <jrossi@linux.ibm.com>

Remove the explicit prefetch check when using vfio-ccw devices.
This check does not trigger in practice as all Linux channel programs
are intended to use prefetch.

It is expected that all ORBs issued by Linux will request prefetch.
Although non-prefetching ORBs are not rejected, they will prefetch
nonetheless. A warning is issued up to once per 5 seconds when a
forced prefetch occurs.

A non-prefetch ORB does not necessarily result in an error, however
frequent encounters with non-prefetch ORBs indicate that channel
programs are being executed in a way that is inconsistent with what
the guest is requesting. While there is currently no known case of an
error caused by forced prefetch, it is possible in theory that forced
prefetch could result in an error if applied to a channel program that
is dependent on non-prefetch.

Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20200506212440.31323-2-jrossi@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/s390/vfio-ccw.rst |  6 ++++++
 drivers/s390/cio/vfio_ccw_cp.c  | 19 ++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index fca9c4f5bd9c..23e7d136f8b4 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -335,6 +335,12 @@ device.
 The current code allows the guest to start channel programs via
 START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
 
+Currently all channel programs are prefetched, regardless of the
+p-bit setting in the ORB.  As a result, self modifying channel
+programs are not supported.  For this reason, IPL has to be handled as
+a special case by a userspace/guest program; this has been implemented
+in QEMU's s390-ccw bios as of QEMU 4.1.
+
 vfio-ccw supports classic (command mode) channel I/O only. Transport
 mode (HPF) is not supported.
 
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3645d1720c4b..b9febc581b1f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -8,6 +8,7 @@
  *            Xiao Feng Ren <renxiaof@linux.vnet.ibm.com>
  */
 
+#include <linux/ratelimit.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
@@ -625,23 +626,27 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
  * the target channel program from @orb->cmd.iova to the new ccwchain(s).
  *
  * Limitations:
- * 1. Supports only prefetch enabled mode.
- * 2. Supports idal(c64) ccw chaining.
- * 3. Supports 4k idaw.
+ * 1. Supports idal(c64) ccw chaining.
+ * 2. Supports 4k idaw.
  *
  * Returns:
  *   %0 on success and a negative error value on failure.
  */
 int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 {
+	/* custom ratelimit used to avoid flood during guest IPL */
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
 	/*
-	 * XXX:
-	 * Only support prefetch enable mode now.
+	 * We only support prefetching the channel program. We assume all channel
+	 * programs executed by supported guests likewise support prefetching.
+	 * Executing a channel program that does not specify prefetching will
+	 * typically not cause an error, but a warning is issued to help identify
+	 * the problem if something does break.
 	 */
-	if (!orb->cmd.pfch)
-		return -EOPNOTSUPP;
+	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
+		dev_warn(mdev, "Prefetching channel program even though prefetch not specified in ORB");
 
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
-- 
2.25.4

