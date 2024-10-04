Return-Path: <kvm+bounces-27923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D545399066C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CE0428139D
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 14:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87988217911;
	Fri,  4 Oct 2024 14:43:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FBC20FAA1;
	Fri,  4 Oct 2024 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728053010; cv=none; b=cYaedbL6LlE7TZhSPkTuhNTfn7zMf+fBJAXxU5c6AQwhV9dQPZxiErQLIAt3/zQUNXLrb4L83lCcAAkA3QSnFAgKWisDJ+05BhUlDYIULw4GzzC9c0G9EMqcH7VDr/BhdSbg/BiRbc+xgAXP9d9axMfGiA9fjk3CB/3jiTDVfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728053010; c=relaxed/simple;
	bh=V/n3a/RmyEFaEXOi7ye94B3gyl3XifclsxOHGAcIQLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bBn/uWKwaf0/BERX0aisEckLrKtKVMcvX4PVLkmLRw/DG9QusV8JZ+Jdr3SLo6tjsPac4PXOUjNq94WVGQHKZMtb3OpXtuoj7iyQK0AZlcaPbPYkSsoigPK16n6h+aYV6EiNYk2toCXhV0aRbD22cFn4ciJa8E2k9rDVzbpR6ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1388A339;
	Fri,  4 Oct 2024 07:43:56 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2305E3F58B;
	Fri,  4 Oct 2024 07:43:21 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v6 00/11] arm64: Support for running as a guest in Arm CCA
Date: Fri,  4 Oct 2024 15:42:55 +0100
Message-Id: <20241004144307.66199-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for running Linux in a protected VM under the
Arm Confidential Compute Architecture (CCA). This is a trimmed down
series following the feedback from the v5 posting[1]. Thanks for the
feedback!

Individual patches have a change log. But things to highlight:

 * Some patches have been merged already. The first two patches from v4
   were borrowed from pKVM were merged as part of that series. The GIC
   ITS patches[2][3] have been merged via the tip tree.

 * Final RMM v1.0 spec[4] - only minor changes over the previous spec,
   but we've now got a proper release.

 * Probing/initialisation of the RMM is now done later. This means
   there's no need for finding the PSCI conduit and can drop the patch
   for that.

 * The patches for set_fixmap_io() is also gone - we the RMM is detected
   later it's now too late for earlycon. See below for instructions on
   how to use earlycon.

 * Mainline no longer uses PHYS_MASK_SHIFT for manipulating PTEs, so we
   can drop the patch for making that dynamic.

 * There's now some documentation! In particular this clarifies a change
   in the boot requirements - memory must now be RIPAS RAM for a realm
   guest.

This series is based on v6.12-rc1.

Testing
=======

Since a couple of the patches have been merged separately, and there was
also a bug[5] in -rc1 which impacts 9p filesystems, I've provided the
below git tree with everything you need for a CCA guest:

https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v6

Back by popular demand is also a tree with both host and guest changes:

https://gitlab.arm.com/linux-arm/linux-cca cca-full/v5+v6

(I'll post the v5 series of the host changes shortly)

You will also need an up-to-date RMM - the necessary changes have been
merged into the 'main' branch of upstream:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main

And you also need an updated kvmtool, there's a branch with the
necessary changes here:

https://git.gitlab.arm.com/linux-arm/kvmtool-cca.git cca/v3

earlycon
--------

If using 'earlycon' on the kernel command line it is now necessary to
pass the address of the serial port *in the unprotected IPA*. This is
because the fixmap changes were dropped (due to the late probing of the
RMM). E.g. for kvmtool you will need:

  earlycon=uart,mmio,0x101000000

This is the main drawback to late probing. One potential improvement
would be an option like "earlycon=realm" to identify that the earlycon
uart is in the unprotected space without having to know the actual IPA.
I've left this out for now as I'm not sure whether there is any actual
interest in this.

[1] https://lore.kernel.org/r/20240819131924.372366-1-steven.price%40arm.com
[2] e36d4165f079 ("irqchip/gic-v3-its: Rely on genpool alignment")
[3] b08e2f42e86b ("irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor")
[4] https://developer.arm.com/documentation/den0137/1-0rel0/
[5] https://lore.kernel.org/all/cbaf141ba6c0e2e209717d02746584072844841a.1727722269.git.osandov@fb.com/

Sami Mujawar (1):
  virt: arm-cca-guest: TSM_REPORT support for realms

Steven Price (4):
  arm64: realm: Query IPA size from the RMM
  arm64: Enforce bounce buffers for realm DMA
  arm64: mm: Avoid TLBI when marking pages as valid
  arm64: Document Arm Confidential Compute

Suzuki K Poulose (6):
  arm64: rsi: Add RSI definitions
  arm64: Detect if in a realm and set RIPAS RAM
  arm64: rsi: Add support for checking whether an MMIO is protected
  arm64: rsi: Map unprotected MMIO as decrypted
  efi: arm64: Map Device with Prot Shared
  arm64: Enable memory encrypt for Realms

 Documentation/arch/arm64/arm-cca.rst          |  67 ++++++
 Documentation/arch/arm64/booting.rst          |   3 +
 Documentation/arch/arm64/index.rst            |   1 +
 arch/arm64/Kconfig                            |   3 +
 arch/arm64/include/asm/io.h                   |   8 +
 arch/arm64/include/asm/mem_encrypt.h          |   9 +
 arch/arm64/include/asm/pgtable-prot.h         |   4 +
 arch/arm64/include/asm/pgtable.h              |   5 +
 arch/arm64/include/asm/rsi.h                  |  68 ++++++
 arch/arm64/include/asm/rsi_cmds.h             | 160 +++++++++++++
 arch/arm64/include/asm/rsi_smc.h              | 193 ++++++++++++++++
 arch/arm64/include/asm/set_memory.h           |   3 +
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/efi.c                       |  12 +-
 arch/arm64/kernel/rsi.c                       | 141 ++++++++++++
 arch/arm64/kernel/setup.c                     |   3 +
 arch/arm64/mm/init.c                          |  10 +-
 arch/arm64/mm/pageattr.c                      |  98 +++++++-
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
 23 files changed, 1010 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/arch/arm64/arm-cca.rst
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h
 create mode 100644 arch/arm64/kernel/rsi.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

-- 
2.34.1


