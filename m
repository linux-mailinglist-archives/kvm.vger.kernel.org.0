Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78621E0AD5
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbgEYJld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:41:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45372 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389621AbgEYJlc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 05:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590399691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DUvpXlPXs7ufoDvrhTV1rCg4xG/G69AoTzyKRvUGk/k=;
        b=QM9+IWr6HJ9UL8YR+uazWsxswBI/GJfDE4DnxsMUNpnaQwFH8dHAxBt8qzK3cI7CxN3zZb
        /rFTFtGGPeWnjfSYZH/JFjvQ0xQVfT5/FG7ADyzXWA9pLcLgr87Wy9dicGSBIwQz+wQeVV
        7KUJvb+o8IHzWdibsScOtwMRKadsY4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-TUEQyEm1Oo-sCR292fSWcw-1; Mon, 25 May 2020 05:41:27 -0400
X-MC-Unique: TUEQyEm1Oo-sCR292fSWcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFDFE8014D7;
        Mon, 25 May 2020 09:41:25 +0000 (UTC)
Received: from localhost (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0141319729;
        Mon, 25 May 2020 09:41:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 02/10] vfio-ccw: document possible errors
Date:   Mon, 25 May 2020 11:41:07 +0200
Message-Id: <20200525094115.222299-3-cohuck@redhat.com>
In-Reply-To: <20200525094115.222299-1-cohuck@redhat.com>
References: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interacting with the I/O and the async regions can yield a number
of errors, which had been undocumented so far. These are part of
the api, so remedy that.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20200407111605.1795-1-cohuck@redhat.com>
---
 Documentation/s390/vfio-ccw.rst | 56 +++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 23e7d136f8b4..3a946fd45562 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -204,15 +204,44 @@ definition of the region is::
 	  __u32   ret_code;
   } __packed;
 
+This region is always available.
+
 While starting an I/O request, orb_area should be filled with the
 guest ORB, and scsw_area should be filled with the SCSW of the Virtual
 Subchannel.
 
 irb_area stores the I/O result.
 
-ret_code stores a return code for each access of the region.
+ret_code stores a return code for each access of the region. The following
+values may occur:
+
+``0``
+  The operation was successful.
+
+``-EOPNOTSUPP``
+  The orb specified transport mode or an unidentified IDAW format, or the
+  scsw specified a function other than the start function.
+
+``-EIO``
+  A request was issued while the device was not in a state ready to accept
+  requests, or an internal error occurred.
+
+``-EBUSY``
+  The subchannel was status pending or busy, or a request is already active.
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
 
-This region is always available.
 
 vfio-ccw cmd region
 -------------------
@@ -231,6 +260,29 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
 
 Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
 
+command specifies the command to be issued; ret_code stores a return code
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
+  A request was issued while the device was not in a state ready to accept
+  requests.
+
+``-EAGAIN``
+  A request was being processed, and the caller should retry.
+
+``-EBUSY``
+  The subchannel was status pending or busy while processing a halt request.
+
+
 vfio-ccw operation details
 --------------------------
 
-- 
2.25.4

