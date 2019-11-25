Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD62108BBD
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfKYKcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:31 -0500
Received: from foss.arm.com ([217.140.110.172]:47672 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfKYKca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 036A0328;
        Mon, 25 Nov 2019 02:32:30 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 050C83F52E;
        Mon, 25 Nov 2019 02:32:28 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 00/16] Add writable BARs and PCIE 1.1 support
Date:   Mon, 25 Nov 2019 10:30:17 +0000
Message-Id: <20191125103033.22694-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
it from trying to reprogram the BARs. Let's make the BARs writable so we
can get rid of this band-aid.

Let's also extend the legacy PCI emulation, which came out in 1992, so we
can properly emulate the PCI Express version 1.1 protocol, which is
relatively newer, being published in 2005.

With these two changes, we are very close to running EDK2 as the firmware
for the virtual machine; the only thing that is missing is flash emulation
for storing firmware variables.

Summary of the patches:
* Patches 1-12 are fixes or enhancements needed to support reprogramable
  BARs.
* Patches 13-15 add support for reprogramable BARs and remove the dt
  property.
* Patch 16 adds support for PCIE 1.1.

Based on the series at [1].

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/034964.html

Alexandru Elisei (8):
  Makefile: Use correct objcopy binary when cross-compiling for x86_64
  Remove pci-shmem device
  Check that a PCI device's memory size is power of two
  arm: pci.c: Advertise only PCI bus 0 in the DT
  virtio/pci: Ignore MMIO and I/O accesses when they are disabled
  Use independent read/write locks for ioport and mmio
  virtio/pci: Add support for BAR configuration
  Add PCI Express 1.1 support

Julien Thierry (7):
  ioport: pci: Move port allocations to PCI devices
  pci: Fix ioport allocation size
  arm/pci: Fix PCI IO region
  arm/pci: Do not use first PCI IO space bytes for devices
  virtio/pci: Make memory and IO BARs independent
  vfio: Add support for BAR configuration
  arm/fdt: Remove 'linux,pci-probe-only' property

Sami Mujawar (1):
  pci: Fix BAR resource sizing arbitration

 Makefile                          |   4 +-
 arm/fdt.c                         |   1 -
 arm/include/arm-common/kvm-arch.h |   2 +-
 arm/include/arm-common/pci.h      |   1 +
 arm/kvm.c                         |   3 +
 arm/pci.c                         |  28 ++-
 builtin-run.c                     |   5 -
 hw/pci-shmem.c                    | 400 ------------------------------
 hw/vesa.c                         |  21 +-
 include/kvm/ioport.h              |   4 -
 include/kvm/pci-shmem.h           |  32 ---
 include/kvm/pci.h                 |  61 ++++-
 include/kvm/util.h                |   2 +
 include/kvm/vesa.h                |   6 +-
 include/kvm/virtio-pci.h          |   1 +
 ioport.c                          |  36 +--
 mmio.c                            |  26 +-
 pci.c                             |  64 ++++-
 powerpc/include/kvm/kvm-arch.h    |   2 +-
 vfio/core.c                       |   6 +-
 vfio/pci.c                        |  97 +++++++-
 virtio/pci.c                      | 355 ++++++++++++++++++++------
 x86/include/kvm/kvm-arch.h        |   2 +-
 23 files changed, 562 insertions(+), 597 deletions(-)
 delete mode 100644 hw/pci-shmem.c
 delete mode 100644 include/kvm/pci-shmem.h

-- 
2.20.1

