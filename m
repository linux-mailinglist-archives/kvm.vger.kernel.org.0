Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0A2A0906
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgJ3PB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgJ3PB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 11:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604070117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HRlXzgPlOlTLzlZheP17qFCHXA+/zGO9eoSgNLbBfiQ=;
        b=PrGxf9XtP+6ElXABX5fH6t+gLlIISJrU5BIyrq1db0lbNhqvZ/47zSLt5wjrTlUE+R+oD4
        O8KQ6A2wsr3oOBxwAFBh1atzg8M9cAbdxQeuJAsyjeLjqg9//tE1jjLCv1ShhVzfyUpT4I
        vEHOWfWWJ4fsxTx8JQhmfenxKN4lOrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-skMTrk0COkScOKr7YEaIdA-1; Fri, 30 Oct 2020 11:01:55 -0400
X-MC-Unique: skMTrk0COkScOKr7YEaIdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E375787950C;
        Fri, 30 Oct 2020 15:01:53 +0000 (UTC)
Received: from gimli.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C6205B4AA;
        Fri, 30 Oct 2020 15:01:50 +0000 (UTC)
Subject: [PATCH] vfio/pci: Implement ioeventfd thread handler for contended
 memory lock
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Date:   Fri, 30 Oct 2020 09:01:50 -0600
Message-ID: <160407008986.9986.83949368176304529.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ioeventfd is called under spinlock with interrupts disabled,
therefore if the memory lock is contended defer code that might
sleep to a thread context.

Fixes: bc93b9ae0151 ("vfio-pci: Avoid recursive read-lock usage")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209253#c1
Reported-by: Ian Pilcher <arequipeno@gmail.com>
Tested-by: Ian Pilcher <arequipeno@gmail.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c |   43 +++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 9e353c484ace..a0b5fc8e46f4 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -356,34 +356,60 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
-static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
+static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
+					bool test_mem)
 {
-	struct vfio_pci_ioeventfd *ioeventfd = opaque;
-
 	switch (ioeventfd->count) {
 	case 1:
-		vfio_pci_iowrite8(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite8(ioeventfd->vdev, test_mem,
 				  ioeventfd->data, ioeventfd->addr);
 		break;
 	case 2:
-		vfio_pci_iowrite16(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite16(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 	case 4:
-		vfio_pci_iowrite32(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite32(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 #ifdef iowrite64
 	case 8:
-		vfio_pci_iowrite64(ioeventfd->vdev, ioeventfd->test_mem,
+		vfio_pci_iowrite64(ioeventfd->vdev, test_mem,
 				   ioeventfd->data, ioeventfd->addr);
 		break;
 #endif
 	}
+}
+
+static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
+{
+	struct vfio_pci_ioeventfd *ioeventfd = opaque;
+	struct vfio_pci_device *vdev = ioeventfd->vdev;
+
+	if (ioeventfd->test_mem) {
+		if (!down_read_trylock(&vdev->memory_lock))
+			return 1; /* Lock contended, use thread */
+		if (!__vfio_pci_memory_enabled(vdev)) {
+			up_read(&vdev->memory_lock);
+			return 0;
+		}
+	}
+
+	vfio_pci_ioeventfd_do_write(ioeventfd, false);
+
+	if (ioeventfd->test_mem)
+		up_read(&vdev->memory_lock);
 
 	return 0;
 }
 
+static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
+{
+	struct vfio_pci_ioeventfd *ioeventfd = opaque;
+
+	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
+}
+
 long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
@@ -457,7 +483,8 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 	ioeventfd->test_mem = vdev->pdev->resource[bar].flags & IORESOURCE_MEM;
 
 	ret = vfio_virqfd_enable(ioeventfd, vfio_pci_ioeventfd_handler,
-				 NULL, NULL, &ioeventfd->virqfd, fd);
+				 vfio_pci_ioeventfd_thread, NULL,
+				 &ioeventfd->virqfd, fd);
 	if (ret) {
 		kfree(ioeventfd);
 		goto out_unlock;

