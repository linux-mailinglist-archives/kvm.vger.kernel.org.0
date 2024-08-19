Return-Path: <kvm+bounces-24496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB10E956BAA
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 485D8B228FD
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130E616C6A2;
	Mon, 19 Aug 2024 13:19:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEACB16C68B;
	Mon, 19 Aug 2024 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073583; cv=none; b=I/PFMJ9SRXLfYAPHYbgV3CpUv7M4i94EbfNQDF4+bGyxySz91MfxzMgceA+5OuAXhpz2TyzQeZlPgD5heAsKSKAwPlG3YuOCCz4cbaiGtp0iaW1bJ0DPgKuxia1GHohfGPJVX0lQlxy8TeuZFZsXzMlDN3c4hBtTPj2lNRZpXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073583; c=relaxed/simple;
	bh=q7n4yox1qlvnzKsPcwva4ELTO5183R23ss6XmWPQJUE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GlRnpAs5OOZktgQ0GTI/TYVcTqdZwAXPcR8UQle42qXrgqFO7P82wowsP9MnvtDIn4k7ntazIdIqjqOMYdhBmxZ99zDuF0w28aOae3iSg+ZSLIlZfwrdGKKT03oA4TVmLNDvLdsrpIGmS0KlgD6nHEQRP0v2jLolAs1kZ3K0d3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4372A339;
	Mon, 19 Aug 2024 06:20:07 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33A913F73B;
	Mon, 19 Aug 2024 06:19:37 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 00/19] arm64: Support for running as a guest in Arm CCA
Date: Mon, 19 Aug 2024 14:19:05 +0100
Message-Id: <20240819131924.372366-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for running Linux in a protected VM under the
Arm Confidential Compute Architecture (CCA). This has been updated
following the feedback from the v4 posting[1]. Thanks for the feedback!
Individual patches have a change log. But things to highlight:

 * New RMM spec version[2] (v1.0-rel0-rc1). Note that this makes a
   number of (small) breaking changes so you will need to update the RMM
   and host too (see below).

 * 'Borrowed' two commits by Will from the pKVM series which add a
   dispatcher/hook for mem_encrypt and ioremap. These will hopefully
   make it easier for CCA to live alongside pKVM.

 * Reworked the code for handling protected/shared MMIO. The new RMM
   spec adds a new state (RIPAS_IO - although that may get renamed),
   which is currently unused, but will be used in a later version to
   signify that a granule is backed by a protected hardware MMIO region.
   Using this we can now identify whether the top bit should be set when
   performing an ioremap (or similar).

The ABI to the RMM from a realm (the RSI) is based on the RMM
v1.0-rel0-rc1 specification[2]. Future RMM specifications after v1.0
will be backwards compatible so a guest using the v1.0 specification
(i.e. this series) will be able to run on future versions of the RMM
without modification.

This series is based on v6.11-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v5

As mentioned above the new RMM specification means that corresponding
changes need to be made in the RMM, at this time these changes are still
in review (see 'topics/rmm-1.0-rel0-rc1'). So you'll need to fetch the
changes[3] from the gerrit instance until they are pushed to the main
branch.

It has also been pointed out that some documentation would be a good
idea - I'm afraid it hasn't made this version, but I didn't want to hold
off posting for any longer.

The new version of the RMM also means you'll need to update the host
support, a v4 of the host changes will be posted soon, in the mean time
the code is available from git here:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v4

[1] https://lore.kernel.org/r/20240701095505.165383-1-steven.price%40arm.com
[2] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
[3] https://review.trustedfirmware.org/c/TF-RMM/tf-rmm/+/30485

Jean-Philippe Brucker (1):
  firmware/psci: Add psci_early_test_conduit()

Sami Mujawar (1):
  virt: arm-cca-guest: TSM_REPORT support for realms

Steven Price (6):
  arm64: realm: Query IPA size from the RMM
  arm64: Make the PHYS_MASK_SHIFT dynamic
  arm64: Enforce bounce buffers for realm DMA
  arm64: mm: Avoid TLBI when marking pages as valid
  irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor
  irqchip/gic-v3-its: Rely on genpool alignment

Suzuki K Poulose (9):
  arm64: rsi: Add RSI definitions
  arm64: Detect if in a realm and set RIPAS RAM
  arm64: rsi: Add support for checking whether an MMIO is protected
  fixmap: Allow architecture overriding set_fixmap_io
  fixmap: Pass down the full phys address for set_fixmap_io
  arm64: Override set_fixmap_io
  arm64: rsi: Map unprotected MMIO as decrypted
  efi: arm64: Map Device with Prot Shared
  arm64: Enable memory encrypt for Realms

Will Deacon (2):
  arm64: mm: Add top-level dispatcher for internal mem_encrypt API
  arm64: mm: Add confidential computing hook to ioremap_prot()

 arch/arm64/Kconfig                            |   4 +
 arch/arm64/include/asm/fixmap.h               |   2 +
 arch/arm64/include/asm/io.h                   |  12 +
 arch/arm64/include/asm/mem_encrypt.h          |  24 ++
 arch/arm64/include/asm/pgtable-hwdef.h        |   6 -
 arch/arm64/include/asm/pgtable-prot.h         |   4 +
 arch/arm64/include/asm/pgtable.h              |  10 +
 arch/arm64/include/asm/rsi.h                  |  68 ++++++
 arch/arm64/include/asm/rsi_cmds.h             | 157 +++++++++++++
 arch/arm64/include/asm/rsi_smc.h              | 189 ++++++++++++++++
 arch/arm64/include/asm/set_memory.h           |   4 +
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/efi.c                       |  12 +-
 arch/arm64/kernel/rsi.c                       | 149 +++++++++++++
 arch/arm64/kernel/setup.c                     |   8 +
 arch/arm64/mm/Makefile                        |   2 +-
 arch/arm64/mm/init.c                          |  10 +-
 arch/arm64/mm/ioremap.c                       |  23 +-
 arch/arm64/mm/mem_encrypt.c                   |  50 +++++
 arch/arm64/mm/mmu.c                           |  17 ++
 arch/arm64/mm/pageattr.c                      |  84 ++++++-
 drivers/firmware/psci/psci.c                  |  25 +++
 drivers/irqchip/irq-gic-v3-its.c              | 142 +++++++++---
 drivers/tty/serial/earlycon.c                 |   2 +-
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
 include/asm-generic/fixmap.h                  |   4 +-
 include/linux/psci.h                          |   5 +
 31 files changed, 1200 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm64/include/asm/mem_encrypt.h
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h
 create mode 100644 arch/arm64/kernel/rsi.c
 create mode 100644 arch/arm64/mm/mem_encrypt.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

-- 
2.34.1


