Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FFA102A5
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfD3WuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:50:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45945 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727636AbfD3Wt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:58 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:55 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncnd009688;
        Wed, 1 May 2019 01:49:53 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on stale device removal
Date:   Tue, 30 Apr 2019 17:49:36 -0500
Message-Id: <20190430224937.57156-10-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If device is removal is initiated by two threads as below, mdev core
attempts to create a syfs remove file on stale device.
During this flow, below [1] call trace is observed.

     cpu-0                                    cpu-1
     -----                                    -----
  mdev_unregister_device()
    device_for_each_child
       mdev_device_remove_cb
          mdev_device_remove
                                       user_syscall
                                         remove_store()
                                           mdev_device_remove()
                                        [..]
   unregister device();
                                       /* not found in list or
                                        * active=false.
                                        */
                                          sysfs_create_file()
                                          ..Call trace

Now that mdev core follows correct device removal system of the linux
bus model, remove shouldn't fail in normal cases. If it fails, there is
no point of creating a stale file or checking for specific error status.

kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
sysfs_create_file_ns+0x7f/0x90
kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
5.1.0-rc6-vdevbus+ #6
kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
08/09/2016
kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
kernel: Call Trace:
kernel: remove_store+0xdc/0x100 [mdev]
kernel: kernfs_fop_write+0x113/0x1a0
kernel: vfs_write+0xad/0x1b0
kernel: ksys_write+0x5a/0xe0
kernel: do_syscall_64+0x5a/0x210
kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 9f774b91d275..ffa3dcebf201 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -237,10 +237,8 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 		int ret;
 
 		ret = mdev_device_remove(dev);
-		if (ret) {
-			device_create_file(dev, attr);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return count;
-- 
2.19.2

