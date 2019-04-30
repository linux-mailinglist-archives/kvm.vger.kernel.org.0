Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE3102D1
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfD3Wtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:49:49 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45865 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbfD3Wts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:48 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:42 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncnV009688;
        Wed, 1 May 2019 01:49:41 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 01/10] vfio/mdev: Avoid release parent reference during error path
Date:   Tue, 30 Apr 2019 17:49:28 -0500
Message-Id: <20190430224937.57156-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During mdev parent registration in mdev_register_device(),
if parent device is duplicate, it releases the reference of existing
parent device.
This is incorrect. Existing parent device should not be touched.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b96fedc77ee5..1299d2e72ce2 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -181,6 +181,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	/* Check for duplicate */
 	parent = __find_parent_device(dev);
 	if (parent) {
+		parent = NULL;
 		ret = -EEXIST;
 		goto add_dev_err;
 	}
-- 
2.19.2

