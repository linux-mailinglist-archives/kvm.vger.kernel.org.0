Return-Path: <kvm+bounces-53449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA23B12044
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DED783AEA9C
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2348273816;
	Fri, 25 Jul 2025 14:41:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4782459D7
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753454494; cv=none; b=hriZvkho8wfFMtt/9dklJQmRcEoh9LwkMbR7YQu0tDGy7MNkl/X4mV4puDCkicqlKuAYcANC0VgHsok+3Q6MuAvZ6mbNYE45HYDHluz47CqRtFpfIddL/SMr8Q0TWYcquz6P6SMtnalOAeY4KtAEypYyIGtEi/qdXWgY0gSzRtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753454494; c=relaxed/simple;
	bh=7HcoaKkWfarGbRxel8F0ma688ornFbbIKKvfKyM5+34=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z7bWhgM1HWhILqb5oh1MUbRGEB3Axsu4JuVgxZmXVp8Yn2wQpg5TDLMm5LWZlJ4iMHvvOzSir1xVjWUR8CS92YaN0gjhbXoJTY3L16OLevNiSaJbDVibh50w2tcNiyusHzAPOBSJa3tu7dOFn50aeqIODGfpH8NcJLNj6mEf10o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96534176C;
	Fri, 25 Jul 2025 07:41:24 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A5D03F6A8;
	Fri, 25 Jul 2025 07:41:30 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2 0/6] arm64: Nested virtualization support
Date: Fri, 25 Jul 2025 15:40:54 +0100
Message-Id: <20250725144100.2944226-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 of the nested virt support series, just adding three patches from
Marc's repo, to complete the nested virt experience.
Marc, I added some commit messages to your patches, please have a look if
they make vaguely sense. Thanks!
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

Andre Przywara (3):
  Sync kernel UAPI headers with v6.16-rc1
  arm64: Initial nested virt support
  arm64: nested: add support for setting maintenance IRQ

Marc Zyngier (3):
  arm64: Add counter offset control
  arm64: add FEAT_E2H0 support (TBC)
  arm64: Generate HYP timer interrupt specifiers

 arm64/arm-cpu.c                     |  7 ++-
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 21 +++++++-
 arm64/include/asm/kvm.h             | 23 +++++++--
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 ++++-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 14 +++++-
 arm64/kvm.c                         | 17 +++++++
 arm64/timer.c                       | 29 +++++------
 include/linux/kvm.h                 |  5 ++
 include/linux/virtio_net.h          | 13 +++++
 include/linux/virtio_pci.h          |  1 +
 riscv/include/asm/kvm.h             |  2 +
 x86/include/asm/kvm.h               | 75 +++++++++++++++++++++++++++++
 15 files changed, 196 insertions(+), 31 deletions(-)

-- 
2.25.1


