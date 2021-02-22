Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0845B321D6E
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhBVQwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:52:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhBVQwA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CgcpckDo9UEWBagLaIjLCEPd9ZKR8yZthDIdNf7Trmc=;
        b=iqEmFTrbr6PuSzXSjQX4wO2CKRv4h2PwG0jgnsIlArmYlQ/6DoCDHL69WMQcyl9RC7RTfx
        qV4DPsoW+ZFGZvavyUMMKLiL7eAylddS12d6fSwBaCAWoMUGErt6xNs4FY+3D4laGBKYYI
        9caPjFxXtotnmcysN+MCbQIpW0KkvlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-TU9vfHv_MuKmOaZx2C8S7Q-1; Mon, 22 Feb 2021 11:50:32 -0500
X-MC-Unique: TU9vfHv_MuKmOaZx2C8S7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1764ECC627;
        Mon, 22 Feb 2021 16:50:30 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A3FA5D9D3;
        Mon, 22 Feb 2021 16:50:23 +0000 (UTC)
Subject: [RFC PATCH 00/10] vfio: Device memory DMA mapping improvements
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:50:22 -0700
Message-ID: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a re-implementation of [1] following suggestions and code from
Jason Gunthorpe.  This is lightly tested but seems functional and
throws no lockdep warnings.  In this series we tremendously simplify
zapping of vmas mapping device memory using unmap_mapping_range(), we
create a protocol for looking up a vfio_device from a vma and provide
an interface to get a reference from that vma, using that device
reference, the caller can register a notifier for the device to
trigger on events such as device release.  This notifier is only
enabled here for vfio-pci, but both the vma policy and the notifier
trigger should be trivial to add to any vfio bus driver after RFC.

Does this look more like the direction we should go?

Note that like the last series we're still not dropping DMA mappings
on device memory disable as this would likely break userspace in some
instances, we don't have IOMMU interfaces to modify protection bits,
and it's not clear an IOMMU fault is absolutely better than the bus
error.  Thanks,

Alex

[1]https://lore.kernel.org/kvm/161315658638.7320.9686203003395567745.stgit@gimli.home/T/#m64859ccd7d92f39a924759c7423f2dcf7d367c84
---

Alex Williamson (10):
      vfio: Create vfio_fs_type with inode per device
      vfio: Update vfio_add_group_dev() API
      vfio: Export unmap_mapping_range() wrapper
      vfio/pci: Use vfio_device_unmap_mapping_range()
      vfio: Create a vfio_device from vma lookup
      vfio: Add a device notifier interface
      vfio/pci: Notify on device release
      vfio/type1: Refactor pfn_list clearing
      vfio/type1: Pass iommu and dma objects through to vaddr_get_pfn
      vfio/type1: Register device notifier


 drivers/vfio/Kconfig                         |    1 
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |    6 -
 drivers/vfio/mdev/vfio_mdev.c                |    5 -
 drivers/vfio/pci/vfio_pci.c                  |  223 ++++----------------------
 drivers/vfio/pci/vfio_pci_private.h          |    3 
 drivers/vfio/platform/vfio_platform_common.c |    7 +
 drivers/vfio/vfio.c                          |  143 +++++++++++++++--
 drivers/vfio/vfio_iommu_type1.c              |  211 ++++++++++++++++++++-----
 include/linux/vfio.h                         |   19 ++
 9 files changed, 368 insertions(+), 250 deletions(-)

