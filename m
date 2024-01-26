Return-Path: <kvm+bounces-7146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D2983DBA6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:23:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 761EDB22A69
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0391CA95;
	Fri, 26 Jan 2024 14:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wICAl9ld"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AAD1C6A0
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279012; cv=none; b=kkxiQ91eX4/2rg2Z0qLNXqRk2h8VV8GhiYOJJxkvTnjwJmze0AC7L0ozQYDRJ3mRmMSIc3V+/D1QYVWFdoj6YbvF5uHoSDfoKyxNjOFaCHlFAEOEGib16RHR+ktyQi36X7T6qOEL+EopCzcjuQxtmjozngnlf+Dc3/VDP9XonLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279012; c=relaxed/simple;
	bh=3DE/YZxLyMzDSvcrQRq44B0LcPTidWx7nC5zRllni8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=lN34h7tyjJocwynfQ/i+AO38PFmQCEy7/v72wOT1nQk9NB5Nqw/8GQXQGat3/FjOeyYAnodRi9shLUi/nRqIuMJ3gPd7rNodkg5DjZ8ql2LZTDjG05RyvoccI9VVWjryj4/5OLfGu8qCoyq9EkI4cIrUteubmcxW3zDGE6jwF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wICAl9ld; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AGdZaxsblPPQTcb4MiCja5v9bc/JeD30lRJSlJeOJ4k=;
	b=wICAl9ld7yTz6MeEFnwdUtPTMXuJ/M1HUV0EZdrFjcZyixhEm80bgRfpX2IMy4hH8rLCym
	aBvV2H7lJfu3+LSsQ4A21osXNrstXCvTrsGYsUTBuOb/YHIUrL1+Rt8z1t/lUfho36cnVn
	4rZisFWDGC0YHsG3F3lc/23kxGC2wQE=
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
Subject: [kvm-unit-tests PATCH v2 00/24] Introduce RISC-V
Date: Fri, 26 Jan 2024 15:23:25 +0100
Message-ID: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2:
 - While basing [1] on this series I found two bugs (one in exception
   return and another in isa string parsing). I also decided to expose
   a get_pte() function to unit tests and also an isa-extension-by-name
   function to check for arbitrary extensions. Finally, I picked up
   Thomas' gitlab-ci suggestion and his tags.

(Having [1] and the selftests running makes me pretty happy with the
series, so, unless somebody shouts, I'll merge this sometime next week.)

[1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/e9c6c58b1c799de77fd39970b358a7592ecd048f

Thanks,
drew

Original cover letter follows:

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

 .gitlab-ci.yml               |  17 +++
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
 lib/riscv/asm/csr.h          | 100 ++++++++++++++
 lib/riscv/asm/io.h           |  87 ++++++++++++
 lib/riscv/asm/isa.h          |  33 +++++
 lib/riscv/asm/memory_areas.h |   1 +
 lib/riscv/asm/mmu.h          |  32 +++++
 lib/riscv/asm/page.h         |  21 +++
 lib/riscv/asm/pgtable.h      |  42 ++++++
 lib/riscv/asm/processor.h    |  29 ++++
 lib/riscv/asm/ptrace.h       |  46 +++++++
 lib/riscv/asm/sbi.h          |  54 ++++++++
 lib/riscv/asm/setup.h        |  15 ++
 lib/riscv/asm/smp.h          |  29 ++++
 lib/riscv/asm/spinlock.h     |   7 +
 lib/riscv/asm/stack.h        |  12 ++
 lib/riscv/bitops.c           |  47 +++++++
 lib/riscv/io.c               |  97 +++++++++++++
 lib/riscv/isa.c              | 126 +++++++++++++++++
 lib/riscv/mmu.c              | 205 +++++++++++++++++++++++++++
 lib/riscv/processor.c        |  64 +++++++++
 lib/riscv/sbi.c              |  40 ++++++
 lib/riscv/setup.c            | 188 +++++++++++++++++++++++++
 lib/riscv/smp.c              |  70 ++++++++++
 lib/riscv/stack.c            |  32 +++++
 lib/string.c                 |  14 ++
 lib/string.h                 |   2 +
 riscv/Makefile               | 106 ++++++++++++++
 riscv/cstart.S               | 259 +++++++++++++++++++++++++++++++++++
 riscv/flat.lds               |  75 ++++++++++
 riscv/run                    |  41 ++++++
 riscv/sbi.c                  |  41 ++++++
 riscv/selftest.c             | 100 ++++++++++++++
 riscv/sieve.c                |   1 +
 riscv/unittests.cfg          |  37 +++++
 63 files changed, 2616 insertions(+), 267 deletions(-)
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
 create mode 100644 lib/riscv/isa.c
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


