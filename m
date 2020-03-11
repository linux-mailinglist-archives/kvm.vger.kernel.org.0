Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D818244A
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgCKV6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:58:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729726AbgCKV6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 17:58:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583963924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UO6irQAkGyQ/Cqy5oQ7oIcu+pBDHAQ9auYgdZN2lko=;
        b=On0tNK9szZtUsWucECCX3m6GZPoSjb51MsmzxhV0Ful/M3+CJCed99gX8bbtjfm97t8jU5
        ag8uqUUFTHyMGWtNosrO2aH3HFep/1y6lzPeeOQYf/8cN57zbkuTTyBbOM0ZXqvXnAiPJN
        THrqmXRT4eepZNWpMXWcobffZHL9Aqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-ywR8Vb8LMEGvUWxOGU69gg-1; Wed, 11 Mar 2020 17:58:40 -0400
X-MC-Unique: ywR8Vb8LMEGvUWxOGU69gg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AF501088388;
        Wed, 11 Mar 2020 21:58:38 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBC1E92972;
        Wed, 11 Mar 2020 21:58:34 +0000 (UTC)
Subject: [PATCH v3 1/7] vfio: Include optional device match in
 vfio_device_ops callbacks
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com, kevin.tian@intel.com
Date:   Wed, 11 Mar 2020 15:58:34 -0600
Message-ID: <158396391448.5601.14344561558422706517.stgit@gimli.home>
In-Reply-To: <158396044753.5601.14804870681174789709.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow bus drivers to provide their own callback to match a device to
the user provided string.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |   20 ++++++++++++++++----
 include/linux/vfio.h |    4 ++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c8482624ca34..0bd77d6ea691 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -875,11 +875,23 @@ EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
-	struct vfio_device *it, *device = NULL;
+	struct vfio_device *it, *device = ERR_PTR(-ENODEV);
 
 	mutex_lock(&group->device_lock);
 	list_for_each_entry(it, &group->device_list, group_next) {
-		if (!strcmp(dev_name(it->dev), buf)) {
+		int ret;
+
+		if (it->ops->match) {
+			ret = it->ops->match(it->device_data, buf);
+			if (ret < 0) {
+				device = ERR_PTR(ret);
+				break;
+			}
+		} else {
+			ret = !strcmp(dev_name(it->dev), buf);
+		}
+
+		if (ret) {
 			device = it;
 			vfio_device_get(device);
 			break;
@@ -1430,8 +1442,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 		return -EPERM;
 
 	device = vfio_device_get_from_name(group, buf);
-	if (!device)
-		return -ENODEV;
+	if (IS_ERR(device))
+		return PTR_ERR(device);
 
 	ret = device->ops->open(device->device_data);
 	if (ret) {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..029694b977f2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -26,6 +26,9 @@
  *         operations documented below
  * @mmap: Perform mmap(2) on a region of the device file descriptor
  * @request: Request for the bus driver to release the device
+ * @match: Optional device name match callback (return: 0 for no-match, >0 for
+ *         match, -errno for abort (ex. match with insufficient or incorrect
+ *         additional args)
  */
 struct vfio_device_ops {
 	char	*name;
@@ -39,6 +42,7 @@ struct vfio_device_ops {
 			 unsigned long arg);
 	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
 	void	(*request)(void *device_data, unsigned int count);
+	int	(*match)(void *device_data, char *buf);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);

