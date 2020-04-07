Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F981A0CB0
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 13:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDGLQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 07:16:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21069 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725883AbgDGLQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 07:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586258173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3du99pETZoLILFx0f95jymvWmustW+PUAhmPmiIjcqo=;
        b=F+yalRsD096JlStHI9519bR9va9nWYI4RcfogVbepHuN4fPdwb0O6fEpBPC+LSihrMlzIO
        hRipGSfIDPg/J8u5Otb1mYbbnNQ5Drn/4Jj7TPbXh2OkDIaB86w1sUdyhKO7+dGBG6NjaL
        WRb+PALPc2N/mMRjWfCqAZT1q5eLHNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-nWnCS009Pn2sk1k5pxSguQ-1; Tue, 07 Apr 2020 07:16:11 -0400
X-MC-Unique: nWnCS009Pn2sk1k5pxSguQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C516100DFC3;
        Tue,  7 Apr 2020 11:16:09 +0000 (UTC)
Received: from localhost (ovpn-112-38.ams2.redhat.com [10.36.112.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD9C260BEC;
        Tue,  7 Apr 2020 11:16:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio-ccw: document possible errors
Date:   Tue,  7 Apr 2020 13:16:05 +0200
Message-Id: <20200407111605.1795-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interacting with the I/O and the async regions can yield a number
of errors, which had been undocumented so far. These are part of
the api, so remedy that.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/s390/vfio-ccw.rst | 54 ++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-cc=
w.rst
index fca9c4f5bd9c..4538215a362c 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -210,7 +210,36 @@ Subchannel.
=20
 irb_area stores the I/O result.
=20
-ret_code stores a return code for each access of the region.
+ret_code stores a return code for each access of the region. The followi=
ng
+values may occur:
+
+``0``
+  The operation was successful.
+
+``-EOPNOTSUPP``
+  The orb specified transport mode or an unidentified IDAW format, did n=
ot
+  specify prefetch mode, or the scsw specified a function other than the
+  start function.
+
+``-EIO``
+  A request was issued while the device was not in a state ready to acce=
pt
+  requests, or an internal error occurred.
+
+``-EBUSY``
+  The subchannel was status pending or busy, or a request is already act=
ive.
+
+``-EAGAIN``
+  A request was being processed, and the caller should retry.
+
+``-EACCES``
+  The channel path(s) used for the I/O were found to be not operational.
+
+``-ENODEV``
+  The device was found to be not operational.
+
+``-EINVAL``
+  The orb specified a chain longer than 255 ccws, or an internal error
+  occurred.
=20
 This region is always available.
=20
@@ -231,6 +260,29 @@ This region is exposed via region type VFIO_REGION_S=
UBTYPE_CCW_ASYNC_CMD.
=20
 Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
=20
+command specifies the command to be issued; ret_code stores a return cod=
e
+for each access of the region. The following values may occur:
+
+``0``
+  The operation was successful.
+
+``-ENODEV``
+  The device was found to be not operational.
+
+``-EINVAL``
+  A command other than halt or clear was specified.
+
+``-EIO``
+  A request was issued while the device was not in a state ready to acce=
pt
+  requests.
+
+``-EAGAIN``
+  A request was being processed, and the caller should retry.
+
+``-EBUSY``
+  The subchannel was status pending or busy while processing a halt requ=
est.
+
+
 vfio-ccw operation details
 --------------------------
=20
--=20
2.21.1

