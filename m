Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5D3E1A03
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhHERHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236937AbhHERHf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=flm8HIEA9Hn4PQkZkDKodDdN26bAb3fK34DI1Ef+s1Y=;
        b=JxGySDyXy7NRqauDdkvZdtyq/Nnba1G61d3b5DJ3brrlrgSSMCJttYywAyOpASUtWIH2W4
        oUxqIVFyU9l/+t6ZVO1mT3xIo7DsgRp/V+MjbAFjSH/ZxCkHR+3oqnjsofBUUaKrGfPJn8
        1QhP2kBZA831z8bFTi1m2pOmlm9NK5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-QtE1bS47OD62_5TOMO9ZJQ-1; Thu, 05 Aug 2021 13:07:18 -0400
X-MC-Unique: QtE1bS47OD62_5TOMO9ZJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C9B3190A7A0;
        Thu,  5 Aug 2021 17:07:17 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7DD71000186;
        Thu,  5 Aug 2021 17:07:09 +0000 (UTC)
Subject: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:07:09 -0600
Message-ID: <162818322947.1511194.6035266132085405252.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By linking all the device fds we provide to userspace to an
address space through a new pseudo fs, we can use tools like
unmap_mapping_range() to zap all vmas associated with a device.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |    1 +
 2 files changed, 58 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 02cc51ce6891..b88de89bda31 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -21,8 +21,10 @@
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/pseudo_fs.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -37,6 +39,14 @@
 #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC	"VFIO - User Level meta-driver"
 
+/*
+ * Not exposed via UAPI
+ *
+ * XXX Adopt the following when available:
+ * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/
+ */
+#define VFIO_MAGIC 0x5646494f /* "VFIO" */
+
 static struct vfio {
 	struct class			*class;
 	struct list_head		iommu_drivers_list;
@@ -46,6 +56,8 @@ static struct vfio {
 	struct mutex			group_lock;
 	struct cdev			group_cdev;
 	dev_t				group_devt;
+	struct vfsmount			*vfio_fs_mnt;
+	int				vfio_fs_cnt;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -519,6 +531,35 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
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
+	ret = simple_pin_fs(&vfio_fs_type,
+			    &vfio.vfio_fs_mnt, &vfio.vfio_fs_cnt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	inode = alloc_anon_inode(vfio.vfio_fs_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		simple_release_fs(&vfio.vfio_fs_mnt, &vfio.vfio_fs_cnt);
+
+	return inode;
+}
+
 /**
  * Device objects - create, release, get, put, search
  */
@@ -783,6 +824,12 @@ int vfio_register_group_dev(struct vfio_device *device)
 		return -EBUSY;
 	}
 
+	device->inode = vfio_fs_inode_new();
+	if (IS_ERR(device->inode)) {
+		vfio_group_put(group);
+		return PTR_ERR(device->inode);
+	}
+
 	/* Our reference on group is moved to the device */
 	device->group = group;
 
@@ -907,6 +954,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	group->dev_counter--;
 	mutex_unlock(&group->device_lock);
 
+	iput(device->inode);
+	simple_release_fs(&vfio.vfio_fs_mnt, &vfio.vfio_fs_cnt);
+
 	/*
 	 * In order to support multiple devices per group, devices can be
 	 * plucked from the group while other devices in the group are still
@@ -1411,6 +1461,13 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
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
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a2c5b30e1763..90bcc2e9c8eb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -24,6 +24,7 @@ struct vfio_device {
 	refcount_t refcount;
 	struct completion comp;
 	struct list_head group_next;
+	struct inode *inode;
 };
 
 /**


