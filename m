Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2304A30F995
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhBDRYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:24:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238465AbhBDRYK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zc+XWtfGtASjsMASpHkffR1pL11AhNAnMUdubmKUbE8=;
        b=HDqF/3CD1/j+1U2Nr7g260J0ChyEqqwEL3QfH1OqilRzY7xcjyu/Mt+7vo+viGXpcGSanI
        o4lCf8yUU5C7483MXbxnTBbIrRf2Ag7BU5n1vCIHHtOrlUjq7dNeV7lFLogcKtNVQp5FeV
        kgEKH9bmGYVsVvQwyepNrCRkxKtU4pI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-GuaFadePOfu83dcFO57M_A-1; Thu, 04 Feb 2021 12:22:41 -0500
X-MC-Unique: GuaFadePOfu83dcFO57M_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2E1C879A0D;
        Thu,  4 Feb 2021 17:22:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4092D1A87C;
        Thu,  4 Feb 2021 17:22:31 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 00/13] vdpa: add vdpa simulator for block device
Date:   Thu,  4 Feb 2021 18:22:17 +0100
Message-Id: <20210204172230.85853-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
- added new patches
  - 'vringh: explain more about cleaning riov and wiov'
  - 'vdpa: add return value to get_config/set_config callbacks'
  - 'vhost/vdpa: remove vhost_vdpa_config_validate()'
- split Xie's patch 'vhost/vdpa: Remove the restriction that only supports
  virtio-net devices'
- updated Mellanox copyright to NVIDIA [Max]
- explained in the 'vdpa: add vdpa simulator for block device' commit
  message that inputs are validated in subsequent patches [Stefan]

v2: https://lore.kernel.org/lkml/20210128144127.113245-1-sgarzare@redhat.com/
v1: https://lore.kernel.org/lkml/93f207c0-61e6-3696-f218-e7d7ea9a7c93@redhat.com/

This series is the second part of the v1 linked above. The first part with
refactoring of vdpa_sim has already been merged.

The patches are based on Max Gurtovoy's work and extend the block simulator to
have a ramdisk behaviour.

As mentioned in the v1 there was 2 issues and I fixed them in this series:
1. The identical mapping in the IOMMU used until now in vdpa_sim created issues
   when mapping different virtual pages with the same physical address.
   Fixed by patch "vdpa_sim: use iova module to allocate IOVA addresses"

2. There was a race accessing the IOMMU between the vdpasim_blk_work() and the
   device driver that map/unmap DMA regions. Fixed by patch "vringh: add
   'iotlb_lock' to synchronize iotlb accesses"

I used the Xie's patch coming from VDUSE series to allow vhost-vdpa to use
block devices. As Jason suggested I split it into two patches and I added
a return value to get_config()/set_config() callbacks.

The series also includes small fixes for vringh, vdpa, and vdpa_sim that I
discovered while implementing and testing the block simulator.

Thanks for your feedback,
Stefano

Max Gurtovoy (1):
  vdpa: add vdpa simulator for block device

Stefano Garzarella (11):
  vdpa_sim: use iova module to allocate IOVA addresses
  vringh: add 'iotlb_lock' to synchronize iotlb accesses
  vringh: reset kiov 'consumed' field in __vringh_iov()
  vringh: explain more about cleaning riov and wiov
  vringh: implement vringh_kiov_advance()
  vringh: add vringh_kiov_length() helper
  vdpa_sim: cleanup kiovs in vdpasim_free()
  vdpa: add return value to get_config/set_config callbacks
  vhost/vdpa: remove vhost_vdpa_config_validate()
  vdpa_sim_blk: implement ramdisk behaviour
  vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID

Xie Yongji (1):
  vhost/vdpa: Remove the restriction that only supports virtio-net
    devices

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   2 +
 include/linux/vdpa.h                 |  18 +-
 include/linux/vringh.h               |  19 +-
 drivers/vdpa/ifcvf/ifcvf_main.c      |  24 ++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |  17 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 134 ++++++++-----
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 288 +++++++++++++++++++++++++++
 drivers/vhost/vdpa.c                 |  47 ++---
 drivers/vhost/vringh.c               |  69 +++++--
 drivers/vdpa/Kconfig                 |   8 +
 drivers/vdpa/vdpa_sim/Makefile       |   1 +
 11 files changed, 504 insertions(+), 123 deletions(-)
 create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c

-- 
2.29.2

