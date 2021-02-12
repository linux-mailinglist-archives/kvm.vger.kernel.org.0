Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B5C31A345
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 18:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhBLRGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 12:06:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhBLRFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 12:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613149463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=muci2bFECA89B0jMNuPjwDVm80b8N6IObvOF04Qj7Xg=;
        b=hWpQlHCCFh4ogMSq10hmij7rj+fHYDBZmnfenppeHLP+pBQMkoedQj7kcnmDXpHI5m0Fli
        PtimYCZBfvgvOizqxbF3PG2QfR4oohAbdpFFMUAvOW8OQbwEP1hfnCr9QkhrUPZlZ156z8
        LML8Ozjv1rsAe1ZupNfBq0Dn6F6sL9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-PCm_6tleO5CUMpRycwNyYw-1; Fri, 12 Feb 2021 12:04:20 -0500
X-MC-Unique: PCm_6tleO5CUMpRycwNyYw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42AFA85B671;
        Fri, 12 Feb 2021 17:04:16 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4F2B19D80;
        Fri, 12 Feb 2021 17:04:14 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] virtio/s390: implement virtio-ccw revision 2 correctly
Date:   Fri, 12 Feb 2021 18:04:11 +0100
Message-Id: <20210212170411.992217-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CCW_CMD_READ_STATUS was introduced with revision 2 of virtio-ccw,
and drivers should only rely on it being implemented when they
negotiated at least that revision with the device.

However, virtio_ccw_get_status() issued READ_STATUS for any
device operating at least at revision 1. If the device accepts
READ_STATUS regardless of the negotiated revision (which it is
free to do), everything works as intended; a device rejecting the
command should also be handled gracefully. For correctness, we
should really limit the command to revision 2 or higher, though.

We also negotiated the revision to at most 1, as we never bumped
the maximum revision; let's do that now.

Fixes: 7d3ce5ab9430 ("virtio/s390: support READ_STATUS command for virtio-ccw")
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---

QEMU does not fence off READ_STATUS for revisions < 2, which is probably
why we never noticed this. I'm not aware of other hypervisors that do
fence it off, nor any that cannot deal properly with an unknown command.

Not sure whether this is stable worthy?

---
 drivers/s390/virtio/virtio_ccw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 5730572b52cd..54e686dca6de 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -117,7 +117,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 1
+#define VIRTIO_CCW_REV_MAX 2
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -952,7 +952,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 
-	if (vcdev->revision < 1)
+	if (vcdev->revision < 2)
 		return vcdev->dma_area->status;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
-- 
2.26.2

