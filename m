Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8E331991
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhCHVsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:48:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231205AbhCHVsC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:48:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hW4A6VrZBqHMNaSKmE4dJ1kMW+0QH0GPJ90BtbinJGI=;
        b=FMWMcJKJSoV1S6rEi2QYw73knffYxedGCZTCb8SYRr80ZvQhzpBUgsN7nwrYltGnMGY3Cs
        9HcdTX4G4X6B5Qb7TA5BibaojtqGNaWM9KRz6UhhYCNiu0sjGt1ur81arhwbUvSCgYkWZh
        vpO3u3Z0cdmIENA8/OMu0SU+/t2B2lc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-7TjGgObcNPeYsZoGc7NIHQ-1; Mon, 08 Mar 2021 16:48:00 -0500
X-MC-Unique: 7TjGgObcNPeYsZoGc7NIHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9067526862;
        Mon,  8 Mar 2021 21:47:59 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D991101F513;
        Mon,  8 Mar 2021 21:47:53 +0000 (UTC)
Subject: [PATCH v1 03/14] vfio: Export unmap_mapping_range() wrapper
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:47:52 -0700
Message-ID: <161524007281.3480.3739694915199289018.stgit@gimli.home>
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

Allow bus drivers to use vfio pseudo fs mapping to zap all mmaps
across a range of their device files.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |    7 +++++++
 include/linux/vfio.h |    2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 34d32f16246a..3852e57b9e04 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -565,6 +565,13 @@ static struct inode *vfio_fs_inode_new(void)
 	return inode;
 }
 
+void vfio_device_unmap_mapping_range(struct vfio_device *device,
+				     loff_t start, loff_t len)
+{
+	unmap_mapping_range(device->inode->i_mapping, start, len, true);
+}
+EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
+
 /**
  * Device objects - create, release, get, put, search
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b784463000d4..f435dfca15eb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -56,6 +56,8 @@ extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
+extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
+					    loff_t start, loff_t len);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {

