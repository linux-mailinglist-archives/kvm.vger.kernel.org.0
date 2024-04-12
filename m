Return-Path: <kvm+bounces-14416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6F08A2982
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6891282D2E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8213E479;
	Fri, 12 Apr 2024 08:42:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF3818030;
	Fri, 12 Apr 2024 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911343; cv=none; b=BBsTq6wo7kFFeW+w5GfvpGAPk3vxaRZ4xXy8btEF4fCTiJ1mi9cj3y41Rqdijw4wOk4xjNu9qzLUnGtd6bRt3UzLqY9eDK37UZogD/23FtFc6d/QvclbT6Uh3tMmwslE8M5S/3sEakBxvFnj4/gTEY+JgdoxiG+1lT8FWvsCIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911343; c=relaxed/simple;
	bh=2EX6iBBzoO8XThrr012LSgZY7hMePq4EBfqU0ZC+c9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FBErfUJFgiRYYcrcby2i+ZEdhz+D+tOkXx00kX95HN6RRmov6hToPoLTvjJ9Uf9qaNwLTD1Ote6fAgNF1mXVQlD6XdVOzSguhJ3kxzgjOzE4TrchSjBUjs87SfbjYZrLzzscDFo4r6TGiogp5VS1qrNJoHHwVeyr2eS5cLwY+X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A2D7339;
	Fri, 12 Apr 2024 01:42:51 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B68B33F6C4;
	Fri, 12 Apr 2024 01:42:19 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 00/14] arm64: Support for running as a guest in Arm CCA
Date: Fri, 12 Apr 2024 09:41:59 +0100
Message-Id: <20240412084213.1733764-1-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084056.1733704-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for running Linux in a protected VM under the
Arm Confidential Compute Architecture (CCA). The purpose of this series
is to gather feedback on the proposed changes to the architecture code
for CCA.

The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
(EAC 5) specification[1].

This series is based on v6.9-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v2

Introduction
============
A more general introduction to Arm CCA is available on the Arm
website[2], and links to the other components involved are available in
the overall cover letter.

Arm Confidential Compute Architecture adds two new 'worlds' to the
architecture: Root and Realm. A new software component known as the RMM
(Realm Management Monitor) runs in Realm EL2 and is trusted by both the
Normal World and VMs running within Realms. This enables mutual
distrust between the Realm VMs and the Normal World.

Virtual machines running within a Realm can decide on a (4k)
page-by-page granularity whether to share a page with the (Normal World)
host or to keep it private (protected). This protection is provided by
the hardware and attempts to access a page which isn't shared by the
Normal World will trigger a Granule Protection Fault.

Realm VMs can communicate with the RMM via another SMC interface known
as RSI (Realm Services Interface). This series adds wrappers for the
full set of RSI commands and uses them to manage the Realm IPA State
(RIPAS) and to discover the configuration of the realm.

The VM running within the Realm needs to ensure that memory that is
going to use is marked as 'RIPAS_RAM' (i.e. protected memory accessible
only to the guest). This could be provided by the VMM (and subject to
measurement to ensure it is setup correctly) or the VM can set it
itself.  This series includes a patch which will iterate over all
described RAM and set the RIPAS. This is a relatively cheap operation,
and doesn't require memory donation from the host. Instead, memory can
be dynamically provided by the host on fault. An alternative would be to
update booting.rst and state this as a requirement, but this would
reduce the flexibility of the VMM to manage the available memory to the
guest (as the initial RIPAS state is part of the guest's measurement).

Within the Realm the most-significant active bit of the IPA is used to
select whether the access is to protected memory or to memory shared
with the host. This series treats this bit as if it is attribute bit in
the page tables and will modify it when sharing/unsharing memory with
the host.

This top bit usage also necessitates that the IPA width is made more
dynamic in the guest. The VMM will choose a width (and therefore which
bit controls the shared flag) and the guest must be able to identify
this bit to mask it out when necessary. PHYS_MASK_SHIFT/PHYS_MASK are
therefore made dynamic.

To allow virtio to communicate with the host the shared buffers must be
placed in memory which has this top IPA bit set. This is achieved by
implementating the set_memory_{encrypted,decrypted} APIs for arm64 and
forcing the use of bounce buffers. For now all device access is
considered to required the memory to be shared, at this stage there is
no support for real devices to be assigned to a realm guest - obviously
if device assignment is added this will have to change.

Finally the GIC is (largely) emulated by the (untrusted) host. The RMM
provides some management (including register save/restore) but the
ITS buffers must be placed into shared memory for the host to emulate.
There is likely to be future work to harden the GIC driver against a
malicious host (along with any other drivers used within a Realm guest).

[1] https://developer.arm.com/documentation/den0137/1-0eac5/
[2] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture

Sami Mujawar (2):
  arm64: rsi: Interfaces to query attestation token
  virt: arm-cca-guest: TSM_REPORT support for realms

Steven Price (5):
  arm64: realm: Query IPA size from the RMM
  arm64: Mark all I/O as non-secure shared
  arm64: Make the PHYS_MASK_SHIFT dynamic
  arm64: Enforce bounce buffers for realm DMA
  arm64: realm: Support nonsecure ITS emulation shared

Suzuki K Poulose (7):
  arm64: rsi: Add RSI definitions
  arm64: Detect if in a realm and set RIPAS RAM
  fixmap: Allow architecture overriding set_fixmap_io
  arm64: Override set_fixmap_io
  arm64: Enable memory encrypt for Realms
  arm64: Force device mappings to be non-secure shared
  efi: arm64: Map Device with Prot Shared

 arch/arm64/Kconfig                            |   3 +
 arch/arm64/include/asm/fixmap.h               |   4 +-
 arch/arm64/include/asm/io.h                   |   6 +-
 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/mem_encrypt.h          |  19 ++
 arch/arm64/include/asm/pgtable-hwdef.h        |   4 +-
 arch/arm64/include/asm/pgtable-prot.h         |   3 +
 arch/arm64/include/asm/pgtable.h              |   7 +-
 arch/arm64/include/asm/rsi.h                  |  46 ++++
 arch/arm64/include/asm/rsi_cmds.h             | 143 ++++++++++++
 arch/arm64/include/asm/rsi_smc.h              | 136 ++++++++++++
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/efi.c                       |   2 +-
 arch/arm64/kernel/rsi.c                       |  85 +++++++
 arch/arm64/kernel/setup.c                     |   3 +
 arch/arm64/mm/init.c                          |  13 +-
 arch/arm64/mm/mmu.c                           |  13 ++
 arch/arm64/mm/pageattr.c                      |  48 +++-
 drivers/irqchip/irq-gic-v3-its.c              |  95 ++++++--
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 208 ++++++++++++++++++
 include/asm-generic/fixmap.h                  |   2 +
 25 files changed, 822 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm64/include/asm/mem_encrypt.h
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h
 create mode 100644 arch/arm64/kernel/rsi.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

-- 
2.34.1


