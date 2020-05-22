Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76381DEFD9
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgEVTRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 15:17:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56769 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730795AbgEVTRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 15:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590175041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jx7M5hh5OlPJaLkcPE2uUud79NeL6y2HrKLpO8B3VK0=;
        b=EXcmYo7XKI9xFHruCALmxH3ZbNnsNL3XIekVhFT31sfggLrZUJ+dNWAwjyoipCVT8WENoV
        38Tpq9hFU+imQk2Ws3VnSL1P4L2SQISfYplsu6u8RwBporRVl8FT4rVUCQaNHprLVtvdek
        lx4guVW2//QySe9uzG7pbHUl9JZ1gJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-DkHHKDiBPry1-5yCOZuL_w-1; Fri, 22 May 2020 15:17:16 -0400
X-MC-Unique: DkHHKDiBPry1-5yCOZuL_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B158474;
        Fri, 22 May 2020 19:17:15 +0000 (UTC)
Received: from gimli.home (ovpn-114-203.phx2.redhat.com [10.3.114.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0BAC6C77E;
        Fri, 22 May 2020 19:17:09 +0000 (UTC)
Subject: [PATCH v3 0/3] vfio-pci: Block user access to disabled device MMIO
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com, cai@lca.pw
Date:   Fri, 22 May 2020 13:17:09 -0600
Message-ID: <159017449210.18853.15037950701494323009.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:

The memory_lock semaphore is only held in the MSI-X path for callouts
to functions that may access MSI-X MMIO space of the device, this
should resolve the circular locking dependency reported by Qian
(re-testing very much appreciated).  I've also incorporated the
pci_map_rom() and pci_unmap_rom() calls under the memory_lock.  Commit
0cfd027be1d6 ("vfio_pci: Enable memory accesses before calling
pci_map_rom") made sure memory was enabled on the info path, but did
not provide locking to protect that state.  The r/w path of the BAR
access is expanded to include ROM mapping/unmapping.  Unless there
are objections, I'll plan to drop v2 from my next branch and replace
it with this.  Thanks,

Alex

v2:

Locking in 3/ is substantially changed to avoid the retry scenario
within the fault handler, therefore a caller who does not allow retry
will no longer receive a SIGBUS on contention.  IOMMU invalidations
are still not included here, I expect that will be a future follow-on
change as we're not fundamentally changing that issue in this series.
The 'add to vma list only on fault' behavior is also still included
here, per the discussion I think it's still a valid approach and has
some advantages, particularly in a VM scenario where we potentially
defer the mapping until the MMIO BAR is actually DMA mapped into the
VM address space (or the guest driver actually accesses the device
if that DMA mapping is eliminated at some point).  Further discussion
and review appreciated.  Thanks,

Alex

v1:

Add tracking of the device memory enable bit and block/fault accesses
to device MMIO space while disabled.  This provides synchronous fault
handling for CPU accesses to the device and prevents the user from
triggering platform level error handling present on some systems.
Device reset and MSI-X vector table accesses are also included such
that access is blocked across reset and vector table accesses do not
depend on the user configuration of the device.

This is based on the vfio for-linus branch currently in next, making
use of follow_pfn() in vaddr_get_pfn() and therefore requiring patch
1/ to force the user fault in the case that a PFNMAP vma might be
DMA mapped before user access.  Further PFNMAP iommu invalidation
tracking is not yet included here.

As noted in the comments, I'm copying quite a bit of the logic from
rdma code for performing the zap_vma_ptes() calls and I'm also
attempting to resolve lock ordering issues in the fault handler to
lockdep's satisfaction.  I appreciate extra eyes on these sections in
particular.

I expect this to be functionally equivalent for any well behaved
userspace driver, but obviously there is a potential for the user to
get -EIO or SIGBUS on device access.  The device is provided to the
user enabled and device resets will restore the command register, so
by my evaluation a user would need to explicitly disable the memory
enable bit to trigger these faults.  We could potentially remap vmas
to a zero page rather than SIGBUS if we experience regressions, but
without known code requiring that, SIGBUS seems the appropriate
response to this condition.  Thanks,

Alex

---

Alex Williamson (3):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory


 drivers/vfio/pci/vfio_pci.c         |  349 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_config.c  |   36 +++-
 drivers/vfio/pci/vfio_pci_intrs.c   |   14 +
 drivers/vfio/pci/vfio_pci_private.h |   15 ++
 drivers/vfio/pci/vfio_pci_rdwr.c    |   24 ++
 drivers/vfio/vfio_iommu_type1.c     |   36 +++-
 6 files changed, 435 insertions(+), 39 deletions(-)

