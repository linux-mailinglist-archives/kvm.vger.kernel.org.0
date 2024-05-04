Return-Path: <kvm+bounces-16563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 145E78BBB34
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 878291F22054
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AAE224CC;
	Sat,  4 May 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lG65v2CN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7178210E6
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825734; cv=none; b=ngJtDL/nTJE6Gq/4/tYS2Ol7eR0euV+jO1QEWmLHu/zxU9GK7KfN/1Cj07JqM/wpfkiNNIEjBTq1rW5epbQbZsEel+WI7gkrDF53vZQz15AaYezidmji5K+ia5i34aiXeSt13Jefvgs560MyPK0wnFr0QribJfumZSkOFwlUmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825734; c=relaxed/simple;
	bh=RWioFPA0z6is0jMUIOzFxMRmKUdm1jk19zwxmmF3Xxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Dofr7zflB9TRDQRm4wB62XCAcdiFKIlMu2XjhVesmQeY/p+uNUgmxe3MO/x/l70yCNuvXMej1rAjvyVFgqgG75yOciGtUvROlDp22yGVZX0vzqP70yWUAWV65txFsoD5X0ZZlimnG33ZoT/JDGWl3b+KMAnBkb3MmRXKjOcsqYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lG65v2CN; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ff57410ebbso378938a12.1
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825732; x=1715430532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xn4ezSDHOhf2aKKwmztM6YSNcy7Szv8mxSVuwHNvyBM=;
        b=lG65v2CNPfqHdXzowRwszGN/Th/wISL4m1CS8aeud/PZR/9wA05+asHh0d6JPERCt/
         KunUso5Ndd8jcDYQLQEnpkuiPnb+AFZHJvXYz+Zi3o1RWUk/ls1FWQ3sS4sJVSqznRKq
         HuwIVbRJkD1vcV4K5LAjlIAcQEylXS6LGLvndfOOJxtTMLlEn/pRjcG5UWlilIBB4X0t
         7FwuYQGkORzSWV/ULIEN+6DbJo6nE0DvWOVoS5FW/Ja9MGCrd+dR5QdpBEtCOjFoG+lo
         7dF9x9dxfhpM0yfLQZIZQdWSqtpzbdPEGiwVP+fuendT3kjN7Rt9J9UahalZx2qRee+a
         KELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825732; x=1715430532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xn4ezSDHOhf2aKKwmztM6YSNcy7Szv8mxSVuwHNvyBM=;
        b=PZa9pJWEyd5qNV/70QMvzCJTNemL+bQTXxLKmh3Xb+lDLBWVhBc+DFvXDQTU0iXHiT
         dQo4+/KkHowq3rP5NeNIwNi5BMl1ou8UvuVfkCy+VESc5bhYbUdoEKKCTJ+gZ2cmcLZY
         5JdiU0bKBPeR0NCeNVU1+YIR4bxDdwVY9qTF17TchbGyl69B9Tx5OaXYosN8XpPwaxA8
         sZMcd7K2/usySZSJv84aMltD7cJSsvcW7xlYnwMG7LPwp81I3obslt+ys30N4U/1VhAk
         fpM6fFBP0FYKPxHudMByLXqxWxZshy0mhGPDBECdqIascaM9PELQAISj3O1gZgyQprsy
         4LPg==
X-Forwarded-Encrypted: i=1; AJvYcCXcG6jhBHc8zfjP/OdiQazFHkYmyiD+v1tMufb2mBHRKLj3kA6EjHpmi74hU+k3Wczc3BpEmQLoipUMOZSqrXqdkXFv
X-Gm-Message-State: AOJu0YySyFTehdjm4mgGb65rghV/dijb2/rgMwraq1RrvN7/SmJXE5Bs
	tS2wMTJFZw9x03uhJ2u4mIvEMzjmBtjJMeKqkJqw+d2CxzjvVGE7
X-Google-Smtp-Source: AGHT+IHOGS20krAYeoChwowN/g0FbyyWv1HZoAqitITYc/rRqsePtmaLqQPRQrtNOSXgpxA1QWAijw==
X-Received: by 2002:a05:6a20:7f96:b0:1a9:b2ee:5f72 with SMTP id d22-20020a056a207f9600b001a9b2ee5f72mr6224148pzj.36.1714825731750;
        Sat, 04 May 2024 05:28:51 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:28:51 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 00/31] powerpc improvements
Date: Sat,  4 May 2024 22:28:06 +1000
Message-ID: <20240504122841.1177683-1-npiggin@gmail.com>
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
https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc

Since v8:
- Migration improvements merged and out of series.
- Rebased on upstream.
- Did some more splitting of patches to make review easier.
- Added a new kfail option for known failures because I add a bunch
  and I don't want to remove them but also don't want them to report
  as failing the test (at least until implementations can be improved).
- Added MMU tlb invalidation tests that trigger upstream QEMU bug.
- Added tcg/kvm host detection to help known-failure reporting.
- Fixed a few fails and marked a lot of known fails.

Thanks,
Nick

Nicholas Piggin (31):
  doc: update unittests doc
  report: Add known failure reporting option
  powerpc: Mark known failing tests as kfail
  powerpc: Update unittests for latest QEMU version
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
  scripts: allow machine option to be specified in unittests.cfg
  scripts: Accommodate powerpc powernv machine differences
  powerpc: Support powernv machine with QEMU TCG
  powerpc: Fix emulator illegal instruction test for powernv
  powerpc/sprs: Test hypervisor registers on powernv machine
  powerpc: general interrupt tests
  powerpc: Add rtas stop-self support
  powerpc: Remove broken SMP exception stack setup
  powerpc: Enable page alloc operations
  powerpc: add SMP and IPI support
  powerpc: Add cpu_relax
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
  powerpc: Add facility to query TCG or KVM host
  powerpc: gitlab CI update

 .gitlab-ci.yml                           |  30 +-
 MAINTAINERS                              |   1 -
 Makefile                                 |   2 +-
 common/sieve.c                           |  15 +-
 configure                                |  58 +-
 docs/unittests.txt                       |  19 +-
 lib/libcflat.h                           |   4 +-
 lib/{ppc64 => powerpc}/asm-offsets.c     |   9 +
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
 lib/powerpc/asm/processor.h              |  66 +++
 lib/{ppc64 => powerpc}/asm/ptrace.h      |  22 +-
 lib/powerpc/asm/reg.h                    |  42 ++
 lib/powerpc/asm/rtas.h                   |   2 +
 lib/powerpc/asm/setup.h                  |   3 +-
 lib/powerpc/asm/smp.h                    |  48 +-
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
 lib/powerpc/setup.c                      | 192 ++++++-
 lib/powerpc/smp.c                        | 342 ++++++++++--
 lib/powerpc/spinlock.c                   |  33 ++
 lib/{ppc64 => powerpc}/stack.c           |   0
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
 lib/ppc64/asm/stack.h                    |  11 -
 lib/report.c                             |  33 +-
 lib/s390x/io.c                           |   1 +
 lib/s390x/uv.h                           |   1 +
 lib/vmalloc.c                            |   7 +
 lib/vmalloc.h                            |   2 +
 lib/x86/vm.h                             |   1 +
 powerpc/Makefile                         | 112 +++-
 powerpc/Makefile.common                  |  86 ---
 powerpc/Makefile.ppc64                   |  28 -
 powerpc/atomics.c                        | 375 +++++++++++++
 powerpc/cstart64.S                       |  57 +-
 powerpc/emulator.c                       |  16 +
 powerpc/interrupts.c                     | 518 ++++++++++++++++++
 powerpc/mmu.c                            | 283 ++++++++++
 powerpc/pmu.c                            | 403 ++++++++++++++
 powerpc/run                              |  44 +-
 powerpc/selftest.c                       |   4 +-
 powerpc/sieve.c                          |   1 +
 powerpc/smp.c                            | 348 ++++++++++++
 powerpc/spapr_vpa.c                      |   3 +-
 powerpc/sprs.c                           | 662 ++++++++++++++++-------
 powerpc/timebase.c                       | 331 ++++++++++++
 powerpc/tm.c                             |   6 +-
 powerpc/unittests.cfg                    |  88 ++-
 s390x/mvpg.c                             |   1 +
 s390x/selftest.c                         |   1 +
 scripts/common.bash                      |   8 +-
 scripts/runtime.bash                     |  22 +-
 x86/pmu.c                                |   1 +
 x86/pmu_lbr.c                            |   1 +
 x86/vmexit.c                             |   1 +
 x86/vmware_backdoors.c                   |   1 +
 86 files changed, 4798 insertions(+), 544 deletions(-)
 rename lib/{ppc64 => powerpc}/asm-offsets.c (91%)
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
 rename lib/{ppc64 => powerpc}/stack.c (100%)
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
 create mode 100644 powerpc/mmu.c
 create mode 100644 powerpc/pmu.c
 create mode 120000 powerpc/sieve.c
 create mode 100644 powerpc/smp.c
 create mode 100644 powerpc/timebase.c

-- 
2.43.0


