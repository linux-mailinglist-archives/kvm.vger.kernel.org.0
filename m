Return-Path: <kvm+bounces-9804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3C08670D0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F2CE2893E4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424BF59B78;
	Mon, 26 Feb 2024 10:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHSpYeWd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C532163B
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942355; cv=none; b=l3Le+zerHK86on2MKhdy7wsILcrmRyzKn3JYlBCTYurlyP1rnGQeKUFtj0eLbor9FbZ0XmwFO87ZKxnmOMwwsTmv3UbY2ICK48tXo3KmNhIY1oyGkJiK8HSe7MaarWVOQ3qgiP+V8QRAoQIWRIEtZ5xM7t20SQz5Txyf60rod2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942355; c=relaxed/simple;
	bh=CfU8H4BM/A4o0/QQDhNVAIrZY9EyGzTNl/wydxPS+JM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IENsqHD3V8mV1clWtBrOAnqCeCHnFJLEEt5Kbmg1jBtgo1upai/PmQ+cKZFIii5QGxUw3ULg9jjOamWtR90WB1aFXQbbK74DmDWPkdbYoSqciw5Vw7Bk75OXXYZOTCdrL4i6iRu+Li6vURMHD4zLKAgJ/so9WTtH1Z2hh7FTxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHSpYeWd; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e47a104c2eso1453600b3a.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942353; x=1709547153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie2Etjd7dE2vfu3S+YH57fBhtjZAbWZwCY8cyQZx5Zo=;
        b=RHSpYeWdQbWFhF0ZMD213QsbkThLLD/d3I62Gthm6CFAvZATg6zq71NucOA3UKZviR
         yrMR/5cB8TCyRaECd0qPYp/Fwi5nL9NWmQFfkJi9H8kuxZRVSWN3W0yELIQo30t11JMd
         5w89Wh+HSmXZlub5HpXju9XHUbWWuN1tdGYnzFNh04yUZB9kGkyAUaO1+cfCwA60H43I
         f93lX77iQl//9d1JpXq017XdTSdYC0npi+4aciyqPUUGo3ZSxCVHMFdkhwLUOjvSRx8/
         f72amjH8/BEZOW0yRDE201uMUQCqVtkjjr9UOQnL/WZQS1eS8dSZ5T2SyWO35Gm5CBP+
         mfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942353; x=1709547153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ie2Etjd7dE2vfu3S+YH57fBhtjZAbWZwCY8cyQZx5Zo=;
        b=dmM5QH5AerULYTAKoqYKl3oCWOYKXDhZr3M151j+EVBRjtGvPqeVA5FvAgbALxAVoK
         OXlp+TNC1OZocykPhgDcdLJl4RRU4oTO+Hp9pL2PPEqV0vV7Wtz7ZWfwo3NZhdZUYQ2A
         5iaOoj8Z9cYTiBOkXJixxZ18mq9iCqPvXou47SSMpQa164Uo0lPmYmA5hZppcSxQjGnt
         zz1zEKtoR05BLyVRP4ghUP7ZerBOiKvk8TfGTutJw3LAWJJYCk2De0nC58PvypINMXTb
         84Jdvqa6r+fP1E9F1cCZ+vRexWfaOxmeWSJNOH6WOtujkXfGeLDk6C0GSgDfz/1hyyNG
         XEMA==
X-Forwarded-Encrypted: i=1; AJvYcCXynfNW0iRjOUkijzM1YaHbJeO8y+s++ldVEPDODEJyv30Yomyl9Ynr5ZYrd1IqOuW4u/0QiKbuhHHRbuSgEDk5wFPJ
X-Gm-Message-State: AOJu0YwyeLRmQFfJy7Y4V13HAkTbJRfB3Y3rIqWUFnAwyRGTqvnikCDE
	03dBPy3aFZCVM/uIsG4uw7hlmP1KiAJyvEFJA2/yZ9bZRGLU16vr
X-Google-Smtp-Source: AGHT+IE2nREndiF3/AYSv1IZTEefq/2XruzcQuQCiLQzYauQkoJx/7rtnZR4InanWf5JypfNBA8n1Q==
X-Received: by 2002:a05:6a00:320b:b0:6e4:f12c:c43e with SMTP id bm11-20020a056a00320b00b006e4f12cc43emr5102422pfb.24.1708942352959;
        Mon, 26 Feb 2024 02:12:32 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:32 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 00/32] powerpc improvements
Date: Mon, 26 Feb 2024 20:11:46 +1000
Message-ID: <20240226101218.1472843-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the same familiar set of powerpc patches, it's taken a
while to get them merged. And unfortunately they keep growing
with fixes and new tests.

This goes on top of the previous migration and other core
patches. Full tree can be found here.

https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=heads

I have tried to test all combinations of KVM and TCG for P8/9/10
and powernv. There are a small number of failures, some due to
bugs in TCG, QEMU, and KVM. I don't want to drop such test cases
but xfail doesn't quite work because it will start failing if we
fix implementation to now work AFAIKS. If there is concern about
that, then maybe we could add a known-failure type of report that
can document the reason and not fail the entire group of tests.

Since last posting, this adds several fixes to the start of the
series, fixes a bunch of bugs in the SPRs and other tests that
Joel and Thomas raised.  Tidied up the new new SMP support and
fixed a couple of issues there. Added MMU, usermode support,
add atomics, timebase, PMU tests, and removes the ppc64
subdirectories.

Thanks,
Nick

Nicholas Piggin (32):
  powerpc: Fix KVM caps on POWER9 hosts
  powerpc: Fix pseries getchar return value
  powerpc: Fix stack backtrace termination
  powerpc: interrupt stack backtracing
  powerpc: Cleanup SPR and MSR definitions
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/sprs: Don't fail changed SPRs that are used by the test
    harness
  powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
  scripts: allow machine option to be specified in unittests.cfg
  scripts: Accommodate powerpc powernv machine differences
  powerpc: Support powernv machine with QEMU TCG
  powerpc: Fix emulator illegal instruction test for powernv
  powerpc/sprs: Test hypervisor registers on powernv machine
  powerpc: general interrupt tests
  powerpc: Add rtas stop-self support
  powerpc: Remove broken SMP exception stack setup
  arch-run: Fix handling multiple exit status messages
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
  configure: Fail on unknown arch
  configure: Make arch_libdir a first-class entity
  powerpc: Remove remnants of ppc64 directory and build structure
  powerpc: gitlab CI update

 .gitlab-ci.yml                           |  16 +-
 MAINTAINERS                              |   1 -
 Makefile                                 |   2 +-
 common/sieve.c                           |  15 +-
 configure                                |  69 ++-
 lib/libcflat.h                           |   2 -
 lib/{ppc64 => powerpc}/asm-offsets.c     |   7 +
 lib/{ppc64 => powerpc}/asm/asm-offsets.h |   0
 lib/powerpc/asm/atomic.h                 |   6 +
 lib/powerpc/asm/barrier.h                |  12 +
 lib/{ppc64 => powerpc}/asm/bitops.h      |   4 +-
 lib/powerpc/asm/hcall.h                  |   6 +
 lib/{ppc64 => powerpc}/asm/io.h          |   4 +-
 lib/powerpc/asm/mmu.h                    |  10 +
 lib/powerpc/asm/opal.h                   |  22 +
 lib/powerpc/asm/page.h                   |  66 +++
 lib/powerpc/asm/pgtable-hwdef.h          |  67 +++
 lib/powerpc/asm/pgtable.h                | 126 +++++
 lib/powerpc/asm/ppc_asm.h                |   8 +-
 lib/powerpc/asm/processor.h              |  68 ++-
 lib/{ppc64 => powerpc}/asm/ptrace.h      |  22 +-
 lib/powerpc/asm/reg.h                    |  72 +++
 lib/powerpc/asm/rtas.h                   |   2 +
 lib/powerpc/asm/setup.h                  |   3 +-
 lib/powerpc/asm/smp.h                    |  50 +-
 lib/powerpc/asm/spinlock.h               |  11 +
 lib/powerpc/asm/stack.h                  |   3 +
 lib/powerpc/asm/time.h                   |   1 +
 lib/{ppc64 => powerpc}/asm/vpa.h         |   0
 lib/powerpc/hcall.c                      |   6 +-
 lib/powerpc/io.c                         |  41 +-
 lib/powerpc/io.h                         |   6 +
 lib/powerpc/mmu.c                        | 275 +++++++++
 lib/powerpc/opal-calls.S                 |  50 ++
 lib/powerpc/opal.c                       |  76 +++
 lib/powerpc/processor.c                  |  91 ++-
 lib/powerpc/rtas.c                       |  81 ++-
 lib/powerpc/setup.c                      | 159 +++++-
 lib/powerpc/smp.c                        | 287 ++++++++--
 lib/powerpc/spinlock.c                   |  32 ++
 lib/powerpc/stack.c                      |  55 ++
 lib/ppc64/.gitignore                     |   1 -
 lib/ppc64/asm/barrier.h                  |   9 -
 lib/ppc64/asm/handlers.h                 |   1 -
 lib/ppc64/asm/hcall.h                    |   1 -
 lib/ppc64/asm/memory_areas.h             |   6 -
 lib/ppc64/asm/page.h                     |   1 -
 lib/ppc64/asm/ppc_asm.h                  |   1 -
 lib/ppc64/asm/processor.h                |   1 -
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
 powerpc/Makefile.common                  |  86 ---
 powerpc/Makefile.ppc64                   |  27 -
 powerpc/atomics.c                        | 373 +++++++++++++
 powerpc/cstart64.S                       |  78 ++-
 powerpc/emulator.c                       |  21 +-
 powerpc/interrupts.c                     | 517 +++++++++++++++++
 powerpc/pmu.c                            | 337 +++++++++++
 powerpc/run                              |  42 +-
 powerpc/selftest.c                       |   4 +-
 powerpc/sieve.c                          |   1 +
 powerpc/smp.c                            | 349 ++++++++++++
 powerpc/sprs.c                           | 678 ++++++++++++++++-------
 powerpc/timebase.c                       | 330 +++++++++++
 powerpc/tm.c                             |   4 +-
 powerpc/unittests.cfg                    |  63 ++-
 s390x/mvpg.c                             |   1 +
 s390x/selftest.c                         |   1 +
 scripts/arch-run.bash                    |   2 +-
 scripts/common.bash                      |   8 +-
 scripts/runtime.bash                     |  20 +-
 x86/pmu.c                                |   1 +
 x86/pmu_lbr.c                            |   1 +
 x86/vmexit.c                             |   1 +
 x86/vmware_backdoors.c                   |   1 +
 84 files changed, 4400 insertions(+), 541 deletions(-)
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
 create mode 100644 lib/powerpc/asm/reg.h
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
 delete mode 100644 lib/ppc64/asm/rtas.h
 delete mode 100644 lib/ppc64/asm/setup.h
 delete mode 100644 lib/ppc64/asm/smp.h
 delete mode 100644 lib/ppc64/asm/spinlock.h
 delete mode 100644 lib/ppc64/asm/stack.h
 delete mode 100644 powerpc/Makefile.common
 delete mode 100644 powerpc/Makefile.ppc64
 create mode 100644 powerpc/atomics.c
 create mode 100644 powerpc/interrupts.c
 create mode 100644 powerpc/pmu.c
 create mode 120000 powerpc/sieve.c
 create mode 100644 powerpc/smp.c
 create mode 100644 powerpc/timebase.c

-- 
2.42.0


