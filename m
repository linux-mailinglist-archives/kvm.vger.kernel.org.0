Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E742054043D
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiFGRDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiFGRDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22B25FF585
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAB86143D;
        Tue,  7 Jun 2022 10:03:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 489B13F66F;
        Tue,  7 Jun 2022 10:03:11 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 00/24] Virtio v1 support
Date:   Tue,  7 Jun 2022 18:02:15 +0100
Message-Id: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for version 1 of the virtio transport to kvmtool. Based on a
RFC by Sasha Levin [1], I've been trying to complete it here and there.
It's long overdue and is quite painful to rebase, so let's get it
merged.

Several reasons why the legacy transport needs to be replaced:

* Only 32 feature bits are supported. Most importantly
  VIRTIO_F_ACCESS_PLATFORM, which forces a Linux guest to use the DMA
  API, cannot be enabled. So we can't support private guests that
  decrypt or share only their DMA memory with the host.

* Legacy virtqueue address is a 32-bit pfn, aligned on 4kB. Since Linux
  guests bypass the DMA API they can't support large GPAs.

* New devices types (iommu, crypto, memory, etc) and new features cannot
  be supported.

* New guests won't implement the legacy transport. Existing guests will
  eventually drop legacy support.

Support for modern transport becomes the default and legacy is enabled
with --virtio-legacy.

I only tested what I could: vsock, scsi and vhost-net are currently
broken and can be fixed later (they have issues with mem regions and
feature mask, among other things). I also haven't tested big-endian.

Find the series at https://jpbrucker.net/git/kvmtool/ virtio/devel

[1] https://lore.kernel.org/all/1447823472-17047-1-git-send-email-sasha.levin@oracle.com/
    The SOB was kept in patch 21

Jean-Philippe Brucker (24):
  virtio: Add NEEDS_RESET to the status mask
  virtio: Remove redundant test
  virtio/vsock: Remove redundant state tracking
  virtio: Factor virtqueue initialization
  virtio: Support modern virtqueue addresses
  virtio: Add config access helpers
  virtio: Fix device-specific config endianness
  virtio/console: Remove unused callback
  virtio: Remove set_guest_features() device op
  Add memcpy_fromiovec_safe
  virtio/net: Offload vnet header endianness conversion to tap
  virtio/net: Prepare for modern virtio
  virtio/net: Implement VIRTIO_F_ANY_LAYOUT feature
  virtio/console: Add VIRTIO_F_ANY_LAYOUT feature
  virtio/blk: Implement VIRTIO_F_ANY_LAYOUT feature
  virtio/pci: Factor MSI route creation
  virtio/pci: Delete MSI routes
  virtio: Extract init_vq() for PCI and MMIO
  virtio/pci: Make doorbell offset dynamic
  virtio: Move PCI transport to pci-legacy
  virtio: Add support for modern virtio-pci
  virtio: Move MMIO transport to mmio-legacy
  virtio: Add support for modern virtio-mmio
  virtio/pci: Initialize all vectors to VIRTIO_MSI_NO_VECTOR

 Makefile                          |   4 +
 arm/include/arm-common/kvm-arch.h |   6 +-
 include/kvm/disk-image.h          |   3 +-
 include/kvm/iovec.h               |   2 +
 include/kvm/kvm-config.h          |   1 +
 include/kvm/kvm.h                 |   6 +
 include/kvm/pci.h                 |  11 +
 include/kvm/virtio-9p.h           |   2 +-
 include/kvm/virtio-mmio.h         |  29 ++-
 include/kvm/virtio-pci-dev.h      |   4 +
 include/kvm/virtio-pci.h          |  48 +++-
 include/kvm/virtio.h              |  52 ++--
 mips/include/kvm/kvm-arch.h       |   2 -
 powerpc/include/kvm/kvm-arch.h    |   2 -
 x86/include/kvm/kvm-arch.h        |   2 -
 builtin-run.c                     |   2 +
 disk/core.c                       |  26 +-
 net/uip/core.c                    |  71 ++++--
 util/iovec.c                      |  31 +++
 virtio/9p.c                       |  27 +--
 virtio/balloon.c                  |  46 ++--
 virtio/blk.c                      | 102 ++++----
 virtio/console.c                  |  33 +--
 virtio/core.c                     |  82 ++++++-
 virtio/mmio-legacy.c              | 150 ++++++++++++
 virtio/mmio-modern.c              | 157 ++++++++++++
 virtio/mmio.c                     | 202 ++--------------
 virtio/net.c                      | 122 +++++-----
 virtio/pci-legacy.c               | 205 ++++++++++++++++
 virtio/pci-modern.c               | 386 ++++++++++++++++++++++++++++++
 virtio/pci.c                      | 361 ++++++----------------------
 virtio/rng.c                      |  15 +-
 virtio/scsi.c                     |  44 ++--
 virtio/vsock.c                    |  39 ++-
 34 files changed, 1490 insertions(+), 785 deletions(-)
 create mode 100644 virtio/mmio-legacy.c
 create mode 100644 virtio/mmio-modern.c
 create mode 100644 virtio/pci-legacy.c
 create mode 100644 virtio/pci-modern.c

-- 
2.36.1

