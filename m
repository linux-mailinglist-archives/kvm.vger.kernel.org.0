Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612B31A8015
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391039AbgDNOkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:01 -0400
Received: from foss.arm.com ([217.140.110.172]:57094 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391025AbgDNOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:39:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F2F630E;
        Tue, 14 Apr 2020 07:39:57 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 95A8D3F73D;
        Tue, 14 Apr 2020 07:39:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 00/18] Various fixes
Date:   Tue, 14 Apr 2020 15:39:28 +0100
Message-Id: <20200414143946.1521-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've taken the fixes from my reassignable BARs and PCIE support series [1]
and created this series because 1. they can be taken independently and 2.
rebasing a 32 patch series was getting very tedious.

Changes from the original series:

* Gathered Reviewed-by tags. Only patch #14 "virtio: Don't ignore
  initialization failures" doesn't have one.
* The virtio net device now frees the allocated devices and the ops copy on
  failure in patch #14.

[1] https://www.spinics.net/lists/kvm/msg211272.html

Alexandru Elisei (14):
  Makefile: Use correct objcopy binary when cross-compiling for x86_64
  hw/i8042: Compile only for x86
  Remove pci-shmem device
  Check that a PCI device's memory size is power of two
  arm/pci: Advertise only PCI bus 0 in the DT
  vfio/pci: Allocate correct size for MSIX table and PBA BARs
  vfio/pci: Don't assume that only even numbered BARs are 64bit
  vfio/pci: Ignore expansion ROM BAR writes
  vfio/pci: Don't access unallocated regions
  virtio: Don't ignore initialization failures
  Don't ignore errors registering a device, ioport or mmio emulation
  hw/vesa: Don't ignore fatal errors
  hw/vesa: Set the size for BAR 0
  ioport: Fail when registering overlapping ports

Julien Thierry (3):
  ioport: pci: Move port allocations to PCI devices
  pci: Fix ioport allocation size
  virtio/pci: Make memory and IO BARs independent

Sami Mujawar (1):
  pci: Fix BAR resource sizing arbitration

 Makefile                       |   6 +-
 arm/ioport.c                   |   3 +-
 arm/pci.c                      |   2 +-
 builtin-run.c                  |   5 -
 hw/i8042.c                     |  14 +-
 hw/pci-shmem.c                 | 400 ---------------------------------
 hw/vesa.c                      |  34 ++-
 include/kvm/devices.h          |   3 +-
 include/kvm/ioport.h           |  10 +-
 include/kvm/kvm.h              |   7 +-
 include/kvm/pci-shmem.h        |  32 ---
 include/kvm/pci.h              |   4 +-
 include/kvm/util.h             |   2 +
 include/kvm/vesa.h             |   6 +-
 include/kvm/virtio.h           |   7 +-
 include/linux/compiler.h       |   2 +-
 ioport.c                       |  50 ++---
 mips/kvm.c                     |   3 +-
 pci.c                          |  59 ++++-
 powerpc/include/kvm/kvm-arch.h |   2 +-
 powerpc/ioport.c               |   3 +-
 vfio/core.c                    |   6 +-
 vfio/pci.c                     |  87 +++++--
 virtio/9p.c                    |   9 +-
 virtio/balloon.c               |  10 +-
 virtio/blk.c                   |  14 +-
 virtio/console.c               |  11 +-
 virtio/core.c                  |   9 +-
 virtio/mmio.c                  |  13 +-
 virtio/net.c                   |  45 ++--
 virtio/pci.c                   |  78 ++++---
 virtio/scsi.c                  |  14 +-
 x86/include/kvm/kvm-arch.h     |   2 +-
 x86/ioport.c                   |  66 ++++--
 34 files changed, 384 insertions(+), 634 deletions(-)
 delete mode 100644 hw/pci-shmem.c
 delete mode 100644 include/kvm/pci-shmem.h

-- 
2.20.1

