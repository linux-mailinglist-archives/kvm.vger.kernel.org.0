Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77866308CB
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiKSBw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiKSBwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:52:41 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1567EC4B59
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:54 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id r10-20020a17090a1bca00b002137a500398so3823249pjr.5
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CjK5nD/uvnQk7qUQi9oIboYcWNk4lZcV0pG+jDjHbYw=;
        b=sO/BixX+Fxa6IYPQU8TkdF+XFQ44C4ZySQ2iwNGf4nj3I51S8QIRUibkPiKNqU6bw1
         j4PlnepiO1Ad8v/zZSnMeIBI68hxaFqyJGMZebX4cy3Jv14uXBvY/oT0aik++6OQL6oN
         DbLgAWDsPzUK72v+4dKMHKRTS+Pj0wR02zmTyQNbwMmm5J9cue1G73b6Acb3Oy+6Rqq7
         SFCX3tIjVDK5Bkgwj3xiOgKx932eMjN+X5AA0/Lbv6Dl4c1cRTcxk/wdcfGn/cUpN1uD
         EJ0BOyIS/RA9GP99cIy1ORxMCIBlL+dVVmi0pQd37KDIkkhww3/YCplg0uN9lfWxW1qn
         tETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CjK5nD/uvnQk7qUQi9oIboYcWNk4lZcV0pG+jDjHbYw=;
        b=Vv1wixzcr/Rg1wkGibMglH/6TExiwYaZGwyqRz1nONmP3RgCQdTf5ieFI/wynOfRiR
         HJuzN4JYxQA6nTjTXz33lRy7oMdX9SYtfNfKhMZ30toaYktAh0qOGGzqMe5x768m9iVJ
         YdijtyZ1zyqModUdE52nn5r86BeNE1RqjzeGuYBh0xYP/dbTnEM94oB/PuCFCOJrHcH6
         IOl9iah6ap8sEbJweWPU79PgHzQUb6vq4qogRK6RvfYRVzNpkBVG15hcQHatAGrfx9wn
         q9Y1UNRwpGpzMJFZs8eWeQFLmUKYd7eX4KpV/YTSajsuT4IzVdY7AEGylA/liP/AUeY/
         02oQ==
X-Gm-Message-State: ANoB5pnJJeVp54n7xA91iIDoA6eOu362qFZ66a7aqCWDK/jLffQbU6CR
        5ZD8KfIgyCg8bdYXLXafaGKKO1pxtoA=
X-Google-Smtp-Source: AA0mqf40VxY3bniB1w/5m0fnfOQyqSksKugX3b7aeyvG44COkqlBU1UDui2GOB4g4JxSgT+nQap4mhTD/UM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:31c4:0:b0:56e:989d:7410 with SMTP id
 x187-20020a6231c4000000b0056e989d7410mr10648162pfx.1.1668821693609; Fri, 18
 Nov 2022 17:34:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 19 Nov 2022 01:34:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-1-seanjc@google.com>
Subject: [PATCH 0/9] tools: Make {clear,set}_bit() atomic for reals
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For obvious reasons I'd like to route the this through Paolo's tree.
In theory, taking just patch 5 through tip would work, but creating a
topic branch seems like the way to go, though maybe I'm being overly
paranoid.  The current tip/perf/core doesn't have any conflicts, nor does
it have new set_bit() or clear_bit() users.

 
Code sitting in kvm/queue for 6.2 adds functionality that relies on
clear_bit() being an atomic operation.  Unfortunately, despite being
implemented in atomic.h (among other strong hits that they should be
atomic), clear_bit() and set_bit() aren't actually atomic (and of course
I realized this _just_ after everything got queued up).

Move current tools/ users of clear_bit() and set_bit() to the
double-underscore versions (which tools/ already provides and documents
as being non-atomic), and then implement clear_bit() and set_bit() as
actual atomics to fix the KVM selftests bug.

Perf and KVM are the only affected users.  NVDIMM also has test code
in tools/, but that builds against the kernel proper.  The KVM code is
well tested and fully audited.  The perf code is lightly tested; if I
understand the build system, it's probably not even fully compile tested.

Patches 1 and 2 are completely unrelated and are fixes for patches
sitting in kvm/queue.  Paolo, they can be squashed if you want to rewrite
history.

Patch 3 fixes a hilarious collision in a KVM ARM selftest that will arise
when clear_bit() is converted to an atomic.

Patch 4 changes clear_bit() and set_bit() to take an "unsigned long"
instead of an "int" so that patches 5-6 aren't accompanied by functional
changes.  I.e. if something in perf is somehow relying on "bit" being a
signed int, failures will bisect to patch 4 and not to the
supposed-to-be-a-nop conversion to __clear_bit() and __set_bit().

Patch 5-9 switch perf+KVM and complete the conversion.

Applies on:
  
  git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue

Sean Christopherson (9):
  KVM: selftests: Add rdmsr_from_l2() implementation in Hyper-V eVMCS
    test
  KVM: selftests: Remove unused "vcpu" param to fix build error
  KVM: arm64: selftests: Enable single-step without a "full" ucall()
  tools: Take @bit as an "unsigned long" in {clear,set}_bit() helpers
  perf tools: Use dedicated non-atomic clear/set bit helpers
  KVM: selftests: Use non-atomic clear/set bit helpers in KVM tests
  tools: Drop conflicting non-atomic test_and_{clear,set}_bit() helpers
  tools: Drop "atomic_" prefix from atomic test_and_set_bit()
  tools: KVM: selftests: Convert clear/set_bit() to actual atomics

 tools/arch/x86/include/asm/atomic.h           |  6 +++-
 tools/include/asm-generic/atomic-gcc.h        | 13 ++++++-
 tools/include/asm-generic/bitops/atomic.h     | 15 ++++----
 tools/include/linux/bitmap.h                  | 34 -------------------
 tools/perf/bench/find-bit-bench.c             |  2 +-
 tools/perf/builtin-c2c.c                      |  6 ++--
 tools/perf/builtin-kwork.c                    |  6 ++--
 tools/perf/builtin-record.c                   |  6 ++--
 tools/perf/builtin-sched.c                    |  2 +-
 tools/perf/tests/bitmap.c                     |  2 +-
 tools/perf/tests/mem2node.c                   |  2 +-
 tools/perf/util/affinity.c                    |  4 +--
 tools/perf/util/header.c                      |  8 ++---
 tools/perf/util/mmap.c                        |  6 ++--
 tools/perf/util/pmu.c                         |  2 +-
 .../util/scripting-engines/trace-event-perl.c |  2 +-
 .../scripting-engines/trace-event-python.c    |  2 +-
 tools/perf/util/session.c                     |  2 +-
 tools/perf/util/svghelper.c                   |  2 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  2 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 21 ++++++------
 tools/testing/selftests/kvm/dirty_log_test.c  | 34 +++++++++----------
 .../selftests/kvm/include/ucall_common.h      |  8 +++++
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../selftests/kvm/x86_64/hyperv_evmcs.c       | 13 +++++--
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  4 +--
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
 27 files changed, 102 insertions(+), 106 deletions(-)


base-commit: 3321eef4acb51c303f0598d8a8493ca58528a054
-- 
2.38.1.584.g0f3c55d4c2-goog

