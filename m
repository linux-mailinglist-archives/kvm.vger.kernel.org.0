Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3DE3E1A0F
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhHERIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237671AbhHERId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52ysVOWK9I9bBgN7ggwsw/lOUOadE8Uwd/lGY6JIZmE=;
        b=Eo83GyAghbYHgabniFmpmesLziruy4OreBsVV6GBVbAUNBQdPF/J8AKfjokZ9CMXOccWnq
        FyERqZ/zXP7R/447UhhGW30AYGHQplC0DR2HYudc+h+U9M6LPJUTilAPNDBKu71njh5S38
        XY6PrsiLxTdBl740lziJFnMrfJL6FeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-wbzGY5czNNO7psv5ypCTKA-1; Thu, 05 Aug 2021 13:08:17 -0400
X-MC-Unique: wbzGY5czNNO7psv5ypCTKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4031190D341;
        Thu,  5 Aug 2021 17:08:16 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87B3E5F724;
        Thu,  5 Aug 2021 17:08:12 +0000 (UTC)
Subject: [PATCH 6/7] vfio: Add vfio_device_io_remap_mapping_range()
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:08:12 -0600
Message-ID: <162818329235.1511194.15804833796430403640.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This provides a mirror of vfio_device_unmap_mapping_range() for
vmas mapping device memory where the pfn is provided by
vfio_device_vma_to_pfn().

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |    2 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 42ca93be152a..c5b3a3446dd9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/wait.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 
 #define DRIVER_VERSION	"0.3"
@@ -567,6 +568,49 @@ void vfio_device_unmap_mapping_range(struct vfio_device *device,
 }
 EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
 
+int vfio_device_io_remap_mapping_range(struct vfio_device *device,
+				       loff_t start, loff_t len)
+{
+	struct address_space *mapping = device->inode->i_mapping;
+	int ret = 0;
+
+	i_mmap_lock_write(mapping);
+	if (mapping_mapped(mapping)) {
+		struct rb_root_cached *root = &mapping->i_mmap;
+		pgoff_t pgstart = start >> PAGE_SHIFT;
+		pgoff_t pgend = (start + len - 1) >> PAGE_SHIFT;
+		struct vm_area_struct *vma;
+
+		vma_interval_tree_foreach(vma, root, pgstart, pgend) {
+			unsigned long pfn;
+			unsigned int flags;
+
+			ret = vfio_device_vma_to_pfn(device, vma, &pfn);
+			if (ret)
+				break;
+
+			/*
+			 * Force NOFS memory allocation context to avoid
+			 * deadlock while we hold i_mmap_rwsem.
+			 */
+			flags = memalloc_nofs_save();
+			ret = io_remap_pfn_range(vma, vma->vm_start, pfn,
+						 vma->vm_end - vma->vm_start,
+						 vma->vm_page_prot);
+			memalloc_nofs_restore(flags);
+			if (ret)
+				break;
+		}
+	}
+	i_mmap_unlock_write(mapping);
+
+	if (ret)
+		vfio_device_unmap_mapping_range(device, start, len);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_device_io_remap_mapping_range);
+
 /**
  * Device objects - create, release, get, put, search
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 5f07ebe0f85d..c2c51c7a6f05 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -71,6 +71,8 @@ extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
+extern int vfio_device_io_remap_mapping_range(struct vfio_device *device,
+					      loff_t start, loff_t len);
 extern int vfio_device_vma_to_pfn(struct vfio_device *device,
 				  struct vm_area_struct *vma,
 				  unsigned long *pfn);


