Return-Path: <kvm+bounces-11041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 416C687253F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F059A287891
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B385171B6;
	Tue,  5 Mar 2024 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h8KTShX4"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F133815E86
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658545; cv=none; b=Gvep3JYMSxAAayocTUqkgy0wAhf20QuzG40E7eU+W8aL9Y4dJKBEUlxUU7yM/5Mmn/ESn9Ijb8KW7cnL0iYXMdmFg6f8azhWq1KSMOQVznouhgn5rn+UtODZRAxdEuyTxjPciXPuiseTG9Y8B/oueJD+JU+9dIUr+nQyQgVjR9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658545; c=relaxed/simple;
	bh=vOfjeDzw9ZYeH7G4VElq0O30lm4oX6TiNKg8xX9j31w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=LjjTiBu1Y4J/y6oLQEidQXVXyC1va/DULVo9zRDE9VTIvyCOSE1gUIjcEi4LKITTH5zw/S51rBnaFGVmGkaU2C2UOx8AN+BsA4j7avaHz5K18ptYNH9k3pPmfx2ALi1hRBoeY6U6pXAnn3I0qa0Q4K47wrbehUNEOMXdloj98MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h8KTShX4; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qiGjlVIp3GLTTnuU70kOvQo6dv9eQHB7GF1BkZe2X+4=;
	b=h8KTShX4U7H/i5zwB63unsPBlhFTAUP52vczpMSRxIiWXuhKMACgGlnbDeXu8qncD8y+xP
	ul609H2eR8t69964/H1AzffHV36Is+iSK0l17jxzGZYg99/53gBd9/OZI+bGBynat3rBrW
	RoTrCHpZ9lwNVFu0lAKtoJUjEIQ2+rA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 00/13] Enable EFI support
Date: Tue,  5 Mar 2024 18:08:59 +0100
Message-ID: <20240305170858.395836-15-andrew.jones@linux.dev>
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

[1] https://lore.kernel.org/all/20240305164623.379149-20-andrew.jones@linux.dev/

v2:
 - Rebase on v3 of arm's efi improvement series
 - Just make base_address a weak function rather than duplicate it
 - Always preserve .so files (they're useful for debug)
 - Build the sieve test for EFI
 - Pick up a couple tags

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
 lib/arm64/stack.c             |  12 +-
 lib/efi.c                     |  33 ++++++
 lib/elf.h                     |   5 +
 lib/riscv/asm/setup.h         |   5 +
 lib/riscv/processor.c         |  11 +-
 lib/riscv/setup.c             | 170 +++++++++++++++++++++-------
 lib/riscv/stack.c             |  30 +++--
 lib/s390x/stack.c             |  12 +-
 lib/stack.c                   |   8 +-
 lib/stack.h                   |  24 +++-
 lib/x86/stack.c               |  12 +-
 riscv/Makefile                |  27 ++++-
 riscv/cstart.S                |   4 +
 riscv/efi/crt0-efi-riscv64.S  | 205 ++++++++++++++++++++++++++++++++++
 riscv/efi/elf_riscv64_efi.lds | 142 +++++++++++++++++++++++
 riscv/efi/reloc_riscv64.c     |  91 +++++++++++++++
 riscv/efi/run                 | 106 ++++++++++++++++++
 riscv/flat.lds                |   1 +
 riscv/run                     |   2 +-
 21 files changed, 828 insertions(+), 97 deletions(-)
 create mode 100644 riscv/efi/crt0-efi-riscv64.S
 create mode 100644 riscv/efi/elf_riscv64_efi.lds
 create mode 100644 riscv/efi/reloc_riscv64.c
 create mode 100755 riscv/efi/run

-- 
2.44.0


