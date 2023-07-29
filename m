Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6221A7679A8
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjG2Agu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjG2Ags (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:36:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65D130E4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583a89cccf6so26730397b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591006; x=1691195806;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMhJ/b6DMkuq/YdDrUWNaUZgSpR6tSiB89ISkM72Wx4=;
        b=uDNZSukByS7JyZ2jTEcrBQl7mGqhWoKqA2jPxWizvz2EyIAtNwjBDsbWnq8K25aP1c
         aGUNlsQCf/llPt5k93kDpL4/X2KOWZMToFa5soFdm8SQZ80FiVSihf9oTl/ob06d4uLB
         A89y28pB2flFbHcOhZSaDKEr1iY46y9zNb3+YdGFthAy7fQZVnSH2+uJlM3jA3U9b+s0
         1lob8zXM5sLoRCYLPUaqo5Y8s5wf+iEZDOMb/VHGGR5MKtEIbQJv8IwQ6aUQjSQXD4nL
         iyyyuFW0dkdEnlSBWkk1bEMBBgfS5s9+l9tIhsWOiBjr/xL04hP/43Ge/C3IBQpzoNAN
         hyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591006; x=1691195806;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMhJ/b6DMkuq/YdDrUWNaUZgSpR6tSiB89ISkM72Wx4=;
        b=DDxOVW3i1knvq9KKpliYy0gx/eDCDLmrpcwUh5QLuFX9Hgp2r06zi6nGNPQu5kOkRX
         RJb2R15kcMsSsmN7RyWtsu/o8gLuE0EwlXcwlCq10zqh80e16Si4IFrIgqZwNKSOq4mG
         fZSs8D+dUTopGvTXx19UEv3lakTpdnbNiApjio9LnJfcCnRyHC2FHfj/b/pJlSItyZBs
         4Ic9vvIgDjzlsxtUMjScHJLkgHR8THNXxHYT9T+8+9RqsurPOU7Zl4Z9p9d6iz0xjPFt
         HR5YPlnqrYLkZaM7loFoxWYdaQxFsIVZqoAsLm4Lh805iidLJ1T1sZWbp6TM7CkEUMFv
         v5FA==
X-Gm-Message-State: ABy/qLbZIZheSY6fkXAfYkAjwyoLczC/h9m2w2iN2UjWC5FGTTWPDVEs
        VgrIop3pzT4JG4kNFnIZeL7E/lh7iDo=
X-Google-Smtp-Source: APBJJlF8MZMONjBAnx6gWcIkUk+d8DyxD4xCa+6q0yvO/BGd+aR/kU76AQtPV98ljgxWdHS1cmKtERBcZkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:19c2:0:b0:d0d:1563:58f2 with SMTP id
 185-20020a2519c2000000b00d0d156358f2mr17145ybz.2.1690591006063; Fri, 28 Jul
 2023 17:36:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-1-seanjc@google.com>
Subject: [PATCH v4 00/34] KVM: selftests: Guest printf and asserts overhaul
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
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

This is effectively v4 of Aaron's series to add printf capabilities to
the guest[*].  I also pulled in Thomas' patch to rename ASSERT_EQ() to
TEST_ASSERT_EQ(), mainly so that we can decide on a common output format
for both host and guest asserts in a single series, but also so that all
these basically treewide patches are contained in a single series.

Note, Aaron did all of the heavy lifting, I just mopped up.  The core code
is pretty much unchanged from Aaron's v3, v4 massages the assert code a
bit and converts all the tests.

I initially did the conversion in one big patch (the flag is ugly), but
after hitting a nasty bug (see "Add a shameful hack to preserve/clobber
GPRs across ucall") that occurred purely due to the compiler using
registers differently, I decided splitting it up was probably for the best
(even though I still think it probably wasn't worth the effort).

Other maintainers, I want to get this into 6.6, hell or high water.  The
ability to use proper asserts in the guest is super nice, and given how
much selftests code is written via CTRL-C + CTRL-V, the sooner we switch
over the better.

My thought is to apply this whole thing to kvm-x86/selftests early next
week, and then create a tag to make that part of branch immutable.  That
would allow other architectures to pull the code into their trees, e.g.
if an arch is gaining a big selftest or something.

Apologies for not giving advance warning, I was originally thinking we
could leisurely convert to the printf-based asserts, but then realized
that we would probably never get rid of the old crud if we tried that
approach.

Any objections, or better ideas?

Thanks!

Oh, and tested on Intel, AMD, and whatever flavor of ARM we have.  Compile
tested on s390 and RISC-V.

[*] https://lore.kernel.org/all/20230607224520.4164598-1-aaronlewis@google.com

Aaron Lewis (5):
  KVM: selftests: Add strnlen() to the string overrides
  KVM: selftests: Add guest_snprintf() to KVM selftests
  KVM: selftests: Add additional pages to the guest to accommodate ucall
  KVM: selftests: Add string formatting options to ucall
  KVM: selftests: Add a selftest for guest prints and formatted asserts

Sean Christopherson (28):
  KVM: selftests: Make TEST_ASSERT_EQ() output look like normal
    TEST_ASSERT()
  KVM: selftests: Add a shameful hack to preserve/clobber GPRs across
    ucall
  KVM: selftests: Add formatted guest assert support in ucall framework
  KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
  KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSERT
  KVM: selftests: Convert ARM's hypercalls test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert ARM's page fault test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert ARM's vGIC IRQ test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert the memslot performance test to printf guest
    asserts
  KVM: selftests: Convert s390's memop test to printf style GUEST_ASSERT
  KVM: selftests: Convert s390's tprot test to printf style GUEST_ASSERT
  KVM: selftests: Convert set_memory_region_test to printf-based
    GUEST_ASSERT
  KVM: selftests: Convert steal_time test to printf style GUEST_ASSERT
  KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSERT
  KVM: selftests: Convert the Hyper-V extended hypercalls test to printf
    asserts
  KVM: selftests: Convert the Hyper-V feature test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert x86's KVM paravirt test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest
    asserts
  KVM: selftests: Convert x86's nested exceptions test to printf guest
    asserts
  KVM: selftests: Convert x86's set BSP ID test to printf style guest
    asserts
  KVM: selftests: Convert the nSVM software interrupt test to printf
    guest asserts
  KVM: selftests: Convert x86's TSC MSRs test to use printf guest
    asserts
  KVM: selftests: Convert the x86 userspace I/O test to printf guest
    assert
  KVM: selftests: Convert VMX's PMU capabilities test to printf guest
    asserts
  KVM: selftests: Convert x86's XCR0 test to use printf-based guest
    asserts
  KVM: selftests: Rip out old, param-based guest assert macros
  KVM: selftests: Print out guest RIP on unhandled exception
  KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers

Thomas Huth (1):
  KVM: selftests: Rename the ASSERT_EQ macro

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   8 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  22 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   8 +-
 .../selftests/kvm/aarch64/hypercalls.c        |  20 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |  17 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   3 +-
 .../testing/selftests/kvm/guest_print_test.c  | 221 +++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  12 +-
 .../testing/selftests/kvm/include/test_util.h |  18 +-
 .../selftests/kvm/include/ucall_common.h      |  97 +++---
 .../testing/selftests/kvm/lib/guest_sprintf.c | 307 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   6 +-
 .../selftests/kvm/lib/string_override.c       |   9 +
 .../testing/selftests/kvm/lib/ucall_common.c  |  44 +++
 .../selftests/kvm/lib/x86_64/processor.c      |  18 +-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  32 +-
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |   4 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c |  62 ++--
 tools/testing/selftests/kvm/s390x/memop.c     |  13 +-
 tools/testing/selftests/kvm/s390x/tprot.c     |  11 +-
 .../selftests/kvm/set_memory_region_test.c    |  21 +-
 tools/testing/selftests/kvm/steal_time.c      |  20 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  12 +-
 .../x86_64/dirty_log_page_splitting_test.c    |  18 +-
 .../x86_64/exit_on_emulation_failure_test.c   |   2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |   3 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  29 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   8 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c |  35 +-
 .../kvm/x86_64/nested_exceptions_test.c       |  16 +-
 .../kvm/x86_64/recalc_apic_map_test.c         |   6 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   6 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  22 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  34 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |  10 +-
 .../vmx_exception_with_invalid_guest_state.c  |   2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  31 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   |   8 +-
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  29 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  20 +-
 42 files changed, 938 insertions(+), 331 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

