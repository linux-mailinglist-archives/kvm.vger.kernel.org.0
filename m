Return-Path: <kvm+bounces-41997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0296A70C39
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72F7B7A3E3E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43E7267B05;
	Tue, 25 Mar 2025 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v/k952Ay"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95046165F16
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938796; cv=none; b=eiTSJmiPlsBUrXQEumtcH+w2yne4QHxQqpPtq9p8/tFDY14yY+xhXNh9On3yUhvpV03w6zI0nAAY4VrB1/CRPIt5ZCkmUwRDeYzY5HkeIWouMjsCrgi3ioxa/rACnhQDbI+HvrgjX3sh8AgL/GKr3X+SgsGWBrFG24oEF1k1c4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938796; c=relaxed/simple;
	bh=k3E1h/E7UVRzhvdDrvj8+tvzmX3dSxH0GgHSJs8JqdI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=po+p0ghjR4pEVvUu47Z8JSGOLCkohYedgnjBtHEZ0wXDNq++vUfZaanv73h0sx1RNB/gcMetfuVR0nI/aRPlwcDQzZ6Aru46UuiwVs9izxZaj6L/LnpdhlLlushcMQizE03PXs3aTVdY+nQI0m2vrHmXjbbX/jhbJs59zQoKh3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v/k952Ay; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mByK3U9ks43MxbjsUGI4MqUdWykoyYidE7K05BaGj3I=;
	b=v/k952AygTxKU2zK1lpBI46x4uig5614TXskb12Ne87QjDB9Sr05uWNG0h4k3hohkU09DE
	FQRR3Ojijef1RLuQGDW2WEmnCC+gORrZ583QVSRNN02zpEdnQkeCKCNZVIdF1AHYV/uAOl
	4i1BJw0kvQFb8rcZ6ILfLegC1IvaaWo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 0/9] arm: Drop support for 32-bit kvmtool
Date: Tue, 25 Mar 2025 14:39:30 -0700
Message-Id: <20250325213939.2414498-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last stable kernel to support 32-bit KVM/arm is 5.4, which is on
track for EOL at the end of this year. Considering this, and the fact
that 32-bit KVM never saw much usage in the first place, it is probably
time to toss out the coprolite.

Of course, this has no effect on the support for 32-bit guests on 64-bit
KVM.

RFC: https://lore.kernel.org/kvmarm/20250314222516.1302429-1-oliver.upton@linux.dev/

RFC -> v1:
 - Collected Marc's Acks
 - Cleaned up some forgotten references to CONFIG_ARM (Alex)
 - Minor nits on includes, defines (Alex)

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
 {arm/aarch64 => arm64}/arm-cpu.c              |   4 +-
 {arm => arm64}/fdt.c                          |   4 +-
 {arm => arm64}/gic.c                          |   2 +-
 {arm => arm64}/gicv2m.c                       |   2 +-
 {arm/aarch64 => arm64}/include/asm/image.h    |   0
 {arm/aarch64 => arm64}/include/asm/kernel.h   |   0
 {arm/aarch64 => arm64}/include/asm/kvm.h      |   0
 {arm/aarch64 => arm64}/include/asm/pmu.h      |   0
 .../include/asm/sve_context.h                 |   0
 .../arm-common => arm64/include}/gic.h        |   0
 {arm/aarch64 => arm64}/include/kvm/barrier.h  |   0
 .../include/kvm}/fdt-arch.h                   |   0
 .../include/kvm}/kvm-arch.h                   |   8 +-
 .../include/kvm}/kvm-config-arch.h            |  24 +-
 .../include/kvm}/kvm-cpu-arch.h               |  10 +-
 .../arm-common => arm64/include}/pci.h        |   0
 .../arm-common => arm64/include}/timer.h      |   0
 {arm => arm64}/ioport.c                       |   0
 {arm/aarch64 => arm64}/kvm-cpu.c              | 289 ++++++++++++----
 {arm => arm64}/kvm.c                          | 209 +++++++++++-
 {arm => arm64}/pci.c                          |   4 +-
 {arm/aarch64 => arm64}/pmu.c                  |   2 +-
 {arm/aarch64 => arm64}/pvtime.c               |   0
 {arm => arm64}/timer.c                        |   4 +-
 builtin-run.c                                 |   2 +-
 hw/cfi_flash.c                                |   2 +-
 hw/rtc.c                                      |   2 +-
 hw/serial.c                                   |   2 +-
 virtio/core.c                                 |   2 +-
 47 files changed, 498 insertions(+), 1145 deletions(-)
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
 rename {arm/include/arm-common => arm64/include}/gic.h (100%)
 rename {arm/aarch64 => arm64}/include/kvm/barrier.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/fdt-arch.h (100%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-arch.h (96%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-config-arch.h (54%)
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-cpu-arch.h (82%)
 rename {arm/include/arm-common => arm64/include}/pci.h (100%)
 rename {arm/include/arm-common => arm64/include}/timer.h (100%)
 rename {arm => arm64}/ioport.c (100%)
 rename {arm/aarch64 => arm64}/kvm-cpu.c (70%)
 rename {arm => arm64}/kvm.c (59%)
 rename {arm => arm64}/pci.c (98%)
 rename {arm/aarch64 => arm64}/pmu.c (99%)
 rename {arm/aarch64 => arm64}/pvtime.c (100%)
 rename {arm => arm64}/timer.c (95%)


base-commit: e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be
-- 
2.39.5


