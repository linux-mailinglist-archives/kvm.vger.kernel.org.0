Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A482998F
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403991AbfEXN5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 09:57:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60647 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403895AbfEXN5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 09:57:43 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 May 2019 16:57:41 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4ODvdQr019054;
        Fri, 24 May 2019 16:57:40 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv4 0/3] vfio/mdev: Improve vfio/mdev core module
Date:   Fri, 24 May 2019 08:57:35 -0500
Message-Id: <20190524135738.54862-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we would like to use mdev subsystem for wider use case as
discussed in [1], [2] apart from an offline discussion.
This use case is also discussed with wider forum in [4] in track
'Lightweight NIC HW functions for container offload use cases'.

This series is prep-work and improves vfio/mdev module in following ways.

Patch-1 Improves the mdev create/remove sequence to match Linux
bus, device model
Patch-2 Avoid recreating remove file on stale device to eliminate
call trace
Patch-3 Fix race conditions of create/remove with parent removal.
This is improved version than using srcu as srcu can take seconds
to minutes.

This series is tested using
(a) mtty with VM using vfio_mdev driver for positive tests and device
removal while device in use by VM using vfio_mdev driver.

(b) mlx5 core driver using RFC patches [3] and internal patches.
Internal patches are large and cannot be combined with this prep-work
patches. It will posted once prep-work completes.

[1] https://www.spinics.net/lists/netdev/msg556978.html
[2] https://lkml.org/lkml/2019/3/7/696
[3] https://lkml.org/lkml/2019/3/8/819
[4] https://netdevconf.org/0x13/session.html?workshop-hardware-offload

---
Changelog:
---
v3->v4:
 - Addressed comments from Cornelia for unbalanced mutex_unlock
 - Correct typo of subsquent to subsequent in patch-1 commit log
 - Instead of using refcount and completion, using rwsem to synchronize
   between mdev creation/deletion and parent unregistration
v2->v3:
 - Addressed comment from Cornelia
 - Corrected several errors in commit log, updated commit log
 - Dropped already merged 7 patches
v1->v2:
 - Addressed comments from Alex
 - Rebased
 - Inserted the device checking loop in Patch-6 as original code
 - Added patch 7 to 10
 - Added fixes for race condition in create/remove with parent removal
   Patch-10 uses simplified refcount and completion, instead of srcu
   which might take seconds to minutes on busy system.
 - Added fix for device create/remove sequence to match
   Linux device, bus model
v0->v1:
 - Dropped device placement on bus sequence patch for this series
 - Addressed below comments from Alex, Kirti, Maxim.
 - Added Review-by tag for already reviewed patches.
 - Dropped incorrect patch of put_device().
 - Corrected Fixes commit tag for sysfs remove sequence fix
 - Split last 8th patch to smaller refactor and fixes patch
 - Following coding style commenting format
 - Fixed accidental delete of mutex_lock in mdev_unregister_device
 - Renamed remove helped to mdev_device_remove_common().
 - Rebased for uuid/guid change

Parav Pandit (3):
  vfio/mdev: Improve the create/remove sequence
  vfio/mdev: Avoid creating sysfs remove file on stale device removal
  vfio/mdev: Synchronize device create/remove with parent removal

 drivers/vfio/mdev/mdev_core.c    | 125 ++++++++++++++-----------------
 drivers/vfio/mdev/mdev_private.h |   4 +-
 drivers/vfio/mdev/mdev_sysfs.c   |   6 +-
 3 files changed, 62 insertions(+), 73 deletions(-)

-- 
2.19.2

