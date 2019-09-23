Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11673BB56E
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408094AbfIWNfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:37 -0400
Received: from foss.arm.com ([217.140.110.172]:42276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404581AbfIWNfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA021000;
        Mon, 23 Sep 2019 06:35:36 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B7E4A3F694;
        Mon, 23 Sep 2019 06:35:35 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 00/16] arm: Allow the user to define the memory layout
Date:   Mon, 23 Sep 2019 14:35:06 +0100
Message-Id: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest memory layout created by kvmtool is fixed: regular MMIO is below
1G, PCI MMIO is below 2G, and the RAM always starts at the 2G mark. Real
hardware can have a different memory layout, and being able to create a
specific memory layout can be very useful for testing the guest kernel.

This series allows the user the specify the memory layout for the
virtual machine by expanding the -m/--mem option to take an <addr>
parameter, and by adding architecture specific options to define the I/O
ports, regular MMIO and PCI MMIO memory regions.

The user defined memory regions are implemented in patch #16; I consider
the patch to be an RFC because I'm not really sure that my approach is the
correct one; for example, I decided to make the options arch dependent
because that seemed like the path of least resistance, but they could have
just as easily implemented as arch independent and each architecture
advertised having support for them via a define (like with RAM base
address).

Summary:
 * Patches 1-8 are fixes and cleanups.
 * Patch 9 implements the option for the user to specify the RAM base
   address, but the MMIO regions are left unchanged.
 * Patches 10-12 represent another round of cleanups.
 * Patch 13 implements a memory allocator that allows the user the specify
   any RAM address. The MMIO regions are allocated from the remaining
   address space.
 * Patches 14-15 are cleanups in preparation for the patch will allow the
   user to define the memory layout.
 * Patch 16 implements the option for the user to define the memory layout.

The series are based on previous work by Julien Grall [1].

[1] https://www.spinics.net/lists/kvm/msg179408.html

Alexandru Elisei (10):
  kvmtool: Add helper to sanitize arch specific KVM configuration
  kvmtool: Use MB consistently
  builtin-run.c: Always use virtual machine ram_size in bytes
  arm: Remove redundant define ARM_PCI_CFG_SIZE
  arm: Allow the user to specify RAM base address
  arm/pci: Remove unused ioports
  arm: Allow any base address for RAM
  arm: Move memory related code to memory.c
  kvmtool: Make the size@addr option parser globally visible
  arm: Allow the user to define the MMIO regions

Julien Grall (4):
  kvm__arch_init: Don't pass hugetlbfs_path and ram_size in parameter
  virtio/scsi: Allow to use multiple banks
  arm: Move anything related to RAM initialization in kvm__init_ram
  Fold kvm__init_ram call in kvm__arch_init and rename it

Suzuki K Poulose (2):
  arm: Allow use of hugepage with 16K pagesize host
  kvmtool: Allow standard size specifiers for memory

 Documentation/kvmtool.1                  |   4 +-
 Makefile                                 |   2 +-
 arm/aarch32/include/kvm/kvm-arch.h       |   2 +-
 arm/aarch64/include/kvm/kvm-arch.h       |   6 +-
 arm/allocator.c                          | 150 ++++++++++++++
 arm/gic.c                                |  30 +--
 arm/include/arm-common/allocator.h       |  25 +++
 arm/include/arm-common/kvm-arch.h        |  59 +++---
 arm/include/arm-common/kvm-config-arch.h |  25 +++
 arm/include/arm-common/memory.h          |  13 ++
 arm/kvm.c                                |  58 ++----
 arm/memory.c                             | 326 +++++++++++++++++++++++++++++++
 arm/pci.c                                |   7 +-
 builtin-run.c                            | 119 +++++++++--
 include/kvm/kvm-config.h                 |   5 +-
 include/kvm/kvm.h                        |   7 +-
 kvm.c                                    |  15 +-
 mips/include/kvm/kvm-arch.h              |   4 +
 mips/kvm.c                               |  14 +-
 pci.c                                    |  36 +++-
 powerpc/include/kvm/kvm-arch.h           |   4 +
 powerpc/kvm.c                            |  14 +-
 util/util.c                              |   2 +-
 virtio/mmio.c                            |   7 +
 virtio/scsi.c                            |  21 +-
 x86/include/kvm/kvm-arch.h               |   4 +
 x86/kvm.c                                |  35 ++--
 27 files changed, 843 insertions(+), 151 deletions(-)
 create mode 100644 arm/allocator.c
 create mode 100644 arm/include/arm-common/allocator.h
 create mode 100644 arm/include/arm-common/memory.h
 create mode 100644 arm/memory.c

-- 
2.7.4

