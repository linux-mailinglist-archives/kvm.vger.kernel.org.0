Return-Path: <kvm+bounces-38936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2687A404DD
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D51F73B9C81
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029EA1F8EEC;
	Sat, 22 Feb 2025 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqmSnBz8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE3515689A
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188559; cv=none; b=GFwAUcg/997DapIe0zHnQ18I2h1ZYyKHJrzGYrAnu3aUel835zEDQWdEJsBZyVn/xZK4cYo5mpiC5ev+yphDqCi972d5OIo6k4D/ijQmhlPzHPy6YJVylXf/R9CmALmgKOx8oh+jtGD/Lw6UtzVFKtf6AIK7rcKV13GyF7ErArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188559; c=relaxed/simple;
	bh=D66GIq7K9wLx+9WMFretIiyOUfSdTbCQ7NEgXv9YwLs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=k2mEROjBfgw5u3Pj9nXE3pP+is+bxGtEcQ4HoB+uN3IppP8woE6weerqdZWztRKuUIy8Pti3MVeOd22aefIfchzkO9XPt4UuNvzgEtMlFxGikSLqtQ1yp+kK953gs3f7pymSQSNxu8nNfOHP0moetesGr2EA5uKsP+0wAQuPHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqmSnBz8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso8775548a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 17:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740188557; x=1740793357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMV1+v3kmLfU145KAk8LrvIrW84mgCr84o9YEajYxaI=;
        b=eqmSnBz8vROPHmmKX7rFvKgAnK0yiRls3uLdsp+Av/8a2YhJOzQyCI0Cy0YAHfrPmA
         nU5gbRhkjCWu/j6SI6nUTijlpQKraixFWvRtxZRmrv7k/HcuOHmlWzZLiblW3dz5626f
         PmuxRyECKmcJxuq/MqsBXYyLqzpwWYJqiYzm2uo/V+K26ClAUiFCp4REaD8eY4hOXiWI
         fQaBg9TARbTQtMsMtVB+3jgTgts7UxgUvQvMChG+8AU2SWlLkzRtshfcllFWGQXYYXRf
         f2dhRW1Kr/LxXkG+jF7LgRv1010WIvh+x3p1yA7Xj7V9L4YDUCpOQOBsX7AxgV68k+Mn
         g8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740188557; x=1740793357;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMV1+v3kmLfU145KAk8LrvIrW84mgCr84o9YEajYxaI=;
        b=EKymslCYnHJYDlnMmhhYsIDFRNRCf9ZIIwQ31KYbVGOk/a7kaO+2vHlszPH6/ygYoL
         hAuFA4w+Eqinfg/FN+tbfVeYo7n9jgcsQ+QAd6QkenaWwz6dZBX/On9Tr86DdY+uJ0dP
         awuk8XcM9xpzCaLPe5l1FZqjPfCQZe+dJKBAtkFvCtAHWPbu3gBx8KAv7QTODcGqznUq
         3Z//vFzpEmQqgE9eWpYFxxhlTSRrnJFMXcAX7IlUjw/2ogk3sjnU6UsvuYfvI8nUv98Q
         oyj5R+QrjWgf+v08EjH/OQ1zd0PS59GgkuBB+MDGBxi6VoBZcsfCeN/JgDvFkKs5Ta8N
         L3/Q==
X-Gm-Message-State: AOJu0Yx80yRc4cmrW5rSwXY1uhxyt/YJs8OKxA+K5pKpLSJKzIivHMO/
	kOMezVsasEtsVQHdalPzWPCw5V3umyJ32QMrFcimeuMvmMEqu9/I7/Y7LXeQmf7VKYunrhBNRMF
	18w==
X-Google-Smtp-Source: AGHT+IHBFM8YO9/o6J3at666Bwgtq1isjrRcJQckEB6S+1R/IotITRiItYVcXSjAFIpnVMW5enG2xYtWKgQ=
X-Received: from pjh15.prod.google.com ([2002:a17:90b:3f8f:b0:2fc:d276:ee01])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e44:b0:2f5:63a:44f9
 with SMTP id 98e67ed59e1d1-2fce7b0acaamr7726615a91.23.1740188556840; Fri, 21
 Feb 2025 17:42:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 17:42:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250222014232.2301713-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, new tests, and more!
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a pile of long-overdue changes.  Note, a few of the new tests
fail on AMD CPUs (LAM and  bus lock #DB).  I was hoping to get the KVM
fixes posted today, but I kept running into KUT failures (there's still
one more failure with apic-split when running on Turin with AVIC enabled,
but that one is pre-existing).

If someone wants a project, SEV-ES, SEV-SNP, and TDX support is still
awaiting review+merge.

The following changes since commit f77fb696cfd0e4a5562cdca189be557946bf522f:

  arm: pmu: Actually use counter 0 in test_event_counter_config() (2025-02-04 14:09:20 +0100)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2025.02.21

for you to fetch changes up to 8d9218bb6b7ced9e8244250b8f0d8b2090c1042a:

  x86/debug: Add a split-lock #AC / bus-lock #DB testcase (2025-02-21 17:11:29 -0800)

----------------------------------------------------------------
KVM-Unit-Tests x86 changes:

 - Expand the per-CPU data+stack area to 12KiB per CPU to reduce the
   probability of tests overflowing their stack and clobbering pre-CPU
   data.

 - Add testcases for LA57 canonical checks.

 - Add testcases for LAM.

 - Add a smoke test to make sure KVM doesn't bleed split-lock #AC/#DB into
   the guest.

 - Fix many warts and bugs in the PMU test, and prepare it for PMU version 5
   and beyond.

 - Many misc fixes and cleanups.

----------------------------------------------------------------
Aaron Lewis (1):
      x86: Increase the timeout for the test "vmx_apicv_test"

Binbin Wu (3):
      x86: Allow setting of CR3 LAM bits if LAM supported
      x86: Add test cases for LAM_{U48,U57}
      x86: Add test case for INVVPID with LAM

Dapeng Mi (17):
      x86: pmu: Remove blank line and redundant space
      x86: pmu: Refine fixed_events[] names
      x86: pmu: Align fields in pmu_counter_t to better pack the struct
      x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
      x86: pmu: Print measured event count if test fails
      x86: pmu: Fix potential out of bound access for fixed events
      x86: pmu: Fix cycles event validation failure
      x86: pmu: Use macro to replace hard-coded branches event index
      x86: pmu: Use macro to replace hard-coded ref-cycles event index
      x86: pmu: Use macro to replace hard-coded instructions event index
      x86: pmu: Enable and disable PMCs in loop() asm blob
      x86: pmu: Improve instruction and branches events verification
      x86: pmu: Improve LLC misses event verification
      x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy CPUs
      x86: pmu: Add IBPB indirect jump asm blob
      x86: pmu: Adjust lower boundary of branch-misses event
      x86: pmu: Optimize emulated instruction validation

Hang SU (1):
      x86: replace segment selector magic number with macro definition

Maxim Levitsky (6):
      pmu_lbr: drop check for MSR_LBR_TOS != 0
      x86: Add _safe() and _fep_safe() variants to segment base load instructions
      x86: Add a few functions for gdt manipulation
      x86: Move struct invpcid_desc descriptor to processor.h
      x86: Add testcases for writing (non)canonical LA57 values to MSRs and bases
      nVMX: add a test for canonical checks of various host state vmcs12 fields.

Nicolas Saenz Julienne (1):
      x86: Make set/clear_bit() atomic

Robert Hoo (1):
      x86: Add test case for LAM_SUP

Sean Christopherson (12):
      x86: Force host-phys-bits for normal maxphyaddr access tests
      nVMX: Clear A/D enable bit in EPTP after negative testcase on non-A/D host
      x86: Make per-CPU stacks page-aligned
      x86: Add a macro for the size of the per-CPU stack/data area
      x86: Increase per-CPU stack/data area to 12KiB
      x86: Expand LA57 test to 64-bit mode (to prep for canonical testing)
      x86: Drop "enabled" field from "struct kvm_vcpu_pv_apf_data"
      x86: Move descriptor table selector #defines to the top of desc.h
      x86: Commit to using __ASSEMBLER__ instead of __ASSEMBLY__
      x86: Move SMP #defines from apic-defs.h to smp.h
      x86: Include libcflat.h in atomic.h for u64 typedef
      x86/debug: Add a split-lock #AC / bus-lock #DB testcase

Xiong Zhang (1):
      x86: pmu: Remove duplicate code in pmu_init()

Zide Chen (3):
      nVMX: Account for gaps in fixed performance counters
      x86/pmu: Fixed PEBS basic record parsing issue
      x86/pmu: Execute PEBS test only if PEBSRecordFormat >= 4

 lib/x86/apic-defs.h  |   7 -
 lib/x86/apic.h       |   2 +
 lib/x86/asm/page.h   |   4 +-
 lib/x86/atomic.h     |   2 +
 lib/x86/desc.c       |  38 ++++-
 lib/x86/desc.h       | 132 ++++++++--------
 lib/x86/msr.h        |  42 +++++
 lib/x86/pmu.c        |   5 -
 lib/x86/processor.h  | 101 +++++++++++-
 lib/x86/setup.c      |   2 +-
 lib/x86/smp.c        |   2 +-
 lib/x86/smp.h        |  18 ++-
 x86/Makefile.common  |   3 +-
 x86/Makefile.i386    |   2 +-
 x86/Makefile.x86_64  |   1 +
 x86/asyncpf.c        |   1 -
 x86/cstart.S         |  11 +-
 x86/cstart64.S       |  17 ++-
 x86/debug.c          |  45 ++++++
 x86/efi/efistart64.S |   3 +-
 x86/la57.c           | 342 ++++++++++++++++++++++++++++++++++++++++-
 x86/lam.c            | 286 ++++++++++++++++++++++++++++++++++
 x86/pcid.c           |   6 -
 x86/pmu.c            | 423 +++++++++++++++++++++++++++++++++++++++++----------
 x86/pmu_lbr.c        |   1 -
 x86/pmu_pebs.c       |   6 +-
 x86/trampolines.S    |  16 +-
 x86/unittests.cfg    |  13 +-
 x86/vmx_tests.c      | 237 ++++++++++++++++++++++++++++-
 29 files changed, 1551 insertions(+), 217 deletions(-)
 create mode 100644 x86/lam.c

