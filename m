Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3254B102CD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfD3Wv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:51:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45902 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727573AbfD3Wtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:53 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:48 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncnZ009688;
        Wed, 1 May 2019 01:49:47 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 05/10] vfio/mdev: Follow correct remove sequence
Date:   Tue, 30 Apr 2019 17:49:32 -0500
Message-Id: <20190430224937.57156-6-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev_remove_sysfs_files() should follow exact mirror sequence of a
create, similar to what is followed in error unwinding path of
mdev_create_sysfs_files().

Fixes: 6a62c1dfb5c7 ("vfio/mdev: Re-order sysfs attribute creation")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 5193a0e0ce5a..cbf94b8165ea 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -280,7 +280,7 @@ int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
 
 void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
 {
+	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 	sysfs_remove_link(&dev->kobj, "mdev_type");
 	sysfs_remove_link(type->devices_kobj, dev_name(dev));
-	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 }
-- 
2.19.2

