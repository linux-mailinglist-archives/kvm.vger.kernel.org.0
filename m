Return-Path: <kvm+bounces-19394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F523904AC7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B369B1F21624
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FDE374E9;
	Wed, 12 Jun 2024 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eiw7gR54"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E1374C4
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169812; cv=none; b=lblD1XiJmqOuYAZaMl9iZyt5ch+EutgIizLGAzr9qqo8Z1UuXR1vck8KibF6lyrZheqQTY1vmqXeeWNj/k5WQlv9GKGPxhTre5mp2Xi7gNiBjH6g4S0+765DpRkfbBNySrcTM9yaJcg2y/5nQTecs6cy4B5p8iWOf/ZuS2vtXnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169812; c=relaxed/simple;
	bh=feSY9BewnFGp5aeHCjBQGAbaPgejrx3qUPSDPE6Vtak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VI+mzEl/3g9Yhhv1ytZ22rn/msfnoqyMQiVDREUERnGPUqR7J0oYI4IQLK5cXUW1N6KYr3kNAKFWn6NYXSCivU7tdQxtXHIoiiM7eLwheg+zkw6YQtQ8YAnNyNVftiXQFFFYxbYTg0OoCxgmaF2gvgSKdV/+G3tTH74pugt57ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eiw7gR54; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f6fd08e0f2so27014915ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169810; x=1718774610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uklboiDlNq1iAwrNweEzsuHAT7xa1yfgd/xlZey1tHA=;
        b=Eiw7gR543Q0TptWp0vGIL1/HRseOZn36AqWE0HzC67wBAnRoeIGkBj3j4R/Bf2IRFl
         aGq7Ayw9ybGVWvbCDn9mKxIgfN35ECUzu+qHHMl2sxH+GRO1NMkHhNp6xBIXQdP2RFZR
         CBiqwOv91YXbApDB8HVlOVusKL+BYn6NBDGYzmM7obG4Mb6s9H6KwfXQDyDz9YDF2ZW0
         0ak96d15Z8t9pQ6CkNPTbC2fNSfDmcaH5YeOVRzb2X5kUz+TXsStEZyg+lyCWMreypa7
         9wntn1y1rCjnrKU+2hSki0wJnSkZ+FkMsl23KY+NfoqKWAA+GUi/iCWTdOpWqsoc1W84
         JPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169810; x=1718774610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uklboiDlNq1iAwrNweEzsuHAT7xa1yfgd/xlZey1tHA=;
        b=eH7jUbPXYUp1m2+ykTnpbq4/Kx/fflSg+1wXeV2XVGR5CAfyOj8cn5nk6XKfYIHvPu
         OLCwVCiMkUMeEDtadU9o26JUirQN6cP8q7jOFtglKW2KC2bglmnuTS7kp6gLAbLbWr5i
         TyJn5z//OjBV1QkVZYgiDEfAawBhipgXNrTabjA7DIh26hZX46OWEDc0crMP1G+ZSgWL
         PLgjJLB39MxQ21feYcIuQ/b9P8jl0h5WlDk2Cz3Uo8m6FBn0ZoSv3VSqfp6AP9zApGCT
         h/zyygByX6KoXOlx2eI9+4jZMAKWHUtGFU55ycf38cCFgjN72tje/EmgfiFTnVPV+eX6
         OG8g==
X-Forwarded-Encrypted: i=1; AJvYcCWa7uz0OXOWpvfovpbZ9AmE33U5dV9aYwBhkgeqoDCuxbT2HrdDQGk3qh4SZ8ZD57HP8tywi4YL5QHT5cBY6ZaTWctU
X-Gm-Message-State: AOJu0YypRJW3Nyj08EwErlRxJZfk1hSp5Xp0fal/TgKhbB6PQ+tk0pnt
	NGvawdnwjhotQ2CalH0vssgiO1swIp8zyXMhi6LXv50jf3AIWC0F
X-Google-Smtp-Source: AGHT+IE4vm1HhOzouG/uIh/DRBNze8adNK7qarnodBymmGDRMyM7awIkvEKZM90J4HFguoStJlqvwA==
X-Received: by 2002:a17:902:dac7:b0:1f8:3d1d:b398 with SMTP id d9443c01a7336-1f83d1db6b3mr7146505ad.19.1718169810320;
        Tue, 11 Jun 2024 22:23:30 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:30 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 00/15] powerpc improvements
Date: Wed, 12 Jun 2024 15:23:05 +1000
Message-ID: <20240612052322.218726-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
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

Since v9:
- Rebase after a good chunk of patches were merged.
- Review from Thomas:
  - TCG/KVM host query is moved to the start of the series.
  - Changelog for atomics test.
  - Dropped spinlock patch change for now.
  - Fixed tlbie assembly long lines in mmu patch.
  - Use fdt64 accessor for 64-bit dt value.
  - Upgrade powerpc gitlab CI to Fedora 40 and enable more tests
  - Several other improvements.
- Reduced some long lines.
- Fixed some SPDX headers.
- New patch for adding a panic test. s390x is the only other panic
  test user but it requires KVM so I couldn't see if run_tests.sh
  looks sane there, but the harness needed a fix to work on powerpc.

Thanks,
Nick

Nicholas Piggin (15):
  powerpc: Add facility to query TCG or KVM host
  powerpc: Add atomics tests
  powerpc: Add timebase tests
  powerpc: Add MMU support
  common/sieve: Support machines without MMU
  powerpc: Add sieve.c common test
  powerpc: add usermode support
  powerpc: add pmu tests
  configure: Make arch_libdir a first-class entity
  powerpc: Remove remnants of ppc64 directory and build structure
  powerpc: gitlab CI update
  scripts/arch-run.bash: Fix run_panic() success exit status
  powerpc: Add a panic test
  powerpc/gitlab-ci: Upgrade powerpc to Fedora 40
  powerpc/gitlab-ci: Enable more tests with Fedora 40

 .gitlab-ci.yml                           |  36 +-
 MAINTAINERS                              |   1 -
 Makefile                                 |   2 +-
 common/sieve.c                           |  14 +-
 configure                                |  63 ++-
 lib/{ppc64 => powerpc}/asm-offsets.c     |   0
 lib/{ppc64 => powerpc}/asm/asm-offsets.h |   0
 lib/{ppc64 => powerpc}/asm/atomic.h      |   0
 lib/{ppc64 => powerpc}/asm/barrier.h     |   4 +-
 lib/{ppc64 => powerpc}/asm/bitops.h      |   4 +-
 lib/powerpc/asm/hcall.h                  |   6 +
 lib/{ppc64 => powerpc}/asm/io.h          |   4 +-
 lib/powerpc/asm/mmu.h                    |  86 ++++
 lib/{ppc64 => powerpc}/asm/opal.h        |   4 +-
 lib/powerpc/asm/page.h                   |  65 +++
 lib/powerpc/asm/pgtable-hwdef.h          |  66 +++
 lib/powerpc/asm/pgtable.h                | 125 +++++
 lib/powerpc/asm/processor.h              |  15 +
 lib/{ppc64 => powerpc}/asm/ptrace.h      |   6 +-
 lib/powerpc/asm/reg.h                    |  14 +
 lib/powerpc/asm/rtas.h                   |   1 +
 lib/powerpc/asm/setup.h                  |   1 +
 lib/powerpc/asm/smp.h                    |   3 +
 lib/powerpc/asm/spinlock.h               |   6 +
 lib/powerpc/asm/stack.h                  |   3 +
 lib/{ppc64 => powerpc}/asm/vpa.h         |   0
 lib/powerpc/io.c                         |   7 +
 lib/powerpc/mmu.c                        | 260 +++++++++++
 lib/{ppc64 => powerpc}/opal-calls.S      |   4 +-
 lib/{ppc64 => powerpc}/opal.c            |   0
 lib/powerpc/processor.c                  |  47 ++
 lib/powerpc/rtas.c                       |  19 +
 lib/powerpc/setup.c                      |  61 ++-
 lib/{ppc64 => powerpc}/stack.c           |   0
 lib/ppc64/.gitignore                     |   1 -
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
 lib/vmalloc.c                            |   7 +
 lib/vmalloc.h                            |   2 +
 powerpc/Makefile                         | 111 ++++-
 powerpc/Makefile.common                  |  89 ----
 powerpc/Makefile.ppc64                   |  30 --
 powerpc/atomics.c                        | 386 ++++++++++++++++
 powerpc/interrupts.c                     | 129 +++++-
 powerpc/mmu.c                            | 225 +++++++++
 powerpc/pmu.c                            | 562 +++++++++++++++++++++++
 powerpc/run                              |   2 +-
 powerpc/selftest.c                       |  18 +-
 powerpc/sieve.c                          |   1 +
 powerpc/sprs.c                           |   2 +-
 powerpc/timebase.c                       | 350 ++++++++++++++
 powerpc/tm.c                             |   2 +-
 powerpc/unittests.cfg                    |  64 ++-
 scripts/arch-run.bash                    |   1 +
 64 files changed, 2696 insertions(+), 245 deletions(-)
 rename lib/{ppc64 => powerpc}/asm-offsets.c (100%)
 rename lib/{ppc64 => powerpc}/asm/asm-offsets.h (100%)
 rename lib/{ppc64 => powerpc}/asm/atomic.h (100%)
 rename lib/{ppc64 => powerpc}/asm/barrier.h (83%)
 rename lib/{ppc64 => powerpc}/asm/bitops.h (69%)
 rename lib/{ppc64 => powerpc}/asm/io.h (50%)
 create mode 100644 lib/powerpc/asm/mmu.h
 rename lib/{ppc64 => powerpc}/asm/opal.h (90%)
 create mode 100644 lib/powerpc/asm/page.h
 create mode 100644 lib/powerpc/asm/pgtable-hwdef.h
 create mode 100644 lib/powerpc/asm/pgtable.h
 rename lib/{ppc64 => powerpc}/asm/ptrace.h (89%)
 create mode 100644 lib/powerpc/asm/spinlock.h
 rename lib/{ppc64 => powerpc}/asm/vpa.h (100%)
 create mode 100644 lib/powerpc/mmu.c
 rename lib/{ppc64 => powerpc}/opal-calls.S (88%)
 rename lib/{ppc64 => powerpc}/opal.c (100%)
 rename lib/{ppc64 => powerpc}/stack.c (100%)
 delete mode 100644 lib/ppc64/.gitignore
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
 create mode 100644 powerpc/mmu.c
 create mode 100644 powerpc/pmu.c
 create mode 120000 powerpc/sieve.c
 create mode 100644 powerpc/timebase.c

-- 
2.45.1


