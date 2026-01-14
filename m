Return-Path: <kvm+bounces-68018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A85D3D1EA13
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 31F1E306B06D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16D5396B88;
	Wed, 14 Jan 2026 11:58:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3891C38B983
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391928; cv=none; b=alYYmoc8sl7ZNtlwIix5xRKDyaOhE0zRes1gDgGT/8jajuJHR4namWHZUy1bfVMtP4+3CC6hU7cT4DrerVmCHt0Hu/cid0IE43oBSzZgSHVz6QLY7eC3fM3i7+xUnsPuERvFiEzGhFlhyjVEXXqAqHrAhCeu1M0zziMqgu+ybzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391928; c=relaxed/simple;
	bh=sHU6Ozm+zslLq5gDaJSDJN+Dv4Cqt08DO2oJ/8Eihrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BKsIpGhO6giYkjD6HFlQSPkTina+IKKLD4qV+46erN9ghvkcJMmubsdWu8e6Yi47vYydj20wssgx72Gb4pt48bfuG7IT5QzeX2kzziN0iNCoicD4HoB3xCKLhuTFTydn1J2yxdt8TAM0T8ePspcEkxXkOiD9KzzxdIzaxnY7A5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F24ED1424;
	Wed, 14 Jan 2026 03:58:37 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 731D03F632;
	Wed, 14 Jan 2026 03:58:43 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Date: Wed, 14 Jan 2026 11:56:52 +0000
Message-Id: <20260114115703.926685-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2.

Changes since v4[1]:
	- changed env var to support EL2=1,y,Y
	- replaced ifdef in selftest with test_exception_prep()

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (9):
  arm64: set SCTLR_EL1 to a known value for secondary cores
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported
  arm64: add EL2 environment variable

 arm/cstart64.S             | 66 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 +++
 arm/micro-bench.c          | 26 +++++++++++++--
 arm/pmu.c                  | 13 +++++---
 arm/run                    |  7 ++++
 arm/selftest.c             | 22 ++++++++++---
 arm/timer.c                | 12 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  8 +++++
 lib/arm/asm/timer.h        | 11 +++++++
 lib/arm/setup.c            |  4 +++
 lib/arm/timer.c            | 19 +++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++
 lib/arm64/processor.c      | 14 ++++++++
 14 files changed, 208 insertions(+), 20 deletions(-)

-- 
2.25.1


