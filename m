Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85663E19FF
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhHERHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:07:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236939AbhHERHW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l4Uq7TB3YUFBMp+pdj8dichS5azt5tuf8mailmjW03g=;
        b=WC0TxSMR292U9pD1S7at1qHGFlCf58VXjMp3SdE7TEfapZi3PlY3IrPIKJ1hp+JCHAfuDL
        K70Dp5zSNg1yBMdfdnAo9ShENMDksCQNGi9j8ju2yk+ywFyxh1Ls5KDQJ8k6W320h2UU0s
        fVkxXg/k8YvOsYR7P7LfnST+iKw8VME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-fLq1oFuCP2yEXpceXJwwMA-1; Thu, 05 Aug 2021 13:07:05 -0400
X-MC-Unique: fLq1oFuCP2yEXpceXJwwMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 678DF101C8A5;
        Thu,  5 Aug 2021 17:07:04 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BFA560BF4;
        Thu,  5 Aug 2021 17:06:57 +0000 (UTC)
Subject: [PATCH 0/7] vfio: device fd address space and vfio-pci mmap
 invalidation cleanup
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:06:57 -0600
Message-ID: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio-pci currently goes through some pretty nasty locking algorithms
since commit abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO
access on disabled memory") was added to invalidate and re-fault mmaps
to device MMIO around cases where device memory is disabled.  This
series greatly simplifies that by making use of an address space on
the vfio device file descriptor, as suggested by Jason Gunthorpe.
This allows us to use unmap_mapping_range() on the device fd to zap
such mappings, and by creating a vma-to-pfn callback, we can implement
a reverse function to restore all mappings.

This series was originally part of a larger series which also added a
callback to get a vfio device from a vma, which allows the IOMMU
backend to limit pfnmaps to vfio device memory.  The long term goal
is to implement the vma-to-pfn for all vfio device drivers to enable
this in the IOMMU backend and proceed with a mechanism to also
invalidate DMA mappings to device memory while disabled.

Given my slow progress towards that longer goal, I'd like to get this
in as an interim cleanup as it seems worthwhile on its own.  I'll
intend to rework this on top of Jason's device_open/close series.
Thanks,

Alex

---

Alex Williamson (7):
      vfio: Create vfio_fs_type with inode per device
      vfio: Export unmap_mapping_range() wrapper
      vfio/pci: Use vfio_device_unmap_mapping_range()
      vfio,vfio-pci: Add vma to pfn callback
      mm/interval_tree.c: Export vma interval tree iterators
      vfio: Add vfio_device_io_remap_mapping_range()
      vfio/pci: Remove map-on-fault behavior


 drivers/vfio/pci/vfio_pci.c         | 279 +++++++---------------------
 drivers/vfio/pci/vfio_pci_config.c  |   8 +-
 drivers/vfio/pci/vfio_pci_private.h |   5 +-
 drivers/vfio/vfio.c                 |  69 ++++++-
 include/linux/vfio.h                |  10 +
 mm/interval_tree.c                  |   3 +
 6 files changed, 156 insertions(+), 218 deletions(-)

