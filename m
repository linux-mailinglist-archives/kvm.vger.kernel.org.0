Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16049331993
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCHVsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:48:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231195AbhCHVrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D+es/eWhmxxz29JK+WvmP/Ck2/6vYOLc/3sWGVtLCbc=;
        b=RFgXid9+IxNYras43sTW+ZLPZD7AskI0UkHzUclZIRk9RuxgTNb6oIQ+vGwMHTm3qsfGrK
        tW7D+cKcvSb/fhZESF6K80UW68sNiWWBEwZ8T/gCSBfsJX+S9m7dwmBAJXg/H5tZhmppdw
        1NjhZfe65sYslA30mZlvFe+Rx68n+Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-5e4ZJSszOj6VeyxB2DsjeQ-1; Mon, 08 Mar 2021 16:47:24 -0500
X-MC-Unique: 5e4ZJSszOj6VeyxB2DsjeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A241005D45;
        Mon,  8 Mar 2021 21:47:23 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66601037E80;
        Mon,  8 Mar 2021 21:47:16 +0000 (UTC)
Subject: [PATCH v1 00/14] vfio: Device memory DMA mapping improvements
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:47:16 -0700
Message-ID: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The primary goal of this series is to better manage device memory
mappings, both with a much simplified scheme to zap CPU mappings of
device memory using unmap_mapping_range() and also to restrict IOMMU
mappings of PFNMAPs to vfio device memory and drop those mappings on
device release.  This series updates vfio-pci to include the necessary
vma-to-pfn interface, allowing the type1 IOMMU backend to recognize
vfio device memory.  If other bus drivers support peer-to-peer DMA,
they should be updated with a similar callback and trigger the device
notifier on release.

RFC->v1:

 - Fix some incorrect ERR handling
 - Fix use of vm_pgoff to be compatible with unmap_mapping_range()
 - Add vma-to-pfn interfaces
 - Generic device-from-vma handling
 - pfnmap obj directly maps back to vfio_dma obj
 - No bypass for strict MMIO handling
 - Batch PFNMAP handling
 - Follow-on patches to cleanup "extern" usage and bare unsigned

Works in my environment, further testing always appreciated.  This
will need to be merged with a solution for concurrent fault handling.
Thanks especially to Jason Gunthorpe for previous reviews and
suggestions.  Thanks,

Alex

RFC:https://lore.kernel.org/kvm/161401167013.16443.8389863523766611711.stgit@gimli.home/

---

Alex Williamson (14):
      vfio: Create vfio_fs_type with inode per device
      vfio: Update vfio_add_group_dev() API
      vfio: Export unmap_mapping_range() wrapper
      vfio/pci: Use vfio_device_unmap_mapping_range()
      vfio: Create a vfio_device from vma lookup
      vfio: Add vma to pfn callback
      vfio: Add a device notifier interface
      vfio/pci: Notify on device release
      vfio/type1: Refactor pfn_list clearing
      vfio/type1: Pass iommu and dma objects through to vaddr_get_pfn
      vfio/type1: Register device notifier
      vfio/type1: Support batching of device mappings
      vfio: Remove extern from declarations across vfio
      vfio: Cleanup use of bare unsigned


 Documentation/driver-api/vfio-mediated-device.rst |   19 +-
 Documentation/driver-api/vfio.rst                 |    8 -
 drivers/s390/cio/vfio_ccw_cp.h                    |   13 +
 drivers/s390/cio/vfio_ccw_private.h               |   14 +
 drivers/s390/crypto/vfio_ap_private.h             |    2 
 drivers/vfio/Kconfig                              |    1 
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                 |    6 -
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |    7 -
 drivers/vfio/mdev/vfio_mdev.c                     |    5 
 drivers/vfio/pci/vfio_pci.c                       |  229 ++++-----------------
 drivers/vfio/pci/vfio_pci_intrs.c                 |   42 ++--
 drivers/vfio/pci/vfio_pci_private.h               |   69 +++---
 drivers/vfio/platform/vfio_platform_common.c      |    7 -
 drivers/vfio/platform/vfio_platform_irq.c         |   21 +-
 drivers/vfio/platform/vfio_platform_private.h     |   31 +--
 drivers/vfio/vfio.c                               |  154 ++++++++++++--
 drivers/vfio/vfio_iommu_type1.c                   |  234 +++++++++++++++------
 include/linux/vfio.h                              |  129 ++++++------
 18 files changed, 543 insertions(+), 448 deletions(-)

