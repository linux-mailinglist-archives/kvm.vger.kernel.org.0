Return-Path: <kvm+bounces-67435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D6BD0545A
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:58:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4D3873014EAB
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834A02EB859;
	Thu,  8 Jan 2026 17:58:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC1F2EA15C;
	Thu,  8 Jan 2026 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895123; cv=none; b=moI3j6/XQrv0gbps5hhUjkL2pJ/uCZsY88xe6VTMPtrTxVH++MmALIQHJBxhamorc5VXWjF4NF1z5JzE6rN5zEwpZK+5MR6SMicQ9L4E90WB18K33EwgXCkt6x4VCeWO+Onp1nz7GOEN4YGo03Vw0+nbJztC3ZHKg7xMVabli0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895123; c=relaxed/simple;
	bh=hZICZNSJDvTerdtTp4mYTKvCaT0mOy3dyl1ZcWY4PyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X6lA2hYbgL+Uv6SBqX+UGWMcuvvofIdSqqJAq0XA6rxyRue5SVG9F91bxnqotsIAAsl+Idz7fuTwLJ7uTMZGFV9C3eDlT5gqoA8nqqJcPWU7J25MjYwXHChNexIg43Hoapzbo7WdkV5dfhJjvoU+lvTDdVvEvuxoZadvrkSm+RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37645497;
	Thu,  8 Jan 2026 09:58:32 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5ED7C3F5A1;
	Thu,  8 Jan 2026 09:58:36 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 00/15] arm64: Handle PSCI calls in userspace
Date: Thu,  8 Jan 2026 17:57:38 +0000
Message-ID: <20260108175753.1292097-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is version 5 of the patch series, originally posted by Oliver [0].

Use SMCCC filtering capability in to handle PSCI calls in the userspace.

Changes since v4:
Link: https://lkml.kernel.org/r/20250930103130.197534-1-suzuki.poulose@arm.com

 - Update headers to v6.18
 - Remove duplicate assignment of pause_req_cpu (Marc)
 - Flip the command line to opt in for PSCI in userspace, retaining default
   in kernel handling. (Marc)
 - Collect Review from Marc, thanks!

Changes since v3:
 - Address Will's comment on the race between pause/resume - Patch 1
 - Rebase on to v6.17-rc7
 - Drop importing cputype.h, which was not used by the series

[0] https://lore.kernel.org/all/20230802234255.466782-1-oliver.upton@linux.dev/



Oliver Upton (12):
  Import arm-smccc.h from Linux v6.18
  arm64: Stash kvm_vcpu_init for later use
  arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
  arm64: Expose ARM64_CORE_REG() for general use
  arm64: Add support for finding vCPU for given MPIDR
  arm64: Add skeleton implementation for PSCI
  arm64: psci: Implement CPU_SUSPEND
  arm64: psci: Implement CPU_ON
  arm64: psci: Implement AFFINITY_INFO
  arm64: psci: Implement MIGRATE_INFO_TYPE
  arm64: psci: Implement SYSTEM_{OFF,RESET}
  arm64: smccc: Start sending PSCI to userspace

Suzuki K Poulose (3):
  Allow pausing the VM from vcpu thread
  update_headers: arm64: Track psci.h for PSCI definitions
  update headers: Linux v6.18

 Makefile                            |   2 +
 arm64/include/asm/kvm.h             |  23 ++-
 arm64/include/asm/smccc.h           |  65 ++++++
 arm64/include/kvm/kvm-arch.h        |   2 +
 arm64/include/kvm/kvm-config-arch.h |   8 +-
 arm64/include/kvm/kvm-cpu-arch.h    |  30 ++-
 arm64/kvm-cpu.c                     |  51 +++--
 arm64/kvm.c                         |  20 ++
 arm64/psci.c                        | 207 +++++++++++++++++++
 arm64/smccc.c                       |  81 ++++++++
 include/linux/arm-smccc.h           | 305 ++++++++++++++++++++++++++++
 include/linux/kvm.h                 |  36 ++++
 include/linux/psci.h                |  52 +++++
 include/linux/virtio_ids.h          |   1 +
 include/linux/virtio_net.h          |  49 ++++-
 include/linux/virtio_pci.h          |   1 +
 kvm-cpu.c                           |  13 ++
 kvm.c                               |  34 +++-
 powerpc/include/asm/kvm.h           |  13 --
 riscv/include/asm/kvm.h             |  26 ++-
 util/update_headers.sh              |  17 +-
 x86/include/asm/kvm.h               | 115 +++++++++++
 22 files changed, 1091 insertions(+), 60 deletions(-)
 create mode 100644 arm64/include/asm/smccc.h
 create mode 100644 arm64/psci.c
 create mode 100644 arm64/smccc.c
 create mode 100644 include/linux/arm-smccc.h

-- 
2.43.0


