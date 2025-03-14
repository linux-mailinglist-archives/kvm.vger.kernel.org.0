Return-Path: <kvm+bounces-41117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE169A62078
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 316588833A6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2871F153A;
	Fri, 14 Mar 2025 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HFnKvQYG"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC00C1A3174
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991672; cv=none; b=e+YLQhuwMtoJIYINRjLw/2fm6olGB4LCIJ7gDFfQ1dyrqS+zVsBT8uoUesbEoQNjZVwR4kgAFVROtBCs/06JpNkn243s5enxOMpoiBoalqZNan2ufRklCtZuu6pLvy2qrJw6XfTwy6vteUiXCN2LA+1t9zF/x9MjbQQm//xl+00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991672; c=relaxed/simple;
	bh=M3g5rrvKLGH79LZ1cD3Sdu/+ggcKKB8NqXxspdwV/Ks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mK80eYbM5s8bHjzC9qtx3xeTbsyiFefQrARO1190YdxT5gsO17cNmwu2xY7h+F5sk9NLVHw6+FTHaY+skvhqVNcvbemcSW0Ui8BVjXeL3HssSYArZcZl38TgV83TUy2GW1+XyAx5FTQ5PEt5D07OUv2mD3R4mMFhegM81JvqsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HFnKvQYG; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lBVZR4uXUSPPvEPGlWvqFoD+Ej/JWMLtccCvCEPLHwY=;
	b=HFnKvQYGq9Cakrhx9Iq3JktnVlybfkntvZgBKOGqGmMRiwBfv9o6Dy37ajYPTmWhZnnmwK
	OtDjcI8+I1v2pkvZYacZbuNNQpSAKjmuYxp5GAeZmbaNVWDYBJILRL0h3fuoxq7TxAKEXf
	+NSTn6wR6ALdsLbgUyX/SDVhVPNCais=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 0/9] arm: Drop support for 32-bit kvmtool
Date: Fri, 14 Mar 2025 15:25:07 -0700
Message-Id: <20250314222516.1302429-1-oliver.upton@linux.dev>
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
 .../include/kvm}/kvm-arch.h                   |   6 +-
 .../include/kvm}/kvm-config-arch.h            |  24 +-
 .../include/kvm}/kvm-cpu-arch.h               |  10 +-
 .../arm-common => arm64/include}/pci.h        |   0
 .../arm-common => arm64/include}/timer.h      |   0
 {arm => arm64}/ioport.c                       |   0
 {arm/aarch64 => arm64}/kvm-cpu.c              | 289 ++++++++++++----
 {arm => arm64}/kvm.c                          | 212 +++++++++++-
 {arm => arm64}/pci.c                          |   4 +-
 {arm/aarch64 => arm64}/pmu.c                  |   2 +-
 {arm/aarch64 => arm64}/pvtime.c               |   0
 {arm => arm64}/timer.c                        |   4 +-
 42 files changed, 495 insertions(+), 1139 deletions(-)
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
 rename {arm/include/arm-common => arm64/include/kvm}/kvm-arch.h (97%)
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


