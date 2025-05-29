Return-Path: <kvm+bounces-47972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93410AC7F52
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA3A3B26F2
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA01226CFE;
	Thu, 29 May 2025 13:56:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C82224B0C
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526992; cv=none; b=kuHSkWV1ehv6BbeyhLgtYL5NuQtKMJRATDNESaOXgbSL/GXMZaj2Yg3FRsdfhT2V28KHGuO/ZupEJElfc+ZPngnfYVNwqCHpLj+j7M/LHSzut9TkBwzhbdNLmSvXoEU+0YE+/wEi3MFKIJZNBm8vqZcsPADb8fQnP0nhjmmBQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526992; c=relaxed/simple;
	bh=TsPOS6LVXHO8JXbYSYGqNKLcztarndE6eVNRtsyq9K0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mImksr0QFBG3oiTP0ir2u+6MMlpLJTRTTP7mTt80gmCMDV7kgIWoDa6LFQhwd5fTfkv6Lw29RZ14EzwElmwLKsAHAQ/IZGyZGaggyBZu33QOFJrdn9RW8jk5nG7qYmRqdxXahry4qN7yyjW8whaOSdIOztOGV02oGHewMYL8s0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FAAD176A;
	Thu, 29 May 2025 06:56:13 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84D9B3F673;
	Thu, 29 May 2025 06:56:28 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 0/9] arm64: support EL2
Date: Thu, 29 May 2025 14:55:48 +0100
Message-Id: <20250529135557.2439500-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2. These
have been tested with Marc Zyngier's Linux kvm-arm64/nv-next branch [1] and
kvmtool branch arm64/nv-6.13 [2]

The goal is to later extend and add new tests for Nested Virtualisation,
however they should also work with bare metal as well.

Changes since v1[3]:
	- Authorship fixed on 2 patches
	- Tested and fixed EFI support
	- Recactored assembly and added init_el macro
	- Clear trap registers, trying to avoid relying on default register
	  state
	- Cleaned up PMU changes

The debug tests fail with --nested, but pass with --nested --e2h0, I
need to investigate this.

Thanks,
Joey

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-next (commit a35d752b17f4)
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git arm64/nv-6.13 (commit 5b6fe295ea7)
[3] https://lore.kernel.org/kvmarm/20250220141354.2565567-1-joey.gouly@arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (7):
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported

 arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 ++++
 arm/micro-bench.c          | 26 ++++++++++++++++--
 arm/pmu.c                  | 13 ++++++---
 arm/selftest.c             | 18 ++++++++----
 arm/timer.c                | 10 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  1 +
 lib/arm/asm/timer.h        | 11 ++++++++
 lib/arm/setup.c            |  6 ++++
 lib/arm/timer.c            | 19 +++++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++++
 12 files changed, 167 insertions(+), 19 deletions(-)

-- 
2.25.1


