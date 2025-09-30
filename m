Return-Path: <kvm+bounces-59137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 959A8BAC7D2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 507701C84D5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15602F8BEE;
	Tue, 30 Sep 2025 10:32:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F511C84A6;
	Tue, 30 Sep 2025 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228321; cv=none; b=s+jPOinaYqUBiCycppYQ79aDpQws62B4Gs/w06DidGe4/1gVaCOqFXkjmS/nhSUq4cGdRqI2qOVKfIU8oWmKxY9vN2rWQW0R1ESv1OpTSWVzfCTEETwXvFbTNQUO/7Q4FqkPYm4ypMhLt66itBJTBC/FnSqE3Vam3e1uVn7d+W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228321; c=relaxed/simple;
	bh=MmWWeWN2VszbM6u7oDU+wa7E68fvdskDjNBmxAo7sms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cOPsYrfsj83ZG1ZWk7oHd/qJes1NUmfk3lM+CpjnsFtGnREuMkRtE0JJRC6Mf/PkiVewguq+cB71zBQUOZvO9LeFV8Gow1libLHbp49GKzodLA/gvpHIY8vw9dX6lgCxPVL4pFxNr43YKvNQXqK84E/1uaYxfpSnIyEhcph27zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29AB82008;
	Tue, 30 Sep 2025 03:31:51 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D22ED3F66E;
	Tue, 30 Sep 2025 03:31:57 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool 00/15] arm64: Handle PSCI calls in userspace
Date: Tue, 30 Sep 2025 11:31:14 +0100
Message-ID: <20250930103130.197534-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is version 4 of the patch series, originally posted by Oliver [0]. Mostly
remains the same as v3, except for

 - Address Will's comment on the race between pause/resume - Patch 1
 - Rebase on to v6.17-rc7
 - Drop importing cputype.h, which was not used by the series

[0] https://lore.kernel.org/all/20230802234255.466782-1-oliver.upton@linux.dev/


Oliver Upton (12):
  Import arm-smccc.h from Linux 6.17-rc7
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
  update headers: Linux v6.17-rc7

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
 include/linux/kvm.h                 |  33 +++
 include/linux/psci.h                |  52 +++++
 include/linux/virtio_net.h          |  46 +++++
 include/linux/virtio_pci.h          |   1 +
 kvm-cpu.c                           |  13 ++
 kvm.c                               |  35 +++-
 powerpc/include/asm/kvm.h           |  13 --
 riscv/include/asm/kvm.h             |   3 +
 util/update_headers.sh              |  17 +-
 x86/include/asm/kvm.h               |  81 ++++++++
 21 files changed, 1030 insertions(+), 58 deletions(-)
 create mode 100644 arm64/include/asm/smccc.h
 create mode 100644 arm64/psci.c
 create mode 100644 arm64/smccc.c
 create mode 100644 include/linux/arm-smccc.h

-- 
2.43.0


