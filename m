Return-Path: <kvm+bounces-12076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F0787F89C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853201F21A02
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 07:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA520537ED;
	Tue, 19 Mar 2024 07:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djK39U+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4791E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835177; cv=none; b=ffLmlAD7S1zWTA7sbhVtIuNLblnSBk9iekd3tfDlGDdE+QIRpTrsubaa9NJ0quMBS7GskslhjaoYicUIPrEd0PjqN4Pn0fGSqZd17Jye6u1tQ4ks/A/vRf6o0v9M3IT086EguzUwZ+Kr0eSanDtvUkXcqp7J+PM0p/VG1a5JQx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835177; c=relaxed/simple;
	bh=LYqlEe7KTEL9YfH1NQT246lS9Kn0hd3sQkIbCBTgYDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ByoBKNkGB44u+S99DD+eA6OOMlJJHbWNlzD5n07zuiuGjJR3tM0+3QPwCfeBXhzKrC2rHx/1gN9/Iyb2lTB8UG1lqYT/BEN4H6Mx+SJO9QXoukj56oxkIyW9V3HdVBw4/qlpTS26t4ECQMQ1TKmMhuHt+7cXmOMFLC1iG8D1v5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djK39U+S; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ca2ac094so4735281b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835175; x=1711439975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/fQl+aBLc/vpQz7SyONYn8N3lgkZT1awNMICSaZyEFc=;
        b=djK39U+SdQoqO3SfJccB7SCxFk9+L3j3sMAJ2k3oBAHOXD5V7o19WJU5Q4ILefpicd
         MdFhEMzGO0dTFlLg3rhBbtGrBZ8kBAZlNlscINAW7vswz9w0JHYfFKlEoe46pYatFazT
         g8TJdsOC230amYHNnjNFzL8xe8Eyvq2g70itlLzLwzsmcdrL7UnVMsimNVlkBM14beIV
         tIRwfZGDfeCyDGzhK+jGJliIefnHXx8UwK9ZnGDu3OkGTThUUiRVEz66boSeb3lmFpeN
         I64tNojG6eNxpWvQUM64MSOUG5rYqYAW7i9vDAU/ywxeZNr5MPbkWKFgPUpqYj3ef6yL
         UTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835175; x=1711439975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fQl+aBLc/vpQz7SyONYn8N3lgkZT1awNMICSaZyEFc=;
        b=w3QK8VEeY4HYimrpHQIWJfkRTfJbeX46/58wBbWQLK/K7DSRCVtCyeCuavkt/2CuUQ
         QW23nIHLlugaBEMeaWL8KdJmvS3VFTCGYWJSAaEt0HHXQh/RjMXyKvET4bDCriTiWY60
         PMtY4ICWLxkCdCaVEiE9JZ/3aPKrUjnDskpDDVtLodymNH0OQbYBy0WslXD54d+PtzL0
         THNGbJ6b+u1o5Mz3P+r8VvLsWhue40BRSshNT0B3D7tgMiEV6BkgX0DwXwhatsG3wszZ
         VEPp2jFdDxt3+qzACq0WM5RG+U02BcyPiI5Vg3/zuflAz7LWi5Z1Mo0MDB7DeOpNx3am
         CtOA==
X-Forwarded-Encrypted: i=1; AJvYcCV1exdv+sRtggQp/9oXR/Kkms8w1TKT8zMJzTYRMgB/0cQp6InavFFlfquNhwfTYX4i5RffuMMP3PV57tubA+JRsU7p
X-Gm-Message-State: AOJu0Yxn8m8ulHR+R10pi2cHZrfdxamjt+ql0mH+y4UecSdGVO02PbEQ
	nNmP358m0n9d+5gqHSPQuFOn3eEOyvj0j9KscobAgXaJF5yOjbl0gxy7xfhTwHA=
X-Google-Smtp-Source: AGHT+IEXcaZ+nCpbskQUwrx6BQ/MLiJbPCS2B1Ghxjxr9Qzo0j0OmbjqEbdMoyNbFA/iW3gLzs4tgg==
X-Received: by 2002:a05:6a00:1a88:b0:6e6:ce9e:fed0 with SMTP id e8-20020a056a001a8800b006e6ce9efed0mr2243761pfv.27.1710835175445;
        Tue, 19 Mar 2024 00:59:35 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:35 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 00/35] migration, powerpc improvements
Date: Tue, 19 Mar 2024 17:58:51 +1000
Message-ID: <20240319075926.2422707-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
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

Sorry I lost the v6 tag on the previous series. Since then,
I merged the series with the migration ones since they touch
the same things.

Addressed almost all comments since the last post, I think just
one case where a "elif kvm" branch was kept in the powerpc/run
script because I find it convenient to add KVM specific things
there if needed.

Main changes since v6 (thanks to reviewers):
- Rebased on new stack backtrace patches, and cherry picks
  from v6.
- Move new files to SPDX headers.
- Improve comments on and simplify interrupt stack frame and
  backtracing.
- Add a docs/ directory with unittests.cfg documentation
  deduplicated from arch code and moved there, and document
  new machine= option. Not exactly 1:1 move of comments, so
  suggestions and improvements welcome there.
- Made new shell script a bit more consistent with style. I
  do have shellcheck working and some patches started, btw.,
  will look at submitting that after this series.
- Fix up a few unittests and gitlab CI to avoid failing on the
  QEMU TCG migration bug. Reduced runtime of some of the new
  migration tests.

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
 common/memory-verify.c                   |  67 +++
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
 lib/powerpc/mmu.c                        | 274 ++++++++++
 lib/powerpc/opal-calls.S                 |  50 ++
 lib/powerpc/opal.c                       |  76 +++
 lib/powerpc/processor.c                  |  91 +++-
 lib/powerpc/rtas.c                       |  81 ++-
 lib/powerpc/setup.c                      | 159 +++++-
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
 powerpc/pmu.c                            | 336 ++++++++++++
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
 99 files changed, 4729 insertions(+), 657 deletions(-)
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
2.42.0


