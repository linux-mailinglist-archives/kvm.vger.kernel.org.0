Return-Path: <kvm+bounces-58638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 042F4B9A17F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D84D73AF072
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8ED305042;
	Wed, 24 Sep 2025 13:45:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26B24502A
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721525; cv=none; b=KyhiNf1mbVp3kMV+yOPJGfA5C3JjdenTNAZmypi5ZK6cx3UHGf+54H3rmYE+hd0QYN3CzG4bBOe/kmkqRYsIj8A/zpHIuiFHG3cqy0gybRNOiLVZ2Wsg62zRO4bVLBSwN0Qv1dY89PehZqL6LGwsYfbU16Bi1H0Czgi3HeFlw6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721525; c=relaxed/simple;
	bh=abgqkQhYniJWCyH534lQE/FEFCkzxYytvSvB99BXO5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G+46oeVZmSYrGBrdIWB9xrIkm3Qyzu1vtUCe0flf/7BcKm0eDNyr5Hl19u3uM+QpxvXm3Mp/jTpBTinoubGW0nIuTdSsdf49QFR+mpYNyM2s6cPo0GxIh7GTvp0FjN+wBZr8z6+Xx5Uf7d67a6giH8SXlvq9t+se7ZIHmkIwbTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09975106F;
	Wed, 24 Sep 2025 06:45:13 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F8833F5A1;
	Wed, 24 Sep 2025 06:45:20 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 0/7] arm64: Nested virtualization support
Date: Wed, 24 Sep 2025 14:45:04 +0100
Message-Id: <20250924134511.4109935-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v4 of the nested virt support series, slightly reworking the
code for the maintenance IRQ. Also adding a fix from Marc for virtio
endianess handling. Changelog below.
========================================================

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 updates the kernel headers, to get the new EL2 capability, and
the VGIC device control to setup the maintenance IRQ.
Patch 2 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 3 allows by setting the maintenance IRQ.
Patch 4 to 6 are picked from Marc's repo, and allow to set the arch
timer offset, enable non-VHE guests (at the cost of losing recursive
nested virtualisation), and also advertise the virtual EL2 timer IRQ.

Tested on the FVP (with some good deal of patience), and some commercial
(non-fruity) hardware, down to a guest's guest's guest.

Cheers,
Andre

Changelog v3 ... v4:
- pass kvm pointer to gic__generate_fdt_nodes()
- use macros for PPI offset and DT type identifier
- properly calculate DT interrupt flags value
- add patch 7 to fix virtio endianess issues
- CAPITALISE verbs in commit message

Changelog v2 ... v3:
- adjust^Wreplace commit messages for E2H0 and counter-offset patch
- check for KVM_CAP_ARM_EL2_E2H0 when --e2h0 is requested
- update kernel headers to v6.16 release

Changelog v1 ... 2:
- add three patches from Marc:
  - add --e2h0 command line option
  - add --counter-offset command line option
  - advertise all five arch timer interrupts in DT


Andre Przywara (3):
  Sync kernel UAPI headers with v6.16
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |  6 +--
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 26 ++++++++-
 arm64/include/asm/kvm.h             | 23 ++++++--
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 +++-
 arm64/include/kvm/kvm-cpu-arch.h    |  5 +-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 64 +++++++++++++++++++----
 arm64/kvm.c                         | 17 ++++++
 arm64/timer.c                       | 29 +++++------
 include/linux/kvm.h                 | 31 +++++++++++
 include/linux/virtio_net.h          | 13 +++++
 include/linux/virtio_pci.h          |  1 +
 riscv/include/asm/kvm.h             |  2 +
 x86/include/asm/kvm.h               | 81 +++++++++++++++++++++++++++++
 16 files changed, 274 insertions(+), 44 deletions(-)

-- 
2.25.1


