Return-Path: <kvm+bounces-6779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D6383A2AA
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17E431C22EF0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DDC168B1;
	Wed, 24 Jan 2024 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ObR2i7ws"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF3F101D0
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080704; cv=none; b=XlmEma+CzDHoR9+0u42U1plAGJTK0p8GdzEyzpkF76aIS1CBzQZgHX2VQeqRmsAT1UOwH0nxgCmxf9v3OB62+9OxkCfcUYUwXb6j/2BlpwZ9Gbxa4LlI0M1soJDe8yl86WpHXR3j/lqbwdXVpYv3UmVSkgtSRi+hWI5d0t87BeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080704; c=relaxed/simple;
	bh=BUDOl+he2VSDS5povOk9spu6aJfCgv7y3hWCCp9KE58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=aXkEAsxGxKccb+Na0Qnl4We1wsj3AParPfds1O9s9pvprOSikHxSUzeFLAa533WP0SAkPNobRlEPQhLC7wxL2AwHnK5ldhNF32Arf4cfXtTE1iOEDtc1WZUFwYyD6D5cXYiAqUq+AzMVYNTrPlt2mjH7WX39JVdIwQJYzpSP2XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ObR2i7ws; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L7AGd2HUhFEaUQa5X78KLrXAOeiW+3NvEnQYv5/yyjQ=;
	b=ObR2i7ws8uvf4/p2EcN91/SQ1PlQ7xWwrMeH1xJjP7ksXVKZ6zj50G4gVWxsGefBamI3tw
	P6NnRGsC7cNWqh+n9HO7VrUKxQW0MTBqutyaeZvFa7l7JLSjvJPKI6qsUvi0MAFYNf+cOk
	b9ytoV8YBdWIJv4O9MTrlpdNwS2aMWk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 00/24] Introduce RISC-V
Date: Wed, 24 Jan 2024 08:18:16 +0100
Message-ID: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series adds another architecture to kvm-unit-tests (RISC-V, both
32-bit and 64-bit). Much of the code is borrowed from arm/arm64 by
mimicking its patterns or by first making the arm code more generic
and moving it to the common lib.

This series brings UART, SMP, MMU, and exception handling support.
One should be able to start writing CPU validation tests in a mix
of C and asm as well as write SBI tests, as is the plan for the SBI
verification framework. kvm-unit-tests provides backtraces on asserts
and input can be given to the tests through command line arguments,
environment variables, and the DT (there's already an ISA string
parser for extension detection).

This series only targets QEMU TCG and KVM, but OpenSBI may be replaced
with other SBI implementations, such as RustSBI. It's a goal to target
bare-metal as soon as possible, so EFI support is already in progress
and will be posted soon. More follow on series will come as well,
bringing interrupt controller support for timer and PMU testing,
support to run tests in usermode, and whatever else people need for
their tests.

Thanks,
drew 

Andrew Jones (24):
  configure: Add ARCH_LIBDIR
  riscv: Initial port, hello world
  arm/arm64: Move cpumask.h to common lib
  arm/arm64: Share cpu online, present and idle masks
  riscv: Add DT parsing
  riscv: Add initial SBI support
  riscv: Add run script and unittests.cfg
  riscv: Add riscv32 support
  riscv: Add exception handling
  riscv: Add backtrace support
  arm/arm64: Generalize wfe/sev names in smp.c
  arm/arm64: Remove spinlocks from on_cpu_async
  arm/arm64: Share on_cpus
  riscv: Compile with march
  riscv: Add SMP support
  arm/arm64: Share memregions
  riscv: Populate memregions and switch to page allocator
  riscv: Add MMU support
  riscv: Enable the MMU in secondaries
  riscv: Enable vmalloc
  lib: Add strcasecmp and strncasecmp
  riscv: Add isa string parsing
  gitlab-ci: Add riscv64 tests
  MAINTAINERS: Add riscv

 .gitlab-ci.yml               |  16 +++
 MAINTAINERS                  |   8 ++
 Makefile                     |   2 +-
 arm/Makefile.common          |   2 +
 arm/selftest.c               |   3 +-
 configure                    |  16 +++
 lib/arm/asm/gic-v2.h         |   2 +-
 lib/arm/asm/gic-v3.h         |   2 +-
 lib/arm/asm/gic.h            |   2 +-
 lib/arm/asm/setup.h          |  14 --
 lib/arm/asm/smp.h            |  45 +-----
 lib/arm/mmu.c                |   3 +-
 lib/arm/setup.c              |  93 +++----------
 lib/arm/smp.c                | 135 +-----------------
 lib/arm64/asm/cpumask.h      |   1 -
 lib/{arm/asm => }/cpumask.h  |  42 +++++-
 lib/ctype.h                  |  10 ++
 lib/elf.h                    |  11 ++
 lib/ldiv32.c                 |  16 +++
 lib/linux/const.h            |   2 +
 lib/memregions.c             |  82 +++++++++++
 lib/memregions.h             |  29 ++++
 lib/on-cpus.c                | 154 +++++++++++++++++++++
 lib/on-cpus.h                |  14 ++
 lib/riscv/.gitignore         |   1 +
 lib/riscv/asm-offsets.c      |  62 +++++++++
 lib/riscv/asm/asm-offsets.h  |   1 +
 lib/riscv/asm/barrier.h      |  20 +++
 lib/riscv/asm/bitops.h       |  21 +++
 lib/riscv/asm/bug.h          |  20 +++
 lib/riscv/asm/csr.h          |  84 ++++++++++++
 lib/riscv/asm/io.h           |  87 ++++++++++++
 lib/riscv/asm/isa.h          |  18 +++
 lib/riscv/asm/memory_areas.h |   1 +
 lib/riscv/asm/mmu.h          |  26 ++++
 lib/riscv/asm/page.h         |  18 +++
 lib/riscv/asm/pgtable.h      |  42 ++++++
 lib/riscv/asm/processor.h    |  27 ++++
 lib/riscv/asm/ptrace.h       |  46 +++++++
 lib/riscv/asm/sbi.h          |  54 ++++++++
 lib/riscv/asm/setup.h        |  15 ++
 lib/riscv/asm/smp.h          |  29 ++++
 lib/riscv/asm/spinlock.h     |   7 +
 lib/riscv/asm/stack.h        |  12 ++
 lib/riscv/bitops.c           |  47 +++++++
 lib/riscv/io.c               |  97 +++++++++++++
 lib/riscv/mmu.c              | 195 ++++++++++++++++++++++++++
 lib/riscv/processor.c        | 146 ++++++++++++++++++++
 lib/riscv/sbi.c              |  40 ++++++
 lib/riscv/setup.c            | 188 +++++++++++++++++++++++++
 lib/riscv/smp.c              |  70 ++++++++++
 lib/riscv/stack.c            |  32 +++++
 lib/string.c                 |  14 ++
 lib/string.h                 |   2 +
 riscv/Makefile               | 105 ++++++++++++++
 riscv/cstart.S               | 258 +++++++++++++++++++++++++++++++++++
 riscv/flat.lds               |  75 ++++++++++
 riscv/run                    |  38 ++++++
 riscv/sbi.c                  |  41 ++++++
 riscv/selftest.c             | 100 ++++++++++++++
 riscv/sieve.c                |   1 +
 riscv/unittests.cfg          |  37 +++++
 62 files changed, 2514 insertions(+), 267 deletions(-)
 delete mode 100644 lib/arm64/asm/cpumask.h
 rename lib/{arm/asm => }/cpumask.h (72%)
 create mode 100644 lib/memregions.c
 create mode 100644 lib/memregions.h
 create mode 100644 lib/on-cpus.c
 create mode 100644 lib/on-cpus.h
 create mode 100644 lib/riscv/.gitignore
 create mode 100644 lib/riscv/asm-offsets.c
 create mode 100644 lib/riscv/asm/asm-offsets.h
 create mode 100644 lib/riscv/asm/barrier.h
 create mode 100644 lib/riscv/asm/bitops.h
 create mode 100644 lib/riscv/asm/bug.h
 create mode 100644 lib/riscv/asm/csr.h
 create mode 100644 lib/riscv/asm/io.h
 create mode 100644 lib/riscv/asm/isa.h
 create mode 100644 lib/riscv/asm/memory_areas.h
 create mode 100644 lib/riscv/asm/mmu.h
 create mode 100644 lib/riscv/asm/page.h
 create mode 100644 lib/riscv/asm/pgtable.h
 create mode 100644 lib/riscv/asm/processor.h
 create mode 100644 lib/riscv/asm/ptrace.h
 create mode 100644 lib/riscv/asm/sbi.h
 create mode 100644 lib/riscv/asm/setup.h
 create mode 100644 lib/riscv/asm/smp.h
 create mode 100644 lib/riscv/asm/spinlock.h
 create mode 100644 lib/riscv/asm/stack.h
 create mode 100644 lib/riscv/bitops.c
 create mode 100644 lib/riscv/io.c
 create mode 100644 lib/riscv/mmu.c
 create mode 100644 lib/riscv/processor.c
 create mode 100644 lib/riscv/sbi.c
 create mode 100644 lib/riscv/setup.c
 create mode 100644 lib/riscv/smp.c
 create mode 100644 lib/riscv/stack.c
 create mode 100644 riscv/Makefile
 create mode 100644 riscv/cstart.S
 create mode 100644 riscv/flat.lds
 create mode 100755 riscv/run
 create mode 100644 riscv/sbi.c
 create mode 100644 riscv/selftest.c
 create mode 120000 riscv/sieve.c
 create mode 100644 riscv/unittests.cfg

-- 
2.43.0


