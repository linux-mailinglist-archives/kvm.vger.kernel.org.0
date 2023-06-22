Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7679D73AB53
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjFVVOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 17:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjFVVOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 17:14:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9FC19AB
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:14:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56cf9a86277so88516637b3.3
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687468483; x=1690060483;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqUulwFndrSd4Z5q05A624q3pqI8UuERYAHN9/eTEII=;
        b=33zr6TGeQavSRT1WuiIzJ4fhf2pI+8pC3cpXhuJwcjWI2WIk+9czdmtc+rXTkB3s7j
         Qh2E87+dLZdpUYrVx4IlGmxLFaVAwFLM1ZyHLlM8BSjgjZ+5L5AqLDxYs0JesCtpajtf
         cLISB/c4THSZ0KKSz89KArwWQuzUrCXXt8DJYum/5vueZYQaKywnu2K3kew0loFm88TA
         lUwWfV+U2ydyZbWfy/jhfaMZEZMnvrx7IuSrk+x7FtrpL7ORx0tw0VniSZJO1T2hEK0T
         GJF5a8/N2e+FYcNksKCXy1CILhSZLZo9zh+mdbSXwstnFi3s05NpdMnEWkm4Ix3tOkBB
         SWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687468483; x=1690060483;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqUulwFndrSd4Z5q05A624q3pqI8UuERYAHN9/eTEII=;
        b=cDCwleMBPDZImBzAcefApcwO9lt/RkQKDdDbyJxWnxX9DcKvGid8iGcbwe4KsOVzZZ
         vXrkRMnkekhnhomAAkpbYh9MNU5kqQYXKzhxKbFTCr2kKHSUU6LyD1NXdjVv34/hyN2V
         Ju0RWmXjHEgkwlnPjxegy3iNT1PVU8RVSJb81ROBVFnG0z6jRrgQ+R4Io+RLfblrTP4R
         mhUuB+rwTetW1Qpm2S4El/ywThtD4qHkICI5C94d1VkyulUg31MjmJjqMSXfcq+s8oTm
         PuRhTmSmIhZPAxL6SyxBcplvJlEHsCs7IlVmzUrKwsyApe/v4fYHVa9s+f6h0DFM2VDx
         gMMQ==
X-Gm-Message-State: AC+VfDzyJ62EXfRPJ1zDlNufcYDa2PmfVJfoXrd0El2Q3ucu2/GLqker
        JQpufs1NrhQHBxJjZwz3CgT6dA1EfpE=
X-Google-Smtp-Source: ACHHUZ4/GDc/ab+X+y3D/CYeCzXwd1oDZnX/VCGgCf2my+uzyj9kiMr//KAYWuuDCQz3CPYg8DsPAd/957U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ef0e:0:b0:56f:e7d7:911e with SMTP id
 o14-20020a81ef0e000000b0056fe7d7911emr7333001ywm.4.1687468483726; Thu, 22 Jun
 2023 14:14:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 22 Jun 2023 14:14:40 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230622211440.2595272-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull a variety of (mostly) x86 changes.  There's one non-x86 change to
fix a bug in processing "check" entries in unittests.cfg files.  The majority
of the x86 changes revolve around nSVM, PMU, and emulator tests.

The following changes since commit 02d8befe99f8205d4caea402d8b0800354255681:

  pretty_print_stacks: modify relative path calculation (2023-04-20 10:26:06 +0200)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.06.22

for you to fetch changes up to e3a9b2f5490e854dfcccdde4bcc712fe928b02b4:

  x86/emulator64: Test non-canonical memory access exceptions (2023-06-12 11:06:19 -0700)

----------------------------------------------------------------
x86 fixes, cleanups, and new testcases, and a few generic changes

 - Fix a bug in runtime.bash that caused it to mishandle "check" strings with
   multiple entries, e.g. a test that depends on multiple module params
 - Make the PMU tests depend on vPMU support being enabled in KVM
 - Fix PMU's forced emulation test on CPUs with full-width writes
 - Add a PMU testcase for measuring TSX transactional cycles
 - Nested SVM testcase for virtual NMIs
 - Fix linker warnings about an executable stack
 - Move a pile of code to ASM_TRY() and "safe" helpers
 - Set up the guest stack in the LBRV tests so that the tests don't fail if the
   compiler decides to generate function calls in guest code
 - Ignore the "mispredict" flag in nSVM's LBRV tests to fix false failures
 - Clean up usage of helpers that disable interrupts, e.g. stop inserting
   unnecessary nops
 - Add helpers to dedup code for programming the APIC timer

----------------------------------------------------------------
Like Xu (2):
      x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
      x86/pmu: Wrap the written counter value with gp_counter_width

Mathias Krause (15):
      x86: Drop types.h
      x86: Use symbolic names in exception_mnemonic()
      x86: Add vendor specific exception vectors
      x86/cet: Use symbolic name for #CP
      x86/access: Use 'bool' type as defined via libcflat.h
      x86/run_in_user: Preserve exception handler
      x86/run_in_user: Relax register constraints of inline asm
      x86/run_in_user: Reload SS after successful return
      x86/fault_test: Preserve exception handler
      x86/emulator64: Relax register constraints for usr_gs_mov()
      x86/emulator64: Switch test_sreg() to ASM_TRY()
      x86/emulator64: Add non-null selector test
      x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
      x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
      x86/emulator64: Test non-canonical memory access exceptions

Maxim Levitsky (8):
      x86: replace irq_{enable|disable}() with sti()/cli()
      x86: introduce sti_nop() and sti_nop_cli()
      x86: add few helper functions for apic local timer
      x86: nSVM: Remove nop after stgi/clgi
      x86: nSVM: make svm_intr_intercept_mix_if/gif test a bit more robust
      x86: nSVM: use apic_start_timer/apic_stop_timer instead of open coding it
      x86: nSVM: Add nested shutdown interception test
      x86: nSVM: Remove defunct get_npt_pte() declaration

Santosh Shukla (1):
      x86: nSVM: Add support for VNMI test

Sean Christopherson (15):
      nSVM: Add helper to report fatal errors in guest
      x86: Link with "-z noexecstack" to suppress irrelevant linker warnings
      x86: Add macros to wrap ASM_TRY() for single instructions
      x86: Convert inputs-only "safe" instruction helpers to asm_safe()
      x86: Add macros to wrap ASM_TRY() for single instructions with output(s)
      x86: Move invpcid_safe() to processor.h and convert to asm_safe()
      x86: Move XSETBV and XGETBV "safe" helpers to processor.h
      x86: nSVM: Set up a guest stack in LBRV tests
      lib: Expose a subset of VMX's assertion macros
      x86: Add defines for the various LBR record bit definitions
      x86: nSVM: Ignore mispredict bit in LBR records
      x86: nSVM: Replace check_dbgctl() with TEST_EXPECT_EQ() in LBRV test
      x86: nSVM: Print out RIP and LBRs from VMCB if LBRV guest test fails
      runtime: Convert "check" from string to array so that iterating works
      x86/pmu: Make PMU testcases dependent on vPMU being enabled in KVM

 lib/util.h                |  31 ++++
 lib/x86/apic.c            |  38 ++++
 lib/x86/apic.h            |   6 +
 lib/x86/desc.c            |  43 +++--
 lib/x86/desc.h            |  48 ++++++
 lib/x86/fault_test.c      |   4 +-
 lib/x86/msr.h             |  11 ++
 lib/x86/processor.h       | 137 +++++++++------
 lib/x86/smp.c             |   2 +-
 lib/x86/usermode.c        |  38 ++--
 scripts/runtime.bash      |   1 +
 x86/Makefile.common       |   2 +-
 x86/access.c              |  11 +-
 x86/apic.c                |   6 +-
 x86/asyncpf.c             |   6 +-
 x86/cet.c                 |   2 +-
 x86/cmpxchg8b.c           |   1 -
 x86/emulator.c            |   1 -
 x86/emulator64.c          | 105 +++++++-----
 x86/eventinj.c            |  22 +--
 x86/hyperv_connections.c  |   2 +-
 x86/hyperv_stimer.c       |   4 +-
 x86/hyperv_synic.c        |   6 +-
 x86/intel-iommu.c         |   2 +-
 x86/ioapic.c              |  15 +-
 x86/memory.c              |  60 ++-----
 x86/pcid.c                |   8 -
 x86/pmu.c                 |  52 +++++-
 x86/pmu_pebs.c            |   1 -
 x86/svm.c                 |  17 +-
 x86/svm.h                 |  11 +-
 x86/svm_tests.c           | 429 +++++++++++++++++++++++-----------------------
 x86/taskswitch2.c         |   4 +-
 x86/tscdeadline_latency.c |   4 +-
 x86/types.h               |  21 ---
 x86/unittests.cfg         |   7 +-
 x86/vmexit.c              |  18 +-
 x86/vmx.h                 |  32 +---
 x86/vmx_tests.c           |  48 ++----
 x86/xsave.c               |  31 +---
 40 files changed, 709 insertions(+), 578 deletions(-)
 delete mode 100644 x86/types.h
