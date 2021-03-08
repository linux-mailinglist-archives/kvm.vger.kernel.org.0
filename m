Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F395A331998
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCHVss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:48:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230039AbhCHVsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:48:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d6MnUnVW52Yw6f/HHmKvr8ccfx7cPXR9bB5feQ6cEzw=;
        b=hYnHVm+gxZ31cMWNdmJ2EAsm6SoUnVeey0lMxsuQp/T9RvlfLtbWdBh64SXUkCFLgDOrpV
        ssfZx442w5KbTUWBeV2JTbIr4LnfHloC4LsEE2NfA/XF5toJCQe+Mnwg+SAknaihH6h0/z
        MJRy9c/OMg7tu14ELtppb/NgHmebNcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-pl2EUHLcOcK1VrFI6N1Utw-1; Mon, 08 Mar 2021 16:48:12 -0500
X-MC-Unique: pl2EUHLcOcK1VrFI6N1Utw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64216107465C;
        Mon,  8 Mar 2021 21:48:11 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F071110023AC;
        Mon,  8 Mar 2021 21:48:10 +0000 (UTC)
Subject: [PATCH v1 05/14] vfio: Create a vfio_device from vma lookup
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:48:10 -0700
Message-ID: <161524009061.3480.597759044049531365.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Creating an address space mapping onto our vfio pseudo fs for each
device file descriptor means that we can universally retrieve a
vfio_device from a vma mapping this file.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |   19 +++++++++++++++++--
 include/linux/vfio.h |    1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3852e57b9e04..3a3e85a0dc3e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -927,6 +927,23 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
 
+static const struct file_operations vfio_device_fops;
+
+struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
+{
+	struct vfio_device *device;
+
+	if (!vma->vm_file || vma->vm_file->f_op != &vfio_device_fops)
+		return ERR_PTR(-ENODEV);
+
+	device = vma->vm_file->private_data;
+
+	vfio_device_get(device);
+
+	return device;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_from_vma);
+
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
@@ -1486,8 +1503,6 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 	return 0;
 }
 
-static const struct file_operations vfio_device_fops;
-
 static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 {
 	struct vfio_device *device;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f435dfca15eb..660b8adf90a6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -58,6 +58,7 @@ extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
 extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
+extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {

