Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55240A183D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfH2LUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 07:20:12 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43766 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728171AbfH2LTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 07:19:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 14:19:17 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TBJ8v4020002;
        Thu, 29 Aug 2019 14:19:15 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v2 3/6] mdev: Expose mdev alias in sysfs tree
Date:   Thu, 29 Aug 2019 06:19:01 -0500
Message-Id: <20190829111904.16042-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190829111904.16042-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose the optional alias for an mdev device as a sysfs attribute.
This way, userspace tools such as udev may make use of the alias, for
example to create a netdevice name for the mdev.

Signed-off-by: Parav Pandit <parav@mellanox.com>

---
Changelog:
v0->v1:
 - Addressed comments from Cornelia Huck
 - Updated commit description
---
 drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 43afe0e80b76..59f4e3cc5233 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -246,7 +246,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_WO(remove);
 
+static ssize_t alias_show(struct device *device,
+			  struct device_attribute *attr, char *buf)
+{
+	struct mdev_device *dev = mdev_from_dev(device);
+
+	if (!dev->alias)
+		return -EOPNOTSUPP;
+
+	return sprintf(buf, "%s\n", dev->alias);
+}
+static DEVICE_ATTR_RO(alias);
+
 static const struct attribute *mdev_device_attrs[] = {
+	&dev_attr_alias.attr,
 	&dev_attr_remove.attr,
 	NULL,
 };
-- 
2.19.2

