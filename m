Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E983031A55E
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBLT27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:28:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhBLT25 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613158051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SmXdhYbUwFwSJYJWGAUkTJ3lEIS/O65yIUkUv4tH8U0=;
        b=PcRH+tD2GlQzWXafnbwHVPa7nqeKG1QZFUBxo3JXbTK2XiMvahQv7WO8NtvtInRMKO2izV
        oB4JmbLIG5lOTJCBtcsMO6Cq9oyEE+aW+fjcrAhGrWUkZrk5jjIubCCBzZXyXm27zThWS6
        GRgI2JbaNymjuATDZiVjgW3vZhU9FQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-tcLrF6fIMReCvCKocU0IpQ-1; Fri, 12 Feb 2021 14:27:28 -0500
X-MC-Unique: tcLrF6fIMReCvCKocU0IpQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6722A1934104;
        Fri, 12 Feb 2021 19:27:27 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A85F210502;
        Fri, 12 Feb 2021 19:27:20 +0000 (UTC)
Subject: [PATCH 0/3] vfio: Device memory DMA mapping improvements
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Fri, 12 Feb 2021 12:27:19 -0700
Message-ID: <161315658638.7320.9686203003395567745.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series intends to improve some long standing issues with mapping
device memory through the vfio IOMMU interface (ie. P2P DMA mappings).
Unlike mapping DMA to RAM, we can't pin device memory, nor is it
always accessible.  We attempt to tackle this (predominantly the
first issue in this iteration) by creating a registration and
notification interface through vfio-core, between the IOMMU backend
and the bus driver.  This allows us to do things like automatically
remove a DMA mapping to device if it's closed by the user.  We also
keep references to the device container such that it remains isolated
while this mapping exists.

Unlike my previous attempt[1], this version works across containers.
For example if a user has device1 with IOMMU context in container1
and device2 in container2, a mapping of device2 memory into container1
IOMMU context would be removed when device2 is released.

What I don't tackle here is when device memory is disabled, such as
for a PCI device when the command register memory bit is cleared or
while the device is in reset.  Ideally is seems like it might be
nice to have IOMMU API interfaces that could remove r/w permissions
from the IOTLB entry w/o removing it entirely, but I'm also unsure
of the ultimate value in modifying the IOTLB entries at this point.

In the PCI example again, I'd expect a DMA to disabled or unavailable
device memory to get an Unsupported Request response.  If we play
with the IOTLB mapping, we might change this to an IOMMU fault for
either page permissions or page not present, depending on how we
choose to invalidate that entry.  However, it seems that a system that
escalates an UR error to fatal, through things like firmware first
handling, is just as likely to also make the IOMMU fault fatal.  Are
there cases where we expect otherwise, and if not is there value to
tracking device memory enable state to that extent in the IOMMU?

Jason, I'm also curious if this scratches your itch relative to your
suggestion to solve this with dma-bufs, and if that's still your
preference, I'd love an outline to accomplish this same with that
method.

Thanks,
Alex

[1]https://lore.kernel.org/kvm/158947414729.12590.4345248265094886807.stgit@gimli.home/

---

Alex Williamson (3):
      vfio: Introduce vma ops registration and notifier
      vfio/pci: Implement vm_ops registration
      vfio/type1: Implement vma registration and restriction


 drivers/vfio/pci/Kconfig            |    1 
 drivers/vfio/pci/vfio_pci.c         |   87 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    1 
 drivers/vfio/vfio.c                 |  120 ++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c     |  192 ++++++++++++++++++++++++++++-------
 include/linux/vfio.h                |   20 ++++
 6 files changed, 384 insertions(+), 37 deletions(-)

