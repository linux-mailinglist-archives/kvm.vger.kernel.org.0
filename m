Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DD6321D75
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhBVQxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:53:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231340AbhBVQwg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzp0VHuXflaSzr4YP7UkIUcUa63Bg3Yc8ylwuaHiZ/Y=;
        b=NI+2jK+kjgkmiznMJStCkVintjQ2+PXLIzyAJoy8Cxz6t2LiHjaXcDLhMoRsJ8b8t6Cojo
        VBWsjtHO38eV3CpUg+HS8s77WuTWLOcs5gigY7R6wRAgcaw5TFXRa7XTPyu7IukVTJ+X3l
        +egqo/FQPdyveXW8hNb88+uzQJoIiaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-vBJJ812AP6GE3mDmp3VvGg-1; Mon, 22 Feb 2021 11:51:09 -0500
X-MC-Unique: vBJJ812AP6GE3mDmp3VvGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1835A192AB78;
        Mon, 22 Feb 2021 16:51:08 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A92315C1BD;
        Mon, 22 Feb 2021 16:50:59 +0000 (UTC)
Subject: [RFC PATCH 03/10] vfio: Export unmap_mapping_range() wrapper
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:50:59 -0700
Message-ID: <161401265929.16443.14593298513137995113.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 067cd843961c..da212425ab30 100644
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

