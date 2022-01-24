Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65A49A66D
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 03:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343504AbiAYB6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 20:58:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1845199AbiAXXLm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 18:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643065900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+xq1dvb+auyrR+UeLJpXMeONNpkCtEYu5jUsqN8ZMlw=;
        b=H4BgmLhfPZnKEBq4GL2wjJwDc3G67X0NJdHMSjnQBKVJvrj6Zzadv89wkGm0qqX83z8bi2
        HwYRT1TFFtmL0XN4T9g070lYGzTP623rVI9PwicbIioN2/rOJmADTnaGTEMiUUGDOwXsFy
        FF2YkdQNaeLcQgrVHlqeMyC9FMPv+Pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-ld2GHqSqO42Wyt0MthM2yA-1; Mon, 24 Jan 2022 18:11:39 -0500
X-MC-Unique: ld2GHqSqO42Wyt0MthM2yA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26F90835B47;
        Mon, 24 Jan 2022 23:11:38 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.18.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B49C5108B4;
        Mon, 24 Jan 2022 23:11:37 +0000 (UTC)
Subject: [PATCH] vfio/pci: Stub vfio_pci_vga_rw when !CONFIG_VFIO_PCI_VGA
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 24 Jan 2022 16:11:37 -0700
Message-ID: <164306582968.3758255.15192949639574660648.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resolve build errors reported against UML build for undefined
ioport_map() and ioport_unmap() functions.  Without this config
option a device cannot have vfio_pci_core_device.has_vga set,
so the existing function would always return -EINVAL anyway.

Link: https://lore.kernel.org/r/20220123125737.2658758-1-geert@linux-m68k.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c |    2 ++
 include/linux/vfio_pci_core.h    |    9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 57d3b2cbbd8e..82ac1569deb0 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -288,6 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return done;
 }
 
+#ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
@@ -355,6 +356,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+#endif
 
 static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 					bool test_mem)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..ae6f4838ab75 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -159,8 +159,17 @@ extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
 extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
+#ifdef CONFIG_VFIO_PCI_VGA
 extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
+#else
+static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	return -EINVAL;
+}
+#endif
 
 extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);


