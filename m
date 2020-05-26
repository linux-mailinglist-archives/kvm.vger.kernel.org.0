Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8F41C637B
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgEEVyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:54:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728076AbgEEVyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588715682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ruRIwLyK3gyVc7TdrpR1YTdwCD5wsXYlQVD4A6a2gC0=;
        b=Z5awgtQ+EzvoF8OL89jHpl6wo6hX46B4bHGEhTziC+RjddY6YSf0ZS4VqqBowbiOlykF4o
        Ged2iwtpftOgJQvXZ4hM+HKuhI7V54oL/WU9QQKK6hZ6HzsPbVqIdGDHBpWzsaVLRAiNH3
        0GXA5gKN90ySG8LbHASERl1yos4l4vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-J0qlrQ_iOTu3mBLyNMRLpA-1; Tue, 05 May 2020 17:54:40 -0400
X-MC-Unique: J0qlrQ_iOTu3mBLyNMRLpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF113107ACCA;
        Tue,  5 May 2020 21:54:39 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB7961FDE1;
        Tue,  5 May 2020 21:54:36 +0000 (UTC)
Subject: [PATCH v2 0/3] vfio-pci: Block user access to disabled device MMIO
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca
Date:   Tue, 05 May 2020 15:54:36 -0600
Message-ID: <158871401328.15589.17598154478222071285.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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


 drivers/vfio/pci/vfio_pci.c         |  321 +++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c  |   36 +++-
 drivers/vfio/pci/vfio_pci_intrs.c   |   18 ++
 drivers/vfio/pci/vfio_pci_private.h |   12 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |   12 +
 drivers/vfio/vfio_iommu_type1.c     |   36 ++++
 6 files changed, 405 insertions(+), 30 deletions(-)

