Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DC933198C
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhCHVrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:47:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhCHVri (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5qWQV30xEvYhKMl4+qKvr7XLbSB144DLEcjcsYdfp1w=;
        b=aKL/06AqfWoo7gZz3xgFB1TlWfKyjccm94N1u9nu6aXOrA8Kn4BT9cwUegMJBOuuTrmBMO
        pDbXYW466Ex7BCXNff5sNFC0V69Ymun6ko8yD6PQaArpBkMyNtkhvDlf22I3Ap7PvkbJDe
        fDw/UMjAh+8j9ahLf3Gxjtm17K9ST/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-HSiE92j2N1GDfXZoE6nETg-1; Mon, 08 Mar 2021 16:47:36 -0500
X-MC-Unique: HSiE92j2N1GDfXZoE6nETg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7958B1005D4A;
        Mon,  8 Mar 2021 21:47:35 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A06941A878;
        Mon,  8 Mar 2021 21:47:28 +0000 (UTC)
Subject: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per device
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:47:28 -0700
Message-ID: <161524004828.3480.1817334832614722574.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By linking all the device fds we provide to userspace to an
address space through a new pseudo fs, we can use tools like
unmap_mapping_range() to zap all vmas associated with a device.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 38779e6fd80c..abdf8d52a911 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,11 +32,18 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pseudo_fs.h>
+#include <linux/mount.h>
 
 #define DRIVER_VERSION	"0.3"
 #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC	"VFIO - User Level meta-driver"
 
+#define VFIO_MAGIC 0x5646494f /* "VFIO" */
+
+static int vfio_fs_cnt;
+static struct vfsmount *vfio_fs_mnt;
+
 static struct vfio {
 	struct class			*class;
 	struct list_head		iommu_drivers_list;
@@ -97,6 +104,7 @@ struct vfio_device {
 	struct vfio_group		*group;
 	struct list_head		group_next;
 	void				*device_data;
+	struct inode			*inode;
 };
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -529,6 +537,34 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 	return group;
 }
 
+static int vfio_fs_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, VFIO_MAGIC) ? 0 : -ENOMEM;
+}
+
+static struct file_system_type vfio_fs_type = {
+	.name = "vfio",
+	.owner = THIS_MODULE,
+	.init_fs_context = vfio_fs_init_fs_context,
+	.kill_sb = kill_anon_super,
+};
+
+static struct inode *vfio_fs_inode_new(void)
+{
+	struct inode *inode;
+	int ret;
+
+	ret = simple_pin_fs(&vfio_fs_type, &vfio_fs_mnt, &vfio_fs_cnt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	inode = alloc_anon_inode(vfio_fs_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		simple_release_fs(&vfio_fs_mnt, &vfio_fs_cnt);
+
+	return inode;
+}
+
 /**
  * Device objects - create, release, get, put, search
  */
@@ -539,11 +575,19 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 					     void *device_data)
 {
 	struct vfio_device *device;
+	struct inode *inode;
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (!device)
 		return ERR_PTR(-ENOMEM);
 
+	inode = vfio_fs_inode_new();
+	if (IS_ERR(inode)) {
+		kfree(device);
+		return ERR_CAST(inode);
+	}
+	device->inode = inode;
+
 	kref_init(&device->kref);
 	device->dev = dev;
 	device->group = group;
@@ -574,6 +618,9 @@ static void vfio_device_release(struct kref *kref)
 
 	dev_set_drvdata(device->dev, NULL);
 
+	iput(device->inode);
+	simple_release_fs(&vfio_fs_mnt, &vfio_fs_cnt);
+
 	kfree(device);
 
 	/* vfio_del_group_dev may be waiting for this device */
@@ -1488,6 +1535,13 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 */
 	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
 
+	/*
+	 * Use the pseudo fs inode on the device to link all mmaps
+	 * to the same address space, allowing us to unmap all vmas
+	 * associated to this device using unmap_mapping_range().
+	 */
+	filep->f_mapping = device->inode->i_mapping;
+
 	atomic_inc(&group->container_users);
 
 	fd_install(ret, filep);

