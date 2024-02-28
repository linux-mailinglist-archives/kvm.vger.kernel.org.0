Return-Path: <kvm+bounces-10269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB5E86B299
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD4F11C239EA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19ECC15B969;
	Wed, 28 Feb 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uUz0Pct3"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DDE15B116
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132668; cv=none; b=aHL5onRWoRD6igfhENq4ZQzVX1+cdlkrvFI5XvoGTkJvIN5FPJQaq54SeUZ7DhMeG0BCan5DiiQmy93dMhupqnxBwIp+QJsUYhlhrJOqEbQgqLcboJ/ZNszPPWbg3Cyj9Gkckv7Xc+9Ba0Day9sliZp25jW82zp9hMGSLvoHEyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132668; c=relaxed/simple;
	bh=8eMRd/oHEUe9MUzGYkwL5XXK2iDMIa3Qqdmyvs/RTg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=CwTZeg2Ov+iqDCMK5pX6LZWQosO2C6wZuuOj36jpiGFihYD0u8Fp/ZHHBvysoggco8GfsApLQ61InKWKPoEXmT5aIqWr3f2FduX9gylJ4VOL7+J+42zPcrKFPnoAvtxiFZi/4Z9eac2UwFj8eDGphx68ZQ14SHaPcj90I7Q0K0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uUz0Pct3; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F3OLa0i4UwdZZlQuFWpgted6HIiHCPiUmaMsOXLR+zY=;
	b=uUz0Pct30kEYSGTtC5vW46S0JdyD6/bGZ8BSDhUT39gYg2T344Djbq1m9nbA6ApU7zG3gh
	vKK4mdgmrZjYDJCmOZxYpQncNtprNp9lgRTXxLOGTERdyvMKKYG94SXBJvT/zNYxYvsere
	x8A06r6DXZQloK/LBwqxNwdG137UWws=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 00/13] Enable EFI support
Date: Wed, 28 Feb 2024 16:04:16 +0100
Message-ID: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series starts with some fixes for backtraces for bugs found
when tracing with riscv EFI builds. The series then brings EFI
support to riscv, basing the approach heavily on arm64's support
(including arm64's improvements[1]). It should now be possible
to launch tests from EFI-capable bootloaders.

[1] https://lore.kernel.org/all/20240227192109.487402-20-andrew.jones@linux.dev/

Thanks,
drew

Andrew Jones (13):
  riscv: Call abort instead of assert on unhandled exceptions
  riscv: show_regs: Prepare for EFI images
  treewide: lib/stack: Fix backtrace
  treewide: lib/stack: Make base_address arch specific
  riscv: Import gnu-efi files
  riscv: Tweak the gnu-efi imported code
  riscv: Enable building for EFI
  riscv: efi: Switch stack in _start
  efi: Add support for obtaining the boot hartid
  riscv: Refactor setup code
  riscv: Enable EFI boot
  riscv: efi: Add run script
  riscv: efi: Use efi-direct by default

 configure                     |  12 +-
 lib/arm/stack.c               |  13 +--
 lib/arm64/stack.c             |  29 +++--
 lib/efi.c                     |  33 ++++++
 lib/elf.h                     |   5 +
 lib/riscv/asm/setup.h         |   5 +
 lib/riscv/processor.c         |  11 +-
 lib/riscv/setup.c             | 170 +++++++++++++++++++++-------
 lib/riscv/stack.c             |  30 +++--
 lib/s390x/stack.c             |  12 +-
 lib/stack.c                   |  19 +---
 lib/stack.h                   |  26 +++--
 lib/x86/stack.c               |  29 +++--
 riscv/Makefile                |  24 +++-
 riscv/cstart.S                |   4 +
 riscv/efi/crt0-efi-riscv64.S  | 205 ++++++++++++++++++++++++++++++++++
 riscv/efi/elf_riscv64_efi.lds | 142 +++++++++++++++++++++++
 riscv/efi/reloc_riscv64.c     |  91 +++++++++++++++
 riscv/efi/run                 | 106 ++++++++++++++++++
 riscv/flat.lds                |   1 +
 riscv/run                     |   2 +-
 21 files changed, 859 insertions(+), 110 deletions(-)
 create mode 100644 riscv/efi/crt0-efi-riscv64.S
 create mode 100644 riscv/efi/elf_riscv64_efi.lds
 create mode 100644 riscv/efi/reloc_riscv64.c
 create mode 100755 riscv/efi/run

-- 
2.43.0


