Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B03307864
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhA1OnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231276AbhA1OnH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:43:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oKQyktnzCEz0hqPUDHkW7dyXbU3t7aSFEMciUM7CkaI=;
        b=BAADef/ICk1xX1ZSazXf93rtvnjaKHt6z25/lDsw4o+PCsuEZig1DthmAwvCX1zrfv94Bv
        2AZAA9/bKHaV1fRjM5P1Siy38PZl/1p1NV+ZOqbZXq6s4Aa7ytZHKj62zHsLXnuXXEO9AY
        zuuzsTQhF1VYfps+VqmjxzdDn3mwSiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-oddZIRJDMeiHx4rcSfnbdg-1; Thu, 28 Jan 2021 09:41:37 -0500
X-MC-Unique: oddZIRJDMeiHx4rcSfnbdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784211800D41;
        Thu, 28 Jan 2021 14:41:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 832AE60875;
        Thu, 28 Jan 2021 14:41:28 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 00/10] vdpa: add vdpa simulator for block device
Date:   Thu, 28 Jan 2021 15:41:17 +0100
Message-Id: <20210128144127.113245-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Since this series is still a RFC, I used the Xie's patch as is to allow
vhost-vdpa to use block devices, but I'll rebase when he splits it into
multiple patches.

The series also includes small fixes for vdpa_sim that I discovered while
implementing the block simulator.

Thanks for your feedback,
Stefano

Max Gurtovoy (1):
  vdpa: add vdpa simulator for block device

Stefano Garzarella (8):
  vdpa_sim: use iova module to allocate IOVA addresses
  vringh: add 'iotlb_lock' to synchronize iotlb accesses
  vringh: reset kiov 'consumed' field in __vringh_iov()
  vringh: implement vringh_kiov_advance()
  vringh: add vringh_kiov_length() helper
  vdpa_sim: cleanup kiovs in vdpasim_free()
  vdpa_sim_blk: implement ramdisk behaviour
  vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID

Xie Yongji (1):
  vdpa: Remove the restriction that only supports virtio-net devices

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   2 +
 include/linux/vringh.h               |  19 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 118 +++++++----
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 288 +++++++++++++++++++++++++++
 drivers/vhost/vdpa.c                 |  28 +--
 drivers/vhost/vringh.c               |  54 +++--
 drivers/vdpa/Kconfig                 |   8 +
 drivers/vdpa/vdpa_sim/Makefile       |   1 +
 8 files changed, 433 insertions(+), 85 deletions(-)
 create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c

-- 
2.29.2

