Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3902321D7A
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhBVQxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:53:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231478AbhBVQxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScOwtZfsBfs3LX8QPLUz2J4hjmFvF5QjW3WOO14yaj8=;
        b=WEYIcp/rEeAeiIoAPdolDIaF9wgV/NwD0/Nku/k21ZlTBV7G/xg7ZGC8RPBCHBZiZNBnUv
        yC6xXV16wM7fg0EdgzIoITmwnnM9Bn/pUjUo8WEt1XvmiYrSGiUkICx3NyJ7qz2TRa2GvS
        U56RhlWTXCl7P//zfNFYdpJ7P5blw1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-fHKP-MOyNQOfDhHfKM2YeQ-1; Mon, 22 Feb 2021 11:51:51 -0500
X-MC-Unique: fHKP-MOyNQOfDhHfKM2YeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A00CC623;
        Mon, 22 Feb 2021 16:51:50 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22A5257;
        Mon, 22 Feb 2021 16:51:39 +0000 (UTC)
Subject: [RFC PATCH 06/10] vfio: Add a device notifier interface
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:51:38 -0700
Message-ID: <161401269874.16443.4238313694176658818.stgit@gimli.home>
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

Using a vfio device, a notifier block can be registered to receive
select device events.  Notifiers can only be registered for contained
devices, ie. they are available through a user context.  Registration
of a notifier increments the reference to that container context
therefore notifiers must minimally respond to the release event by
asynchronously removing notifiers.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/Kconfig |    1 +
 drivers/vfio/vfio.c  |   35 +++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |    9 +++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 5533df91b257..8ac1601b681b 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -23,6 +23,7 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
+	select SRCU
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 399c42b77fbb..1a1b46215ac4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -105,6 +105,7 @@ struct vfio_device {
 	struct list_head		group_next;
 	void				*device_data;
 	struct inode			*inode;
+	struct srcu_notifier_head	notifier;
 };
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -610,6 +611,7 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	device->ops = ops;
 	device->device_data = device_data;
 	dev_set_drvdata(dev, device);
+	srcu_init_notifier_head(&device->notifier);
 
 	/* No need to get group_lock, caller has group reference */
 	vfio_group_get(group);
@@ -1778,6 +1780,39 @@ static const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
+int vfio_device_register_notifier(struct vfio_device *device,
+				  struct notifier_block *nb)
+{
+	int ret;
+
+	/* Container ref persists until unregister on success */
+	ret =  vfio_group_add_container_user(device->group);
+	if (ret)
+		return ret;
+
+	ret = srcu_notifier_chain_register(&device->notifier, nb);
+	if (ret)
+		vfio_group_try_dissolve_container(device->group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_device_register_notifier);
+
+void vfio_device_unregister_notifier(struct vfio_device *device,
+				    struct notifier_block *nb)
+{
+	if (!srcu_notifier_chain_unregister(&device->notifier, nb))
+		vfio_group_try_dissolve_container(device->group);
+}
+EXPORT_SYMBOL_GPL(vfio_device_unregister_notifier);
+
+int vfio_device_notifier_call(struct vfio_device *device,
+			      enum vfio_device_notify_type event)
+{
+	return srcu_notifier_call_chain(&device->notifier, event, NULL);
+}
+EXPORT_SYMBOL_GPL(vfio_device_notifier_call);
+
 /**
  * External user API, exported by symbols to be linked dynamically.
  *
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 188c2f3feed9..8217cd4ea53d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -60,6 +60,15 @@ extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
 extern void vfio_device_vma_open(struct vm_area_struct *vma);
 extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
+extern int vfio_device_register_notifier(struct vfio_device *device,
+					 struct notifier_block *nb);
+extern void vfio_device_unregister_notifier(struct vfio_device *device,
+					    struct notifier_block *nb);
+enum vfio_device_notify_type {
+	VFIO_DEVICE_RELEASE = 0,
+};
+int vfio_device_notifier_call(struct vfio_device *device,
+			      enum vfio_device_notify_type event);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {

