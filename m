Return-Path: <kvm+bounces-42668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F545A7C1CF
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1FC21897AC6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D8620F076;
	Fri,  4 Apr 2025 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O65OkhZP"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBD1DA53
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785570; cv=none; b=E6o9pT7JAc0dNz4FGRvknpwDHLuEMAwSsFl6eTGyl3VN2Fj5lM+S9rfeXa69/SHYDR7MKAcCZYwhR8bR7VIEPLA0Z980Q8rfSgpo+Km6zGE0fvTfPbKIhJUnGonAjRRKSCCqaVQowEnYK+uK0xwAoygFxAz4pRXVrdF9z60w9Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785570; c=relaxed/simple;
	bh=h9VIzqika1SYII2NaBoGWXB3jUeQFYAkjBfKeJajHYM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uB1HmEbJK5vNT5GMul3lA/krHmELMX4uYFOpPaWrhu5kdQCddAayBI7K+uhHUQ6iZZYRpGb3Z6Cy82pdAwQ0rYMpXBcHUursjt0O2lzuFs1U95cw6Nl4VL0iA6+ZANmOFYaw1tdH0EjTmNm+TBfGSlhfjKzk7mB9yCR0lTXPwD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O65OkhZP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+DtZov2YxrqWacepQyZltq5Yq5wqCErNbBzjsUWttxM=;
	b=O65OkhZPkFhwGIP3mq69kVvZ9Drm2H29sJiZCm6JaM2NYuNtyhZxncTO2SZyUQ8x89y2ab
	HylstIir4Q3Jh0ZxXl2tWxDBS1gGPElZ0+/vUIth1AkAEDd8Y8wZJA/7LNh936JK4cRyWv
	AMJ9/IRD+qZukJL5LRpbO0BCxDKD/Y4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 0/9] arm: Drop support for 32-bit kvmtool
Date: Fri,  4 Apr 2025 09:52:23 -0700
Message-Id: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v1: https://lore.kernel.org/kvmarm/20250325213939.2414498-1-oliver.upton@linux.dev/

v1 -> v2:
 - Move headers under arm64/include/kvm similar to other arches (Alex)

Oliver Upton (9):
  Drop support for 32-bit arm
  arm64: Move arm64-only features into main directory
  arm64: Combine kvm.c
  arm64: Merge kvm-cpu.c
  arm64: Combine kvm-config-arch.h
  arm64: Move remaining kvm/* headers
  arm64: Move asm headers
  arm64: Rename top-level directory
  arm64: Get rid of the 'arm-common' include directory

 INSTALL                                       |   9 +-
 Makefile                                      |  40 +--
 arm/aarch32/arm-cpu.c                         |  50 ---
 arm/aarch32/include/asm/kernel.h              |   8 -
 arm/aarch32/include/asm/kvm.h                 | 311 ------------------
 arm/aarch32/include/kvm/barrier.h             |  10 -
 arm/aarch32/include/kvm/fdt-arch.h            |   6 -
 arm/aarch32/include/kvm/kvm-arch.h            |  18 -
 arm/aarch32/include/kvm/kvm-config-arch.h     |   8 -
 arm/aarch32/include/kvm/kvm-cpu-arch.h        |  24 --
 arm/aarch32/kvm-cpu.c                         | 132 --------
 arm/aarch32/kvm.c                             |  14 -
 arm/aarch64/include/kvm/fdt-arch.h            |   6 -
 arm/aarch64/include/kvm/kvm-arch.h            |  22 --
 arm/aarch64/include/kvm/kvm-config-arch.h     |  29 --
 arm/aarch64/include/kvm/kvm-cpu-arch.h        |  19 --
 arm/aarch64/kvm.c                             | 212 ------------
 arm/kvm-cpu.c                                 | 153 ---------
 {arm/aarch64 => arm64}/arm-cpu.c              |   5 +-
 {arm => arm64}/fdt.c                          |   5 +-
 {arm => arm64}/gic.c                          |   3 +-
 {arm => arm64}/gicv2m.c                       |   3 +-
 {arm/aarch64 => arm64}/include/asm/image.h    |   0
 {arm/aarch64 => arm64}/include/asm/kernel.h   |   0
 {arm/aarch64 => arm64}/include/asm/kvm.h      |   0
 {arm/aarch64 => arm64}/include/asm/pmu.h      |   0
 .../include/asm/sve_context.h                 |   0
 {arm/aarch64 => arm64}/include/kvm/barrier.h  |   0
 .../include/kvm}/fdt-arch.h                   |   0
 .../arm-common => arm64/include/kvm}/gic.h    |   0
 .../include/kvm}/kvm-arch.h                   |   8 +-
 .../include/kvm}/kvm-config-arch.h            |  24 +-
 .../include/kvm}/kvm-cpu-arch.h               |  10 +-
 .../pci.h => arm64/include/kvm/pci-arch.h     |   0
 .../arm-common => arm64/include/kvm}/timer.h  |   0
 {arm => arm64}/ioport.c                       |   0
 {arm/aarch64 => arm64}/kvm-cpu.c              | 289 ++++++++++++----
 {arm => arm64}/kvm.c                          | 210 +++++++++++-
 {arm => arm64}/pci.c                          |   5 +-
 {arm/aarch64 => arm64}/pmu.c                  |   3 +-
 {arm/aarch64 => arm64}/pvtime.c               |   0
 {arm => arm64}/timer.c                        |   5 +-
 builtin-run.c                                 |   2 +-
 hw/cfi_flash.c                                |   2 +-
 hw/rtc.c                                      |   2 +-
 hw/serial.c                                   |   2 +-
 virtio/core.c                                 |   2 +-
 47 files changed, 498 insertions(+), 1153 deletions(-)
 delete mode 100644 arm/aarch32/arm-cpu.c
 delete mode 100644 arm/aarch32/include/asm/kernel.h
 delete mode 100644 arm/aarch32/include/asm/kvm.h
 delete mode 100644 arm/aarch32/include/kvm/barrier.h
 delete mode 100644 arm/aarch32/include/kvm/fdt-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-config-arch.h
 delete mode 100644 arm/aarch32/include/kvm/kvm-cpu-arch.h
 delete mode 100644 arm/aarch32/kvm-cpu.c
 delete mode 100644 arm/aarch32/kvm.c
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 delete mode 100644 arm/aarch64/include/kvm/kvm-arch.h
 delete mode 100644 arm/aarch64/include/kvm/kvm-config-arch.h
 delete mode 100644 arm/aarch64/include/kvm/kvm-cpu-arch.h
 delete mode 100644 arm/aarch64/kvm.c
 delete mode 100644 arm/kvm-cpu.c
 rename {arm/aarch64 => arm64}/arm-cpu.c (96%)
 rename {arm => arm64}/fdt.c (99%)
 rename {arm => arm64}/gic.c (99%)
 rename {arm => arm64}/gicv2m.c (99%)
 rename {arm/aarch64 => arm64}/include/asm/image.h (100%)
 rename {arm/aarch64 => arm64}/include/asm/kernel.h (100%)
 rename {arm/aarch64 => arm64}/include/asm/kvm.h (100%)
 rename {arm/aarch64 => arm64}/include/asm/pmu.h (100%)
 rename {arm/aarch64 => arm64}/include/asm/sve_context.h (100%)
 rename {arm/aarch64 => arm64}/include/kvm/barrier.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/fdt-arch.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/gic.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-arch.h (96%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-config-arch.h (54%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-cpu-arch.h (82%)
 rename arm/include/arm-common/pci.h => arm64/include/kvm/pci-arch.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/timer.h (100%)
 rename {arm => arm64}/ioport.c (100%)
 rename {arm/aarch64 => arm64}/kvm-cpu.c (70%)
 rename {arm => arm64}/kvm.c (59%)
 rename {arm => arm64}/pci.c (98%)
 rename {arm/aarch64 => arm64}/pmu.c (99%)
 rename {arm/aarch64 => arm64}/pvtime.c (100%)
 rename {arm => arm64}/timer.c (94%)


base-commit: e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be
-- 
2.39.5


