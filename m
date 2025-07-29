Return-Path: <kvm+bounces-53623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0EB6B14BC7
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08063A9B96
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE9628852B;
	Tue, 29 Jul 2025 09:58:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA9A2777E4
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 09:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753783080; cv=none; b=n+2Qq0TbMCFqf8W+aM0R3DJlT6S3dXZXQB4I/f3o8V+Wy8WGZ2tLG0n4kv2es+WAVraIW6fiBmDt9sj5eR2oKzZDO3JxrD4L2g2HjiHa64k8pKjKqDQGPnkvRt/Q5U/TDMjg7llIF3S2vIApwtRxytFc1K9EK/cHQQBj3guUxWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753783080; c=relaxed/simple;
	bh=8EOz5swPaoijvn9bEq3UkCoKOLcaDRTkNkUAm6nXlsM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eXRX8VVGobuBtocGhZyNgOMWuNMHalTnsUG8ijPkyV2TkXp3gANyEjgQj1Z2KdrkLgN131D8o+10/sgGjJdC2BV961bGiKc3IPoAaQWAOYzTCpvs2TxZm6ut3OjmuaPHLxscAQwBI/7+R+8nAyuuUBAacgOqxVGhfUdzfs8W464=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE41C1516;
	Tue, 29 Jul 2025 02:57:43 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9730E3F673;
	Tue, 29 Jul 2025 02:57:50 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v3 0/6] arm64: Nested virtualization support
Date: Tue, 29 Jul 2025 10:57:39 +0100
Message-Id: <20250729095745.3148294-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v3 of the nested virt support series, adjusting commit messages
and adding a check that FEAT_E2H0 is really available.
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
  arm64: nested: add support for setting maintenance IRQ

Marc Zyngier (3):
  arm64: add counter offset control
  arm64: add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers

 arm64/arm-cpu.c                     |  7 ++-
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 21 +++++++-
 arm64/include/asm/kvm.h             | 23 ++++++--
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 +++-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 17 +++++-
 arm64/kvm.c                         | 17 ++++++
 arm64/timer.c                       | 29 +++++------
 include/linux/kvm.h                 | 31 +++++++++++
 include/linux/virtio_net.h          | 13 +++++
 include/linux/virtio_pci.h          |  1 +
 riscv/include/asm/kvm.h             |  2 +
 x86/include/asm/kvm.h               | 81 +++++++++++++++++++++++++++++
 15 files changed, 231 insertions(+), 31 deletions(-)

-- 
2.25.1


