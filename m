Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30BC7903F0
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 01:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349105AbjIAXNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245077AbjIAXNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 19:13:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E7E56
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 16:13:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5958487ca15so28043257b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 16:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693610013; x=1694214813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgOA6nI78h6x0gLSoP2ActOqqv3p3SoTAGbmddaogrQ=;
        b=BmtmhqF9s873W1Q9GFTkKrTSVYNnq3Vu52UZe8wlEl1Cs/XzaRd74P8qCvY8tWgcwd
         /HNqEgMnYtFbD5kNk0WAVzitcdNcwhQuEVc902pVe2JEqGNG0vq3feGKq6Y8MTTVdmp1
         tnNfNmvpmLkZuzY9ME/aziBVgCokDLNG0LZ4Mdx+P6yRQQpzzFlrdoqXvmyGap2GzM8w
         UyzjVUV6Ipbdk8g3pJ7gs17hwRetxIs+mMecKtaSWvOxZ7CLHZLK9f3JLywIrarbJ0wg
         63n5TZZgl+6CwU0SFkRGOrgIkn8XD5gasqub8V1PWMs6/lZKLfVI9VnLgHhr/yXsCPtt
         pscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693610013; x=1694214813;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgOA6nI78h6x0gLSoP2ActOqqv3p3SoTAGbmddaogrQ=;
        b=bU8m4uMzXqw2zhHzunDKPrCSkv/R5IDRMiGr34truF2PM+ILS6+amrkwJ9nl1XBVWL
         kBREIIfRYJPaaFYwQ1DjoivcHz4z6cBYd+zz2lYa62qSNXfFowBsli8nm8C8NckNZ9OG
         /VIjC2dAS9VwbLLmn0Tzb2yQq1iV1HLcD0mC+V7NSV2hkBBi96BF2+1dgIeNNcXUMyuK
         8xsQ2pjzwfT37LIXvnIb7jiCn07zLFMk2uDnYcG1nO/TKVLF2jZIG6Bu7RlklhzMRCV/
         NWhCWZg/RoHqr5Vu9a3loT2i/VEcaLSp3U9eUEwt1+XB5k8bdDbpFG5N8QHcuvIjNs1T
         Jrmg==
X-Gm-Message-State: AOJu0Ywtp+ITsWhnJvG6vEIOxF5Kzj9NuReUC+Yb5alB0KQXOpANdK0O
        KtyugLeidFJE69XfFUgrDm7JJZ1ivd0=
X-Google-Smtp-Source: AGHT+IEH57zYI+2x0uQdDA1AY/LCGc0kJi/4ZEW9icBgeiMQqWS7bJMg8nrUj7oLW60JpLR1+kJOcWGxQ/g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ec49:0:b0:576:cd91:b888 with SMTP id
 r9-20020a0dec49000000b00576cd91b888mr105852ywn.0.1693610013304; Fri, 01 Sep
 2023 16:13:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 16:13:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901231330.3608891-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is essentially v2 of the previous attempt[*], sans the fix for exectuable
stack warnings (now fixed for all architectures), plus fixes for nVMX testcases
related to 64-bit hosts (these *just* got posted, but it's not like anyone else
is reviewing KUT x86 changes these days, so I don't see any point in waiting).

There's one non-x86 change to fix a bug in processing "check" entries in
unittests.cfg files.  The majority of the x86 changes revolve around nSVM, PMU,
and emulator tests.

[*] https://lore.kernel.org/all/20230622211440.2595272-1-seanjc@google.com

The following changes since commit e8f8554f810821e37f05112a46ae9775a029b5d1:

  Makefile: Move -no-pie from CFLAGS into LDFLAGS (2023-08-22 11:26:00 +0200)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.09.01

for you to fetch changes up to d4fba74a42d222d2cfdde65351fac3531a1d6f5c:

  nVMX: Fix the noncanonical HOST_RIP testcase (2023-09-01 15:58:19 -0700)

----------------------------------------------------------------
x86 fixes, cleanups, and new testcases, and a few generic changes

 - Fix a bug in runtime.bash that caused it to mishandle "check" strings with
   multiple entries, e.g. a test that depends on multiple module params
 - Make the PMU tests depend on vPMU support being enabled in KVM
 - Fix PMU's forced emulation test on CPUs with full-width writes
 - Add a PMU testcase for measuring TSX transactional cycles
 - Nested SVM testcase for virtual NMIs
 - Move a pile of code to ASM_TRY() and "safe" helpers
 - Set up the guest stack in the LBRV tests so that the tests don't fail if the
   compiler decides to generate function calls in guest code
 - Ignore the "mispredict" flag in nSVM's LBRV tests to fix false failures
 - Clean up usage of helpers that disable interrupts, e.g. stop inserting
   unnecessary nops
 - Add helpers to dedup code for programming the APIC timer
 - Fix a variety of bugs in nVMX testcases related to being a 64-bit host

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

Sean Christopherson (21):
      nSVM: Add helper to report fatal errors in guest
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
      nVMX: Test CR4.PCIDE can be set for 64-bit host iff PCID is supported
      nVMX: Assert CR4.PAE is set when testing 64-bit host
      nVMX: Assert that the test is configured for 64-bit mode
      nVMX: Rename vmlaunch_succeeds() to vmlaunch()
      nVMX: Shuffle test_host_addr_size() tests to "restore" CR4 and RIP
      nVMX: Drop testcase that falsely claims to verify vmcs.HOST_RIP[63:32]
      nVMX: Fix the noncanonical HOST_RIP testcase

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
 x86/vmx_tests.c           | 170 +++++++++---------
 x86/xsave.c               |  31 +---
 39 files changed, 779 insertions(+), 628 deletions(-)
 delete mode 100644 x86/types.h
