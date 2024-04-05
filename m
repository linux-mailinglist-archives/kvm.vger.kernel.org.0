Return-Path: <kvm+bounces-13640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6A418997EA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D60B2863EC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF88415F30B;
	Fri,  5 Apr 2024 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XiPuHvyA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD8D3DB97
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306153; cv=none; b=inu147DJDluFlaDNF94qyw4IllWkxtKZVqMhTupeVyyqCAM4MxxzENyfj1oWQekiszBBM4laiIr4kmJ/ZsU4B9SY2xwoAavr4eLwfyhI3JP42OlaNnySSrIsRmhEJnqLnGSs4Dcz+7AGZ2baXXQoHi9LheEidTsYcLXKUjieNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306153; c=relaxed/simple;
	bh=n+I01v1ybaguT8oejwko/AVt4sOUntmL0xw7zuvzS3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jmiVUWp+m1EfWHTFrhce6xP+KxHKf2RzHLoAVpTPz5HuiCWzGCJp1OvnYHxwS7Ld/rkh00lQY5kGRjBQFcgYkOEAVveYlH4db/34/TFEZM5QjDrbg3/kFsYKIXncm8m8K018GxBBGemQcUc1pMQhwqbSAbS1ZKY44IqD4E5Qcgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XiPuHvyA; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-369ec1fbadfso7934545ab.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306150; x=1712910950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YPqlqkuTn2pg1WJojCL23EOqBn84OOPX41FJDSVyTbM=;
        b=XiPuHvyAY0DkQ2Vs/6c/pMVHyni/1qRzJPtnN/KAjz/J09gtPCW4BJAQ1yZD76xxFs
         OmLcim39xUhwlei+AWTY4Vwzj43tdUmFLEScaLl5PtobIOLPGQ+V8F0YPSCNRh5k8Wlq
         s83wlGAI/ORuXEOc5TAf2bkbo8XelatyYVPXJ1RSbBVLC4gu71vp8gpeHzqEQ0b7ENJa
         IYfnquKVNG5kof+ELqcLuNww/rVRJ+UHbLHp2aDyQDf/DZ6QqW5W7gmV/d6quXBcmjXZ
         Q3M+Cn6W6xXX0a57XwKQp8k8LIbZKkKIlQuh6Eza6HUNzxWr6/lb9VYpNaYEPSThJ7uP
         Jc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306150; x=1712910950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPqlqkuTn2pg1WJojCL23EOqBn84OOPX41FJDSVyTbM=;
        b=bMhglqVlAvgUoaD93TwKNCUH15cH199p7RchQaHGwd7CVmtSn2gYzR0XoaCvng5vKO
         v3uW5Nd8k0RPAwcD7Y3BDagGrpoFAnCpbwD1dTxAjs3glwaGZFr2IZ1zYX2vlDD0m1TD
         +sovLKCJuQ62HBrvbYVNspqOscqhhQ34THLDwW4XDyITOhGF4V3knKhpw78/gLoxvxN2
         7L3EUdy4OZHbXQ8AhA8HmeOkfgy5IqEGGxP2DojvLPwcFYHi+STljl1N3wRqJBIBfYIg
         xzZUTEf5RisOEXZcLMidSrEjaExwqs0dy0AWjhPXLkQchyv4G92AZJIo0Oj0V+vxOGE3
         sA4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMdDhDuA4nVFtYcs4Qx9upTPnBqPxOjUbsOQpE68wfPR2cVjcj6FJDSwNWDlem0mrVEKTphX79Gs49ky1pI3ra090r
X-Gm-Message-State: AOJu0Yxz+xpnVxLx2cVXWG3jkm8x8L+UYdyZnPMkvwIsUB4outOHo583
	BN+Dd0Yd2gTbnCfIhPOoZdmJo5MpSetzLqAWu6RriFL/6BYSXRtT
X-Google-Smtp-Source: AGHT+IGu9g2hoAix0lmz2rgzHldnXWlhNxMvhMOMaFNnMTBrql/WlGlpqQ8pWhRscBmfK5NRh4BuGA==
X-Received: by 2002:a05:6e02:3f81:b0:368:a261:5275 with SMTP id ds1-20020a056e023f8100b00368a2615275mr864843ilb.1.1712306150363;
        Fri, 05 Apr 2024 01:35:50 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:35:50 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 00/35] migration, powerpc improvements
Date: Fri,  5 Apr 2024 18:35:01 +1000
Message-ID: <20240405083539.374995-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tree here
https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=heads

(That tree has some shellcheck patches at the end, not in this series)

Since v7, fixed a couple of Thomas' review comments. Also added
a test for PMC5 counting vs interrupts which is broken on upstream
TCG. And a small fix for SMP+MMU (secondary stack was being allocated
in discontiguous virtual memory if they were started when MMU is
enabled on the primary) discovered while I was making a test case
for TCG TLB races (not yet included in the series).
(https://lists.gnu.org/archive/html/qemu-ppc/2024-03/msg00567.html)

Thanks,
Nick

Nicholas Piggin (35):
  arch-run: Add functions to help handle migration directives from test
  arch-run: Keep infifo open
  migration: Add a migrate_skip command
  (arm|s390): Use migrate_skip in test cases
  arch-run: Add a "continuous" migration option for tests
  gitlab-ci: Run migration selftest on s390x and powerpc
  common: add memory dirtying vs migration test
  powerpc: Fix KVM caps on POWER9 hosts
  powerpc: Fix stack backtrace termination
  powerpc: interrupt stack backtracing
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
  doc: start documentation directory with unittests.cfg doc
  scripts: allow machine option to be specified in unittests.cfg
  scripts: Accommodate powerpc powernv machine differences
  powerpc: Support powernv machine with QEMU TCG
  powerpc: Fix emulator illegal instruction test for powernv
  powerpc/sprs: Test hypervisor registers on powernv machine
  powerpc: general interrupt tests
  powerpc: Add rtas stop-self support
  powerpc: Remove broken SMP exception stack setup
  powerpc: add SMP and IPI support
  powerpc: Permit ACCEL=tcg,thread=single
  powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is
    running
  powerpc: Add atomics tests
  powerpc: Add timebase tests
  powerpc: Add MMU support
  common/sieve: Use vmalloc.h for setup_mmu definition
  common/sieve: Support machines without MMU
  powerpc: Add sieve.c common test
  powerpc: add usermode support
  powerpc: add pmu tests
  configure: Make arch_libdir a first-class entity
  powerpc: Remove remnants of ppc64 directory and build structure
  powerpc: gitlab CI update

 .gitlab-ci.yml                           |  26 +-
 MAINTAINERS                              |   1 -
 Makefile                                 |   2 +-
 arm/gic.c                                |  21 +-
 arm/unittests.cfg                        |  26 +-
 common/memory-verify.c                   |  68 +++
 common/selftest-migration.c              |  26 +-
 common/sieve.c                           |  15 +-
 configure                                |  58 +-
 docs/unittests.txt                       |  95 ++++
 lib/libcflat.h                           |   2 -
 lib/migrate.c                            |  37 +-
 lib/migrate.h                            |   5 +
 lib/{ppc64 => powerpc}/asm-offsets.c     |   7 +
 lib/{ppc64 => powerpc}/asm/asm-offsets.h |   0
 lib/powerpc/asm/atomic.h                 |   6 +
 lib/powerpc/asm/barrier.h                |  12 +
 lib/{ppc64 => powerpc}/asm/bitops.h      |   4 +-
 lib/powerpc/asm/hcall.h                  |   6 +
 lib/{ppc64 => powerpc}/asm/io.h          |   4 +-
 lib/powerpc/asm/mmu.h                    |  10 +
 lib/powerpc/asm/opal.h                   |  22 +
 lib/powerpc/asm/page.h                   |  65 +++
 lib/powerpc/asm/pgtable-hwdef.h          |  66 +++
 lib/powerpc/asm/pgtable.h                | 125 +++++
 lib/powerpc/asm/processor.h              |  63 +++
 lib/{ppc64 => powerpc}/asm/ptrace.h      |  22 +-
 lib/powerpc/asm/reg.h                    |  42 ++
 lib/powerpc/asm/rtas.h                   |   2 +
 lib/powerpc/asm/setup.h                  |   3 +-
 lib/powerpc/asm/smp.h                    |  50 +-
 lib/powerpc/asm/spinlock.h               |  11 +
 lib/powerpc/asm/stack.h                  |   3 +
 lib/{ppc64 => powerpc}/asm/vpa.h         |   0
 lib/powerpc/hcall.c                      |   4 +-
 lib/powerpc/io.c                         |  41 +-
 lib/powerpc/io.h                         |   6 +
 lib/powerpc/mmu.c                        | 283 ++++++++++
 lib/powerpc/opal-calls.S                 |  50 ++
 lib/powerpc/opal.c                       |  76 +++
 lib/powerpc/processor.c                  |  91 +++-
 lib/powerpc/rtas.c                       |  81 ++-
 lib/powerpc/setup.c                      | 160 +++++-
 lib/powerpc/smp.c                        | 287 ++++++++--
 lib/powerpc/spinlock.c                   |  33 ++
 lib/powerpc/stack.c                      |  53 ++
 lib/ppc64/.gitignore                     |   1 -
 lib/ppc64/asm/barrier.h                  |   9 -
 lib/ppc64/asm/handlers.h                 |   1 -
 lib/ppc64/asm/hcall.h                    |   1 -
 lib/ppc64/asm/memory_areas.h             |   6 -
 lib/ppc64/asm/page.h                     |   1 -
 lib/ppc64/asm/ppc_asm.h                  |   1 -
 lib/ppc64/asm/processor.h                |   1 -
 lib/ppc64/asm/reg.h                      |   1 -
 lib/ppc64/asm/rtas.h                     |   1 -
 lib/ppc64/asm/setup.h                    |   1 -
 lib/ppc64/asm/smp.h                      |   1 -
 lib/ppc64/asm/spinlock.h                 |   6 -
 lib/ppc64/asm/stack.h                    |   8 -
 lib/s390x/io.c                           |   1 +
 lib/s390x/uv.h                           |   1 +
 lib/vmalloc.c                            |   7 +
 lib/vmalloc.h                            |   2 +
 lib/x86/vm.h                             |   1 +
 powerpc/Makefile                         | 111 +++-
 powerpc/Makefile.common                  |  85 ---
 powerpc/Makefile.ppc64                   |  27 -
 powerpc/atomics.c                        | 374 +++++++++++++
 powerpc/cstart64.S                       |  66 ++-
 powerpc/emulator.c                       |  16 +
 powerpc/interrupts.c                     | 516 ++++++++++++++++++
 powerpc/memory-verify.c                  |   1 +
 powerpc/pmu.c                            | 405 ++++++++++++++
 powerpc/run                              |  42 +-
 powerpc/selftest.c                       |   4 +-
 powerpc/sieve.c                          |   1 +
 powerpc/smp.c                            | 348 ++++++++++++
 powerpc/sprs.c                           | 659 ++++++++++++++++-------
 powerpc/timebase.c                       | 329 +++++++++++
 powerpc/tm.c                             |   4 +-
 powerpc/unittests.cfg                    | 101 +++-
 riscv/unittests.cfg                      |  26 +-
 s390x/Makefile                           |   1 +
 s390x/memory-verify.c                    |   1 +
 s390x/migration-cmm.c                    |   8 +-
 s390x/migration-skey.c                   |   4 +-
 s390x/migration.c                        |   1 +
 s390x/mvpg.c                             |   1 +
 s390x/selftest.c                         |   1 +
 s390x/unittests.cfg                      |  37 +-
 scripts/arch-run.bash                    | 116 +++-
 scripts/common.bash                      |   8 +-
 scripts/runtime.bash                     |  22 +-
 x86/pmu.c                                |   1 +
 x86/pmu_lbr.c                            |   1 +
 x86/unittests.cfg                        |  26 +-
 x86/vmexit.c                             |   1 +
 x86/vmware_backdoors.c                   |   1 +
 99 files changed, 4809 insertions(+), 657 deletions(-)
 create mode 100644 common/memory-verify.c
 create mode 100644 docs/unittests.txt
 rename lib/{ppc64 => powerpc}/asm-offsets.c (94%)
 rename lib/{ppc64 => powerpc}/asm/asm-offsets.h (100%)
 create mode 100644 lib/powerpc/asm/atomic.h
 create mode 100644 lib/powerpc/asm/barrier.h
 rename lib/{ppc64 => powerpc}/asm/bitops.h (69%)
 rename lib/{ppc64 => powerpc}/asm/io.h (50%)
 create mode 100644 lib/powerpc/asm/mmu.h
 create mode 100644 lib/powerpc/asm/opal.h
 create mode 100644 lib/powerpc/asm/page.h
 create mode 100644 lib/powerpc/asm/pgtable-hwdef.h
 create mode 100644 lib/powerpc/asm/pgtable.h
 rename lib/{ppc64 => powerpc}/asm/ptrace.h (59%)
 create mode 100644 lib/powerpc/asm/spinlock.h
 rename lib/{ppc64 => powerpc}/asm/vpa.h (100%)
 create mode 100644 lib/powerpc/mmu.c
 create mode 100644 lib/powerpc/opal-calls.S
 create mode 100644 lib/powerpc/opal.c
 create mode 100644 lib/powerpc/spinlock.c
 create mode 100644 lib/powerpc/stack.c
 delete mode 100644 lib/ppc64/.gitignore
 delete mode 100644 lib/ppc64/asm/barrier.h
 delete mode 100644 lib/ppc64/asm/handlers.h
 delete mode 100644 lib/ppc64/asm/hcall.h
 delete mode 100644 lib/ppc64/asm/memory_areas.h
 delete mode 100644 lib/ppc64/asm/page.h
 delete mode 100644 lib/ppc64/asm/ppc_asm.h
 delete mode 100644 lib/ppc64/asm/processor.h
 delete mode 100644 lib/ppc64/asm/reg.h
 delete mode 100644 lib/ppc64/asm/rtas.h
 delete mode 100644 lib/ppc64/asm/setup.h
 delete mode 100644 lib/ppc64/asm/smp.h
 delete mode 100644 lib/ppc64/asm/spinlock.h
 delete mode 100644 lib/ppc64/asm/stack.h
 delete mode 100644 powerpc/Makefile.common
 delete mode 100644 powerpc/Makefile.ppc64
 create mode 100644 powerpc/atomics.c
 create mode 100644 powerpc/interrupts.c
 create mode 120000 powerpc/memory-verify.c
 create mode 100644 powerpc/pmu.c
 create mode 120000 powerpc/sieve.c
 create mode 100644 powerpc/smp.c
 create mode 100644 powerpc/timebase.c
 create mode 120000 s390x/memory-verify.c

-- 
2.43.0


