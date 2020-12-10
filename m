Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1DB2D6677
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393392AbgLJT3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:29:39 -0500
Received: from foss.arm.com ([217.140.110.172]:44758 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390262AbgLJOaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA4941FB;
        Thu, 10 Dec 2020 06:29:21 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE1443F718;
        Thu, 10 Dec 2020 06:29:20 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 00/21] Unify I/O port and MMIO trap handling
Date:   Thu, 10 Dec 2020 14:28:47 +0000
Message-Id: <20201210142908.169597-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment we use two separate code paths to handle exits for
KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
are semantically very similar. Because the trap handler callback routine
is different, devices need to decide on one conduit or need to provide
different handler functions for both of them.

This is not only unnecessary code duplication, but makes switching
devices from I/O port to MMIO a tedious task, even though there is no
real difference between the two, especially on ARM and PowerPC.

For ARM we aim at providing a flexible memory layout, and also have
trouble with the UART and RTC device overlapping with the PCI I/O area,
so it seems indicated to tackle this once and for all.

The first three patches do some cleanup, to simplify things later.

Patch 04/21 lays the groundwork, by extending mmio.c to be able to also
register I/O port trap handlers, using the same callback prototype as
we use for MMIO.

The next 14 patches then convert devices that use the I/O port
interface over to the new joint interface. This requires to rework
the trap handler routine to adhere to the same prototype as the existing
MMIO handlers. For most devices this is done in two steps: a first to
introduce the reworked handler routine, and a second to switch to the new
joint registration routine. For some devices the first step is trivial,
so it's done in one patch.

Patch 19/21 then retires the old I/O port interface, by removing ioport.c
and friends.

The final two patches switch the UART and the RTC device over to register
on the MMIO "bus", when running on ARM or arm64. This changes the
addresses to be at 16MB, so they are not in the PCI I/O area anymore.

Admittedly this goal can be achieved much simpler, by just having the
first three patches, and some more changes and ifdef's in the last two,
but I figured it would be good to clean up the I/O port mess for good.

Please have a look and comment!

Cheers,
Andre

Andre Przywara (21):
  ioport: Remove ioport__setup_arch()
  hw/serial: Use device abstraction for FDT generator function
  ioport: Retire .generate_fdt_node functionality
  mmio: Extend handling to include ioport emulation
  hw/i8042: Clean up data types
  hw/i8042: Refactor trap handler
  hw/i8042: Switch to new trap handlers
  x86/ioport: Refactor trap handlers
  x86/ioport: Switch to new trap handlers
  hw/rtc: Refactor trap handlers
  hw/rtc: Switch to new trap handler
  hw/vesa: Switch trap handling to use MMIO handler
  hw/serial: Refactor trap handler
  hw/serial: Switch to new trap handlers
  vfio: Refactor ioport trap handler
  vfio: Switch to new ioport trap handlers
  virtio: Switch trap handling to use MMIO handler
  pci: Switch trap handling to use MMIO handler
  Remove ioport specific routines
  hw/serial: ARM/arm64: Use MMIO at higher addresses
  hw/rtc: ARM/arm64: Use MMIO at higher addresses

 Makefile             |   1 -
 arm/ioport.c         |   5 -
 hw/i8042.c           |  88 ++++++----------
 hw/rtc.c             |  91 ++++++++---------
 hw/serial.c          | 166 +++++++++++++++++++-----------
 hw/vesa.c            |  19 +---
 include/kvm/i8042.h  |   1 -
 include/kvm/ioport.h |  25 -----
 include/kvm/kvm.h    |  42 +++++++-
 ioport.c             | 235 -------------------------------------------
 mips/kvm.c           |   5 -
 mmio.c               |  59 +++++++++--
 pci.c                |  82 +++++----------
 powerpc/ioport.c     |   6 --
 vfio/core.c          |  50 ++++-----
 virtio/pci.c         |  42 ++------
 x86/ioport.c         | 106 +++++++++----------
 17 files changed, 385 insertions(+), 638 deletions(-)
 delete mode 100644 ioport.c

-- 
2.17.1

